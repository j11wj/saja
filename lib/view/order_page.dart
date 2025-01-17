import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/constant/constants_color.dart';
import 'package:saja_stor_app/controller/home_controller.dart';

class OrderPage extends StatelessWidget {
  OrderPage({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    controller.fetchOrders();

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 62.h, bottom: 14.h),
                child: Text(
                  "Order's",
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
              FutureBuilder(
                future: controller.getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: EdgeInsets.only(top: 300.h),
                      child: const CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 300.h),
                      child: const Text('لا توجد منتجات في قائمة الطلبات'),
                    );
                  }
                  return Padding(
                    padding:
                        EdgeInsets.only(top: 15.h, right: 16.w, left: 16.w),
                    child: SizedBox(
                      height: 620.h,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
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
                                    onTap: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            child: SizedBox(
                                              height: 130.h,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    'هل تريد الغاء الطلب',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 27.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller.deleteOrder(
                                                          snapshot.data!
                                                              .docs[index].id);
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 25.w,
                                                              vertical: 2.h),
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.2),
                                                              blurRadius: 4.r,
                                                              offset:
                                                                  const Offset(
                                                                      0.0, 4),
                                                            )
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r)),
                                                      child: Text(
                                                        'حذف',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 0.5.w,
                                            color: Color(0xffff0000),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      child: Text(
                                        'الغاء',
                                        style:
                                            TextStyle(color: Color(0xffff0000)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.h.w),
                                Container(
                                  height: 190.h,
                                  width: 200.w,
                                  padding: EdgeInsets.all(10.h.w),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'طلب جاري ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Text(
                                        'اسم الزبون: ${snapshot.data!.docs[index]['nameOfUser']}',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'اسم المنتج: ${snapshot.data!.docs[index]['nameOfProdect']}',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'المبلغ المستحق: \$${snapshot.data!.docs[index]['price']}',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.all(10.h.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffE5FF00)
                                        .withOpacity(0.29),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/Group 25.svg',
                                    height: 22.h,
                                    width: 22.w,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
