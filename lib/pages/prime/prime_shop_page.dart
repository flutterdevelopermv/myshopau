import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopau/models/auth_user.dart';
import 'package:myshopau/pages/account/signup_page.dart';
import 'package:myshopau/pages/prime/prime_home_screen.dart';
import '../../models/prime_member.dart';
import '../a_widgets/firestore_listview_builder.dart';
import '../a_widgets/text_widget.dart';

class PrimeShopPage extends StatelessWidget {
  const PrimeShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TextW('AU Prime')),
      body: Column(
        children: [
          GFListTile(
            shadow: BoxShadow(color: Colors.amber.shade100),
            title: const TextW("My Prime Accounts"),
          ),
          Expanded(
            child: FirestoreListViewBuilder(
              query: PrimeMember.col_ref
                  .where(PrimeMember.phone_key,
                      isEqualTo: FireUser.user()
                          ?.phoneNumber
                          ?.replaceAll("+91", "")
                          .trim())
                  .orderBy(PrimeMember.regestratiom_time_key),
              builder: (context, snapshot) {
                var pm = PrimeMember.fromDS(snapshot);
                return GFListTile(
                  shadow: const BoxShadow(color: Colors.transparent),
                  title: TextW(pm.user_name ?? "username"),
                  avatar: const Icon(MdiIcons.account),
                  icon: const Icon(MdiIcons.chevronRight),
                  onTap: () async {
                    await Future.delayed(const Duration(milliseconds: 300));
                    final error = "".obs;
                    var pwdTC = TextEditingController();
                    Get.bottomSheet(
                      Container(
                        height: Get.height / 2,
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Container(
                                width: 50, height: 3, color: Colors.black38),
                            const SizedBox(height: 20),
                            SignupPage.field(
                                icon: MdiIcons.account,
                                lable: pm.user_name!,
                                readOnly: true),
                            const SizedBox(height: 13),
                            SignupPage.field(
                                controller: pwdTC,
                                icon: MdiIcons.key,
                                lable: "Prime password"),
                            Obx(() => SizedBox(
                                height: error.value.isNotEmpty ? 40 : 20,
                                child: error.value.isNotEmpty
                                    ? Center(
                                        child: TextW(error.value,
                                            color: Colors.red))
                                    : null)),
                            GFButton(
                                onPressed: () async {
                                  error.value = "";
                                  await Future.delayed(
                                      const Duration(milliseconds: 300));
                                  if (pwdTC.text != pm.password) {
                                    error.value = "Incorrect Password !";
                                  } else {
                                    Get.back();
                                    await Future.delayed(
                                        const Duration(milliseconds: 300));
                                    Get.to(() => PrimeHomeScreen(pm));
                                  }
                                  //
                                },
                                child: const TextW("Login")),
                          ]),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                    // Get.to(() => PrimeHomeScreen(pm));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 7032046133
// 7386391559
