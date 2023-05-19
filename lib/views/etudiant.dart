import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'classroom_item.dart';

class Etudiant extends StatefulWidget {
  const Etudiant({super.key});

  @override
  State<Etudiant> createState() => _EtudiantState();
}

class _EtudiantState extends State<Etudiant> {
  late String? niveau;
  late String? specialite;

  Future<String?> getNiveau() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final String? fieldValue = snapshot.get('niveau');
    niveau = fieldValue;
    print(niveau);
    return fieldValue;
  }

  Future<String?> getSpecialite() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final String? fieldValue = snapshot.get('specialite');
    specialite = fieldValue;
    print(specialite);
    return fieldValue;
  }

  late var ClassesCheck = FirebaseFirestore.instance
      .collection('Classes')
      .where('niveau', isEqualTo: niveau);

  @override
  void initState() {
    // TODO: implement initState
    getNiveau();
    getSpecialite();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Etudiant"),
        ),
        body: StreamBuilder(
            stream: ClassesCheck.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("has error with data");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      return ClassroomItem(
                          title:
                              "${snapshot.data?.docs[i].data()['className']}",
                          classDescription:
                              "${snapshot.data?.docs[i].data()['description']}");
                    });
              }
              return Text("loading....");
            }));
  }
}





















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'classroom_item.dart';

// class Etudiant extends StatefulWidget {
//   const Etudiant({super.key});

//   @override
//   State<Etudiant> createState() => _EtudiantState();
// }

// class _EtudiantState extends State<Etudiant> {
//   String? niveau;
//   String? specialite;

//    var ref = FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid).get();
      

//   late var niveauValue = ref.then((value) async {
    
//        niveau = await value.get('niveau');
   
//   });
//   late var specialiteValue = ref.then((value) async{
//     specialite =await value.get('specialite');

//   });

//   late var ClassesCheck = FirebaseFirestore.instance
//       .collection('Classes')
//       .where('niveau', isEqualTo: niveau);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(niveau!),
//         ),
//         body: StreamBuilder(
//             stream: ClassesCheck.snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Text("has error with data");
//               }

//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else {}
//               if (snapshot.hasData) {
//                 return ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, i) {
//                       return ClassroomItem(
//                           title:
//                               "${snapshot.data?.docs[i].data()['className']}",
//                           classDescription:
//                               "${snapshot.data?.docs[i].data()['description']}");
//                     });
//               }
//               return Text("loading....");
//             }));
//   }
// }
