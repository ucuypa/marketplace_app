import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ NEW
import 'package:marketplace_app/presentation/favorites/application/favorites_controller.dart'; // ✅ NEW

import 'package:marketplace_app/UserModel/user_model.dart';
import 'package:marketplace_app/authentication/login.dart';
import 'package:marketplace_app/authentication/registration.dart';
import 'package:marketplace_app/presentation/home/home_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication/auth_wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope( // tetap pakai Riverpod
      child: MultiProvider( // ✅ tambahkan MultiProvider
        providers: [
          ChangeNotifierProvider(create: (_) => FavoritesController()),
          // tambahkan provider lain di sini jika perlu
        ],
        child: DevicePreview(
          enabled: !kReleaseMode,
          builder: (context) => const MyApp(),
        ),
      ),
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
      title: 'Theme Marketplace',
      home: const HomePage(), // This widget handles auth state
    );
  }
}
