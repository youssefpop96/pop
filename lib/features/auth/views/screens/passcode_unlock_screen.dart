import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pop/core/utilities/styles/app_colors.dart';
import 'package:pop/core/utilities/styles/app_text_styles.dart';

class PasscodeUnlockScreen extends StatefulWidget {
  final VoidCallback onUnlock;
  final bool isForSetup; // If true, it just means we are using it for authentication to disable or change.

  const PasscodeUnlockScreen({super.key, required this.onUnlock, this.isForSetup = false});

  @override
  State<PasscodeUnlockScreen> createState() => _PasscodeUnlockScreenState();
}

class _PasscodeUnlockScreenState extends State<PasscodeUnlockScreen> {
  String _enteredCode = '';
  bool _hasError = false;

  void _onKeyPress(String value) async {
    if (_enteredCode.length < 4) {
      setState(() {
        _enteredCode += value;
        _hasError = false;
      });

      if (_enteredCode.length == 4) {
        await _verifyCode();
      }
    }
  }

  void _onBackspace() {
    if (_enteredCode.isNotEmpty) {
      setState(() {
        _enteredCode = _enteredCode.substring(0, _enteredCode.length - 1);
        _hasError = false;
      });
    }
  }

  Future<void> _verifyCode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('app_passcode');

    if (_enteredCode == savedCode) {
      widget.onUnlock();
    } else {
      setState(() {
        _hasError = true;
        _enteredCode = '';
      });
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
        appBar: widget.isForSetup 
           ? AppBar(
               backgroundColor: Colors.transparent,
               elevation: 0,
               leading: Center(
                 child: IconButton(
                   icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.kPrimary, size: 20),
                   onPressed: () => Navigator.pop(context, false),
                 ),
               ),
             )
           : null,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.lock_rounded, color: AppColors.kPrimary, size: 48),
              const SizedBox(height: 24),
              Text(
                'ENTER PASSCODE',
                style: AppTextStyles.headlineLg.copyWith(fontSize: 24, letterSpacing: 4, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              Text(
                _hasError ? 'INCORRECT PASSCODE' : 'TO UNLOCK SECURE DATA',
                style: AppTextStyles.labelMd.copyWith(color: _hasError ? Colors.redAccent : Colors.black45, fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.bold),
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
