import 'package:flutter/material.dart';

import '../constants.dart';

class MessageLine extends StatelessWidget {
   MessageLine({required this.nomComplet, required this.messageText, this.email, super.key});
    final String? nomComplet;
      final String? messageText;
      final String? email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("$nomComplet", style: TextStyle(fontWeight: FontWeight.w400, color: kDarkGeenColor, fontSize: 12),),
          Material(
            elevation: 6,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),
            topLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)
            ),
            color: kBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 30),
              child: Text("$messageText", style: TextStyle(fontSize: 14, color:Colors.white),),
            )),
        ],
      ),
    );
  }
}
