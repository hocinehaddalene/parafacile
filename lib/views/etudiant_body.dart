import 'package:flutter/material.dart';
import 'package:parafacile/views/classroom_post.dart';

import 'classroom_item.dart';

class EtudiantBody extends StatefulWidget {
  const EtudiantBody({super.key});

  @override
  State<EtudiantBody> createState() => _EtudiantBodyState();
}

class _EtudiantBodyState extends State<EtudiantBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Etudiant Classroom")),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, itemCount) => ClassroomPostWidget(
            authorName: "professeur",
            commentCount: 3,
            postTitle: "Cours de chapitre 3 avec explication ",
            description: "but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
          ),
          ),
        );
  }
}
