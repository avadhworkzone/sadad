import 'dart:developer';

import '../../apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../apimodels/responseModel/DashBoard/chart/transactionChartResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class TransactionChartRepo extends BaseService {
  Future<TransactionChartResponseModel> transactionChartRepo(
      String time) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: transactionChart + '?filter[date]=$time',
      body: {},
    );
    log("Transaction res :$response");
    TransactionChartResponseModel transactionChartResponseModel =
        TransactionChartResponseModel.fromJson(
            response as Map<String, dynamic>);
    return transactionChartResponseModel;
  }
}
