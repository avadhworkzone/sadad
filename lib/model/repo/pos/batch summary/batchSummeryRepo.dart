import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/BatchSummary/TerminalBatchSummeryResModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalListResponse.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class BatchSummaryRepo extends BaseService {
  Future<List<TerminalBatchSummaryResModel>> batchSummaryRepo({
    String? filter,
    // required int start,
    // required int end
  }) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      // url: batchSummery + '?filter[skip]=$start&filter[limit]=$end'
      url: batchSummery + '${filter}',
      body: {},
    );
    print("TerminalBatchSummaryList res :$response");
    final batchSummaryRepo = (response as List<dynamic>)
        .map((e) => TerminalBatchSummaryResModel.fromJson(e))
        .toList();
    return batchSummaryRepo;
  }

  Future<List<TerminalBatchSummaryResModel>> batchSummaryDetailRepo(
      {String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: batchSummery + filter!,
      body: {},
    );
    print("TerminalBatchSummaryList res :$response");
    final batchSummaryRepo = (response as List<dynamic>)
        .map((e) => TerminalBatchSummaryResModel.fromJson(e))
        .toList();
    return batchSummaryRepo;
  }
}
