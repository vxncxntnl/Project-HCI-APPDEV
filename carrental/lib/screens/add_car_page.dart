import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/car.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({Key? key}) : super(key: key);

  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  void _addCar() async {
    if (_formKey.currentState!.validate()) {
      final carBox = Hive.box<Car>('cars');

      // Create a new Car object
      final newCar = Car(
        id: carBox.length + 1, // Simple ID generation
        name: nameController.text,
        pricePerDay: double.parse(priceController.text),
        isAvailable: true,
        model: modelController.text,
        year: int.tryParse(yearController.text),
        imagePath: '', // You can add image handling later
        imageUrl: '', // You can add image handling later
      );

      // Add the new car to the box
      await carBox.add(newCar);

      // Clear the text fields
      nameController.clear();
      priceController.clear();
      modelController.clear();
      yearController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car added successfully!')),
      );

      // Optionally, navigate back or reset the form
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Car')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Car Name'),
                validator: (value) => value!.isEmpty ? 'Enter car name' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price per Day'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
              ),
              TextFormField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Model'),
                validator: (value) => value!.isEmpty ? 'Enter car model' : null,
              ),
              TextFormField(
                controller: yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter car year' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addCar,
                child: const Text('Add Car'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}