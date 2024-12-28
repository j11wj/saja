import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getCollectionData(
      String collectionName) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }
  Future<List<String>> fetchCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('category').get();
      List<String> categories =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
      return categories;
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }
  Future setCollectionData(
      {required String collectionName,
      required Map<String, dynamic> data}) async {
    try {
      await _firestore.collection(collectionName).add(data);
      print('done');
    } catch (e) {
      print(e.toString());
    }
  }
}
