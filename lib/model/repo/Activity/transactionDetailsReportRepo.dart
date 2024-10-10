import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityAllTransactionReportResponse.dart';

import '../../services/api_service.dart';
import '../../services/base_service.dart';

class TransferDetailsReportRepo extends BaseService {
  Future<ActivityAllTransactionReportResponse> transferListRepo(
      {required int start, required int end, String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: transactionDetailsReport +
          '?filter[skip]=$start&filter[limit]=10&filter[order]=created%20DESC&filter[where][transactionentityId][inq][0]=5&filter[where][transactionentityId][inq][1]=8$filter',
      body: {},
    );
    log("transferListResponse res ::::$response");
    ActivityAllTransactionReportResponse activityAllTransactionReportResponse =
        ActivityAllTransactionReportResponse.fromJson(
            (response as Map<String, dynamic>));
    return activityAllTransactionReportResponse;
  }
}
