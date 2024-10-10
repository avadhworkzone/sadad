import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/posPaymentReportTransactionResModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/pospaymentResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosTransactionReportRepo extends BaseService {
  Future<PosPaymentReportTransactionResModel> posPaymentReportListRepo({
    String? id,
    String? transactionEntityId,
    String? transactionStatus,
    String? include,
    String terminalFilter = '',
    String transactionType = '',
    required int start,
  }) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTransactionReport +
          // '?filter={"where":{"and":[{"or":[{"senderId": $id},{"receiverId":$id}]}, $transactionEntityId$transactionStatus$terminalFilter]},"skip": $start,"limit": $end,"order": "created DESC","include": $include}',
          '?filter[skip]=$start&filter[limit]=10&filter[order]=created DESC$terminalFilter$transactionType$transactionStatus',
      body: {},
    );
    print("payment list res :$response");
    PosPaymentReportTransactionResModel posPaymentReportTransactionResModel =
        PosPaymentReportTransactionResModel.fromJson(response);
    return posPaymentReportTransactionResModel;
    // final posPaymentResponseModel = (response as List<dynamic>)
    //     .map((e) => PosPaymentResponseModel.fromJson(e))
    //     .toList();
    // return posPaymentResponseModel;
  }
}
