import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart.dart';

class Coupon {
  //
  final int coupon_id;
  //
  final String coupon_code;
  //
  final bool is_active;
  //
  final bool is_coin_back;
  final bool is_cash_back;
  final bool is_delivery_waive;
  final bool is_refferal_code;
  //
  final bool is_for_prime_purchase;
  //
  final bool for_prepaid_only;
  final bool first_order_only;
  final bool for_primer_only;
  final bool for_kyc_only;
  final bool through_no_coins_only;
  final bool thorough_au_cash_only;
  final bool thorough_cash_coins_only;
  final bool thorough_bank_only;
  final bool thorough_zero_charge_gateway_only;
  //
  final int max_times_per_user;
  //
  final num min_order_value;
  final num coupon_amount;
  final num coupon_percentage;
  final num max_coupon_amount;
  //
  final List<int> eligible_categories;
  final List<int> ineligible_categories;
  final List<int> eligible_products;
  final List<int> ineligible_products;
  final List<String> eligible_users;
  final List<String> ineligible_users;
  final List<Coupon> can_merge_coupons;
  final List<Coupon> cannot_merge_coupons;
  //
  final String coupon_title;
  final String coupon_description;
  final String? coupon_image_url;

  DocumentReference<Map<String, dynamic>>? docRef;

  //
  Coupon({
    required this.coupon_id,
    required this.coupon_code,

    //
    required this.is_active,
    //
    required this.is_coin_back,
    required this.is_cash_back,
    required this.is_delivery_waive,
    required this.is_refferal_code,
    //
    required this.is_for_prime_purchase,
    //
    required this.for_prepaid_only,
    required this.first_order_only,
    required this.for_primer_only,
    required this.for_kyc_only,
    required this.through_no_coins_only,
    required this.thorough_au_cash_only,
    required this.thorough_cash_coins_only,
    required this.thorough_bank_only,
    required this.thorough_zero_charge_gateway_only,
    //
    required this.max_times_per_user,
    //
    required this.min_order_value,
    required this.coupon_amount,
    required this.coupon_percentage,
    required this.max_coupon_amount,
    //
    required this.eligible_categories,
    required this.ineligible_categories,
    required this.eligible_products,
    required this.ineligible_products,
    required this.eligible_users,
    required this.ineligible_users,
    required this.can_merge_coupons,
    required this.cannot_merge_coupons,
    //
    required this.coupon_title,
    required this.coupon_description,
    required this.coupon_image_url,
  });

  //
  static final col_ref = FirebaseFirestore.instance.collection("coupons");
}

//

class OrderCoupon  {

  num? applied_amount;
  Coupon coupon;

  OrderCoupon({
    required this.applied_amount,
   required this.coupon,
  });

 
}

//
