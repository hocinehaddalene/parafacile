import 'package:flutter/material.dart';
import 'package:parafacile/views/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
     WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(paraFacile());
}
class paraFacile extends StatelessWidget {
  paraFacile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Inter", useMaterial3: true),
      home: Home(),
    );
  }
}


