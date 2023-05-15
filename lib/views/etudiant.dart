import 'package:flutter/material.dart';

class Etudiant extends StatefulWidget {
  const Etudiant({super.key});

  @override
  State<Etudiant> createState() => _EtudiantState();
}

class _EtudiantState extends State<Etudiant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Etudiant"),)
    );
  }
}