import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jemisyseshop/data/dataService.dart';
import 'package:jemisyseshop/model/common.dart';
import 'package:jemisyseshop/model/dataObject.dart';
import 'package:jemisyseshop/model/dialogs.dart';
import 'package:jemisyseshop/utilities/videoCall.dart';
import 'package:jemisyseshop/view/voucherDetail.dart';
import 'package:rxdart/subjects.dart';

DataService obj = new DataService();
Commonfn objcf = new Commonfn();
Flushbar flush;

final BehaviorSubject<ReminderNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReminderNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

Future<void> initNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReminderNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
}

Future<void> showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0', 'Natalia', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'Natalia title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> turnOffNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> turnOffNotificationById(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    num id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> scheduleNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String id,
    String body,
    DateTime scheduledNotificationDateTime) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    id,
    'Reminder notifications',
    'Remember about it',
    icon: 'app_icon',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(0, 'Reminder', body,
      scheduledNotificationDateTime, platformChannelSpecifics);
}

Future<void> scheduleNotificationPeriodically(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    String id,
    String body,
    RepeatInterval interval) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    id,
    'Reminder notifications',
    'Remember about it',
    icon: 'smile_icon',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.periodicallyShow(
      0, 'Reminder', body, interval, platformChannelSpecifics);
}

void requestIOSPermissions(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

Future<void> sendNotification(BuildContext context, String channelName) async {
  FCMParam param = FCMParam();
  param.to = "/topics/" + channelName;
  param.title = "On Video Call";
  param.body = "Dear Customer, Please click here to accept and join to video call";
  param.channelName = channelName;
  param.isScheduled = "no";
  param.image = "http://51.79.160.233/NotificationImages/videoCall.jpg";
  param.tag = "videoCall";
  param.click_action = "FLUTTER_NOTIFICATION_CLICK";
  param.screen = "videoCall";
  param.time_to_live = 300;
  param.color = "#FF0000";
  param.restricted_package_name = "com.jemisys.jemisyseshop";
  print(param.toString());
  await obj.FCMSendPushNotifications(param).then((state) =>
      objcf.showInfoFlushbar(context, state, "Notifications"));
}

Future<dynamic> _scheduleNotification(Map<String, dynamic> message) async {
  final data = message['data'];

  notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);
  requestIOSPermissions(flutterLocalNotificationsPlugin);

  DateTime scheduledTime = DateTime.parse(data['scheduledTime']);
  //var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));
  var scheduledNotificationDateTime = new DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day,
      scheduledTime.hour, scheduledTime.minute);

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    "4",
    'Reminder notifications',
    'Remember about it',
    icon: 'app_icon',
    enableVibration: false,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      data['scheduledTitle'],
      data['scheduledBody'],
      scheduledNotificationDateTime,
      platformChannelSpecifics);

  return Future<void>.value();
}

void firebaseMessagingConfigure() {
  BuildContext context;
  var notification, notificationData;
  firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        notification = message['notification'];
        notificationData = message['data'] ?? message;
        String buttonTitle = "OK";
        if (notificationData['screen'] != null) {
          if (notificationData['screen'] == "videoCall")
            buttonTitle = "ACCEPT";
        }
        print('onMessage: $message');
        if (notificationData["isScheduled"] == "yes") {
          _scheduleNotification(message);
        }
        else {
          flush = Flushbar<bool> (
            borderRadius: 15,
            title: notification['title'],
            message: notification['body'],
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.FLOATING,
            reverseAnimationCurve: Curves.decelerate,
            forwardAnimationCurve: Curves.elasticOut,
            backgroundGradient: LinearGradient(colors: [Colors.teal, Colors.blueAccent],),
            backgroundColor: Colors.red,
            boxShadows: [BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0,)],
            isDismissible: false,
            //duration: Duration(seconds: 20 ),
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
            mainButton: FlatButton(
              onPressed: () {
                flush.dismiss(true);
                if (notificationData['screen'] != null) {
                  _serialiseAndNavigate(context, message);
                }
              },
              child: Text(
                buttonTitle,
                style: TextStyle(color: Colors.black),
              ),
            ),
            showProgressIndicator: true,
            progressIndicatorBackgroundColor: Colors.blueGrey,
            titleText: Text(
              notification['title'],
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.yellow, fontFamily: "ShadowsIntoLightTwo"),
            ),
            messageText: Text(
              notification['body'],
              style: TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
            ),
          )..show(context).then((result) {
          });
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _serialiseAndNavigate(context, message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _serialiseAndNavigate(context, message);
      }
  );

  firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true)
  );
}

void _serialiseAndNavigate(BuildContext context, Map<String, dynamic> message) {
  var notificationData = message['data'] ?? message;
  if (notificationData["isScheduled"] == "yes") {
    _scheduleNotification(message);
    Dialogs.AlertMessage(context, "Appointment confirmed and reminder added");
  }
  else if (notificationData['screen'] != null) {
    // Navigate to the screen defined
    if (notificationData['screen'] == 'voucher') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VoucherDetailPage()),);
    }
    else if (notificationData['screen'] == 'videoCall') {
      hideGoldRate = true;
      Commonfn.handleCameraAndMic();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: notificationData['channelName'],
            role: ClientRole.Broadcaster,
          ),),
      );
    }
    // If there's no view it'll just open the app on the first view
  }
}
