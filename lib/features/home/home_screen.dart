//import 'package:alprince_carwash/features/auth/login_screen.dart';
import 'package:alprince_carwash/features/home/widgets/feature_section.dart';
import 'package:alprince_carwash/features/home/widgets/home_buttons.dart';
import 'package:alprince_carwash/features/home/widgets/home_state.dart';
import 'package:alprince_carwash/features/profile/profile_screen.dart';
import 'package:alprince_carwash/features/shop/shopping-screen.dart';
import 'package:flutter/material.dart';
import 'package:alprince_carwash/core/theme/app_colors.dart';

import 'widgets/welcome_section.dart';
import '../shared/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: Builder(
          builder: (buttonContext) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.text),
            onPressed: () => Scaffold.of(buttonContext).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold, width: 0.5),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/gold2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(width: 1, height: 30, color: AppColors.border),
            const SizedBox(width: 10),
            const Text(
              'مغسلة البرنس',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.text,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: AppColors.text),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: AppColors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const WelcomeSection(),
              const SizedBox(height: 32),
              const HomeButtons(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const HomeState(number: '+5K', label: 'عميل سعيد'),
                  Container(width: 1, height: 30, color: AppColors.border),
                  const HomeState(number: '4+', label: 'سنوات خبرة'),
                  Container(width: 1, height: 30, color: AppColors.border),
                  const HomeState(number: '100%', label: 'ضمان الجودة'),
                  /*     ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text('تسجيل الدخول'),
                  ),*/
                ],
              ),
              FeatureSection(),
            ],
          ),
        ),
      ),
    );
  }
}
