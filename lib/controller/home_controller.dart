import 'dart:io';

import 'package:android_id/android_id.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/model/basket.dart';
import 'package:saja_stor_app/model/category.dart';
import 'package:saja_stor_app/model/items.dart';
import 'package:saja_stor_app/model/order.dart';

// import '../firebase/firebase_servis.dart';

class HomeController extends GetxController {
  final _firebase = FirebaseFirestore.instance;
  @override
  void onInit()  {
    //TODO: implement onInit
    //  fetchItems();
    //  fetchCategories();
    super.onInit();
  }
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
      fetchItems(); // إعادة تحميل كل العناصر إذا كان النص فارغًا
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
      final querySnapshot = await _firebase.collection('category').get();

      // Map Firestore documents to Category objects
      categories.value = querySnapshot.docs.map((doc) {
        return Category.fromFirestore(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  var CatName = 'All'.obs;

  
  var items = <Items>[].obs; // Observable list of categories
  Future<void> fetchItems({String? lastDocumentId}) async {
    if (lastDocumentId == null) {
      print('is not empty');
    }
    try {
      QuerySnapshot querySnapshot;

      if (CatName == 'All') {
        querySnapshot = await _firebase
            .collection('items')
            .orderBy('id') // يجب أن يكون الحقل مرتبًا
            .startAfter([lastDocumentId]) // ابدأ بعد آخر مستند تم جلبه
            .limit(3) // جلب 30 مستند في كل مرة
            .get();
      } else {
        querySnapshot = await _firebase
            .collection('items')
            .where('category', isEqualTo: CatName)
            .orderBy('id') // يجب أن يكون الحقل مرتبًا
            .startAfter([lastDocumentId]) // ابدأ بعد آخر مستند تم جلبه
            .limit(3) // جلب 30 مستند في كل مرة
            .get();
      }

      // إضافة البيانات الجديدة إلى القائمة الحالية
      final newItems = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Items.fromFirestore(doc.id, data);
      }).toList();

      items.addAll(newItems); // إضافة البيانات الجديدة إلى القائمة

      // تحديث الحالة (إذا كنت تستخدم GetX)
      update();

      // حفظ آخر مستند تم جلبه للاستخدام في الطلب التالي
      if (querySnapshot.docs.isNotEmpty) {
        lastDocumentId = querySnapshot.docs.last.id;
      }
    } catch (e, stackTrace) {
      print('Error fetching items: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<QuerySnapshot> getBasket() async {
    final querySnapshot = await _firebase
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
      final querySnapshot = await _firebase
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

  var suggestions = <Items>[].obs;

  Future<void> fetchSuggestions({required List<String> suggestionIds}) async {
    suggestions.clear(); // تنظيف القائمة الحالية

    // إذا كانت القائمة `items` فارغة، نقوم بجلب العناصر أولاً
    if (items.isEmpty) {
      print("Items list is empty. Fetching items...");
      await fetchItems();
    }

    try {
      // استخدام `where` لتصفية العناصر التي تتطابق مع `suggestionIds`
      final matchedItems =
          items.where((item) => suggestionIds.contains(item.id)).toList();

      // إضافة العناصر المطابقة إلى القائمة `suggestions`
      suggestions.addAll(matchedItems);

      // تحديث الحالة (إذا كنت تستخدم GetX)
      update();
    } catch (e) {
      print('Error fetching suggestions: $e');
    }
  }

  // Fetch categories from Firestore
  Future<QuerySnapshot> getOrders() async {
    final querySnapshot = await _firebase
        .collection('order')
        .where('deviceId', isEqualTo: await getId())
        .get();
    return querySnapshot;
  }

  var orders = <Orders>[].obs; // Observable list of categories

  // Fetch categories from Firestore
  Future<void> fetchOrders() async {
    try {
      final querySnapshot = await _firebase
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
    var db = _firebase;
    await db.collection('basket').doc(id).delete();

    // Update the UI

    getBasket();
    update();
  }

  Future<void> deleteOrder(String id) async {
    var db = _firebase;
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
