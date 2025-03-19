
import '../views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Providers/notification_provider.dart';
import 'Providers/post_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Important pour l'accès aux ressources natives
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plateforme Professionnelle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}





