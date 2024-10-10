// ignore_for_file: prefer_interpolation_to_compose_strings

import '../../../apimodels/responseModel/productScreen/order/orderListResponseModel.dart';
import '../../../apimodels/responseModel/productScreen/reports/orderReportResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class OrderListRepo extends BaseService {
  Future<List<OrderListResponseModel>> orderListRepo(String id, String date,
      {required int start, required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: order +
          '?filter[where][vendorId]=$id&filter[include][0]=transaction$date&filter[include][1]=customerId&filter[include][2]=orderstatus&filter[skip]=$start&filter[limit]=10',
    );

    ///%20 or +
    print("OrderList res :$response");
    final orderListResponseModel = (response as List<dynamic>)
        .map((e) => OrderListResponseModel.fromJson(e))
        .toList();
    return orderListResponseModel;
  }

  Future<OrderReportResponseModel> orderReportListRepo(String id, String date,
      {required int start, required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: orderReport + '?$id$date&filter[skip]=$start&filter[limit]=$end',
      body: {},
    );
    print("OrderList res :$response");
    OrderReportResponseModel orderReportResponseModel =
        OrderReportResponseModel.fromJson(response);
    return orderReportResponseModel;
  }
}
