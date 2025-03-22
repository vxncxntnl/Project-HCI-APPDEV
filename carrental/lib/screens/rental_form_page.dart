import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/car.dart';
import '../models/rental.dart';
import '../services/rental_service.dart';

class RentalFormPage extends StatefulWidget {
  final Car car;

  const RentalFormPage({Key? key, required this.car}) : super(key: key);

  @override
  _RentalFormPageState createState() => _RentalFormPageState();
}

class _RentalFormPageState extends State<RentalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController rentalDaysController = TextEditingController();
  final RentalService rentalService = RentalService();

  String? selectedPaymentMethod;
  final List<String> paymentMethods = ['Cash', 'Credit Card', 'Gcash', 'PayPal'];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      var rental = Rental(
        id: rentalService.rentalBox.isEmpty ? 1 : rentalService.rentalBox.keys.cast<int>().last + 1,
        customerName: nameController.text,
        contactNumber: contactController.text,
        duration: int.parse(rentalDaysController.text),
        isPaid: false,
        carId: widget.car.id,
        totalCost: widget.car.pricePerDay * int.parse(rentalDaysController.text),
        paymentMethod: selectedPaymentMethod ?? '',
      );

      rentalService.addRental(rental);

      // Update car availability
      setState(() {
        widget.car.isAvailable = false; // Mark the car as rented
        widget.car.save(); // Save the updated state
      });

      // Clear fields
      nameController.clear();
      contactController.clear();
      rentalDaysController.clear();
      setState(() => selectedPaymentMethod = null);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rental confirmed!')),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rent ${widget.car.name}')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car: ${widget.car.name}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(nameController, 'Your Name', Icons.person),
                    _buildTextField(contactController, 'Contact Number', Icons.phone, isNumber: true),
                    _buildTextField(rentalDaysController, 'Rental Duration (Days)', Icons.calendar_today, isNumber: true),
                    const SizedBox(height: 10),
                    
                    DropdownButtonFormField<String>(
                      value: selectedPaymentMethod,
                      decoration: _inputDecoration('Payment Method', Icons.payment),
                      items: paymentMethods.map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedPaymentMethod = value),
                      validator: (value) => value == null ? 'Please select a payment method' : null,
                    ),
                    
                    const SizedBox(height: 20),
                    // Display total cost
                    Text(
                      'Total Cost: ₱${_calculateTotalCost()}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: _submitForm,
                        child: const Text('Confirm Rental', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Calculate total cost based on rental days
  String _calculateTotalCost() {
    if (rentalDaysController.text.isNotEmpty) {
      int rentalDays = int.parse(rentalDaysController.text);
      double totalCost = widget.car.pricePerDay * rentalDays;
      return totalCost.toStringAsFixed(2);
    }
    return '0.00';
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: _inputDecoration(label, icon),
        validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
        onChanged: (value) {
          // Recalculate total cost when rental days change
          setState(() {});
        },
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}