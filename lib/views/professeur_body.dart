import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';

import 'add_anouncement.dart';
import 'add_course.dart';

class ProfesseurBody extends StatelessWidget {
  const ProfesseurBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: const Text("hocine"),
    );
  }
}
