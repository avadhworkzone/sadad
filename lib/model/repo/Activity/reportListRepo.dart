import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityAllTransactionReportResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalReport.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementPayoutDetailResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlemetPayoutListResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class ActivityWithdrawalReport extends BaseService {
  Future<ActivityWithdrawalReportResponseModel> withdrawalListRepo(
      {String? filter,
      String? filterType,
      required int start,
      required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url:
          'reporthistories/$filterType?filter[skip]=$start&filter[limit]=10$filter',
      body: {},
    );
    print("ActivityWithdrawalReport res :$response");
    ActivityWithdrawalReportResponseModel
        settlementWithdrawalListResponseModel =
        ActivityWithdrawalReportResponseModel.fromJson(
            (response as Map<String, dynamic>));
    return settlementWithdrawalListResponseModel;
  }
}

class ActivityAllTransactionReport extends BaseService {
  Future<ActivityAllTransactionReportResponse> allTransactionListRepo(
      {String? filter, required int start, required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url:
          'reporthistories/transactionDetailsReport?filter[skip]=$start&filter[limit]=10$filter',
      body: {},
    );
    print("ActivityAllTransactionReport res :$response");

    ActivityAllTransactionReportResponse activityAllTransactionReportResponse =
        ActivityAllTransactionReportResponse.fromJson(
            (response as Map<String, dynamic>));
    return activityAllTransactionReportResponse;
  }
}
