import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopau/bottom_navigator.dart';
import 'package:myshopau/models/auth_user.dart';

import '../../a_utils/fcm.dart';
import '../a_widgets/text_widget.dart';

class SignupPage extends StatelessWidget {
  final String phoneNumber;
  const SignupPage(this.phoneNumber, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailTC = TextEditingController();

    var fnTC = TextEditingController();
    var lstTC = TextEditingController();
    var homeTC = TextEditingController();
    var dobTC = TextEditingController();

    final error = "".obs;

    final is_male = true.obs;
    final dateFormat = DateFormat("dd/MM/yyyy");
    return Scaffold(
      appBar: AppBar(title: const TextW('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(children: [
            field(
                icon: MdiIcons.cellphoneText,
                lable: "Phone number",
                controller: TextEditingController(text: phoneNumber),
                readOnly: true),
            const SizedBox(height: 10),
            field(
              icon: MdiIcons.email,
              lable: "Email id",
              keyboardType: TextInputType.emailAddress,
              controller: emailTC,
            ),
            const SizedBox(height: 10),
            field(
              icon: MdiIcons.accountSchool,
              lable: "First name",
              controller: fnTC,
            ),
            const SizedBox(height: 10),
            field(
              icon: MdiIcons.account,
              lable: "Last name",
              controller: lstTC,
            ),
            const SizedBox(height: 10),
            field(
                icon: MdiIcons.homeCity,
                lable: "Home town",
                controller: homeTC),
            const SizedBox(height: 15),
            field(
              icon: MdiIcons.cakeVariant,
              lable: "Date of Birth",
              readOnly: true,
              controller: dobTC,
              onTap: () async {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 100)),
                  lastDate: DateTime.now(),
                  selectableDayPredicate: (day) {
                    dobTC.text = dateFormat.format(day);
                    return true;
                  },
                );
              },
            ),
            const SizedBox(height: 15),
            Obx(() => Row(children: [
                  const TextW("Gender"),
                  const SizedBox(width: 20),
                  GFButton(
                      type: GFButtonType.outline,
                      color: is_male.value ? Colors.black : Colors.black12,
                      child: TextW("Male",
                          color: is_male.value ? Colors.black : Colors.black87),
                      onPressed: () {
                        is_male.value = true;
                      }),
                  const SizedBox(width: 20),
                  GFButton(
                      type: GFButtonType.outline,
                      color: !is_male.value ? Colors.black : Colors.black12,
                      child: TextW("Female",
                          color:
                              !is_male.value ? Colors.black : Colors.black87),
                      onPressed: () {
                        is_male.value = false;
                      }),
                  const Spacer(),
                ])),
            Obx(() => SizedBox(
                  height: error.value.isNotEmpty ? 60 : 40,
                  child: error.value.isNotEmpty
                      ? Center(child: TextW(error.value, color: Colors.red))
                      : null,
                )),
            SizedBox(
                width: Get.width / 2,
                height: 40,
                child: GFButton(
                  elevation: 2,
                  child: const TextW("Sign up",
                      textScaleFactor: 1.2, is_bold: true),
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 750));

                    error.value = "";
                    if (emailTC.text.isEmail == false) {
                      error.value = "Please enter valid Email id";
                    } else if (fnTC.text.isEmpty) {
                      error.value = "Please enter valid First name";
                    } else if (lstTC.text.isEmpty) {
                      error.value = "Please enter valid Last name";
                    } else if (lstTC.text.length < 4) {
                      error.value = "Please enter valid Home town";
                    } else if (dobTC.text.isNotEmpty &&
                        (dateFormat
                                    .parse(dobTC.text)
                                    .difference(DateTime.now())
                                    .inDays)
                                .abs() <
                            365 * 10) {
                      error.value = "Please enter valid Date of Birth";
                    }

                    //
                    if (error.value.isEmpty && FireUser.user() != null) {
                      var token = await FCMfunctions.checkFCMtoken();
                      await FireUser.col_ref
                          .doc(FireUser.user()!.uid)
                          .set(FireUser(
                                  first_name: fnTC.text,
                                  sur_name: lstTC.text,
                                  phone: phoneNumber,
                                  email: emailTC.text,
                                  is_male: is_male.value,
                                  dob: dateFormat.parse(dobTC.text),
                                  home_town: homeTC.text,
                                  profile_pic: null,
                                  fcm_token: token,
                                  first_login_time: DateTime.now(),
                                  docRef: FireUser.col_ref
                                      .doc(FireUser.user()!.uid))
                              .toMap())
                          .then(
                              (value) => Get.offAll(const BottomBarWithBody()));
                    }
                  },
                )),
          ]),
        ),
      ),
    );
  }

  static Widget field(
      {double? width,
      required IconData icon,
      required String lable,
      TextEditingController? controller,
      TextInputType? keyboardType,
      TextInputAction? textInputAction,
      FocusNode? focusNode,
      String? errorText,
      void Function()? onEditingComplete,
      bool readOnly = false,
      bool is_obscure = false,
      bool req_couter = false,
      void Function()? onTap,
      int? maxLength}) {
    OutlineInputBorder boarder({Color? color}) {
      return OutlineInputBorder(
        borderSide: BorderSide(width: 0.5, color: color ?? Colors.black26),
        borderRadius: BorderRadius.circular(10),
      );
    }

    //
    var obscure = true.obs;

    return Obx(() => TextField(
        keyboardType: keyboardType,
        controller: controller,
        readOnly: readOnly,
        obscureText: is_obscure ? obscure.value : !obscure.value,
        textInputAction: textInputAction ?? TextInputAction.next,
        maxLength: maxLength,
        focusNode: focusNode,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          enabledBorder: boarder(),
          focusedBorder: boarder(),
          disabledBorder: boarder(),
          errorBorder: boarder(color: Colors.red),
          focusedErrorBorder: boarder(color: Colors.red),
          hintText: lable,
          hintStyle: const TextStyle(
              color: Colors.black54, fontWeight: FontWeight.w300),
          counterText: req_couter ? null : "",
          errorMaxLines: 3,
          prefixIcon: Icon(icon, color: Colors.black26),
          suffixIcon: is_obscure
              ? IconButton(
                  onPressed: () {
                    obscure.value = !obscure.value;
                  },
                  icon: Icon(
                      obscure.value ? MdiIcons.eyeOffOutline : MdiIcons.eye,
                      color: Colors.black26))
              : null,
          errorText: errorText != null
              ? (errorText.isNotEmpty ? errorText : null)
              : null,
        ),
        onTap: onTap,
        onEditingComplete: onEditingComplete));
  }
}
