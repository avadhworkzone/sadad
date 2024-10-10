// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosDisputesRepo extends BaseService {
  Future<List<PosDisputesResponseModel>> posDisputesListRepo(
      {String? id,
      String? transactionEntityId,
      String? transactionStatus,
      String terminalFilter = '',
      String? include,
      required int start,
      required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: disputes +
          '?filter={"where":{"and":[{"or":[{"senderId": $id},{"receiverId":$id}]}, $transactionEntityId$transactionStatus$terminalFilter]},"skip":"$start","limit":"10","order":"created DESC","include":$include}',
      body: {},
    );
    print("dispute list res :$response");
    final posDisputesResponseModel = (response as List<dynamic>)
        .map((e) => PosDisputesResponseModel.fromJson(e))
        .toList();
    return posDisputesResponseModel;
  }
}
