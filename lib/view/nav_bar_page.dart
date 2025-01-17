import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saja_stor_app/view/basket_page.dart';
import 'package:saja_stor_app/view/home_page.dart';
import 'package:saja_stor_app/view/order_page.dart';

import '../constant/constants_color.dart';
import '../controller/home_controller.dart';

class NavBarPage extends StatelessWidget {
  const NavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> page = [
      HomePage(),
      OrderPage(),
      BasketPage(),
    ];
    return GetBuilder(
      init: HomeController(),
      builder: (controller) {
        return Scaffold(
          body: page[controller.navIndex],
          backgroundColor: myBackgroundColor,
          bottomNavigationBar: _btn(controller),
        );
      },
    );
  }

  Container _btn(HomeController controller) {
    return Container(
      color: Colors.white,
      height: 95.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 20.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
               
                controller.changeNavIndex(0);
              },
              child: Container(
                padding: EdgeInsets.all(10.h.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: controller.navIndex == 0 ? Color(0xffF0BDBD) : null,
                ),
                child: SvgPicture.asset(
                  'assets/icons/Group 19.svg',
                  // ignore: deprecated_member_use
                  color: controller.navIndex == 0 ? null : Colors.black,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                controller.changeNavIndex(1);
              },
              child: Container(
                padding: EdgeInsets.all(10.h.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: controller.navIndex == 1 ? Color(0xffF0BDBD) : null,
                ),
                child: SvgPicture.asset(
                  'assets/icons/Shopping Bag.svg',
                  // ignore: deprecated_member_use
                  color: controller.navIndex == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                controller.changeNavIndex(2);
              },
              child: Container(
                padding: EdgeInsets.all(10.h.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: controller.navIndex == 2 ? Color(0xffF0BDBD) : null,
                ),
                child: SvgPicture.asset(
                  'assets/icons/Vector-5.svg',
                  // ignore: deprecated_member_use
                  color: controller.navIndex == 2 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
