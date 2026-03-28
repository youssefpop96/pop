import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class PasscodeSetupScreen extends StatefulWidget {
  const PasscodeSetupScreen({super.key});

  @override
  State<PasscodeSetupScreen> createState() => _PasscodeSetupScreenState();
}

class _PasscodeSetupScreenState extends State<PasscodeSetupScreen> {
  String _enteredCode = '';

  void _onKeyPress(String value) {
    if (_enteredCode.length < 4) {
      setState(() {
        _enteredCode += value;
      });

      if (_enteredCode.length == 4) {
        _saveCode();
      }
    }
  }

  void _onBackspace() {
    if (_enteredCode.isNotEmpty) {
      setState(() {
        _enteredCode = _enteredCode.substring(0, _enteredCode.length - 1);
      });
    }
  }

  Future<void> _saveCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_passcode', _enteredCode);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('APP LOCK SECURED'),
          backgroundColor: AppColors.kPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true); // true indicates successful setup
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
            'SETUP PASSCODE',
            style: AppTextStyles.headlineLg.copyWith(fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.w900),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.security_rounded, color: AppColors.kPrimary, size: 48),
              const SizedBox(height: 24),
              Text(
                'CREATE PASSCODE',
                style: AppTextStyles.headlineLg.copyWith(fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Text(
                'ENTER 4 DIGITS FOR APP LOCK',
                style: AppTextStyles.labelMd.copyWith(color: Colors.black45, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _enteredCode.length > index ? AppColors.kPrimary : Colors.black12,
                    ),
                  );
                }),
              ),
              const Spacer(),
              _buildKeyboard(),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80),
            _buildKey('0'),
            SizedBox(
              width: 80,
              child: GestureDetector(
                onTap: _onBackspace,
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Center(child: Icon(Icons.backspace_rounded, size: 28, color: Colors.black45)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String value) {
    return GestureDetector(
      onTap: () => _onKeyPress(value),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            value,
            style: AppTextStyles.headlineLg.copyWith(fontSize: 28, color: AppColors.kPrimary),
          ),
        ),
      ),
    );
  }
}
