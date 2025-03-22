import 'package:flutter/material.dart';
import '../services/car_service.dart';
import '../services/rental_service.dart';
import '../models/car.dart';
import '../models/rental.dart';

class CarStatusPage extends StatefulWidget {
  @override
  _CarStatusPageState createState() => _CarStatusPageState();
}

class _CarStatusPageState extends State<CarStatusPage> {
  final carService = CarService();
  final rentalService = RentalService();
  List<Car> allCars = [];
  Map<int, String> rentedCarOwners = {}; // Map to store renter names
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Simulate loading delay
      allCars = carService.carBox.values.toList(); // Fetch all cars

      // Fetch rental info for rented cars
      for (var car in allCars) {
        if (!car.isAvailable) {
          Rental? rental = rentalService.rentalBox.values.firstWhere(
            (r) => r.carId == car.id,
            orElse: () => Rental(
              id: -1,
              customerName: "Unknown",
              contactNumber: "",
              duration: 0,
              isPaid: false,
              carId: car.id,
              totalCost: 0,
              paymentMethod: "",
            ),
          );
          if (rental.id != -1) {
            rentedCarOwners[car.id] = rental.customerName;
          }
        }
      }
    } catch (e) {
      errorMessage = 'Failed to load cars: $e';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Car Status")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
              : allCars.isEmpty
                  ? const Center(child: Text("No cars available."))
                  : ListView.builder(
                      itemCount: allCars.length,
                      itemBuilder: (context, index) {
                        final car = allCars[index];
                        bool isRented = !car.isAvailable;
                        String renterName = rentedCarOwners[car.id] ?? "Unknown";

                        return ListTile(
                          title: Text(car.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("₱${car.pricePerDay.toStringAsFixed(2)} per day"),
                              if (isRented) Text("Rented by: $renterName", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                          trailing: isRented
                              ? const Icon(Icons.close, color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                        );
                      },
                    ),
    );
  }
}
