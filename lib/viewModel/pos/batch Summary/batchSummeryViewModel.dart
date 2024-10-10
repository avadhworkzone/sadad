import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/BatchSummary/TerminalBatchSummeryResModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementPayoutDetailResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlemetPayoutListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/userBankListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/pos/batch%20summary/batchSummeryRepo.dart';
import 'package:sadad_merchat_app/model/repo/settlement/settlementListRepo.dart';
import 'package:sadad_merchat_app/model/repo/settlement/userBankListRepo.dart';

class BatchSummeryViewModel extends GetxController {
  ApiResponse batchSummeryListApiResponse = ApiResponse.initial('Initial');
  ApiResponse batchSummeryDetailListApiResponse =
      ApiResponse.initial('Initial');

  // int startPosition = 0;
  // int endPosition = 10;
  bool isPaginationLoading = false;
  List<TerminalBatchSummaryResModel> batchSummeryResponse = [];

  void setInit() {
    batchSummeryListApiResponse = ApiResponse.initial('Initial');
    batchSummeryDetailListApiResponse = ApiResponse.initial('Initial');
    // startPosition = 0;
    // endPosition = 10;
    isPaginationLoading = false;
    batchSummeryResponse.clear();
  }

  void clearResponseList() {
    batchSummeryResponse.clear();
    // startPosition = 0;
    // endPosition = 10;
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  /// batchSummeryList List...

  Future<void> batchSummeryList(
      {String? id, String? filter, bool isLoading = false}) async {
    if (batchSummeryListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      batchSummeryListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<TerminalBatchSummaryResModel> res =
          await BatchSummaryRepo().batchSummaryRepo(
              // start: startPosition, end: endPosition,

              filter: filter);
      print('res pos ${batchSummeryResponse.length}');
      batchSummeryResponse.addAll(res);
      batchSummeryListApiResponse = ApiResponse.complete(batchSummeryResponse);
      // startPosition += 10;
      // endPosition += 10;
      setIsPaginationLoading(false);
      print("batchSummeryListApiResponse RES:$batchSummeryResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('batchSummeryListApiResponse.....$e');
      batchSummeryListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// batchSummeryList List...

  Future<void> batchSummeryDetailList(
      {String? id, String? filter, bool isLoading = false}) async {
    if (batchSummeryDetailListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      batchSummeryDetailListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<TerminalBatchSummaryResModel> res =
          await BatchSummaryRepo().batchSummaryDetailRepo(filter: filter);
      print('res pos ${batchSummeryResponse.length}');
      batchSummeryResponse.addAll(res);
      batchSummeryDetailListApiResponse =
          ApiResponse.complete(batchSummeryResponse);
      setIsPaginationLoading(false);
      print("batchSummeryDetailListApiResponse RES:$batchSummeryResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('batchSummeryDetailListApiResponse.....$e');
      batchSummeryDetailListApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
