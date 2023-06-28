import 'package:myshopau/a_utils/supa.dart';
import 'package:myshopau/models/transactions.dart';

class ExcelTrans {
  //
  static List<AuAuTrans> listAuAUTrans = [
    AuAuTrans.fromExcel('a', 'b', 100),
    AuAuTrans.fromExcel('b', 'a', 50),
    AuAuTrans.fromExcel('c', 'd', 40),
    AuAuTrans.fromExcel('d', 'a', 105),
    AuAuTrans.fromExcel('a', 'b', 100),
    AuAuTrans.fromExcel('c', 'd', 20),
    AuAuTrans.fromExcel('d', 'a', 120),
    AuAuTrans.fromExcel('a', 'b', 328),
    AuAuTrans.fromExcel('b', 'c', 23),
    AuAuTrans.fromExcel('a', 'b', 233),
    AuAuTrans.fromExcel('c', 'd', 42),
    AuAuTrans.fromExcel('c', 'a', 234),
    AuAuTrans.fromExcel('b', 'a', 113),
    AuAuTrans.fromExcel('a', 'b', 323),
    AuAuTrans.fromExcel('b', 'c', 43),
    AuAuTrans.fromExcel('d', 'a', 545),
    AuAuTrans.fromExcel('b', 'c', 232),
    AuAuTrans.fromExcel('a', 'd', 144),
    AuAuTrans.fromExcel('c', 'd', 145),
    AuAuTrans.fromExcel('a', 'd', 233),
  ];

//
  static Future<void> send_auauTrans() async {
    await supabase
        .from(AuAuTrans.table)
        .insert(listAuAUTrans.map((e) => e.toSupaMap()).toList());
  }

//
  static List<PrimeTrans> listPrimeTrans = [
    PrimeTrans.fromExcel('a', '1', 1, 1, 12),
    PrimeTrans.fromExcel('b', '3', 0, 0, 323),
    PrimeTrans.fromExcel('c', '4', 1, 1, 23),
    PrimeTrans.fromExcel('a', '2', 1, 1, 332.3),
    PrimeTrans.fromExcel('d', '1', 0, 0, 323.43),
    PrimeTrans.fromExcel('c', '3', 1, 0, 121.12),
    PrimeTrans.fromExcel('d', '4', 0, 0, 23.323),
    PrimeTrans.fromExcel('a', '1', 1, 1, 323.2),
    PrimeTrans.fromExcel('c', '3', 0, 1, 122),
    PrimeTrans.fromExcel('c', '5', 1, 0, 45),
    PrimeTrans.fromExcel('d', '3', 0, 1, 878),
    PrimeTrans.fromExcel('d', '1', 0, 0, 55),
    PrimeTrans.fromExcel('a', '2', 1, 0, 466),
    PrimeTrans.fromExcel('c', '4', 1, 1, 767),
    PrimeTrans.fromExcel('b', '5', 1, 0, 45),
    PrimeTrans.fromExcel('b', '3', 0, 1, 344),
    PrimeTrans.fromExcel('a', '1', 0, 1, 24),
    PrimeTrans.fromExcel('b', '3', 0, 0, 545),
    PrimeTrans.fromExcel('d', '2', 1, 1, 34),
    PrimeTrans.fromExcel('c', '1', 1, 0, 345),
    PrimeTrans.fromExcel('a', '3', 0, 1, 545),
    PrimeTrans.fromExcel('b', '4', 0, 0, 3443),
    PrimeTrans.fromExcel('c', '1', 1, 0, 12),
    PrimeTrans.fromExcel('a', '3', 1, 1, 23),
    PrimeTrans.fromExcel('d', '4', 0, 1, 323),
  ];

  //
  static Future<void> send_PrimeTrans() async {
    await supabase
        .from(PrimeTrans.table)
        .insert(listPrimeTrans.map((e) => e.toSupaMap()).toList());
  }

