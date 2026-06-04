import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AvexApp());
}

class AvexApp extends StatelessWidget {
  const AvexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AVEX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}
