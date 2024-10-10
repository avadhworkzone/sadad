import 'dart:convert';

import 'package:sadad_merchat_app/model/apimodels/requestmodel/Auth/loginRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/errorResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

import '../../apimodels/responseModel/Auth /loginResponseModel.dart';

class LoginRepo extends BaseService {
  Future<dynamic> loginRepo(LoginRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    print('LoginRequestModel Req :${jsonEncode(model)}');
    var response = await ApiService().getResponse(
      apiType: APIType.aPost,
      url: login,
      body: body,
    );

    print('login Login Data :::$response');
    // print('response type:${response.runtimeType}');
    if ((response as Map<String, dynamic>).containsKey('error')) {
      final result = ErrorResponseModel.fromJson(response);
      return result;
    }
    LoginResponseModel loginResponseModel =
        LoginResponseModel.fromJson(response);
    return loginResponseModel;
  }
}
