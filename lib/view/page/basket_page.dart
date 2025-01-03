import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/constant/constants.dart';
import 'package:saja_stor_app/controller/home_controller.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

class BasketPage extends StatelessWidget {
  BasketPage({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 62.h, bottom: 14.h),
              child: Text(
                "Basket",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Divider(
              height: 2.h,
              color: primaryColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Text(
                      'محتويات السلة',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: controller.getBasket(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('لا توجد منتجات في السلة');
                }
                print(snapshot.data!.docs);
                return SizedBox(
                  height: 550.h,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return _basketWidget(
                        basket: snapshot.data!.docs[index],
                        controller: controller,
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _basketWidget(
      {required var basket, required HomeController controller}) {
    TextEditingController name = TextEditingController();
    TextEditingController loc = TextEditingController();
    TextEditingController phone = TextEditingController();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
      padding: EdgeInsets.all(10.w.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: primaryColor.withOpacity(0.4),
            width: 1.w,
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 10.r,
              offset: const Offset(0.0, 0.0),
              spreadRadius: 0,
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 150.h),
            child: GestureDetector(
              onTap: () async {
                
                Get.snackbar(
                  'تمت العملية',
                  'تم حذف المنتج',
                  duration: Duration(milliseconds: 2000),
                );
                controller.deleteBasket(basket.id);
                controller.update();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5.w,
                      color: Colors.red,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Text(
                  'حذف',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Padding(
            padding: EdgeInsets.only(top: 150.h),
            child: GestureDetector(
              onTap: () {
                Get.bottomSheet(BottomSheet(
                  onClosing: () {},
                  builder: (context) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      child: Column(
                        children: [
                          TextField(
                            controller: name,
                            decoration: const InputDecoration(
                              labelText: 'اسم الزبون',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          TextField(
                            controller: loc,
                            decoration: const InputDecoration(
                              labelText: 'موقع التوصيل',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          TextField(
                            controller: phone,
                            decoration: const InputDecoration(
                              labelText: 'رقم الهاتف',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (name.text.isNotEmpty &&
                                      phone.text.isNotEmpty &&
                                      loc.text.isNotEmpty) {
                                    try {
                                      String? deId = await controller.getId();
                                      var db = FirebaseFirestore.instance;
                                      await db.collection('order').doc().set({
                                        'id': basket.id,
                                        'nameOfProdect': basket.name,
                                        'price': basket.price,
                                        'deviceId': deId,
                                        'phone': phone.text,
                                        'address': loc.text,
                                        'nameOfUser': name.text,
                                        'date': DateTime.now().toString(),
                                      });
                                      Get.appUpdate();
                                      controller.deleteBasket(basket.id);
                                      Get.back();
                                    } catch (e) {
                                      print("Error: " + e.toString());
                                    }
                                  }
                                  // Get.back();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.5.w,
                                        color: Colors.transparent,
                                      ),
                                      color: primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: const Text(
                                    'تاكيد',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ));
                // showDialog<void>(
                //   context: context,
                //   builder: (context) {
                //     return Dialog(
                //       child: SizedBox(
                //         height: 130.h,
                //         child: Column(
                //           mainAxisAlignment:
                //               MainAxisAlignment.spaceAround,
                //           children: [
                //             Text(
                //               'هل تريد الغاء الطلب',
                //               style: TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 27.sp,
                //                 fontWeight: FontWeight.w800,
                //               ),
                //             ),
                //             Container(
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: 25.w, vertical: 2.h),
                //               decoration: BoxDecoration(
                //                   color: primaryColor,
                //                   boxShadow: [
                //                     BoxShadow(
                //                       color: Colors.black
                //                           .withOpacity(0.2),
                //                       blurRadius: 4.r,
                //                       offset: const Offset(0.0, 4),
                //                     )
                //                   ],
                //                   borderRadius:
                //                       BorderRadius.circular(10.r)),
                //               child: Text(
                //                 'حذف',
                //                 style: TextStyle(color: Colors.white),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 2.h),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5.w,
                      color: Colors.transparent,
                    ),
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Text(
                  'تاكيد',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            height: 190.h,
            width: 180.w,
            padding: EdgeInsets.all(10.h.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${basket['name']!}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'السعر: \$${basket['price']}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'العدد: 1',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
