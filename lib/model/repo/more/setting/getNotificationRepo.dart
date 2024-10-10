import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/more/notificatioModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/notificationResponseModel.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/viewModel/more/setting/notificationViewModel.dart';

class NotificationRepo extends BaseService {
  NotificationResponseModel notificationResponseModel =
      NotificationResponseModel();

  RxInt userMetaPrefID = 0.obs;

  Future<NotificationResponseModel> getNotificationSettings() async {
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');

    final url = Uri.parse(baseURL +
        "/usermetapreferences?filter[where][userId]=$id" +
        notificationInfo);
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    var result = await http.get(url, headers: header);
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      List data = json.decode(result.body);
      notificationResponseModel = NotificationResponseModel.fromJson(data[0]);
      print("id is :- ${data[0]["id"]}");
      userMetaPrefID.value = notificationResponseModel.id!;
      print("data is :- ${data[0]["receivedpaymentsms"]}");

      // notificationModel.value.isPlayaSound =
      //     notificationResponseModel.isplayasound;
    } else if (result.statusCode == 401) {
      //Get.back(result: true);
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
    return notificationResponseModel;
  }

  Future<NotificationResponseModel> updateNotificationSetting(
      NotificationViewModel notificationCnt) async {
    String token = await encryptedSharedPreferences.getString('token');

    final url = Uri.parse(
        baseURL + "/usermetapreferences/" + "${userMetaPrefID.value}");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };

    var body = {
      "isArabic": notificationCnt.receiveArabic.value,
      "receivedpaymentpush": notificationCnt.receivedPaymentPush.value,
      "receivedpaymentsms": notificationCnt.receivedPaymentSms.value,
      "receivedpaymentemail": notificationCnt.receivedPaymentEmail.value,
      "transferpush": notificationCnt.transferPush.value,
      "transfersms": notificationCnt.transferSms.value,
      "transferemail": notificationCnt.transferEmail.value,
      "receivedorderspush": notificationCnt.receivedOrdersPush.value,
      "receivedordersms": notificationCnt.receivedOrderSms.value,
      "receivedorderemail": notificationCnt.receivedOrderEmail.value,
      "isplayasound": notificationCnt.isPlayaSound.value
    };

    print(url);
    print('------$body');
    var result =
        await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      await encryptedSharedPreferences.setString(
          'notSound', '${notificationCnt.isPlayaSound.value}');
      var data = json.decode(result.body);
      print("Resp :-  $data");
      Get.snackbar('Success', 'Notification Change Successful');
    } else if (result.statusCode == 401) {
      //Get.back(result: true);
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
    return notificationResponseModel;
  }
}
