import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/features/auth/auth_pages/login_screen.dart';
import 'package:notes/features/auth/auth_pages/sign_up_screen.dart';
import 'package:notes/features/crud.dart';
import 'package:notes/features/splash_screen.dart';
import 'package:notes/screens/add_note_screen.dart';
import 'package:notes/screens/home_screen.dart';

import 'features/auth/auth_pages/user_profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Map<String, dynamic>> data = [];
  final DataService db = DataService();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    analytics.setAnalyticsCollectionEnabled(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Notes",
      routes: {
        '/': (globalContext) => SplashScreen(),
        '/login': (globalContext) => LoginPage(),
        '/signup': (globalContext) => SignUpPage(),
        '/profile': (globalContext) => UserProfileScreen(),
        '/home': (context) => HomeScreen(),
        '/addNote': (context) => AddNoteScreen(),
      },
      initialRoute: '/',
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}
