import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/createInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/invoicereportResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/reportDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/createInvoiceRepo.dart';

import '../../../model/repo/payment/reports/reportsDetailRepo.dart';

class ReportDetailViewModel extends GetxController {
  ApiResponse transactionReportApiResponse = ApiResponse.initial('Initial');
  ApiResponse invoiceReportApiResponse = ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;
  bool isPaginationLoading = false;
  List<RepData> tranResponse = [];
  List<InvData> invResponse = [];

  void setReportInit() {
    transactionReportApiResponse = ApiResponse.initial('Initial');
    invoiceReportApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    tranResponse.clear();
    invResponse.clear();
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  void clearResponseList() {
    tranResponse.clear();
    invResponse.clear();
    startPosition = 0;
    endPosition = 10;
  }

  ///transactionReport
  Future<void> transactionReport({
    String? filter,
    String? type,
  }) async {
    if (transactionReportApiResponse.status != Status.COMPLETE) {
      transactionReportApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      TransactionReportResponseModel transactionReportResponseModel =
          await TransactionReportRepo().reportsDetailRepo(
              filter!, type!, startPosition.toString(), endPosition.toString());

      tranResponse.addAll(transactionReportResponseModel.repData!);
      transactionReportApiResponse =
          ApiResponse.complete(transactionReportResponseModel);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("transactionReportApiResponse RES:$transactionReportResponseModel");
    } catch (e) {
      setIsPaginationLoading(false);
      print('transactionReportApiResponse.....$e');
      transactionReportApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///invoiceReport
  Future<void> invoiceReport({
    String? filter,
    String? type,
  }) async {
    if (invoiceReportApiResponse.status != Status.COMPLETE) {
      invoiceReportApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      InvoiceReportResponseModel invoiceReportResponseModel =
          await InvoiceReportRepo().invoiceReportRepo(
              filter!, type!, startPosition.toString(), endPosition.toString());

      invResponse.addAll(invoiceReportResponseModel.invdata!);
      invoiceReportApiResponse =
          ApiResponse.complete(invoiceReportResponseModel);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("invoiceReportApiResponse RES:$invoiceReportResponseModel");
    } catch (e) {
      setIsPaginationLoading(false);
      print('invoiceReportApiResponse.....$e');
      transactionReportApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