  //
  static List<ShopTrans> listShopTrans = [
    ShopTrans.fromExcel('a', 1, 0, 1, 651),
    ShopTrans.fromExcel('b', 0, 0, 2, 949),
    ShopTrans.fromExcel('c', 0, 0, 3, 923),
    ShopTrans.fromExcel('a', 1, 1, 4, 157),
    ShopTrans.fromExcel('d', 0, 1, 5, 112),
    ShopTrans.fromExcel('c', 1, 1, 6, 918),
    ShopTrans.fromExcel('d', 1, 1, 7, 767),
    ShopTrans.fromExcel('a', 1, 1, 8, 50),
    ShopTrans.fromExcel('c', 1, 0, 9, 580),
    ShopTrans.fromExcel('c', 1, 1, 10, 350),
    ShopTrans.fromExcel('d', 0, 1, 11, 77),
    ShopTrans.fromExcel('d', 0, 0, 12, 929),
    ShopTrans.fromExcel('a', 1, 0, 13, 145),
    ShopTrans.fromExcel('c', 0, 0, 14, 885),
    ShopTrans.fromExcel('b', 0, 1, 15, 687),
    ShopTrans.fromExcel('b', 0, 0, 16, 931),
    ShopTrans.fromExcel('a', 0, 0, 17, 667),
    ShopTrans.fromExcel('b', 1, 9, 18, 401),
    ShopTrans.fromExcel('d', 1, 1, 19, 669),
    ShopTrans.fromExcel('c', 1, 0, 20, 119),
    ShopTrans.fromExcel('a', 0, 1, 21, 28),
    ShopTrans.fromExcel('b', 1, 1, 22, 757),
    ShopTrans.fromExcel('c', 1, 0, 23, 459),
    ShopTrans.fromExcel('a', 0, 1, 24, 904),
    ShopTrans.fromExcel('d', 1, 1, 25, 214),
    ShopTrans.fromExcel('a', 0, 0, 26, 120),
    ShopTrans.fromExcel('b', 1, 1, 27, 359),
    ShopTrans.fromExcel('c', 0, 0, 28, 200),
    ShopTrans.fromExcel('a', 0, 0, 29, 636),
    ShopTrans.fromExcel('d', 0, 0, 30, 17),
    ShopTrans.fromExcel('c', 0, 0, 31, 968),
    ShopTrans.fromExcel('d', 1, 1, 32, 475),
    ShopTrans.fromExcel('a', 1, 1, 33, 243),
    ShopTrans.fromExcel('c', 1, 1, 34, 871),
    ShopTrans.fromExcel('c', 0, 0, 35, 898),
    ShopTrans.fromExcel('d', 1, 1, 36, 616),
    ShopTrans.fromExcel('a', 1, 1, 37, 461),
    ShopTrans.fromExcel('b', 0, 0, 38, 955),
    ShopTrans.fromExcel('b', 1, 1, 39, 403),
  ];

  //
  //
  static Future<void> send_ShopTrans() async {
    await supabase
        .from(ShopTrans.table)
        .insert(listShopTrans.map((e) => e.toSupaMap()).toList());
  }

  //
  static List<CashCoinsTrans> list_cash_coins_trans = [
    CashCoinsTrans.fromExcel('a', 100, 1, 'jkd'),
    CashCoinsTrans.fromExcel('b', 20, 0, 'dvdv'),
    CashCoinsTrans.fromExcel('c', 11, 1, 'v'),
    CashCoinsTrans.fromExcel('d', 130, 0, 'dvdv'),
    CashCoinsTrans.fromExcel('a', 2332, 0, 'dvdv'),
    CashCoinsTrans.fromExcel('c', 233, 1, 'dvdv'),
    CashCoinsTrans.fromExcel('d', 122, 1, ''),
    CashCoinsTrans.fromExcel('a', 44, 1, 'dfefe'),
    CashCoinsTrans.fromExcel('b', 343, 1, 'fee'),
    CashCoinsTrans.fromExcel('a', 232, 0, 'e'),
    CashCoinsTrans.fromExcel('c', 12, 1, 'ef'),
    CashCoinsTrans.fromExcel('c', 333, 0, 'eff'),
    CashCoinsTrans.fromExcel('b', 1233, 1, 'fee'),
    CashCoinsTrans.fromExcel('a', 2, 1, 'v'),
    CashCoinsTrans.fromExcel('b', 233, 0, 'e'),
    CashCoinsTrans.fromExcel('d', 233, 1, 'wefefe'),
    CashCoinsTrans.fromExcel('b', 97, 1, ''),
    CashCoinsTrans.fromExcel('a', 34, 0, ''),
    CashCoinsTrans.fromExcel('c', 344, 1, 'dvdv'),
    CashCoinsTrans.fromExcel('a', 231, 0, 'v'),
    CashCoinsTrans.fromExcel('b', 12, 1, 'd'),
    CashCoinsTrans.fromExcel('a', 11, 0, 'v'),
    CashCoinsTrans.fromExcel('d', 122, 1, 'v'),
    CashCoinsTrans.fromExcel('a', 32, 0, ''),
    CashCoinsTrans.fromExcel('b', 33, 0, 'vvv'),
    CashCoinsTrans.fromExcel('d', 12, 1, ''),
    CashCoinsTrans.fromExcel('a', 11, 1, 'vr'),
    CashCoinsTrans.fromExcel('b', 12, 1, 'v'),
    CashCoinsTrans.fromExcel('c', 122, 0, 'v'),
    CashCoinsTrans.fromExcel('b', 12, 0, 'r'),
    CashCoinsTrans.fromExcel('d', 33, 0, 'ffe'),
    CashCoinsTrans.fromExcel('a', 32, 1, 'wefefe'),
    CashCoinsTrans.fromExcel('a', 233, 1, 'efef'),
    CashCoinsTrans.fromExcel('b', 21, 0, ''),
    CashCoinsTrans.fromExcel('c', 122, 0, 'fee'),
    CashCoinsTrans.fromExcel('a', 33, 1, 'fee'),
    CashCoinsTrans.fromExcel('c', 33, 1, 'f'),
    CashCoinsTrans.fromExcel('d', 23, 0, 'efr'),
    CashCoinsTrans.fromExcel('d', 443, 1, ''),
    CashCoinsTrans.fromExcel('d', 43, 1, 'rg'),
  ];

