// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosDisputeCountRepo extends BaseService {
  Future<PosDisputesCountResponseModel> posDisputeCountRepo({
    String? filter,
    String? id,
    String terminalFilter = '',
    String? transactionEntityId,
    String? transactionStatus,
  }) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posDisputeCount +
          '?where={ "and":[{"or":[{"senderId": $id},{"receiverId":$id}]}, $transactionEntityId$transactionStatus$terminalFilter] }',
      body: {},
    );
    print("dispute count res :$response");
    final posDisputesCountResponseModel =
        PosDisputesCountResponseModel.fromJson(
            response as Map<String, dynamic>);
    return posDisputesCountResponseModel;
  }
}
