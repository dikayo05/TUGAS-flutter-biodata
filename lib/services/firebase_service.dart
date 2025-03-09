import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;

  Future<void> addBiodata({
    required String name,
    String? age,
    String? address,
  }) async {
    await db.collection("biodata").add({
      "name": name,
      "age": age,
      "address": address,
    });
  }

  Future<void> getBiodata() async {
    await db.collection("biodata").get().then((querySnapshot) {
      print("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    }, onError: (e) => print("Error completing: $e"));
  }
}
