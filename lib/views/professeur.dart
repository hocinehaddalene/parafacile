import 'package:flutter/material.dart';
import 'package:parafacile/views/classroom_item.dart';
import 'package:parafacile/views/create_classe.dart';

class Professeur extends StatefulWidget {
  const Professeur({super.key});

  @override
  State<Professeur> createState() => _ProfesseurState();
}

class _ProfesseurState extends State<Professeur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Professeur"),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: Colors.white,
        child: Icon(Icons.add,color: Colors.black,size: 29,),
        
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreateClasse();
          }
          ));
        }),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ClassroomItem();
        },
        itemCount: 11,
      ),
    );
  }
}
