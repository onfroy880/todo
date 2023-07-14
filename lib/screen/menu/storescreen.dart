import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/screen/menu/info.dart';
import 'package:todo/service/activeNotify.dart';
import 'package:todo/widget/layout/apptext.dart';
import 'package:todo/widget/layout/apptitle.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  DateTime selecteDate = DateTime.now();
  bool ok = true;
  void setDate(DateTime day) {
    if (ok == true) {
      setState(() {
        selecteDate = day;
      });
      ok = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Timer(const Duration(seconds: 15), () async {
    //   ActiveNotify().notify();
    // });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  AppTitle(
                    text: 'Calendar',
                    color: Colors.blue,
                    isFont: true,
                    // size: 18,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InfoScreen()),
                      );
                    },
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                selectDate();
              },
              child: AppTitle(
                text: selecteDate.toString().substring(0, 7),
                size: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(
              text: 'Click to select date and view task are programmed.',
              size: 12,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.utc(2000),
      lastDate: DateTime.utc(2222),
    );
  }
}
