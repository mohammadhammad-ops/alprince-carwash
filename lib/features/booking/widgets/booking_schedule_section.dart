import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class BookingScheduleSection extends StatelessWidget {
  const BookingScheduleSection({
    super.key,
    required this.selectedDate,
    required this.onPickDate,
    required this.timeSlotsWidget,
  });

  final DateTime? selectedDate;
  final VoidCallback onPickDate;
  final Widget timeSlotsWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: AppColors.gold,
            ),
            SizedBox(width: 8),
            Text(
              'موعد الحجز',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        const Divider(),

        const SizedBox(height: 16),

        InkWell(
          onTap: onPickDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text(
                  selectedDate == null
                      ? 'اختر التاريخ'
                      : '${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}',
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        timeSlotsWidget,
      ],
    );
  }
}