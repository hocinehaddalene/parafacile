// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:parafacile/views/etudiant_body.dart';
import 'package:parafacile/views/professeur_body.dart';

class ClassroomItem extends StatefulWidget {
  ClassroomItem({required this.title, required this.classDescription});
   String? title;
   String? classDescription;


  @override
  State<ClassroomItem> createState() => _ClassroomItemState();
}

class _ClassroomItemState extends State<ClassroomItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        route();
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color.fromARGB(255, 47, 146, 136)),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Text(
                  widget.title ?? "pas de titre",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                subtitle: Text(
                  widget.classDescription?? "pas de description",
                  style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1)),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                "Professeur",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }

  route() {
    print("teh widjet is tapped");

    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Professeur") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfesseurBody(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EtudiantBody(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }
}
