import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/controller/home_controller.dart';

import '../../constant/constants.dart';

class DetailPage extends StatefulWidget {
  final Items items;
  final List suggestions;
  final String type;
  const DetailPage(
      {super.key,
      required this.items,
      required this.type,
      required this.suggestions});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  HomeController controller = HomeController();
  var suggestion = [].obs;

  @override
  void initState() {
    // TODO: implement initState
    // widget.suggestions.map(
    //   (e) {
    //     if (e.id != widget.items.id) {
    //       setState(() {
    //         suggestion.add(e);
    //       });
    //     }
    //   },
    // );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    widget.suggestions.clear();
    controller.suggestion.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // if (suggestion.isEmpty) {
      //   return Center(child: CircularProgressIndicator());
      // }

      return Scaffold(
        backgroundColor: myBackgroundColor,
        appBar: AppBar(
          backgroundColor: myBackgroundColor,
          actions: [
            IconButton(
              onPressed: () async {
                try {
                  // String? deId = await controller.getId();
                  // var db = FirebaseFirestore.instance;
                  // await db.collection('basket').doc().set({
                  //   'id': widget.items.id,
                  //   'name': widget.items.name,
                  //   'price': widget.items.price,
                  //   'image': widget.items.image,
                  //   'deviceId': deId,
                  //   'description': widget.items.description,
                  // });
                } catch (e) {
                  print("Error: " + e.toString());
                }

                // print('done');
              },
              icon: const Icon(
                Icons.shopping_cart_outlined,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 400.h,
                    child: Image.asset(widget.items.image),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  widget.items.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  widget.items.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              widget.suggestions != null
                  ? SizedBox(
                      height: 250.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        // itemCount: widget.suggestions.length,
                        itemCount: widget.suggestions.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: GestureDetector(
                              onTap: () {
                                controller.fetchSugection(
                                    widget.suggestions[index].type,
                                    id: widget.suggestions[index].id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailPage(
                                      items: widget.suggestions[index],
                                      type: widget.suggestions[index].type,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 135.h,
                                        width: 133.w,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffc7e8fd),
                                          borderRadius:
                                              BorderRadius.circular(100.r),
                                        ),
                                        child: SizedBox(
                                          height: 50.h,
                                          width: 50.w,
                                          child: Image.asset(
                                            widget.suggestions[index].image,
                                            height: 50.h,
                                            width: 50.w,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 90.w,
                                            child: Text(
                                              ' ${widget.suggestions[index].name}',
                                              textDirection: TextDirection.rtl,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              // try {
                                              //   String? deId = await controller.getId();
                                              //   var db = FirebaseFirestore.instance;
                                              //   await db.collection('basket').doc().set({
                                              //     'id': item.id,
                                              //     'name': item.name,
                                              //     'price': item.price,
                                              //     'image': item.image,
                                              //     'deviceId': deId,
                                              //     'description': item.description,
                                              //   });
                                              //   Get.appUpdate();
                                              // } catch (e) {
                                              //   print("Error: " + e.toString());
                                              // }
                                            },
                                            child: CircleAvatar(
                                              radius: 15.r,
                                              backgroundColor:
                                                  const Color(0xffF0BDBD),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 90.w,
                                            child: Text(
                                              "\$${widget.suggestions[index].price}",
                                              overflow: TextOverflow.ellipsis,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 30.h)
              // Row(
              //   children: [
              //     Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(22),
              //       ),
              //       padding: const EdgeInsets.all(15),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Center(
              //             child: Hero(
              //               tag: items[0].image,
              //               child: Image.asset(items[0].image),
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Text(
              //             items[0].name,
              //             style: const TextStyle(
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold,
              //               letterSpacing: -1,
              //             ),
              //           ),
              //           items[0].category != null
              //               ? Text(
              //                   items[0].category!,
              //                   style: const TextStyle(
              //                     fontSize: 12,
              //                     fontWeight: FontWeight.w500,
              //                     color: Colors.grey,
              //                   ),
              //                 )
              //               : const SizedBox(height: 20),
              //           Row(
              //             children: [
              //               Text(
              //                 "\$${items[0].price}",
              //                 style: const TextStyle(
              //                   fontSize: 17,
              //                   fontWeight: FontWeight.w800,
              //                   letterSpacing: -1,
              //                 ),
              //               ),
              //               const Spacer(),
              //               const CircleAvatar(
              //                 radius: 18,
              //                 backgroundColor: Colors.black,
              //                 child: Icon(
              //                   Icons.favorite,
              //                   color: Colors.white,
              //                   size: 22,
              //                 ),
              //               )
              //             ],
              //           )
              //         ],
              //       ),
              //     ),
              //   ],
              // )
              // // SizedBox(
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     shrinkWrap: true,
              //     itemCount: items.length,
              //     itemBuilder: (context, index) => Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(22),
              //       ),
              //       padding: const EdgeInsets.all(15),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Center(
              //             child: Hero(
              //               tag: items[index].image,
              //               child: Image.asset(items[index].image),
              //             ),
              //           ),
              //           const SizedBox(height: 5),
              //           Text(
              //             items[index].name,
              //             style: const TextStyle(
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold,
              //               letterSpacing: -1,
              //             ),
              //           ),
              //           items[index].category != null
              //               ? Text(
              //                   items[index].category!,
              //                   style: const TextStyle(
              //                     fontSize: 12,
              //                     fontWeight: FontWeight.w500,
              //                     color: Colors.grey,
              //                   ),
              //                 )
              //               : const SizedBox(height: 20),
              //           Row(
              //             children: [
              //               Text(
              //                 "\$${items[index].price}",
              //                 style: const TextStyle(
              //                   fontSize: 17,
              //                   fontWeight: FontWeight.w800,
              //                   letterSpacing: -1,
              //                 ),
              //               ),
              //               const Spacer(),
              //               const CircleAvatar(
              //                 radius: 18,
              //                 backgroundColor: Colors.black,
              //                 child: Icon(
              //                   Icons.favorite,
              //                   color: Colors.white,
              //                   size: 22,
              //                 ),
              //               )
              //             ],
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        // bottomSheet: Container(
        //   height: 270,
        //   width: double.infinity,
        //   padding: const EdgeInsets.symmetric(
        //     horizontal: 40,
        //     vertical: 20,
        //   ),
        //   decoration: const BoxDecoration(
        //     color: primaryColor,
        //     borderRadius: BorderRadius.vertical(
        //       top: Radius.circular(40),
        //     ),
        //   ),
        //   child: Column(
        //     children: [
        //       const SizedBox(height: 40),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               const Text(
        //                 "Total Price",
        //                 style: TextStyle(
        //                   fontSize: 18,
        //                   fontWeight: FontWeight.w500,
        //                   color: Colors.white,
        //                   letterSpacing: -1,
        //                 ),
        //               ),
        //               Text(
        //                 "\$${widget.plant.price}",
        //                 style: const TextStyle(
        //                   fontSize: 20,
        //                   fontWeight: FontWeight.w800,
        //                   color: Colors.white,
        //                   height: 1,
        //                   letterSpacing: -1,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Container(
        //             padding:
        //                 const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        //             decoration: BoxDecoration(
        //               color: cartButtonColor,
        //               borderRadius: BorderRadius.circular(30),
        //             ),
        //             child: const Text(
        //               "Add to Cart",
        //               style: TextStyle(
        //                 fontSize: 20,
        //                 fontWeight: FontWeight.bold,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //         ],
        //       )
        //     ],
        //   ),
        // ),
      );
    });
  }

  Column plantsInfo(icon, name, value) => Column(
        children: [
          Icon(
            icon,
            size: 45,
            color: Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade200,
            ),
          )
        ],
      );
}
