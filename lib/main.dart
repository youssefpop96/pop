import 'package:flutter/material.dart';
import 'core/utilities/size_config.dart';
import 'features/splash/views/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, 
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Builder(
        builder: (context) {
          SizeConfig().init(context);
          return const SplashScreen();
        },
      ),
    );
  }
}
