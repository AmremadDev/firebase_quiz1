import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_quiz1/singup.dart';
import 'package:flutter/material.dart';

class SingIn extends StatefulWidget {
  @override
  State<SingIn> createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
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
      padding: const EdgeInsets.only(top: 150),
      child: Form(
          key: formstate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: ((value) {
                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value!);
                    return (emailValid == true)
                        ? null
                        : "your email isn't correct. Please try again.";
                  }),
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
                        (_obscureText == true)
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
                        signInWithEmailAndPassword(_email,_password);
                      } else
                        print("data isn't valid");
                    },
                    child: Text(
                      "LOGIN",
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> SignUp()));
              },
              child: Text(
                "No account yet? Create on",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      print(credential.user!.email);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
