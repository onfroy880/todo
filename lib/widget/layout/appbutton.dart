import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppButtonResponsive extends StatelessWidget {
  AppButtonResponsive({super.key, this.widht, this.btnTxt});

  double? widht;
  String? btnTxt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widht,
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            btnTxt!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
