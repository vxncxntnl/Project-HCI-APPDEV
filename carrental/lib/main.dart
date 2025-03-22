import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/car.dart';
import 'models/rental.dart';
import 'screens/car_list_page.dart';
import 'screens/add_car_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(CarAdapter());
  Hive.registerAdapter(RentalAdapter());

  var carBox = await Hive.openBox<Car>('cars');
  await Hive.openBox<Rental>('rentals');

  // Add default cars only if the box is empty
  if (carBox.isEmpty) {
    carBox.addAll([
      Car(id: 1, name: "Toyota Hiace", pricePerDay: 4500, isAvailable: true, model: '', year: null, imagePath: 'hiace.jpg', imageUrl: ''),
      Car(id: 2, name: "Toyota Fortuner", pricePerDay: 3500, isAvailable: true, model: '', year: null, imagePath: 'fortuner.jpg', imageUrl: ''),
      Car(id: 3, name: "Toyota Hilux", pricePerDay: 3000, isAvailable: true, model: '', year: null, imagePath: 'hilux.jpg', imageUrl: ''),
      Car(id: 4, name: "Toyota Land Cruiser", pricePerDay: 6000, isAvailable: true, model: '', year: null, imagePath: 'land.jpg', imageUrl: ''),
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Rental',
      theme: ThemeData(
        useMaterial3: true, // Enables Material 3 UI
        colorSchemeSeed: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CarListPage(),
    const AddCarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taagz Car Rental'),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _screens[_selectedIndex],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 65,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.directions_car), label: 'Cars'),
          NavigationDestination(icon: Icon(Icons.add_circle), label: 'Add Car'),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        indicatorColor: Colors.blue.shade100,
      ),
    );
  }
}