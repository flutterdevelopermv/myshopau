import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myshopau/models/auth_user.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'prime_member.dart';

class Primer {
  int? primer_position;
  String? primer_id;
  String? name;
  DateTime? regestratiom_time;
  // null = not initiated, 0 = initiated, 1 = under progress, 2 = online_payment success, 3 = online payment failed, 4 = offline paid
  int? payment_status;
  String? interested_in;
  String? order_id;
  String? phone;
  DocumentReference<Map<String, dynamic>>? referer_doc;
  DocumentReference<Map<String, dynamic>>? auth_user_doc;
  DocumentReference<Map<String, dynamic>>? docRef;

  Primer({
    required this.primer_position,
    required this.primer_id,
    required this.name,
    required this.regestratiom_time,
    required this.payment_status,
    required this.interested_in,
    required this.order_id,
    required this.phone,
    required this.referer_doc,
    required this.auth_user_doc,
    required this.docRef,
  });

  //
  static const primer_position_key = "primer_position";
  static const primer_id_key = "primer_id";
  static const name_key = "name";
  static const phone_key = "phone";
  static const regestratiom_time_key = "regestratiom_time";
  static const payment_status_key = "payment_status";
  static const interested_in_key = "interested_in";

  static const order_id_key = "order_id";

  static const referer_doc_key = "referer_doc";
  static const auth_user_doc_key = "auth_user_doc";
  static const docRef_key = "docRef";

  //
  static final col_ref = FirebaseFirestore.instance.collection("primers");

  //
  bool is_paid() {
    return (payment_status == 2 || payment_status == 4);
  }
  //

  Map<String, dynamic> toMap() {
    return {
      primer_position_key: primer_position,
      name_key: name,
      phone_key: phone,
      regestratiom_time_key: regestratiom_time,
      payment_status_key: payment_status,
      interested_in_key: interested_in,
      order_id_key: order_id,
      referer_doc_key: referer_doc?.id,
      auth_user_doc_key: auth_user_doc?.id,
    };
  }

  //
  static Primer dummy() {
    return Primer(
        primer_position: null,
        primer_id: null,
        name: null,
        phone: null,
        regestratiom_time: null,
        payment_status: null,
        interested_in: null,
        order_id: null,
        referer_doc: null,
        auth_user_doc: null,
        docRef: null);
  }

  //

  static Primer fromDS(DocumentSnapshot<Map<String, dynamic>> docSnap) {
    Map<String, dynamic> json = docSnap.data() ?? {};

    return Primer(
        primer_position: json[primer_position_key],
        primer_id: json[primer_id_key],
        name: json[name_key],
        phone: json[phone_key],
        regestratiom_time: json[regestratiom_time_key]?.toDate(),
        payment_status: json[payment_status_key],
        interested_in: json[interested_in_key],
        order_id: json[order_id_key],
        referer_doc: json[referer_doc_key] != null
            ? col_ref.doc(json[referer_doc_key])
            : null,
        auth_user_doc: json[auth_user_doc_key] != null
            ? col_ref.doc(json[auth_user_doc_key])
            : null,
        docRef: docSnap.reference);
  }

  //
  static Future<Primer?> from_id(String primer_id) async {
    Primer? pm;
    await col_ref
        .where(primer_id_key, isEqualTo: primer_id)
        .limit(1)
        .get()
        .then((qs) {
      if (qs.docs.isNotEmpty) {
        pm = Primer.fromDS(qs.docs.first);
      }
    });
    return pm;
  }

  //
  static Future<void> addPrimePositionViaFire(Primer pmm) async {
    if (pmm.primer_id != null &&
        pmm.primer_position == null &&
        pmm.is_paid() &&
        pmm.referer_doc != null &&
        pmm.primer_id != null) {
      HttpsCallable addPos =
          FirebaseFunctions.instance.httpsCallable('add_prime_position');
      await addPos.call(<String, dynamic>{
        Primer.primer_id_key: pmm.primer_id!,
      });
    } else {
      Get.snackbar("Error", "Invalid user credentials");
    }
  }

  //
  //
  static Future<Primer?> last_prime_member() async {
    return col_ref
        .orderBy(primer_position_key, descending: true)
        .limit(1)
        .get()
        .then(((qs) {
      if (qs.docs.isNotEmpty) {
        return Primer.fromDS(qs.docs.first);
      }
      return null;
    }));
  }

  //
  static Future<void> add_prime_position(Primer pmm) async {
    await col_ref
        .orderBy(primer_position_key, descending: true)
        .limit(1)
        .get()
        .then((qs) async {
      if (qs.docs.isNotEmpty) {
        var pmLast = Primer.fromDS(qs.docs.first);
        pmm.primer_position = pmLast.primer_position! + 1;
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

  static Primer fromPrimeMember(PrimeMember pmm) {
    return Primer(
        primer_position: pmm.member_position,
        primer_id: pmm.user_name,
        name: pmm.user_name,
        phone: pmm.phone,
        regestratiom_time: pmm.regestratiom_time,
        payment_status: pmm.payment_status,
        interested_in: pmm.interested_in,
        order_id: pmm.order_id,
        referer_doc: pmm.referer_doc,
        auth_user_doc: pmm.auth_user_doc,
        docRef: pmm.docRef);
  }

  //
  static Future<int?> referrals_count(Primer pmr) async {
    if (pmr.referer_doc != null) {
      var ct = await col_ref
          .where(referer_doc_key, isEqualTo: pmr.referer_doc!.id)
          .where(primer_position_key, isNotEqualTo: null)
          .count()
          .get();
      return ct.count;
    }
    return null;
  }

  //
  // static Future<void> members_to_primers() async {
  //   var ds = await PrimeMember.col_ref.get();
  //   for (var qds in ds.docs) {
  //     var pmm = PrimeMember.fromDS(qds);
  //     var prm = fromPrimeMember(pmm);
  //     await col_ref.doc(qds.id).set(prm.toMap());
  //     print(prm.primer_id);
  //   }
  //   print("---done---");
  // }
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

    Primer.from_id(userName).then((pmm) async {
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
            await Primer.add_prime_position(pmm);
          } else if (pmm.payment_status == null &&
              (status.data == "attempted")) {
            pmm.payment_status = 0;
            await pmm.docRef!.update(pmm.toMap());
          }
        } else if (pmm.payment_status == 4 && pmm.primer_position == null) {
          await Primer.add_prime_position(pmm);
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
  static void razorOrder(Primer pmm) {
    if (pmm.order_id != null) {
      razorpay.open({
        'key': razorKey,
        'amount': amount, //in the smallest currency sub-unit.
        'name': 'My Shop AU',
        'order_id': pmm.order_id!, // Generate order_id using Orders API

        'prefill': {
          'contact': FireUser.user()?.phoneNumber,
          // 'email': pmm.email!,
        }
      });
    } else {
      Get.snackbar("Error", "Invalid user credentials");
    }
  }
}
