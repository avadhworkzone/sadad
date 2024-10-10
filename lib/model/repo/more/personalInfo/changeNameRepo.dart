import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/view/auth/loginscreen.dart';

import '../../../../viewModel/more/businessInfo/businessmodel.dart';

class ChangeNameRepo extends BaseService {
  Future<void> changeUserName( BusinessDataModel? businessData) async {
    String token = await encryptedSharedPreferences.getString('token');

    final url = Uri.parse(baseURL + changeName + "301");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    Map<String, dynamic> body = {
      "businessname": businessData!.businessName!,
      "otp": businessData.otp!
    };

    var result = await http.patch(url, headers: header, body: jsonEncode(body));
    print('req is $body');
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    }else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
      log("OffAll Login screen",name: "Login Screen");
    }

  }
}
