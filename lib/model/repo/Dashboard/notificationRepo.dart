import 'dart:developer';

import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/notificationResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/notificationResponseModel.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';

import '../../apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class NotificationListRepo extends BaseService {
  Future<List<NotificationListResponseModel>> notificationRepo(
      {required int start, required int end}) async {
    String id = await encryptedSharedPreferences.getString('id');
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: notification +
          '?filter[where][notificationreceiverId]=$id&filter[include]=notification&filter[order]=created DESC&filter[skip]=$start&filter[limit]=$end',
      body: {},
    );
    log("Notification res :$response");
    if ((response as List).isEmpty) {
      Utility.isNotificationResEmpty = false;
      print('    Utility.isNotificationResEmpty');
    }
    final notificationResponseModel = (response as List<dynamic>)
        .map((e) => NotificationListResponseModel.fromJson(e))
        .toList();
    return notificationResponseModel;
  }
}
