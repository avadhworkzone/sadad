import '../../../apimodels/responseModel/productScreen/order/orderCountResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class OrderRepo extends BaseService {
  ///order Count
  Future<OrderCountResponseModel> orderCountRepo(String id, String date) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: order + '/counts?where[vendorId]=$id$date',
      body: {},
    );
    print("orderCount res :$response");
    final orderCountResponseModel =
        OrderCountResponseModel.fromJson(response as Map<String, dynamic>);
    return orderCountResponseModel;
  }
}
