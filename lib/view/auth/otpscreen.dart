// ignore_for_file: unnecessary_string_interpolations

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Auth%20/verifyOtpResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/auth/register/setYourPassword.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../model/apimodels/requestmodel/Auth/verifyOtpRequestModel.dart';
import '../../model/apis/api_response.dart';
import '../../viewModel/Auth/loginViewModel.dart';
import '../home.dart';

class OtpScreen extends StatefulWidget {
  bool? isRegistration;
  bool? isForgotPass;
  String? signature;
  String? partnerID;
  OtpScreen(
      {Key? key,
      this.isRegistration,
      this.isForgotPass,
      this.signature,
      this.partnerID})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String currentText = "";
  int counter = 59;
  HomeController homeController = Get.find();

  // String _otpcode = "";
  Timer? timer;
  VerifyOtpRequestModel verifyOtpReq = VerifyOtpRequestModel();
  LoginViewModel loginViewModel = Get.find();
  String _code = "";

  //TextEditingController otp = TextEditingController();
  final scaffoldKey = GlobalKey();
  late OTPTextEditController otp;
  late OTPInteractor _otpInteractor;

  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    Utility.countryCodeNumber = '+974';
    deviceToken();
    initData();
    smsOtpGet();
    _otpInteractor = OTPInteractor();
    _otpInteractor
        .getAppSignature()
        //ignore: avoid_print
        .then((value) => print('signature - $value'));

