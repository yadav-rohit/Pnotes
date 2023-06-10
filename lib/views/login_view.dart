import 'package:flutter/material.dart';
import 'package:pnotes/constants/routes.dart';
import 'package:pnotes/services/auth/auth_exceptions.dart';
import 'package:pnotes/services/auth/auth_service.dart';

import '../firebase_options.dart';
import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: Text("Login"),
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
                final credential = await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  await showErrorDialog(context, 'Please verify your email');
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyemailRoute,
                        (route) => false,
                  );
                  return;
                }
                else if(user?.isEmailVerified == true){
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,

                        (route) => false,
                  );
                }

              }
              on userNotFoundAuthException{
                await showErrorDialog(context, 'User Not Found with this email');
              }
              on  WrongPasswordAuthException{
                await showErrorDialog(context, "wrong credentials");
              }
              on GenericAuthException{
                await showErrorDialog(context, 'authentication error');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Register'))
        ],
      ),
    );
  }
}

