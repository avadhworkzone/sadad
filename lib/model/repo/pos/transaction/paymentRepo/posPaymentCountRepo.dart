// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosPaymentCountRepo extends BaseService {
  Future<PosPaymentCountResponseModel> posPaymentCountRepo({
    String? filter,
    String? id,
    String? transactionEntityId,
    String terminalFilter = '',
    String? transactionStatus,
  }) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posPaymentCount +
          '?where={ "and": [{"or":[{"senderId":$id},{ "receiverId":$id}]},$transactionEntityId$transactionStatus$terminalFilter] }',
      body: {},
    );
    print("payment count res :$response");
    final posPaymentCountResponseModel =
        PosPaymentCountResponseModel.fromJson(response as Map<String, dynamic>);
    return posPaymentCountResponseModel;
  }
}
