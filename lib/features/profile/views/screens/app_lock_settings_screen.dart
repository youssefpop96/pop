import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';
import 'package:pop/features/profile/views/screens/passcode_setup_screen.dart';
import 'package:pop/features/auth/views/screens/passcode_unlock_screen.dart';

class AppLockSettingsScreen extends StatefulWidget {
  const AppLockSettingsScreen({super.key});

  @override
  State<AppLockSettingsScreen> createState() => _AppLockSettingsScreenState();
}

class _AppLockSettingsScreenState extends State<AppLockSettingsScreen> {
  bool _isAppLockEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('app_passcode');
    if (mounted) {
      setState(() {
        _isAppLockEnabled = savedCode != null && savedCode.isNotEmpty;
      });
    }
  }

  Future<void> _toggleAppLock(bool value) async {
    if (value) {
      // Enable App Lock -> Push to Setup Screen
      final bool? success = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PasscodeSetupScreen()),
      );
      if (success == true) {
        setState(() => _isAppLockEnabled = true);
      }
    } else {
      // Disable App Lock -> Requires confirmation of current passcode
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasscodeUnlockScreen(
            isForSetup: true,
            onUnlock: () async {
              Navigator.pop(context); // Pop unlock screen
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('app_passcode');
              if (mounted) {
                setState(() => _isAppLockEnabled = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('APP LOCK DISABLED'),
                    backgroundColor: Colors.black45,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kBackground,
        gradient: LinearGradient(
          colors: [AppColors.kBackground, AppColors.kSurfaceLow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Center(
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.kPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Text(
            'SECURITY',
            style: AppTextStyles.headlineLg.copyWith(fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('APP LOCK & SECURITY', style: AppTextStyles.labelMd.copyWith(letterSpacing: 2, color: Colors.black26, fontSize: 10, fontWeight: FontWeight.w900)),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.kPrimary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.fingerprint_rounded, color: AppColors.kPrimary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Text('PASSCODE LOCK', style: AppTextStyles.headlineSm.copyWith(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
                          ],
                        ),
                        CupertinoSwitch(
                          value: _isAppLockEnabled,
                          activeTrackColor: AppColors.kPrimary,
                          onChanged: _toggleAppLock,
                        ),
                      ],
                    ),
                    if (_isAppLockEnabled) ...[
                      const Divider(height: 32, color: Colors.black12),
                      GestureDetector(
                        onTap: () async {
                           // Navigate to unlock before changing
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasscodeUnlockScreen(
                                isForSetup: true,
                                onUnlock: () async {
                                  Navigator.pop(context); // Pop unlock screen
                                  // Open setup screen
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PasscodeSetupScreen()),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.password_rounded, color: Colors.black45, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Text('CHANGE PASSCODE', style: AppTextStyles.labelMd.copyWith(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black26, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'When enabled, you will be required to enter a 4-digit passcode every time you launch or resume the application, ensuring that your private notes and thoughts are securely protected from unauthorized access.',
                style: AppTextStyles.labelMd.copyWith(color: Colors.black45, height: 1.5, fontSize: 11),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
