import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/addProductResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/posAllTransactionResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/posCounterResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/addProductRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/posAllTransactionCountRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/posCounterRepo.dart';

import '../../model/apimodels/responseModel/productScreen/onlineTransactionResponseModel.dart';
import '../../model/repo/payment/onlineTransactionRepo.dart';

class PosTransactionCountViewModel extends GetxController {
  ApiResponse posTransactionCountApiResponse = ApiResponse.initial('Initial');
  ApiResponse posCounterApiResponse = ApiResponse.initial('Initial');

  setInit() {
    posTransactionCountApiResponse = ApiResponse.initial('Initial');
    posCounterApiResponse = ApiResponse.initial('Initial');
  }

  ///add product view model
  Future<void> posTransactionCount(String date) async {
    posTransactionCountApiResponse = ApiResponse.loading('Loading');
    // update();
    try {
      PosAllTransactionCountResponseModel response =
          await PosTransactionCountRepo().posTransactionCountRepo(date);
      posTransactionCountApiResponse = ApiResponse.complete(response);
      print("posTransactionCountApiResponse RES:$response");
    } catch (e) {
      print('posTransactionCountApiResponse.....$e');
      posTransactionCountApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> posCounter(String date) async {
    posCounterApiResponse = ApiResponse.loading('Loading');
    // update();
    try {
      PosCounterResponseModel response =
          await PosCounterRepo().posCounterRepo(date);
      posCounterApiResponse = ApiResponse.complete(response);
      print("posCounterApiResponse RES:$response");
    } catch (e) {
      print('posCounterApiResponse.....$e');
      posCounterApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
