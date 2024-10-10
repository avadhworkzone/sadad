// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/liveTerminalMapResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/pospaymentResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class LiveTerminalMapRepo extends BaseService {
  Future<List<LiveTerminalMapResponseModel>> liveTerminalMap() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: liveTerminalMapUrl,
      body: {},
    );
    print("liveTerminalMap res :$response");
    final liveTerminalMapResponseModel = (response as List<dynamic>)
        .map((e) => LiveTerminalMapResponseModel.fromJson(e))
        .toList();
    return liveTerminalMapResponseModel;
  }
}
