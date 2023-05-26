import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/widgets/custom_button.dart';
import 'add_anouncement.dart';
import 'add_course.dart';
import '../widgets/classroom_post.dart';

class 
EtudiantBody extends StatefulWidget {
  
EtudiantBody({this.posts, this.id});
  List<dynamic>? posts;
  String? id;
  String? desc;
  

 
  @override
  State<
EtudiantBody> createState() => _EtudiantBodyState();
}

class _EtudiantBodyState extends State<
EtudiantBody> {
  String? nomComplet;
  String? nomPrefesseur;
  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Classes')
          .where('id', isEqualTo: widget.id)
          .get();
      var classes = await snapshot.docs.map((doc) => doc.data()).toList();

      var posts = await <Map<String, dynamic>>[];
      for (var classData in classes) {
        var classPosts = await classData['posts'] as List<dynamic>;
        posts.addAll(classPosts.cast<Map<String, dynamic>>());
      }

      return await posts;
    } catch (error) {
      print('Error retrieving posts: $error');
      return [];
    }
  }

  Future<void> getNomPrenom() async {
      var CurrentUserId = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid).id;
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(CurrentUserId)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      String nom =await data['nom'];
      String prenom = await data['prenom'];
      setState(() {
        nomComplet = "$nom $prenom";
        print("le nom complet es $nomComplet");
      });
    }
  }
Future<void> getProfesseurName() async {

    var snapshot = await FirebaseFirestore.instance
        .collection("Classes")
        .where('is', isEqualTo: widget.id)
        .get();
if (snapshot.docs.length >= 0) {
   nomPrefesseur = await snapshot.docs[0].data()['nom'];
  print('Field value: $nomPrefesseur');
}

  }

  void initState() {
    getProfesseurName();
    getNomPrenom();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    getPosts();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text("Les publications"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.call,
                    color: kGreenColor,
                  )),
            )
          ],
        ),
        
     body:  FutureBuilder(
   future: getPosts(),
       builder: (context, snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
       }

        if (snapshot.hasError) {
         return Text('Error: ${snapshot.error}');
         }

         if (snapshot.hasData)  {
           List<Map<String, dynamic>> posts  =
                snapshot.data as List<Map<String, dynamic>>;

          return ListView.builder(
          itemCount: posts.length,
             itemBuilder: (context, index) {
            final post = posts[index];
           final nomCours = post['nomCours'] as String;
            final description = post['description'] as String;
            final urlAttach = post['urlAttach'] as String;

           return ClassroomPostWidget(authorName: nomPrefesseur!, postTitle: nomCours, commentCount: 0,description: description,urlAttach: urlAttach,);
        },
     );
    }

    return Text('No posts available.');
   },
)
    );
  }
}

// class PostWidget extends StatelessWidget {
//   final String authorName;
//   final String description;

//   const PostWidget({required this.authorName, required this.description});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(authorName),
//       subtitle: Text(description),
//     );
//   }
// }

// class PostsList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getPosts(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         if (snapshot.hasData) {
//           List<Map<String, dynamic>> posts =
//               snapshot.data as List<Map<String, dynamic>>;

//           return ListView.builder(
//             itemCount: posts.length,
//             itemBuilder: (context, index) {
//               final post = posts[index];
//               final description = post['description'] as String;

//               return ClassroomPostWidget(authorName: , postTitle: postTitle, commentCount: commentCount);
//             },
//           );
//         }

//         return Text('No posts available.');
//       },
//     );
//   }

//   Future<List<Map<String, dynamic>>> getPosts() async {
//     try {
//       var snapshot =
//           await FirebaseFirestore.instance.collection('Classes').get();
//       var classes = snapshot.docs.map((doc) => doc.data()).toList();

//       var posts = <Map<String, dynamic>>[];
//       for (var classData in classes) {
//         var classPosts = classData['posts'] as List<dynamic>;
//         posts.addAll(classPosts.cast<Map<String, dynamic>>());
//       }

//       return posts;
//     } catch (error) {
//       print('Error retrieving posts: $error');
//       return [];
//     }
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(title: Text('Posts List')),
//       body: PostsList(),
//     ),
//   ));
// }
