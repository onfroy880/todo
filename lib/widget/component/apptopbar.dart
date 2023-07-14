import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/screen/menu/storescreen.dart';
import 'package:todo/service/offline.dart';
import 'package:todo/widget/layout/appstring.dart';
import 'package:todo/widget/layout/apptext.dart';
import 'package:todo/widget/layout/apptitle.dart';

class AppNavigationBar extends StatefulWidget {
  List<dynamic> user;
  AppNavigationBar({super.key, required this.user});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  bool loadedData = true;
  List<Map<String, dynamic>> progresss = [];
  List<Map<String, dynamic>> dones = [];
  List<Map<String, dynamic>> lists = [];
  void first() async {
    if (loadedData == true) {
      final progress = await OfflineService.onProgressTask();
      final done = await OfflineService.doneTask();
      final list = await OfflineService.listTask();
      setState(() {
        progresss = progress;
        dones = done;
        lists = list;
      });
      loadedData = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 100), (){loadedData = true; first();});
    return Container(
      height: 50,
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              sidebar();
            },
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                image: DecorationImage(
                  image: AssetImage(widget.user[0]['avatar']),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.blue,
                    offset: Offset(0.5, 0.5),
                    blurRadius: 0.5,
                    spreadRadius: 0.5,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          AppTitle(
            text: AppStringFrench.appTitle,
            color: Colors.blue,
            isFont: true,
          ),
          const SizedBox(
            width: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => StoreScreen()),
                  // );
                },
                child: const Icon(
                  Icons.date_range_rounded,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const NotificationScreen()),
                  // );
                },
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sidebar() {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            margin: const EdgeInsets.only(
              right: 80,
            ),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.blue,
                    height: 240,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 215, 215, 215),
                              borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(
                                image: AssetImage(widget.user[0]['avatar']),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.blue,
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 0.5,
                                  spreadRadius: 0.5,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: AppText(
                            text: widget.user[0]['name'],
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.task_rounded, color: Colors.blue),
                            const SizedBox(width: 10,),
                            AppTitle(text: AppStringFrench.appTitle, size: 14,),
                            Expanded(child: Container()),
                            AppText(text: "${lists.length}", size: 16,),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.pending_actions_rounded, color: Colors.deepOrangeAccent),
                            const SizedBox(width: 10,),
                            AppTitle(text: widget.user[0]['language'] == 'French' ? AppStringFrench.onprogress : AppStringEnglish.onprogress, size: 14,),
                            Expanded(child: Container()),
                            AppText(text: "${progresss.length}", size: 16,),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.done_all_rounded, color: Colors.green),
                            const SizedBox(width: 10,),
                            AppTitle(text: widget.user[0]['language'] == 'French' ? AppStringFrench.completed : AppStringEnglish.completed, size: 14,),
                            Expanded(child: Container()),
                            AppText(text: "${dones.length}", size: 16,),
                          ],
                        ),
                        const SizedBox(height: 300,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.language_rounded),
                            const SizedBox(width: 10,),
                            AppTitle(text: 'Language', size: 14,),
                            Expanded(child: Container()),
                            AppText(text: widget.user[0]['language'], size: 16,),
                          ],
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
