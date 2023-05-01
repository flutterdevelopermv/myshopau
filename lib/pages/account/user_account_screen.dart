import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopau/a_utils/reacts.dart';
import 'package:myshopau/pages/a_widgets/text_widget.dart';
import 'package:myshopau/pages/account/tnc_page.dart';

import '../../models/auth_user.dart';
import 'list_addresses_widget.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Account")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (FireUser.user() != null) profileW(),
          const Divider(thickness: 2),
          GFListTile(
            shadow: const BoxShadow(color: Colors.transparent),
            avatar: const Icon(MdiIcons.orderBoolDescending),
            title: TextButton(onPressed: () {}, child: const Text("My Orders")),
          ),
          GFListTile(
            shadow: const BoxShadow(color: Colors.transparent),
            avatar: const Icon(MdiIcons.orderBoolDescendingVariant),
            title: TextButton(
                onPressed: () async {
                  await Future.delayed(const Duration(milliseconds: 300));
                  Get.to(() => const AddressesScreen());
                },
                child: const Text("My Addresses")),
          ),
          GFListTile(
            shadow: const BoxShadow(color: Colors.transparent),
            avatar: const Icon(MdiIcons.logout),
            title: const TextW("Terms and Conditions, Privacy Policy etc"),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 800));
              Get.to(() => const TnCpage());
            },
          ),
          GFListTile(
            shadow: const BoxShadow(color: Colors.transparent),
            avatar: const Icon(MdiIcons.logout),
            title: Obx(() =>
                Text(Reacts.isLoading.value ? "Please wait..." : "Logout")),
            onTap: () async {
              Reacts.isLoading.value = true;
              await FireUser.fireLogOut();
              Reacts.isLoading.value = false;
              // Get.offAll(() => const ShoppingScreenHomePage());
            },
          ),
        ],
      ),
    );
  }

  Widget profileW() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FireUser.col_ref.doc(FireUser.user()!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            var um = FireUser.fromDS(snapshot.data!);
            return GFListTile(
              shadow: const BoxShadow(color: Colors.transparent),
              avatar: GFAvatar(
                size: GFSize.LARGE,
                backgroundImage: um.profile_pic != null
                    ? CachedNetworkImageProvider(um.profile_pic!)
                    : null,
              ),
              title: Text("${um.first_name} ${um.sur_name ?? ''}"),
              subTitleText: "${um.email}\n${um.phone}}",
              icon: IconButton(
                  onPressed: () {}, icon: const Icon(MdiIcons.pencilOutline)),
            );
          }
          return const GFListTile(
            avatar: GFAvatar(size: GFSize.LARGE),
            titleText: "   ",
            subTitleText: "    ",
          );
        });
  }
}
