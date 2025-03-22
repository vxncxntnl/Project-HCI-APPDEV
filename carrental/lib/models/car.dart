import 'package:hive/hive.dart';

part 'car.g.dart';

@HiveType(typeId: 0)
class Car extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double pricePerDay;

  @HiveField(3)
  bool isAvailable;

  @HiveField(4)
  String model;

  @HiveField(5)
  int? year;

  @HiveField(6)
  String imagePath;

  @HiveField(7)
  String imageUrl;

  @HiveField(8)
  String? rentedBy;

  @HiveField(9)
  int rentalDays; // ✅ Add rentalDays

  @HiveField(10)
  bool isPaid; // ✅ Add isPaid

  Car({
    required this.id,
    required this.name,
    required this.pricePerDay,
    required this.isAvailable,
    required this.model,
    this.year,
    required this.imagePath,
    required this.imageUrl,
    this.rentedBy,
    this.rentalDays = 0, // ✅ Default to 0
    this.isPaid = false, // ✅ Default to false
  });

  // ✅ Add copyWith() method here
  Car copyWith({
    int? id,
    String? name,
    double? pricePerDay,
    bool? isAvailable,
    String? model,
    int? year,
    String? imagePath,
    String? imageUrl,
    String? rentedBy,
    int? rentalDays,
    bool? isPaid,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      isAvailable: isAvailable ?? this.isAvailable,
      model: model ?? this.model,
      year: year ?? this.year,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      rentedBy: rentedBy ?? this.rentedBy,
      rentalDays: rentalDays ?? this.rentalDays,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  // Method to calculate total rental cost
  double calculateTotalCost() {
    return pricePerDay * rentalDays;
  }
}