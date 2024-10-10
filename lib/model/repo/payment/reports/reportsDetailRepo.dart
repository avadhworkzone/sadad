// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/invoicereportResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import '../../../apimodels/responseModel/productScreen/reports/reportDetailResponseModel.dart';
import '../../../services/base_service.dart';

//transactionReport
class TransactionReportRepo extends BaseService {
  Future<TransactionReportResponseModel> reportsDetailRepo(
      String filter, String type, String start, String end) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: reports +
          '$type?filter[skip]=$start&filter[limit]=$end&filter[order]=created DESC$filter',
      body: {},
    );
    print("transactionReport res :$response");
    final transactionReportResponseModel =
        TransactionReportResponseModel.fromJson(
            response as Map<String, dynamic>);
    return transactionReportResponseModel;
  }
}

//invoiceReport
class InvoiceReportRepo extends BaseService {
  Future<InvoiceReportResponseModel> invoiceReportRepo(
      String filter, String type, String start, String end) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: reports +
          '$type?filter[skip]=$start&filter[limit]=10&filter[order]=created DESC$filter',
      body: {},
    );
    print("invoiceReport res :$response");
    final invoiceReportResponseModel =
        InvoiceReportResponseModel.fromJson(response as Map<String, dynamic>);
    return invoiceReportResponseModel;
  }
}
