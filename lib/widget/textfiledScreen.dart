import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessmodel.dart';

class TextFieldDisplay extends StatefulWidget {
  TextFieldDisplay({Key? key}) : super(key: key);

  @override
  State<TextFieldDisplay> createState() => _TextFieldDisplayState();
}

class _TextFieldDisplayState extends State<TextFieldDisplay> {
  TextEditingController valueController = TextEditingController();

  final cnt = Get.find<BusinessInfoViewModel>();
  String type = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valueController = TextEditingController(text: Get.arguments[1]);
    type = Get.arguments[0];
  }

  Future<bool> sameValue(String value) async {
    print(value);
    print(cnt.businessDataModel.value.businessName);
    print(valueController.text);

    switch (value) {
      case "Business name":
        if (cnt.businessInfoModel.value.businessname != valueController.text) {
          print(true);
          return true;
        } else {
          print(false);
          return false;
        }
      case "Business Registration Number":
        if (cnt.businessInfoModel.value.merchantregisterationnumber !=
            valueController.text) {
          return true;
        } else {
          return false;
        }
      case "Email ID":
        if (cnt.businessInfoModel.value.user!.email != valueController.text) {
          return true;
        } else {
          return false;
        }
      // case "Mobile Number":
      //   if (cnt.businessInfoModel.value.mobileNumber != valueController.text) {
      //     print(true);
      //     return true;
      //   } else {
      //     print(false);
      //     return false;
      //   }
      default:
        return false;
    }
  }

  Future setValue() async {
    sameValue(type).then((value) {
      print(value);
      if (value == false) {
        Get.snackbar("error".tr, "Same value can not be allow".tr);
      } else {
        setValueToModel().then((value) {
          // print("valuevaluevaluevaluevalue $value");
          // print(
          //     "cnt.businessDataModel.value ${cnt.businessDataModel.value.merchantRegisTeRationNumber}");
          if (_formKey.currentState!.validate()) {
            Get.to(
              () => MoreOtpScreen(
                businessDataModel: cnt.businessDataModel.value,
                type: type,
              ),
            );
          } else {
            Get.snackbar('error'.tr, 'Please enter valid data'.tr);
          }
        });
      }
    });
  }

  Future setValueToModel() async {
    if (Get.arguments[0] == "Business name") {
      cnt.businessDataModel.value.businessName = valueController.text;
      print("Business name ${cnt.businessDataModel.value.businessName}");
    } else if (Get.arguments[0] == "Business Registration Number") {
      cnt.businessDataModel.value.merchantRegisTeRationNumber =
          valueController.text;
      print(
          "Business Registration Number ${cnt.businessDataModel.value.merchantRegisTeRationNumber}");
    } else if (Get.arguments[0] == "Email ID") {
      cnt.businessDataModel.value.email = valueController.text;
      print("Email ID ${cnt.businessDataModel.value.email}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: InkWell(
                onTap: setValue,
                child: buildContainerWithoutImage(
                    color: ColorsUtils.accent, text: "Save".tr)),
          ),
        ],
      ),
      appBar: commonAppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              height24(),
              commonTextField(
                hint: Get.arguments[0],
                keyType: Get.arguments[0] == "Business Registration Number"
                    ? TextInputType.number
                    : TextInputType.emailAddress,
                contollerr: valueController,
                regularExpression:
                    Get.arguments[0] == "Business Registration Number"
                        ? r'[0-9]'
                        : Get.arguments[0] == "Business name"
                            ? r'[a-z A-Z]'
                            : null,
                validationType: '',
                validator: (value) {
                  if (value!.isEmpty) {
                    return "${Get.arguments[0]} cannot be empty".tr;
                  } else {
                    if (Get.arguments[0] == "Email ID") {
                      String pattern =
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]+.com"
                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?)*$";
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value))
                        return 'Enter a valid email address';
                      else
                        return null;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
