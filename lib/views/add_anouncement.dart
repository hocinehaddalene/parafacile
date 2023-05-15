import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddAnouncement extends StatefulWidget {
  AddAnouncement({super.key});

  @override
  State<AddAnouncement> createState() => _AddAnouncementState();
}

class _AddAnouncementState extends State<AddAnouncement> {
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
          title: const Text("Ajouter un annoucement"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  const Text(
                    "Saisair les informations pour Ajouter une announcement",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomTextField(labelText: "Nom de announcement"),
                  CustomTextField(
                    labelText: "Description de announcement",
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
                  TextFormField(
                    style: TextStyle(color: kGreenColor),
                      controller: dateInput,
                      //editing controller of this TextField
                      decoration: const InputDecoration(
                        
                          icon: Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ), //icon of text field
                          labelText: "Ajouter dernier délai",
                          labelStyle: TextStyle(color: Colors.white)
                           //label text of field
                          ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023,5),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));
                            setState(() {  
                            });
          
                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dateInput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      }),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                      title: "Ajouter Anouncement",
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
