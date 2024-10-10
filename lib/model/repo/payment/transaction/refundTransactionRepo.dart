import 'package:sadad_merchat_app/model/services/api_service.dart';

import '../../../apimodels/responseModel/productScreen/transaction/refundTransactionResponseModel.dart';
import '../../../apimodels/responseModel/productScreen/transaction/transactionDetailModel.dart';
import '../../../services/base_service.dart';

class RefundTransactionDetailRepo extends BaseService {
  Future<TransactionRefundDetailResponseModel> refundTransactionDetailRepo(
      String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: transactionList +
          '/$id?filter={"include": ["senderId", "receiverId", "guestuser", "transactionentity", "transactionmode", "transactionstatus", "postransaction", "dispute"]}',
      body: {},
    );
    print("RefundTransactionDetail res :$response");
    final refundTransactionDetailResponseModel =
        TransactionRefundDetailResponseModel.fromJson(
            response as Map<String, dynamic>);
    return refundTransactionDetailResponseModel;
  }
}
