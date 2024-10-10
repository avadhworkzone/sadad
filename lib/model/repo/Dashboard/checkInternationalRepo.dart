import 'dart:developer';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/checkInternationalResponseModel.dart';

import '../../apimodels/responseModel/DashBoard/chart/paymentMethodResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class CheckInternationalRepo extends BaseService {
  Future<List<CheckInternationalResponseModel>> checkInternationalRepo(
    String id,
  ) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: checkInternational + '?filter[where][userId]=$id',
    );
    log("CheckInternational res :$response");
    List<dynamic> resList = response;
    return resList
        .map((e) => CheckInternationalResponseModel.fromJson(e))
        .toList();
  }
}
