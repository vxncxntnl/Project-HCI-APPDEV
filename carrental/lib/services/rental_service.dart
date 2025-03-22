import 'package:hive/hive.dart';
import '../models/rental.dart';
import '../models/car.dart';

class RentalService {
  final Box<Rental> rentalBox = Hive.box<Rental>('rentals');
  final Box<Car> carBox = Hive.box<Car>('cars');

  // Method to add a rental
  void addRental(Rental rental) {
    rentalBox.put(rental.id, rental);

    // Get the car associated with the rental
    var car = carBox.get(rental.carId);
    if (car != null) {
      // Create an updated car instance
      var updatedCar = car.copyWith(
        isAvailable: false, // Mark car as unavailable when rented
        rentedBy: rental.customerName, // Store the customer name
        rentalDays: rental.duration, // Store rental duration
        isPaid: false, // Set to false initially until paid
      );

      // Save updated car details in Hive
      carBox.put(car.id, updatedCar);
    } else {
      // Handle the case where the car is not found
      print('Car with ID ${rental.carId} not found.');
    }
  }

  // Method to get all rentals
  List<Rental> getAllRentals() {
    return rentalBox.values.toList();
  }
}