// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/view/auth/register/signatureScreen.dart';
import 'package:sadad_merchat_app/view/splash.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';

class SetYourPasswordScreen extends StatefulWidget {
  bool? isForgotPass;
  String? partnerID;

  SetYourPasswordScreen({Key? key, this.isForgotPass,this.partnerID}) : super(key: key);

  @override
  State<SetYourPasswordScreen> createState() => _SetYourPasswordScreenState();
}

class _SetYourPasswordScreenState extends State<SetYourPasswordScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  bool isVisible = true;
  bool isCVisible = true;
  ConnectivityViewModel connectivityViewModel = Get.find();

  StaticData staticData = StaticData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomButton(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height40(),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ),
                height30(),
                customMediumLargeBoldText(
                    title: 'Set your account password'.tr),
                height30(),
                commonTextField(
                    contollerr: password,
                    hint: widget.isForgotPass == true
                        ? 'New Password*'.tr
                        : 'Password*'.tr,
                    maxLines: 1,
                    validationType: isVisible == true ? 'password' : '',
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      child: Image.asset(
                        isVisible == true ? Images.password : Images.accentEye,
                        scale: 2.5,
                      ),
                    ),
                    onChange: (str) {
                      if (str.length >= 8) {
                        staticData.passwordRequirement[0]['select'] = true;
                        print('length${str.length}');
                        print(
                            'select${staticData.passwordRequirement[0]['select']}');
                      } else {
                        staticData.passwordRequirement[0]['select'] = false;
                      }
                      if (str.contains(RegExp(r'(?=.*[a-z])(?=.*[A-Z])'))) {
                        staticData.passwordRequirement[1]['select'] = true;
                      } else {
                        staticData.passwordRequirement[1]['select'] = false;
                      }
                      if (str.contains(
                          RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)'))) {
                        staticData.passwordRequirement[2]['select'] = true;
                      } else {
                        staticData.passwordRequirement[2]['select'] = false;
                      }
                      if (str.contains(RegExp(r'(?=.*\W)'))) {
                        staticData.passwordRequirement[3]['select'] = true;
                      } else {
                        staticData.passwordRequirement[3]['select'] = false;
                      }
                      setState(() {});
                    },
                    regularExpression: TextValidation.password,
                    validator: (str) {
                      String pattern =
                          r"(?=.*\d)(?=.*\W)(?=.*[a-z])(?=.*[A-Z]).{8,}";
                      RegExp regex = RegExp(pattern);
                      if (str == null || str.isEmpty || !regex.hasMatch(str))
                        return 'Enter a valid password';
                      else
                        return null;
                    },
                    inputLength: 20),
                height20(),
                commonTextField(
                    contollerr: cPassword,
                    hint: widget.isForgotPass == true
                        ? 'Confirm New Password*'.tr
                        : 'Confirm Password*'.tr,
                    maxLines: 1,
                    validationType: isCVisible == true ? 'password' : '',
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          isCVisible = !isCVisible;
                        });
                      },
                      child: Image.asset(
                        isCVisible == true ? Images.password : Images.accentEye,
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
                height20(),
                customSmallMedBoldText(
                  color: ColorsUtils.black,
                  title: 'Password requirements'.tr,
                ),
                height20(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: StaticData().passwordRequirement.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        staticData.passwordRequirement[index]['select'] == true
                            ? Image.asset(
                                Images.check,
                                height: 14,
                                width: 14,
                                color: ColorsUtils.green,
                              )
                            : customMediumBoldText(
                                title: '*', color: ColorsUtils.border),
                        width20(),
                        Expanded(
                          child: customSmallSemiText(
                              title: staticData.passwordRequirement[index]
                                  ['title']),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column bottomButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                connectivityViewModel.startMonitoring();

                if (connectivityViewModel.isOnline != null) {
                  if (connectivityViewModel.isOnline!) {
                    if (staticData.passwordRequirement[3]['select'] == true &&
                        staticData.passwordRequirement[2]['select'] == true &&
                        staticData.passwordRequirement[1]['select'] == true &&
                        staticData.passwordRequirement[0]['select'] == true) {
                      if (password.text == cPassword.text) {
                        if (widget.isForgotPass == true) {
                          forgotPasswordApiCall();
                        } else {
                          await passwordApiCall();
                        }
                      } else {
                        Get.snackbar(
                            'error', "password didn't match. Try again");
                      }
                    } else {
                      Get.snackbar('error', 'Please check Password');
                    }
                  } else {
                    Get.snackbar('error', 'please check internet connectivity');
                  }
                } else {
                  Get.snackbar('error', 'please check internet connectivity');
                }
              }
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Next'.tr),
          ),
        )
      ],
    );
  }

  Future<void> passwordApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}users/reset-password');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    Map<String, dynamic> body = {"newPassword": password.text};
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    print('req is $body');
    print('header$header');

    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 && result.statusCode >= 200) {
      Utility.password = password.text;
      print('ok done');
      Get.snackbar('success', 'Password set Successfully');
      // widget.isForgotPass == true
      //     ? Get.offAll(() => SplashScreen())
      //     :
      Get.to(() => SignatureScreen(partnerID: widget.partnerID,));
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }

  Future<void> forgotPasswordApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}users/resetPwd');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    Map<String, dynamic> body = {"newPassword": password.text};
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    print('req is $body');
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 && result.statusCode >= 200) {
      print('ok done');
      Get.snackbar('success', 'Password reset Successfully');
      Get.offAll(() => SplashScreen());
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }
}