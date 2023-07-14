import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/screen/menu/info.dart';
import 'package:todo/service/activeNotify.dart';
import 'package:todo/widget/layout/appbutton.dart';
import 'package:todo/widget/layout/appstring.dart';
import 'package:todo/widget/layout/apptext.dart';
import 'package:todo/widget/layout/apptitle.dart';
import 'package:todo/service/offline.dart';

class NewTaskScreen extends StatefulWidget {
  NewTaskScreen({super.key, this.id});
  int? id;
  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  bool isLoading = true;
  List catList = ['Personnal', 'Teams'];
  List icon = [Icons.person_outline_rounded, Icons.diversity_2_rounded];
  int categorie = 0;
  void onTap(int index) {
    setState(() {
      categorie = index;
    });
  }
  void initData() async {
    final data = await OfflineService.singleTask(widget.id!);
    isLoading = true;
    if (isLoading == true) {
      setState(() {
        title.text = data[0]['title'];
        description.text = data[0]['description'];
        date.text = data[0]['date'].toString().substring(0, 10);
        time.text = data[0]['date'].toString().substring(11, 16);
      });
    }
    isLoading = false;
  }

  //date regex
  bool isValidDate(String value) {
    return RegExp(
            r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
        .hasMatch(date.text);
  }
  //time regex
  bool isValidTime(String value) {
    return RegExp(r'^(?:[01]?\d|2[0-3])(?::(?:[0-5]\d?)?)?$')
        .hasMatch(time.text);
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
    if(widget.id != null && isLoading == true){
      initData();
    }
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
                    text: users[0]['language'] == 'French' ? AppStringFrench.titlenew : AppStringEnglish.titlenew,
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
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(text: users[0]['language'] == 'French' ? AppStringFrench.inputtitle : AppStringEnglish.inputtitle),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextFormField(
                      controller: title,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Task title is not empty*';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: users[0]['language'] == 'French' ? AppStringFrench.addtitle : AppStringEnglish.addtitle,
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(text: users[0]['language'] == 'French' ? AppStringFrench.inputcategory : AppStringEnglish.inputcategory),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: catList.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          onTap(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            right: 8,
                          ),
                          padding: const EdgeInsets.all(10),
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2 - 13,
                          decoration: BoxDecoration(
                            color: catList[index] == catList[categorie]
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                icon[index],
                                color: Colors.white,
                              ),
                              AppText(
                                text: catList[index],
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(text: users[0]['language'] == 'French' ? AppStringFrench.inputdescription : AppStringEnglish.inputdescription),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextFormField(
                      controller: description,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is not empty*';
                        }
                        return null;
                      },
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: users[0]['language'] == 'French' ? AppStringFrench.adddescription : AppStringEnglish.adddescription,
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(text: 'Date'),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 13,
                              child: TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: date,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Date is not empty*';
                                  } else if (value.length != 10) {
                                    return 'Date doesn\'t match*';
                                  } else if (isValidDate(value) == false) {
                                    return 'Date isn\'t valid*';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'dd/mm/yy',
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: const Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.blue,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(text: users[0]['language'] == 'French' ? AppStringFrench.inputtime : AppStringEnglish.inputtime),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 13,
                              child: TextFormField(
                                keyboardType: TextInputType.datetime,
                                controller: time,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Time is not empty*';
                                  } else if (value.length != 5) {
                                    return 'Time doesn\'t match*';
                                  } else if (isValidTime(value) == false) {
                                    return 'Time isn\'t valid*';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'hh:mm',
                                  fillColor: Colors.white,
                                  filled: true,
                                  prefixIcon: const Icon(
                                    Icons.timer_outlined,
                                    color: Colors.blue,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if(widget.id == null){
                          await OfflineService.createTask(title.text, catList[categorie], description.text, date.text, time.text);
                        } else {
                          await OfflineService.updateTask(widget.id!, title.text, catList[categorie], description.text, date.text, time.text);
                        }
                        Navigator.pop(context);
                      }
                    },
                    child: AppButtonResponsive(
                      widht: MediaQuery.of(context).size.width,
                      btnTxt: users[0]['language'] == 'French' ? AppStringFrench.btnsavetask : AppStringEnglish.btnsavetask,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
