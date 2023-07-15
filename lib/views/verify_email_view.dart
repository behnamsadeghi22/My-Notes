// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Verify Email",
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "We've sent you an email verification, Please open it to verify your account",
            ),
            const Text(
              "If you haven't received a verification email yet, press the button below",
            ),
            TextButton(
              onPressed: () async {
                AuthSrvice.firebase().sendEmailVerification();
              },
              child: const Text(
                "Send email verification",
              ),
            ),
            TextButton(
              onPressed: () async {
                await AuthSrvice.firebase().logOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text(
                "Restart",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
