// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  double size;
  String text;
  Color color;
  bool isFont;
  AppTitle({
    super.key,
    this.size = 22,
    this.isFont = false,
    this.color = const Color.fromARGB(255, 47, 46, 46),
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: isFont ? 'Dancing' : 'Roboto',
      ),
    );
  }
}
