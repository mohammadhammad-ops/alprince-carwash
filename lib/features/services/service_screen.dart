import 'package:flutter/material.dart';
import 'package:alprince_carwash/data/services_data.dart';
import 'package:alprince_carwash/features/services/widgets/service_card.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خدماتنا')),
      body: ListView.builder(
        itemCount: servicesData.length,
        itemBuilder: (context, index) {
          return ServiceCard(service: servicesData[index]);
        },
      ),
    );
  }
}
