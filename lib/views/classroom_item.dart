// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:parafacile/views/etudiant_body.dart';
import 'package:parafacile/views/professeur_body.dart';

class ClassroomItem extends StatefulWidget {
  ClassroomItem(
      {Key? key,
      this.title,
      this.classDescription,
      this.posts,
      this.id,
      this.NomProfesseur,
      this.isProf})
      : super(key: key);
  final String? title;
  final String? classDescription;
  List<dynamic>? posts;
  final String? id;
  final String? NomProfesseur;
  final bool? isProf;

  @override
  State<ClassroomItem> createState() => _ClassroomItemState();
}

class _ClassroomItemState extends State<ClassroomItem> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_forever_sharp),
          title: const Text('Confirmation'),
          content: const SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Êtes-vous sûr de vouloir supprimer cette classe ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("Classes")
                    .doc("${widget.title}")
                    .delete();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
              color: const Color.fromARGB(255, 47, 146, 136)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                trailing: Visibility(
                  visible: widget.isProf!,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showMyDialog();
                    },
                  ),
                ),
                title: Text(
                  widget.title ?? "pas de titre",
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                subtitle: Text(
                  widget.classDescription ?? "pas de description",
                  style: const TextStyle(color: Color.fromRGBO(80, 80, 80, 1)),
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                widget.NomProfesseur!.toUpperCase() ?? "ProfesseurNom",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  route() {
    print("the widget is tapped");

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
              builder: (context) => ProfesseurBody(
                posts: widget.posts,
                id: widget.id,
                title: widget.title,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EtudiantBody(
                posts: widget.posts,
                id: widget.id!,
                title: widget.title,
              ),
            ),
          );
        }
      } else {
        debugPrint('Document does not exist on the database');
      }
    });
  }
}
