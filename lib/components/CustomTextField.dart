import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    @required this.controller,
    this.hintText,
    this.isObsecure = false,
    this.margin,
    this.textAlign = TextAlign.start,
  });
  final TextEditingController controller;
  final String hintText;
  final bool isObsecure;
  final EdgeInsets margin;
  final TextAlign textAlign;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: (margin == null) ? EdgeInsets.all(10) : margin,
      child: TextFormField(
        textAlign: textAlign,
        obscureText: isObsecure,
        controller: controller,
        validator: (value) => (value.isEmpty) ? "$hintText is required" : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide()
          ),
          labelText: hintText
        )
      ),
    );
  }
}