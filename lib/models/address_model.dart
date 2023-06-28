import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:myshopau/models/auth_user.dart';

class AddressM {
  String name;
  String phone;
  String house;
  String colony;
  String? landmark;
  String pin_code;
  String post_office;
  PinCodeModel pinCodeModel;
  DateTime updated_time;
  DocumentReference<Map<String, dynamic>>? docRef;

  AddressM({
    required this.name,
    required this.phone,
    required this.house,
    required this.colony,
    required this.landmark,
    required this.pin_code,
    required this.post_office,
    required this.pinCodeModel,
    required this.updated_time,
  });

  //
  static const name_key = "name";
  static const phone_key = "phone";
  static const house_key = "house";
  static const colony_key = "colony";
  static const landmark_key = "landmark";
  static const post_office_key = "post_office";
  static const pin_code_key = "pin_code";
  static const pinCodeModel_key = "pinCodeModel";
  static const updated_time_key = "updated_time";
  //
  static final col_ref =
      FireUser.col_ref.doc(FireUser.user()?.uid).collection("address");

  Map<String, dynamic> toMap() {
    return {
      addressMOs.name: name,
      addressMOs.phone: phone,
      addressMOs.house: house,
      addressMOs.colony: colony,
      addressMOs.landmark: landmark,
      addressMOs.pinCode: pin_code,
      addressMOs.postOffice: post_office,
      addressMOs.updatedTime: Timestamp.fromDate(updated_time),
      addressMOs.pinCodeModel: pinCodeModel.toMap(),
    };
  }

  factory AddressM.fromMap(Map<String, dynamic> addressMap) {
    return AddressM(
      name: addressMap[addressMOs.name] ?? "",
      phone: addressMap[addressMOs.phone] ?? "",
      house: addressMap[addressMOs.house] ?? "",
      colony: addressMap[addressMOs.colony] ?? "",
      landmark: addressMap[addressMOs.landmark] ?? "",
      pin_code: addressMap[addressMOs.pinCode] ?? "",
      post_office: addressMap[addressMOs.postOffice] ?? "",
      updated_time:
          addressMap[addressMOs.updatedTime]?.toDate() ?? DateTime.now(),
      pinCodeModel: PinCodeModel.fromMap(addressMap[addressMOs.pinCodeModel]),
    );
  }

  //
  static AddressM emptyAddress() {
    return AddressM(
        name: "",
        phone: "",
        house: "",
        colony: "",
        landmark: '',
        pin_code: "",
        post_office: "",
        pinCodeModel: PinCodeModel(
            isValid: false,
            listAreas: null,
            city: null,
            district: null,
            state: null),
        updated_time: DateTime.now());
  }
}

//
AddressModelObjects addressMOs = AddressModelObjects();

class AddressModelObjects {
  final name = "name";
  final phone = "phone";
  final house = "house";
  final colony = "street";

  final landmark = "landmark";
  final postOffice = "postOffice";

  final pinCode = "pinCode";

  final pinCodeModel = "pinCodeModel";
  final updatedTime = "updatedTime";

  // final addressCR = authUserCR.doc(fireUser()?.uid).collection("address");

  Future<AddressM> dummyAddressModel() async {
    var pinM = await getPinModel(521126);

    return AddressM(
      name: "MV Phaneendra",
      phone: "9848699360",
      house: "7-27/1, last house",
      colony: "Sri nagar",
      landmark: "Opst to govt school",
      pin_code: "521126",
      post_office: "",
      updated_time: DateTime.now(),
      pinCodeModel: pinM ??
          PinCodeModel(
              isValid: false,
              listAreas: null,
              city: null,
              district: null,
              state: null),
    );
  }
}

//

class PinCodeModel {
  bool isValid; // Success
  List? listAreas; //Name
  String? city; // Block
  String? district; // District
  String? state; // State

  PinCodeModel({
    required this.isValid,
    required this.listAreas,
    required this.city,
    required this.district,
    required this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      "isValid": isValid,
      "listAreas": listAreas,
      "city": city,
      "district": district,
      "state": state,
    };
  }

  factory PinCodeModel.fromMap(Map<String, dynamic> pinMap) {
    return PinCodeModel(
        isValid: pinMap["isValid"] ?? false,
        listAreas: pinMap["listAreas"],
        city: pinMap["city"],
        district: pinMap["district"],
        state: pinMap["state"]);
  }

  factory PinCodeModel.fromJson(Map<String, dynamic> pinMap) {
    var pcm = PinCodeModel(
        isValid: false,
        listAreas: null,
        city: null,
        district: null,
        state: null);
    String status = pinMap["Status"];
    if (status == "Success") {
      pcm.isValid = true;
      List offices = pinMap["PostOffice"];
      List<String> listAreas =
          offices.map((e) => e["Name"].toString()).toList();
      pcm.listAreas = listAreas;
      pcm.city = offices.first["Block"];
      pcm.district = offices.first["District"];
      pcm.state = offices.first["State"];
    }

    return pcm;
  }
}

Future<PinCodeModel?> getPinModel(int pinCode) async {
  if (pinCode.toString().length == 6) {
    var url = Uri.parse("https://api.postalpincode.in/pincode/$pinCode");
    Response response = await http.get(url);
    // print(response.body);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      Map<String, dynamic> map = data.first;

      return PinCodeModel.fromJson(map);
    }
  }
  return null;
}
