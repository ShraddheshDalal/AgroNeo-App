// ignore_for_file: unused_import

import 'package:agri/pages/Marketpalce.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'firebase_options.dart';

import 'Home.dart';
import 'pages/splash.dart';
import 'util/restart.dart';
import 'service/message_sender.dart';
import 'service/router.dart';

void main() async {
  print('🌟 main() started');
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase initialized');

  await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.debug,
  appleProvider: AppleProvider.debug,
);

  // print('✅ App Check activated');

  // await AndroidAlarmManager.initialize();
  // print('✅ Alarm Manager initialized');

  // 🟡 Temporarily comment to check app load
  // _scheduleDailyMessageTask();

  try {
    runApp(RestartWidget(child: MyApp()));
    print('✅ runApp executed');
  } catch (e, stack) {
    print('❌ runApp error: $e');
    print(stack);
  }
}

// void _scheduleDailyMessageTask() {
//   final now = DateTime.now();
//   final firstRunTime = DateTime(now.year, now.month, now.day, 9, 0);
//   final runTime = firstRunTime.isBefore(now)
//       ? firstRunTime.add(Duration(days: 1))
//       : firstRunTime;

//   AndroidAlarmManager.periodic(
//     const Duration(hours: 24),
//     1,
//     sendWhatsAppToAllUsers,
//     startAt: runTime,
//     exact: true,
//     wakeup: true,
//     rescheduleOnReboot: true,
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) => onGenerateRoute(settings),
      home: 
      StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
