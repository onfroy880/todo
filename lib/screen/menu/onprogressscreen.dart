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

class OnProgressScreen extends StatefulWidget {
  OnProgressScreen({super.key});
  bool? isLoading;

  @override
  State<OnProgressScreen> createState() => _OnProgressScreenState();
}

class _OnProgressScreenState extends State<OnProgressScreen> {
  List<Map<String, dynamic>> pendingtask = [];
  void initData() async {
    final pendingData = await OfflineService.onProgressTask();
    if (widget.isLoading == true) {
      setState(() {
        pendingtask = pendingData;
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
    // Timer(const Duration(seconds: 3), () async {
    //   ActiveNotify().notify();
    //   print('is notify');
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
                    text: users[0]['language'] == 'French' ? AppStringFrench.titlepro : AppStringEnglish.titlepro,
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
            if (pendingtask.length == 0)
              Center(child: AppText(text: "${users[0]['language'] == 'French' ? AppStringFrench.datanonepro : AppStringEnglish.datanonepro}", color: Colors.grey, size: 12)),
            if (pendingtask.length != 0)
            for (int i = 0; i < pendingtask.length; i++)
              GestureDetector(
                onDoubleTap: () async {
                  int done = await OfflineService.makeDoneTask(pendingtask[i]['id']);
                },
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(id: pendingtask[i]['id'])),
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
                                text: pendingtask[i]['title'].toString().length > 18 ? '${pendingtask[i]['title'].toString().substring(0, 17)}...':pendingtask[i]['title'],
                                size: 16,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              AppText(
                                text: pendingtask[i]['description'].toString().length > 28 ? '${pendingtask[i]['description'].toString().substring(0, 27)}...':pendingtask[i]['description'],
                                size: 12,
                              ),
                            ],
                          ),
                          Icon(
                            Icons.check_circle,
                            color: DateTime.parse('${pendingtask[i]['date'].toString().substring(0, 10).split('/').reversed.join()} ${pendingtask[i]['date'].toString().substring(11, 16)}').isBefore(DateTime.now()) ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                      Container(
                        height: 2,
                        color: const Color.fromARGB(255, 232, 232, 232),
                        margin: const EdgeInsets.all(10),
                      ),
                      AppText(
                        text: DateFormat('EEEE d MMM, yyyy').format(DateTime.parse(pendingtask[i]['date'].toString().substring(0, 10).split('/').reversed.join())),
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
