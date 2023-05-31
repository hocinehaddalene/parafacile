import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/widgets/custom_button.dart';
import 'package:parafacile/widgets/custom_text_field.dart';

class Admin extends StatefulWidget {
  Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final TextEditingController cleController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? cle;
  bool? exist;
  Map<String, dynamic>? data;
  Future<void> getClef(String? val) async {
    await for (var snapshot in FirebaseFirestore.instance
        .collection("clé")
        .where("cle", isEqualTo: cle)
        .snapshots()) {
      for (var message in snapshot.docs) {
        if (message.data().isNotEmpty) {
          setState(() {
            exist = true;
          });
        } else if (message.data().isEmpty) {
          setState(() {
            exist = false;
            print("the value dont $exist");
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text("Admin"),
        leading: const Icon(Icons.admin_panel_settings),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Veuillez inserez les clef des utilisateur pour faire l'authentification",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Card(
                elevation: 8,
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Vous devez saisir une clé unique qui ne se répete pas et doit etre partager uniquement avec un seul utlisateur",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: CustomTextField(
                  labelText: "Saisair la clé",
                  icon: Icons.key_off_outlined,
                  controller: cleController,
                  onChange: (val) {
                    setState(() {
                      cle = val;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              CustomButton(
                  title: "Ajouter clé",
                  textColor: kBackgroundColor,
                  backgroundColor: kGreenColor,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FirebaseFirestore.instance
                          .collection("clé")
                          .where('clé', isEqualTo: cle)
                          .get()
                          .then((QuerySnapshot snapshot) {
                        if (snapshot.docs.isNotEmpty) {
                          print('Value exists in the collection.');
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  backgroundColor:
                                      Color.fromARGB(255, 255, 0, 0),
                                  content: Text("la valeur existe déja")));
                          // ...
                        } else {
                           FirebaseFirestore.instance
                              .collection("clé")
                              .doc()
                              .set({'clé': cle, 'compte': "libre"});
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Color.fromARGB(255, 23, 187, 138),
                            content: Text("clé ajouter avec succés"),
                          ));
                          cleController.clear();

                        }
                      });
                    }
                  })
            ],
          ))
        ],
      ),
    );
  }
}
