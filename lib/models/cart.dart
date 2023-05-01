import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshopau/models/product.dart';
import 'auth_user.dart';

class CartItem {
  int quantity;

  int supa_product;
  int price_id;
  DateTime update_at;
  Product? product;
  DocumentReference<Map<String, dynamic>>? docRef;

  CartItem({
    required this.quantity,
    required this.supa_product,
    required this.update_at,
    required this.price_id,
    required this.product,
    this.docRef,
  });

  //
  static const quantity_key = "quantity";
  static const supa_product_key = "supa_product";
  static const update_at_key = "update_at";
  static const selected_price_index_key = "selected_price_index";
  static const product_key = "product";

  //
  static final col_ref =
      FireUser.col_ref.doc(FireUser.user()?.uid).collection("cart_items");

  Map<String, dynamic> toMap() {
    return {
      quantity_key: quantity,
      update_at_key: Timestamp.fromDate(update_at),
      supa_product_key: supa_product,
      selected_price_index_key: price_id
    };
  }

  static CartItem fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};

    return CartItem(
      quantity: json[quantity_key] ?? 0,
      supa_product: json[supa_product_key],
      price_id: json[selected_price_index_key],
      update_at: json[update_at_key]?.toDate(),
      docRef: docSnap.reference,
      product: null,
    );
  }

  static CartItem fromProduct(Product pd) {
    return CartItem(
      quantity: 1,
      supa_product: pd.id,
      update_at: DateTime.now(),
      price_id: (pd.list_prices?.first.id ?? 0),
      product: pd,
      docRef: col_ref.doc(pd.id.toString()),
    );
  }

  //
  
}

//
class Cart {
  num? total_price;
  num? total_mrp;
  int items_count;
  List<CartItem>? list_items;
  num? discount;

  Cart({
    required this.total_price,
    required this.total_mrp,
    required this.items_count,
    required this.list_items,
  });

  static Future<Cart> getCount() async {
    var cm = Cart(
        total_price: null, total_mrp: null, items_count: 0, list_items: null);
    var qs =
        await CartItem.col_ref.orderBy(CartItem.update_at_key).count().get();
    cm.items_count = qs.count;
    return cm;
  }

  //
  static Future<Cart?> getList() async {
    var cm = Cart(
        total_price: null, total_mrp: null, items_count: 0, list_items: null);
    var qs = await CartItem.col_ref.orderBy(CartItem.update_at_key).get();
    for (var qds in qs.docs) {
      var item = CartItem.fromDS(qds);
      try {
        var pdMap = await Product.fromID(item.supa_product);
        var pd = Product.fromSupa(pdMap);
        item.product = pd;
        var priceModel = pd.list_prices?[item.price_id];
        cm.total_price = (cm.total_price ?? 0) + (priceModel?.price ?? 0);
        cm.total_mrp = (cm.total_mrp ?? 0) + (priceModel?.mrp ?? 0);
        if (cm.list_items != null) {
          cm.list_items!.add(item);
        } else {
          cm.list_items = [item];
        }
      } catch (e) {}
    }
    cm.items_count = cm.list_items?.length ?? 0;
    if (cm.total_price != null && (cm.total_mrp ?? 0) > 0) {
      cm.discount = (cm.total_mrp! / cm.total_mrp! * 100).toInt();
    }
    return cm;
  }
}
