import 'dart:developer';

import '../../apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class AvailableBalanceRepo extends BaseService {
  Future<AvailableBalanceResponseModel> availableBalanceRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: availableBalance + '?filter[where][userId]=$id',
      body: {},
    );
    log("AvailableBalance res :$response");
    AvailableBalanceResponseModel availableBalanceResponseModel =
        AvailableBalanceResponseModel.fromJson(
            (response as List<dynamic>).first);
    return availableBalanceResponseModel;
  }
}
