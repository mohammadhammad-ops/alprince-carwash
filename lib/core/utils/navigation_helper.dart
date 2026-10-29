import 'package:flutter/material.dart';
import '../../features/auth/auth_service.dart';
import '../../features/auth/login_screen.dart';

class NavigationHelper {

  static Future<bool> requireLogin(BuildContext context) async {

    if (AuthService().isLoggedIn) {
      return true;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );

    return AuthService().isLoggedIn;
  }

}