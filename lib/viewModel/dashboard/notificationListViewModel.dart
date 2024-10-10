import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/PoSplineChartResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/paymentMethodResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/posPaymentMethodResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/splineChartResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/notificationResponseModel.dart';

import '../../model/apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../model/apimodels/responseModel/DashBoard/chart/transactionChartResponseModel.dart';
import '../../model/apis/api_response.dart';
import '../../model/repo/Dashboard/availableBalanceRepo.dart';
import '../../model/repo/Dashboard/notificationRepo.dart';
import '../../model/repo/Dashboard/paymentMethodRepo.dart';
import '../../model/repo/Dashboard/splineChartRepo.dart';
import '../../model/repo/Dashboard/transactionChartRepo.dart';

class NotificationListViewModel extends GetxController {
  ApiResponse notificationApiResponse = ApiResponse.initial('Initial');

  ///notification
  int startPosition = 0;
  int endPosition = 10;
  bool isPaginationLoading = false;
  List<NotificationListResponseModel> response = [];

  List<bool> isReadList = [];

  void clearResponseList() {
    response.clear();
    startPosition = 0;
    endPosition = 10;
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  ///

  void setInit() {
    notificationApiResponse = ApiResponse.initial('Initial');
  }

  /// notificationList...
  Future<void> notificationList() async {
    if (notificationApiResponse.status != Status.COMPLETE) {
      notificationApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);
    try {
      List<NotificationListResponseModel> res = await NotificationListRepo()
          .notificationRepo(end: endPosition, start: startPosition);
      print('res pos ${response.length}');
      response.addAll(res);
      notificationApiResponse = ApiResponse.complete(response);
      response.forEach((element) {
        if (element.isread == true) {
          isReadList.add(true);
        } else {
          isReadList.add(false);
        }
      });
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("notificationApiResponse RES:$response");
    } catch (e) {
      setIsPaginationLoading(false);
      print('notificationApiResponse.....$e');
      notificationApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
