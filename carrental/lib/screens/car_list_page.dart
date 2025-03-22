import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/car.dart';
import 'rental_form_page.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({Key? key}) : super(key: key);

  @override
  _CarListPageState createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  late Box<Car>? carBox;

  @override
  void initState() {
    super.initState();
    _openCarBox();
  }

  Future<void> _openCarBox() async {
    if (!Hive.isBoxOpen('cars')) {
      carBox = await Hive.openBox<Car>('cars');
    } else {
      carBox = Hive.box<Car>('cars');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Cars for Rent')),
      body: carBox == null || !carBox!.isOpen
          ? const Center(child: CircularProgressIndicator())
          : ValueListenableBuilder(
              valueListenable: carBox!.listenable(),
              builder: (context, Box<Car> box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('No cars available.'));
                }

                // Get available and rented cars
                List<Car> availableCars = box.values.where((car) => car.isAvailable).toList();
                List<Car> rentedCars = box.values.where((car) => !car.isAvailable).toList();

                // Remove duplicates from rented cars
                List<Car> uniqueRentedCars = [];
                Set<String> seenCarNames = {};
                for (var car in rentedCars) {
                  if (!seenCarNames.contains(car.name)) {
                    seenCarNames.add(car.name);
                    uniqueRentedCars.add(car);
                  }
                }

                return ListView(
                  padding: const EdgeInsets.all(10),
                  children: [
                    // Available Cars section
                    if (availableCars.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Available Cars', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      ...availableCars.map((car) => _buildCarCard(car, true)).toList(),
                    ],
                    // Rented Cars section
                    if (uniqueRentedCars.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Rented Cars', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      ...uniqueRentedCars.map((car) => _buildCarCard(car, false)).toList(),
                    ],
                  ],
                );
              },
            ),
    );
  }

  // Build car card UI
  Widget _buildCarCard(Car car, bool isAvailable) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCarImage(car),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(car.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      _getCarDetails(car),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₱${car.pricePerDay.toStringAsFixed(2)} / day',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                isAvailable
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RentalFormPage(car: car),
                            ),
                          );
                        },
                        child: const Text('Rent'),
                      )
                    : Column(
                        children: [
                          Text(
                            'Status: ${car.isPaid ? "Paid" : "Pending"}',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: car.isPaid ? Colors.green : Colors.red),
                          ),
                          if (!car.isPaid)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  car.isPaid = true;
                                  car.save();
                                });
                              },
                              child: const Text('Mark as Paid'),
                            ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to display the car image
  Widget _buildCarImage(Car car) {
    String imagePath = 'assets/images/${car.imagePath}';

    if (car.imagePath.isEmpty) {
      return const Icon(Icons.directions_car, size: 80, color: Colors.grey);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imagePath,
        width: 100,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, size: 80, color: Colors.red);
        },
      ),
    );
  }

  // Function to get detailed car information
  Widget _getCarDetails(Car car) {
    switch (car.name.toLowerCase()) {
      case "toyota fortuner":
        return const Text(
          "🚗 Model: 2022\n🛠️ Engine: 2.8L Diesel\n🔧 Transmission: Automatic\n👥 Seats: 7\n⛽ Fuel: Diesel",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        );
      case "toyota hiace":
        return const Text(
          "🚐 Model: 2025\n🛠️ Engine: 3.0L Diesel\n🔧 Transmission: Automatic\n👥 Seats: 15\n⛽ Fuel: Diesel",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        );
      case "toyota hilux":
        return const Text(
          "🛻 Model: Hilux Conquest\n🛠️ Engine: 2.8L Turbo Diesel\n🔧 Transmission: Automatic\n👥 Seats: 5\n⛽ Fuel: Diesel",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        );
      case "toyota land cruiser":
        return const Text(
          "🚙 Model: 2024\n🛠️ Engine: 3.3L V6 Diesel\n🔧 Transmission: Automatic\n👥 Seats: 7\n⛽ Fuel: Diesel",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        );
      default:
        return const Text(
          "ℹ️ No details available",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        );
    }
  }
}
