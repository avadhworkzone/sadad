import 'dart:developer';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/createInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/createInvoiceRepo.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';

import '../../model/apimodels/requestmodel/Auth/loginRequestModel.dart';
import '../../model/apimodels/requestmodel/Auth/sendOtpRequestModel.dart';
import '../../model/apimodels/requestmodel/Auth/verifyOtpRequestModel.dart';
import '../../model/apimodels/responseModel/Auth /loginResponseModel.dart';
import '../../model/apimodels/responseModel/Auth /resendOtpResponseModel.dart';
import '../../model/apimodels/responseModel/Auth /sendOtpResponseModel.dart';
import '../../model/apimodels/responseModel/Auth /verifyOtpResponseModel.dart';
import '../../model/repo/auth/loginRepo.dart';
import '../../model/repo/auth/resendOtpRepo.dart';
import '../../model/repo/auth/sendOtpRepo.dart';

class LoginViewModel extends GetxController {
  ApiResponse loginApiResponse = ApiResponse.initial('Initial');
  ApiResponse sendOtpApiResponse = ApiResponse.initial('Initial');
  ApiResponse verifyOtpApiResponse = ApiResponse.initial('Initial');
  ApiResponse resendOtpApiResponse = ApiResponse.initial('Initial');

  /// Login...
  Future<void> login(LoginRequestModel model) async {
    loginApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      final response = await LoginRepo().loginRepo(model);
      loginApiResponse = ApiResponse.complete(response);
      log("loginApiResponse RES:$response");
    } catch (e) {
      log('loginApiResponse.....$e');
      loginApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// sendOtp...
  Future<void> sendOtp(SendOtpRequestModel model, {context}) async {
    sendOtpApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      SendOtpResponseModel response = await SendOtpRepo().sendOtpRepo(model);
      sendOtpApiResponse = ApiResponse.complete(response);
      log("sendOtpApiResponse RES:$response");
    } catch (e) {
      log('sendOtpApiResponse.....$e');
      sendOtpApiResponse = ApiResponse.error('error');
    }
    update();
  }

  /// verifyOtp...
  Future<void> verifyOtp(VerifyOtpRequestModel model) async {
    verifyOtpApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      VerifyOtpResponseModel response =
          await VerifyOtpRepo().verifyOtpRepo(model);
      verifyOtpApiResponse = ApiResponse.complete(response);
      log("verifyOtpApiResponse RES:$response");
    } catch (e) {
      log('verifyOtpApiResponse.....$e');
      verifyOtpApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///resendOtp
  Future<void> resendOtp() async {
    resendOtpApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      ResendOtpResponseModel response = await ResendOtpRepo().resendOtpRepo();
      resendOtpApiResponse = ApiResponse.complete(response);
      log("resendOtpApiResponse RES:$response");
    } catch (e) {
      log('resendOtpApiResponse.....$e');
      resendOtpApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
