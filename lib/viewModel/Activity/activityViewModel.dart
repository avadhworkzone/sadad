import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/balanceListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Activity/balanceListRepoModel.dart';

class ActivityViewModel extends GetxController {
  ApiResponse balanceListApiResponse = ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;
  String countBalance = '';
  bool isPaginationLoading = false;
  List<BalanceData> response = [];

  void setTransactionInit() {
    balanceListApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    response.clear();
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

  Future<void> balanceList({
    String? filter,
  }) async {
    if (balanceListApiResponse.status != Status.COMPLETE) {
      balanceListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      BalanceListResponseModel res = await BalanceListRepo().balanceListRepo(
        start: startPosition,
        end: endPosition,
        filter: filter,
      );
      countBalance = res.count.toString();
      response.addAll(res.data!);
      balanceListApiResponse = ApiResponse.complete(response);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("balanceListApiResponse RES:$response");
    } catch (e) {
      setIsPaginationLoading(false);
      print('balanceListApiResponse.....$e');
      balanceListApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
