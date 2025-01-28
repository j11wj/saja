import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/controller/home_controller.dart';
import 'package:saja_stor_app/controller/xhome_controller.dart';
import 'package:saja_stor_app/model/items.dart';
import '../constant/constants_color.dart';

class DetailPage extends StatefulWidget {
  final Items items;
  final List<Items> itemsList;
  final List suggestions;

  const DetailPage({super.key, required this.items, required this.suggestions, required this.itemsList});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final XhomeController controller = Get.put(XhomeController());

  @override
  void initState() {
    controller.fetchItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackgroundColor,
      appBar: AppBar(
        backgroundColor: myBackgroundColor,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                String? deviceId = await controller.getId();
                var db = FirebaseFirestore.instance;
                await db.collection('basket').doc().set({
                  'id': widget.items.id,
                  'name': widget.items.name,
                  'price': widget.items.price,
                  'image': widget.items.image,
                  'deviceId': deviceId,
                  'description': widget.items.description,
                });
                Get.snackbar('Success', 'Item added to basket!');
              } catch (e) {
                Get.snackbar('Error', e.toString());
              }
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemImage(),
            const SizedBox(height: 20),
            _buildItemDetails(),
            const SizedBox(height: 20),
            _buildSuggestionsList(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 400.h,
          child: Image.memory(base64Decode(widget.items.image)),
        ),
      ],
    );
  }

  Widget _buildItemDetails() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.items.name,
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.items.description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Obx(() {
      if (controller.suggestions.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: CircularProgressIndicator(),
          ),
        );
      }
      return SizedBox(
        height: 250.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = controller.suggestions[index]!;
            return _buildSuggestionCard(suggestion);
          },
        ),
      );
    });
  }

  Widget _buildSuggestionCard(Items suggestion) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: GestureDetector(
        onTap: () async {
          controller.fetchSuggestions(
              suggestionIds: widget.items.suggestions.cast<String>());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(
                
                items: suggestion,
                suggestions: suggestion.suggestions, itemsList: widget.itemsList,
              ),
            ),
          );
        },
        child: Container(
          height: 209.h,
          width: 151.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSuggestionImage(suggestion),
              _buildSuggestionDetails(suggestion),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionImage(Items suggestion) {
    return Container(
      height: 135.h,
      width: 133.w,
      margin: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        color: const Color(0xffc7e8fd),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Image.memory(
        base64Decode(suggestion.image),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSuggestionDetails(Items suggestion) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            suggestion.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            "\$${suggestion.price}",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
