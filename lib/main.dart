import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_quiz1/Models/Account.dart';
import 'package:firebase_quiz1/homepage.dart';
import 'package:firebase_quiz1/singIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => Account())),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      title: "Firebase Quiz-1",
      home: (FirebaseAuth.instance.currentUser == null )? SignIn() : HomePage(),
    ),
  ));
}
