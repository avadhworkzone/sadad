import '../../apimodels/responseModel/productScreen/onlineTransactionResponseModel.dart';
import '../../services/api_service.dart';
import '../../services/base_service.dart';

class OnlineTransactionRepo extends BaseService {
  ///order Count
  Future<OnlineTransactionResponseModel> onlineTransactionRepo(
      String date) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: onlineTransaction + '?filter[date]=' + date,
      body: {},
    );
    print("onlineTransaction res :$response");
    final onlineTransactionResponseModel =
        OnlineTransactionResponseModel.fromJson(response);
    return onlineTransactionResponseModel;
  }
}
