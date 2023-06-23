import 'package:cloud_firestore/cloud_firestore.dart';

//
class AuAuTrans {
  DocumentReference<Map<String, dynamic>> debit_user;
  DocumentReference<Map<String, dynamic>> credit_user;
  num amount;
  DateTime init_time;

  AuAuTrans({
    required this.debit_user,
    required this.credit_user,
    required this.amount,
    required this.init_time,
  });
}

//
class PrimeTrans {
  DocumentReference<Map<String, dynamic>> au_user;
  bool is_cash;
  bool prime_to_au;
  DocumentReference<Map<String, dynamic>> primer;
  num amount;
  DateTime init_time;
  //
  PrimeTrans({
    required this.au_user,
    required this.is_cash,
    required this.prime_to_au,
    required this.primer,
    required this.amount,
    required this.init_time,
  });
}

//
class ShopTrans {
  DocumentReference<Map<String, dynamic>> au_user;
  bool? is_au_cash;
  bool? is_refund;
  int order_id;
  num amount;
  DateTime init_time;
  //
  ShopTrans({
    required this.au_user,
    required this.is_au_cash,
    required this.is_refund,
    required this.order_id,
    required this.amount,
    required this.init_time,
  });
}

//
class BankTrans {
  DocumentReference<Map<String, dynamic>> au_user;
  bool? is_au_to_bank;
  num amount;
  DateTime init_time;
  DateTime? settlement_time;

  /// null = invalid, 0 = initiated, 10 = completed, 1 = approved, 2 = under_progress, 3 = rejected, 4 = pending_from_admin, 5 = kyc_pending;
  int? status;
  String? admin_comments;
  String? user_comments;
  num deductions;
  String? decuction_remarks;
  String? bank_trans_id;
  int? pg_order_id;

  //
  BankTrans({
    required this.au_user,
    required this.is_au_to_bank,
    required this.amount,
    required this.init_time,
    required this.settlement_time,
    required this.status,
    required this.admin_comments,
    required this.user_comments,
    required this.deductions,
    required this.decuction_remarks,
    required this.bank_trans_id,
    required this.pg_order_id,
  });
}

//
class CashCoinsTrans {
  DocumentReference<Map<String, dynamic>> au_user;
  num cash_amount;
  num coins_amount;
  bool cash_to_coins;
  DateTime init_time;
  String? trans_remarks;

  //
  CashCoinsTrans({
    required this.au_user,
    required this.cash_amount,
    required this.coins_amount,
    required this.cash_to_coins,
    required this.init_time,
    required this.trans_remarks,
  });
}
