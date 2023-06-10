import 'package:flutter/material.dart';
import 'package:pnotes/constants/routes.dart';
import 'package:pnotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Column(
        children: [
          const Text("email sent Please verify your email"),
          TextButton(
              onPressed: () async {
                final user = AuthService.firebase().sendEmailVerification();
              },
              child: const Text("didn't recieve? Resend Email")),
          TextButton(
              onPressed: () async {
                await AuthService.firebase().signOut();
      Navigator.of(context).pushNamedAndRemoveUntil(
        registerRoute,
            (route) => false,
      );
              },
              child: const Text("Sign Out"))
        ],
      ),
    );
  }
}
