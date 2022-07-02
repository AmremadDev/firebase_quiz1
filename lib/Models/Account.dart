import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class Account extends ChangeNotifier {
  String name = "" ;
  String phone = "" ;
  String email ="" ;
  String password ="" ;


 late  final UserCredential  credential ;

// Account({this.name="",this.phone = "",required this.email,required this.password}){
// }


  void signInWithEmailAndPassword(String email, String password) async {
    try {
       credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(credential.user!.email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<bool> isExists(String email) async {
    print(email);
    try {
      List<String> methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.length > 0)
        return true;
      else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      //Create the account
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send Verification Code
      if (credential.user!.emailVerified == false) {
        User? user = FirebaseAuth.instance.currentUser!;
        await user.sendEmailVerification();
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
