import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../a_utils/fire.dart';

class CategoryModel {
  String name;
  String? image_url;
  DateTime upload_time;
  Reference? image_sr;
  List<DocumentReference<Map<String, dynamic>>>? sub_categories;
  bool? is_main;
  int? rank;
  DocumentReference<Map<String, dynamic>>? docRef;

  CategoryModel({
    required this.name,
    required this.image_url,
    required this.upload_time,
    required this.image_sr,
    required this.sub_categories,
    required this.is_main,
    required this.rank,
    required this.docRef,
  });
  Map<String, dynamic> toMap() {
    return {
      name_key: name,
      image_url_key: image_url,
      upload_time_key: Timestamp.fromDate(upload_time),
      image_sr_key: image_sr?.fullPath,
      sub_categories_key: sub_categories?.map((e) => e.id).toList(),
      is_main_key: is_main,
      rank_key: rank,
    };
  }

  //
  static final col_ref = FirebaseFirestore.instance.collection("categories");
  //
  static const name_key = "name";
  static const image_url_key = "image_url";
  static const upload_time_key = "upload_time";

  static const image_sr_key = "image_sr";
  static const sub_categories_key = "sub_categories";
  static const is_main_key = "is_main";
  static const rank_key = "rank";
  //

  static CategoryModel fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};

    return CategoryModel(
      name: json[name_key],
      image_url: json[image_url_key],
      upload_time: json[upload_time_key]?.toDate(),
      image_sr:
          json[image_sr_key] != null ? Fire.sr.child(json[image_sr_key]) : null,
      sub_categories: json[sub_categories_key]
          ?.map((e) => col_ref.doc(e.toString()))
          .toList(),
      is_main: json[is_main_key],
      rank: json[rank_key],
      docRef: docSnap.reference,
    );
  }
}
