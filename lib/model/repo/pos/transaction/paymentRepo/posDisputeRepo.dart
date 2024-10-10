// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosDisputesDetailRepo extends BaseService {
  Future<List<PosDisputesDetailResponseModel>> posDisputesDetailRepo(
      {String? id,
      String? userId,
      required int start,
      required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: disputes +
          '?filter={"where":{"and":[{"or":[{"senderId": $userId},{"receiverId":$userId}]},{"isPOS":true},{"id":$id}]},"skip":"$start","limit":"10","order":"created DESC","include":["senderId","receiverId","transaction"],"include":[{"relation":"disputestatus","fields":["name"]},{"relation":"disputetype","fields":["name"]},{"relation":"senderId"},{"relation":"receiverId"},{"relation":"transaction","scope":{"include":{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}}}]}',
      body: {},
    );
    print("disputes res :$response");
    final posDisputesDetailResponseModel = (response as List<dynamic>)
        .map((e) => PosDisputesDetailResponseModel.fromJson(e))
        .toList();
    return posDisputesDetailResponseModel;
  }
}
