import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

import '../firebase/firebase_servis.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  var dataList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // Fetch data
  Future<void> fetchData(String collectionName) async {
    try {
      isLoading(true);
      var data = await _firebaseService.getCollectionData(collectionName);
      dataList.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  int navIndex = 0;

  void changeNavIndex(int i) {
    navIndex = i;
    update();
  }

  var categories = <Category>[].obs; // Observable list of categories

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('category').get();

      // Map Firestore documents to Category objects
      categories.value = querySnapshot.docs.map((doc) {
        return Category.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  var items = <Items>[].obs; // Observable list of categories

  // Fetch items from Firestore
  Future<void> fetchItems({CatName}) async {
    try {
      if (CatName == null) {
        final querySnapshot =
            await FirebaseFirestore.instance.collection('items').get();

        items.value = querySnapshot.docs.map((doc) {
          return Items.fromFirestore(doc.id, doc.data());
        }).toList();
      } else {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('items')
            .where('category', isEqualTo: '$CatName')
            .get();

        items.value = querySnapshot.docs.map((doc) {
          return Items.fromFirestore(doc.id, doc.data());
        }).toList();
      }

      ;
      // if (CatName == null) {
      //    querySnapshot =
      //       await FirebaseFirestore.instance.collection('items').get();
      // } else {
      //   querySnapshot =
      //       await FirebaseFirestore.instance.collection('items').where('category',isEqualTo: '$CatName').get();
      // }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  var baskets = <Basket>[].obs; // Observable list of categories

  // Fetch categories from Firestore
  Future<void> fetchBasket() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('basket')
          .where('deviceId', isEqualTo: await getId())
          .get();

      // Map Firestore documents to Category objects
      baskets.value = querySnapshot.docs.map((doc) {
        return Basket.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }

    //delete Basket from Firestore
  } // Fetch categories from Firestore

  var suggestion = <Items?>[].obs;
  Future<void> fetchSugection(String type, {String? id}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('items')
          .where('type', isEqualTo: type)
          .get();

      // Map Firestore documents to Category objects
      suggestion.value = querySnapshot.docs
          .map((doc) {
            if (doc.id != id) {
              return Items.fromFirestore(doc.id, doc.data());
            } else {
              return null; // Mark as null to skip
            }
          })
          .where((item) => item != null)
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }

    //delete Basket from Firestore
  }

  var orders = <Order>[].obs; // Observable list of categories

  // Fetch categories from Firestore
  Future<void> fetchOrders() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('order')
          .where('deviceId', isEqualTo: await getId())
          .get();

      // Map Firestore documents to Category objects
      orders.value = querySnapshot.docs.map((doc) {
        return Order.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> deleteBasket(String id) async {
    var db = FirebaseFirestore.instance;
    await db.collection('basket').doc(id).delete();
    baskets.clear();
    fetchBasket();
    update();
  }

  ///get  deviceId
  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return AndroidId().getId(); // unique ID on Android
    }
  }
}

class Order {
  String id;
  String diveceId;
  String price;
  String phone;
  String address;
  String nameOfUser;
  String date;
  Order({
    required this.id,
    required this.diveceId,
    required this.price,
    required this.phone,
    required this.address,
    required this.nameOfUser,
    required this.date,
  });
  // Factory method to create a Order object from Firestore data
  factory Order.fromFirestore(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      diveceId: data['deviceId'] ?? '',
      price: data['price'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      nameOfUser: data['nameOfUser'] ?? '',
      date: data['date'] ?? '',
    );
  }
}

class Basket {
  String id;
  String name;
  String price;
  Basket({
    required this.id,
    required this.name,
    required this.price,
  });
  // Factory method to create a Basket object from Firestore data
  factory Basket.fromFirestore(String id, Map<String, dynamic> data) {
    return Basket(
      id: id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
    );
  }
}

class Items {
  String id;
  String name;
  String price;
  String description;
  String image;
  String type;
  String category;
  Items({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.type,
    required this.category,
  });
  // Factory method to create a Items object from Firestore data
  factory Items.fromFirestore(String id, Map<String, dynamic> data) {
    return Items(
      id: id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      description: data['discription'] ?? '',
      image: data['image'] ?? '',
      type: data['type'] ?? '',
      category: data['category'] ?? '',
    );
  }
}

class Category {
  String id;
  String name;

  Category({required this.id, required this.name});

  // Factory method to create a Category object from Firestore data
  factory Category.fromFirestore(String id, Map<String, dynamic> data) {
    return Category(
      id: id,
      name: data['name'] ?? '',
    );
  }
}
