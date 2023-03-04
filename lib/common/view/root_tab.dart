import 'package:flutter/material.dart';
import 'package:nosepack/common/const/colors.dart';
import 'package:nosepack/common/layout/default_layout.dart';
import 'package:nosepack/product/view/product_screen.dart';
import 'package:nosepack/restaurant/view/restaurant_screen.dart';
import 'package:nosepack/user/view/profile_screen.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(
        length: 4, vsync: this); // need to singletickerproviderstatemixin
    controller.addListener(tabListener);
  }

  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '테스트 앱',
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(), // fix
        controller: controller,
        children: [
          RestaurantScreen(),
          ProductScreen(),
          Center(
            child: Container(
              child: Text("Order"),
            ),
          ),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            controller.animateTo(index);
          },
          currentIndex: index,
          type: BottomNavigationBarType.shifting,
          unselectedFontSize: 10,
          selectedFontSize: 10,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedItemColor: PRIMARY_COLOR,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood_sharp), label: 'Food'),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined), label: 'Order'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add_alt_1_outlined), label: 'Profile'),
          ]),
    );
  }
}
