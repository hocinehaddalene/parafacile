import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/views/post_details.dart';

class ClassroomPostWidget extends StatefulWidget {
  final String authorName;
  final String postTitle;
  int? commentCount;
  String? description;
  String? urlAttach;
  String fileName;
  List<dynamic>? posts;
  int? index;
  late String? id;
  Map<String, dynamic>? post;
  Function refreshPosts;

  ClassroomPostWidget({
    required this.authorName,
    required this.postTitle,
    this.commentCount,
    this.description,
    required this.urlAttach,
    required this.fileName,
    this.post,
    this.posts,
    this.id,
    this.index,
    required this.refreshPosts
    
  });

  @override
  State<ClassroomPostWidget> createState() => _ClassroomPostWidgetState();
}

class _ClassroomPostWidgetState extends State<ClassroomPostWidget> {

  Future<void> deletePost(String id) async {
    try {
      // Get the document reference based on the 'id' field
      var snapshot = await FirebaseFirestore.instance
          .collection('Classes')
          .where('id', isEqualTo: widget.id)
          .get();

      var classRef = await snapshot.docs.first.reference;
      // Update the 'posts' array field
      classRef.update({
        'posts' : FieldValue.arrayRemove([widget.posts![widget.index!]])
      });
        
      print('Post removed from successfully!');
    } catch (error) {
      print('Error removing post: $error');
    }
  }    
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.delete_forever_sharp),
          title: const Text('Confirmation'),
          content: const SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Êtes-vous sûr de vouloir supprimer cette classe ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () async{
 setState(() {
                  deletePost(widget.id!);

 });
   await Future.delayed(Duration(milliseconds: 400)); // Add a small delay here

                widget.refreshPosts();
                   Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _showMyDialog,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PostDetails(id: widget.id,
            post: Post(
                title: widget.postTitle,
                description: widget.description!,
                attachments: <Attachment>[
                  Attachment(
                      name: widget.fileName,
                      url: widget.urlAttach!)
                ],
                comments: [],),
          );
        }));
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.postTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39.0),
              child: Text(
                'Professeur: ${widget.authorName}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${widget.description}'),
            ),
            Container(
              color: kGreenColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.comment,
                      color: kBackgroundColor,
                    ),
                    const SizedBox(width: 5),
                    Text('${widget.commentCount} Comments', style: TextStyle(color: kBackgroundColor),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
