import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/model/services/base_service.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/view/splash.dart';

class ChangePasswordRepo extends BaseService {
  Future<void> changePass(
      {required String password, required String currentPassword}) async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(baseURL + changePassword);
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    Map<String, dynamic> body = {
      "oldPassword": currentPassword,
      "newPassword": password
    };
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    print('req is $body');
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      Get.showSnackbar(GetSnackBar(
        message: 'Password changed successfully',
        duration: Duration(seconds: 1),
      ));

      // encryptedSharedPreferences.clear();
      Future.delayed(Duration(seconds: 0), () {
        Get.offAll(() => SplashScreen());
      });
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
      log("OffAll Login screen", name: "Login Screen");
    }
  }
}
