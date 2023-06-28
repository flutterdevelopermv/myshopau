import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshopau/models/product.dart';
import 'address_model.dart';
import 'auth_user.dart';
import 'coupon.dart';
//

//
class Cart {
  List<CartItem> list_items;
  num? delivery_fee;
  List<OrderCoupon> coupons;
  AddressM? address;

  Cart({
    required this.list_items,
    required this.delivery_fee,
    required this.coupons,
    required this.address,
  });

  //
  static Future<Cart> getCart() async {
    var cm =
        Cart(list_items: [], delivery_fee: null, address: null, coupons: []);
    var qs = await CartItem.col_ref.orderBy(CartItem.updated_time_key).get();
    for (var qds in qs.docs) {
      var item = CartItem.fromDS(qds);
      try {
        var pdMap = await Product.fromID(item.supa_product);
        var pd = Product.fromSupa(pdMap);
        item.product = pd;
        if (cm.list_items.isNotEmpty) {
          cm.list_items.add(item);
        } else {
          cm.list_items = [item];
        }
      } catch (e) {}
    }
    return cm;
  }

  //

  //
}

//
class CartItem {
  int quantity;
  int supa_product;
  String priceId;
  DateTime updated_time;
  Product? product;
  DocumentReference<Map<String, dynamic>>? docRef;

  CartItem({
    required this.quantity,
    required this.supa_product,
    required this.updated_time,
    required this.priceId,
    required this.product,
    this.docRef,
  });

  //
  static const quantity_key = "quantity";
  static const supa_product_key = "supa_product";
  static const updated_time_key = "updated_time";
  static const priceId_key = "priceId";
  static const product_key = "product";

  //
  static final col_ref =
      FireUser.col_ref.doc(FireUser.user()?.uid).collection("cart_items");

  //
  Query<Map<String, dynamic>> item_ref() => col_ref
      .where(supa_product_key, isEqualTo: supa_product)
      .where(priceId_key, isEqualTo: priceId)
      .limit(1);

  Map<String, dynamic> toMap() => {
        quantity_key: quantity,
        updated_time_key: Timestamp.fromDate(updated_time),
        supa_product_key: supa_product,
        priceId_key: priceId
      };

  static CartItem fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};

    return CartItem(
      quantity: json[quantity_key] ?? 0,
      supa_product: json[supa_product_key],
      priceId: json[priceId_key],
      updated_time: json[updated_time_key]?.toDate(),
      docRef: docSnap.reference,
      product: null,
    );
  }

  static CartItem fromProduct(Product pd) {
    return CartItem(
      quantity: 1,
      supa_product: pd.id,
      updated_time: DateTime.now(),
      priceId: (pd.list_prices.first.id.toString()),
      product: pd,
      docRef: col_ref.doc(pd.id.toString()),
    );
  }

  //
}

//

//
class ShopOrder {
  DocumentReference<Map<String, dynamic>> user_doc;
  List<OrderCoupon> applied_coupons;
  num final_amount;
  List<CartItem> list_items;
  AddressM? delivery_address;

  // 1 = ordered, 2 = accepted, 3 = rejected, 4 = packing, 5 = shipped, 9 = delivered, 10 = cancelled,11 = refunded,
  int order_status;
  DateTime order_time;

  List<OrderStatus> status_history;
  DocumentReference<Map<String, dynamic>>? docRef;

  //
  ShopOrder({
    required this.user_doc,
    required this.applied_coupons,
    required this.final_amount,
    required this.list_items,
    required this.delivery_address,
    required this.order_status,
    required this.order_time,
    required this.status_history,
    required this.docRef,
  });
}

//
class OrderStatus {
  DateTime status_time;
  int status_value;
  String? status_remarks;
  String? tracking_id;
  String? tracking_link;

  //
  OrderStatus({
    required this.status_time,
    required this.status_value,
    required this.status_remarks,
    required this.tracking_id,
    required this.tracking_link,
  });
}

//

