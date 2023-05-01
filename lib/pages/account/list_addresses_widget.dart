import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myshopau/models/address_model.dart';

import 'address_edit_screen.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Addresses")),
      body: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GFButton(
                    type: GFButtonType.outline2x,
                    splashColor: Colors.blueGrey,
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 300));
                      Get.to(
                          () => AddressEditScreen(AddressModel.emptyAddress()));
                    },
                    child: const Text(" +   Add address   ")),
              )),
          Expanded(
            child: FirestoreListView<Map<String, dynamic>>(
                // shrinkWrap: true,
                loadingBuilder: (context) {
                  return const GFLoader();
                },
                query: AddressModel.col_ref
                    .orderBy(AddressModel.updated_time_key, descending: true),
                itemBuilder: ((context, doc) {
                  var am = AddressModel.fromMap(doc.data());
                  am.docRef = doc.reference;
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      child: Card(
                        elevation: 4,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(am.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                    "${am.house}, ${am.colony}, ${am.pinCodeModel.city}....",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text("Pin code : ${am.pin_code}"),
                                  Text("Phone : ${am.phone}"),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: TextButton(
                                  onPressed: () async {
                                    await Future.delayed(
                                        const Duration(milliseconds: 300));
                                    Get.to(() => AddressEditScreen(am));
                                  },
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.blue),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ],
      ),
    );
  }
}
