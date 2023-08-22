import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes/extensions/list/filter.dart';
import 'package:notes/services/auth/crud/crud_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class NotesService {
  Database? _db;

  List<DatabaseNote> _notes = [];

  DatabaseUser? _user;

  // A Singleton is a design pattern often used in software development when
  // a system needs to coordinate actions across a system and restricts instantiation
  // of a class to a single object providing a global point of access.
  // It's used when exactly one object is needed to coordinate actions across the system
  // In Flutter, you can create a Singleton by defining a static variable
  // in your class as the single instance, and by making the class constructor private.
  // This ensures that the class is instantiated only once
  // The _shared variable is declared as a static final variable,
  // which means it can be accessed from anywhere in the code
  // it is just a private initializer of this class
  // The Singleton class cannot be instantiated outside the file where it is defined
  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  // In summary, this code creates a Singleton instance of the NotesService
  // class and initializes a broadcast StreamController that emits a
  // list of DatabaseNote objects whenever a listener starts listening to the stream
  factory NotesService() => _shared;
  // This factory constructor ensures that any attempts to create a
  // new instance of the NotesService class will return the existing instance

  // everything going to be read from the outside through this
  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Stream<List<DatabaseNote>> get allNotes =>
      _notesStreamController.stream.filter((note) {
        final currentUser = _user;
        if (currentUser != null) {
          return note.userId == currentUser.id;
        } else {
          throw UserShouldBeSetBeforeReadingAllNotes();
        }
      });

  Future<DatabaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    try {
      final user = await getUser(email: email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on CouldNotFindUserException {
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
      return createdUser;
    } catch (e) {
      // this only allows you to basically put a breakpoint here if you want to debug your application,
      // it's kind of quiet a cheap way to debug your application
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // Create the user table
      await db.execute(createUserTable);
      // Create the note table
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      // empty
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      // Reset local database
      _db = null;
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    // db.delete() returns the number of rows that were deleted
    final deletedCount = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    // insert method helps insert a map of [values] into the
    // specified [table] and returns the id* of the last inserted row. it returns an int
    final userId = await db.insert(
      userTable,
      {
        emailColumn: email.toLowerCase(),
      },
    );
    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
      // The first row that was read from the user table , Remember we said a limit is 1
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Make sure owner exists in the database with correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }
    const text = "";
    // create the note
    final noteId = await db.insert(
      noteTable,
      {
        userIdCulomn: owner.id,
        textCulomn: text,
        isSyncedWithCloudColumn: 1,
      },
    );
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedwithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    } else {
      final countBefore = _notes.length;
      _notes.removeWhere((note) => note.id == id);
      if (_notes.length != countBefore) {
        _notesStreamController.add(_notes);
      }
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    // We're reseting the _notes , this make sure that our local cash is updated
    _notes = [];
    // Updating the stream controller , this make sure that the UI is updated
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      // We could see this pattern , we first update our local cash,
      _notes.add(note);
      // and then we reflect those changes to the outside world
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
    );
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    // make sure note exists
    await getNote(id: note.id);
    // update db
    final updateCount = await db.update(
      noteTable,
      {
        textCulomn: text,
        isSyncedWithCloudColumn: 0,
      },
      where: "id = ?",
      whereArgs: [note.id],
    );

    if (updateCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final updatedNote = await getNote(id: note.id);
      // remove the existing note
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;
  // The id and email properties of the DatabaseUser object are set using values from the map parameter.
  // The id property is set to the value of the idColumn key in the map,
  // which is cast to an integer using the as keyword.
  // The email property is set to the value of the emailColumn key in the map,
  // which is cast to a string using the as keyword

  @override
  String toString() => 'Person, ID = $id , Email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;
  // The equality operator
  // The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  // In Dart and Flutter, the covariant keyword is used to modify the behavior of
  // method parameters and return values in subclasses and implementations.
  // When we use the covariant keyword on a parameter or return value in a subclass or
  // implementation, we are telling Dart that it's okay to use a more specific type
  // than the one used in the superclass or interface

  @override
  int get hashCode => id.hashCode;
  // Hash codes must be the same for objects that are equal to each other according to [operator ==]
  // The hash code of an object should only change if the object changes in a way that affects equality
  // Objects that are not equal are allowed to have the same hash code.
  // It is even technically allowed that all instances have the same hash code,
  // but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap]
  // If a subclass overrides [hashCode], it should override the [operator ==] operator as well to maintain consistency.
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedwithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedwithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdCulomn] as int,
        text = map[textCulomn] as String,
        isSyncedwithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "note, ID = $id, User Id = $userId, Is synced with cloud? = $isSyncedwithCloud, Text = $text";

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = "notes.db";
// dbName is like a file name that we're gonna create
const noteTable = "note";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdCulomn = "user_id";
const textCulomn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const createUserTable = ''' 
      CREATE TABLE IF NOT EXISTS "user" (
	    "id"	INTEGER NOT NULL,
	    "email"	TEXT NOT NULL UNIQUE,
	    PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';
const createNoteTable = ''' 
      CREATE TABLE IF NOT EXISTS "note" (
	    "id"	INTEGER NOT NULL,
	    "user_id"	INTEGER NOT NULL,
	    "text"	TEXT,
	    "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	    FOREIGN KEY("user_id") REFERENCES "user"("id"),
	    PRIMARY KEY("id" AUTOINCREMENT)
      );
      ''';
