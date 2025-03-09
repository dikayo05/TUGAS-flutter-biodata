import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biodata/services/biodata_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // paggil model
  Biodataservice? service;
  String? selectedDocId;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  // jalan saat screen show
  @override
  void initState() {
    super.initState();
    // Initialize an instance of Cloud Firestore
    service = Biodataservice(FirebaseFirestore.instance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(hintText: 'Age'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(hintText: 'Address'),
              ),

              Expanded(
                child: StreamBuilder(
                  // call `Biodata` which return a Stream
                  stream: service?.getBiodata(),
                  builder: (context, snapshot) {
                    // check our connection (loading|error)
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.connectionState == ConnectionState.none) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error fetching data: ${snapshot.data}');
                    } else if (snapshot.hasData &&
                        snapshot.data?.docs.isEmpty == true) {
                      return const Center(child: Text('Empty documents'));
                    }
                    // `data?.docs` return a [List<QueryDocumentSnapshot>]
                    // we're going to return a [ListView.builder] with those documents data
                    final documents = snapshot.data?.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: documents?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // since it return a Map<String,dynamic> we access data by `key`
                          title: Text(documents?[index]['name']),
                          subtitle: Text(documents?[index]['age']),
                          onTap: () {
                            nameController.text = documents?[index]['name'];
                            ageController.text = documents?[index]['age'];
                            addressController.text =
                                documents?[index]['address'];
                            selectedDocId = documents?[index].id;
                          },
                          trailing: IconButton(onPressed: () {
                            if (documents?[index].id != null) {
                              service?.delete(documents![index].id);
                            }
                          }, icon: const Icon(Icons.delete)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // get name,age and address dari controller
          final name = nameController.text;
          final age = ageController.text;
          final address = addressController.text;

          if (name.isEmpty || age.isEmpty || address.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please fill all fields')),
            );
            return;
          }
          if (selectedDocId != null) {
            service?.update(selectedDocId!, {
              'name': name,
              'age': age,
              'address': address,
            });
            selectedDocId = null;
          } else {
            service?.add({'name': name, 'age': age, 'address': address});
          }
          nameController.clear();
          ageController.clear();
          addressController.clear();
        },
      ),
    );
  }
}
