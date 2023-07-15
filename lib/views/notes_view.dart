// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Main UI",
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  if (shouldLogOut) {
                    AuthSrvice.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  // "child" is what the user see and the "value" is what you a developer see
                  value: MenuAction.logout,
                  child: Text(
                    "Log out",
                  ),
                )
              ];
            },
          ),
        ],
      ),
      body: const Text(
        "This is your notes",
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Log out"),
        content: const Text(
          "Are you sure you want to log out?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text(
              "cancel",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text(
              "logout",
            ),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}