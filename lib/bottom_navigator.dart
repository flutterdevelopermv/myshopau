import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopau/a_utils/fcm.dart';
import 'package:myshopau/a_utils/hive.dart';
import 'package:myshopau/models/auth_user.dart';
import 'package:myshopau/pages/a_widgets/text_widget.dart';
import 'package:myshopau/pages/account/phone_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'pages/account/user_account_screen.dart';
import 'pages/prime/prime_shop_page.dart';
import 'pages/shopping/categories_page.dart';
import 'pages/shopping/shopping_home_page.dart';

//

class BottomBarWithBody extends StatefulWidget {
  const BottomBarWithBody({Key? key}) : super(key: key);

  @override
  State<BottomBarWithBody> createState() => _BottomBarWithBodyState();
}

class _BottomBarWithBodyState extends State<BottomBarWithBody> {
  @override
  void initState() {
    if (FireUser.user() != null) {
      fcmMainInit();
    }
    HiveApi.openBoxes();
    // FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: PersistentTabController(initialIndex: 0),
      onItemSelected: onTabSelected,
      navBarStyle: NavBarStyle.style8,
      resizeToAvoidBottomInset: true,
      screens: [
        const ShoppingScreenHomePage(),
        const CategoriesPage(),
        StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const UserAccountScreen();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    appBar: AppBar(title: const TextW("My Account")),
                    body: const GFLoader());
              }
              return const PhoneAuthPage();
            }),
        StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return const PrimeShopPage();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    appBar: AppBar(title: const TextW("My Account")),
                    body: const GFLoader());
              }

              return const PhoneAuthPage();
            }),
      ],
      decoration: NavBarDecoration(
          colorBehindNavBar: Colors.white,
          border: Border.all(color: Colors.black26, width: 0.45)),
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.home),
          inactiveIcon: const Icon(MdiIcons.homeOutline),
          activeColorPrimary: Colors.black,
          // activeColorSecondary: Colors.purple,
          inactiveColorSecondary: Colors.black,
          title: "Home",
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.viewGrid),
          inactiveIcon: const Icon(MdiIcons.viewGridOutline),
          activeColorPrimary: Colors.black,
          // activeColorSecondary: Colors.purple,
          inactiveColorSecondary: Colors.black,
          title: "Categories",
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.account),
          inactiveIcon: const Icon(MdiIcons.accountOutline),
          title: "Account",
          activeColorPrimary: Colors.black,
          // activeColorSecondary: Colors.purple,
          inactiveColorSecondary: Colors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(MdiIcons.accountGroup),
          inactiveIcon: const Icon(MdiIcons.accountGroupOutline),
          title: "Prime",
          activeColorPrimary: Colors.black,
          // activeColorSecondary: Colors.purple,
          inactiveColorSecondary: Colors.black,
        ),
      ],
    );
  }

  Future<void> onTabSelected(int index) async {
    if (index == 1) {
      // var k = await Product.query_prefix.order(Product.id_key);
      // print(k);
    }
  }
}


//

