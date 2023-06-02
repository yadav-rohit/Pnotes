import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
      appBar: AppBar(title: const Text('Register'),),
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
          TextButton(onPressed: () async{
            final email = _email.text;
            final password = _password.text;
            try {
              final credential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
              print(credential);
            }on FirebaseAuthException
            catch(e){
              if(e.code== 'weak-password'){
                print("password should be strong like you");
              }
              else if(e.code== 'email-already-in-use'){
                print("harami ek email se kitne account banaega");
              }
              else if(e.code== 'invalid-email'){
                print("email to sahi daal le bhai");
              }
            }
          },
            child: const Text('Register'),),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                    (route) => false ,
            );
          }, child: Text('Login'),),
        ],
      ),
    );
  }
}
