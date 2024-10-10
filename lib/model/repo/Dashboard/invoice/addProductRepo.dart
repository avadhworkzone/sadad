import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/addProductResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class AddProductRepo extends BaseService {
  Future<List<AddProductsResponseModel>> addProductRepo(
      String id, String key, String name) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: addProducts +
          '?filter[include]=$key&filter[where][merchantId]=$id&filter[where][price][gte]=\"1.0\"&filter[where][isRecurringProduct]=0$name',
      body: {},
    );
    log("AddProduct res :$response");
    // AddProductsResponseModel addProductsResponseModel =
    // AddProductsResponseModel.fromJson(response);
    final addProductsResponseModel = (response as List<dynamic>)
        .map((e) => AddProductsResponseModel.fromJson(e))
        .toList();
    return addProductsResponseModel;
  }
}
