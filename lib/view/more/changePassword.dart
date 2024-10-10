import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/viewModel/more/personalInfo/changePasswordViewModel.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool currentPass = true;
  bool pass = true;
  bool confirmPass = true;
  final _formKey = GlobalKey<FormState>();

  final cnt = Get.put(ChangePasswordViewModel());
  StaticData staticData = StaticData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    cnt.onChangePassword(context);
                  }
                  // } else {
                  //   Get.snackbar('error'.tr, 'Change Password Failed'.tr);
                  // }
                },
                child: buildContainerWithoutImage(
                    color: ColorsUtils.accent, text: "Save".tr)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height24(),
                commonTextField(
                    contollerr: cnt.currentPasswordCnt,
                    hint: 'Current password*'.tr,
                    maxLines: 1,
                    validationType: currentPass == true ? 'password' : '',
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          currentPass = !currentPass;
                        });
                      },
                      child: Image.asset(
                        currentPass == true
                            ? Images.password
                            : Images.accentEye,
                        scale: 2.5,
                      ),
                    ),
                    regularExpression: TextValidation.password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password cannot be empty".tr;
                      } else if (value != cnt.currentPasswordCnt.text) {
                        return "Current Password not valid".tr;
                      }
                      return null;
                    },
                    inputLength: 20),
                height20(),
                commonTextField(
                    contollerr: cnt.passwordCnt,
                    hint: 'Password*'.tr,
                    maxLines: 1,
                    validationType: pass == true ? 'password' : '',
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          pass = !pass;
                        });
                      },
                      child: Image.asset(
                        pass == true ? Images.password : Images.accentEye,
                        scale: 2.5,
                      ),
                    ),
                    regularExpression: TextValidation.password,
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return "Password cannot be empty".tr;
                      } else if (cnt.currentPasswordCnt.text ==
                          cnt.passwordCnt.text) {
                        return "Current password and new password can't be same"
                            .tr;
                      } else if (!regex.hasMatch(value)) {
                        return 'Enter valid password'.tr;
                      } else {
                        return null;
                      }

                      return null;
                    },
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
                    inputLength: 20),
                height20(),
                commonTextField(
                    contollerr: cnt.confirmPasswordCnt,
                    hint: 'Confirm Password*'.tr,
                    maxLines: 1,
                    validationType: confirmPass == true ? 'password' : '',
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          confirmPass = !confirmPass;
                        });
                      },
                      child: Image.asset(
                        confirmPass == true
                            ? Images.password
                            : Images.accentEye,
                        scale: 2.5,
                      ),
                    ),
                    regularExpression: TextValidation.password,
                    validator: (value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return "Password cannot be empty".tr;
                      } else if (cnt.passwordCnt.text !=
                          cnt.confirmPasswordCnt.text) {
                        return "New password and confirm password does not match"
                            .tr;
                      } else if (!regex.hasMatch(value)) {
                        return 'Enter valid password'.tr;
                      } else {
                        return null;
                      }
                    },
                    inputLength: 20),
                height24(),
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

  String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password'.tr;
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password'.tr;
      } else {
        return null;
      }
    }
  }
}
