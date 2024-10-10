import 'dart:developer';
import 'dart:io';

import '../apimodels/responseModel/uploadImageResponseModel.dart';
import '../services/api_service.dart';
import '../services/base_service.dart';

class UploadImageRepo extends BaseService {
  Future<UploadImageResponseModel> uploadImageRepo({required File file}) async {
    // var body = {'file': await MultipartFile.fromFile(image.path, filename: fileName};

    final response =
        await ApiService().uploadImage(url: uploadImageUrl, file: file);
    // apiType: APIType.aPost,
    // url: uploadProfileURL,
    // body: body,
    // fileUpload: true);
    log("uploadImage res... :${response}");
    UploadImageResponseModel uploadImageResponseModel =
        UploadImageResponseModel.fromJson(response);
    return uploadImageResponseModel;
  }
}
