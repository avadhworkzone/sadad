// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/posAllTransactionResponseModel.dart';

import '../../apimodels/responseModel/productScreen/onlineTransactionResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class PosTransactionCountRepo extends BaseService {
  ///order Count
  Future<PosAllTransactionCountResponseModel> posTransactionCountRepo(
      String date) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTransactionCount +
          '?filter[date]=' +
          date +
          '&isPosTransaction=true',
      body: {},
    );
    print("posTransactionCount res :$response");
    final posTransactionCountResponseModel =
        PosAllTransactionCountResponseModel.fromJson(response);
    return posTransactionCountResponseModel;
  }
}
