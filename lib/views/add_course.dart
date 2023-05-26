import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/views/professeur_body.dart';

import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddCourse extends StatefulWidget {
  AddCourse({required this.id});
  late String id;

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  String? courseName;
  String? courseDescription;
  String? urlAttach;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  // late Map<String,dynamic> posts =  {
  //   'nomCours' : courseName,
  //   'description' : courseDescription
  // };
  Future<void> addPostToClass(String id) async {
    try {
      // Get the document reference based on the 'id' field
      var snapshot = await FirebaseFirestore.instance
          .collection('Classes')
          .where('id', isEqualTo: widget.id)
          .limit(1)
          .get();

      var classRef = await snapshot.docs.first.reference;

      // Update the 'posts' array field
      await classRef.update({
        'posts': FieldValue.arrayUnion([
          {
            'nomCours': courseName,
            'description': courseDescription,
            'urlAttach': urlAttach
          }
        ])
      });

      print('Post added to class successfully!');
    } catch (error) {
      print('Error adding post to class: $error');
    }
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController courseNameController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future uploadData() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    urlAttach = await urlDownload;
    print(urlAttach);
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
          title: const Text("Ajouter un cours"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                  CustomTextField(
                    labelText: "Nom du cours",
                    controller: courseNameController,
                    onChange: (val) {
                      courseName = val;
                    },
                  ),
                  CustomTextField(
                    controller: DescriptionController,
                    onChange: (val) {
                      courseDescription = val;
                    },
                    labelText: "Description du cours",
                    maxLines: 4,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    backgroundColor: const Color.fromARGB(255, 229, 235, 179),
                    onPressed: selectFile,
                    title: 'Choisir fichier',
                    textColor: kBackgroundColor,
                  ),
                  Card(
                    elevation: 5,
                    child: Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          pickedFile?.name ?? "aucun fichier a été attaché",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CustomButton(
                      title: "Ajouter Cour",
                      textColor: kBackgroundColor,
                      backgroundColor: kGreenColor,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try  {
                            const CircularProgressIndicator(value: 20,);
                            await uploadData();
                            addPostToClass(widget.id);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                              return ProfesseurBody(id: widget.id,);
                              }));

                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("il ya un erreur "),
                            ));
                          }
                        }
                      })
                ],
              ),
            ),
          ),
        ));
  }
}
