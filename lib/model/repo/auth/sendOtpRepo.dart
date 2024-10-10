import 'dart:convert';

import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';
import '../../apimodels/requestmodel/Auth/sendOtpRequestModel.dart';
import '../../apimodels/requestmodel/Auth/verifyOtpRequestModel.dart';
import '../../apimodels/responseModel/Auth /sendOtpResponseModel.dart';
import '../../apimodels/responseModel/Auth /verifyOtpResponseModel.dart';

///send otp
class SendOtpRepo extends BaseService {
  Future<SendOtpResponseModel> sendOtpRepo(SendOtpRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    print('SendOtpRequestModel Req :${jsonEncode(model)}');
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: sendOtp,
      body: body,
    );
    print('sendOtp Data :::$response');
    SendOtpResponseModel sendOtpResponseModel =
        SendOtpResponseModel.fromJson(response);
    return sendOtpResponseModel;
  }
}

///verify otp
class VerifyOtpRepo extends BaseService {
  Future<VerifyOtpResponseModel> verifyOtpRepo(
      VerifyOtpRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    print('VerifyOtpRequestModel Req :${jsonEncode(model)}');
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: verifyOtp,
      body: body,
    );
    print('verifyOtp Data :::$response');
    VerifyOtpResponseModel verifyOtpResponseModel =
        VerifyOtpResponseModel.fromJson(response);
    return verifyOtpResponseModel;
  }
}
