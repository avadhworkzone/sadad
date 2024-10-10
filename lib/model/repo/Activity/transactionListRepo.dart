import 'dart:developer';

import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/balanceListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/lastTransferListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/transferListResponseModel.dart';

import '../../apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class TransferListRepo extends BaseService {
  Future<List<ActivityTransferListResponse>> transferListRepo(
      {required int start, required int end, String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: activityTransactionList + '${filter}',
      body: {},
    );
    print("TransferList res :$response");
    final activityTransferListResponse = (response as List<dynamic>)
        .map((e) => ActivityTransferListResponse.fromJson(e))
        .toList();
    return activityTransferListResponse;
  }
}

class TransferLastListRepo extends BaseService {
  Future<List<LastTransferListResponse>> transferLastListRepo({
    required int start,
    required int end,
  }) async {
    String id = await encryptedSharedPreferences.getString('id');
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: activityTransactionList +
          '?filter[where][or][0][senderId]=$id&filter[where][or][1][receiverId]=$id&filter[include]=senderId&filter[include]=receiverId&filter[include]=guestuser&filter[skip]=$start&filter[limit]=10&filter[order]=created%20DESC&filter[where][transactionentityId]=5',
      body: {},
    );
    print("LastTransferListResponse  :$response");
    final lastTransferListResponse = (response as List<dynamic>)
        .map((e) => LastTransferListResponse.fromJson(e))
        .toList();
    return lastTransferListResponse;
  }
}