  //
  static Future<void> send_CashCoinsTrans() async {
    await supabase
        .from(CashCoinsTrans.table)
        .insert(list_cash_coins_trans.map((e) => e.toSupaMap()).toList());
  }

  //
  static List<BankTrans> list_BankTrans() {
    return [
      BankTrans.fromExcel('a', 0, 0, 508),
      BankTrans.fromExcel('b', 0, 10, 651),
      BankTrans.fromExcel('c', 0, 10, 86),
      BankTrans.fromExcel('d', 2, 3, 408),
      BankTrans.fromExcel('a', 1, 2, 672),
      BankTrans.fromExcel('c', 1, 0, 392),
      BankTrans.fromExcel('d', 2, 10, 911),
      BankTrans.fromExcel('a', 2, 10, 846),
      BankTrans.fromExcel('b', 0, 10, 777),
      BankTrans.fromExcel('a', 2, 2, 518),
      BankTrans.fromExcel('c', 0, 2, 897),
      BankTrans.fromExcel('c', 0, 1, 747),
      BankTrans.fromExcel('b', 0, 10, 904),
      BankTrans.fromExcel('a', 0, 10, 474),
      BankTrans.fromExcel('b', 1, 5, 207),
      BankTrans.fromExcel('d', 2, 10, 756),
      BankTrans.fromExcel('b', 2, 10, 649),
      BankTrans.fromExcel('a', 2, 0, 960),
      BankTrans.fromExcel('c', 0, 3, 256),
      BankTrans.fromExcel('a', 0, 10, 593),
      BankTrans.fromExcel('b', 2, 10, 961),
      BankTrans.fromExcel('a', 2, 10, 321),
      BankTrans.fromExcel('d', 2, 3, 746),
      BankTrans.fromExcel('a', 1, 10, 148),
      BankTrans.fromExcel('b', 2, 2, 377),
      BankTrans.fromExcel('d', 1, 3, 113),
      BankTrans.fromExcel('a', 2, 10, 740),
      BankTrans.fromExcel('b', 1, 10, 501),
      BankTrans.fromExcel('c', 0, 4, 878),
      BankTrans.fromExcel('b', 2, 10, 289),
      BankTrans.fromExcel('d', 2, 10, 644),
      BankTrans.fromExcel('a', 1, 5, 533),
      BankTrans.fromExcel('a', 2, 10, 338),
      BankTrans.fromExcel('b', 2, 10, 664),
      BankTrans.fromExcel('c', 1, 1, 720),
      BankTrans.fromExcel('a', 2, 5, 64),
      BankTrans.fromExcel('c', 1, 10, 977),
      BankTrans.fromExcel('d', 0, 10, 504),
      BankTrans.fromExcel('d', 2, 10, 627),
      BankTrans.fromExcel('d', 2, 4, 38),
      BankTrans.fromExcel('b', 2, 10, 294),
      BankTrans.fromExcel('d', 2, 10, 766),
      BankTrans.fromExcel('a', 1, 5, 215),
      BankTrans.fromExcel('b', 2, 10, 92),
      BankTrans.fromExcel('c', 1, 10, 842),
      BankTrans.fromExcel('b', 1, 4, 866),
      BankTrans.fromExcel('d', 1, 10, 66),
      BankTrans.fromExcel('a', 2, 10, 453),
      BankTrans.fromExcel('a', 1, 5, 511),
      BankTrans.fromExcel('b', 2, 0, 531),
      BankTrans.fromExcel('c', 2, 10, 562),
      BankTrans.fromExcel('a', 0, 10, 499),
      BankTrans.fromExcel('c', 2, 10, 388),
      BankTrans.fromExcel('d', 1, 4, 160),
      BankTrans.fromExcel('d', 0, 10, 286),
      BankTrans.fromExcel('d', 1, 10, 915),
    ];
  }

  //
  static Future<void> send_BankTrans() async {
    await supabase
        .from(BankTrans.table)
        .insert(list_BankTrans().map((e) => e.toSupaMap()).toList());
  }
}
