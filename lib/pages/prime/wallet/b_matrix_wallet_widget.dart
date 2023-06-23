
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:getwidget/getwidget.dart';

import '../../../models/primer.dart';
import '../../a_widgets/stream_single_query_builder.dart';



class MatrixWalletWidget extends StatelessWidget {
  final Primer pmr;
  const MatrixWalletWidget(this.pmr, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GFListTile(
          padding: const EdgeInsets.fromLTRB(0, 12, 3, 12),
          margin: const EdgeInsets.all(8),
          color: Colors.blue.shade100,
          titleText: "Promotional coins",
          subTitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: StreamSingleQueryBuilder(
                query: Primer.col_ref
                    .orderBy(Primer.primer_position_key, descending: true),
                builder: (snapshot) {
                  var pmLast = Primer.fromDS(snapshot);
                  return StreamBuilder<List<num>>(
                      stream:
                          withdrawMOs.streamWithdrawalAmountList(pmr, false),
                      builder: (context, snapshot) {
                        num? amount;
                        if (snapshot.hasData) {
                          amount = withdrawMOs.listAmount(snapshot.data!);
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "Credits = ${matrixIncome(pmr.memberPosition ?? 0, pmLast.memberPosition ?? 0)}"),
                            Text("Debits = ${amount ?? ''}"),
                          ],
                        );
                      });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GFButton(
              onPressed: () async {},
              child: const Text("Redeem Coins"),
            ),
            GFButton(
              onPressed: () async {},
              child: const Text("Withdraw"),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<bool?>(
                    future: kycMOs.isPrimeKycVerified(pmr.userName!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var isKycVerified = snapshot.data;
                        if (isKycVerified != true) {
                          return const Text(
                              "$stopEmoji   Your KYC is not verified.\nPlease get it verified to withdraw");
                        } else {
                          return const SizedBox();
                        }
                      }
                      return const Text(
                          "$stopEmoji   Your KYC is not verified.\nPlease get it verified to withdraw");
                    }),
                const SizedBox(height: 15),
                FutureBuilder<num>(
                    future: withdrawMOs.matrixIncomeF(pmr.memberPosition!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var mi = snapshot.data!;

                        return Column(
                          children: [
                            if (needDirectRef(mi.toInt()) > pmr.directIncome)
                              Text(
                                "$stopEmoji   You are in Level ${currentLevel(mi.toInt())}, you need to have ${needDirectRef(mi.toInt())} direct referrals to eligible for withdraw\n(current direct referrels = ${pmr.directIncome})",
                              ),
                            if (blockedMatrixIncome(mi.toInt()) != 0)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text(
                                  "\u{1F512}  Your ${blockedMatrixIncome(mi.toInt())} coins has been reserved for Level upgradation",
                                ),
                              ),
                          ],
                        );
                      }
                      return const SizedBox();
                    }),
                FutureBuilder<num>(
                    future: withdrawMOs.netIncome(pmr, true),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var ni = snapshot.data!;
                        if (ni > 0) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                            child: Text(
                                "\u{2705}   You are eligible to Redeem $ni AU Coins, via myshopau.com"),
                          );
                        }
                      }
                      return const SizedBox();
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //
  Future<void> matrixWithdrawBS() async {
    var isKycVerified = await kycMOs.isPrimeKycVerified(pmr.userName!);
    var mi = await withdrawMOs.matrixIncomeF(pmr.memberPosition!);

    if (isKycVerified != true || needDirectRef(mi.toInt()) != 0) {
      Get.bottomSheet(Container(
        height: 250,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isKycVerified != true)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "$stopEmoji   Your KYC is not verified.\nPlease get it verified to withdraw"),
                ),
              if (needDirectRef(mi.toInt()) != 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$stopEmoji   You are in Level ${currentLevel(mi.toInt())}, you need to have ${needDirectRef(mi.toInt())} direct referrals to eligible for withdraw (current direct referrels = ${pmr.directIncome})",
                  ),
                ),
            ],
          ),
        ),
      ));
    }
  }
}
