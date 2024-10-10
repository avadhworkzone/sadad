// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';
import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/onlineInvoiceResponseModel.dart';

import '../../../apimodels/responseModel/DashBoard/invoice/invoiceListAllResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class InvoiceAllListRepo extends BaseService {
  Future<List<InvoiceAllListResponseModel>> invoiceAllListRepo(
      String id, String date,
      {required int start, required int end}) async {
    print("getInvoice ${getInvoice}");
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getInvoice +
          '?filter[where][invoicesenderId]=$id&filter[skip]=$start&filter[limit]=10&filter[where][isrentalplaninvoice]=0&filter[where][subsinvoiceId]=0&filter[where][datefilter]=$date&filter[include][0][invoicedetails]&filter[include][1]=invoicesenderId&filter[include][2]=invoicestatus&filter[include][3]=invoicereceiverId&filter[include][4]=user&filter[where][recurring_freq]=none',
    );
    print("invoiceList res :$response");
    final invoiceAllListResponseModel = (response as List<dynamic>)
        .map((e) => InvoiceAllListResponseModel.fromJson(e))
        .toList();
    return invoiceAllListResponseModel;
  }

  Future<OnlineInvoiceReportResponse> invoiceAllListReportRepo(String filter,
      {required int start, required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: invoiceReportOnline +
          '?filter[skip]=$start&filter[limit]=10&filter[order]=created DESC$filter',
    );
    print("invoiceList res :$response");
    OnlineInvoiceReportResponse onlineInvoiceReportResponse =
        OnlineInvoiceReportResponse.fromJson(response);
    return onlineInvoiceReportResponse;
  }
}
