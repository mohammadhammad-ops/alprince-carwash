import 'package:alprince_carwash/data/booking_data.dart';
import 'package:alprince_carwash/data/services_data.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import '../../core/theme/app_colors.dart';
import '../auth/auth_service.dart';
import '../home/home_screen.dart';
import 'widgets/booking_service_section.dart';
import 'widgets/booking_schedule_section.dart';
import 'widgets/booking_customer_section.dart';

const Map<String, String> sizeLabels = {
  'small': 'صغيرة',
  'medium': 'متوسطة',
  'large': 'كبيرة',
};

class BookScreen extends StatefulWidget {
  final Map<String, dynamic>? service;
  final String? size;
  const BookScreen({super.key, this.service, this.size});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  Map<String, dynamic>? _selectedService;
  String? _selectedSize;
  DateTime? _selectedDate;
  String? selectedTime;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController carController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool _bookingConfirmed = false;

  bool _bookingForMe = true;

  bool _isPastTime(DateTime date, String time) {
    final now = DateTime.now();

    final parts = time.trim().split(' ');
    if (parts.length != 2) return true;

    final hourMinute = parts[0].split(':');
    if (hourMinute.length != 2) return true;

    int? hour = int.tryParse(hourMinute[0]);
    final minute = int.tryParse(hourMinute[1]);

    if (hour == null ||
        minute == null ||
        hour < 1 ||
        hour > 12 ||
        minute < 0 ||
        minute > 59) {
      return true;
    }

    final period = parts[1];

    if (period == 'م') {
      if (hour != 12) hour += 12;
    } else if (period == 'ص') {
      if (hour == 12) hour = 0;
    } else {
      return true;
    }

    final bookingDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    return !bookingDateTime.isAfter(now);
  }

  Widget _buildTimeSlots() {
    if (_selectedDate == null) {
      return const Text('اختر التاريخ أولاً');
    }

    final dateStr = dateKey(_selectedDate!);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: timeSlots.map((time) {
        final left = slotsLeft(dateStr, time);
        final full = left <= 0;
        final isPast = _isPastTime(_selectedDate!, time);
        final unavailable = full || isPast;

        return ChoiceChip(
          label: Text('$time • متبقي $left'),
          selected: selectedTime == time,

          onSelected: unavailable
              ? null
              : (_) {
                  setState(() {
                    selectedTime = time;
                  });
                },
        );
      }).toList(),
    );
  }

  Future<void> _confirmBooking() async {
    if (_bookingConfirmed) return;

    if (!AuthService().isLoggedIn) {
      final loggedIn = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(returnToBooking: true),
        ),
      );

      if (!mounted || loggedIn != true) return;

      if (_bookingForMe) {
        nameController.text = AuthService().currentUser?.name ?? '';

        phoneController.text = AuthService().currentUser?.phone ?? '';
      }

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تسجيل الدخول، راجع تفاصيل الحجز واضغط تأكيد الحجز'),
        ),
      );
      return;
    }

    // 1) تأكد إنه اختار تاريخ ووقت
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر التاريخ والوقت أولاً')),
      );
      return;
    }

    final date = dateKey(_selectedDate!);

    if (_isPastTime(_selectedDate!, selectedTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('هذا الموعد انتهى، يرجى اختيار وقت آخر')),
      );

      setState(() {
        selectedTime = null;
      });

      return;
    }

    // 2) فحص أخير: يمكن الوقت امتلأ
    if (isSlotFull(date, selectedTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('هاد الوقت امتلأ، اختر وقت ثاني')),
      );
      setState(() => selectedTime = null);
      return;
    }
    if (_selectedService == null || _selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار الخدمة وحجم السيارة')),
      );
      return;
    }
    final price = _selectedService!['prices'][_selectedSize];
    // 3) أضف الحجز

    if (_bookingConfirmed) return;

    _bookingConfirmed = true;

    bookingsData.add({
      'ownerPhone': AuthService().currentUser!.phone,

      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'car': carController.text.trim(),
      'notes': notesController.text.trim(),
      'date': dateKey(_selectedDate!),
      'time': selectedTime,
      'service': _selectedService!['name'],
      'size': _selectedSize,
      'price': price,
    });
    // 4) عرض تفاصيل الحجز بعد التأكيد
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.green),
              SizedBox(width: 8),
              Text('تم تأكيد الحجز'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الخدمة: ${_selectedService!['name']}'),
              Text('الحجم: ${sizeLabels[_selectedSize]}'),
              Text('السعر: $price ₪'),
              Text(
                'التاريخ: ${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}',
              ),
              Text('الوقت: $selectedTime'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.of(this.context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              child: const Text('العودة للرئيسية'),
            ),
          ],
        );
      },
    );
  }

  // اليوم بدون ساعة/دقيقة
  DateTime get _today {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  DateTime get _lastDate {
    final t = _today;
    return DateTime(t.year, t.month, t.day + 30);
  }

  // هل اليوم مسموح؟ (مش عطلة)
  bool _isDayAllowed(DateTime day) {
    return !closedDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }

  // أول يوم متاح، أو null إذا ما في ولا يوم
  DateTime? _firstAllowedDate() {
    var d = _today;
    while (!d.isAfter(_lastDate)) {
      if (_isDayAllowed(d)) return d;
      d = DateTime(d.year, d.month, d.day + 1);
    }
    return null;
  }

  Future<void> _pickDate() async {
    final first = _firstAllowedDate();
    if (first == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد أيام متاحة للحجز حالياً')),
      );
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? first,
      firstDate: _today,
      lastDate: _lastDate,
      selectableDayPredicate: _isDayAllowed,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        selectedTime = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _selectedService = widget.service;
      _selectedSize = widget.size;
    }
    if (AuthService().isLoggedIn) {
      nameController.text = AuthService().currentUser?.name ?? '';

      phoneController.text = AuthService().currentUser?.phone ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    carController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' الحجز')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BookingServiceSection(
                selectedService: _selectedService,
                selectedSize: _selectedSize,
                servicesData: servicesData,
                sizeLabels: sizeLabels,

                onServiceSelected: (service) {
                  setState(() {
                    _selectedService = service;
                  });
                },

                onSizeSelected: (size) {
                  setState(() {
                    _selectedSize = size;
                  });
                },
              ),
              BookingScheduleSection(
                selectedDate: _selectedDate,
                onPickDate: _pickDate,
                timeSlotsWidget: _buildTimeSlots(),
              ),
              const SizedBox(height: 16),
              BookingCustomerSection(
                bookingForMe: _bookingForMe,

                nameController: nameController,
                phoneController: phoneController,
                carController: carController,
                notesController: notesController,

                nameValidator: (v) => _required(v, 'اكتب اسمك'),

                phoneValidator: (value) {
                  final v = value?.trim() ?? '';

                  if (v.isEmpty) {
                    return 'اكتب رقم الهاتف';
                  }

                  if (!RegExp(r'^05\d{8}$').hasMatch(v)) {
                    return 'رقم غير صحيح (مثال: 0599123456)';
                  }

                  return null;
                },

                onBookingForMeChanged: (value) {
                  setState(() {
                    _bookingForMe = value;

                    if (value) {
                      nameController.text =
                          AuthService().currentUser?.name ?? '';

                      phoneController.text =
                          AuthService().currentUser?.phone ?? '';
                    } else {
                      nameController.clear();
                      phoneController.clear();
                    }
                  });
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmBooking,
                  child: const Text('تأكيد الحجز'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
