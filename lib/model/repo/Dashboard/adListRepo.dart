import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/adListResponseModel.dart';

import '../../apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class AdsListRepo extends BaseService {
  Future<List<AdsListResponseModel>> adsListRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: ads,
    );
    log("AdsListRepo res :$response");
    List<dynamic> resList = response;
    return resList.map((e) => AdsListResponseModel.fromJson(e)).toList();
  }
}
