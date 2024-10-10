import 'package:get/get.dart';

class NotificationModel {
  bool? isArabic = true;
  bool? receivedPaymentPush = true;

  RxBool receivedPaymentSms = true.obs;
  RxBool receivedPaymentEmail = true.obs;
  RxBool transferPush = true.obs;
  RxBool transferSms = true.obs;
  RxBool transferEmail = true.obs;
  RxBool receivedOrdersPush = true.obs;
  RxBool receivedOrderSms = true.obs;
  RxBool receivedOrderEmail = true.obs;
  RxBool isPlayaSound = true.obs;

  NotificationModel({
    this.isArabic,
    this.receivedPaymentPush,
    // required this.receivedPaymentSms,
    // required this.receivedPaymentEmail,
    // required this.transferPush,
    // required this.transferSms,
    // required this.transferEmail,
    // required this.receivedOrdersPush,
    // required this.receivedOrderSms,
    // required this.receivedOrderEmail,
    // required this.isPlayaSound
  });
}
