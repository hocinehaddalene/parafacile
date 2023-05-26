import 'package:flutter/material.dart';
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
  String section;
  List<Attachment> attachments;
  List<String> comments;

  Post({
    required this.title,
    required this.description,
    required this.section,
    required this.attachments,
    required this.comments,
  });
}

class PostDetails extends StatefulWidget {
  Post post;

  PostDetails({super.key, required this.post});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  void _showAddCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newComment = '';

        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            onChanged: (value) {
              newComment = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your comment',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (newComment.isNotEmpty) {
                  widget.post.comments.add(newComment);
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
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Post Details'),
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Section: ${widget.post.section}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    widget.post.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Divider(),
              if (widget.post.attachments.isNotEmpty)
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Attachments',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.post.attachments.length,
                          itemBuilder: (BuildContext context, int index) {
                            final attachment = widget.post.attachments[index];
                            return ListTile(
                              title: Text(attachment.name),
                              leading: const Icon(Icons.attachment),
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
