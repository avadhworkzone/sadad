import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class TerminalListRepo extends BaseService {
  Future<List<TerminalListResponseModel>> terminalListRepo(
      {required int start, required int end, String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTerminal +
          '?filter[skip]=$start&filter[limit]=$end&filter[order][0]=is_active DESC&filter[order][1]=is_online ASC&filter[include]=posdevice$filter',
      body: {},
    );
    print("TerminalListRes res :$response");
    final terminalListResponseModel = (response as List<dynamic>)
        .map((e) => TerminalListResponseModel.fromJson(e))
        .toList();
    return terminalListResponseModel;
  }

  Future<List<TerminalListResponseModel>> terminalReportListRepo(
      {required int start, required int end, String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTerminalReport +
          '?filter[skip]=$start&filter[limit]=$end&filter[order]=created DESC$filter',
      body: {},
    );
    print("TerminalListRes res :$response");
    final terminalListResponseModel = (response as List<dynamic>)
        .map((e) => TerminalListResponseModel.fromJson(e))
        .toList();
    return terminalListResponseModel;
  }
}
