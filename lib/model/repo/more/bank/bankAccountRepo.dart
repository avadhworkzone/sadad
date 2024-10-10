import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/IdentityDocumentProofingModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/uploadImageResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/view/auth/loginscreen.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';

import '../../../apimodels/responseModel/more/addBankAccountModel.dart';

class BankAccountRepo extends BaseService {
  var accountList = [];
  Rx<AddBankAccountModel> addBankAccountModel = AddBankAccountModel().obs;
  Rx<AddSetAsDefaultViewModel> addSetAsDefault = AddSetAsDefaultViewModel().obs;

  Future<List> getBankAccountDetail() async {
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');
    final url = Uri.parse(baseURL +
        getBankDetail +
        "[userId]=$id&filter[include][0]=bank&filter[include][1]=userbankstatus");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.get(url, headers: header);
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      accountList = json.decode(result.body);
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
    return accountList;
  }

  Future<AddBankAccountModel> addBankAccount(
      {required String ibanNumber,
      required String authorizationdetails,
      int? bankId,
      bool? primary,required String accountName}) async {
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');
    final url = Uri.parse(baseURL + addBankAccountDetail);
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> body = {
      "ibannumber": ibanNumber,
      "authorizationdetails": authorizationdetails,
      "createdby": id,
      "modifiedby": id,
      "userId": id,
      "userbankstatusId": 4,
      "bankId": bankId,
      "beneficiary_name":accountName,
      "primary": primary
    };
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok donesssss');
      addBankAccountModel.value =
          AddBankAccountModel.fromJson(json.decode(result.body));
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', jsonDecode(result.body)['error']['message']);
      addBankAccountModel.value.ibannumber =
          '${jsonDecode(result.body)['error']['message']}';
    }
    return addBankAccountModel.value;
  }

  Future<int> deleteBankAccount({required String id}) async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(baseURL + deleteAccount + id);
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    var result = await http.delete(url, headers: header);
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      return result.statusCode;
    } else if (result.statusCode == 401) {
      funcSessionExpire();
      return result.statusCode;
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
      return result.statusCode;
    }
  }

  Future<UploadImageResponseModel> uploadBusinessDocImageRepo(
      {required File file}) async {
    UploadImageResponseModel uploadImageResponseModel =
        UploadImageResponseModel();

    try {
      dio.Dio _dio = dio.Dio();

      String token = await encryptedSharedPreferences.getString('token');
      String fileName = file.path.split('/').last;
      log("FILE NAME $fileName");
      log("FILE NAME PATH ${file.path}");
      dio.FormData formData = dio.FormData();
      if (fileName.contains('pdf')) {
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(
              'application',
              'pdf',
            ),
          ),
        });
      } else {
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(
              "image",
              'jpg',
            ),
          ),
        });
      }
      log("URL ${baseURL + 'containers/api-business/upload'}");
      log("token $token");

      var response = await _dio.post(baseURL + 'containers/api-business/upload',
          data: formData,
          options: dio.Options(
            headers: {"Authorization": token},
          ));
      if (response.statusCode! < 299 || response.statusCode == 200) {
        print('ok done');
        print("uploadImage res... :$response");

        uploadImageResponseModel =
            UploadImageResponseModel.fromJson(response.data);
        return uploadImageResponseModel;
      } else {
        return uploadImageResponseModel;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
        return uploadImageResponseModel;
      } else {
        print(e.message);
        Get.snackbar(
            'error', '${jsonDecode(e.response?.data)['error']['message']}');
        return uploadImageResponseModel;
      }
    }
  }

  Future<Map?> uploadBusinessDocImageNewRepo(
      {required File file}) async {

    try {
      dio.Dio _dio = dio.Dio();

      String token = await encryptedSharedPreferences.getString('token');

      String fileName = file.path.split('/').last;
      log("FILE NAME $fileName");
      log("FILE NAME PATH ${file.path}");
      dio.FormData formData = dio.FormData();
      if (fileName.contains('pdf')) {
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(
              'application',
              'pdf',
            ),
          ),
        });
      } else {
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(
              "image",
              'jpg',
            ),
          ),
        });
      }
      log("URL ${baseURL + 'containers/api-business/upload'}");
      log("token $token");

      var response = await _dio.post(baseURL + 'containers/api-business/upload',
          data: formData,
          options: dio.Options(
            headers: {"Authorization": token},
          ));
      if (response.statusCode! < 299 || response.statusCode == 200) {
        print("uploadImage res... :$response");
        log("ocr of image ${response.data}");
        return response.data;
      } else {
        print("error code${response.statusCode}");
        return null;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print("e.messge${e.message}");
        Get.snackbar(
            'error', '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }


  Future<Map?> verifyBusinessDocImageRepo({required File file, required String typeId}) async {
    try {
      dio.Dio _dio = dio.Dio();

      String token = await encryptedSharedPreferences.getString('token');

      String fileName = file.path.split('/').last;
      log("FILE NAME $fileName");
      log("FILE NAME PATH ${file.path}");
      dio.FormData formData = dio.FormData();
      if (fileName.contains('pdf')) {
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(
              'application',
              'pdf',
            ),
          ),
        });
      } else {
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(
              "image",
              'jpg',
            ),
          ),
        });
      }
      log("URL containers/fetchImageConfidence");
      log("token $token");

      var response = await _dio.post(
          baseURLOCR + "containers/fetchImageConfidence/",
          data: formData,
          options: dio.Options(
            headers: {
              "Authorization":
                  "LSlQTPhNuWihitj47WrMnYZ68mt1TMW3xiprg4YyeEiUAOnXEGM1oB1aEKMb1m3N7hUZrf8Ay061LT0w"
            },
          ));
      if (response.statusCode! < 299 || response.statusCode == 200) {
        print('ok done');
        print("uploadImage res... :$response");
        log("confidence of image ${response.data}");
        return response.data;
      } else {
        print("error code${response.statusCode}");
        return null;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print("e.messge${e.message}");
        Get.snackbar(
            'error', '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }

  Future<Map?> fetchDocOcrData({required File file,required String typeId}) async {
    try {
      dio.Dio _dio = dio.Dio();

      String token = await encryptedSharedPreferences.getString('token');
      String fileName = file.path.split('/').last;
      String? mimeType = mime(fileName);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      print("MimeType ${mimeType}");
      log("FILE NAME $fileName");
      log("FILE NAME PATH ${file.path}");
      dio.FormData formData = dio.FormData();
      if (fileName.contains('pdf')) {
        print("pdf");
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(mimee, type),
          ),
        });
      } else {
        print("jpg");
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(mimee, type),
          ),
        });
      }
      log("token $token");
      log("URL containers/fetchDocumentOcr");

      var response = await _dio.post(
          baseURLOCR + "containers/fetchDocumentOcr/",
          data: formData,
          options: dio.Options(
            headers: {
              "Authorization":
                  "LSlQTPhNuWihitj47WrMnYZ68mt1TMW3xiprg4YyeEiUAOnXEGM1oB1aEKMb1m3N7hUZrf8Ay061LT0w",
              "type": typeId
            },
          ));
      print('ok done');
      if (response.statusCode! < 299 || response.statusCode == 200) {
        print("uploadImage res... :$response");
        log("ocr of image ${response.data}");
        return response.data;
      } else {
        print("error code${response.statusCode}");
        return null;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print("e.messge${e.message}");
        Get.snackbar(
            'error', '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }

  Future<Map?> identityDocumentProofing({required File file,required String typeId}) async {
    try {
      dio.Dio _dio = dio.Dio();

      String token = await encryptedSharedPreferences.getString('token');

      String fileName = file.path.split('/').last;
      String? mimeType = mime(fileName);
      String mimee = mimeType!.split('/')[0];
      String type = mimeType.split('/')[1];
      print("MimeType ${mimeType}");
      log("FILE NAME $fileName");
      log("FILE NAME PATH ${file.path}");
      dio.FormData formData = dio.FormData();
      if (fileName.contains('pdf')) {
        print("pdf");
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(mimee, type),
          ),
        });
      } else {
        print("jpg");
        formData = dio.FormData.fromMap({
          "file": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(mimee, type),
          ),
        });
      }
      log("token $token");
      log("URL containers/identityDocumentProofing/");

      var response = await _dio.post(
          baseURLOCR + "containers/identityDocumentProofing/",
          data: formData,
          options: dio.Options(
            headers: {
              "Authorization":
                  "LSlQTPhNuWihitj47WrMnYZ68mt1TMW3xiprg4YyeEiUAOnXEGM1oB1aEKMb1m3N7hUZrf8Ay061LT0w",
              "type": typeId
            },
          ));
      print('ok done');
      if (response.statusCode! < 299 || response.statusCode == 200) {
        log("identityDocumentProofing ${response.data}");
        return response.data;
        // List<IdentityDocumentProofing> identityDocumentProofing = identityDocumentProofingFromJson(response.data.toString());
        // return identityDocumentProofing;
      } else {
        print("error code${response.statusCode}");
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print("e.messge${e.message}");
        Get.snackbar(
            'error', '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }

  Future<UploadImageResponseModel> uploadBankDocImageRepo(
      {required File file}) async {
    UploadImageResponseModel uploadImageResponseModel =
        UploadImageResponseModel();

    try {
      dio.Dio _dio = dio.Dio();

      String token = await encryptedSharedPreferences.getString('token');

      String fileName = file.path.split('/').last;
      log("FILE NAME $fileName");
      log("FILE NAME PATH ${file.path}");
      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType("image", 'jpg'),
        ),
      });

      log("URL ${baseURL + 'containers/api-bank/upload'}");
      log("token $token");

      var response = await _dio.post(baseURL + 'containers/api-business/upload',
          data: formData,
          options: dio.Options(
            headers: {"Authorization": token},
          ));
      if (response.statusCode! < 299 || response.statusCode == 200) {
        print('ok done');
        print("uploadImage res... :$response");

        uploadImageResponseModel =
            UploadImageResponseModel.fromJson(response.data);
        return uploadImageResponseModel;
      } else {
        return uploadImageResponseModel;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
        return uploadImageResponseModel;
      } else {
        print(e.message);
        Get.snackbar(
            'error', '${jsonDecode(e.response?.data)['error']['message']}');
        return uploadImageResponseModel;
      }
    }
  }

  Future<UploadImageResponseModel> uploadBankingDocImageRepo(
      {required File file}) async {
    UploadImageResponseModel uploadImageResponseModel =
        UploadImageResponseModel();

    try {
      dio.Dio _dio = dio.Dio();

      String token = await encryptedSharedPreferences.getString('token');

      String fileName = file.path.split('/').last;
      log("FILE NAME $fileName");
      log("FILE NAME PATH ${file.path}");
      dio.FormData formData = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType("image", 'jpg'),
        ),
      });

      log("URL ${baseURL + uploadBankDocument}");
      log("token $token");

      var response = await _dio.post(baseURL + uploadBankDocument,
          data: formData,
          options: dio.Options(
            headers: {"Authorization": token},
          ));
      if (response.statusCode! < 299 || response.statusCode == 200) {
        print('ok done');
        print("uploadImage res... :$response");

        uploadImageResponseModel =
            UploadImageResponseModel.fromJson(response.data);
        return uploadImageResponseModel;
      } else {
        return uploadImageResponseModel;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
        return uploadImageResponseModel;
      } else {
        print(e.message);
        Get.snackbar(
            'error', '${jsonDecode(e.response?.data)['error']['message']}');
        return uploadImageResponseModel;
      }
    }
  }

  Future<List> getBank() async {
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');
    final url = Uri.parse(baseURL + getBanks);
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.get(url, headers: header);
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      accountList = json.decode(result.body);
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
    return accountList;
  }

  Future<bool> updateSetAsDefault(bool isPrimary, {required String id}) async {
    String token = await encryptedSharedPreferences.getString('token');

    final url = Uri.parse(baseURL + "userbanks/" + id);
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var body = {
      "primary": isPrimary,
    };

    print(url);
    var result =
        await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("Resp :-  $data");
      return true;
    } else if (result.statusCode == 401) {
      funcSessionExpire();
      return false;
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
      return false;
    }
  }
}
