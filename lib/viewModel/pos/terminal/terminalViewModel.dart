import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/createInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/liveTerminalMapResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/invoicereportResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/reportDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/createInvoiceRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/liveTerminalMapRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/terminal/terminalCountRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/terminal/terminalDetailRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/terminal/terminalListRepo.dart';

import '../../../model/repo/payment/reports/reportsDetailRepo.dart';

class TerminalViewModel extends GetxController {
  ApiResponse terminalListApiResponse = ApiResponse.initial('Initial');
  ApiResponse terminalDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse terminalCountApiResponse = ApiResponse.initial('Initial');
  ApiResponse liveTerminalMapApiResponse = ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;
  bool isPaginationLoading = false;
  List<TerminalListResponseModel> terminalListRes = [];

  void setTerminalInit() {
    terminalListApiResponse = ApiResponse.initial('Initial');
    terminalDetailApiResponse = ApiResponse.initial('Initial');
    terminalCountApiResponse = ApiResponse.initial('Initial');
    liveTerminalMapApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    // terminalListRes.clear();
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  void clearResponseList() {
    terminalListRes.clear();
    startPosition = 0;
    endPosition = 10;
  }

  Future<void> terminalList({String? filter, int? ending, bool isLoading = false, bool isBackLoading = true}) async {
    if (isBackLoading) {
      if (terminalListApiResponse.status != Status.COMPLETE || isLoading == true) {
        terminalListApiResponse = ApiResponse.loading('Loading');
      }
    }
    update();
    // setIsPaginationLoading(true);

    try {
      List<TerminalListResponseModel> terminalListResponseModel = await TerminalListRepo().terminalListRepo(start: startPosition, end: ending == null ? endPosition : ending, filter: filter);
      if (startPosition == 0) {
        terminalListRes.clear();
      }
      terminalListRes.addAll(terminalListResponseModel);
      terminalListApiResponse = ApiResponse.complete(terminalListRes);
      startPosition += 10;
      setIsPaginationLoading(false);
      print("terminalListApiResponse RES:$terminalListRes");
    } catch (e) {
      setIsPaginationLoading(false);
      print('terminalListApiResponse.....$e');
      terminalListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> terminalReportList({String? filter, int? ending, bool isLoading = false}) async {
    if (terminalListApiResponse.status != Status.COMPLETE || isLoading == true) {
      terminalListApiResponse = ApiResponse.loading('Loading');
    }
    update();
    // setIsPaginationLoading(true);

    try {
      List<TerminalListResponseModel> terminalListResponseModel = await TerminalListRepo().terminalReportListRepo(start: startPosition, end: ending != null ? ending : endPosition, filter: filter);

      terminalListRes.addAll(terminalListResponseModel);
      terminalListApiResponse = ApiResponse.complete(terminalListRes);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("terminalListApiResponse RES:$terminalListRes");
    } catch (e) {
      setIsPaginationLoading(false);
      print('terminalListApiResponse.....$e');
      terminalListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///terminalDetail

  Future<void> terminalDetail({String? id}) async {
    terminalDetailApiResponse = ApiResponse.loading('Loading');
    // update();
    try {
      List<TerminalDetailResponseModel> res = await TerminalDetailRepo().terminalDetailRepo(id: id);
      terminalDetailApiResponse = ApiResponse.complete(res);
      print("terminalDetailApiResponse RES:$res");
    } catch (e) {
      print('terminalDetailApiResponse.....$e');
      terminalDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///terminal count

  Future<void> terminalCount({String? filter, bool isLoading = false}) async {
    if (isLoading) {
      terminalCountApiResponse = ApiResponse.loading('Loading');
    }

    try {
      TerminalCountResponseModel countRes = await TerminalCountRepo().terminalCountRepo(filter!);
      terminalCountApiResponse = ApiResponse.complete(countRes);
      print("terminalCountApiResponse RES:$countRes");
    } catch (e) {
      print('terminalCountApiResponse.....$e');
      terminalCountApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///terminal map
  Future<void> terminalMap() async {
    liveTerminalMapApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      List<LiveTerminalMapResponseModel> liveTerminalMapResponseModel = await LiveTerminalMapRepo().liveTerminalMap();
      liveTerminalMapApiResponse = ApiResponse.complete(liveTerminalMapResponseModel);
      print("liveTerminalMapApiResponse RES:$liveTerminalMapResponseModel");
    } catch (e) {
      print('liveTerminalMapApiResponse.....$e');
      liveTerminalMapApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
