import 'dart:convert';

import '../../../apimodels/requestmodel/dashboard/product/editProductRequestModel.dart';
import '../../../apimodels/responseModel/productScreen/product/editProductResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class EditProductRepo extends BaseService {
  Future<EditProductResponseModel> editProduct(
      String id, EditProductRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    print('EditProduct Req :${jsonEncode(model)}');
    var response = await ApiService().getResponse(
      apiType: APIType.aPatch,
      url: productList + id,
      body: body,
    );
    print('EditProductData :::$response');
    EditProductResponseModel editProductRes =
        EditProductResponseModel.fromJson(response);
    return editProductRes;
  }
}
