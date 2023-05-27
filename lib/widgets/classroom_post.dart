import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';
import 'package:parafacile/views/post_details.dart';

class ClassroomPostWidget extends StatefulWidget {
  final String authorName;
  final String postTitle;
  int? commentCount;
  String? description;
  String? urlAttach;
  late String? id;

  ClassroomPostWidget({
    required this.authorName,
    required this.postTitle,
    this.commentCount,
    this.description,
    this.urlAttach,
    this.id
  });

  @override
  State<ClassroomPostWidget> createState() => _ClassroomPostWidgetState();
}

class _ClassroomPostWidgetState extends State<ClassroomPostWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PostDetails(id: widget.id,
            post: Post(
                title: widget.postTitle,
                description: widget.description!,
                attachments: <Attachment>[
                  Attachment(
                      name: "tapper ici pour voir votre attachement",
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
                style: TextStyle(
                  color: kDarkGeenColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 39.0),
              child: Text(
                'Author: ${widget.authorName}',
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
                    SizedBox(width: 5),
                    Text('${widget.commentCount} Comments'),
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
