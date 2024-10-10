import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/eCommerceCounterResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class EcommerceCounterRepo extends BaseService {
  ///order Count
  Future<ECommerceCounterResponseModel> eCommerceCounterRepo(
      String filter) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: ecommerceCounter + '?filter[date]=$filter',
      body: {},
    );
    print("ecommerceCounter res :$response");
    // print('ecommerceCounter${url}');
    final eCommerceCounterResponseModel =
        ECommerceCounterResponseModel.fromJson(
            response as Map<String, dynamic>);
    return eCommerceCounterResponseModel;
  }
}
