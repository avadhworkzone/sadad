import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/adListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/PoSplineChartResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/paymentMethodResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/posPaymentMethodResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/splineChartResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/notificationResponseModel.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/adListRepo.dart';

import '../../model/apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../model/apimodels/responseModel/DashBoard/chart/transactionChartResponseModel.dart';
import '../../model/apis/api_response.dart';
import '../../model/repo/Dashboard/availableBalanceRepo.dart';
import '../../model/repo/Dashboard/notificationRepo.dart';
import '../../model/repo/Dashboard/paymentMethodRepo.dart';
import '../../model/repo/Dashboard/splineChartRepo.dart';
import '../../model/repo/Dashboard/transactionChartRepo.dart';

class DashBoardViewModel extends GetxController {
  ApiResponse availableBalanceApiResponse = ApiResponse.initial('Initial');
  ApiResponse splineChartApiResponse = ApiResponse.initial('Initial');
  ApiResponse pSplineChartApiResponse = ApiResponse.initial('Initial');
  ApiResponse transactionChartApiResponse = ApiResponse.initial('Initial');
  ApiResponse paymentMethodApiResponse = ApiResponse.initial('Initial');
  ApiResponse posPaymentMethodApiResponse = ApiResponse.initial('Initial');
  ApiResponse adsListApiResponse = ApiResponse.initial('Initial');

  RxString transactionChartLine = 'All'.obs;

  int _countGraph = 0;

  int get countGraph => _countGraph;
  void addCount() {
    _countGraph++;
    update();
  }

  void setCount(int val) {
    _countGraph = val;
    update();
  }

  void subCount() {
    _countGraph--;
    update();
  }

  bool _isChartLoad = true;

  bool get isChartLoad => _isChartLoad;

  set isChartLoad(bool value) {
    _isChartLoad = value;
    update();
  }

  set initIsChartLoad(bool value) {
    _isChartLoad = value;
    // update();
  }

  void setInit() {
    availableBalanceApiResponse = ApiResponse.initial('Initial');
    pSplineChartApiResponse = ApiResponse.initial('Initial');
    splineChartApiResponse = ApiResponse.initial('Initial');
    transactionChartApiResponse = ApiResponse.initial('Initial');
    paymentMethodApiResponse = ApiResponse.initial('Initial');
    posPaymentMethodApiResponse = ApiResponse.initial('Initial');
    adsListApiResponse = ApiResponse.initial('Initial');
  }

  /// AvailableBalance...
  Future<void> availableBalance(String id) async {
    availableBalanceApiResponse = ApiResponse.loading('Loading');
    // update();
    try {
      AvailableBalanceResponseModel response =
          await AvailableBalanceRepo().availableBalanceRepo(id);
      availableBalanceApiResponse = ApiResponse.complete(response);
      print("AvailableBalanceApiResponse RES:$response");
    } catch (e) {
      print('AvailableBalanceApiResponse.....$e');
      availableBalanceApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// SplineChart...
  Future<void> splineChart(String time) async {
    splineChartApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      SplineChartResponseModel response =
          await SplineChartRepo().splineChartRepo(time);
      splineChartApiResponse = ApiResponse.complete(response);
      print("splineChartApiResponse RES:$response");
    } catch (e) {
      print('splineChartApiResponse.....$e');
      splineChartApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> posSplineChart(String time) async {
    pSplineChartApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      PosSplineChartResponseModel response =
          await SplineChartRepo().posSplineChartRepo(time);
      pSplineChartApiResponse = ApiResponse.complete(response);
      print("pSplineChartApiResponse RES:$response");
    } catch (e) {
      print('pSplineChartApiResponse.....$e');
      pSplineChartApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// TransactionChart...
  Future<void> transactionChart(String time) async {
    transactionChartApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      TransactionChartResponseModel response =
          await TransactionChartRepo().transactionChartRepo(time);
      transactionChartApiResponse = ApiResponse.complete(response);
      print("transactionChartApiResponse RES:$response");
    } catch (e) {
      print('transactionChartApiResponse.....$e');
      transactionChartApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///Payment Method

  Future<void> paymentMethod(String time) async {
    paymentMethodApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      PaymentMethodResponseModel response =
          await PaymentMethodRepo().paymentMethodRepo(time);
      paymentMethodApiResponse = ApiResponse.complete(response);
      print("paymentMethodApiResponse RES:$response");
    } catch (e) {
      print('paymentMethodApiResponse.....$e');
      paymentMethodApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> posPaymentMethod(String time) async {
    posPaymentMethodApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      PosPaymentMethodResponseModel response =
          await PaymentMethodRepo().posPaymentMethodRepo(time);
      posPaymentMethodApiResponse = ApiResponse.complete(response);
      print("posPaymentMethodApiResponse RES:$response");
    } catch (e) {
      print('posPaymentMethodApiResponse.....$e');
      posPaymentMethodApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// adsList...
  Future<void> adsList() async {
    adsListApiResponse = ApiResponse.loading('Loading');
    update();

    try {
      List<AdsListResponseModel> res = await AdsListRepo().adsListRepo();
      print('res pos ${res.length}');
      adsListApiResponse = ApiResponse.complete(res);

      print("adsListApiResponse RES:$res");
    } catch (e) {
      print('adsListApiResponse.....$e');
      adsListApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
