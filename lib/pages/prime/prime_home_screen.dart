import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopau/pages/a_widgets/text_widget.dart';

import '../../models/prime_member.dart';
import '../shopping/shopping_home_page.dart';
import 'a_change_password.dart';

class PrimeHomeScreen extends StatelessWidget {
  final PrimeMember pm;
  const PrimeHomeScreen(this.pm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TextW("AU Prime")),
      drawer: SafeArea(
        child: Drawer(
          // backgroundColor: Colors.pink.shade100,
          width: Get.width - 50,
          child: drawerItems(),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
            width: Get.width,
            child: const Card(
                child: Center(
              child: Text("ADVAITAUNNATHI",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            TextButton(onPressed: () {}, child: const Text("BUY")),
            const Text("|"),
            TextButton(onPressed: () {}, child: const Text("SELL")),
            const Text("|"),
            TextButton(
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 200));
                  // PrimeMember.shareRefLink(pmm);
                },
                child: const Text("REFER")),
          ]),
          CarouselSlider.builder(
            options: CarouselOptions(
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              height: 130.0,
              viewportFraction: 0.7,

              autoPlay: true,
              enlargeCenterPage: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 600),
              // padEnds: false,
              // clipBehavior: Clip.antiAlias,
            ),
            itemCount: 8,
            itemBuilder:
                (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              color: Colors.orange.shade100,
              child: Center(child: Text(itemIndex.toString())),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 150,
            width: 200,
            color: Colors.green.shade200,
            child:
                const Center(child: Text("Notice\nBoard", textScaleFactor: 2)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                Container(
                    color: Colors.purple.shade100,
                    child:
                        const GridTile(child: Center(child: Text("product")))),
                Container(
                    color: Colors.purple.shade100,
                    child:
                        const GridTile(child: Center(child: Text("product")))),
                Container(
                    color: Colors.purple.shade100,
                    child:
                        const GridTile(child: Center(child: Text("product")))),
                Container(
                    color: Colors.purple.shade100,
                    child:
                        const GridTile(child: Center(child: Text("product")))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GFListTile(
          shadow: const BoxShadow(color: Colors.transparent),
          margin: const EdgeInsets.symmetric(vertical: 10),
          titleText: pm.name,
          subTitle: Column(
            children: [
              TextW("Username : ${pm.user_name!}"),
              TextW(pm.email!),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 120));
                    Get.to(() => ChangePassword(pm));
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.key),
                      SizedBox(width: 10),
                      Text("Change password"),
                    ],
                  )),
              // TextButton(
              //     onPressed: () {},
              //     child: Row(
              //       children: const [
              //         Icon(MdiIcons.account),
              //         SizedBox(width: 10),
              //         Text("Profile"),
              //       ],
              //     )),
              TextButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    // Get.to(() => WalletsScreen(pmm));
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.wallet),
                      SizedBox(width: 10),
                      Text("Wallet"),
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    // Get.to(() => DirectIncomeHistory(pmm, wantAppBar: true));
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.accountMultiplePlus),
                      SizedBox(width: 10),
                      Text("Direct referrals"),
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    // var km = KycModel(
                    //     userName: pmm.userName!,
                    //     aadhaarUrl: null,
                    //     panCardUrl: null,
                    //     checkOrPassbookUrl: null,
                    //     accountNumber: null,
                    //     ifsc: null,
                    //     bankName: null,
                    //     updatedTime: null,
                    //     docRef: kycMOs.kycDR(pmm.userName!),
                    //     isKycVerified: null);

                    // await km.docRef!.get().then((ds) async {
                    //   if (ds.exists && ds.data() != null) {
                    //     km = KycModel.fromMap(ds.data()!);
                    //     km.docRef = ds.reference;
                    //   } else {
                    //     await km.docRef!
                    //         .set(km.toMap(), SetOptions(merge: true));
                    //   }
                    //   Get.to(() => KycRegScreen(km));
                    // });
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.shieldCheck),
                      SizedBox(width: 10),
                      Text("KYC Details page"),
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    // await waitMilli();
                    Get.offAll(() => const ShoppingScreenHomePage());
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.cash),
                      SizedBox(width: 10),
                      Text("Redeem AU Coins"),
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 250));
                    Get.offAll(() => const ShoppingScreenHomePage());
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.shopping),
                      SizedBox(width: 10),
                      Text("Shopping"),
                    ],
                  )),
              TextButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 250));
                    Get.offAllNamed("/prime");
                  },
                  child: Row(
                    children: const [
                      Icon(MdiIcons.logout),
                      SizedBox(width: 10),
                      Text("Prime Logout"),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
