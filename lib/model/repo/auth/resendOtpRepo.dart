import 'dart:developer';

import '../../apimodels/responseModel/Auth /resendOtpResponseModel.dart';
import '../../apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class ResendOtpRepo extends BaseService {
  Future<ResendOtpResponseModel> resendOtpRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: resendOtp,
      body: {},
    );
    log("resendOtp res :$response");
    ResendOtpResponseModel resendOtpResponseModel =
        ResendOtpResponseModel.fromJson(response);
    return resendOtpResponseModel;
  }
}
