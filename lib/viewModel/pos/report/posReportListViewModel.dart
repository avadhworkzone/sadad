import 'dart:convert';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/createInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/reportListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/terminalListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/invoicereportResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/reportDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/createInvoiceRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/report/posReportListRepo.dart';

import '../../../model/repo/payment/reports/reportsDetailRepo.dart';

class PosReportDetailViewModel extends GetxController {
  ApiResponse posTransactionReportApiResponse = ApiResponse.initial('Initial');
  ApiResponse posTerminalListReportApiResponse = ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;
  bool isPaginationLoading = false;
  List<PosTranListData> tranResponse = [];
  List<TerminalData> terminalResponse = [];

  void setReportInit() {
    posTransactionReportApiResponse = ApiResponse.initial('Initial');
    posTerminalListReportApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    tranResponse.clear();
    terminalResponse.clear();
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  void clearResponseList() {
    tranResponse.clear();
    terminalResponse.clear();
    startPosition = 0;
    endPosition = 10;
  }

  ///transactionReport
  Future<void> transactionReport({
    String? filter,
    String? type,
  }) async {
    if (posTransactionReportApiResponse.status != Status.COMPLETE) {
      posTransactionReportApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      PosReportTransactionListResponseModel transactionReportResponseModel =
          await PosTransactionReportRepo().posTransactionReportRepo(
              filter!, type!, startPosition.toString(), endPosition.toString());

      tranResponse.addAll(transactionReportResponseModel.data!);
      posTransactionReportApiResponse =
          ApiResponse.complete(transactionReportResponseModel);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print(
          "posTransactionReportApiResponse RES:$transactionReportResponseModel");
    } catch (e) {
      setIsPaginationLoading(false);
      print('posTransactionReportApiResponse.....$e');
      posTransactionReportApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///terminal report+
  Future<void> terminalReport({
    String? filter,
    String? type,
  }) async {
    if (posTerminalListReportApiResponse.status != Status.COMPLETE) {
      posTerminalListReportApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      TerminalReportResponseModel terminalReportResponseModel =
          await PosTerminalReportRepo().posTerminalReportRepo(
        end: endPosition,
        start: startPosition,
        filter: filter!,
      );

      terminalResponse.addAll(terminalReportResponseModel.data!);
      posTerminalListReportApiResponse =
          ApiResponse.complete(terminalReportResponseModel);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print(
          "posTerminalListReportApiResponse RES:${jsonEncode(terminalReportResponseModel)}");
    } catch (e) {
      setIsPaginationLoading(false);
      print('posTerminalListReportApiResponse.....$e');
      posTerminalListReportApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
