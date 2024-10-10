import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalFilterGetSubUserResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class GetSubUserRepo extends BaseService {
  Future<List<GetSubUserNamesResponseModel>> getSubUserRepo() async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: getSubUser,
      body: {},
    );
    print("getSubUser res :$response");
    final getSubUserNamesResponseModel = (response as List<dynamic>)
        .map((e) => GetSubUserNamesResponseModel.fromJson(e))
        .toList();
    return getSubUserNamesResponseModel;
  }
}
