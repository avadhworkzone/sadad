import 'dart:convert';

import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/createInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class CreateInvoiceRepo extends BaseService {
  Future<CreateInvoiceResponseModel> createInvoiceRepo(
      CreateInvoiceRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    // print('CreateInvoiceRequestModel Req :${jsonEncode(model)}');
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: createInvoice,
      body: body,
    );
    print('Response CreateInvoice Data :::$response');
    // print('response type:${response.runtimeType}');
    CreateInvoiceResponseModel createInvoiceResponseModel =
        CreateInvoiceResponseModel.fromJson(response);

    return createInvoiceResponseModel;
  }
}
