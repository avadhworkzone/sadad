import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/userBankListResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class UserBankListRepo extends BaseService {
  Future<List<UserBankListResponseModel>> userBankListRepo() async {
    String id = await encryptedSharedPreferences.getString('id');

    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: userBankList + '?filter[where][userId]=$id&filter[include]=bank',
      body: {},
    );
    print("UserBankListRepo res :$response");
    final userBankListResponseModel = (response as List<dynamic>)
        .map((e) => UserBankListResponseModel.fromJson(e))
        .toList();
    return userBankListResponseModel;
  }
}
