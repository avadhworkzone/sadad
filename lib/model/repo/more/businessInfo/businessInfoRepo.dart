import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/pdfviewerController.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessmodel.dart';

class BusinessInfoRepo extends BaseService {
  Rx<BusinessInfoResponseModel> businessInfoModel =
      BusinessInfoResponseModel().obs;
  PdfViewerModel pdfViewerModel = Get.put(PdfViewerModel());
  final cnt = Get.find<BankAccountViewModel>();

  Future<BusinessInfoResponseModel> getBusinessInformation() async {
    BusinessInfoResponseModel businessInfoResponseModel =
        BusinessInfoResponseModel();
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');
    print("user =>>>>>>>>> $id");
    final url = Uri.parse(baseURL +
        getBusinessInfo +
        "[userId]=$id&filter[include][0]=businessmedia&filter[include][1]=userbusinessstatus&filter[include][2][user][0]=role&filter[include][2][user][0]=usermetapersonals");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.get(url, headers: header);
    print('header$header');
    print("Api businessinfo response body ${result.body}");
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      List data = json.decode(result.body);
      print("result.body ${result.body}");
      if (data.isNotEmpty) {
        print("object");
        businessInfoResponseModel = BusinessInfoResponseModel.fromJson(data[0]);
        pdfViewerModel.pdfView =
            businessInfoResponseModel.user!.usermetapersonals!.agreementdoc ?? '';
        await encryptedSharedPreferences.setString(
            'Pdf', "${Constants.agreementContainer}${pdfViewerModel.pdfView}");
        businessInfoResponseModel = BusinessInfoResponseModel.fromJson(data[0]);
        pdfViewerModel.pdfView =
            businessInfoResponseModel.user!.usermetapersonals!.agreementdoc ?? '';
      } else {
        return businessInfoResponseModel;
      }
      log('business model=======>>>>>${businessInfoResponseModel.toJson()}');

      await encryptedSharedPreferences.setString(
          'userbusinessId', "${businessInfoResponseModel.id}");
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
    return businessInfoResponseModel;
  }

  Future<List<String>> getPOSandActiveUser() async {
    List<String>? posActiveUser = [];
    String token = await encryptedSharedPreferences.getString('token');
    // String id = await encryptedSharedPreferences.getString('id');
    final url = Uri.parse(baseURL + myAccountCounters);
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.get(url, headers: header);
    print('header$header');
    print("Api response getPOSandActiveUser ${result.body}");
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode >= 200) {
      print('ok done');
      var data = json.decode(result.body);

      posActiveUser = [data["users"].toString(), data["pos"].toString()];
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
    return posActiveUser;
  }

  Future<void> updateBusinessInfoM(
      {required BusinessDataModel businessData,
      String? type,
      businessMedia}) async {
    String token = await encryptedSharedPreferences.getString('token');
    // String id = await encryptedSharedPreferences.getString('id');
    String userBusinessId =
        await encryptedSharedPreferences.getString('userbusinessId');
    final url = Uri.parse(baseURL + updateBusinessInfo + "$userBusinessId");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    // String userBusinessId =
    // await encryptedSharedPreferences.getString('userbusinessId');

    var body = getBody(
        type: type,
        businessData: businessData,
        businessMedia: businessMedia,
        userBusinessId: userBusinessId);
    print("body =======>>>  $body");

    var result =
        await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data ========>>>>>>$data");

      Get.back(result: true);
      Get.back(result: true);
      // if (type == "Document") {
      //   Get.back(result: true);
      // }
      Get.showSnackbar(GetSnackBar(
        message: 'Update Successfully',
        duration: Duration(seconds: 1),
      ));
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }
  Map<String, int> someMap = {
    "a": 1,
    "b": 2,
  };
  Future<void> updateBusinessInfoNew(Map<String, dynamic>? body) async {
    String token = await encryptedSharedPreferences.getString('token');
    // String id = await encryptedSharedPreferences.getString('id');
    String userBusinessId =
    await encryptedSharedPreferences.getString('userbusinessId');
    final url = Uri.parse(baseURL + updateBusinessInfo + "$userBusinessId");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print("body =======>>>  $body");

    var result =
    await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data ========>>>>>>$data");

      Get.back(result: true);
      Get.back(result: true);
      // if (type == "Document") {
      //   Get.back(result: true);
      // }

      if(body!.containsKey("newCellnumber") || body.containsKey("changedemail")) {
        Get.showSnackbar(GetSnackBar(
          message: 'Please login with your updated details.'.tr,
          duration: Duration(seconds: 5),
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          message: 'Update Successfully'.tr,
          duration: Duration(seconds: 1),
        ));
      }

    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }
  Map<dynamic, dynamic> getBody(
      {String? type,
      BusinessDataModel? businessData,
      Businessmedia? businessMedia,
      String? userBusinessId}) {
    // print("===${businessMedia!.businessmediatypeId}");

    print("===$userBusinessId");
    print("===$cnt.uploadedUrl");
    switch (type) {
      case "Business name":
        return {
          "businessname": businessData!.businessName!,
          "otp": businessData.otp!,
          "userbusinessstatusId": 4,
          "basicdetailsstatusId":4,
        };

      case "Business Registration Number":
        return {
          "merchantregisterationnumber":
              businessData!.merchantRegisTeRationNumber!,
          "otp": businessData.otp!,
          "userbusinessstatusId": 4,
          "basicdetailsstatusId":4,
        };
      case "Email ID":
        return {
          "changedemail": businessData!.email!,
          "otp": businessData.otp!,
          "userbusinessstatusId": 4,
          "basicdetailsstatusId":4,
        };
      case "Address":
        return {
          "buildingnumber": businessData!.buildingNumber!,
          "streetnumber": businessData.streetNumber!,
          "zonenumber": businessData.zoneNumber!,
          "otp": businessData.otp!,
          "userbusinessstatusId": 4,
          "basicdetailsstatusId":4,
        };
      case "Mobile number":
        return {
          "newCellnumber": businessData!.mobileNumber,
          "otp": businessData.otp!,
          "userbusinessstatusId": 4,
          "basicdetailsstatusId":4,
        };

      case "Document":
        return {
          "businessmedia": [
            {
              "userbusinessId": userBusinessId,
              "name": cnt.uploadedUrl.value,
              "businessmediatypeId": businessMedia!.businessmediatypeId,
            }
          ],
          "otp": businessData!.otp!,
          "userbusinessstatusId": 4
        };

      default:
        return {
          "businessname": businessData!.businessName!,
          "otp": businessData.otp!,
        };
    }
  }

