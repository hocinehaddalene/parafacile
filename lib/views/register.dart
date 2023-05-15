import 'package:flutter/material.dart';
import 'package:parafacile/views/register_body.dart';

import '../constants.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(title: const Text("Enregistrer")),
      body:SingleChildScrollView(child:  RegisterBody()),
    );
  }
}