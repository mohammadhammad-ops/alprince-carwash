import 'package:flutter/material.dart';

import 'booking_edit_screen.dart';
import '../../data/booking_data.dart';
import '../../models/booking_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  final Map<String, dynamic> bookingData;

  const BookingDetailsScreen({
    super.key,
    required this.booking,
    required this.bookingData,
  });

  Future<void> _cancelBooking(BuildContext context) async {
    if (bookingData['status'] == 'ملغي') return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إلغاء الحجز'),
        content: const Text('هل أنت متأكد أنك تريد إلغاء هذا الحجز؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('رجوع'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text(
              'تأكيد الإلغاء',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // التأكد أن الحجز ما زال موجودًا
    if (!bookingsData.contains(bookingData)) return;

    bookingData['status'] = 'ملغي';

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم إلغاء الحجز بنجاح')));

    // العودة لصفحة حجوزاتي
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تفاصيل الحجز"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_car_wash),
                title: const Text("الخدمة"),
                subtitle: Text(booking.serviceName),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text("حجم السيارة"),
                subtitle: Text(booking.carSize),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text("السعر"),
                subtitle: Text("${booking.price} ₪"),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text("التاريخ"),
                subtitle: Text(booking.date),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("الوقت"),
                subtitle: Text(booking.time),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("الحالة"),
                subtitle: Text(booking.status),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: bookingData['status'] == 'ملغي'
                    ? null
                    : () async {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BookingEditScreen(bookingData: bookingData),
                          ),
                        );

                        if (!context.mounted) return;

                        if (updated == true) {
                          Navigator.pop(context, true);
                        }
                      },

                icon: const Icon(Icons.edit),
                label: const Text("تعديل الحجز"),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: bookingData['status'] == 'ملغي'
                    ? null
                    : () => _cancelBooking(context),
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  "إلغاء الحجز",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
