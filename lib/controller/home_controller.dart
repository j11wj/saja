import 'dart:io';

import 'package:android_id/android_id.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/model/basket.dart';
import 'package:saja_stor_app/model/category.dart';
import 'package:saja_stor_app/model/items.dart';
import 'package:saja_stor_app/model/order.dart';

// import '../firebase/firebase_servis.dart';

class HomeController extends GetxController {
  // final FirebaseService _firebaseService = FirebaseService();

  // var dataList = <Map<String, dynamic>>[].obs;
  // var isLoading = false.obs;

  // // Fetch data
  // Future<void> fetchData(String collectionName) async {
  //   try {
  //     isLoading(true);
  //     var data = await _firebaseService.getCollectionData(collectionName);
  //     dataList.assignAll(data);
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   } finally {
  //     isLoading(false);
  //   }
  // }
var searchText = ''.obs;
void searchItems(String query) {
  if (query.isEmpty) {
    fetchItems(CatName: CatName); // إعادة تحميل كل العناصر إذا كان النص فارغًا
  } else {
    items.value = items.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
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

  String CatName = 'All';
  var items = <Items>[].obs; // Observable list of categories

  // Fetch items from Firestore
  Future<void> fetchItems({CatName}) async {
    try {
      if (CatName == 'All') {
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

  Future<QuerySnapshot> getBasket() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('basket')
        .where('deviceId', isEqualTo: await getId())
        .get();

    // Map Firestore documents to Category objects

    return querySnapshot;

    //delete Basket from Firestore
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
  fetchSugection({required List suggestionId, required it}) {
    try {
      for (var i = 0; i < it.length; i++) {
        print('Error fetching');
        if (suggestionId.contains(it[i].id)) {
          print('element.id ${it[i].id}');
          suggestion.add(it[i]);
        } else {}
      }
      update();
    } catch (e) {
      print('Error fetching categories: $e');
    }

    //delete Basket from Firestore
  }

  // Fetch categories from Firestore
  Future<QuerySnapshot> getOrders() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('order')
        .where('deviceId', isEqualTo: await getId())
        .get();
    return querySnapshot;
  }

  var orders = <Orders>[].obs; // Observable list of categories

  // Fetch categories from Firestore
  Future<void> fetchOrders() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('order')
          .where('deviceId', isEqualTo: await getId())
          .get();

      // Map Firestore documents to Category objects
      orders.value = querySnapshot.docs.map((doc) {
        return Orders.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> deleteBasket(String id) async {
    var db = FirebaseFirestore.instance;
    await db.collection('basket').doc(id).delete();

    // Update the UI

    getBasket();
    update();
  }

  Future<void> deleteOrder(String id) async {
    var db = FirebaseFirestore.instance;
    await db.collection('order').doc(id).delete();

    // Update the UI

    getBasket();
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
