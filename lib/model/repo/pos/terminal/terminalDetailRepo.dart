import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class TerminalDetailRepo extends BaseService {
  Future<List<TerminalDetailResponseModel>> terminalDetailRepo(
      {String? id}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTerminal +
          '?filter[skip]=0&filter[limit]=1&filter[where][terminalId]=$id&filter[order]=created DESC&filter[include]=posdevice&filter[include][4]=terminaldevicehistory&filter[include][1]=rentalPlan&filter[include][2]=rentalDetail',
      body: {},
    );
    print("TerminalDetailRes res :$response");
    final terminalDetailResponseModel = (response as List<dynamic>)
        .map((e) => TerminalDetailResponseModel.fromJson(e))
        .toList();
    return terminalDetailResponseModel;
  }
}
