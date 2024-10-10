import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/editInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/getInvoiceResponseModel.dart';

import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class EditInvoiceRepo extends BaseService {
  Future<GetInvoiceResponseModel> editInvoiceRepo(
      String id, EditInvoiceRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPatch,
      url: getInvoice +
          '/$id?filter[include][invoicedetails][product]=productmedia',
      body: body,
    );

    log("EditInvoice res :$response");
    GetInvoiceResponseModel getInvoiceResponseModel =
        GetInvoiceResponseModel.fromJson(response);
    return getInvoiceResponseModel;
  }
}
