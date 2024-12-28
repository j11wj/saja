import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/controller/home_controller.dart';
import 'package:saja_stor_app/firebase/firebase_servis.dart';
import 'package:saja_stor_app/view/page/detail_page.dart';
import '../../constant/constants.dart';
import '../../model/items.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    controller.fetchCategories();
    controller.fetchItems();

    return Scaffold(
      body: Obx(
        () {
          if (controller.items.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 27.h),
                      child: GestureDetector(
                        onTap: () {
                          print(controller.items);
                        },
                        child: SizedBox(
                          height: 28.h,
                          width: 26.w,
                          child: const Icon(Icons.tune),
                        ),
                      ),
                    ),
                    searchField(),
                    SizedBox(height: 20.h),
                    Row(
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
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    height: 300.h,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 20.h),
                                    color: primaryColor,
                                    child: ListView.builder(
                                      itemCount:
                                          controller.categories.length + 1,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (index ==
                                                    controller
                                                        .categories.length) {
                                                  controller.items.value
                                                      .clear();
                                                  controller.fetchItems(
                                                      CatName: null);
                                                  Get.back();
                                                }
                                                print(controller
                                                    .categories[index].name);
                                                controller.items.value.clear();
                                                controller.fetchItems(
                                                    CatName:
                                                        '${controller.categories[index].name}');
                                                Get.back();
                                              },
                                              child: Text(
                                                index <
                                                        controller
                                                            .categories.length
                                                    ? '${controller.categories[index].name}'
                                                    : 'all',
                                                style: TextStyle(
                                                    fontSize: 24.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.white,
                                              height: 5.h,
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(9.h.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Color(0xffF0BDBD),
                            ),
                            child: Image.asset(
                              'assets/icons/Vector.png',
                              height: 26.h,
                              width: 22.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'All',
                      style: TextStyle(
                        color: Color(0xffF0BDBD),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    _itemsWidget(context, controller),
                  ],
                ),
              ),
            ),
          );
          // return ListView.builder(
          //   itemCount: controller.categories.length,
          //   itemBuilder: (context, index) {
          //     final category = controller.categories[index];
          //     return ListTile(
          //       title: Text(category.name),
          //       subtitle: Text('ID: ${category.id}'),
          //     );
          //   },
          // );
        },
      ),
    );

    // return GetBuilder(
    //   init: HomeController(),
    //   builder: (controller) {
    //     return Scaffold(
    //       backgroundColor: myBackgroundColor,
    //       body: SafeArea(
    //         child: Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 16.w),
    //           child: SingleChildScrollView(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Padding(
    //                   padding: EdgeInsets.only(top: 27.h),
    //                   child: GestureDetector(
    //                     onTap: () {},
    //                     child: SizedBox(
    //                       height: 28.h,
    //                       width: 26.w,
    //                       child: const Icon(Icons.tune),
    //                     ),
    //                   ),
    //                 ),
    //                 searchField(),
    //                 SizedBox(height: 20.h),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(
    //                       'Categories',
    //                       style: TextStyle(
    //                         color: Colors.black,
    //                         fontSize: 24.sp,
    //                         fontWeight: FontWeight.w900,
    //                       ),
    //                     ),
    //                     GestureDetector(
    //                       onTap: () {
    //                         showDialog<void>(
    //                           context: context,
    //                           builder: (context) {
    //                             return Dialog(
    //                               child: Container(
    //                                 height: 300.h,
    //                                 padding: EdgeInsets.symmetric(
    //                                     horizontal: 10.w, vertical: 20.h),
    //                                 color: primaryColor,
    //                                 child: ListView.builder(
    //                                   itemCount: controller.categories.length,
    //                                   itemBuilder: (context, index) {
    //                                     return Column(
    //                                       children: [
    //                                         Text(
    //                                           'categories',
    //                                           style: TextStyle(
    //                                               fontSize: 24.sp,
    //                                               color: Colors.white,
    //                                               fontWeight: FontWeight.bold),
    //                                         ),
    //                                         Divider(
    //                                           color: Colors.white,
    //                                           height: 5.h,
    //                                         )
    //                                       ],
    //                                     );
    //                                   },
    //                                 ),
    //                               ),
    //                             );
    //                           },
    //                         );
    //                       },
    //                       child: Container(
    //                         padding: EdgeInsets.all(9.h.w),
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(10.r),
    //                           color: Color(0xffF0BDBD),
    //                         ),
    //                         child: Image.asset(
    //                           'assets/icons/Vector.png',
    //                           height: 26.h,
    //                           width: 22.w,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 SizedBox(height: 20.h),
    //                 Text(
    //                   'All',
    //                   style: TextStyle(
    //                     color: Color(0xffF0BDBD),
    //                     fontSize: 24.sp,
    //                     fontWeight: FontWeight.w900,
    //                   ),
    //                 ),
    //                 _itemsWidget(context),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  MasonryGridView _itemsWidget(
      BuildContext context, HomeController controller) {
    return MasonryGridView(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      crossAxisSpacing: 25,
      mainAxisSpacing: 25,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      children: [
        for (var item in controller.items)
          GestureDetector(
            onTap: () async {
              await controller.fetchSugection(item.type, id: item.id);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(
                    items: item,
                    type: item.type,
                    suggestions: controller.suggestion,
                  ),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Container(
                height: 209.h,
                width: 151.w,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.r),
                    topRight: Radius.circular(100.r),
                    bottomLeft: Radius.circular(5.r),
                    bottomRight: Radius.circular(5.r),
                  ),
                ),
                padding: EdgeInsets.all(8.h.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 135.h,
                      width: 133.w,
                      decoration: BoxDecoration(
                        color: Color(0xffc7e8fd),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: SizedBox(
                        height: 50.h,
                        width: 50.w,
                        child: Image.memory(
                          base64Decode(item.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        SizedBox(
                          width: 90.w,
                          child: Text(
                            item.name,
                            textDirection: TextDirection.rtl,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            try {
                              String? deId = await controller.getId();
                              var db = FirebaseFirestore.instance;
                              await db.collection('basket').doc().set({
                                'id': item.id,
                                'name': item.name,
                                'price': item.price,
                                'image': item.image,
                                'deviceId': deId,
                                'description': item.description,
                              });
                              Get.appUpdate();
                            } catch (e) {
                              print("Error: " + e.toString());
                            }
                          },
                          child: CircleAvatar(
                            radius: 15.r,
                            backgroundColor: Color(0xffF0BDBD),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "\$${item.price}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  AppBar headerParts() {
    return AppBar(
      backgroundColor: myBackgroundColor,
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.arrow_back_ios_new,
        ),
      ),
      centerTitle: true,
      title: const Text(
        "Search Products",
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
      ),
    );
  }

  Padding searchField() {
    return Padding(
      padding: EdgeInsets.only(top: 22.h),
      child: Expanded(
        flex: 6,
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              filled: true,
              fillColor: Colors.white,
              hintText: "search box",
              hintStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.7),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
              prefixIcon: const Icon(Icons.search)),
        ),
      ),
    );
  }
}
