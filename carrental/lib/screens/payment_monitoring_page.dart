import 'package:flutter/material.dart';

class PaymentMonitoringPage extends StatelessWidget {
  final List<Map<String, dynamic>> payments = [
    {"customer": "John Doe", "car": "Toyota Camry", "status": "Paid"},
    {"customer": "Jane Smith", "car": "Honda Civic", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Monitoring")),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];
          return ListTile(
            title: Text("${payment["customer"]} - ${payment["car"]}"),
            subtitle: Text("Status: ${payment["status"]}"),
            trailing: payment["status"] == "Paid"
                ? Icon(Icons.check, color: Colors.green)
                : Icon(Icons.hourglass_empty, color: Colors.orange),
          );
        },
      ),
    );
  }
}

