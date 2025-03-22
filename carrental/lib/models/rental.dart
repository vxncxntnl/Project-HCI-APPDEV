import 'package:hive/hive.dart';

part 'rental.g.dart';

@HiveType(typeId: 1)
class Rental extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String customerName;

  @HiveField(2)
  final String contactNumber;

  @HiveField(3)
  final int duration; // Duration of rental in days

  @HiveField(4)
  bool isPaid; // Payment status

  @HiveField(5)
  final int carId; // ID of rented car

  @HiveField(6)
  final double totalCost; // Total cost of rental

  @HiveField(7)
  final String paymentMethod; // Payment method

  Rental({
    required this.id,
    required this.customerName,
    required this.contactNumber,
    required this.duration,
    required this.isPaid,
    required this.carId,
    required this.totalCost,
    required this.paymentMethod,
  });
}