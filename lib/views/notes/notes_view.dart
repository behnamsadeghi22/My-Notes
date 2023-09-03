// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:notes/constants/routes.dart';
import 'package:notes/enums/menu_action.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
import 'package:notes/services/cloud/cloud_note.dart';
import 'package:notes/services/cloud/firebase_cloud_storage.dart';
import 'package:notes/utilities/dialogs/logout_dialog.dart';
import 'package:notes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Notes",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                createOrUpdateNoteRoute,
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  // "child" is what the user see and the "value" is what you as a developer see
                  value: MenuAction.logout,
                  child: Text(
                    "Log out",
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

// In Flutter, AsyncSnapshot is a generic class that is used to represent the result of
// an asynchronous operation. It is commonly used with FutureBuilder and StreamBuilder
// widgets to handle asynchronous data loading and update the UI accordingly

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text("Log out"),
//         content: const Text(
//           "Are you sure you want to log out?",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//             child: const Text(
//               "cancel",
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             child: const Text(
//               "logout",
//             ),
//           ),
//         ],
//       );
//     },
//   ).then((value) => value ?? false);
// }
