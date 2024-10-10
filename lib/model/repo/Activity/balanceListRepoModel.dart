import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/balanceListResponseModel.dart';

import '../../apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class BalanceListRepo extends BaseService {
  Future<BalanceListResponseModel> balanceListRepo(
      {required int start, required int end, String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: balanceList + '?filter[skip]=$start&filter[limit]=10$filter',
      body: {},
    );
    log("balanceList res :$response");
    BalanceListResponseModel balanceListResponseModel =
        BalanceListResponseModel.fromJson((response as Map<String, dynamic>));
    return balanceListResponseModel;
  }
}
