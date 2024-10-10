import 'dart:developer';
import '../../../apimodels/responseModel/DashBoard/invoice/invoiceCountResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class InvoiceCountRepo extends BaseService {
  Future<InvoiceCountResponseModel> invoiceCountRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: invoiceCount + '?where[invoicesenderId]=$id',
      body: {},
    );
    log("invoiceCount res :$response");
    InvoiceCountResponseModel invoiceCountResponseModel =
        InvoiceCountResponseModel.fromJson(response);
    return invoiceCountResponseModel;
  }
}
