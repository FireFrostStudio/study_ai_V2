import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({super.key, this.controller, this.style, this.readOnly = false});

  final TextEditingController? controller;
  final TextStyle? style;
  bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: DefaultTextStyle(
            style: style?? TextStyle(fontSize: 15), // Set the default text style
            child: TextField(
              readOnly: readOnly,
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Ask StudyAI',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}