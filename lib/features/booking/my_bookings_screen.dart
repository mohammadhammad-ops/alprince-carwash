import 'package:flutter/material.dart';

import '../../data/booking_data.dart';
import '../../models/booking_model.dart';
import '../auth/auth_service.dart';
import 'booking_details_screen.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerPhone = AuthService().currentUser?.phone;

    final myBookings = bookingsData
        .where((booking) {
          return ownerPhone != null && booking['ownerPhone'] == ownerPhone;
        })
        .toList()
        .reversed
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('حجوزاتي'), centerTitle: true),
      body: myBookings.isEmpty
          ? const Center(
              child: Text(
                'لا يوجد لديك حجوزات حتى الآن',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: myBookings.length,
              itemBuilder: (context, index) {
                final data = myBookings[index];

                final booking = BookingModel(
                  serviceName: data['service']?.toString() ?? '',
                  carSize:
                      const {
                        'small': 'صغيرة',
                        'medium': 'متوسطة',
                        'large': 'كبيرة',
                      }[data['size']] ??
                      data['size']?.toString() ??
                      '',
                  price: (data['price'] as num).toDouble(),
                  date: data['date']?.toString() ?? '',
                  time: data['time']?.toString() ?? '',
                  status: data['status']?.toString() ?? 'مؤكد',
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      child: Icon(Icons.local_car_wash),
                    ),
                    title: Text(
                      booking.serviceName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('📅 ${booking.date}'),
                          Text('🕒 ${booking.time}'),
                          Text('🚗 ${booking.carSize}'),
                          Text('💰 ${booking.price} ₪'),
                          Text('الحالة: ${booking.status}'),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),

                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingDetailsScreen(
                            booking: booking,
                            bookingData: data,
                          ),
                        ),
                      );

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyBookingsScreen(),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
