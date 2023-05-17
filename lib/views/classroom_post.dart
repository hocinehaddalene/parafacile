import 'package:flutter/material.dart';
import 'package:parafacile/constants.dart';

class ClassroomPostWidget extends StatelessWidget {
  final String authorName;
  final String postTitle;
  final int commentCount;
  String? description;

  ClassroomPostWidget({
    required this.authorName,
    required this.postTitle,
    required this.commentCount,
    this.description
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // Customize card appearance as per your design
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              postTitle,
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
              'Author: $authorName',
              style: TextStyle(
                
                fontWeight: FontWeight.w800,
                color: Colors.grey[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('$description'),),
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
                  Text('$commentCount Comments'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
