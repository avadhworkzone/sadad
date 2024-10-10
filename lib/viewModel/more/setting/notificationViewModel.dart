import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/notificationResponseModel.dart';
import 'package:sadad_merchat_app/model/repo/more/setting/getNotificationRepo.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';

class NotificationViewModel extends GetxController {
  RxBool isLoading = false.obs;
  NotificationRepo notificationRepo = NotificationRepo();
  Rx<NotificationResponseModel> notificationResponseModel =
      NotificationResponseModel().obs;

  /// Notification vars
  ///

  RxBool isArabic = false.obs;
  RxBool receivedPaymentPush = false.obs;
  RxBool receivedPaymentSms = false.obs;
  RxBool receivedPaymentEmail = false.obs;
  RxBool transferPush = false.obs;
  RxBool transferSms = false.obs;
  RxBool transferEmail = false.obs;
  RxBool receivedOrdersPush = false.obs;
  RxBool receivedOrderSms = false.obs;
  RxBool receivedOrderEmail = false.obs;
  RxBool isPlayaSound = false.obs;
  RxBool receiveArabic = false.obs;

  ///
  ///

  Future getNotificationSettings(context) async {
    // isLoading.value = true;
    showLoadingDialog(context: context);
    try {
      notificationResponseModel.value =
          await notificationRepo.getNotificationSettings();
      print(
          " Before notificationModel.value.receivedPaymentPush?.value :- ${receivedPaymentPush.value} , ${notificationResponseModel.value.isArabic}");
      isArabic.value = notificationResponseModel.value.isArabic!;
      receivedPaymentPush.value =
          notificationResponseModel.value.receivedpaymentpush!;
      print(
          "After notificationModel.value.receivedPaymentPush?.value :- ${receivedPaymentPush.value} , ${notificationResponseModel.value.receivedpaymentpush!}");
      receivedPaymentSms.value =
          notificationResponseModel.value.receivedpaymentsms!;
      receivedPaymentEmail.value =
          notificationResponseModel.value.receivedpaymentemail!;
      transferPush.value = notificationResponseModel.value.transferpush!;
      transferSms.value = notificationResponseModel.value.transfersms!;
      transferEmail.value = notificationResponseModel.value.transferemail!;
      receivedOrdersPush.value =
          notificationResponseModel.value.receivedorderspush!;
      receivedOrderSms.value =
          notificationResponseModel.value.receivedordersms!;
      receivedOrderEmail.value =
          notificationResponseModel.value.receivedorderemail!;
      isPlayaSound.value =
          notificationResponseModel.value.isplayasound == "false"
              ? false
              : true;
      print(
          'before value is ${receiveArabic.value}--${notificationResponseModel.value.isArabic!}');
      receiveArabic.value = notificationResponseModel.value.isArabic!;
      print(
          'after value is ${receiveArabic.value}--${notificationResponseModel.value.isArabic!}');
      // isLoading.value = false;
      hideLoadingDialog(context: context);
    } catch (e) {
      hideLoadingDialog(context: context);
    }
  }
}
