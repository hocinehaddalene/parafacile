import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/views/chat_screen.dart';
import 'package:parafacile/views/add_quiz.dart';
import 'package:parafacile/views/quiz_score.dart';
import 'package:parafacile/views/quiz_view.dart';
import 'package:parafacile/widgets/custom_button.dart';
import 'add_anouncement.dart';
import 'add_course.dart';
import '../widgets/classroom_post.dart';

class ProfesseurBody extends StatefulWidget {
  ProfesseurBody({this.posts, this.id, this.commentText, this.title});
  List<dynamic>? posts;
  String? title;
  String? id;
  String? desc;
  String? commentText;

  @override
  State<ProfesseurBody> createState() => _ProfesseurBodyState();
}

class _ProfesseurBodyState extends State<ProfesseurBody> {
  String? nomComplet;
  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Classes')
          .where('id', isEqualTo: widget.id)
          .get();
      var classes = await snapshot.docs.map((doc) => doc.data()).toList();

      var posts = await <Map<String, dynamic>>[];
      for (var classData in classes) {
        var classPosts = await classData['posts'] as List<dynamic>;
        posts.addAll(classPosts.cast<Map<String, dynamic>>());
      }

      return await posts;
    } catch (error) {
      print('Error retrieving posts: $error');
      return [];
    }
  }

  var CurrentUserId = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .id;
  Future<void> getNomPrenom() async {
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

  @override
  void initState() {

    getNomPrenom();
    print(widget.title);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPosts();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  void refreshPosts() {
  setState(() {});
  }
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Les publications"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return ChatScreen(
                        id: widget.id,
                      );
                    }));
                  },
                  icon: Icon(
                    Icons.message_rounded,
                    color: kGreenColor,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return QuizView(title: widget.title);
                    }));
                  },
                  icon: Icon(
                    Icons.quiz_rounded,
                    color: kGreenColor,
                  )),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 29,
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: 150,
                      color: kBackgroundColor,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              height: 60,
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AddCourse(
                                      id: widget.id!,
                                    );
                                  }));
                                },
                                child: const Text(
                                  "Ajouter un cours",
                                  style: TextStyle(fontSize: 16),
                                ),
                              )),
                          SizedBox(
                              height: 60,
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AddQuiz(
                                      title: widget.title,
                                    );
                                  }));
                                },
                                child: const Text(
                                  "Ajouter une QUIZZ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ))
                        ],
                      ),
                    );
                  });
            }),
        body: Column(
          
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return QuizScore(
                    title: widget.title,
                  );
                }));
              },
              child: Container(
                height: 85,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 68, 0, 255),
                    Color.fromARGB(255, 33, 1, 70),
                  ],
                )),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Vous pouvez ici consultez les résultat de votre quiz",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: getPosts().asStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    List<dynamic> posts =
                        snapshot.data as List<Map<String, dynamic>>;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final nomCours = post['nomCours'] as String;
                        final description = post['description'] as String;
                        final urlAttach = post['urlAttach'] as String;
                        final name = post['filename'] as String;

                        return ClassroomPostWidget(
                          authorName: nomComplet!,
                          postTitle: nomCours,
                          commentCount: 0,
                          description: description,
                          urlAttach: urlAttach,
                          id: widget.id!,
                          fileName: name,
                          posts: posts,
                          post: post,
                          index: index,
                          refreshPosts: refreshPosts
                        );
                      },
                    );
                  }
                  return const Text('No posts available.');
                },
              ),
            )
          ],
        ));
  }
}
