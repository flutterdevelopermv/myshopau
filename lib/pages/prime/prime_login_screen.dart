import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:myshopau/a_utils/reacts.dart';
import 'package:myshopau/models/prime_member.dart';

import '../../a_utils/misc.dart';
import '../../a_utils/text_formatters.dart';
import 'prime_home_screen.dart';
import 'prime_payment_page.dart';

class PrimeLoginScreen extends StatefulWidget {
  final PrimeMember pm;
  const PrimeLoginScreen(this.pm, {Key? key}) : super(key: key);

  @override
  State<PrimeLoginScreen> createState() => _PrimeLoginScreenState();
}

class _PrimeLoginScreenState extends State<PrimeLoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //

  var errorUserName = "".obs;

  var errorPassword = "".obs;

  var isValidUser = false.obs;

  String? userNm;
  String? pswd;

  //

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prime Login")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoaPLPMZE1sJX9Ik_FtKM8X1mwam4TnVBgjA&usqp=CAU",
                  )),
              const SizedBox(height: 15),
              userName(),
              password(),
              const SizedBox(height: 15),
              login(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Widget userName() {
    var tc = TextEditingController();
    tc.text = widget.pm.user_name ?? "";
    userNm = tc.text;
    return Row(
      children: [
        const Icon(MdiIcons.accountQuestion),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Obx(() {
            bool isValid = errorUserName.value.contains("valid-");
            var error = isValid
                ? errorUserName.value.replaceAll("valid-", "")
                : errorUserName.value;

            return TextField(
              maxLines: 1,
              autofocus: true,
              controller: tc,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
                labelText: "User Name",
                errorText: error.isNotEmpty ? error : null,
                errorStyle:
                    isValid ? const TextStyle(color: Colors.green) : null,
              ),
              onChanged: (txt) async {
                userNm = null;
                txt.toLowerCase().trim();
                errorUserName.value = "";
                afterDebounce(after: () async {
                  if (txt.length < 6) {
                    errorUserName.value =
                        "User name contains minimum 6 characters";
                  } else if (txt.length > 30) {
                    errorUserName.value =
                        "User name contains maximum 30 characters";
                  } else if (txt.contains(RegExp(r'^[a-z0-9]{6,30}$'))) {
                    userNm = txt.toLowerCase();
                    errorUserName.value = "valid-";
                  } else {
                    errorUserName.value =
                        "User name contains only letters and numbers";
                  }
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget password() {
    var obscureTxt = false.obs;
    return Row(
      children: [
        const Icon(MdiIcons.lockOutline),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Obx(() {
            var fPass = errorPassword.value;
            bool isValid = fPass.contains("valid-");
            var error = isValid ? fPass.replaceAll("valid-", "") : fPass;

            return TextField(
              maxLines: 1,
              obscureText: obscureTxt.value,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.name,
              inputFormatters: [LowerCaseTextFormatter()],
              decoration: InputDecoration(
                suffixIcon: TextButton(
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 250));
                      obscureTxt.value = !obscureTxt.value;
                    },
                    child: Text(obscureTxt.value ? "show" : "hide")),
                labelText: "Enter Password",
                errorText: error.isNotEmpty
                    ? isValid
                        ? "Password Valid"
                        : error
                    : null,
                errorStyle:
                    isValid ? const TextStyle(color: Colors.green) : null,
              ),
              onChanged: (txt) async {
                afterDebounce(after: () async {
                  if (txt.length < 4) {
                    errorPassword.value =
                        "Password contains minimum 4 characters";
                  } else if (txt.length > 10) {
                    errorPassword.value =
                        "Password contains maximum 10 characters";
                  } else {
                    pswd = txt;
                    errorPassword.value = "valid-";
                  }
                });
              },
              onSubmitted: (value) async {
                await onSubmit();
              },
            );
          }),
        ),
      ],
    );
  }

  Widget login() {
    return Column(
      children: [
        Align(
            alignment: Alignment.topRight,
            child: TextButton(
                onPressed: () {}, child: const Text("Forgot Password?"))),
        Obx(
          () => Align(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
                onPressed: () async {
                  await onSubmit();
                },
                child: SizedBox(
                    width: 100,
                    child: Center(
                        child: Reacts.isLoading.value
                            ? const Text("Loading....")
                            : const Text("Login")))),
          ),
        ),
      ],
    );
  }

  Future<void> onSubmit() async {
    Reacts.isLoading.value = true;
    if (userNm != null && pswd != null) {
      await PrimeMember.from_userName(userNm!).then((pm) async {
        if (pm != null) {
          if (pm.password != pswd) {
            pswd = null;
            errorPassword.value = "Incorrect Password";
          } else {
            errorPassword.value = "Incorrectdd";
            await onValid(pm);
          }
        } else {
          userNm = null;
          errorUserName.value = "Incorrect User Name";
        }
      });
    } else if (userNm == null) {
      errorUserName.value = "Please enter User Name";
    } else if (pswd == null) {
      errorPassword.value = "Please enter Password";
    }

    Reacts.isLoading.value = false;
  }

  Future<void> onValid(PrimeMember pm) async {
    // servicesBox.put(primeMOs.userName, pm.user_name);
    if (pm.is_paid() != true || pm.member_position == null) {
      var isPaid = await Razor.check_update_and_get_order_status(pm.user_name!);
      if (isPaid) {
        var pmm = await PrimeMember.from_userName(pm.user_name!);

        Get.to(() => PrimeHomeScreen(pmm ?? pm));
      } else {
        Get.to(() => PrimePaymentPage(pm));
      }
    } else {
      Get.to(() => PrimeHomeScreen(pm));
    }
  }
}
