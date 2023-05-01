import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PrimeMember {
  int? member_position;
  String? member_id;
  String? user_name;
  String? password;
  String? name;
  String? email;
  String? phone;
  DateTime? regestratiom_time;
  // null = not initiated, 0 = initiated, 1 = under progress, 2 = online_payment success, 3 = online payment failed, 4 = offline paid
  int? payment_status;
  String? interested_in;
  String? member_photo;
  String? order_id;
  num wallet_bal;
  num coins_bal;
  DocumentReference<Map<String, dynamic>>? referer_doc;
  DocumentReference<Map<String, dynamic>>? auth_user_doc;
  DocumentReference<Map<String, dynamic>>? docRef;

  PrimeMember({
    required this.member_position,
    required this.member_id,
    required this.user_name,
    required this.password,
    required this.name,
    required this.email,
    required this.phone,
    required this.regestratiom_time,
    required this.payment_status,
    required this.interested_in,
    required this.member_photo,
    required this.order_id,
    required this.wallet_bal,
    required this.coins_bal,
    required this.referer_doc,
    required this.auth_user_doc,
    required this.docRef,
  });

  //
  static const member_position_key = "member_position";
  static const member_id_key = "member_id";
  static const name_key = "name";
  static const email_key = "email";
  static const phone_key = "phone";
  static const regestratiom_time_key = "regestratiom_time";
  static const payment_status_key = "payment_status";
  static const interested_in_key = "interested_in";
  static const user_name_key = "user_name";
  static const password_key = "password";
  static const member_photo_key = "member_photo";
  static const order_id_key = "order_id";
  static const wallet_bal_key = "wallet_bal";
  static const coins_bal_key = "coins_bal";
  static const referer_doc_key = "referer_doc";
  static const auth_user_doc_key = "auth_user_doc";
  static const docRef_key = "docRef";

  //
  static final col_ref = FirebaseFirestore.instance.collection("prime_members");

  //
  bool is_paid() {
    return (payment_status == 2 || payment_status == 4);
  }
  //

  Map<String, dynamic> toMap() {
    return {
      member_position_key: member_position,
      member_id_key: member_id,
      name_key: name,
      email_key: email,
      phone_key: phone,
      regestratiom_time_key: regestratiom_time,
      payment_status_key: payment_status,
      interested_in_key: interested_in,
      user_name_key: user_name,
      password_key: password,
      member_photo_key: member_photo,
      order_id_key: order_id,
      wallet_bal_key: wallet_bal,
      coins_bal_key: coins_bal,
      referer_doc_key: referer_doc?.id,
      auth_user_doc_key: auth_user_doc?.id,
    };
  }

  //
  static PrimeMember dummy() {
    return PrimeMember(
        member_position: null,
        member_id: null,
        user_name: null,
        password: null,
        name: null,
        email: null,
        phone: null,
        regestratiom_time: null,
        payment_status: null,
        interested_in: null,
        member_photo: null,
        order_id: null,
        wallet_bal: 0,
        coins_bal: 0,
        referer_doc: null,
        auth_user_doc: null,
        docRef: null);
  }

  //

  static PrimeMember fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};

    return PrimeMember(
        member_position: json[member_position_key],
        member_id: json[member_id_key],
        user_name: json[user_name_key],
        password: json[password_key],
        name: json[name_key],
        email: json[email_key],
        phone: json[phone_key],
        regestratiom_time: json[regestratiom_time_key]?.toDate(),
        payment_status: json[payment_status_key],
        interested_in: json[interested_in_key],
        member_photo: json[member_photo_key],
        order_id: json[order_id_key],
        wallet_bal: json[wallet_bal_key] ?? 0,
        coins_bal: json[coins_bal_key] ?? 0,
        referer_doc: json[referer_doc_key] != null
            ? col_ref.doc(json[referer_doc_key])
            : null,
        auth_user_doc: json[auth_user_doc_key] != null
            ? col_ref.doc(json[auth_user_doc_key])
            : null,
        docRef: docSnap.reference);
  }

  //
  static Future<PrimeMember?> from_userName(String userName) async {
    PrimeMember? pm;
    await col_ref
        .where(user_name_key, isEqualTo: userName)
        .limit(1)
        .get()
        .then((qs) {
      if (qs.docs.isNotEmpty) {
        pm = PrimeMember.fromDS(qs.docs.first);
      }
    });
    return pm;
  }

  //
  static Future<void> addPrimePositionViaFire(PrimeMember pmm) async {
    if (pmm.user_name != null &&
        pmm.member_position == null &&
        pmm.is_paid() &&
        pmm.referer_doc != null &&
        pmm.member_id != null) {
      HttpsCallable addPos =
          FirebaseFunctions.instance.httpsCallable('add_prime_position');
      await addPos.call(<String, dynamic>{
        PrimeMember.user_name_key: pmm.user_name!,
      });
    } else {
      Get.snackbar("Error", "Invalid user credentials");
    }
  }

  //
  //
  static Future<PrimeMember?> last_prime_member() async {
    return col_ref
        .orderBy(member_position_key, descending: true)
        .limit(1)
        .get()
        .then(((qs) {
      if (qs.docs.isNotEmpty) {
        return PrimeMember.fromDS(qs.docs.first);
      }
      return null;
    }));
  }

  //
  static Future<void> add_prime_position(PrimeMember pmm) async {
    await col_ref
        .orderBy(member_position_key, descending: true)
        .limit(1)
        .get()
        .then((qs) async {
      if (qs.docs.isNotEmpty) {
        var pmLast = PrimeMember.fromDS(qs.docs.first);
        pmm.member_position = pmLast.member_position! + 1;
        pmm.payment_status = 2;
        await pmm.docRef?.update(pmm.toMap());
      }
    });
  }

  //
  //
  String dateTime(DateTime time) {
    String ampm = DateFormat("a").format(time).toLowerCase();
    String chatDayTime = DateFormat("dd MMM").format(time);
    //
    String today = DateFormat("dd MMM").format(DateTime.now());
    // String chatDay =
    //     DateFormat("dd MMM").format(crm.lastChatModel!.senderSentTime);

    if (today == chatDayTime) {
      chatDayTime = DateFormat("h:mm").format(time) + ampm;
    }
    return chatDayTime;
  }

  //
}

