import 'dart:convert';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/countryCodeResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/createInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/countryCodeRepo.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/createInvoiceRepo.dart';

class CreateInvoiceViewModel extends GetxController {
  ApiResponse createInvoiceApiResponse = ApiResponse.initial('Initial');
  ApiResponse countryCodeApiResponse = ApiResponse.initial('Initial');

  /// CreateInvoice...
  Future<void> createInvoice(CreateInvoiceRequestModel model) async {
    createInvoiceApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      CreateInvoiceResponseModel response =
          await CreateInvoiceRepo().createInvoiceRepo(model);
      createInvoiceApiResponse = ApiResponse.complete(response);
      print("createInvoiceApiResponse RES:$response");
    } catch (e) {
      print('createInvoiceApiResponse.....$e');
      createInvoiceApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///countryCode
  Future<void> countryCode(String code) async {
    countryCodeApiResponse = ApiResponse.loading('Loading');
    update();

    try {
      List<CountryCodeResponseModel> response =
          await CountryCodeRepo().countryCodeRepo(code);
      countryCodeApiResponse = ApiResponse.complete(response);
      print("countryCodeApiResponse RES:$response");
    } catch (e) {
      print('countryCodeApiResponse.....$e');
      countryCodeApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
