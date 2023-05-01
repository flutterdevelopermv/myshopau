import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../models/prime_member.dart';

class PrimePaymentPage extends StatefulWidget {
  PrimeMember pmm;
  PrimePaymentPage(this.pmm, {Key? key}) : super(key: key);

  @override
  State<PrimePaymentPage> createState() => _PrimePaymentPageState();
}

class _PrimePaymentPageState extends State<PrimePaymentPage> {
  @override
  void initState() {
    Razor.razorInIt(widget.pmm.user_name!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        actions: [
          IconButton(
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 200));
              Get.toNamed("/prime");
            },
            icon: const Icon(MdiIcons.alphaPCircleOutline),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: widget.pmm.docRef!.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              var pmm = PrimeMember.fromDS(snapshot.data!);
              if (pmm.is_paid() == true) {
                return success(pmm);
              } else if (pmm.is_paid() == false) {
                return attempted(pmm);
              } else {
                return unattempted(pmm);
              }
            }
            return const GFLoader();
          }),
    );
  }

  Widget unattempted(PrimeMember pmm) {
    return Column(
      children: [
        intro(pmm),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              "Proceed to pay Rs.1000/- prime member ship fee, to become a Prime member, to recieve prime benefits"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GFButton(
            child: pmm.order_id != null
                ? const Text("Proceed")
                : const Text("Please wait..."),
            onPressed: () async {
              await Future.delayed(const Duration(milliseconds: 200));
              if (pmm.order_id != null) {
                Razor.razorOrder(pmm);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget attempted(PrimeMember pmm) {
    return Column(
      children: [
        intro(pmm),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Your previous payment is unsuccessfull / pending"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GFButton(
              child: const Text("Check status"),
              onPressed: () async {
                var isPaid = await Razor.check_update_and_get_order_status(
                    pmm.user_name!);

                if (isPaid) {
                  Get.snackbar(
                      "Your payment is successful", "Proceed to prime");
                } else {
                  Get.snackbar("Your payment is unsuccessful / pending",
                      "Please try again");
                }
              },
            ),
            GFButton(
              child: const Text("Pay"),
              onPressed: () async {
                await Future.delayed(const Duration(milliseconds: 200));
                Razor.razorOrder(pmm);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget success(PrimeMember pmm) {
    return Column(
      children: [
        const Text("Your payment is successful"),
        GFButton(
          child: const Text("Proceed to Prime"),
          onPressed: () async {
            await Future.delayed(const Duration(milliseconds: 200));
          },
        ),
      ],
    );
  }

  Widget intro(PrimeMember pmm) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              "Hi ${pmm.name}, Thanks for your registration to the Prime membership"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Your User Name is : ${pmm.user_name}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Your Member ID is : ${pmm.member_id}"),
        ),
      ],
    );
  }
}