//
class Razor {
  //
  static const amount = 100000;
  static final razorpay = Razorpay();
  static const razorKey = "rzp_live_yCBJw6q6PHaIpJ";

  //

  static Future<bool> check_update_and_get_order_status(String userName) async {
    var isPaid = false;

    PrimeMember.from_userName(userName).then((pmm) async {
      if (pmm != null) {
        if (pmm.order_id != null && pmm.payment_status != 4) {
          HttpsCallable checkOrderStatus =
              FirebaseFunctions.instance.httpsCallable('orderStutus');
          var status = await checkOrderStatus.call(<String, dynamic>{
            "orderId": pmm.order_id,
          });
          if (status.data == "paid") {
            isPaid = true;
            pmm.payment_status = 2;
            await PrimeMember.add_prime_position(pmm);
          } else if (pmm.payment_status == null &&
              (status.data == "attempted")) {
            pmm.payment_status = 0;
            await pmm.docRef!.update(pmm.toMap());
          }
        } else if (pmm.payment_status == 4 && pmm.member_position == null) {
          await PrimeMember.add_prime_position(pmm);
        }
      }
    });
    return isPaid;
  }

  //
 static void razorInIt(String userName) async {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) async {
      var isPaid = await check_update_and_get_order_status(userName);
      if (isPaid) {
        Get.snackbar("Payment success", "Proceed to prime");
      } else {
        Get.snackbar("Fetching payment...", "Please check status");
      }
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      Get.snackbar("Payment Error", "Please try again");
    });
  }

  //
  static void razorOrder(PrimeMember pmm) {
    if (pmm.order_id != null && pmm.phone != null && pmm.email != null) {
      razorpay.open({
        'key': razorKey,
        'amount': amount, //in the smallest currency sub-unit.
        'name': 'My Shop AU',
        'order_id': pmm.order_id!, // Generate order_id using Orders API

        'prefill': {
          'contact': pmm.phone!,
          'email': pmm.email!,
        }
      });
    } else {
      Get.snackbar("Error", "Invalid user credentials");
    }
  }
}
