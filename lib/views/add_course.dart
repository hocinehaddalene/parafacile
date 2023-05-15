import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddCourse extends StatefulWidget {
  AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  String? niveaudropdownValue = "1ere anne";

  String? selectedNiveau;

  String? specialitedropdownValue = "ISP";

  String? Selectedspecialite;

  TextEditingController dateInput = TextEditingController();

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
          title: const Text("Ajouter un cours"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  const Text(
                    "Saisair les informations pour Ajouter un cours",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomTextField(labelText: "Nom du cours"),
                  CustomTextField(
                    labelText: "Description du cours",
                    maxLines: 4,
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
                  CustomTextField(
                    labelText: "Ajouter un attachement",
                    prefixIcon: Icon(Icons.attach_file),
                    prefixIconColor: Colors.white,
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                      title: "Ajouter Cour",
                      textColor: kBackgroundColor,
                      backgroundColor: kGreenColor,
                      onPressed: () {})
                ],
              ),
            ),
          ),
        ));
  }
}