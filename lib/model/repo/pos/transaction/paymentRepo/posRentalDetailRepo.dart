// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/refund/posRefundDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosRentalDetailRepo extends BaseService {
  Future<PosRentalDetailResponseModel> posRentalDetailRepo(
      {String? id, required int start, required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posRental +
          '?filter[skip]=$start&filter[limit]=10&filter[order]=created DESC&filter[where][id]=$id',
      body: {},
    );
    log("rental res :$response");
    final posRentalDetailResponseModel =
        PosRentalDetailResponseModel.fromJson(response as Map<String, dynamic>);
    return posRentalDetailResponseModel;
  }
}

class ActivityPosRentalDetailRepo extends BaseService {
  Future<PosRentalDetailResponseModel> activityPosRentalDetailRepo(
      {String? id, required int start, required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posRental +
          // '?filter[skip]=$start&filter[limit]=$end&filter[order]=created DESC&filter[where][id]=$id',
          '?filter[skip]=$start&filter[limit]=$end&filter[where][invoiceno]=$id',
      body: {},
    );
    log("rental res :$response");
    final posRentalDetailResponseModel =
        PosRentalDetailResponseModel.fromJson(response as Map<String, dynamic>);
    return posRentalDetailResponseModel;
  }
}
