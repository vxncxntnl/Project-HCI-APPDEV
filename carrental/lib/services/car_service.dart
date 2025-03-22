import 'package:hive/hive.dart';
import '../models/car.dart';
import '../models/rental.dart';

class CarService {
  final Box<Car> carBox = Hive.box<Car>('cars');
  final Box<Rental> rentalBox = Hive.box<Rental>('rentals');

  // Fetch all available cars
  List<Car> getAvailableCars() {
    return carBox.values.where((car) => car.isAvailable).toList();
  }

  // Rent a car
  void rentCar(int key, String renterName, int rentalDays, String contactNumber) {
    final car = carBox.get(key);

    if (car == null) {
      print('Car not found');
      return;
    }

    if (!car.isAvailable) {
      print('Car is not available for rent');
      return;
    }

    double totalCost = car.pricePerDay * rentalDays;

    final rental = Rental(
      id: rentalBox.isEmpty ? 1 : rentalBox.keys.cast<int>().last + 1, // Ensure unique ID
      customerName: renterName,
      contactNumber: contactNumber,
      duration: rentalDays,
      isPaid: false,
      carId: car.id,
      totalCost: totalCost,
      paymentMethod: "Pending", // Assuming you want to set a default payment method
    );

    rentalBox.put(rental.id, rental);

    // Update car availability and assign renter's name
    final updatedCar = car.copyWith(isAvailable: false, rentedBy: renterName);
    carBox.put(car.id, updatedCar);
  }

  // Fetch all rented cars
  List<Car> getRentedCars() {
    return carBox.values.where((car) => !car.isAvailable).toList();
  }
}