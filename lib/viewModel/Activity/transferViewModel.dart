import 'dart:convert';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityAllTransactionReportResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/lastTransferListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/transferListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Activity/transactionDetailsReportRepo.dart';
import 'package:sadad_merchat_app/model/repo/Activity/transactionListRepo.dart';

class TransferViewModel extends GetxController {
  ApiResponse transferListApiResponse = ApiResponse.initial('Initial');
  ApiResponse lastTransferListApiResponse = ApiResponse.initial('Initial');
  ApiResponse transferReportListApiResponse = ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;
  bool isPaginationLoading = false;
  String countTransferReport = '0';
  List<LastTransferListResponse> response = [];
  List<DataTransaction> activityReportTransferResponse = [];

  void setTransactionInit() {
    print('call.....');
    lastTransferListApiResponse = ApiResponse.initial('Initial');
    transferReportListApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    response.clear();
    activityReportTransferResponse.clear();
    update();
  }

  void clearResponseList() {
    response.clear();
    startPosition = 0;
    endPosition = 10;
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;

    update();
  }

  /// balance List...

  Future<void> transferList({
    String? filter,
  }) async {
    if (transferListApiResponse.status != Status.COMPLETE) {
      transferListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<ActivityTransferListResponse> res =
          await TransferListRepo().transferListRepo(
        start: 0,
        end: 10,
        filter: filter,
      );
      transferListApiResponse = ApiResponse.complete(res);
      setIsPaginationLoading(false);
      print("transferListApiResponse RES:$res");
      print('resssss......${res}');
    } catch (e) {
      setIsPaginationLoading(false);
      print('transferListApiResponse.....$e');
      transferListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// transfer last List...

  Future<void> transferLastList() async {
    if (lastTransferListApiResponse.status != Status.COMPLETE) {
      lastTransferListApiResponse = ApiResponse.loading('Loading');
    }
    print('start===$startPosition end ---$endPosition');
    setIsPaginationLoading(true);

    try {
      List<LastTransferListResponse> res =
          await TransferLastListRepo().transferLastListRepo(
        start: startPosition,
        end: endPosition,
      );
      response.addAll(res);
      lastTransferListApiResponse = ApiResponse.complete(response);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
    } catch (e) {
      setIsPaginationLoading(false);
      print('lastTransferListApiResponse.....$e');
      lastTransferListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///transfer report list
  Future<void> transferReportList({String? filter}) async {
    if (transferReportListApiResponse.status != Status.COMPLETE) {
      transferReportListApiResponse = ApiResponse.loading('Loading');
    }
    print('start===$startPosition end ---$endPosition');
    setIsPaginationLoading(true);

    try {
      ActivityAllTransactionReportResponse res =
          await TransferDetailsReportRepo().transferListRepo(
              start: startPosition, end: endPosition, filter: filter);
      countTransferReport = res.count.toString();
      activityReportTransferResponse.addAll(res.data!);
      transferReportListApiResponse =
          ApiResponse.complete(activityReportTransferResponse);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
    } catch (e) {
      setIsPaginationLoading(false);
      print('transferReportListApiResponse.....$e');
      transferReportListApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
