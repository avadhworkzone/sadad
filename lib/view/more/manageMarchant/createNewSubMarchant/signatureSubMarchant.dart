// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/uploadImageResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/auth/register/pdfOfTermsAndCondition.dart';
import 'package:sadad_merchat_app/view/auth/register/setYourPassword.dart';
import 'package:sadad_merchat_app/view/dashboard/dashboardScreen.dart';
import 'package:sadad_merchat_app/view/home.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/uploadImageViewModel.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

import '../../../auth/register/TermsAndConditionRegister.dart';
import '../manageMerchantOTP.dart';

class SignatureSubMarchant extends StatefulWidget {

  Map<String, dynamic> body;
  String password;
  SignatureSubMarchant({Key? key,required this.body,required this.password}) : super(key: key);

  @override
  State<SignatureSubMarchant> createState() => _SignatureSubMarchantState();
}

class _SignatureSubMarchantState extends State<SignatureSubMarchant> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  UploadImageViewModel uploadImageViewModel = Get.find();
  bool isTermsCondition = false;
  bool isSignature = false;
  ConnectivityViewModel connectivityViewModel = Get.find();
  HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: InkWell(
                  onTap: () {
                    if (isTermsCondition == false) {
                      Get.snackbar(
                          'Error', 'Please Agree on Terms & Conditions');
                    } else {
                      connectivityViewModel.startMonitoring();

                      if (connectivityViewModel.isOnline != null) {
                        if (connectivityViewModel.isOnline!) {
                          _handleSaveButtonPressed();
                        } else {
                          Get.snackbar(
                              'error', 'please check internet connectivity');
                        }
                      } else {
                        Get.snackbar(
                            'error', 'please check internet connectivity');
                      }
                    }
                  },
                  child: buildContainerWithoutImage(
                      color: ColorsUtils.accent, text: 'Finish'.tr)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height40(),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios)),
                height40(),

                customMediumLargeBoldText(title: 'E-Signature'.tr),
                height10(),

                customSmallMedSemiText(
                  title: 'Please, Provide your E-Signature in below box'.tr,
                ),

                height30(),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    children: [
                      SfSignaturePad(
                          key: signatureGlobalKey,
                          backgroundColor: Colors.white,
                          strokeColor: Colors.black,
                          onDraw: (offset, time) {
                            print(offset);
                            if (offset == 0) {
                              isSignature = false;
                              print(offset == 0);
                              print('sing $isSignature');
                            } else {
                              isSignature = true;
                              print(offset == 0);
                              print('sing $isSignature');
                            }
                          },
                          minimumStrokeWidth: 1.0,
                          maximumStrokeWidth: 4.0),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            isSignature = false;
                            print('sing $isSignature');

                            _handleClearButtonPressed();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                size: 30,
                              ),
                              customMediumBoldText(title: 'Clear'.tr)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                height30(),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isTermsCondition = !isTermsCondition;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: ColorsUtils.black)),
                        child: isTermsCondition
                            ? Center(
                          child: Image.asset(
                            Images.check,
                            width: 10,
                          ),
                        )
                            : SizedBox(),
                      ),
                    ),
                    width20(),
                    customVerySmallSemiText(title: 'I agree to the Sadad'.tr),
                    // width5(),
                    InkWell(
                      onTap: () {
                        Get.to(() => TermsAndConditionRegister());
                      },
                      child: Text(' ${'Terms and conditions'.tr}',
                          style: ThemeUtils.blackBold.copyWith(
                              decoration: TextDecoration.underline,
                              fontSize: FontUtils.verySmall,
                              color: ColorsUtils.accent)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    if (isTermsCondition == true) {
      if (isSignature == true) {
        await convertToDataToFile();
      } else {
        Get.snackbar('error', 'Please do Signature');
      }
    } else {
      Get.snackbar('error', 'Please read Terms and conditions');
    }
  }

  Future<File> convertToDataToFile() async {
    showLoadingDialog(context: context);
    final data =
    await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ImageByteFormat.png);

    Uint8List imageInUnit8List =
    bytes!.buffer.asUint8List(); // store unit8List image here ;

    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(imageInUnit8List);
    print('$file');
    try {
      await signatureApiCall(file);
    } catch (e) {
      hideLoadingDialog(context: context);
      print('error is here$e');
      Get.snackbar('error', 'Session expire please login again');
    }
    return file;
  }

  Future<void> signatureApiCall(File file) async {
    final resposne = await ApiService()
        .uploadImage(file: file, url: 'containers/api-signature/upload');

    // var data = jsonEncode(resposne);

    print('res is ${(resposne)}');
    print(
        'res=>${jsonDecode(resposne.toString())['result']['files']['file'][0]['name']}');
    // print('res=>${resposne['result']['files']['file'][0]['name']}');
    hideLoadingDialog(context: context);
    createMerchantOTP(jsonDecode(resposne.toString())['result']['files']['file'][0]['name']);
    //userDataUpdateApiCall(jsonDecode(resposne.toString())['result']['files']['file'][0]['name']);
  }
  createMerchantOTP(String Signature) async {
    try {
      dio.Dio _dio = dio.Dio();
      String token = await encryptedSharedPreferences.getString('token');
      var response = await _dio.get(Utility.baseUrl + "usermetaauths/resendOtp?type=createsubmerchantotp",
          options: dio.Options(
            headers: {"Authorization": token},
          ));

      log("response:::${response.data}");
      if (response.statusCode == 200) {
        if (response.data["result"] == true) {
          Get.back();
          Get.snackbar(
              'success'.tr, 'OTP Send SuccessFully'.tr);
          Get.to(() => ManageMerchantOTP(body: widget.body,password: widget.password,isCreateSubMerchant: true,signature: Signature));
          setState(() {});
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print(e.message);
        Get.snackbar('error', '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }

  userDataUpdateApiCall(String img) async {
    String token = await encryptedSharedPreferences.getString('token');

    final url = Uri.parse('${Utility.baseUrl}users/${Utility.userId}');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);

    Map<String, dynamic> body = {
      "name": widget.body["businessname"],
      "agreement": 1,
      "signature": img,
      "cellnumber": widget.body["newCellnumber"],
      "email": widget.body["changedemail"],
      "password": widget.password,
      "otp": 294801,
      "buildingnumber": widget.body["buildingnumber"],
      "streetnumber": widget.body["streetnumber"],
      "zonenumber": widget.body["zonenumber"],
      "latitude": 23,
      "longitude": 23,
      "merchantregisterationnumber": widget.body["merchantregisterationnumber"]
    };
    var result = await http.patch(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {

    } else {
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  Future<void> userMetaPreferencesApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}usermetapreferences');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };

    Map<String, dynamic> body = {
      "receivedpaymentemail": false,
      "receivedordersms": false,
      "lastloginip": '',
      "receivedpaymentpush": true,
      "orderemail": false,
      "transfersms": false,
      "receivedorderspush": true,
      "receivedorderemail": false,
      "receivedrequestforpaymentpush": true,
      "transferpush": true,
      "userId": '${Utility.userId}',
      "lastlogindatetime": '${DateTime.now()}',
      "receivedpaymentsms": false,
      "createdby": 0,
      "transferemail": false,
      "ordersms": false,
      "modifiedby": 0,
      "receivedrequestforpaymentemail": false,
      "orderpush": true,
      "receivedrequestforpaymentsms": false
    };

    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      print('user meta result.${result.body}');
      loginApiCall();
    } else {
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  Future<void> loginApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}users/login');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> body = {
      "password": '${Utility.password}',
      "cellnumber": '${Utility.userPhone}',
      "signinForSignup": true
    };
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      await encryptedSharedPreferences.setString('bioPass', Utility.password);
      await encryptedSharedPreferences.setString(
          'bioNumber', Utility.userPhone);
      print('login result.${result.body}');
      await encryptedSharedPreferences.setString(
          'token', jsonDecode(result.body)['id'].toString());
      await encryptedSharedPreferences.setString(
          'id', jsonDecode(result.body)['userId'].toString());
      Utility.userId = '${jsonDecode(result.body)['userId']}';

      await encryptedSharedPreferences.setString('fromReg', 'true');
      //
      Future.delayed(Duration(seconds: 1), () {
        homeController.initBottomIndex = 0;

        Get.offAll(() => HomeScreen());
      });
    } else {
      hideLoadingDialog(context: context);
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }
}
