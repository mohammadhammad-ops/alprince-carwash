import 'package:alprince_carwash/features/booking/book_screen.dart';
import 'package:flutter/material.dart';
import 'package:alprince_carwash/core/theme/app_colors.dart';


class ServiceCard extends StatefulWidget {
  final Map<String, dynamic> service;
  const ServiceCard({super.key, required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  String selectedSize = 'medium';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> prices = widget.service['prices'];
    final int currentPrice = prices[selectedSize];
    final List<dynamic> features = widget.service['features'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark3,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── الصف العلوي: إيموجي + تاغ ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.service['emoji'],
                style: const TextStyle(fontSize: 30),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.service['tag'],
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Text(
            widget.service['name'],
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.service['nameEn'],
            style: const TextStyle(
              color: AppColors.goldLight,
              fontSize: 11,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.service['description'],
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // ── قائمة المميزات ──
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: AppColors.gold),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      f,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── أزرار الحجم ──
          Row(
            children: prices.keys.map((size) {
              final bool isSelected = size == selectedSize;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: GestureDetector(
                  onTap: () => setState(() => selectedSize = size),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.gold : AppColors.dark4,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      size == 'small'
                          ? 'صغيرة'
                          : size == 'medium'
                          ? 'متوسطة'
                          : 'كبيرة',
                      style: TextStyle(
                        color: isSelected ? AppColors.black : AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // ── السعر + زر الحجز ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentPrice ₪',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookScreen(
                        service: widget.service,
                        size: selectedSize,
                      ),
                    ),
                  );
                },

                child: const Text('احجز الان'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
