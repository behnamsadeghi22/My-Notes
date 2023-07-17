import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
      );
  // A factory constructor gives more flexibility to create an object.
  // Generative constructors only create an instance of the class.
  // But, the factory constructor can return an instance of the class or even subclass.
  // It is also used to return the cached instance of the class.

  // In Flutter, factory constructors are a way to create objects from a class
  // by providing custom logic for creating instances of that class.
  // A factory constructor is a special type of constructor that returns an instance of the class it belongs to,
  // but the object returned can be a different instance than the one that was created.
}
