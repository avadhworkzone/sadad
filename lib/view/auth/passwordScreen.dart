import 'dart:convert';

import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:encrypt/encrypt.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/Auth/loginRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/errorResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/auth/register/enterYourPhoneNumberScreen.dart';
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/Auth/loginViewModel.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../model/apimodels/requestmodel/Auth/sendOtpRequestModel.dart';
import '../../model/apimodels/responseModel/Auth /loginResponseModel.dart';
import '../../model/apis/api_response.dart';
import '../../staticData/loading_dialog.dart';
import '../../staticData/utility.dart';
import 'otpscreen.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class PasswordScreen extends StatefulWidget {
  String? phoneNumber;

  PasswordScreen({key, this.phoneNumber}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  TextEditingController password = TextEditingController();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  SendOtpRequestModel sendOtpReq = SendOtpRequestModel();
  String? profilePic = '';
  String? name = '';
  String token = '';
  bool isVisible = true;
  final _formKey = GlobalKey<FormState>();
  LoginRequestModel loginReq = LoginRequestModel();
  LoginViewModel loginViewModel = Get.find();
  ConnectivityViewModel connectivityViewModel = Get.find();
  bool isLoading = true;
  @override
  void initState() {
    isLoading = true;
    deviceToken();
    // TODO: implement initState
    super.initState();
    fetchProfileDetails();
    singleCallForVPNCheck();
  }

  @override
  Widget build(BuildContext context) {
    // password.text = "Sadad@123456";
    return Scaffold(
        body: isLoading
            ? Center(
                child: Loader(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height30(),

                      ///back button
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(Icons.arrow_back_ios)),
                      height30(),
                      Row(
                        children: [
                          Spacer(),
                          profilePic == '' || profilePic == null
                              ? Image.network(
                                  "https://sadad.qa/wp-content/uploads/2022/02/Color-Logo.png",
                                  fit: BoxFit.none,
                                  height: Get.height * 0.125,
                                  width: Get.height * 0.125,
                                )
                              : Image.network(
                                  "${Utility.baseUrl}containers/api-businesslogo/download/${profilePic.toString()}?access_token=${token.toString()}",
                                  fit: BoxFit.fill,
                                  height: Get.height * 0.125,
                                  width: Get.height * 0.125,
                                ),
                          Spacer(),
                        ],
                      ),
                      height15(),
                      Row(
                        children: [
                          Spacer(),
                          name == ''
                              ? SizedBox()
                              : Text(
                                  name.toString(),
                                  style: ThemeUtils.blackBold
                                      .copyWith(fontSize: FontUtils.medLarge),
                                ),
                          Spacer(),
                        ],
                      ),

                      ///enter account
                      height25(),
                      Text(
                        'Enter your account password'.tr,
                        style: ThemeUtils.blackSemiBold
                            .copyWith(fontSize: FontUtils.medium),
                      ),
                      height20(),

                      ///textField password
                      SizedBox(
                        child: commonTextField(
                            contollerr: password,
                            hint: 'Password'.tr,
                            maxLines: 1,
                            validationType: isVisible == true ? 'password' : '',
                            suffix: InkWell(
                              onTap: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              child: Image.asset(
                                isVisible == true
                                    ? Images.password
                                    : Images.accentEye,
                                scale: 2.5,
                              ),
                            ),
                            regularExpression: TextValidation.password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password cannot be empty".tr;
                              }

                              return null;
                            },
                            inputLength: 20),
                      ),
                      height20(),
                      Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                              onTap: () {
                                singleCallForVPNCheck();
                                Get.to(() => EnterYourPhoneScreen(
                                      isForgotPass: true,
                                      phone: widget.phoneNumber,
                                    ));
                              },
                              child: customSmallMedSemiText(
                                  title: 'Forgot Password?'.tr))),

                      ///next button
                      const Spacer(),
                      GetBuilder<ConnectivityViewModel>(
                        builder: (internetController) {
                          return InkWell(
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                if (_formKey.currentState!.validate()) {
                                  connectivityViewModel.startMonitoring();

                                  if (internetController.isOnline != null) {
                                    if (internetController.isOnline!) {
                                      showLoadingDialog(context: context);
                                      final getAppSignature =
                                          await SmsAutoFill().getAppSignature;
                                      // await encryptedSharedPreferences.setString('token', '');
                                      // await encryptedSharedPreferences.clear();
                                      loginReq.cellnumber = widget.phoneNumber;
                                      loginReq.password = password.text;
                                      loginReq.devicetoken = Utility.deviceId;
                                      loginReq.appSignature =
                                          getAppSignature.toString();

                                      final url = Uri.parse(
                                          '${Utility.baseUrl}users/login');
                                      Map<String, String> header = {
                                        'Content-Type': 'application/json'
                                      };

                                      var result = await http.post(url,
                                          headers: header,
                                          body: jsonEncode(loginReq));
                                      if (result.statusCode == 200) {
                                        Utility.mobNo = widget.phoneNumber!;
                                        Utility.userPhone = widget.phoneNumber!;
                                        print('phone${Utility.userPhone}');
                                        print(
                                            "res token ${jsonDecode(result.body)['id'].toString()}");
                                        var temp = jsonDecode(result.body);
                                        print(temp);
                                        await encryptedSharedPreferences.setString(
                                            'id',
                                            '${jsonDecode(result.body)['userId'].toString()}');
                                        await encryptedSharedPreferences.setString(
                                            'isSubmerchantEnabled',
                                            '${jsonDecode(result.body)['isSubmerchantEnabled'].toString()}');
                                        await encryptedSharedPreferences.setString(
                                            'isSubMarchantAvailable',
                                            '${jsonDecode(result.body)['isSubMarchantAvailable'].toString()}');

                                        await encryptedSharedPreferences.setString(
                                            'isDocExpired',
                                            '${jsonDecode(result.body)['isDocExpired'].toString()}');
                                        await encryptedSharedPreferences.setString(
                                            'promtDocMessageEn',
                                            '${jsonDecode(result.body)['promtDocMessageEn'].toString()}');
                                        await encryptedSharedPreferences.setString(
                                            'promtDocMessageAr',
                                            '${jsonDecode(result.body)['promtDocMessageAr'].toString()}');
                                        // await encryptedSharedPreferences.setString('isSubmerchantEnabled',
                                        //     'true');
                                        await encryptedSharedPreferences
                                            .setString(
                                                'token',
                                                jsonDecode(result.body)['id']
                                                    .toString());

                                        await encryptedSharedPreferences
                                            .setString('bioNumber',
                                                widget.phoneNumber!);
                                        await encryptedSharedPreferences
                                            .setString(
                                                'bioPass', password.text);
                                        print(
                                            'number is  ${await encryptedSharedPreferences.getString('bioNumber')} pass is ${await encryptedSharedPreferences.getString('bioPass')}');
                                        Utility.userId =
                                            jsonDecode(result.body)['userId']
                                                .toString();
                                        Get.snackbar('Success'.tr,
                                            'OTP Send Successfully'.tr);
                                        hideLoadingDialog(context: context);
                                        final getAppSignature =
                                            await SmsAutoFill().getAppSignature;

                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          Get.to(() => OtpScreen(
                                                isRegistration: false,
                                                signature: getAppSignature,
                                              ));
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

                                      // await loginViewModel.login(loginReq);

                                      // if (loginViewModel.loginApiResponse.status ==
                                      //     Status.COMPLETE) {
                                      //   // Utility.mobNo = widget.phoneNumber!;
                                      //
                                      //   // Utility.userPhone = widget.phoneNumber!;
                                      //   // print('phone${Utility.userPhone}');
                                      //   // final result =
                                      //   //     loginViewModel.loginApiResponse.data;
                                      //   // print('${result.runtimeType}error is come');
                                      //   // if (result is ErrorResponseModel) {
                                      //   //   Get.snackbar('error', result.error!.message!);
                                      //   //   hideLoadingDialog(context: context);
                                      //   //   return;
                                      //   // }
                                      //   // LoginResponseModel response =
                                      //   //     loginViewModel.loginApiResponse.data;
                                      //   // print("res token ${response.id}");
                                      //   // await encryptedSharedPreferences.setString(
                                      //   //     'id', '${response.userId}');
                                      //   //
                                      //   // await encryptedSharedPreferences.setString(
                                      //   //     'token', response.id!);
                                      //
                                      //   ///biometric store
                                      //   //
                                      //   // await encryptedSharedPreferences.setString(
                                      //   //     'bioNumber', widget.phoneNumber!);
                                      //   // await encryptedSharedPreferences.setString(
                                      //   //     'bioPass', password.text);
                                      //
                                      //   // print(
                                      //   //     'number is  ${await encryptedSharedPreferences.getString('bioNumber')} pass is ${await encryptedSharedPreferences.getString('bioPass')}');
                                      //
                                      //   ///
                                      //   // print('phone${Utility.userPhone}');
                                      //   // Utility.userPhone = widget.phoneNumber!;
                                      //   // LoginResponseModel loginResponseModel =
                                      //   //     loginViewModel.loginApiResponse.data;
                                      //   // Utility.userId =
                                      //   //     loginResponseModel.userId.toString();
                                      //
                                      //   // Get.snackbar(
                                      //   //     'Success'.tr, 'OTP Send Successfully'.tr);
                                      //   // hideLoadingDialog(context: context);
                                      //   // final getAppSignature =
                                      //   //     await SmsAutoFill().getAppSignature;
                                      //   //
                                      //   // Future.delayed(Duration(seconds: 1), () {
                                      //   //   Get.to(() => OtpScreen(
                                      //   //         isRegistration: false,
                                      //   //         signature: getAppSignature,
                                      //   //       ));
                                      //   // });
                                      //
                                      //   // ///send otp api call
                                      //   // sendOtpReq.newCellnumber = Utility.mobNo;
                                      //   // await loginViewModel.sendOtp(sendOtpReq,
                                      //   //     context: context);
                                      //   //
                                      //   // if (loginViewModel.sendOtpApiResponse.status ==
                                      //   //     Status.COMPLETE) {
                                      //   //   print('phone${Utility.userPhone}');
                                      //   //   Utility.userPhone = widget.phoneNumber!;
                                      //   //   LoginResponseModel loginResponseModel =
                                      //   //       loginViewModel.loginApiResponse.data;
                                      //   //   Utility.userId =
                                      //   //       loginResponseModel.userId.toString();
                                      //   //
                                      //   //   Get.snackbar(
                                      //   //       'Success'.tr, 'OTP Send Successfully'.tr);
                                      //   //   hideLoadingDialog(context: context);
                                      //   //   final getAppSignature =
                                      //   //       await SmsAutoFill().getAppSignature;
                                      //   //
                                      //   //   Future.delayed(Duration(seconds: 1), () {
                                      //   //     Get.to(() => OtpScreen(
                                      //   //           isRegistration: false,
                                      //   //           signature: getAppSignature,
                                      //   //         ));
                                      //   //   });
                                      //   // } else {
                                      //   //   hideLoadingDialog(context: context);
                                      //   //   Get.snackbar(
                                      //   //     'error'.tr,
                                      //   //     'check data'.tr,
                                      //   //   );
                                      //   // }
                                      //
                                      //   ///
                                      // } else {
                                      //   hideLoadingDialog(context: context);
                                      //   Get.snackbar('error'.tr,
                                      //       'please provide valid phone number and password');
                                      // }
                                    } else {
                                      Get.snackbar('error',
                                          'please check internet connectivity');
                                    }
                                  } else {
                                    Get.snackbar('error',
                                        'please check internet connectivity');
                                  }
                                } else {
                                  Get.snackbar(
                                      'error'.tr, 'please fill data'.tr);
                                }
                              },
                              child: buildContainerWithoutImage(
                                  color: ColorsUtils.accent, text: 'Next'.tr));
                        },
                      ),
                      height20(),
                    ],
                  ),
                ),
              ));
  }

  Future<void> fetchProfileDetails() async {
    token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(
        '${Utility.baseUrl}users/findOne?filter[where][cellnumber]=${widget.phoneNumber}&[secured]=true');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print('token is $token');

    var result = await http.get(
      url,
      headers: header,
    );
    if (result.statusCode == 200) {
      print(result.body);

      final str2 = utf8.decode(base64.decode(jsonDecode(result.body)['data']));

      final text = CryptLib.instance
          .decryptCipherTextWithRandomIV(str2, "XDRvx?#Py^5V@3jC");
      print("DecryptedText ${text}");
      print("DecryptedText ${jsonDecode(text)['profilepic']}");
      print("DecryptedText ${jsonDecode(text)['name']}");
      //print("DecryptedText posactivated ${jsonDecode(text)['posactivated']}");
      await encryptedSharedPreferences.setString(
          'posActivatedDate', jsonDecode(text)['posactivated'] ?? "");
      profilePic = jsonDecode(text)['profilepic'];
      name = jsonDecode(text)['name'];
      //setState(() {});
    } else {
      hideLoadingDialog(context: context);
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
    isLoading = false;
    setState(() {});
  }

  Future<String?> deviceToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    Utility.deviceId = fcmToken!;
  }
}
