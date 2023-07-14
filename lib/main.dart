// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/screen/auth/signin.dart';
import 'package:todo/screen/menu/homescreen.dart';
import 'package:todo/service/activeNotify.dart';
import 'package:todo/service/offline.dart';
import 'package:todo/widget/layout/appstring.dart';
import 'package:todo/widget/layout/apptext.dart';
import 'package:todo/widget/layout/apptitle.dart';


void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const TimerFrame(),
    );
  }
}

class TimerFrame extends StatefulWidget {
  const TimerFrame({super.key});

  @override
  State<TimerFrame> createState() => _TimerFrameState();
}

class _TimerFrameState extends State<TimerFrame> {

  bool loading = true;
  bool loadedData = true;
  void loaded() {
    if (loading == true) {
      setState(() {
        loading = false;
      });
    }
  }

  List<Map<String, dynamic>> users = [];
  void first() async {
    if (loadedData == true) {
      final data = await OfflineService.listUser();
      setState(() {
        users = data;
      });
    }
    loadedData = false;
  }

  @override
  Widget build(BuildContext context) {
    first();
    Timer(const Duration(seconds: 5), () async {
      loaded();
    });
    return loading
        ? Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blue,
                  Colors.indigoAccent,
                  Colors.lightBlue
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTitle(
                      text: AppStringFrench.appTitle,
                      size: 48,
                      color: Colors.white,
                      isFont: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppText(
                      text: AppStringEnglish.appChargement,
                      size: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          )
        : users.isEmpty
            ? const SignInScreen()
            : HomeScreen();
  }
}
