import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/userMetaProfileResponseModel.dart';

import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class UserMetaProfileRepo extends BaseService {
  Future<List<UserMetaProfileResponse>> userMetaProfileRepo(
    String id,
  ) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: userMetaProfile + '?filter[where][userId]=$id',
      body: {},
    );
    print("userMetaProfile res :$response");

    final userMetaProfileResponse = (response as List<dynamic>)
        .map((e) => UserMetaProfileResponse.fromJson(e))
        .toList();
    return userMetaProfileResponse;
  }
}
