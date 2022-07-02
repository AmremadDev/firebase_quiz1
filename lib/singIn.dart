import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_quiz1/Models/Account.dart';
import 'package:firebase_quiz1/homepage.dart';
import 'package:firebase_quiz1/singup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.red,
                  Colors.redAccent,
                ])),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            // logo Area
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                  height: 70,
                  width: 170,
                  child: Image(image: AssetImage("images/loginLogo.png"))),
            ),

            // form Area
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Form(
                  key: formstate,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildEmailField(context),
                      _buildPasswordField(context),
                      _buildCreateButton(context),
                    ],
                  )),
            ),
            _builtOtherBody(context)
          ],
        ),
      ),
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
              SizedBox(
                width: 60,
                height: 60,
                child: Card(
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset("images/google.png"),
                    color: Color.fromARGB(255, 63, 50, 50),
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: Card(
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset("images/facebook.png"),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                height: 60,
                child: Card(
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset("images/twitter.png"),
                    // iconSize: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUp()));
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

  TextFormField _buildEmailField(BuildContext context) {
    Account model = Provider.of(context);
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value!);

          if (emailValid == true)
            return null;
          else
            return "your email isn't correct. Please try again.";
        },
        onChanged: (value) => model.email = value,
        onSaved: (value) => model.email = value!,
        style: TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.yellow),
          labelStyle: TextStyle(color: Colors.white, fontSize: 18),
          labelText: "Email",
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ));
  }

  Widget _buildPasswordField(BuildContext context) {
    Account model = Provider.of(context);
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
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
            },
            onSaved: (value) => model.password = value!,
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
            ));
      },
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    Account model = Provider.of(context);
    return Padding(
        padding: EdgeInsets.only(top: 40),
        child: MaterialButton(
          color: Colors.red[800],
          height: 50,
          textColor: Colors.white,
          onPressed: () async {
            FormState? formdata = formstate.currentState!;

            if (formdata.validate() == true) {
              formstate.currentState!.save();

              String? result = await context
                  .read<Account>()
                  .signInWithEmailAndPassword(model.email, model.password);

              if (context.read<Account>().isLogin == true) {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              } else {
                dialogbox(context, 'Error', result!, type: DialogType.ERROR);
              }
            }
          },
          child: Text(
            "LOGIN",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ));
  }
}

Future<dynamic> dialogbox(
    BuildContext context, String title, String description,
    {DialogType type = DialogType.SUCCES}) {
  return AwesomeDialog(
    context: context,
    barrierColor: Colors.transparent,
    // autoDismiss: true,
    dialogType: type,

    // btnOkColor: Colors.redAccent,
    btnOkText: "OK",
    headerAnimationLoop: true,

    animType: AnimType.TOPSLIDE,

    title: title,
    titleTextStyle: const TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    desc: description,
    descTextStyle: const TextStyle(color: Colors.white, fontSize: 16),

    buttonsTextStyle: const TextStyle(color: Colors.white, fontSize: 18),

    // padding: EdgeInsets.all(20),
    dialogBackgroundColor: Colors.red[300],

    // onDissmissCallback: (type) => {print("onDissmissCallback => ${type.name}")},
    btnOkOnPress: () {},
  ).show();
}
