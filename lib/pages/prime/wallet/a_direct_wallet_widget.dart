
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:getwidget/getwidget.dart';
// import 'package:intl/intl.dart';


// import 'package:collection/collection.dart';

// import '../../../models/primer.dart';

// class DirectWalletWidget extends StatelessWidget {
//   final Primer pmr;
//   const DirectWalletWidget(this.pmr, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     num debitsAmount = 0;
//     num? balanceAmount;
//     return StreamBuilder<List<num>>(
//         stream: withdrawMOs.streamWithdrawalAmountList(pmr, false),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             debitsAmount = withdrawMOs.listAmount(snapshot.data!);
//           }

//           var shoppingAmount = pmr.directIncome * 500 * 0.1;
//           balanceAmount =
//               pmr.directIncome * 500 - shoppingAmount - debitsAmount;
//           var map = {
//             "Total Referral Income": pmr.directIncome * 500,
//             "Total Withdrwal amount": debitsAmount,
//             "Shopping amount": shoppingAmount,
//             "Balance Amount": balanceAmount,
//           };
//           return Column(
//             children: [
//               GFListTile(
//                 padding: const EdgeInsets.fromLTRB(0, 12, 3, 12),
//                 margin: const EdgeInsets.all(8),
//                 color: Colors.green.shade100,
//                 titleText: "Referral benefits",
//                 subTitle: Padding(
//                     padding: const EdgeInsets.only(top: 5),
//                     child: Table(
//                       columnWidths: const {1: FractionColumnWidth(0.2)},
//                       children: map.keys
//                           .toList()
//                           .mapIndexed((index, key) => TableRow(
//                                 children: [
//                                   Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 5),
//                                       child: Text(key,
//                                           style: ([0, 3].contains(index))
//                                               ? const TextStyle(
//                                                   fontWeight: FontWeight.bold)
//                                               : null)),
//                                   Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Text(
//                                           map[key]?.toStringAsFixed(1) ?? "0.0",
//                                           style: ([0, 3].contains(index))
//                                               ? const TextStyle(
//                                                   fontWeight: FontWeight.bold)
//                                               : null)),
//                                 ],
//                               ))
//                           .toList(),
//                     )),
//                 onTap: () {
//                   Get.to(() => ReferalBenefitsScreen(pmr),
//                       transition: Transition.native);
//                 },
//               ),
//               if (balanceAmount != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: withdrawStatus(balanceAmount: balanceAmount!),
//                 ),
//               // GFButton(
//               //   color: Colors.green,
//               //   onPressed: () async {
//               //     await Future.delayed(const Duration(milliseconds: 150));
//               //   },
//               //   child: const Text("Withdraw"),
//               // ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 30, 5, 5),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       FutureBuilder<bool?>(
//                           future: kycMOs.isPrimeKycVerified(pmr.userName!),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               var isKycVerified = snapshot.data;
//                               if (isKycVerified != true) {
//                                 return const Text(
//                                     "$stopEmoji   Your KYC is not verified.\nPlease get it verified to withdraw");
//                               } else {
//                                 return const SizedBox();
//                               }
//                             }
//                             return const Text(
//                                 "$stopEmoji   Your KYC is not verified.\nPlease get it verified to withdraw");
//                           }),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         });
//   }

//   //
//   void refWithdrawBS() async {
//     if (pmr.directIncome == 0) {
//       Get.bottomSheet(
//         Container(
//             color: Colors.white,
//             height: 150,
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                   "Your referer balance is zero, please get referers and withdraw"),
//             )),
//       );
//     } else {
//       Get.bottomSheet(Container(
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: const [
//               TextField(
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//         ),
//       ));
//     }
//   }

//   //
//   Widget withdrawStatus({required num balanceAmount}) {
//     //
//     //
//     Widget withdrawlButton() {
//       var isPressed = false.obs;
//       Widget withdrawlButton = GFButton(
//         color: Colors.green,
//         onPressed: () async {
//           await Future.delayed(const Duration(milliseconds: 500));
//           if (balanceAmount < 1) {
//             Get.bottomSheet(
//               Container(
//                   color: Colors.white,
//                   height: 150,
//                   child: const Padding(
//                     padding: EdgeInsets.all(20.0),
//                     child: Text(
//                         "Your referer balance is zero, please get referers and withdraw",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   )),
//             );
//           } else {
//             isPressed.value = true;
//           }
//         },
//         child: const Text("Withdraw Balance Amount"),
//       );

//       return Obx(() => isPressed.value
//           ? Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GFButton(
//                   color: Colors.red,
//                   onPressed: () async {
//                     await Future.delayed(const Duration(milliseconds: 500));
//                     isPressed.value = false;
//                   },
//                   child: const Text("Cancle request"),
//                 ),
//                 GFButton(
//                     onPressed: () async {
//                       await Future.delayed(const Duration(milliseconds: 500));
//                       await withdrawMOs.withdrawalsCR().add(WithdrawModel(
//                               isMatrix: false,
//                               userName:
//                                   pmr.userName ?? pmr.memberPosition.toString(),
//                               memberPosition: pmr.memberPosition!,
//                               amount: balanceAmount,
//                               requestedTime: DateTime.now(),
//                               isSettled: null,
//                               adminComments: null,
//                               transactionNumber: null,
//                               isCustomerRecd: null,
//                               reminderTime: null,
//                               isCoinsWithdraw: null,
//                               transactionTime: null)
//                           .toMap());
//                     },
//                     child: const Text("Confirm"))
//               ],
//             )
//           : withdrawlButton);
//     }

//     return StreamSingleQueryBuilder(
//       query: withdrawMOs
//           .withdrawalsCR()
//           .where(withdrawMOs.memberPosition, isEqualTo: pmr.memberPosition)
//           .orderBy(withdrawMOs.requestedTime, descending: true),
//       builder: (qds) {
//         var wm = WithdrawModel.fromMap(qds.data());
//         if (wm.isSettled != true) {
//           return GFListTile(
//             color: Colors.blue.shade50,
//             title: Text(
//                 "Your claim is ${wm.isSettled == true ? 'Settled' : 'Under Progress'}",
//                 textScaleFactor: 1.2,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     decoration: TextDecoration.underline)),
//             subTitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 Text(
//                     "Claim time ${DateFormat("dd MMM yyyy, h:mm a").format(wm.requestedTime)}"),
//                 const SizedBox(height: 10),
//                 Text("Claim amount ₹ ${wm.amount}"),
//                 if (wm.adminComments != null)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Text(
//                       "** ${wm.adminComments!}",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         }
//         return withdrawlButton();
//       },
//       noResultsW: withdrawlButton(),
//     );
//   }
// }
