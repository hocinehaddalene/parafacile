import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/models/classroom.dart';
import 'package:parafacile/views/classroom_item.dart';
import 'package:parafacile/views/create_classe.dart';

class Professeur extends StatefulWidget {
  const Professeur({super.key});

  @override
  State<Professeur> createState() => _ProfesseurState();
}

class _ProfesseurState extends State<Professeur> {
  List ClassroomItems = [];
  var CurrentUserId = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .id;
  late var ClassesProfesseur = FirebaseFirestore.instance
      .collection('Classes')
      .where('idProfesseur', isEqualTo: CurrentUserId);

  getClasses() async {
    try {
      var responsebody = await ClassesProfesseur.get();
      responsebody.docs.forEach((element) {
        setState(() {
          ClassroomItems.add(element.data());
        });
      });
    } catch (e) {
      return e;
    }

    print(ClassroomItems);
  }

  @override
  void initState() {
    // TODO: implement initState
    getClasses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Espace Professeur"),
          actions: [
            IconButton(onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            }, icon:Icon(Icons.logout_outlined,),)
          ],
        ),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              color: Color.fromARGB(255, 219, 26, 26),
              size: 29,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CreateClasse();
              }));
            }),
        body: StreamBuilder(
            stream: ClassesProfesseur.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("has error with data");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {}
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs!.length,
                    itemBuilder: (context, i) {

                      return ClassroomItem(
                        title: "${snapshot.data?.docs[i].data()['className']}",
                        classDescription:
                            "${snapshot.data?.docs[i].data()['description']}",
                        posts: ["${snapshot.data?.docs[i].data()['posts']}"],
                        id: "${snapshot.data?.docs[i].data()['id']}",
                        NomProfesseur:  "${snapshot.data?.docs[i].data()['nom']}"  ,
                      );
                    });
              }
              return Text("loading....");
            }));
  }
}
// ListView.builder(
//             itemCount: ClassroomItems.length,
//             itemBuilder: (context,i) {

//              return ClassroomItem(title: "${ClassroomItems[i]['className']}", classDescription: "${ClassroomItems[i]['description']}");
//             } ,
//     )