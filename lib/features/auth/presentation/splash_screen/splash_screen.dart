
import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/auth/presentation/login/login_page.dart';
import 'package:senior_circle/features/auth/repositories/auth_repository.dart';
import 'package:senior_circle/features/tab/tab.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final AuthRepository _authRepository = AuthRepository();

  void _checkSession(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      final hasSession = _authRepository.hasActiveSession();

      if (hasSession) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TabSelectorWidget()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );  
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkSession(context);

    return Scaffold(
      backgroundColor: AppColors.buttonBlue,
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'Senior Circle',
              textStyle: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
              speed: const Duration(milliseconds: 120),
            ),
          ],
          isRepeatingAnimation: false,
        ),
      ),
    );
  }
}
