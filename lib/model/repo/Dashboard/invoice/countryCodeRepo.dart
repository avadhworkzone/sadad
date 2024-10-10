import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/editInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/countryCodeResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/getInvoiceResponseModel.dart';

import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class CountryCodeRepo extends BaseService {
  Future<List<CountryCodeResponseModel>> countryCodeRepo(
    String code,
  ) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: countryCode + code,
      body: {},
    );
    log("countryCode res :$response");
    final codeResponseModel = (response as List<dynamic>)
        .map((e) => CountryCodeResponseModel.fromJson(e))
        .toList();
    return codeResponseModel;
  }
}
