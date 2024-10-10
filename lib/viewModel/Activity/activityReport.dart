import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityAllTransactionReportResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalFilterGetSubUserResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalReport.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Activity/getSubUserRepo.dart';
import 'package:sadad_merchat_app/model/repo/Activity/reportListRepo.dart';

class ActivityReportViewModel extends GetxController {
  ApiResponse settlementWithdrawalListApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse activityAllTransactionListApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse activityGetSubUserApiResponse = ApiResponse.initial('Initial');
  bool isPaginationLoading = false;
  int startPosition = 0;
  int endPosition = 10;
  String countWithdrawalReport = '0';
  String countTransactionReport = '0';
  List<Data> withdrawalResponse = [];
  List<DataTransaction> transactionResponse = [];

  void setInit() {
    print('call.....');
    settlementWithdrawalListApiResponse = ApiResponse.initial('Initial');
    activityAllTransactionListApiResponse = ApiResponse.initial('Initial');
    activityGetSubUserApiResponse = ApiResponse.initial('Initial');
    isPaginationLoading = false;
    startPosition = 0;
    endPosition = 10;
    update();
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;

    update();
  }

  void clearResponseList() {
    startPosition = 0;
    endPosition = 10;
    transactionResponse.clear();
    withdrawalResponse.clear();
  }

  Future<void> withdrawalList({
    String? filter,
    bool isLoading = false,
    String? filterType,
  }) async {
    if (settlementWithdrawalListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      settlementWithdrawalListApiResponse = ApiResponse.loading('Loading');
    }

    try {
      ActivityWithdrawalReportResponseModel res =
          await ActivityWithdrawalReport().withdrawalListRepo(
        filter: filter,
        start: startPosition,
        filterType: filterType,
        end: endPosition,
      );
      print('res pos ${withdrawalResponse.length}');
      countWithdrawalReport = res.count.toString();
      withdrawalResponse.addAll(res.data!);
      settlementWithdrawalListApiResponse =
          ApiResponse.complete(withdrawalResponse);
      print('startPosition==>$startPosition');
      startPosition += 10;
      endPosition += 10;
      print('startPosition after ==>$startPosition');

      setIsPaginationLoading(false);
      print("settlementWithdrawalListApiResponse RES:$withdrawalResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('settlementWithdrawalListApiResponse.....$e');
      settlementWithdrawalListApiResponse = ApiResponse.error('error');
    }

    update();
  }

  Future<void> allTransactionList({
    String? filter,
    bool isLoading = false,
    String? filterType,
  }) async {
    if (activityAllTransactionListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      activityAllTransactionListApiResponse = ApiResponse.loading('Loading');
    }

    try {
      ActivityAllTransactionReportResponse res =
          await ActivityAllTransactionReport().allTransactionListRepo(
        filter: filter,
        start: startPosition,
        end: endPosition,
      );
      print('res pos ${transactionResponse.length}');
      countTransactionReport = res.count.toString();
      transactionResponse.addAll(res.data!);
      activityAllTransactionListApiResponse =
          ApiResponse.complete(transactionResponse);
      print('startPosition==>$startPosition');
      startPosition += 10;
      endPosition += 10;
      print('startPosition after ==>$startPosition');

      setIsPaginationLoading(false);
      print("activityAllTransactionListApiResponse RES:$transactionResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('activityAllTransactionListApiResponse.....$e');
      activityAllTransactionListApiResponse = ApiResponse.error('error');
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
