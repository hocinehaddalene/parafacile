import 'package:flutter/material.dart';

import 'classroomcontent.dart';

class ClassroomItem extends StatelessWidget {
  ClassroomItem();

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return  ClassroomContent();
        }));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 4,bottom: 4),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color.fromARGB(255, 47, 146, 136)),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Text(
                  "note.title!",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                subtitle: Text(
                  "note.subtitle!",
                  style: TextStyle(color: Color.fromRGBO(80, 80, 80, 1)),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Text(
                "Professeur",
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}