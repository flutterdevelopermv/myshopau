import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myshopau/a_utils/supa.dart';

import '../a_utils/fire.dart';
import 'category_model.dart';
import 'package:collection/collection.dart';

//
class Product {
  int id;
  String name;
  List<ProductImage>? list_images;
  DateTime upload_time;
  List<DocumentReference<Map<String, dynamic>>> list_categories;
  List<ProductPrice>? list_prices;
  num high_price;
  num low_price;
  List<String>? descriptions;
  String? price_type;
  bool? is_live;
  Reference? product_sr;

  Product({
    required this.name,
    required this.list_images,
    required this.upload_time,
    required this.list_categories,
    required this.high_price,
    required this.low_price,
    required this.list_prices,
    required this.descriptions,
    required this.is_live,
    required this.id,
    required this.product_sr,
    required this.price_type,
  });

  //
  static const name_key = "name";
  static const list_images_key = "list_images";
  static const upload_time_key = "upload_time";
  static const list_categories_key = "list_categories";
  static const high_price_key = "high_price";
  static const low_price_key = "low_price";
  static const list_prices_key = "list_prices";
  static const descriptions_key = "descriptions";
  static const is_live_key = "is_live";
  static const id_key = "id";

  static const product_sr_key = "product_sr";
  static const price_type_key = "price_type";
  //
  static final col_ref = FirebaseFirestore.instance.collection("products");

  static Future<Map<String, dynamic>> fromID(int number) async {
    return await Supa.client
        .from("products")
        .select<Map<String, dynamic>>()
        .eq(id_key, number)
        .limit(1)
        .single();
  }

//
  static final query_prefix =
      Supa.client.from("products").select<List<Map<String, dynamic>>>();

  //
  Map<String, dynamic> toMap() {
    return {
      name_key: name,
      list_images_key: list_images?.map((e) => e.toMap()).toList(),
      upload_time_key: upload_time.toIso8601String(),
      list_categories_key: list_categories.map((e) => e.id).toList(),
      high_price_key: list_prices != null
          ? (list_prices_desc(list_prices!).last.price ??
              list_prices_desc(list_prices!).last.mrp)
          : high_price,
      low_price_key: list_prices != null
          ? (list_prices_desc(list_prices!).first.price ??
              list_prices_desc(list_prices!).first.mrp)
          : low_price,
      list_prices_key: list_prices?.map((e) => e.toMap()).toList(),
      descriptions_key: descriptions,
      is_live_key: is_live,
      id_key: id,
      product_sr_key: product_sr?.fullPath,
      price_type_key: price_type,
    };
  }

  //
  static Product fromSupa(Map json) {
    var listImages = json[list_images_key] as List?;
    var listPrcs = (json[list_prices_key] as List?)
        ?.mapIndexed((index, e) => ProductPrice.fromMap(e as Map, index))
        .toList();
    listPrcs?.sort((a, b) => (a.price ?? a.mrp).compareTo(b.price ?? b.mrp));

    var listCat = (json[list_categories_key] as List?)
        ?.map(((e) => e.toString()))
        .toList();
    return Product(
      name: json[name_key] ?? "",
      list_images: listImages?.map((e) => ProductImage.fromMap(e)).toList(),
      list_prices: listPrcs,
      upload_time:
          DateTime.tryParse(json[upload_time_key].toString()) ?? DateTime.now(),
      low_price: (listPrcs?.first.price ?? listPrcs?.first.mrp) ?? 0,
      high_price: (listPrcs?.last.price ?? listPrcs?.last.mrp) ?? 0,
      list_categories:
          listCat?.map((e) => CategoryModel.col_ref.doc(e)).toList() ?? [],
      descriptions:
          (json[descriptions_key] as List?)?.map((e) => e.toString()).toList(),
      is_live: json[is_live_key],
      price_type: json[price_type_key],
      id: json[id_key],
      product_sr: json[product_sr_key] != null
          ? Fire.sr.child(json[product_sr_key])
          : null,
    );
  }

  //
  static List<ProductPrice> list_prices_desc(List<ProductPrice> listPrices) {
    listPrices.sort((a, b) => (a.price ?? a.mrp).compareTo((a.price ?? a.mrp)));
    return listPrices;
  }

  //
  // static Future<void> fire_to_supa() async {
  //   await col_ref.get().then((qs) async {
  //     for (var qds in qs.docs) {
  //       var pd = fromDS(qds);
  //       await Supa.client.from("products").insert(pd.toSupaMap());
  //     }
  //   });
  // }

  //
  // static Future<void> print_supa() async {
  //   final data = await Supa.client.from('products').select('*').eq("id", 1);
  //   if (data.runtimeType == List) {
  //     for (var dt in data) {
  //       print(fromSupa(dt).toMap());
  //     }
  //   }
  // }

  //
}

//
class ProductPrice {
  String price_name;
  num mrp;
  num? price;
  int stock_available;
  int max_per_order;
  int id;

  ProductPrice({
    required this.price_name,
    required this.mrp,
    required this.price,
    required this.max_per_order,
    required this.stock_available,
    required this.id,
  });

  //
  static const price_name_key = "price_name";
  static const mrp_key = "mrp";
  static const price_key = "price";
  static const max_per_order_key = "max_per_order";
  static const stock_available_key = "stock_available";
  static const id_key = "id";

  Map<String, dynamic> toMap() {
    return {
      price_name_key: price_name,
      mrp_key: mrp,
      price_key: price,
      max_per_order_key: max_per_order,
      stock_available_key: stock_available,
      id_key: id,
    };
  }

  static ProductPrice fromMap(Map json, index) {
    return ProductPrice(
      price_name: json[price_name_key] ?? "",
      mrp: json[mrp_key] ?? 0,
      price: json[price_key],
      max_per_order: json[max_per_order_key] ?? 1,
      stock_available: json[stock_available_key] ?? 1,
      id: json[id_key] ?? index,
    );
  }
}

//

class ProductImage {
  String url;
  Reference? sr;
  String? name;
  bool? is_primary;

  ProductImage({
    required this.url,
    required this.sr,
    required this.name,
    required this.is_primary,
  });

  //
  static const url_key = "url";
  static const sr_key = "sr";
  static const name_key = "name";
  static const is_primary_key = "is_primary";

  Map<String, dynamic> toMap() {
    return {
      url_key: url,
      sr_key: sr?.fullPath,
      name_key: name,
      is_primary_key: is_primary
    };
  }

  static ProductImage fromMap(Map imageMap) {
    return ProductImage(
      url: imageMap[url_key],
      sr: imageMap[sr_key] != null ? Fire.sr.child(imageMap[sr_key]) : null,
      name: imageMap[name_key],
      is_primary: imageMap[is_primary_key],
    );
  }
}
