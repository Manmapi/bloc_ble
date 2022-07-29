import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const int HELP_ALARM      = 1;
const int ALL_OK          = 2;
const int TEST            = 3;
const int BATTERY_LOW     = 5;
const int BATTERY_OK      = 6;
const int IMPACT_DETECT   = 12;
const int IMPACT_ALERT    = 13;
const int CHECK_IN_1_DONE = 14;
const int CHECK_IN_2_DONE = 15;
const int CHECK_IN_1_FAIL = 16;
const int CHECK_IN_2_FAIL = 17;


class Information {
  final String status;
  final String? checkInStatus1;
  final String? checkInStatus2;
  final bool batteryStatus;
  const Information({required this.status,required this.checkInStatus1,required this.checkInStatus2,required this.batteryStatus});

  @override
  String toString () {
    return 'status: $status, check in 1: $checkInStatus1, check in 2: $checkInStatus2, battery: $batteryStatus';
  }
}


Information inforDecode(List<int> res, Information preInfor, FlutterLocalNotificationsPlugin notification)
{
  String? status;
  String? checkInStatus1;
  String? checkInStatus2;
  bool batteryStatus;
  if(res[0]==1)
    {
      batteryStatus = true;
    }
  else
    {
      batteryStatus = false;
    }
  switch(res[1])
  {
    case HELP_ALARM:
      status = 'HELPAlarm at ${DateTime.now().toString().substring(0,19)}';
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('HEALTH', 'HEALTH STATUS',
          channelDescription: 'DESCRIBE HEALTH STATUS',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      notification.show(
          0, 'Health alert',status , platformChannelSpecifics,
          payload: 'item x');
      break;
    case ALL_OK:
      status = 'AllOk at ${DateTime.now().toString().substring(0,19)}';
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('HEALTH', 'HEALTH STATUS',
          channelDescription: 'DESCRIBE HEALTH STATUS',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      notification.show(
          0, 'Health alert',status, platformChannelSpecifics,
          payload: 'item x');
      break;
    case TEST:
      status = 'Test at ${DateTime.now().toString().substring(0,19)}';
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('HEALTH', 'HEALTH STATUS',
          channelDescription: 'DESCRIBE HEALTH STATUS',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      notification.show(
          0, 'Health alert',status , platformChannelSpecifics,
          payload: 'item x');
      break;
    case IMPACT_ALERT:
      status = 'Impact alert at ${DateTime.now().toString().substring(0,19)}';
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('HEALTH', 'HEALTH STATUS',
          channelDescription: 'DESCRIBE HEALTH STATUS',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      notification.show(
          0, 'Health alert',status, platformChannelSpecifics,
          payload: 'item x');
      break;
    case IMPACT_DETECT:
      status = 'Impact detect at ${DateTime.now().toString().substring(0,19)}';
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('HEALTH', 'HEALTH STATUS',
          channelDescription: 'DESCRIBE HEALTH STATUS',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      notification.show(
          0, 'Health alert',status, platformChannelSpecifics,
          payload: 'item x');
      break;
    case CHECK_IN_1_DONE:
      checkInStatus1 = 'Checkin1 done at ${DateTime.now().toString().substring(0,19)}';
      break;
    case CHECK_IN_2_DONE:
      checkInStatus2 = 'Checkin2 done at ${DateTime.now().toString().substring(0,19)}';
      break;
    case CHECK_IN_1_FAIL:
      checkInStatus1 = 'Checkin1 fail at ${DateTime.now().toString().substring(0,19)}';
      break;
    case CHECK_IN_2_FAIL:
      checkInStatus2 = 'Checkin2 fail at ${DateTime.now().toString().substring(0,19)}';
      break;
  }
  return Information(status: status??preInfor.status, checkInStatus1: checkInStatus1??preInfor.checkInStatus1, checkInStatus2: checkInStatus2??preInfor.checkInStatus2, batteryStatus: batteryStatus);
}