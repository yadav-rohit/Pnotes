
import 'package:flutter/material.dart';
import 'package:pnotes/constants/routes.dart';
import 'package:pnotes/services/auth/auth_service.dart';
import 'package:pnotes/views/login_view.dart';
import 'package:pnotes/views/register_view.dart';
import 'package:pnotes/views/notes_view.dart';
import 'package:pnotes/views/verifyemail_view.dart';

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
        routes: {
          loginRoute: (context) => const LoginView(),
          registerRoute : (context) => const RegisterView(),
          notesRoute : (context) => const NotesView(),
          verifyemailRoute : (context) => const VerifyEmailView(),
        },
      )
  );
}
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future:  AuthService.firebase().initialize(),
          builder: (context , snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.done:
               final user = AuthService.firebase().currentUser;
               if(user!=null){
                 if(user.isEmailVerified){
                    return const NotesView();
                 }
                 else{
                   Navigator.of(context).pushNamedAndRemoveUntil(
                       verifyemailRoute, (route) => false);
                 }
               }
                else{
                  return const LoginView();
               }
                return const Text("Done");
              default :
                return const CircularProgressIndicator();
            }
          }
      );
  }
}









