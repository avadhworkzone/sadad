import 'dart:convert';

import '../../../apimodels/requestmodel/dashboard/product/createProductRequestModel.dart';
import '../../../apimodels/responseModel/productScreen/product/createProductResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class CreateProductRepo extends BaseService {
  Future<CreateProductResponseModel> createProduct(
      CreateProductRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    print('CreateProduct Req :${jsonEncode(model)}');
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: productList,
      body: body,
    );
    print('CreateProductData :::$response');
    CreateProductResponseModel createProductRes =
        CreateProductResponseModel.fromJson(response);
    return createProductRes;
  }
}
