

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/views/pdf_viewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Attachment {
  String name;
  String url;

  Attachment({required this.name, required this.url});
}

class Post {
  String title;
  String description;
  List<Attachment> attachments;
  List<String> comments;

  Post({
    required this.title,
    required this.description,
    required this.attachments,
    required this.comments,
  });
}

class PostDetails extends StatefulWidget {
  Post post;
  String? newComment;
  late String? id;

  PostDetails({super.key, required this.post,required this.id, this.newComment});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  
  Future<void> addPostToClass() async {
    try {
      // Get the document reference based on the 'id' field
      var snapshot = await FirebaseFirestore.instance
          .collection('Classes')
          .where('id', isEqualTo: widget.id)
          .limit(1)
          .get();

      var classRef = await snapshot.docs.first.reference;

      // Update the 'posts' array field
      await classRef.update({
        'posts': FieldValue.arrayUnion([
          
          {
            
        'comments': FieldValue.arrayUnion([ {
          "text" : widget.newComment

        }])
            
          }
        ])
      });

      print('Post added to class successfully!');
    } catch (error) {
      print('Error adding post to class: $error');
    }
  }
  

  void _showAddCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            onChanged: (value) {
              widget.newComment = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your comment',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (widget.newComment!.isNotEmpty) {
                  widget.post.comments.add(widget.newComment!);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
  @override
  void initState() {
    addPostToClass();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Publication', style: TextStyle(color: Colors.white),),
          backgroundColor: kBackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    widget.post.title, 
                    style: const TextStyle(
                      fontSize: 29,
                      color: Color.fromARGB(255, 24, 187, 187),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Center(
                    child: Text(
                      widget.post.description,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              const Divider(),
              if (widget.post.attachments.isNotEmpty)
                Expanded(
                  child: Card(
                    elevation: 5,
                    
                    child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 39, 176, 123), Color.fromARGB(255, 0, 255, 170)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.4, 0.7],
                      tileMode: TileMode.repeated,
                    ),
                  ),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Attachments',
                            style: TextStyle(
                              fontSize: 23,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                              
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.post.attachments.length,
                              itemBuilder: (BuildContext context, int index) {
                                final attachment = widget.post.attachments[index];
                                return ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(attachment.name, style: TextStyle(color: Color.fromARGB(255, 68, 68, 68)),),
                                      )),
                                  ),
                                  leading: const Icon(Icons.attachment, color: Color.fromARGB(255, 7, 109, 168),),
                                  onTap: () {
                                      
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return pdfviewer(url: attachment.url);
                                    }));
                                      
                                      
                                      
                                      
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Comments (${widget.post.comments.length})',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.post.comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(widget.post.comments[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddCommentDialog(context),
          child: const Icon(Icons.comment),
        ),
      ),
    );
  }
}
