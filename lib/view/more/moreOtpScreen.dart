import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/Auth/sendOtpRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessmodel.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../model/apimodels/requestmodel/Auth/verifyOtpRequestModel.dart';
import '../../model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import '../../model/apis/api_response.dart';
import '../../viewModel/Auth/loginViewModel.dart';

class MoreOtpScreen extends StatefulWidget {
  final String? title;
  final String? value;
  final bool? isAddress;
  final String? type;
  final BusinessDataModel? businessDataModel;
  final Businessmedia? businessMedia;
  final Map<String, dynamic>? body;

  MoreOtpScreen({
    this.title,
    this.value,
    this.isAddress,
    this.type,
    this.businessDataModel,
    this.businessMedia,
    this.body,
    Key? key,
  }) : super(key: key);

  @override
  State<MoreOtpScreen> createState() => _MoreOtpScreenState();
}

class _MoreOtpScreenState extends State<MoreOtpScreen> {
  String currentText = "";
  int counter = 59;
  Timer? timer;
  String _code = "";

  VerifyOtpRequestModel verifyOtpReq = VerifyOtpRequestModel();
  SendOtpRequestModel sendOtpReq = SendOtpRequestModel();
  LoginViewModel loginViewModel = Get.find();
  final cnt = Get.find<BusinessInfoViewModel>();
  String id = "";
  BankAccountResponseModel bankAccountResponseModel =
      BankAccountResponseModel();

  TextEditingController otp = TextEditingController();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    deviceToken();
    initData();
    print("=====>${widget.type}");
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
                          cnt.businessDataModel.value.otp = otp.text;
                          if (otp.text.isNotEmpty) {
                            if(widget.type == "AllBusinessUpdate") {
                              widget.body?.addEntries({"otp":otp.text}.entries);
                              cnt.updateBusinessDetailsNew(body: widget.body ?? {},context: context);
                            } else {
                              cnt.updateBusinessDetails(
                                context: context,
                                type: widget.type,
                                businessDataModel: widget.businessDataModel,
                                businessMedia: widget.businessMedia,
                              );
                            }
                          }
                        }
                      },
                    ),
                  ),
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
                  //     if (otp.text.length == 6) {
                  //       cnt.businessDataModel.value.otp = otp.text;
                  //       if (otp.text.isNotEmpty) {
                  //         cnt.updateBusinessDetails(
                  //           context: context,
                  //           type: widget.type,
                  //           businessDataModel: widget.businessDataModel,
                  //           businessMedia: widget.businessMedia,
                  //         );
                  //       }
                  //     }
                  //   },
                  //   appContext: context,
                  // ),
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
                              counter = 59;
                              otp.clear();

                              initData();

                              await loginViewModel.resendOtp();
                              if (loginViewModel.resendOtpApiResponse.status ==
                                  Status.COMPLETE) {
                                Get.snackbar(
                                    'success'.tr, 'OTP Send SuccessFully'.tr);
                              } else {
                                Get.snackbar('error'.tr, 'Something Wrong'.tr);
                              }
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
                deviceToken();
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
              deviceToken();
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

  Widget bottomButton(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: InkWell(
              onTap: () async {
                log(Utility.userPhone);
                cnt.businessDataModel.value.otp = otp.text;
                if (otp.text.isNotEmpty) {
                  cnt.updateBusinessDetails(
                    context: context,
                    type: widget.type,
                    businessDataModel: widget.businessDataModel,
                    businessMedia: widget.businessMedia,
                  );
                }
              },
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Next'.tr)),
        ),
      ],
    );
  }

  initData() async {
    sendOtpReq.newCellnumber = Utility.userPhone;
    print("newcell number ${Utility.userPhone}");
    await loginViewModel.sendOtp(sendOtpReq, context: context);
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
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      log('id is ${iosDeviceInfo.identifierForVendor}');
      Utility.deviceId = iosDeviceInfo.identifierForVendor!;
      return iosDeviceInfo.identifierForVendor;
      // unique ID on iOS
    } else if (Platform.isAndroid) {
      const _androidIdPlugin = AndroidId();
      //var androidDeviceInfo = await deviceInfo.androidInfo;
      Utility.deviceId = await _androidIdPlugin.getId() ?? "";
      return _androidIdPlugin.getId();
      //Utility.deviceId = androidDeviceInfo.androidId!;
      //return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
