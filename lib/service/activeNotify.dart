import 'dart:async';

import 'package:todo/service/nofication.dart';
import 'package:todo/service/offline.dart';

class ActiveNotify {
  List<Map<String, dynamic>> tasks = [];
  DateTime currentDatetime = DateTime.parse(DateTime.now().toString().substring(0, 16));
  late DateTime databaseDatetime;

  void notify() async {
    Timer(const Duration(seconds: 5), () async {
      final task = await OfflineService.listTask();
      tasks = task;
      for(int i = 0; i < tasks.length; i++){
        databaseDatetime = DateTime.parse('${tasks[i]['date'
        ].toString().substring(0, 10).split('/').reversed.join()} ${tasks[i]['date'
        ].toString().substring(11, 16)}');
        if(databaseDatetime == currentDatetime){
          NotificationService().initNotifications();
          NotificationService().showNotification(title: tasks[i]['title'].toString(), body: tasks[i]['description'].toString().length > 28 ? '${tasks[i]['description'].toString().substring(0, 27)}...':tasks[i]['description']);

        }
      }
    });
  }

}