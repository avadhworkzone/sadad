//transactionReport
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/reportListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/terminalListResponse.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosTransactionReportRepo extends BaseService {
  Future<PosReportTransactionListResponseModel> posTransactionReportRepo(
      String filter, String type, String start, String end) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posReport +
          '$type?filter[skip]=$start&filter[limit]=10&filter[order]=created DESC$filter',
      body: {},
    );
    print("Pos transactionReport res :$response");
    final posTransactionReportResponseModel =
        PosReportTransactionListResponseModel.fromJson(
            response as Map<String, dynamic>);
    return posTransactionReportResponseModel;
  }
}

class PosTerminalReportRepo extends BaseService {
  Future<TerminalReportResponseModel> posTerminalReportRepo(
      {required int start, required int end, String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTerminalReport +
          '?filter[skip]=$start&filter[limit]=10&filter[order]=created DESC$filter',
      body: {},
    );
    print("Pos transactionReport res :$response");
    final posTerminalReportResponseModel =
        TerminalReportResponseModel.fromJson(response as Map<String, dynamic>);
    return posTerminalReportResponseModel;
  }
}
