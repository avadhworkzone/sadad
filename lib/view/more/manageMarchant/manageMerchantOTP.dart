import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/Auth/sendOtpRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/home.dart';
import 'package:sadad_merchat_app/view/more/moreScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessmodel.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:dio/dio.dart' as dio;

import 'package:http/http.dart' as http;

import 'manageMarchant.dart';

class ManageMerchantOTP extends StatefulWidget {
  String? sadadId;
  bool? isUnlink;
  bool? isCreateSubMerchant;
  bool? isEdit;
  bool? isOld;
  Map<String, dynamic>? body;
  String? signature;
  String? password;
  String? unlinkEmail;
  String? unlinkCell;

  ManageMerchantOTP({
    Key? key,
    this.isUnlink,
    this.isEdit,
    this.isOld,
    this.sadadId,
    this.body,
    this.isCreateSubMerchant,
    this.signature,
    this.password,
    this.unlinkEmail,
    this.unlinkCell,
  }) : super(key: key);

  @override
  State<ManageMerchantOTP> createState() => _MoreOtpScreenState();
}

class _MoreOtpScreenState extends State<ManageMerchantOTP> {
  String currentText = "";
  int counter = 59;
  Timer? timer;
  String _code = "";


  TextEditingController otp = TextEditingController();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    deviceTokenNativeiOSAndoid();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
          appBar: commonAppBar(),
          // bottomNavigationBar: bottomButton(context),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  height30(),
                  Text(
                    'Enter the OTP'.tr,
                    style: ThemeUtils.blackBold
                        .copyWith(fontSize: FontUtils.medLarge),
                  ),
                  height15(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${'We have sent the OTP to the number'.tr} \n${Utility.countryCodeNumber} ${Utility.userPhone ?? ""}',
                      textAlign: TextAlign.center,
                      style: ThemeUtils.blackSemiBold
                          .copyWith(fontSize: FontUtils.small),
                    ),
                  ),
                  height30(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PinFieldAutoFill(
                      controller: otp,
                      textInputAction: TextInputAction.go,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                      ],
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      decoration: BoxLooseDecoration(
                        textStyle: ThemeUtils.blackBold
                            .copyWith(fontSize: FontUtils.medium),
                        radius: Radius.circular(10),
                        hintText: '------',
                        // textStyle: TextStyle(fontSize: 20, color: Colors.black),
                        strokeColorBuilder:
                        FixedColorBuilder(Colors.black.withOpacity(0.3)),
                      ),
                      currentCode: _code,
                      codeLength: 6,
                      onCodeSubmitted: (code) async {},
                      onCodeChanged: (code) async {
                        setState(() {
                          _code = code!;
                          // currentText = code;
                        });
                        print('_CODE :=>$_code');
                        if (_code.length == 6) {
                          if (otp.text.isNotEmpty) {
                            otpVefified();
                          }
                        }
                      },
                    ),
                  ),
                  height30(),
                  Text(
                    counter == 0
                        ? 'Can’t receive the OTP?'.tr
                        : "${'OTP is valid upto'.tr} $counter ${'seconds'.tr}",
                    textAlign: TextAlign.center,
                    style: ThemeUtils.blackSemiBold.copyWith(
                        fontSize: FontUtils.small,
                        color: counter == 0
                            ? ColorsUtils.black
                            : ColorsUtils.grey),
                  ),
                  height10(),
                  counter != 0
                      ? SizedBox()
                      : InkWell(
                    onTap: () async {
                      if (counter == 0) {
                        if(widget.isUnlink == true) {
                          await unLinkMarchant();
                        } else if(widget.isCreateSubMerchant == true){
                          createMerchantOTP();
                        } else {
                          await linkMarchant();
                        }
                        counter = 59;
                        otp.clear();
                        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                          counter--;
                          if (counter == 0) {
                            print('Cancel timer');
                            timer.cancel();
                          }
                          setState(() {});
                        });
                      }
                    },
                    child: Text(
                      '${'Resend'.tr}',
                      textAlign: TextAlign.center,
                      style: ThemeUtils.blackSemiBold.copyWith(
                        color: counter == 0
                            ? ColorsUtils.black
                            : ColorsUtils.border,
                        fontSize: FontUtils.small,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                setState(() {});
                deviceTokenNativeiOSAndoid();
                initData();
              } else {
                Get.snackbar('error'.tr, 'Please check your connection');
              }
            } else {
              Get.snackbar('error'.tr, 'Please check your connection');
            }
          },
        );
      }
    } else {
      return InternetNotFound(
        onTap: () async {
          connectivityViewModel.startMonitoring();

          if (connectivityViewModel.isOnline != null) {
            if (connectivityViewModel.isOnline!) {
              setState(() {});
              deviceTokenNativeiOSAndoid();
              initData();
            } else {
              Get.snackbar('error'.tr, 'Please check your connection');
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection');
          }
        },
      );
    }
  }



  initData() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter--;
      if (counter == 0) {
        print('Cancel timer');
        timer.cancel();
      }
      setState(() {});
    });
  }
  otpVefified() async {
    if (widget.isUnlink == true) {
      dio.Dio _dio = dio.Dio();
      String token = await encryptedSharedPreferences.getString('token');
      Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
      var body = {
        "otp": otp.text.toString(),
        "SadadId": widget.sadadId.toString() // Child merchant SadadId
      };
      if(widget.unlinkEmail != null) {
        body.addEntries({"email": widget.unlinkEmail.toString()}.entries);
      }
      if(widget.unlinkCell != null) {
        body.addEntries({"cellnumber": widget.unlinkCell.toString()}.entries);
      }

      print("body =======>>>  ${jsonEncode(body)}");
      final url = Uri.parse(Utility.baseUrl + "users/unlinkChildMerchant");
      var result = await http.post(url, headers: header, body: json.encode(body));
      print('header$header');
      print(result.body);
      print(result.statusCode);
      if (result.statusCode < 299 || result.statusCode == 200) {
        Get.to(() => ManageMarchant(fromMoreScreen: false));
        // Get.showSnackbar(GetSnackBar(
        //   message: 'UnLink merchant successfully.',
        //   duration: Duration(seconds: 2),
        // ));
        Get.snackbar("Success".tr,'UnLink merchant successfully.'.tr);
      } else if (result.statusCode == 401) {
        funcSessionExpire();
      } else {
        Get.snackbar('error'.tr, '${jsonDecode(result.body)['error']['message']}');
      }
    } else if(widget.isCreateSubMerchant == true) {
        String token = await encryptedSharedPreferences.getString('token');
        String lat = await encryptedSharedPreferences.getString('currentLat');
        String long = await encryptedSharedPreferences.getString('currentLong');
        final url = Uri.parse('${Utility.baseUrl}users/createSubMerchant');
        Map<String, String> header = {
          'Authorization': token,
          'Content-Type': 'application/json'
        };
        print(url);
        Map<String, dynamic> body = {
          "name": widget.body!["businessname"],
          "agreement": 1,
          "signature": widget.signature,
          "cellnumber": widget.body!["newCellnumber"],
          "email": widget.body!["changedemail"],
          "password": widget.password,
          "otp": otp.text,
          "buildingnumber": widget.body!["buildingnumber"],
          "streetnumber": widget.body!["streetnumber"],
          "zonenumber": widget.body!["zonenumber"],
          "unitnumber": widget.body!["unitnumber"],
          "latitude": lat,
          "longitude": long,
          "merchantregisterationnumber": widget.body!["merchantregisterationnumber"]
        };
        var result = await http.post(url, headers: header, body: jsonEncode(body));
        if (result.statusCode == 200) {
          Get.to(() => ManageMarchant(fromMoreScreen: false));
          // Get.showSnackbar(GetSnackBar(
          //   message: 'Submerchant created successfully.',
          //   duration: Duration(seconds: 2),
          // ));
          Get.snackbar("Success".tr,'Submerchant created successfully.'.tr);
          setState(() {});
        } else {
          Get.snackbar(
            'error'.tr,
            '${jsonDecode(result.body)['error']['message']}',
          );
        }
    } else {
      dio.Dio _dio = dio.Dio();
      String token = await encryptedSharedPreferences.getString('token');
      Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
      var body = {
        "linkmerchantotp": otp.text.toString(),
        "userId": int.parse(Utility.userId),
        "SadadId": widget.sadadId.toString() // Child merchant SadadId
      };
      print("body =======>>>  ${jsonEncode(body)}");
      final url = Uri.parse(Utility.baseUrl + "usermetaauths/verify");
      var result = await http.post(url, headers: header, body: json.encode(body));
      print('header$header');
      print(result.body);
      print(result.statusCode);
      if (result.statusCode < 299 || result.statusCode == 200) {
        Get.back();
        // Get.showSnackbar(GetSnackBar(
        //   message: 'Link merchant request sent.',
        //   duration: Duration(seconds: 2),
        // ));
        Get.snackbar("Success".tr,'Link merchant request sent.'.tr);
        setState(() {});
      } else if (result.statusCode == 401) {
        funcSessionExpire();
      } else {
        Get.snackbar('error'.tr, '${jsonDecode(result.body)['error']['message']}');
      }
    }
  }

  linkMarchant() async {
    dio.Dio _dio = dio.Dio();
    String token = await encryptedSharedPreferences.getString('token');
    var response = await _dio.get(Utility.baseUrl + "usermetaauths/resendOtp?type=linkmerchantotp&linkMerchantSadadId=${widget.sadadId}",
        options: dio.Options(
          headers: {"Authorization": token},
        ));
    log("response:::${response.data}");
    if (response.statusCode == 200) {
      if(response.data["result"] == true) {
        Get.snackbar(
            'success'.tr, 'OTP Send SuccessFully'.tr);
      }
      //log("subMerchantList:::${subMerchantList}");
    }
  }

  unLinkMarchant() async {
    try {
      dio.Dio _dio = dio.Dio();
      String token = await encryptedSharedPreferences.getString('token');
      var response = await _dio.get(Utility.baseUrl + "usermetaauths/resendOtp?type=unlinkmerchantotp",
          options: dio.Options(
            headers: {"Authorization": token},
          ));

      log("response:::${response.data}");
      if (response.statusCode == 200) {
        if (response.data["result"] == true) {
          Get.snackbar('success'.tr, 'OTP Send SuccessFully'.tr);
          setState(() {});
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print(e.message);
        Get.snackbar('error'.tr, '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }
  createMerchantOTP() async {
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
          Get.snackbar(
              'success'.tr, 'OTP Send SuccessFully'.tr);
          setState(() {});
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print(e.message);
        Get.snackbar('error'.tr, '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }
  Future<String?> deviceTokenNativeiOSAndoid() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      log('id is ${iosDeviceInfo.identifierForVendor}');
      Utility.deviceId = iosDeviceInfo.identifierForVendor!;
      return iosDeviceInfo.identifierForVendor;
      // unique ID on iOS
    } else if (Platform.isAndroid) {
      // var androidDeviceInfo = await deviceInfo.androidInfo;
      // Utility.deviceId = androidDeviceInfo.id!;
      // return androidDeviceInfo.id; // unique ID on Android
      const _androidIdPlugin = AndroidId();
      Utility.deviceId = await _androidIdPlugin.getId() ?? "";
      return _androidIdPlugin.getId();
    }
  }
}
