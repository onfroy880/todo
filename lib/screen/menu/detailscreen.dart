// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo/screen/menu/homescreen.dart';
import 'package:todo/screen/menu/newscreen.dart';
import 'package:todo/service/activeNotify.dart';
import 'package:todo/service/offline.dart';
import 'package:todo/widget/layout/appstring.dart';
import 'package:todo/widget/layout/apptext.dart';
import 'package:todo/widget/layout/apptitle.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({super.key, required this.id});
  int id;
  bool? isLoading;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String title = '';
  String category = '';
  String description = '';
  String statut = '';
  String date = '';
  void initData() async {
    final data = await OfflineService.singleTask(widget.id);
    widget.isLoading = true;
    if (widget.isLoading == true) {
      setState(() {
        title = data[0]['title'];
        category = data[0]['category'];
        description = data[0]['description'];
        date = data[0]['date'];
        statut = data[0]['statut'];
      });
    }
    widget.isLoading = false;
  }

  bool loadedData = true;
  List<Map<String, dynamic>> users = [{'language': 'Engliish', 'name': 'ToDo User', 'avatar': 'images/avatar1.png'}];
  void first() async {
    if (loadedData == true) {
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
    initData();
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
                    text: users[0]['language'] == 'French' ? AppStringFrench.titledet : AppStringEnglish.titledet,
                    color: Colors.blue,
                    isFont: true,
                    // size: 18,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(statut == 'false')
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewTaskScreen(id: widget.id)),
                            );
                          },
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      const SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await OfflineService.deleteTask(widget.id);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Task deleted !')));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        },
                        child: const Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  category == 'Teams' ? Icons.diversity_2_rounded : Icons.person_outline_rounded,
                  color: Colors.orangeAccent,
                ),
                const SizedBox(
                  width: 10,
                ),
                AppTitle(
                  text: title.length > 18 ? '${title.substring(0, 17)}...':title,
                  size: 18,
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(
              text: description,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppText(
                  text: '$category task',
                  size: 14,
                  color: Colors.grey,
                ),
                AppText(
                  text: DateFormat('EEEE d MMM, yyyy HH:mm').format(DateTime.parse('${date.substring(0, 10).split('/').reversed.join()} ${date.substring(11, 16)}')),
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
