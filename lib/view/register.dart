import 'package:art_catalog_full/view/home.dart';
import 'package:art_catalog_full/view/reusable_widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _ageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                children: <Widget>[
                  reusableTextField(
                    "First Name",
                    Icons.person,
                    false,
                    _firstNameTextController,
                  ),
                  const SizedBox(height: 30),
                  reusableTextField(
                    "Last Name",
                    Icons.account_circle,
                    false,
                    _lastNameTextController,
                  ),
                  const SizedBox(height: 30),
                  reusableTextField(
                    "Age",
                    Icons.cake,
                    false,
                    _ageTextController,
                  ),
                  const SizedBox(height: 30),
                  reusableTextField(
                    "Email",
                    Icons.email,
                    false,
                    _emailTextController,
                  ),
                  const SizedBox(height: 30),
                  reusableTextField(
                    "Password",
                    Icons.vpn_key,
                    true,
                    _passwordTextController,
                  ),
                  const SizedBox(height: 30),
                  reusableTextField(
                    "Confirm Password",
                    Icons.lock, // Use a different lock variant
                    true,
                    _confirmPasswordTextController,
                  ),
                  const SizedBox(height: 30),
                  singInSignUpButton(context, false, () {
                    signUp();
                  }),
                ],
              ),
            ),
          )),
    );
  }

  Future signUp() async {
    if (passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailTextController.text.trim(),
          password: _passwordTextController.text.trim(),
        );
        addUserDetails(
                _firstNameTextController.text.trim(),
                _lastNameTextController.text.trim(),
                _emailTextController.text.trim(),
                int.parse(_ageTextController.text.trim()))
            .then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage())));
      } catch (e) {
        print("Error during registration: $e");
        _showErrorToast("Error during registration: $e");
      }
    } else {
      print("Passwords do not match");
      _showErrorToast("Passwords do not match");
    }
  }

  Future addUserDetails(
      String firstName, String lastName, String email, int age) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'age': age,
    });
  }

  bool passwordConfirmed() {
    if (_passwordTextController.text.trim() ==
        _confirmPasswordTextController.text.trim()) {
      return true;
    } else {
      return false;
    }
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
