import 'package:art_catalog_full/view/home.dart';
import 'package:art_catalog_full/view/register.dart';
import 'package:art_catalog_full/view/reusable_widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFFF0A500),
              Color(0xFFCF7500),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  children: <Widget>[
                    logoWidget("assets/icons/catalog.png"),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Email", Icons.person_outline,
                        false, _emailTextController),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outline,
                        true, _passwordTextController),
                    const SizedBox(
                      height: 30,
                    ),
                    singInSignUpButton(context, true, () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                        // Display error toast
                        _showErrorToast(error.toString());
                      });
                    }),
                    signUpOption()
                  ],
                ),
              ),
            )));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const register()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  void _showErrorToast(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(130, 255, 255, 255), // Light blue
      textColor: Colors.white,
      fontSize: 16.0,
      webShowClose: true, // Show close button on web // Web background gradient
      webPosition: "center",
    );
  }
}
