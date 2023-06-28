import 'package:flutter/material.dart';

import '../../../models/primer.dart';
import 'a_direct_wallet_widget.dart';
import 'b_matrix_wallet_widget.dart';
import 'c_joining_bonus.dart';

class WalletsScreen extends StatefulWidget {
  final Primer pmr;
  const WalletsScreen(this.pmr, {Key? key}) : super(key: key);

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabC;
  @override
  void initState() {
    super.initState();
    tabC = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Wallet"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40.0),
            child: TabBar(
              controller: tabC,
              indicatorColor: Colors.white70,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              tabs: const [
                SizedBox(height: 45, child: Center(child: Text("Promotional"))),
                SizedBox(height: 45, child: Center(child: Text("Referral"))),
                SizedBox(height: 45, child: Center(child: Text("Joining"))),
              ],
              indicatorWeight: 2.5,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TabBarView(
          controller: tabC,
          children: [
            const SizedBox(),
            // MatrixWalletWidget(widget.pmr),
            const SizedBox(),
            // DirectWalletWidget(widget.pmr),
            JoiningBonusWidget(widget.pmr),
          ],
        ),
      ),
    );
  }
}




// class WalletHomeScreen extends StatelessWidget {
//   PrimeMemberModel pmm;
//   WalletHomeScreen(this.pmm, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Wallet"),
//       ),
//       body: Column(
//         children: [
//           StreamDocBuilder(
//             docRef: pmm.docRef!,
//             builder: (docSnap) {
//               pmm = PrimeMemberModel.fromMap(docSnap.data()!);
//               pmm.docRef = docSnap.reference;
//               return bodyW(pmm);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget bodyW(PrimeMemberModel pm) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Card(
//             shadowColor: Colors.green.shade200,
//             elevation: 2,
//             child: DirectWalletWidget(pmm),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Card(
//             shadowColor: Colors.green.shade200,
//             elevation: 2,
//             child: MatrixWalletWidget(pmm),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget directWithdraw(PrimeMemberModel pm) {
//     var errorAmount = "".obs;
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Obx(() => TextField(
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: "Withdrawal amount",
//                   errorText:
//                       errorAmount.value.isEmpty ? errorAmount.value : null,
//                 ),
//                 onChanged: (value) {
//                   if (value.isNum) {
//                     int amount = num.tryParse(value)!.toInt();
//                     afterDebounce(after: () async {});
//                   } else {
//                     errorAmount.value = "Enter valid amount";
//                   }
//                 },
//               )),
//         ),
//         const Text(
//             "Your KYC is not verified.\nPlease get it verified to withdraw"),
//       ],
//     );
//   }

//   void redeemCoins() {
//     Get.bottomSheet(Container(
//       color: Colors.white,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: const [TextField()],
//         ),
//       ),
//     ));
//   }
// }
