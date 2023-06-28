import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshopau/a_utils/supa.dart';
import 'package:myshopau/models/auth_user.dart';
import 'package:myshopau/models/primer.dart';

//
class TransHistory {}

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

  //
  static const table = "au_au_trans";

  //
  Map<String, dynamic> toSupaMap() {
    return {
      "debit_user": debit_user.id,
      "credit_user": credit_user.id,
      "amount": amount,
      "init_time": init_time.toIso8601String(),
    };
  }

  //
  Future<void> upload_to_supa() async {
    await supabase.from(table).insert(toSupaMap());
  }

  static AuAuTrans fromExcel(String du, String cu, num amount) {
    return AuAuTrans(
        debit_user: FireUser.col_ref.doc(du),
        credit_user: FireUser.col_ref.doc(cu),
        amount: amount,
        init_time: DateTime.now());
  }
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

  //
  static const table = "prime_trans";

  //
  Map<String, dynamic> toSupaMap() {
    return {
      "au_user": au_user.id,
      "is_cash": is_cash,
      "prime_to_au": prime_to_au,
      "primer": primer.id,
      "amount": amount,
      "init_time": init_time.toIso8601String(),
    };
  }

  //
  static PrimeTrans fromExcel(
      String au, String pu, int is_cash, int ptou, num amount) {
    return PrimeTrans(
        au_user: FireUser.col_ref.doc(au),
        is_cash: is_cash == 1,
        prime_to_au: ptou == 1,
        primer: Primer.col_ref.doc(pu),
        amount: amount,
        init_time: DateTime.now());
  }
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

  //
  static const table = "shop_trans";
  //
  Map<String, dynamic> toSupaMap() {
    return {
      "au_user": au_user.id,
      "is_au_cash": is_au_cash,
      "is_refund": is_refund,
      "order_id": order_id,
      "amount": amount,
      "init_time": init_time.toIso8601String(),
    };
  }

  //
  static ShopTrans fromExcel(
      String au, int isCash, int isRefund, int orderId, num amount) {
    return ShopTrans(
        au_user: FireUser.col_ref.doc(au),
        is_au_cash: isCash == 1,
        is_refund: isRefund == 1,
        order_id: orderId,
        amount: amount,
        init_time: DateTime.now());
  }
}

//
class BankTrans {
  DocumentReference<Map<String, dynamic>> au_user;
  // true = au to bank, false = bank to au, null = bank to pg or pg to bank
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
  //
  static const table = "bank_trans";

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

  //
  Map<String, dynamic> toSupaMap() {
    return {
      "au_user": au_user.id,
      "is_au_to_bank": is_au_to_bank,
      "amount": amount,
      "settlement_time": settlement_time?.toIso8601String(),
      "init_time": init_time.toIso8601String(),
      "status": status,
      "admin_comments": admin_comments,
      "user_comments": user_comments,
      "bank_trans_id": bank_trans_id,
      "pg_order_id": pg_order_id,
    };
  }

  //
  static BankTrans fromExcel(
      String au, int is_au_to_bank, num amount, int status) {
    return BankTrans(
        au_user: FireUser.col_ref.doc(au),
        is_au_to_bank: is_au_to_bank == 1
            ? true
            : is_au_to_bank == 0
                ? false
                : null,
        amount: amount,
        init_time: DateTime.now(),
        settlement_time: DateTime.now().toUtc(),
        status: status,
        admin_comments: null,
        user_comments: null,
        deductions: 0,
        decuction_remarks: null,
        bank_trans_id: null,
        pg_order_id: null);
  }
}

//
class CashCoinsTrans {
  DocumentReference<Map<String, dynamic>> au_user;
  num amount;
  bool cash_to_coins;
  DateTime init_time;
  String? trans_remarks;

  //
  CashCoinsTrans({
    required this.au_user,
    required this.amount,
    required this.cash_to_coins,
    required this.init_time,
    required this.trans_remarks,
  });
  //
  static const table = "cash_coins_trans";
  //
  Map<String, dynamic> toSupaMap() {
    return {
      "au_user": au_user.id,
      "cash_to_coins": cash_to_coins,
      "trans_remarks": trans_remarks,
      "amount": amount,
      "init_time": init_time.toIso8601String(),
    };
  }

  //
  static CashCoinsTrans fromExcel(
      String au, num amount, int cash_to_coins, String remarks) {
    return CashCoinsTrans(
        au_user: FireUser.col_ref.doc(au),
        amount: amount,
        cash_to_coins: cash_to_coins == 1,
        trans_remarks: remarks,
        init_time: DateTime.now());
  }
}
