import 'dart:developer';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/posPaymentMethodResponseModel.dart';

import '../../apimodels/responseModel/DashBoard/chart/paymentMethodResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class PaymentMethodRepo extends BaseService {
  Future<PaymentMethodResponseModel> paymentMethodRepo(
    String time,
  ) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: paymentMethod + '?filter[date]=$time',
      body: {},
    );
    log("paymentMethod res :$response");
    PaymentMethodResponseModel paymentMethodResponseModel =
        PaymentMethodResponseModel.fromJson(response as Map<String, dynamic>);
    return paymentMethodResponseModel;
  }

  Future<PosPaymentMethodResponseModel> posPaymentMethodRepo(
    String time,
  ) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: paymentMethod + '?filter[date]=$time&isPosTransaction=true',
      body: {},
    );
    log("paymentMethod res :$response");
    PosPaymentMethodResponseModel paymentMethodResponseModel =
        PosPaymentMethodResponseModel.fromJson(
            response as Map<String, dynamic>);
    return paymentMethodResponseModel;
  }
}