    otp = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [
          //SampleStrategy(),
        ],
      );
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    SmsAutoFill().unregisterListener();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: bottomButton(context),
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height30(),

            ///back button
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios)),
            ),
            height30(),
            Text(
              'Enter 6 digit OTP'.tr,
              style:
                  ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
            ),
            height15(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${'We just sent the OTP to your mobile number'.tr} \n${Utility.countryCodeNumber} ${Utility.mobNo}',
                textAlign: TextAlign.center,
                style: ThemeUtils.blackSemiBold
                    .copyWith(fontSize: FontUtils.small),
              ),
            ),
            height30(),
            // PinFieldAutoFill(
            //   decoration: UnderlineDecoration(
            //     textStyle: TextStyle(fontSize: 20, color: Colors.black),
            //     colorBuilder:
            //         FixedColorBuilder(Colors.black.withOpacity(0.3)),
            //   ),
            //   currentCode: _code,
            //   onCodeSubmitted: (code) {
            //     setState(() {
            //       currentText = code;
            //     });
            //   },
            //   smsCodeRegexPattern: r"[0-9]",
            //   onCodeChanged: (code) {
            //     if (code!.length == 6) {
            //       currentText = code;
            //       FocusScope.of(context).requestFocus(FocusNode());
            //     }
            //   },
            // ),
            ///last otp field
            // PinCodeTextField(
            //   length: 6,
            //   obscureText: false,
            //   controller: otp,
            //   hintCharacter: '_',
            //   inputFormatters: [
            //     FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
            //   ],
            //   animationType: AnimationType.fade,
            //   keyboardType: TextInputType.phone,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   pinTheme: PinTheme(
            //     borderWidth: 1,
            //     shape: PinCodeFieldShape.box,
            //     activeColor: ColorsUtils.accent,
            //     borderRadius: const BorderRadius.all(Radius.circular(10)),
            //     fieldHeight: 50,
            //     fieldWidth: 40,
            //     fieldOuterPadding: const EdgeInsets.all(2),
            //     selectedColor: ColorsUtils.border,
            //     inactiveColor: ColorsUtils.border,
            //   ),
            //   animationDuration: Duration(milliseconds: 300),
            //   onChanged: (value) async {
            //     setState(() {
            //       currentText = value;
            //     });
            //     //
            //     // if (widget.isForgotPass == true && otp.text == '111111') {
            //     //   Get.offAll(() => SetYourPasswordScreen(
            //     //         isForgotPass: widget.isForgotPass,
            //     //       ));
            //     // } else
            //     if (otp.text.length == 6) {
            //       print('hi');
            //       await apiCall(context);
            //     }
            //   },
            //   appContext: context,
            // ),
            ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PinFieldAutoFill(
                controller: otp,
                textInputAction: TextInputAction.go,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                ],
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                decoration: BoxLooseDecoration(
                  textStyle:
                      ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
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
                    await apiCall(context);
                  }
                },
              ),
            ),
            height30(),
            Text(
              // 'Don\'t receive the OTP?'.tr,
              counter == 0
                  ? 'Can’t receive the OTP?'.tr
                  : "${'OTP is valid upto'.tr} $counter ${'seconds'.tr}",
              textAlign: TextAlign.center,
              style: ThemeUtils.blackSemiBold.copyWith(
                  fontSize: FontUtils.small,
                  color: counter == 0 ? ColorsUtils.black : ColorsUtils.grey),
            ),
            height10(),
            counter != 0
                ? SizedBox()
                : InkWell(
                    onTap: () async {
                      connectivityViewModel.startMonitoring();
                      if (counter == 0) {
                        counter = 59;
                        initData();
                        otp.clear();
                      }
                      if (connectivityViewModel.isOnline != null) {
                        if (connectivityViewModel.isOnline!) {
                          if (widget.isForgotPass == true) {
                            forgotPassSendOtpApiCall();
                          } else {
                            if (widget.isRegistration == true) {
                              registerSendOtpApiCall();
                            } else {
                              await loginViewModel.resendOtp();
                              if (loginViewModel.resendOtpApiResponse.status ==
                                  Status.COMPLETE) {
                                Get.snackbar(
                                    'success'.tr, 'OTP Send SuccessFully'.tr);
                              } else {
                                Get.snackbar('error'.tr, 'Something Wrong'.tr);
                              }
                            }
                          }
                        } else {
                          Get.snackbar(
                              'error', 'please check internet connectivity');
                        }
                      } else {
                        Get.snackbar(
                            'error', 'please check internet connectivity');
                      }
                    },
                    child: Text(
                      '${'Resend'.tr}',
                      textAlign: TextAlign.center,
                      style: ThemeUtils.blackSemiBold.copyWith(
                          color: counter == 0
                              ? ColorsUtils.black
                              : ColorsUtils.border,
                          fontSize: FontUtils.small),
                    ),
                  ),
          ],
        ),
      ),
    ));
  }

  Widget bottomButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: InkWell(
              onTap: () async {
                if (_code.length == 6) {
                  await apiCall(context);
                } else {
                  Get.snackbar('error'.tr, 'Please fill 6 digit OTP'.tr);
                }
              },
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Next'.tr)),
        ),
      ],
    );
  }

  Future<void> apiCall(BuildContext context) async {
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        if (widget.isForgotPass == true) {
          await forgotPassOtpVerify(context);
        } else if (widget.isRegistration == true) {
          await registerOtpVerify(context);
        } else {
          verifyOtpReq.userId = int.parse(Utility.userId);
          verifyOtpReq.otp = int.parse(_code);
          verifyOtpReq.devicetoken = Utility.deviceId;
          await loginViewModel.verifyOtp(verifyOtpReq);

          if (loginViewModel.verifyOtpApiResponse.status == Status.COMPLETE) {
            VerifyOtpResponseModel verifyResponseModel =
                loginViewModel.verifyOtpApiResponse.data;
            if (verifyResponseModel.roleId != 14 &&
                verifyResponseModel.roleId != 16 &&
                verifyResponseModel.roleId != 17 &&
                verifyResponseModel.roleId != 2) {
              await encryptedSharedPreferences.setString(
                  'name', verifyResponseModel.name.toString());
              Utility.name = verifyResponseModel.name;
              verifyResponseModel.profilepic == null
                  ? null
                  : Utility.profilePic = verifyResponseModel.profilepic == null
                      ? null
                      : verifyResponseModel.profilepic;
              print('email is ${verifyResponseModel.email}');
              Utility.userbusinessstatus =
                  verifyResponseModel.userbusinessstatusId ?? 0;
              await encryptedSharedPreferences.setString(
                  'email', verifyResponseModel.email);
              await encryptedSharedPreferences.setString(
                  'sadadId', verifyResponseModel.sadadId);
              await encryptedSharedPreferences.setString(
                  'mobileNo.', verifyResponseModel.cellnumber);
              showLoadingDialog(context: context);

              Get.snackbar('success'.tr, 'Otp verified successfully'.tr);
              AnalyticsService.sendLoginEvent('${Utility.userId}');
              await encryptedSharedPreferences.setString('fromReg', 'false');
              Future.delayed(Duration(seconds: 1), () {
                hideLoadingDialog(context: context);
                Utility.countryCodeNumber = '+974';
                Utility.countryCode = 'QA';
                Utility.mobNo = '';
                homeController.initBottomIndex = 0;
                Get.offAll(() => HomeScreen());
                // Get.to(() => InvoiceList());
              });
            } else {
              Get.snackbar('error'.tr, 'Not allow to login'.tr);
            }
          } else {
            Get.snackbar('error'.tr, 'Please check OTP'.tr);
          }
        }
      } else {
        Get.snackbar('error', 'please check internet connectivity');
      }
    } else {
      Get.snackbar('error', 'please check internet connectivity');
    }
  }

  Future<void> forgotPassOtpVerify(BuildContext context) async {
    showLoadingDialog(context: context);
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}users/verifyResetPassword');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> body = {
      "cellnumber": "${Utility.mobNo}",
      "forgotpasswordotp": otp.text
    };
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      // hideLoadingDialog(context: context);
      print('otp forgot res is ${result.body}');
      await encryptedSharedPreferences.setString(
          'token', jsonDecode(result.body)['accessToken']);
      print(' forgot req is  :${result.body}');
      await encryptedSharedPreferences.setString('mobileNo.', Utility.mobNo);

      Future.delayed(Duration(seconds: 1), () {
        hideLoadingDialog(context: context);
        Utility.countryCodeNumber = '+974';
        Utility.countryCode = 'QA';
        Utility.mobNo = '';
        Get.off(() => SetYourPasswordScreen(
              isForgotPass: widget.isForgotPass,
              partnerID: widget.partnerID,
            ));
        // Get.to(() => InvoiceList());
      });
    } else if (result.statusCode == 499) {
      hideLoadingDialog(context: context);

      Get.off(() => UnderMaintenanceScreen());
    } else {
      hideLoadingDialog(context: context);

      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  Future<void> registerOtpVerify(BuildContext context) async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}usermetaauths/verify');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> body = {
      "signupotp": int.parse(_code),
      "userId": int.parse(Utility.userId),
      "devicetoken": Utility.deviceId
    };
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      Get.snackbar('success'.tr, 'Otp verified successfully'.tr);
      print('otp reg res is ${result.body}');
      // await encryptedSharedPreferences.setString(
      //     'token', jsonDecode(result.body)['accessToken']);
      print('sadadID ${jsonDecode(result.body)['SadadId']}');
      await encryptedSharedPreferences.setString(
          'sadadId', jsonDecode(result.body)['SadadId']);
      Utility.userbusinessstatus = 2;
      Future.delayed(Duration(seconds: 1), () {
        hideLoadingDialog(context: context);
        Utility.countryCodeNumber = '+974';
        Utility.countryCode = 'QA';
        Utility.mobNo = '';
        Get.off(() => SetYourPasswordScreen(
              partnerID: widget.partnerID,
            ));
        // Get.to(() => InvoiceList());
      });
    } else if (result.statusCode == 499) {
      hideLoadingDialog(context: context);

      Get.off(() => UnderMaintenanceScreen());
    } else {
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  forgotPassSendOtpApiCall() async {
    final url = Uri.parse('${Utility.baseUrl}users/reset');
    Map<String, String> header = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "cellnumber": "${Utility.mobNo}",
    };
    print('url is ' + url.toString());
    print('bodu is$body');
    print('body is${jsonEncode(body)}');
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode >= 200 && result.statusCode <= 299) {
      print('result is ' + result.body);
      print('req is ' + url.toString());
    } else if (result.statusCode == 499) {
      hideLoadingDialog(context: context);

      Get.off(() => UnderMaintenanceScreen());
    } else {
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  registerSendOtpApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url =
        Uri.parse('${Utility.baseUrl}usermetaauths/resendotp?type=signup');
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    // Map<String, dynamic> body = {
    //   "cellnumber": "${Utility.mobNo}",
    // };
    print('url is ' + url.toString());
    // print('body is$body');
    var result = await http.get(
      url,
      headers: header,
    );

    if (result.statusCode >= 200 && result.statusCode <= 299) {
      print('result is ' + result.body);
      print('req is ' + url.toString());
    } else if (result.statusCode == 499) {
      hideLoadingDialog(context: context);

      Get.off(() => UnderMaintenanceScreen());
    } else {
      if (result.statusCode == 401) {
        SessionExpire();
      } else {
        print(jsonDecode(result.body)['error']['message']);
        Get.snackbar(
          'error'.tr,
          '${jsonDecode(result.body)['error']['message']}',
        );
      }
    }
  }

  initData() async {
    print('OTP LISTING....');
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter--;
      if (counter == 0) {
        print('Cancel timer');
        timer.cancel();
      }
      setState(() {});
    });
  }

  Future<String?> deviceToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    Utility.deviceId = fcmToken!;
    print('FCM TOKEN :=>${Utility.deviceId}');
    // var deviceInfo = DeviceInfoPlugin();
    // if (Platform.isIOS) {
    //   // import 'dart:io'
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    //   log('id is ${iosDeviceInfo.identifierForVendor}');
    //   Utility.deviceId = iosDeviceInfo.identifierForVendor!;
    //   return iosDeviceInfo.identifierForVendor;
    //   // unique ID on iOS
    // } else if (Platform.isAndroid) {
    //   var androidDeviceInfo = await deviceInfo.androidInfo;
    //   Utility.deviceId = androidDeviceInfo.androidId!;
    //   return androidDeviceInfo.androidId; // unique ID on Android
    // }
  }

  smsOtpGet() async {
    await SmsAutoFill().listenForCode;
  }
}
