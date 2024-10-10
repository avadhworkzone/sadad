import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/posCounterResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/eCommerceCounterResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosCounterRepo extends BaseService {
  ///order Count
  Future<PosCounterResponseModel> posCounterRepo(String filter) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posCounter + '?filter[date]=$filter',
      body: {},
    );
    print("posCounter res :$response");
    final posCounterResponseModel =
        PosCounterResponseModel.fromJson(response as Map<String, dynamic>);
    return posCounterResponseModel;
  }
}
