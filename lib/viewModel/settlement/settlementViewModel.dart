import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementPayoutDetailResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlemetPayoutListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/userBankListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/settlement/settlementListRepo.dart';
import 'package:sadad_merchat_app/model/repo/settlement/userBankListRepo.dart';

class SettlementWithdrawalListViewModel extends GetxController {
  ApiResponse settlementWithdrawalListApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse settlementPayoutListApiResponse = ApiResponse.initial('Initial');
  ApiResponse settlementWithdrawalDetailApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse activityWithdrawalDetailApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse settlementPayoutDetailApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse userBankListApiResponse = ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;
  bool isPaginationLoading = false;
  List<SettlementWithdrawalListResponseModel> withdrawalResponse = [];
  List<SettlementPayoutListResponseModel> payoutResponse = [];

  void setInit() {
    settlementWithdrawalListApiResponse = ApiResponse.initial('Initial');
    settlementPayoutListApiResponse = ApiResponse.initial('Initial');
    settlementWithdrawalDetailApiResponse = ApiResponse.initial('Initial');
    settlementPayoutDetailApiResponse = ApiResponse.initial('Initial');
    userBankListApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    withdrawalResponse.clear();
    payoutResponse.clear();
  }

  void clearResponseList() {
    withdrawalResponse.clear();
    payoutResponse.clear();

    startPosition = 0;
    endPosition = 10;
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  /// settlement List...

  Future<void> settlementWithdrawalList(
      {String? id,
      String? filter,
      bool isLoading = false,
      bool fromSearch = false}) async {
    if (settlementWithdrawalListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      settlementWithdrawalListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<SettlementWithdrawalListResponseModel> res =
          await SettlementWithdrawalListRepo().settlementWithdrawalListRepo(
              start: startPosition, id: id, filter: filter);
      print('res pos ${withdrawalResponse.length}');
      if (fromSearch == true) {
        withdrawalResponse.clear();
        startPosition = 0;
      }
      withdrawalResponse.addAll(res);
      settlementWithdrawalListApiResponse =
          ApiResponse.complete(withdrawalResponse);
      startPosition += 10;
      setIsPaginationLoading(false);
      print("settlementWithdrawalListApiResponse RES:$withdrawalResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('settlementWithdrawalListApiResponse.....$e');
      settlementWithdrawalListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// payout List...

  Future<void> settlementPayoutList(
      {String? id, String? filter, bool isLoading = false}) async {
    if (settlementPayoutListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      settlementPayoutListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<SettlementPayoutListResponseModel> res =
          await SettlementPayoutListRepo().settlementPayoutListRepo(
              start: startPosition, end: endPosition, id: id, filter: filter);
      print('settlementPayoutListApiResponse  ${payoutResponse.length}');
      payoutResponse.addAll(res);
      settlementPayoutListApiResponse = ApiResponse.complete(payoutResponse);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("settlementPayoutListApiResponse RES:$payoutResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('settlementPayoutListApiResponse.....$e');
      settlementPayoutListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///withdrawal detail
  Future<void> settlementWithdrawalDetail(String id) async {
    settlementWithdrawalDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      SettlementWithdrawalDetailResponseModel
          settlementWithdrawalDetailResponseModel =
          await SettlementWithdrawalDetailRepo()
              .settlementWithdrawalDetailRepo(id: id);
      settlementWithdrawalDetailApiResponse =
          ApiResponse.complete(settlementWithdrawalDetailResponseModel);
      print(
          "settlementWithdrawalDetailApiResponse RES:$settlementWithdrawalDetailResponseModel");
    } catch (e) {
      print('settlementWithdrawalDetailApiResponse.....$e');
      settlementWithdrawalDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///activity withdrawal detail
  Future<void> activityWithdrawalDetail(String id) async {
    activityWithdrawalDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      SettlementWithdrawalDetailResponseModel
          settlementWithdrawalDetailResponseModel =
          await ActivityWithdrawalDetailRepo()
              .activityWithdrawalDetailRepo(id: id);
      activityWithdrawalDetailApiResponse =
          ApiResponse.complete(settlementWithdrawalDetailResponseModel);
      print(
          "activityWithdrawalDetailApiResponse RES:$settlementWithdrawalDetailResponseModel");
    } catch (e) {
      print('activityWithdrawalDetailApiResponse.....$e');
      activityWithdrawalDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///payout detail
  Future<void> settlementPayoutDetail(String id) async {
    settlementPayoutDetailApiResponse = ApiResponse.loading('Loading');
    update();

    try {
      SettlementPayoutDetailResponseModel settlementPayoutDetailResponseModel =
          await SettlementPayoutDetailRepo().settlementPayoutDetailRepo(id: id);
      settlementPayoutDetailApiResponse =
          ApiResponse.complete(settlementPayoutDetailResponseModel);
      print(
          "settlementPayoutDetailApiResponse RES:$settlementPayoutDetailResponseModel");
    } catch (e) {
      print('settlementPayoutDetailApiResponse.....$e');
      settlementPayoutDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///user bank list
  Future<void> userBankList() async {
    userBankListApiResponse = ApiResponse.loading('Loading');
    try {
      List<UserBankListResponseModel> res =
          await UserBankListRepo().userBankListRepo();
      userBankListApiResponse = ApiResponse.complete(res);
      print("userBankListApiResponse RES:$res");
    } catch (e) {
      print('userBankListApiResponse.....$e');
      userBankListApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
