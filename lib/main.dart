

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pnotes/views/login_view.dart';
import 'package:pnotes/views/register_view.dart';

import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        title: 'Pnotes',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const HomePage(),
      )
  );
}
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder(
          future:   Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context , snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.done:
               final user = FirebaseAuth.instance.currentUser;
                if(user?.emailVerified??false){
                  return const Text("Done");
                }
                else if(user == null){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> LoginView(),
                    ),
                  );
                }
                else{
                  Navigator.of(context).push
                    (MaterialPageRoute(builder: (context)=> VerifyEmailView(),
                  ),
                  );
                }
               return const Text("Done");
              default :
                return const Text('...loading');
            }
          }
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const  Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text("Please verify your email"),
          TextButton(onPressed: () {
            final user = FirebaseAuth.instance.currentUser;
            user?.sendEmailVerification();
          }, child: const Text('Resend Email'))
        ],
      ),
    );
  }
}







