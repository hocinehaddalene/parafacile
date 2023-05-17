import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Attachment {
  final String name;
  final String url;

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

  PostDetails({required this.post});

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
          title: Text('Add Comment'),
          content: TextField(
            onChanged: (value) {
              newComment = value;
            },
            decoration: InputDecoration(
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
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.post.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Section: ${widget.post.section}',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.post.description,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Divider(),
            if (widget.post.attachments.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Attachments',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.post.attachments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final attachment = widget.post.attachments[index];
                          return ListTile(
                            title: Text(attachment.name),
                            leading: Icon(Icons.attachment),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PDFView(
                                    filePath: attachment.url,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ListTile(
              title: Text(
                'Comments (${widget.post.comments.length})',
                style: TextStyle(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCommentDialog(context),
        child: Icon(Icons.comment),
      ),
    );
  }
}
