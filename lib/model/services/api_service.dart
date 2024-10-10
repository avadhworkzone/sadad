import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';

import '../apis/api_exception.dart';
import 'base_service.dart';
import 'package:http_parser/http_parser.dart';

enum APIType { aPost, aGet, aDelete, aPatch }

class ApiService extends BaseService {
  dio.Dio _dio = dio.Dio();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  Map<String, String>? header;

  Future uploadImage({required File file, required String url}) async {
    var response;
    try {
      String token = await encryptedSharedPreferences.getString('token');

      String fileName = file.path.split('/').last;
      log("FILE NAME $fileName");
      log("FILE NAME PATH ${file.path}");
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType("image", 'jpg'),
        ),
      });

      log("URL ${baseURL + url}");
      log("token $token");

      response = await _dio.post(baseURL + url,
          data: formData,
          options: dio.Options(
            headers: {"Authorization": token},
          ));
      // response = returnResponse(response.statusCode!, jsonEncode(response.data));

      return response;
    } on DioError catch (e) {
      return e;
    }
  }

  Future<dynamic> getResponse(
      {@required APIType? apiType,
      @required String? url,
      Map<String, dynamic>? body,
      bool fileUpload = false}) async {
    var response;

    String token = await encryptedSharedPreferences.getString('token');
    print("token === $token");
    if (token == '') {
      header = {'Content-Type': 'application/json'};
    } else {
      header = {'Authorization': token, 'Content-Type': 'application/json'};
    }
    // pA6LunT9QJEC77RcC5IrApTK4dbacDHNykEoXeQYqtmf1uvP1gDixyfs0KNF7FmV
    // pA6LunT9QJEC77RcC5IrApTK4dbacDHNykEoXeQYqtmf1uvP1gDixyfs0KNF7FmV
    log('header is $header    &&& type:::$apiType');
    log('queryParameters ${Uri.parse(baseURL + url!).queryParametersAll}');
    // log('REQ :${jsonEncode(body)}');
    try {
      String mainUrl = baseURL + url!;
      log("URL ---> ${baseURL + url}");
      if (apiType == APIType.aGet) {
        var result = await http.get(
          Uri.parse(baseURL + url),
          headers: header,
        );

        if (result.statusCode == 499) {
          getx.Get.to(() => const UnderMaintenanceScreen());
        } else {
          response = returnResponse(
            result.statusCode,
            result.body,
          );
        }
      } else if (fileUpload) {
        dio.FormData formData = dio.FormData.fromMap(body!);
        dio.Response result = await dio.Dio().post(baseURL + url,
            data: formData, options: dio.Options(contentType: "form-data"));
        print('responseType+>${result.data.runtimeType}');
        if (result.statusCode == 499) {
          getx.Get.to(() => const UnderMaintenanceScreen());
        } else {
          response = returnResponse(
            result.statusCode!,
            result.data,
          );
        }
        // response = returnResponse(result.statusCode!, result.data);
      } else if (apiType == APIType.aDelete) {
        var result = await http.delete(
          Uri.parse(baseURL + url),
          headers: header,
        );
        // response = returnResponse(
        //   result.statusCode,
        //   result.body,
        // );
        if (result.statusCode == 499) {
          getx.Get.to(() => const UnderMaintenanceScreen());
        } else {
          response = returnResponse(
            result.statusCode,
            result.body,
          );
        }
      } else if (apiType == APIType.aPatch) {
        var result = await http.patch(
          Uri.parse(baseURL + url),
          headers: header,
          body: jsonEncode(body),
        );
        // response = returnResponse(
        //   result.statusCode,
        //   result.body,
        // );
        if (result.statusCode == 499) {
          getx.Get.to(() => const UnderMaintenanceScreen());
        } else {
          response = returnResponse(
            result.statusCode,
            result.body,
          );
        }
      } else {
        var result = await http.post(
          Uri.parse(mainUrl),
          headers: header,
          body: jsonEncode(body),
        );
        if (result.statusCode == 499) {
          getx.Get.to(() => const UnderMaintenanceScreen());
        } else {
          response = returnResponse(
            result.statusCode,
            result.body,
          );
        }
        // response = returnResponse(result.statusCode, result.body);
      }
      return response;
    } catch (e) {
      log('Error=>.. $e');
    }
  }

  returnResponse(int status, String result) {
    print("status---$status");
    // var data = jsonEncode(result);
    switch (status) {
      case 200:
        return jsonDecode(result);
      case 256:
        return jsonDecode(result);
      case 204:
        return jsonDecode(result);
      case 400:
        throw BadRequestException('Bad Request');
      // throw jsonDecode(result);
      case 401:
        throw UnauthorisedException('Unauthorised user');
      // return jsonDecode(result);
      case 404:
        throw ServerException('Server Error');
      case 499:
        throw UnderServerException('Server UnderMaintenance');

      // return jsonDecode(result);
      case 500:
        throw FetchDataException('Internal Server Error');
      default:
        // return jsonDecode(result);
        throw FetchDataException('Internal Server Error');
    }
  }
}
