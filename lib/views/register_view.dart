import 'package:flutter/material.dart';
import 'package:pnotes/constants/routes.dart';
import 'package:pnotes/services/auth/auth_exceptions.dart';
import 'package:pnotes/services/auth/auth_service.dart';
import 'package:pnotes/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _email = TextEditingController();
    _password = TextEditingController();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'enter your email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'enter your password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final credential = await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                final user = await AuthService.firebase().currentUser;
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  verifyemailRoute,
                  (route) => false,
                );
              }
              on WeakPasswordAuthException{
                await showErrorDialog(context, 'password should be strong like you');
              }
              on EmailAlreadyInUseAuthException{
                await showErrorDialog(context, "harami ek email se kitne account banaega");
              }
              on InvalidEmailAuthException{
                await showErrorDialog(
                    context, "email to sahi daal le bhai ya phele wala mt daal");
              }
              on GenericAuthException{
                await showErrorDialog(context, "Failed to Register");
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
