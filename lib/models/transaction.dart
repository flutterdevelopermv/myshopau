import 'package:cloud_firestore/cloud_firestore.dart';
//
class AuAuTrans {
  int debit_user;
  int credit_user;
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
  int au_user;
  bool is_cash;
  bool prime_to_au;
  int primer;
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
  int au_user;
  bool is_cash;
  bool au_to_shop;
  int order_id;
  num amount;
  DateTime init_time;
  //
  ShopTrans({
    required this.au_user,
    required this.is_cash,
    required this.au_to_shop,
    required this.order_id,
    required this.amount,
    required this.init_time,
  });
}

//
class BankTrans {
  int au_user;
  bool bank_to_au;
  num au_amount;
  DateTime init_time;
  DateTime? settlement_time;

  /// null = invalid, 0 = initiated, 10 = completed, 1 = approved, 2 = under_progress, 3 = rejected, 4 = pending_from_admin, 5 = kyc_pending;
  int? status;
  String? admin_comments;
  String? user_comments;
  num deductions;
  String? decuction_remarks;
  String? bank_trans_id;
  int? order_id;

  //
  BankTrans({
    required this.au_user,
    required this.bank_to_au,
    required this.au_amount,
    required this.init_time,
    required this.settlement_time,
    required this.status,
    required this.admin_comments,
    required this.user_comments,
    required this.deductions,
    required this.decuction_remarks,
    required this.bank_trans_id,
    required this.order_id,
  });
}

//
class CashCoinsTrans {
  int au_user;
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

//
class Balances {
  var au = AuAuTrans(
      debit_user: 0, credit_user: 1, amount: 20, init_time: DateTime.now());
  //2
  var ps = PrimeTrans(
      au_user: 1,
      is_cash: true,
      prime_to_au: true,
      primer: 2,
      amount: 1,
      init_time: DateTime.now());
  //3
  var sp = ShopTrans(
      au_user: 1,
      is_cash: true,
      au_to_shop: false,
      order_id: 1,
      amount: 1,
      init_time: DateTime.now());
  //4
  var cc = CashCoinsTrans(
      au_user: 1,
      cash_amount: 1,
      coins_amount: 1,
      cash_to_coins: false,
      init_time: DateTime.now(),
      trans_remarks: null);
  //5
  var bk = BankTrans(
      au_user: 1,
      bank_to_au: true,
      au_amount: 1,
      init_time: DateTime.now(),
      settlement_time: DateTime.now(),
      status: 10,
      admin_comments: null,
      user_comments: null,
      deductions: 1,
      decuction_remarks: null,
      bank_trans_id: "1",
      order_id: 1);

}
