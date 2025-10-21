import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; // Import this to check for kReleaseMode
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import "package:firebase_core/firebase_core.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // Ensures it's only used in debug mode
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Important: These two lines are required by device_preview
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      // Your app's theme, routes, and home
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Gaming')),
      body: const Center(
        child: Text('Hello, World!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
