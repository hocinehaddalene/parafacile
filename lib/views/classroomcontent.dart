import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/views/professeur_body.dart';

import 'etudiant_body.dart';

class ClassroomContent extends StatelessWidget {
   ClassroomContent ({super.key});
    bool isProfesseur = true;
  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Professeur") {
          isProfesseur = true;
        }else{
          isProfesseur = false;  
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Classroom content"),),
      body: isProfesseur==true ? ProfesseurBody(): EtudiantBody(),

    );
  }


}