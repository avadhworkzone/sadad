import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalFilterGetSubUserResponseModel.dart';
import 'package:sadad_merchat_app/model/repo/Activity/getSubUserRepo.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';

import '../../model/apimodels/responseModel/DashBoard/invoice/invoiceCountResponseModel.dart';
import '../../model/apimodels/responseModel/DashBoard/invoice/invoiceListAllResponseModel.dart';
import '../../model/apimodels/responseModel/productScreen/reports/onlineInvoiceResponseModel.dart';
import '../../model/apis/api_response.dart';
import '../../model/repo/Dashboard/invoice/invoiceCountRepo.dart';
import '../../model/repo/Dashboard/invoice/listAllInvoiceRepo.dart';

class InvoiceListViewModel extends GetxController {
  ApiResponse invoiceCountApiResponse = ApiResponse.initial('Initial');
  ApiResponse invoiceAllListApiResponse = ApiResponse.initial('Initial');
  ApiResponse invoiceAllListReportApiResponse = ApiResponse.initial('Initial');
  ApiResponse activityGetSubUserApiResponse = ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;
  String invoiceCountValue = '';
  bool isPaginationLoading = false;
  List<InvoiceAllListResponseModel> response = [];
  List<InvoiceReportRes> invoiceRepResponse = [];
  void setInit() {
    invoiceCountApiResponse = ApiResponse.initial('Initial');
    invoiceAllListApiResponse = ApiResponse.initial('Initial');
    invoiceAllListReportApiResponse = ApiResponse.initial('Initial');
    activityGetSubUserApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    response.clear();
    invoiceRepResponse.clear();
  }

  void clearResponseLost() {
    response.clear();
    invoiceRepResponse.clear();
    startPosition = 0;
    endPosition = 10;
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  /// InvoiceCount...
  Future<void> invoiceCount(String id) async {
    invoiceCountApiResponse = ApiResponse.loading('Loading');
    try {
      InvoiceCountResponseModel response =
          await InvoiceCountRepo().invoiceCountRepo(id);
      invoiceCountApiResponse = ApiResponse.complete(response);
      print("invoiceCountApiResponse RES:$response");
    } catch (e) {
      print('invoiceCountApiResponse.....$e');
      invoiceCountApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// InvoiceAllList...
  Future<void> listAllInvoice(String id, String date) async {
    if (invoiceAllListApiResponse.status != Status.COMPLETE) {
      invoiceAllListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<InvoiceAllListResponseModel> res = await InvoiceAllListRepo()
          .invoiceAllListRepo(id, date, end: endPosition, start: startPosition);
      print('res pos ${response.length}');
      response.addAll(res);
      invoiceAllListApiResponse = ApiResponse.complete(response);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("invoiceAllListApiResponse RES:$response");
    } catch (e) {
      setIsPaginationLoading(false);
      print('invoiceAllListApiResponse.....$e');
      invoiceAllListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// Invoice reportAllList...
  Future<void> invoiceReport(String filter, {bool fromSearch = false}) async {
    if (invoiceAllListReportApiResponse.status != Status.COMPLETE) {
      invoiceAllListReportApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      OnlineInvoiceReportResponse res = await InvoiceAllListRepo()
          .invoiceAllListReportRepo(filter,
              end: endPosition, start: startPosition);
      print('res pos ${invoiceRepResponse.length}');
      invoiceCountValue = res.count.toString();
      if (fromSearch == true) {
        invoiceRepResponse.clear();
        startPosition = 0;
      }
      invoiceRepResponse.addAll(res.data!);
      invoiceAllListReportApiResponse =
          ApiResponse.complete(invoiceRepResponse);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("invoiceAllListReportApiResponse RES:$invoiceRepResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('invoiceAllListReportApiResponse.....$e');
      invoiceAllListReportApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> getSubUser() async {
    activityGetSubUserApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      List<GetSubUserNamesResponseModel> res =
          await GetSubUserRepo().getSubUserRepo();
      activityGetSubUserApiResponse = ApiResponse.complete(res);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
    } catch (e) {
      setIsPaginationLoading(false);
      print('activityGetSubUserApiResponse.....$e');
      activityGetSubUserApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
