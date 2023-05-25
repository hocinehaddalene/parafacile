import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {

CustomTextField(
      {super.key,
      required this.labelText,
      this.onSaved,
      this.obscureText = false,
      this.icon,
      this.prefixIcon,
      this.prefixIconColor,
      this.controller,
      this.maxLines,
      this.readOnly = false,
      this.onTap,
      this.onChange,
      this.initialValue
      });
   String? initialValue;   
   String? labelText;
   void Function(String?)? onSaved;
   bool obscureText;
   IconData? icon;
   Icon? prefixIcon;
   Color? prefixIconColor;
   TextEditingController? controller;
   int? maxLines = 1;
   bool readOnly;
   void Function()? onTap;
   void Function(String)? onChange;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextFormField(
        initialValue: widget.initialValue,
        onChanged: widget.onChange,
        readOnly: widget.readOnly!,
        maxLines: widget.maxLines,
        controller: widget.controller,
        validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrez vos données';
    }
    return null;
  },
        obscureText: widget.obscureText,
        onSaved: widget.onSaved,
        onTap: widget.onTap,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          prefixIconColor: widget.prefixIconColor,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
              widget.obscureText = !widget.obscureText;
              });
            },
            child: Icon(
              widget.icon,
              color: Colors.white54,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
