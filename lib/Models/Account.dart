import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Account extends ChangeNotifier {
  String name = "";
  String phone = "";
  String email = "";
  String password = "";

  bool isCreated = false;
  bool isLogin = false;
  late final UserCredential credential;

// Account({this.name="",this.phone = "",required this.email,required this.password}){
// }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    isLogin = false;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print(credential.user!.email);

      isLogin = true;
      return "Login Successful";

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
         return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
      }
    }

    return "Finished";
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

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    isCreated = false;
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
      isCreated = true;
      return 'Send verification email. Look for the verification email in your inbox and click the link in that email. A confirmation message will appear in your web browser.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return 'another error!.';
    }

    return 'finished';
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }


}
