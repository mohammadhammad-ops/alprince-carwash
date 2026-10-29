import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FeatureCard extends StatelessWidget {
  final Map<String, String> feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark3,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(feature['icon']!, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(
            feature['nameAr']!,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            feature['nameEn']!,
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 10,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature['desc']!,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}