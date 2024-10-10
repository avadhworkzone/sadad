import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/getInvoiceResponseModel.dart';

import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class GetInvoiceRepo extends BaseService {
  Future<GetInvoiceResponseModel> getInvoiceRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getInvoice +
          '/$id?filter[include][0][invoicedetails][product]=productmedia&filter[include][1]=user',
      body: {},
    );
    log("GetInvoice res :$response");
    // final getInvoiceResponseModel = (response as List<dynamic>)
    //     .map((e) => GetInvoiceResponseModel.fromJson(e))
    //     .toList();
    // return getInvoiceResponseModel;
    GetInvoiceResponseModel getInvoiceResponseModel =
        GetInvoiceResponseModel.fromJson(response);
    return getInvoiceResponseModel;
  }
}
