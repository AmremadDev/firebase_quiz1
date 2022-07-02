import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_quiz1/singin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  String _name = "";
  String _phone = "";
  String _email = "";
  String _password = "";
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.red,
                  Colors.red[400]!,
                ])),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            _buildLogo(),
            _buildSingInForm(context),
            _builtOtherBody(context)
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
          height: 70,
          width: 170,
          child: Image(image: AssetImage("images/loginLogo.png"))),
    );
  }

  Widget _buildSingInForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Form(
          key: formstate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  cursorColor: Colors.white,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ((value) {
                    if (value!.length < 3) return "Must be greater than three";
                  }),
                  onSaved: (value) => _name = value!,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.yellow),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                    labelText: "Name",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  )),
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ((value) {
                    bool phoneValid =
                        RegExp(r"^(?:[+0]9)?[0-9]{11}$").hasMatch(value!);
                    return (phoneValid == true)
                        ? null
                        : "your phone isn't correct. Please try again.";
                  }),
                  onSaved: (value) => _phone = value!,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.yellow),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                    labelText: "Phone Number",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  )),
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ((value)
                    {

                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);
                    if (emailValid == true)  {


                        var respose =  isExists(_email);
                       if (respose == true)  return "this email is already exists";
                       else return null;

                      // isExists(_email).then((value) {
                      //   print(value);
                      //   return (value == true) ? null : "this email is already exists";
                      // });


                    } else
                      return "your email isn't correct. Please try again.";
                  }),

                  onChanged: (value) => _email = value,
                  onSaved: (value) => _email = value!,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.yellow),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                    labelText: "Email",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  )),
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ((value) {
                    RegExp regex = RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    } else {
                      if (!regex.hasMatch(value)) {
                        return 'Enter valid password';
                      } else {
                        return null;
                      }
                    }
                  }),
                  onSaved: (value) => _password = value!,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        (_obscureText == false)
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    errorStyle: TextStyle(color: Colors.yellow),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                    labelText: "Password",
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: MaterialButton(
                    color: Colors.red[800],
                    height: 50,
                    textColor: Colors.white,
                    onPressed: () {
                      FormState? formdata = formstate.currentState!;
                      if (formdata.validate() == true) {
                        formstate.currentState!.save();
                        createUserWithEmailAndPassword(_email, _password)
                            .then((result) {
                          if (result == true) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SingIn()));
                          } else {
                            print("Error");
                          }
                        });
                      } else
                        print("data isn't valid");
                    },
                    child: Text(
                      "CREATE ACCOUT",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _builtOtherBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              "Or sign up with",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 10,
                shadowColor: Colors.white,
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset("images/google.png"),
                  iconSize: 40,
                  color: Colors.white,
                ),
              ),
              Card(
                elevation: 10,
                shadowColor: Colors.white,
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset("images/facebook.png"),
                  iconSize: 40,
                  color: Colors.white,
                ),
              ),
              Card(
                elevation: 10,
                shadowColor: Colors.white,
                child: IconButton(
                  onPressed: () {},
                  icon: Image.asset("images/twitter.png"),
                  iconSize: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SingIn()));
              },
              child: Text(
                "Already a member? Login",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<bool> isExists(String email) async {
  print(email);
   try {
    List<String> methods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if(methods.length > 0) return true;
        else return false;
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
