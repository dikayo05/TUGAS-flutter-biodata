import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biodata/services/firebase_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = FirebaseFirestore.instance;
  final firebaseService = FirebaseService();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  void fetchData() {
    firebaseService.getBiodata();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('biodata')),
      body: Center(
        child: Column(
          children: [
            TextField(controller: nameController),
            TextField(controller: ageController),
            TextField(controller: addressController),
            ElevatedButton(
              onPressed: () {
                firebaseService.addBiodata(
                  name: nameController.text,
                  age: ageController.text,
                  address: addressController.text,
                );
                fetchData();              },
              child: const Text('submit'),
            ),
          ],
        ),
      ),
    );
  }
}
