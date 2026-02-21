import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home.dart';
import 'screens/categories.dart';
import 'screens/plants_by_category.dart';
import 'screens/plant_details.dart';
import 'screens/favorite_plants.dart';
import 'screens/about_us.dart';
import 'screens/calendar.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, "/home");
      });
    }

    _setupFCM();
  }

  Future<void> _setupFCM() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification?.title);
      print(message.notification?.body);

      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${message.notification!.title}: ${message.notification!.body}",
            ),
          ),
        );
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Navigator.pushNamed(context, '/home');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.pushNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plants App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginPage(),
        "/register": (context) => const RegisterPage(),
        "/home": (context) => const HomePage(title:'FloraMate – your friend for plants'),
        "/plants_by_category": (context) => const PlantsByCategoryPage(),
        "/plant_details": (context) => const PlantDetailsPage(),
        "/favorites": (context) => const FavoritesPage(),
        "/categories": (context) => const CategoryPage(),
        "/aboutus": (context) => const AboutUsPage(),
        "/calendar": (context) => const CalendarPage(),
        "/profile": (context) => const ProfilePage(),
      },
    );
  }
}
