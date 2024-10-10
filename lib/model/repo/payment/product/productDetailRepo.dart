// ignore_for_file: prefer_interpolation_to_compose_strings

import '../../../apimodels/responseModel/productScreen/product/productDetailResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class ProductDetailRepo extends BaseService {
  Future<ProductDetailResponseModel> productDetailRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: productList + '/$id?filter[include]=productmedia',
      body: {},
    );
    print("ProductDetail res :$response");
    final productDetailResponseModel =
        ProductDetailResponseModel.fromJson(response as Map<String, dynamic>);
    return productDetailResponseModel;
  }
}
