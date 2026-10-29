List<Map<String, dynamic>> bookingsData = [];

final List<String> timeSlots = [
  // ساعات الدوام
  '9:00 ص', '10:00 ص', '11:00 ص', '12:00 م',
  '1:00 م', '2:00 م', '4:00 م',
  '5:00 م', '6:00 م', '7:00 م',
];

const int maxPerSlot = 3;

bool isSlotFull(String date, String time) {
  return slotsLeft(date, time) <= 0;
}

int slotsLeft(String date, String time) {
  final count = bookingsData.where((b) {
    return b['date'] == date && b['time'] == time && b['status'] != 'ملغي';
  }).length;

  return (maxPerSlot - count).clamp(0, maxPerSlot);
}

String dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

List<DateTime> closedDates = []; // ايام الاغلاق
