import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';

import 'add_anouncement.dart';
import 'add_course.dart';
import '../widgets/classroom_post.dart';

class ProfesseurBody extends StatelessWidget {
  const ProfesseurBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title:Text("Professeur"),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: () {}, icon: Icon(Icons.call,color: kGreenColor,)),
        )
      ],),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AddCourse();
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AddAnouncement();
                              }));
                              },
                              child: const Text(
                                "Ajouter une Anouncement",
                                style: TextStyle(fontSize: 16),
                              ),
                            ))
                      ],
                    ),
                  );
                });
          }),
           body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, itemCount) => ClassroomPostWidget(
            authorName: "professeur",
            commentCount: 3,
            postTitle: "Cours de chapitre 3 avec explication ",
            description: "the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
          ),
          ),
      
    );
  }
}
