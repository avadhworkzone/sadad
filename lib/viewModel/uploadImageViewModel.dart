import 'dart:io';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/uploadImageResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';

import '../model/repo/uploadImageRepoModel.dart';

class UploadImageViewModel extends GetxController {
  ApiResponse uploadImageApiResponse = ApiResponse.initial('Initial');

  /// UploadImage...
  Future<void> uploadImage(File file) async {
    uploadImageApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      UploadImageResponseModel response =
          await UploadImageRepo().uploadImageRepo(file: file);
      uploadImageApiResponse = ApiResponse.complete(response);
      print("uploadImageApiResponse RES:$response");
    } catch (e) {
      print('uploadImageApiResponse.....$e');
      uploadImageApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
