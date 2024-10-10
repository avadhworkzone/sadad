import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class TerminalCountRepo extends BaseService {
  Future<TerminalCountResponseModel> terminalCountRepo(String filter) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTerminal + '/count$filter',
      body: {},
    );
    print("TerminalCountRes res :$response");
    TerminalCountResponseModel terminalCountResponseModel =
        TerminalCountResponseModel.fromJson(response as Map<String, dynamic>);
    return terminalCountResponseModel;
  }
}