  Future<int> storeBusinessDetail(
      {required String businessName,
      required String businessReGiSteRationNumber,
      required String buildingNumber,
      required String streetNumber,
      required String zoneNumber,
      required String userId,required Map<String, Map<String, dynamic>> businessDoc,
      required String img}) async {
    String token = await encryptedSharedPreferences.getString('token');
    String userBusinessId =
    await encryptedSharedPreferences.getString('userbusinessId');
    final url = Uri.parse(baseURL + storeUserBusinessDetail + '/' + userBusinessId);

    log("URl i :- $url");
    // "userbusinessId": userBusinessId,
    // "name": widget.docData[element]!['url'][i],
    // "businessmediatypeId": int.parse(element),
    // "doc_expiry": widget.docData[element]!['date'],
    // "metadata": widget.docData[element]!['metadata'][i],
    // "unique_id": widget.docData[element]!['unique_id'],
    List list = [];
    businessDoc.keys.forEach((element) {
      for (int i = 0; i < businessDoc[element]!['url'].length; i++) {
        String tempElement = element;
        if(int.parse(element) > 9) {
          tempElement = "4";
        }
        if(tempElement == '6') {
          list.add({
            "userbusinessId": userBusinessId,
            "name": businessDoc[element]!['url'][i],
            "metadata": businessDoc[element]!['metadata'][i],
            "unique_id": businessDoc[element]!['unique_id'],
            "businessmediastatusId": 4,
          });
        } else {
          list.add({
            "userbusinessId": userBusinessId,
            "name": businessDoc[element]!['url'][i],
            "businessmediatypeId": int.parse(tempElement),
            "doc_expiry": businessDoc[element]!['date'],
            "metadata": businessDoc[element]!['metadata'][i],
            "unique_id": businessDoc[element]!['unique_id'],
            "businessmediastatusId": 4,
          });
        }
      }
    });
    // businessDoc.keys.forEach((element) {
    //   if(businessDoc[element]!['name'] != '' || businessDoc[element]!['doc_expiry'] != '') {
    //     list.add({
    //       "name": businessDoc[element]!['name'],
    //       "businessmediatypeId": int.parse(businessDoc[element]!['businessmediatypeId']),
    //       "doc_expiry": dateformatLocal(businessDoc[element]!['doc_expiry']),
    //       "unique_id"
    //     });
    //   }
    // });

    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> body = {
      "businessname": businessName,
      "merchantregisterationnumber": businessReGiSteRationNumber,
      "buildingnumber": buildingNumber,
      "streetnumber": streetNumber,
      "zonenumber": zoneNumber,
      "businessmedia": list,
      "userbusinessstatusId":4,
      "basicdetailsstatusId":4,
    };
    print('request body :- $body');

    var result = await http.patch(url, headers: header, body: jsonEncode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    Get.back();
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data======>$data");
      return 1;
    } else if (result.statusCode == 401) {
      funcSessionExpire();
      return 2;
      //return false;
    } else {
      Get.snackbar('error', jsonDecode(result.body)['error']['message']);
      return 3;
      // addBankAccountModel.value.ibannumber =
      //     '${jsonDecode(result.body)['error']['message']}';
    }
  }
  String dateformatLocal(String? date) {
    if (date == null || date == '') {
      return '';
    } else {
      // DateTime datetime = DateTime.parse(date);
      // DateFormat tempDate = DateFormat("yyyy-mm-dd HH:MM:ss");
      // String newdate = tempDate.format(datetime);
      // return newdate;

      date = date;
      DateTime parseDate =
      new DateFormat("dd/MM/yyyy").parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    }
  }
}
