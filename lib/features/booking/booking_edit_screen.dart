
import 'package:flutter/material.dart';

import '../../data/booking_data.dart';

class BookingEditScreen extends StatefulWidget {
  final Map<String, dynamic> bookingData;

  const BookingEditScreen({
    super.key,
    required this.bookingData,
  });

  @override
  State<BookingEditScreen> createState() =>
      _BookingEditScreenState();
}

class _BookingEditScreenState extends State<BookingEditScreen> {
  DateTime? selectedDate;
  String? selectedTime;
  bool isSaving = false;

  DateTime get today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get lastDate {
    return today.add(const Duration(days: 30));
  }

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.tryParse(
      widget.bookingData['date']?.toString() ?? '',
    );

    selectedTime = widget.bookingData['time']?.toString();
  }

  bool isDayAllowed(DateTime date) {
    return !closedDates.any(
      (d) =>
          d.year == date.year &&
          d.month == date.month &&
          d.day == date.day,
    );
  }

  bool isPastTime(DateTime date, String time) {
    final parts = time.trim().split(RegExp(r'\s+'));

    if (parts.length != 2) return true;

    final hm = parts[0].split(':');

    if (hm.length != 2) return true;

    int? hour = int.tryParse(hm[0]);
    final minute = int.tryParse(hm[1]);

    if (hour == null ||
        minute == null ||
        hour < 1 ||
        hour > 12 ||
        minute < 0 ||
        minute > 59) {
      return true;
    }

    if (parts[1] == 'م') {
      if (hour != 12) hour += 12;
    } else if (parts[1] == 'ص') {
      if (hour == 12) hour = 0;
    } else {
      return true;
    }

    final appointment = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    return !appointment.isAfter(DateTime.now());
  }

  int availableSlots(String date, String time) {
    final count = bookingsData.where((booking) {
      if (identical(booking, widget.bookingData)) {
        return false;
      }

      return booking['date'] == date &&
          booking['time'] == time &&
          booking['status'] != 'ملغي';
    }).length;

    return (maxPerSlot - count).clamp(0, maxPerSlot);
  }

  Future<void> pickDate() async {
    DateTime? initial = selectedDate;

    if (initial == null ||
        initial.isBefore(today) ||
        initial.isAfter(lastDate) ||
        !isDayAllowed(initial)) {
      initial = today;
    }

    if (!isDayAllowed(initial)) {
      DateTime? found;

      for (var i = 0; i <= 30; i++) {
        final candidate = today.add(Duration(days: i));

        if (isDayAllowed(candidate)) {
          found = candidate;
          break;
        }
      }

      if (found == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('لا توجد أيام متاحة للحجز'),
          ),
        );
        return;
      }

      initial = found;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: lastDate,
      selectableDayPredicate: isDayAllowed,
    );

    if (!mounted || picked == null) return;

    setState(() {
      if (selectedDate == null ||
          dateKey(selectedDate!) != dateKey(picked)) {
        selectedTime = null;
      }

      selectedDate = picked;
    });
  }

  void saveChanges() {
    if (isSaving) return;

    if (!bookingsData.any(
      (b) => identical(b, widget.bookingData),
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الحجز غير موجود'),
        ),
      );
      return;
    }

    if (widget.bookingData['status'] == 'ملغي') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن تعديل حجز ملغي'),
        ),
      );
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار التاريخ والوقت'),
        ),
      );
      return;
    }

    final date = selectedDate!;
    final time = selectedTime!;

    if (date.isBefore(today) ||
        date.isAfter(lastDate) ||
        !isDayAllowed(date) ||
        isPastTime(date, time) ||
        !timeSlots.contains(time)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الموعد غير متاح، اختر موعدًا آخر'),
        ),
      );
      return;
    }

    final dateString = dateKey(date);

    if (availableSlots(dateString, time) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('هذا الموعد ممتلئ'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    widget.bookingData['date'] = dateString;
    widget.bookingData['time'] = time;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final dateString = selectedDate == null
        ? null
        : dateKey(selectedDate!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل موعد الحجز'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختيار التاريخ الجديد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: pickDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                selectedDate == null
                    ? 'اختر التاريخ'
                    : dateKey(selectedDate!),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'اختيار الوقت الجديد',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            if (dateString == null)
              const Text('اختر التاريخ أولاً')
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: timeSlots.map((time) {
                  final left = availableSlots(
                    dateString,
                    time,
                  );

                  final unavailable = left <= 0 ||
                      isPastTime(selectedDate!, time) ||
                      !isDayAllowed(selectedDate!);

                  return ChoiceChip(
                    label: Text(
                      '$time • متبقي $left',
                    ),
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
              ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isSaving ? null : saveChanges,
                icon: const Icon(Icons.save),
                label: const Text('حفظ التعديلات'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
