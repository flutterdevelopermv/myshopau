import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:myshopau/a_utils/reacts.dart';
import 'package:myshopau/models/auth_user.dart';
import 'package:myshopau/pages/account/signup_page.dart';
import 'package:myshopau/pages/account/tnc_page.dart';
import 'package:pinput/pinput.dart';

import '../../bottom_navigator.dart';
import '../a_widgets/lottie_widgets.dart';
import '../a_widgets/text_widget.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneTC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blue, Colors.purple])),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        TextW("Login / Signup",
                            is_white: true, is_heading: true, is_bold: true),
                        SizedBox(height: 10),
                        TextW("Manage Orders | Access Wishlist | Unlock Offers",
                            is_white: true)
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                        height: 200,
                        child: FittedBox(
                            fit: BoxFit.fill, child: Lotties.login())),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const TextW(
                      "Please enter your Phone number to Login / Signup on MyShopAU"),
                  const SizedBox(height: 30),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(
                            width: 40,
                            child: TextField(
                                controller: countryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: InputBorder.none))),
                        const Text("|",
                            style: TextStyle(fontSize: 33, color: Colors.grey)),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          controller: phoneTC,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",
                          ),
                        ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        const TextSpan(
                            text: "By continuing, you agree to MyShopAU's "),
                        TextSpan(
                            text: "Terms of Use and Privacy Policy",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 200));
                                Get.to(() => const TnCpage());
                              }),
                      ])),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: GFButton(
                        elevation: 2,
                        onPressed: () async {
                          Reacts.isLoading.value = true;
                          if (phoneTC.text.isNum && phoneTC.text.length == 10) {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '+91 ${phoneTC.text}',
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {
                                print(
                                    "Verification done ${credential.smsCode}");
                              },
                              verificationFailed: (FirebaseAuthException e) {
                                print(e.message);
                              },
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                Reacts.isLoading.value = false;
                                Get.to(() => OtpVerificationPage(
                                    verificationId, phoneTC.text));
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          }
                        },
                        child: Obx(() => TextW(Reacts.isLoading.value
                            ? "Loading.."
                            : "Continue"))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//

class OtpVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OtpVerificationPage(this.verificationId, this.phoneNumber, {Key? key})
      : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    //
    var otpTC = TextEditingController();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 200,
                  child: FittedBox(fit: BoxFit.fill, child: Lotties.login())),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                controller: otpTC,
                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: GFButton(
                    elevation: 2,
                    onPressed: () async {
                      if (otpTC.text.length == 6) {
                        var cred = PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpTC.text);
                        var uc = await FirebaseAuth.instance
                            .signInWithCredential(cred);
                        // print(uc);
                        // print(FireUser.user());

                        if (uc.user != null) {
                          var ds =
                              await FireUser.col_ref.doc(uc.user!.uid).get();

                          var fu = FireUser.fromDS(ds);
                          if (fu.phone != null) {
                            Get.offAll(() => const BottomBarWithBody());
                          } else {
                            Get.to(() => SignupPage(widget.phoneNumber));
                          }
                        }
                        // try {
                        //   var uc = await FirebaseAuth.instance
                        //       .signInWithCredential(cred);
                        //   print(uc);
                        //   print(FireUser.user());
                        //   if (uc.user != null) {
                        //     var fu = await FireUser.get();
                        //     if (fu?.phone != null) {
                        //       Get.offAll(() => const BottomBarWithBody());
                        //     } else {
                        //       Get.to(() => SignupPage(widget.phoneNumber));
                        //     }
                        //   }
                        // } catch (e) {
                        //   Get.snackbar("Verification Failed ${e.toString()}",
                        //       "Please enter valid details",
                        //       backgroundColor: Colors.white);
                        // }
                      }
                      // 6304242566
                    },
                    child: const Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
