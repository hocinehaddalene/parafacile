import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/views/admin.dart';
import 'package:parafacile/views/professeur.dart';
import 'package:parafacile/widgets/custom_button.dart';

import '../widgets/custom_text_field.dart';
import 'etudiant.dart';

class Login extends StatefulWidget {
  Login({super.key});
    bool isLoading = false;


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(title: const Text("Identifier")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Veuillez saisair votre E-mail et mot de passe",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    CustomTextField(
                        controller: emailController, labelText: "E-mail"),
                    CustomTextField(
                      maxLines: 1,
                      controller: passwordController,
                      labelText: "Mot de passe",
                      obscureText: true,
                      icon: Icons.lock,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomButton(
                          title: "Acceder",
                          textColor: kBackgroundColor,
                          backgroundColor: const Color(0xff8EE5DB),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                             
                                setState(() {
                              widget.isLoading = true;
                                  signIn(
                                emailController.text, passwordController.text);
                                }); 
                            }
                          }),
                            
                    )
                  ]))),
       
           Visibility(child:  Padding(
             padding: const EdgeInsets.all(8.0),
             child: const CircularProgressIndicator(),),
           visible: widget.isLoading,)
        ],
        
      ),
    );
  }
  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Professeur") {
           Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  const Professeur(),
          ),
        );
        }else if ((documentSnapshot.get('role') == "Etudiant") ){
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  const Etudiant(),
          ),
        );
        }
        else if ((documentSnapshot.get('role') == "Admin") ){
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  Admin(),
          ),
        );
        }
        
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
       
      } on FirebaseAuthException catch (t) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(t.message!),
        ));
      }
    }
  }
}

