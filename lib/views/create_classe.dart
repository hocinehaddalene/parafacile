import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/models/classroom.dart';
import 'package:parafacile/widgets/custom_button.dart';
import 'package:parafacile/widgets/custom_text_field.dart';

class CreateClasse extends StatefulWidget {
  CreateClasse({super.key});

  @override
  State<CreateClasse> createState() => _CreateClasseState();
}

class _CreateClasseState extends State<CreateClasse> {
  final formKey = GlobalKey<FormState>();

  TextEditingController classNameController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();


  var CurrentUserId = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid).id;
  String? className;
  String? classDescription;
  String? selectedNiveau;
  String? Selectedspecialite;
  String? niveaudropdownValue = "1ere anne";
  String? specialitedropdownValue = "ISP";

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
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text("Créer une classe"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text(
                  "Saisair les informations pour créer une classe",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 50,
                ),
                CustomTextField(
                  controller: classNameController,
                  labelText: "Nom du classe",
                  onChange: (val) {
                    setState(() {
                      className = val;
                    });
                  },
                ),
                CustomTextField(
                  controller: DescriptionController,
                  labelText: "Description",
                  maxLines: 4,
                  onChange: (val) {
                    setState(() {
                      classDescription = val;
                    });
                  },
                ),
                Row(
                  children: [
                    const Text(
                      'Le niveau d\'étude est :  ',
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
                            child: Text("2eme anne"),
                            value: "2emme anne",
                          ),
                          DropdownMenuItem(
                            child: Text("3ere anne"),
                            value: "3ere anne",
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
                      'la spécialité est : ',
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
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: kGreenColor),
                        isExpanded: true,
                        iconEnabledColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                CustomButton(
                    title: "Créer",
                    textColor: kBackgroundColor,
                    backgroundColor: kGreenColor,
                onPressed: () async {
                        if (formKey.currentState!.validate())  {
                          await Classroom().addClass(className, classDescription, selectedNiveau, Selectedspecialite,CurrentUserId);
                          Navigator.of(context).pop();
                        }
                      },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
