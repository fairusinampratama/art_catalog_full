import 'package:art_catalog_full/view/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAOgVQDJeLdqb3Iv8xJwYQbjEgXD0TqCOA",
      appId: "1:538802214221:android:396fec5e693e91ff0c9304",
      messagingSenderId: "538802214221",
      projectId: "artcatalog-a626c",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat-Bold'),
      home: const SignIn(),
    );
  }
}
