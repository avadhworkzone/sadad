// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/refund/posRefundDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosRefundDetailRepo extends BaseService {
  Future<PosRefundDetailResponseModel> posRefundDetailRepo(
      {String? id,
      String? userId,
      required int start,
      required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posTransaction +
          '/$id?filter={"where":{"and":[{"or":[{"senderId": $userId},{"receiverId":$userId}]}, {"transactionentityId": { "eq": [17] }},{"transactionstatusId":{"inq":[1,2,3,6]}}]},"skip": $start,"limit": 10,"order": "created DESC","include": [{"relation":"senderId"},{"relation":"receiverId"},{"relation":"guestuser"},{"relation":"transactionentity"},{"relation":"transactionmode"},{"relation":"transactionstatus"},{"relation":"dispute"},{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}]}',
      body: {},
    );
    log("refund list res :${jsonEncode(response)}");
    final posRefundDetailResponseModel =
        PosRefundDetailResponseModel.fromJson(response as Map<String, dynamic>);
    return posRefundDetailResponseModel;
  }
}
