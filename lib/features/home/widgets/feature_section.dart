import 'package:alprince_carwash/features/home/widgets/feature_card.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FeatureSection extends StatelessWidget {
  FeatureSection({super.key});
  final features = [
    {
      'icon': '⚡',
      'nameAr': 'سرعة فائقة',
      'nameEn': 'Lightning Fast',
      'desc': 'نحترم وقتك — خدمة سريعة دون المساس بالجودة',
    },
    {
      'icon': '💎',
      'nameAr': 'جودة استثنائية',
      'nameEn': 'Premium Quality',
      'desc': 'منتجات عالمية عالية الجودة ومعدات احترافية',
    },
    {
      'icon': '🛡️',
      'nameAr': 'ضمان الرضا',
      'nameEn': 'Guaranteed',
      'desc': 'لست راضياً؟ نعيد الخدمة مجاناً',
    },
    {
      'icon': '🌿',
      'nameAr': 'صديق للبيئة',
      'nameEn': 'Eco-Friendly',
      'desc': 'منتجات آمنة بيئياً وأنظمة توفير المياه',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.dark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
        children: features.map((f) => FeatureCard(feature: f)).toList(),
      ),
    );
  }
}
