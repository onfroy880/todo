import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/service/activeNotify.dart';
import 'package:todo/service/offline.dart';
import 'package:todo/widget/layout/appstring.dart';
import 'package:todo/widget/layout/apptext.dart';
import 'package:todo/widget/layout/apptitle.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  bool loadedData = true;
  List<Map<String, dynamic>> users = [];
  void first() async {
    if (loadedData == true) {
      users = [{'language': 'Engliish'}];
      final data = await OfflineService.listUser();
      setState(() {
        users[0].clear();
        users = data;
      });
      loadedData = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    first();
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
                  Expanded(child: Container()),
                  AppTitle(
                    text: 'ToDo Information',
                    color: Colors.blue,
                    isFont: true,
                    // size: 18,
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppText(
              text: users[0]['language'] == 'French' ? AppStringFrench.infos : AppStringEnglish.infos,
            ),
          ],
        ),
      ),
    );
  }
}
