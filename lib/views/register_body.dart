import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/widgets/custom_button.dart';
import 'package:parafacile/widgets/custom_text_field.dart';

import 'login.dart';

class RegisterBody extends StatefulWidget {
  RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  @override
  final _auth = FirebaseAuth.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController secondName = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? dropdownValue = "Etudiant";
  String? role;
  String? selectedNiveau;
  String? Selectedspecialite;
  String? niveaudropdownValue = "1ere anne";
  String? specialitedropdownValue = "ISP";

  void onChanged(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        dropdownValue = selectedvalue;
        role = dropdownValue;
        print(dropdownValue);
      });
    } else {}
  }

  void niveauOnChanged(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        niveaudropdownValue = selectedvalue;
        selectedNiveau = niveaudropdownValue;
        print(niveaudropdownValue);
      });
    } else {}
  }

  void specialiteOnChanged(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        specialitedropdownValue = selectedvalue;
        Selectedspecialite = specialitedropdownValue;
        print(specialitedropdownValue);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
      child: Column(
        children: [
          const Center(
              child: Text(
            "Créer votre compte ",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
          )),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextField(controller: firstName, labelText: "Nom"),
                  CustomTextField(controller: secondName, labelText: "Prenom"),
                  CustomTextField(
                      controller: emailController, labelText: "E-mail"),
                  CustomTextField(
                    controller: passwordController,
                    labelText: "Mot de passe",
                    obscureText: true,
                    maxLines: 1,
                    icon: Icons.lock,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Je suis un ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w200),
                      ),
                      Expanded(
                        child: DropdownButton(
                          items: const [
                            DropdownMenuItem(
                              value: "Etudiant",
                              child: Text("Etudiant"),
                            ),
                            DropdownMenuItem(
                              value: "Professeur",
                              child: Text("Professeur"),
                            ),
                          ],
                          value: dropdownValue,
                          onChanged: onChanged,
                          iconSize: 42,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xff8EE5DB)),
                          isExpanded: true,
                          iconEnabledColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: dropdownValue == "Etudiant" ? true : false,
                    child: Column(children: [
                      Row(
                        children: [
                          const Text(
                            'Mon niveua est  ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w200),
                          ),
                          Expanded(
                            child: DropdownButton(
                              items: const [
                                DropdownMenuItem(
                                  value: "1ere anne",
                                  child: Text("1ere anne"),
                                ),
                                DropdownMenuItem(
                                  value: "2emme anne",
                                  child: Text("2emme anne"),
                                ),
                                DropdownMenuItem(
                                  value: "3ere anne",
                                  child: Text("3ere anne"),
                                ),
                              ],
                              value: niveaudropdownValue,
                              onChanged: niveauOnChanged,
                              iconSize: 42,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff8EE5DB)),
                              isExpanded: true,
                              iconEnabledColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Ma spécialité est ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w200),
                          ),
                          Expanded(
                            child: DropdownButton(
                              items: const [
                                DropdownMenuItem(
                                  value: "ISP",
                                  child: Text("ISP"),
                                ),
                                DropdownMenuItem(
                                  value: "LSP",
                                  child: Text("LSP"),
                                ),
                                DropdownMenuItem(
                                  value: "MIM",
                                  child: Text("MIM"),
                                ),
                                DropdownMenuItem(
                                  value: "SF",
                                  child: Text("SF"),
                                ),
                                DropdownMenuItem(
                                  value: "AMAR",
                                  child: Text("AMAR"),
                                ),
                              ],
                              value: specialitedropdownValue,
                              onChanged: specialiteOnChanged,
                              iconSize: 42,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xff8EE5DB)),
                              isExpanded: true,
                              iconEnabledColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  CustomButton(
                      title: "Valider",
                      textColor: kBackgroundColor,
                      backgroundColor: const Color(0xff8EE5DB),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {


                          signUp(
                              emailController.text,
                              passwordController.text,
                              secondName.text,
                              firstName.text,
                              dropdownValue!,
                              selectedNiveau ?? "",
                              Selectedspecialite ?? "");
                        }
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void signUp(String email, String password, String nom, String prenom,
      String role, String niveau, String specialite) async {
    const CircularProgressIndicator();
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {
                  postDetailsToFirestore(
                      email, role, nom, prenom, niveau, specialite)
                });
      } on FirebaseAuthException catch (t) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(t.message!),
        ));
      }
    }
  }

  postDetailsToFirestore(String email, String role, String nom, String prenom,
      String niveau, String specialite) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'email': emailController.text,
      'role': dropdownValue,
      'nom': secondName.text,
      'prenom': firstName.text,
      'niveau': selectedNiveau,
      'specialite': Selectedspecialite
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
