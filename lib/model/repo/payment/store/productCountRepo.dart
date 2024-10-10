// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/productCountResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class ProductCountRepo extends BaseService {
  Future<ProductCountResponseModel> productCountRepo(
      String id, String filter, String dateFilter) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: productList +
          '/count?where={"and":[{"merchantId":$id}$filter,{"isRecurringProduct":"0"}]$dateFilter}',
      body: {},
    );
    print('ProductCount :::$response');
    ProductCountResponseModel productCountResponseModel =
        ProductCountResponseModel.fromJson(response as Map<String, dynamic>);
    return productCountResponseModel;
  }
}
