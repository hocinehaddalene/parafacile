import 'package:flutter/material.dart';
import 'package:parafacile/views/etudiant_body.dart';

import 'classroom_item.dart';

class Etudiant extends StatefulWidget {
  const Etudiant({super.key});

  @override
  State<Etudiant> createState() => _EtudiantState();
}

class _EtudiantState extends State<Etudiant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Etudiant"),
      
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ClassroomItem();
        },
        itemCount: 11,
      ),
    );
  }
}