import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo/screen/menu/detailscreen.dart';
import 'package:todo/screen/menu/info.dart';
import 'package:todo/service/activeNotify.dart';
import 'package:todo/service/offline.dart';
import 'package:todo/widget/layout/appstring.dart';
import 'package:todo/widget/layout/apptext.dart';
import 'package:todo/widget/layout/apptitle.dart';

class DoneScreen extends StatefulWidget {
  DoneScreen({super.key});
  bool? isLoading;
  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  List<Map<String, dynamic>> donetask = [];
  void initData() async {
    final doneData = await OfflineService.doneTask();
    if (widget.isLoading == true) {
      setState(() {
        donetask = doneData;
      });
    }
    widget.isLoading = false;
  }

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
    Timer(const Duration(milliseconds: 100), (){widget.isLoading = true; initData();});
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
                    text: users[0]['language'] == 'French' ? AppStringFrench.titlecom : AppStringEnglish.titlecom,
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
            if (donetask.length == 0)
              Center(child: AppText(text: users[0]['language'] == 'French' ? AppStringFrench.datanonecom : AppStringEnglish.datanonecom, color: Colors.grey, size: 12)),
            if (donetask.length != 0)
            for (int i = 0; i < donetask.length; i++)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(id: donetask[i]['id'])),
                  );
                },
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.1, 0.1),
                        blurRadius: 0.1,
                        spreadRadius: 0.1,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppTitle(
                                text: donetask[i]['title'].toString().length > 18 ? '${donetask[i]['title'].toString().substring(0, 17)}...':donetask[i]['title'],
                                size: 16,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              AppText(
                                text: donetask[i]['description'].toString().length > 28 ? '${donetask[i]['description'].toString().substring(0, 27)}...':donetask[i]['description'],
                                size: 12,
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      Container(
                        height: 2,
                        color: const Color.fromARGB(255, 232, 232, 232),
                        margin: const EdgeInsets.all(10),
                      ),
                      AppText(
                        text: DateFormat('EEEE d MMM, yyyy').format(DateTime.parse(donetask[i]['date'].toString().substring(0, 10).split('/').reversed.join())),
                        size: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
