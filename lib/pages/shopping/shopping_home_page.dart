import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopau/models/auth_user.dart';
import 'package:myshopau/pages/account/phone_page.dart';

import '../a_widgets/text_widget.dart';
import 'product_details_screen.dart';
//
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myshopau/models/cart.dart';
import 'package:myshopau/models/product.dart';

//
class ShoppingScreenHomePage extends StatefulWidget {
  const ShoppingScreenHomePage({Key? key}) : super(key: key);

  @override
  State<ShoppingScreenHomePage> createState() => _ShoppingScreenHomePageState();
}

class _ShoppingScreenHomePageState extends State<ShoppingScreenHomePage> {
  @override
  void initState() {
    // FCMfunctions.setupInteractedMessage();
    // FCMfunctions.onMessage();
    // FCMfunctions.checkFCMtoken();
    // userMOs.userInit();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          var user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text("MyShopAU"),
              actions: [
                // if (user != null)
                //   IconButton(
                //     onPressed: () async {
                //       // await PrimeMember.update_ref_doc();
                //     },
                //     icon: const Icon(MdiIcons.heart),
                //   ),
                // IconButton(
                //   onPressed: () async {
                //     await waitMilli(250);
                //     Get.toNamed("/prime");
                //   },
                //   icon: const Icon(MdiIcons.alphaPCircleOutline),
                // ),
                // IconButton(
                //   onPressed: () {
                //     if (snapshot.hasData) {
                //       Get.to(() => const UserAccountScreen());
                //     } else {
                //       bottomBarLogin();
                //     }
                //   },
                //   icon: const Icon(MdiIcons.accountCircleOutline),
                // ),

                if (user == null)
                  TextButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        Get.to(() => const PhoneAuthPage());
                      },
                      child: const TextW("Log In")),
              ],
            ),
            body: ListView(
              children: const [
                SizedBox(height: 10),
                ProductsGridList(),
                SizedBox(height: 60),
                SizedBox(height: 10),
              ],
            ),
          );
        });
  }
}

class ProductsGridList extends StatelessWidget {
  const ProductsGridList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Product.query_prefix
          .eq(Product.is_live_key, true)
          .order(Product.id_key),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          var list = snapshot.data ?? [];
          var list_prod = list.map((e) => Product.fromSupa(e)).toList();
          return ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //     childAspectRatio: 0.9, maxCrossAxisExtent: Get.width / 2),
            // const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2),
            itemCount: list_prod.length,
            itemBuilder: (context, index) {
              var pm = list_prod[index];

              return DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 200));
                        Get.to(() => ProductViewScreen(pm));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 120,
                              child: CachedNetworkImage(
                                  imageUrl: pm.list_images?.first.url ?? "",
                                  errorWidget: (context, url, error) =>
                                      Container(color: Colors.black12),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(pm.name),
                                  const SizedBox(height: 10),
                                  if (pm.list_prices != null)
                                    (pm.list_prices!.first.mrp ==
                                            pm.list_prices!.first.price)
                                        ? Text(
                                            "\u{20B9}${pm.list_prices?.first.mrp}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "\u{20B9}${pm.list_prices?.first.price}",
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                  "\u{20B9}${pm.list_prices?.first.mrp}",
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                  textScaleFactor: 0.9),
                                              const SizedBox(width: 10),
                                              Text(
                                                  "${((1 - pm.list_prices!.first.price! / pm.list_prices!.first.mrp) * 100).toStringAsFixed(0)}% off",
                                                  textScaleFactor: 0.9,
                                                  style: TextStyle(
                                                    color: Colors
                                                        .deepOrange.shade600,
                                                  )),
                                            ],
                                          ),
                                  const SizedBox(height: 5),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: addToCart(pm)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          );
        }
        return const GFLoader();
      },
    );
  }

  //
  Widget addToCart(Product pd) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: CartItem.fromProduct(pd).docRef?.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data != null && snapshot.data!.exists) {
          var ct = CartItem.fromDS(snapshot.data!);
          return Column(
            children: [
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GFIconButton(
                      type: GFButtonType.outline,
                      size: GFSize.SMALL,
                      color: Colors.purple,
                      icon: const Icon(MdiIcons.minus),
                      onPressed: () async {
                        await Future.delayed(const Duration(microseconds: 900));
                        if (ct.quantity == 1) {
                          await ct.docRef!.delete();
                        } else {
                          ct.quantity--;
                          await ct.docRef!.update(ct.toMap());
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Text(
                      ct.quantity.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          decoration: ct.quantity >
                                  pd.list_prices!.first.stock_available
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                  ),
                  GFIconButton(
                    color: Colors.purple,
                    type: GFButtonType.outline,
                    size: GFSize.SMALL,
                    icon: const Icon(MdiIcons.plus),
                    onPressed: () async {
                      await Future.delayed(const Duration(microseconds: 900));
                      if (ct.quantity < pd.list_prices!.first.max_per_order &&
                          ct.quantity < pd.list_prices!.first.stock_available) {
                        ct.quantity++;
                        await ct.docRef!.update(ct.toMap());
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        }
        return GFButton(
          position: GFPosition.end,
          elevation: 0,
          color: Colors.black87,
          type: GFButtonType.outline,
          child: const Text("Add to cart"),
          onPressed: () async {
            await Future.delayed(const Duration(microseconds: 900));
            if (FireUser.user() != null) {
              await CartItem.col_ref.doc(pd.id.toString()).set(
                  CartItem.fromProduct(pd).toMap(), SetOptions(merge: true));
            }
          },
        );
      },
    );
  }
}
