import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:pnotes/constants/routes.dart';
import 'package:pnotes/enums/menu_action.dart';
import 'package:pnotes/services/auth/auth_service.dart';



class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}


class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton(onSelected: (value) async{
            switch(value){
              case MenuAction.logout:
                await  ShowLogoutDialog(context).then((value) async {
                  if(value){
                    await AuthService.firebase().signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                });
                break;
            }
            devtools.log(value.toString());
          },itemBuilder: (context) {
            return const [
              PopupMenuItem(value: MenuAction.logout,child: Text("Logout"),)
            ];
          },)]
        ,),
      body:  const Center(
        child:  Text("Notes"),

      ),
    );
  }
}


Future<bool> ShowLogoutDialog(BuildContext context) async {
  return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop(false);
            }, child: const Text("No")),
            TextButton(onPressed: () {
              Navigator.of(context).pop(true);
            }, child: const Text("Yes")),
          ],
        );
      }
  ).then((value) => value ?? false);
}
