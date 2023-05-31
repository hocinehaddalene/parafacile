// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:parafacile/constants.dart';

class AddQuiz extends StatefulWidget {
  const AddQuiz({
    Key? key,
    this.title,
  }) : super(key: key);
  final String? title;

  @override
  _AddQuizState createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController correctAnswerController = TextEditingController();
  final TextEditingController wrongAnswer1Controller = TextEditingController();
  final TextEditingController wrongAnswer2Controller = TextEditingController();
  final TextEditingController wrongAnswer3Controller = TextEditingController();

  List<Map<String, dynamic>> questionsList = [];


  void addQuestion() {
    setState(() {
      final question = {
        'question': questionController.text,

        'choices' :  {
        'correctAnswer': correctAnswerController.text,
        'wrongAnswer1': wrongAnswer1Controller.text,
        'wrongAnswer2': wrongAnswer2Controller.text,
        'wrongAnswer3': wrongAnswer3Controller.text,
        }
        
      };

      questionsList.add(question);

      // Clear the form fields
      questionController.clear();
      correctAnswerController.clear();
      wrongAnswer1Controller.clear();
      wrongAnswer2Controller.clear();
      wrongAnswer3Controller.clear();
    });
  }

  void saveQuestionsToFirestore() {
    for (final question in questionsList) {
      FirebaseFirestore.instance
          .collection('quizz')
          .doc("${widget.title}")
          .collection("questions")
          .add(question);
    }
    // Clear the questions list
    setState(() {
      questionsList.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_rounded),
            iconSize: 34,
            color: kGreenColor,
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Veuillez ajouter des questions pour que l'étudiant repondre:", style: TextStyle(color: Colors.black,fontSize: 20,),),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: questionsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final question = questionsList[index];
                    return Flexible(
                      child: Column(
                        children: [
                          Text('Question ${index + 1}:'),
                          TextFormField(
                            initialValue: question['question'],
                            decoration:
                                const InputDecoration(labelText: 'Question'),
                            onChanged: (value) {
                              setState(() {
                                question['question'] = value;
                              });
                            },
                            validator: (value) {
                              if (value == "") {
                                return 'Veulliez saisair une question';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: question["choices"]['correctAnswer'],
                            decoration: const InputDecoration(
                                labelText: 'La réponse juste'),
                            onChanged: (value) {
                              setState(() {
                                question["choices"]['correctAnswer'] = value;
                              });
                            },
                            validator: (value) {
                              if (value == "") {
                                return 'Veuillez saisir une une réponse juste ';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: question["choices"]['wrongAnswer1'],
                            decoration: const InputDecoration(
                                labelText: 'Fausse Réponse 1'),
                            onChanged: (value) {
                              setState(() {
                                question["choices"]['wrongAnswer1'] = value;
                              });
                            },
                            validator: (value) {
                              if (value == "") {
                                return 'Veuillez saisir une une fausse réponse 1';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: question["choices"]['wrongAnswer2'],
                            decoration: const InputDecoration(
                                labelText: 'Fausse Réponse 2'),
                            onChanged: (value) {
                              setState(() {
                                question["choices"]['wrongAnswer2'] = value;
                              });
                            },
                            validator: (value) {
                              if (value == "") {
                                return 'Veuillez saisir une une fausse réponse 2';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: question["choices"]['wrongAnswer3'],
                            decoration: const InputDecoration(
                                labelText:
                                    'Fausse réponse 3'),
                            onChanged: (value) {
                              setState(() {
                                question["choices"]['wrongAnswer3'] = value;
                              });
                            },
                            validator: (value) {
                              if (value == "") {
                                return 'Veuillez saisir une une fausse réponse 3';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addQuestion();
                        }
                      },
                      child: const Text('Ajouter une question'),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (questionsList.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content:
                                Text("Veuillez saisair les questions d'abord"),
                          ));
                        } else {
                          if (_formKey.currentState!.validate()) {
                            saveQuestionsToFirestore();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Les questions sont ajoutées"),
                            ));
                          }
                          else {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content:
                                Text("Veuillez saisair les questions d'abord"),
                          ));
                          }
                        }
                      },
                      child: const Text('Valider les questions'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
