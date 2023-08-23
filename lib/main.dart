// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/notes/create_update_note_view.dart';
import 'package:notes/views/notes/notes_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // In Flutter, the WidgetsFlutterBinding class is responsible for connecting the framework to
  // the underlying platform and providing the necessary bindings for rendering and handling user input.
  // The ensureInitialized() method of WidgetsFlutterBinding is used to initialize the
  // binding and its dependencies before the application starts running.
  // This method is typically called at the beginning of the main() method of the application.
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // 1.When the FutureBuilder is built, it starts executing the Future that was passed to it.
      // 2.While the Future is executing, the FutureBuilder displays a progress indicator or a placeholder widget.
      // 3.When the Future completes with a result, the builder function is called with the result value as input.
      // 4.The builder function then returns a widget tree based on the result value.
      // 5.The FutureBuilder then rebuilds with the widget tree returned by the builder function, replacing the progress indicator or placeholder widget.
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
