import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/controller/delete_controller.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/Auth/sendOtpRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/Auth/verifyOtpRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/deleteAccount/deleteAccountSuccessHandle.dart';
import 'package:sadad_merchat_app/view/splash.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/Auth/loginViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

import '../../../base/constants.dart';

class SendOtpScreen extends StatefulWidget {
  SendOtpScreen({Key? key}) : super(key: key);

  @override
  State<SendOtpScreen> createState() => _MoreOtpScreenState();
}

class _MoreOtpScreenState extends State<SendOtpScreen> {
  String currentText = "";

  VerifyOtpRequestModel verifyOtpReq = VerifyOtpRequestModel();
  SendOtpRequestModel sendOtpReq = SendOtpRequestModel();
  LoginViewModel loginViewModel = Get.find();
  final cnt = Get.find<BusinessInfoViewModel>();
  String id = "";
  BankAccountResponseModel bankAccountResponseModel = BankAccountResponseModel();

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
    controller.timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return GetBuilder(builder: (DeleteAccountController controller) {
          return Scaffold(
            appBar: commonAppBar(),
            // bottomNavigationBar: bottomButton(context),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    height20(),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:
                        Text(
                          'Keep your account safe, please verify your identity'.tr,
                          textAlign: TextAlign.center,
                          style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small),
                        )),
                    height20(),
                    Text(
                      'Enter the OTP'.tr,
                      style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
                    ),
                    height15(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${'We have sent the OTP to the number'.tr} \n${Utility.countryCodeNumber} ${cnt.businessInfoModel.value.user?.cellnumber ?? ""}',
                        textAlign: TextAlign.center,
                        style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small),
                      ),
                    ),
                    height20(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: PinFieldAutoFill(
                        controller: otp,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                        ],
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: BoxLooseDecoration(
                          textStyle: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
                          radius: Radius.circular(10),
                          hintText: '------',
                          // textStyle: TextStyle(fontSize: 20, color: Colors.black),
                          strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                        ),
                        codeLength: 6,
                        currentCode: controller.code,
                        onCodeSubmitted: (code) async {},
                        onCodeChanged: (code) async {
                          controller.code = code ?? "";
                          controller.update();
                          if (code!.length == 6) {
                            submitOtp();
                          }
                        },
                      ),
                    ),
                    height30(),
                    Text(
                      controller.counter == 0 ? 'Can’t receive the OTP?'.tr : "${'OTP is valid upto'.tr} ${controller.counter} ${'seconds'.tr}",
                      textAlign: TextAlign.center,
                      style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small, color: controller.counter == 0 ? ColorsUtils.black : ColorsUtils.grey),
                    ),
                    height10(),
                    controller.counter != 0
                        ? SizedBox()
                        : InkWell(
                            onTap: () async {
                              if (controller.counter == 0) {
                                controller.counter = 60;
                                otp.clear();

                                sendOtpReq.newCellnumber = Utility.userPhone;
                                initData();
                                controller.sendOtp(navigate: false);
                                // if (loginViewModel.sendOtpApiResponse.status == Status.COMPLETE) {
                                //   Get.snackbar('success'.tr, 'OTP Send SuccessFully'.tr);
                                // } else {
                                //   Get.snackbar('error'.tr, 'Something Wrong'.tr);
                                // }
                              }
                            },
                            child: Text(
                              '${'Resend'.tr}',
                              textAlign: TextAlign.center,
                              style: ThemeUtils.blackSemiBold.copyWith(
                                color: controller.counter == 0 ? ColorsUtils.black : ColorsUtils.border,
                                fontSize: FontUtils.small,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        });
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
                Get.snackbar('error'.tr, 'Please check your connection'.tr);
              }
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
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
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection'.tr);
          }
        },
      );
    }
  }

  DeleteAccountController controller = Get.find<DeleteAccountController>();

  Future<void> submitOtp() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(Utility.baseUrl + "usermetaauths/verify");
    log("URl i :- $url");
    Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
    var body = {"deleteuserotp": otp.text, "deactivateReason": controller.reasonForDelete};
    var result = await http.post(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data ========>>>>>>$data");
      // Get.showSnackbar(GetSnackBar(
      //   message: 'Delete Successfully'.tr,
      //   duration: Duration(seconds: 1),
      // ));
      await encryptedSharedPreferences.setString('account_deleted_success', "yes");
      Get.to(deleteAccountSuccessHandle());
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      otp.clear();
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }

  initData() async {
    controller.counter = 60;
    controller.timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      controller.counter--;
      if (controller.counter == 0) {
        timer.cancel();
      }
      controller.update();
    });
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
  accountDeletedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: ColorsUtils.black.withOpacity(0.3), blurRadius: 3, offset: Offset(0, 4), spreadRadius: 3)]),
                padding: EdgeInsets.all(Get.width * .03),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(child: Image.asset(Images.successDeleteAcc),),
                    height15(),
                    Text(
                      "Successfully deleted".tr,
                      style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
                    ),
                    height25(),
                    Text("Your Delete account request is submitted.".tr,
                        style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.mediumSmall, color: ColorsUtils.grey), textAlign: TextAlign.center),
                    height12(),
                    Text("You can exit the app.".tr,
                        style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.mediumSmall, color: ColorsUtils.grey), textAlign: TextAlign.center),
                    height25(),
                    InkWell(
                        onTap: () {
                          if (Platform.isAndroid) {
                            exit(0);
                          } else if (Platform.isIOS) {
                            Get.offAll(() => SplashScreen());
                          }
                        },
                        child:
                            buildContainerWithoutImage(width: Get.width * 0.5, style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.accent, text: 'Okay'.tr)),

                    // SizedBox(
                    //   height: Get.width * .06,
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     Get.back();
                    //   },
                    //   child: Text(
                    //     "No, Thanks".tr,
                    //     style: TextStyle(
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
