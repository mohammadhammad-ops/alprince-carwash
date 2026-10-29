class BookingModel {
  final String serviceName;
  final String carSize;
  final double price;
  final String date;
  final String time;
  final String status;

  const BookingModel({
    required this.serviceName,
    required this.carSize,
    required this.price,
    required this.date,
    required this.time,
    required this.status,
  });
}