import 'package:cloud_firestore/cloud_firestore.dart';

class AuCashCredits {
  num amount;

  /// 1 = Prime, 2 = Shopping order,3 = Bank,4 = AU User, 5 = Coins  
  int? from;
  DocumentReference<Map<String, dynamic>>? trans_user;
  DocumentReference<Map<String, dynamic>>? end_user;
  DocumentReference<Map<String, dynamic>>? primer;
  DocumentReference<Map<String, dynamic>>? shopping_order;

  /// null = invalid, 0 = initiated, 10 = completed, 1 = approved, 2 = under_progress, 3 = rejected, 4 = pending_from_admin, 5 = kyc_pending, 6 = bank_failure;
  int? status;
  DateTime init_time;
  DateTime? credit_time;
  String? bank_trans_id;
  DocumentReference<Map<String, dynamic>>? trans_id;
}

//
class AuCashDebits {
  int? trans_id;
  num amount;
  /// 1 = Prime, 2 = Shopping order,3 = Bank,4 = AU User, 5 = Coins  
  int? to;
  DocumentReference<Map<String, dynamic>>? trans_user;
  DocumentReference<Map<String, dynamic>>? end_user;
  DocumentReference<Map<String, dynamic>>? primer;
  DocumentReference<Map<String, dynamic>>? shopping_order;

  /// null = invalid, 0 = initiated, 10 = completed, 1 = approved, 2 = under_progress, 3 = rejected, 4 = pending_from_admin, 5 = kyc_pending, 6 = bank_failure;
  int? status;
  DateTime init_time;
  DateTime? credit_time;
  num deductions;
  String? decuction_remarks;
  String? bank_trans_id;
  DocumentReference<Map<String, dynamic>>? trans_id;
}

//
class AuCoinCredits {}

//
class AuCoinDebits {}

//
class PrimeCashDebits {
  DocumentReference<Map<String, dynamic>> primer;
  DocumentReference<Map<String, dynamic>> au_user;
  bool is_from_ref_bonus;
  num amount;
  DateTime init_time;
  DocumentReference<Map<String, dynamic>>? docRef;

  //
  PrimeCashDebits({
    required this.primer,
    required this.au_user,
    required this.is_from_ref_bonus,
    required this.amount,
    required this.init_time,
    this.docRef,
  });
}

//
class PrimeCoinDebits {
  DocumentReference<Map<String, dynamic>> primer;
  DocumentReference<Map<String, dynamic>> au_user;
  num amount;
  DateTime init_time;
  DocumentReference<Map<String, dynamic>>? docRef;
}
