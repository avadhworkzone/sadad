// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/pospaymentResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosTransactionListRepo extends BaseService {
  Future<List<PosPaymentResponseModel>> posPaymentListRepo(
      {String? id,
      String? transactionEntityId,
      String? transactionStatus,
      String? include,
      String terminalFilter = '',
      required int start,
      required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTransaction +
          '?filter={"where":{"and":[{"or":[{"senderId": $id},{"receiverId":$id}]}, $transactionEntityId$transactionStatus$terminalFilter]},"skip": $start,"limit": 10,"order": "created DESC","include": $include}',
      body: {},
    );
    print("payment list res :$response");
    final posPaymentResponseModel = (response as List<dynamic>)
        .map((e) => PosPaymentResponseModel.fromJson(e))
        .toList();
    return posPaymentResponseModel;
  }
}
