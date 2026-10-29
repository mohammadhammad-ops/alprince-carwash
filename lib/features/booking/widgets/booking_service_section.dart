import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class BookingServiceSection extends StatelessWidget {
  const BookingServiceSection({
    super.key,
    required this.selectedService,
    required this.selectedSize,
    required this.servicesData,
    required this.sizeLabels,
    required this.onServiceSelected,
    required this.onSizeSelected,
  });

  final Map<String, dynamic>? selectedService;
  final String? selectedSize;

  final List<Map<String, dynamic>> servicesData;
  final Map<String, String> sizeLabels;

  final ValueChanged<Map<String, dynamic>?> onServiceSelected;
  final ValueChanged<String?> onSizeSelected;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.local_car_wash, color: AppColors.gold, size: 24),
            SizedBox(width: 8),
            Text(
              'تفاصيل الحجز',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 8),

        const Divider(),

        const SizedBox(height: 16),
        // إذا فيه خدمة وحجم مختارين، نعرض بطاقة الملخص
        if (selectedService != null && selectedSize != null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedService!['emoji']} ${selectedService!['name']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('السعر: ${selectedService!['prices'][selectedSize]} ₪'),
                  const SizedBox(height: 8),
                  Text(
                    selectedService!['description'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // اختيار الخدمة - يظهر دايماً
        const Text(
          'اختر الخدمة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: servicesData.map((service) {
            final isSelected = selectedService == service;
            return ChoiceChip(
              label: Text(service['name']),
              selected: isSelected,
              onSelected: (selected) {
                onServiceSelected(selected ? service : null);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // اختيار الحجم - يظهر دايماً
        const Text('اختر الحجم', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sizeLabels.entries.map((entry) {
            final isSelected = selectedSize == entry.key;
            return ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (selected) {
                onSizeSelected(selected ? entry.key : null);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
