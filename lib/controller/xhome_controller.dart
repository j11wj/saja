import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

import '../model/category.dart';
import '../model/items.dart';

class XhomeController extends GetxController {
  final items = <Items>[].obs;
  final categories = <Category>[].obs;
  final CatName = 'All'.obs;
  final searchText = ''.obs;
  final isLoading = false.obs; // مؤشر التحميل
  String? lastDocumentName;
  var suggestions = <Items>[].obs;

  void searchItems(String query) {
    if (query.isEmpty) {
      fetchItems(); // إعادة تحميل كل العناصر إذا كان النص فارغًا
    } else {
      items.value = items.where((item) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

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

  Future<void> fetchItems({String? lastDocumentId}) async {
    // if (isLoading.value) return; // إذا كان التحميل قيد التنفيذ، لا تفعل شيئًا
    print('Fetching items');
    // isLoading.value = true; // بدء التحميل
    try {
      QuerySnapshot querySnapshot;

      if (CatName.value == 'All') {
        querySnapshot = await FirebaseFirestore.instance
            .collection('items')
            .orderBy('name') // ترتيب حسب الحقل name
            .startAfter([lastDocumentName ?? '']) // استخدام قيمة واحدة
            .limit(3)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('items')
            .where('category', isEqualTo: CatName.value)
            .orderBy('name') // ترتيب حسب الحقل name
            .startAfter([lastDocumentName ?? '']) // استخدام قيمة واحدة
            .limit(3)
            .get();
      }

      final newItems = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Items.fromFirestore(doc.id, data);
      }).toList();

      items.addAll(newItems); // إضافة العناصر الجديدة إلى القائمة

      // حفظ آخر مستند تم جلبه
      if (querySnapshot.docs.isNotEmpty) {
        lastDocumentName =
            querySnapshot.docs.last['name']; // حفظ قيمة الحقل name
      }
      update();

      // // إذا كان عدد العناصر أقل من الحد المطلوب، توقف عن التحميل
      // if (querySnapshot.docs.length < 3) {
      //   isLoading.value = false;
      //   return;
      // }
    } catch (e, stackTrace) {
      print('Error fetching items: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false; // إنهاء التحميل
    }
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
Future<void> fetchSuggestions({required List<String> suggestionIds}) async {
  suggestions.clear(); // تنظيف القائمة الحالية

  try {
    // استخدام `whereIn` لتصفية العناصر التي تتطابق مع أي من الـ IDs في `suggestionIds`
    final querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where(FieldPath.documentId, whereIn: suggestionIds) // استخدام whereIn
        .get();

    // تحويل النتائج إلى قائمة من العناصر
    final newItems = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Items.fromFirestore(doc.id, data);
    }).toList();

    // إضافة العناصر المطابقة إلى القائمة `suggestions`
    suggestions.addAll(newItems);

    // تحديث الحالة (إذا كنت تستخدم GetX)
    update();
  } catch (e) {
    print('Error fetching suggestions: $e');
  }
}
}
