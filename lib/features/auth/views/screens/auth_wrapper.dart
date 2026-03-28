import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pop/core/utilities/sizes/size_config.dart';
import 'package:pop/features/splash/views/screens/splash_screen.dart';
import 'package:pop/features/home/views/screens/luminous_main_screen.dart';

import 'package:pop/features/auth/views/screens/app_lock_wrapper.dart';

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
          return const AppLockWrapper(child: LuminousMainScreen());
        } else {
          // If no session, show SplashScreen which leads to OnBoarding
          return const SplashScreen();
        }
      },
    );
  }
}
