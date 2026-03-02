import 'package:flutter/material.dart';
import 'package:pop/core/utilities/sizes/size_config.dart';
import 'package:pop/features/splash/views/screens/splash_screen.dart';
import 'package:pop/features/home/views/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/utilities/supabase_credentials.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseCredentials.url,
    anonKey: SupabaseCredentials.anonKey,
  );

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
      // Using an Auth State listener is more reliable for navigation
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Initialize SizeConfig whenever context is available at the root
        SizeConfig.init(context);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        final session = snapshot.data?.session;
        if (session != null) {
          return const HomeScreen();
        } else {
          // If no session, show SplashScreen which leads to OnBoarding
          return const SplashScreen();
        }
      },
    );
  }
}
