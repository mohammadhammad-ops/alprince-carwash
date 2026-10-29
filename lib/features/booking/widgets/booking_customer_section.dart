import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';

class BookingCustomerSection extends StatelessWidget {
  BookingCustomerSection({
    super.key,
    required this.bookingForMe,
    required this.onBookingForMeChanged,
    required this.nameController,
    required this.phoneController,
    required this.carController,
    required this.notesController,
    required this.nameValidator,
    required this.phoneValidator,
  });

  final bool bookingForMe;

  final ValueChanged<bool> onBookingForMeChanged;

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController carController;
  final TextEditingController notesController;

  final String? Function(String?) nameValidator;
  final String? Function(String?) phoneValidator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.person_outline, color: AppColors.gold),
            SizedBox(width: 8),
            Text(
              'بيانات العميل',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 8),

        const Divider(),

        const SizedBox(height: 16),

        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: bookingForMe,
          title: const Text('استخدام بيانات حسابي'),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (value) {
            onBookingForMeChanged(value!);
          },
        ),

        TextFormField(
          controller: nameController,
          readOnly: bookingForMe,
          decoration: const InputDecoration(labelText: 'الاسم الكامل'),
          validator: nameValidator,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: phoneController,
          readOnly: bookingForMe,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          decoration: const InputDecoration(labelText: 'رقم الهاتف'),
          validator: phoneValidator,
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: carController,
          decoration: const InputDecoration(labelText: 'اسم / موديل السيارة'),
        ),

        const SizedBox(height: 16),

        TextFormField(
          controller: notesController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'ملاحظات إضافية'),
        ),
      ],
    );
  }
}
