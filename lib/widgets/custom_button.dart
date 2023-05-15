// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.title,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed
  });
  final String? title;
  final Color? textColor;
  final Color? backgroundColor;
   final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text("$title",style: TextStyle(fontWeight: FontWeight.w400,color: textColor),),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        );
  }
}