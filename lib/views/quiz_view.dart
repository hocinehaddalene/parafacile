import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/views/home.dart';
import 'package:parafacile/views/score_show.dart';

class QuizView extends StatelessWidget {
  QuizView({this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(fontFamily: 'Inter', useMaterial3: true),
      home: QuizScreen(title: title),
    );
  }
}

class QuizScreen extends StatefulWidget {
  QuizScreen({this.title});
  final String? title;

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  late Timer _timer;
  int _timeRemaining = 15;
  List<String> _shuffledChoices = [];
  String? nomComplet;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
    getNomPrenom();
  }

  Future<void> getNomPrenom() async {
    var CurrentUserId = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .id;

    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(CurrentUserId)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      String nom = await data['nom'];
      String prenom = await data['prenom'];

      setState(() {
        nomComplet = "$nom $prenom";
        print("le nom complet es $nomComplet");
      });
    }
  }

  void fetchQuestions() async {
    final QuerySnapshot snapshot = await _db
        .collection('quizz')
        .doc(widget.title)
        .collection('questions')
        .get();
    setState(() {
      _questions =
          snapshot.docs.map((doc) => Question.fromSnapshot(doc)).toList();

      _shuffledChoices = _questions[_currentQuestionIndex].shuffledChoices;
    });
  }

  void startTimer() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(()  {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer.cancel();
          // Move to the next question or end the quiz
          if (_currentQuestionIndex < _questions.length - 1) {
            _currentQuestionIndex++;
            _timeRemaining = 15; // Reset timer for the next question
            _shuffledChoices = _questions[_currentQuestionIndex]
                .shuffledChoices; // Update shuffled choices
            startTimer();
          }  else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ScoreShow(
          score: _score,
          nomComplet: nomComplet,
        );
      }));
      final snapshot =  _db
          .collection('quizz')
          .doc(widget.title)
          .collection('notes')
          .doc()
          .set({"etudiant": nomComplet, "note": _score, "ajouter" : Timestamp.now()});
    }
  
        }
      });
    });
  }

  void handleAnswer(String answer) async {
    final currentQuestion = _questions[_currentQuestionIndex];
    if (answer == currentQuestion.answer) {
      setState(() {
        _score++;
      });
    }
    // Move to the next question or end the quiz
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _timeRemaining = 15; // Reset timer for the next question
      _shuffledChoices = _questions[_currentQuestionIndex]
          .shuffledChoices; // Update shuffled choices
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ScoreShow(
          score: _score,
          nomComplet: nomComplet,
        );
      }));
      final snapshot = await _db
          .collection('quizz')
          .doc(widget.title)
          .collection('notes')
          .doc()
          .set({"etudiant": nomComplet, "note": _score, "ajouter" : Timestamp.now()});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    late final currentQuestion = _questions[_currentQuestionIndex];

    List<ElevatedButton?> allQuestions = [
      ElevatedButton(
        onPressed: () => handleAnswer(_shuffledChoices[0]),
        child: Text(_shuffledChoices[0]),
      ),
      ElevatedButton(
        onPressed: () => handleAnswer(_shuffledChoices[1]),
        child: Text(_shuffledChoices[1]),
      ),
      ElevatedButton(
        onPressed: () => handleAnswer(_shuffledChoices[2]),
        child: Text(_shuffledChoices[2]),
      ),
      ElevatedButton(
        onPressed: () => handleAnswer(_shuffledChoices[3]),
        child: Text(_shuffledChoices[3]),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              'Time: $_timeRemaining',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: allQuestions.length,
                itemBuilder: (context, int index) {
                  return allQuestions[index];
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: $_score',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  final String question;
  final Map<String, dynamic> choices;
  final String answer;

  Question({
    required this.question,
    required this.choices,
    required this.answer,
  });

  factory Question.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Question(
      question: data['question'] ?? '',
      choices: Map<String, dynamic>.from(data['choices'] ?? {}),
      answer: data["choices"]['correctAnswer'] ?? '',
    );
  }

  List<String> get shuffledChoices {
    final List<String> choicesList = [
      choices["correctAnswer"],
      choices["wrongAnswer1"],
      choices["wrongAnswer2"],
      choices["wrongAnswer3"],
    ];
    choicesList.shuffle();
    return choicesList;
  }
}
