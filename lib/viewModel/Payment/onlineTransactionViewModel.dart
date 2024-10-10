import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/eCommerceCounterResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/payment/ecommerceCounterRepo.dart';

import '../../model/apimodels/responseModel/productScreen/onlineTransactionResponseModel.dart';
import '../../model/repo/payment/onlineTransactionRepo.dart';

class OnlineTransactionViewModel extends GetxController {
  ApiResponse onlineTransactionApiResponse = ApiResponse.initial('Initial');
  ApiResponse eCommerceCounterApiResponse = ApiResponse.initial('Initial');
  setInit() {
    onlineTransactionApiResponse = ApiResponse.initial('Initial');
    eCommerceCounterApiResponse = ApiResponse.initial('Initial');
  }

  ///add product view model
  Future<void> onlineTransaction(String date) async {
    onlineTransactionApiResponse = ApiResponse.loading('Loading');
    try {
      OnlineTransactionResponseModel response =
          await OnlineTransactionRepo().onlineTransactionRepo(date);
      onlineTransactionApiResponse = ApiResponse.complete(response);
      print("onlineTransactionApiResponse RES:$response");
    } catch (e) {
      print('onlineTransactionApiResponse.....$e');
      onlineTransactionApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> ecommerceCounter(String filter) async {
    eCommerceCounterApiResponse = ApiResponse.loading('Loading');
    try {
      ECommerceCounterResponseModel response =
          await EcommerceCounterRepo().eCommerceCounterRepo(filter);
      eCommerceCounterApiResponse = ApiResponse.complete(response);
      print("eCommerceCounterApiResponse RES:$response");
    } catch (e) {
      print('eCommerceCounterApiResponse.....$e');
      eCommerceCounterApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
