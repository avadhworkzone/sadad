// ignore_for_file: prefer_interpolation_to_compose_strings

import '../../../apimodels/responseModel/productScreen/product/myproductListResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class MyProductListRepo extends BaseService {
  Future<List<MyProductListResponseModel>> myProductListRepo(String id,
      {required int start, required int end, String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: productList +
          '?filter[where][merchantId]=$id&filter[include]=productmedia&filter[where][isRecurringProduct]=0${filter == null ? '' : filter}&filter[skip]=$start&filter[limit]=10',
      //'filter={"where":{"and":[{"merchantId":$id},{"isRecurringProduct":"0"}]},"skip": $start,"limit": 10,"order": ["created DESC"],"include":"productmedia"${filter == null ? '' : filter}}',
      //'?filter[where][merchantId]=$id&filter[include]=productmedia&filter[where][isRecurringProduct]=0${filter == null ? '' : filter}&filter[skip]=$start&filter[limit]=10',
      body: {},
    );
    print("productList res :$response");
    final myProductListResponseModel = (response as List<dynamic>)
        .map((e) => MyProductListResponseModel.fromJson(e))
        .toList();
    print("productList Repo Length == ${myProductListResponseModel.length}");
    return myProductListResponseModel;
  }
}
