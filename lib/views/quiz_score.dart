import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizScore extends StatefulWidget {
  QuizScore({required this.title});
  String? title;

  @override
  State<QuizScore> createState() => _QuizScoreState();
}

class _QuizScoreState extends State<QuizScore> {
  Future<List<Map<String, dynamic>>> getScores() async {
    var scores = await FirebaseFirestore.instance
        .collection("quizz")
        .doc("${widget.title}")
        .collection("notes")
        .get();

    List<Map<String, dynamic>> scoreList = [];

    for (var score in scores.docs) {
      scoreList.add(score.data());
    }

    return scoreList;
  }

  @override
  void initState() {
    getScores();
    // TODO: implement initState
    super.initState();
    getScores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz Score"),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Voici les Scores des Etudiants dans le quiz : ",style: TextStyle(fontSize: 23),),
          )),
          FutureBuilder(
            future: getScores(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.hasData) {
                List<Map<String, dynamic>> scores = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      final etudiant = scores[index]['etudiant'];
                      final score = scores[index]['note'];
                      final date = scores[index]['ajouter'];
                      DateTime dateTime = date.toDate();
                      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
                      return Expanded(
                        child: Container(
                          color: Colors.deepPurpleAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                title: Text("Score: $score"),
                                subtitle: Text("$etudiant"),
                                trailing: Text("$formattedDate"),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return const Text('No posts available.');
            },
          ),
        ],
      ),
    );
  }
}
