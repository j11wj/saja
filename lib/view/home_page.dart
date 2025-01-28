import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/controller/xhome_controller.dart';
import '../controller/home_controller.dart';
import '../constant/constants_color.dart';
import '../model/items.dart';
import '../view/detail_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final XhomeController controller = Get.put(XhomeController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    controller.fetchCategories();
    controller.fetchItems();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!controller.isLoading.value) {
        controller.fetchItems(lastDocumentId: controller.lastDocumentName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 20.h),
                  _buildCategoryHeader(context),
                  SizedBox(height: 20.h),
                  _buildSelectedCategory(),
                  SizedBox(height: 20.h),
                  controller.items.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await controller.fetchItems(
                                lastDocumentId: controller.lastDocumentName);
                          },
                          child: _buildItemsGrid(context))
                      : _buildLoadingIndicator(),
                  if (controller.isLoading.value) _buildLoadingIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 27.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              print('Items count: ${controller.items.length}');
              print('last:${controller.lastDocumentName}');
            },
            child: Icon(Icons.tune, size: 28.h),
          ),
          _buildSearchField(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Expanded(
      child: TextField(
        onChanged: (value) {
          controller.searchText.value = value;
          controller.searchItems(value);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: "Search box",
          hintStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.7),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 40.w,
            vertical: 15.h,
          ),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        GestureDetector(
          onTap: () => _showCategoryDialog(context),
          child: Container(
            padding: EdgeInsets.all(9.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: const Color(0xffF0BDBD),
            ),
            child: Image.asset(
              'assets/icons/Vector.png',
              height: 26.h,
              width: 22.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCategory() {
    return Text(
      '${controller.CatName.value}',
      style: TextStyle(
        color: const Color(0xffF0BDBD),
        fontSize: 24.sp,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildItemsGrid(BuildContext context) {
    return MasonryGridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      crossAxisSpacing: 25.w,
      mainAxisSpacing: 25.h,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        final item = controller.items[index];
        return _buildItemCard(context, item);
      },
    );
  }

  Widget _buildItemCard(BuildContext context, Items item) {
    return GestureDetector(
      onTap: () async {
        print(item.suggestions);
        controller.fetchSuggestions(
            suggestionIds: item.suggestions.cast<String>());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(
              itemsList: controller.items,
              items: item,
              suggestions: item.suggestions,
            ),
          ),
        );
      },
      child: Container(
        height: 209.h,
        width: 151.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100.r),
            topRight: Radius.circular(100.r),
            bottomLeft: Radius.circular(5.r),
            bottomRight: Radius.circular(5.r),
          ),
        ),
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 135.h,
              width: 133.w,
              decoration: BoxDecoration(
                color: const Color(0xffc7e8fd),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.memory(
                  base64Decode(item.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 90.w,
                  child: Text(
                    item.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _addToBasket(item),
                  child: CircleAvatar(
                    radius: 15.r,
                    backgroundColor: const Color(0xffF0BDBD),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "${item.price} IQ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: EdgeInsets.only(top: 250.h),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          height: 300.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
          color: primaryColor,
          child: ListView.builder(
            itemCount: controller.categories.length + 1,
            itemBuilder: (context, index) => Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (index < controller.categories.length) {
                      controller.CatName.value =
                          controller.categories[index].name;
                    } else {
                      controller.CatName.value = 'All';
                    }
                    controller.items.clear();
                    controller.fetchItems();
                    Get.back();
                  },
                  child: Text(
                    index < controller.categories.length
                        ? controller.categories[index].name
                        : 'All',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(color: Colors.white, height: 5.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addToBasket(Items item) async {
    try {
      String? deviceId = await controller.getId();
      await FirebaseFirestore.instance.collection('basket').doc().set({
        'id': item.id,
        'name': item.name,
        'price': item.price,
        'image': item.image,
        'deviceId': deviceId,
        'description': item.description,
      });
      Get.appUpdate();
    } catch (e) {
      print("Error adding to basket: $e");
    }
  }
}
