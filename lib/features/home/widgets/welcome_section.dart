import 'package:alprince_carwash/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        const Text(
          'أهلاً بك في',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const Text(
          'مغسلة البرنس',
          style: TextStyle(
            color: AppColors.gold,
            fontSize: 36,
            fontWeight: FontWeight.w900,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'نقدم خدمات غسيل وتلميع السيارات بأعلى معايير الجودة والاحترافية',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Your car deserves nothing but excellence.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textMuted,
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
