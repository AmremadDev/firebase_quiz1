import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_quiz1/Models/Account.dart';
import 'package:firebase_quiz1/singIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(MaterialApp(home: HomePage()));
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
  return Scaffold(
    appBar: AppBar(
    title: const Text('HomePage'),
    ),
    body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text("Welcome"),
          Text("${FirebaseAuth.instance.currentUser!.email}",style: Theme.of(context).textTheme.headline6,),
          ElevatedButton(onPressed: (){
            context.read<Account>().logout();

            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SignIn()));

          }, child: Text("Signout")),
        ]),
      ),
    ),
  );
  }
}

