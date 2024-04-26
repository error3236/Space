import 'package:firebase_core/firebase_core.dart';
import 'package:flash/Components/splash_scree.dart';
import 'package:flash/Themes/dark_theme.dart';
import 'package:flash/firebase_options.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Flash());
}

class Flash extends StatelessWidget {
  const Flash({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      home:SplashScreen() ,
    );
  }
}
