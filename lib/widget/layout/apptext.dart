// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  double size;
  String text;
  Color color;
  AppText({
    super.key,
    this.size = 16,
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
        fontFamily: 'Roboto'
      ),
    );
  }
}