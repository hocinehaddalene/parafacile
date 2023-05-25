
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

  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final String? fieldValue = await snapshot.get('niveau');
    final String? fieldSpecialiteValue = await snapshot.get('specialite');
    specialite = fieldSpecialiteValue;
    niveau = fieldValue;

    return await FirebaseFirestore.instance
        .collection('Classes')
        .where('niveau', isEqualTo: niveau).where('specialite', isEqualTo: specialite)
        .get();
  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Etudiant"),
        ),
        body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("has error with data");
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
              return const Text("loading....");
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