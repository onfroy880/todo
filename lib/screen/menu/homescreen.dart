import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todo/screen/menu/detailscreen.dart';
import 'package:todo/screen/menu/donescreen.dart';
import 'package:todo/screen/menu/newscreen.dart';
import 'package:todo/screen/menu/onprogressscreen.dart';
import 'package:todo/service/activeNotify.dart';
import 'package:todo/service/offline.dart';
import 'package:todo/widget/component/apptopbar.dart';
import 'package:todo/widget/layout/appstring.dart';
import 'package:todo/widget/layout/apptext.dart';
import 'package:todo/widget/layout/apptitle.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.isLoading, this.loadedData = true});
  bool? isLoading;
  bool? loadedData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // bool loadedData = true;
  List<Map<String, dynamic>> donetask = [];
  List<Map<String, dynamic>> pendingtask = [];
  List<Map<String, dynamic>> users = [];
  int donetaskcount = 0;
  int pendingtaskcount = 0;
  void initData() async {
    final doneData = await OfflineService.doneTask();
    final pendingData = await OfflineService.onProgressTask();
    if (widget.isLoading == true) {
      setState(() {
        donetask = doneData;
        pendingtask = pendingData;
        if (donetask.length > 8) {
          donetaskcount = 7;
        }else{
          donetaskcount = donetask.length;
        }
        if (pendingtask.length > 13) {
          pendingtaskcount = 12;
        }else{
          pendingtaskcount = pendingtask.length;
        }
      });
    }
    widget.isLoading = false;
  }

  void firsty() async {
    if (widget.loadedData == true) {
      users = [{'language': 'Engliish', 'name': 'ToDo User', 'avatar': 'images/avatar1.png'}];
      final data = await OfflineService.listUser();
      setState(() {
        users[0].clear();
        users = data;
      });
      widget.loadedData = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    firsty();
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
            AppNavigationBar(user: users),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTitle(
                      text: '${users[0]['language'] == 'French' ? AppStringFrench.onprogress : AppStringEnglish.onprogress} (${pendingtask.length})',
                      size: 18,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnProgressScreen()),
                        );
                      },
                      child: AppText(
                        text: users[0]['language'] == 'French' ? AppStringFrench.viewmore : AppStringEnglish.viewmore,
                        color: Colors.blue,
                        size: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (pendingtaskcount == 0)
                  Center(child: AppText(text: users[0]['language'] == 'French' ? AppStringFrench.datanonepro : AppStringEnglish.datanonepro, color: Colors.grey, size: 12)),
                if (pendingtaskcount != 0)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pendingtaskcount,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(id: pendingtask[index]['id'])),
                            );
                          },
                          child: Container(
                            height: 190,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(8),
                            width: MediaQuery.of(context).size.width - 80,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppTitle(
                                          text: pendingtask[index]['title'].toString().length > 18 ? '${pendingtask[index]['title'].toString().substring(0, 17)}...':pendingtask[index]['title'],
                                          size: 16,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        AppText(
                                          text: DateFormat('EEEE d MMM, yyyy').format(DateTime.parse(pendingtask[index]['date'].toString().substring(0, 10).split('/').reversed.join())),
                                          //
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      pendingtask[index]['category'] == 'Teams'? Icons.diversity_2_rounded : Icons.person_outline_rounded,
                                      color: Colors.orangeAccent,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 2,
                                  color:
                                      const Color.fromARGB(255, 232, 232, 232),
                                  margin: const EdgeInsets.all(10),
                                ),
                                AppText(
                                  text: 'Description :',
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                AppText(
                                  text: pendingtask[index]['description'].toString().length > 130 ? '${pendingtask[index]['description'].toString().substring(0, 129)}...':pendingtask[index]['description'],
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                AppText(
                                  text: 'Progress :',
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                LinearProgressIndicator(
                                  value: 100,
                                  backgroundColor: Colors.grey,
                                  color: DateTime.parse('${pendingtask[index]['date'].toString().substring(0, 10).split('/').reversed.join()} ${pendingtask[index]['date'].toString().substring(11, 16)}').isBefore(DateTime.now()) ? Colors.red : Colors.green,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTitle(
                      text: users[0]['language'] == 'French' ? AppStringFrench.completed : AppStringEnglish.completed,
                      size: 18,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DoneScreen()),
                        );
                      },
                      child: AppText(
                        text: users[0]['language'] == 'French' ? AppStringFrench.viewmore : AppStringEnglish.viewmore,
                        color: Colors.blue,
                        size: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (donetaskcount == 0)
                  Center(child: AppText(text: users[0]['language'] == 'French' ? AppStringFrench.datanonecom : AppStringEnglish.datanonecom, color: Colors.grey, size: 12)),
                if (donetaskcount != 0)
                for (int i = 0; i < donetaskcount; i++)
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTaskScreen()),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
