// /3149?filter[include][0]=transaction&filter[include][1]=customerId&filter[include][2]=orderstatus

// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';

import '../../../apimodels/responseModel/productScreen/order/orderDetailResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class OrderDetailRepo extends BaseService {
  Future<OrderDetailResponseModel> orderDetailRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: order +
          '/$id?filter[include][0]=transaction&filter[include][1]=customerId&filter[include][2]=orderstatus',
      body: {},
    );
    log("orderDetail res :${jsonEncode(response)}");
    final orderDetailResponseModel =
        OrderDetailResponseModel.fromJson(response as Map<String, dynamic>);
    return orderDetailResponseModel;
  }
}
