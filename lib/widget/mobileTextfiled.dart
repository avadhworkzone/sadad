import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessmodel.dart';
import 'package:sadad_merchat_app/widget/textfiledScreen.dart';

import '../model/apimodels/responseModel/more/businessInfomodel.dart';
import '../viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:http/http.dart' as http;

class MobileTFScreen extends StatefulWidget {
  final BusinessInfoResponseModel? businessInfoModel;
  const MobileTFScreen({Key? key, this.businessInfoModel}) : super(key: key);

  @override
  State<MobileTFScreen> createState() => _MobileTFScreenState();
}

class _MobileTFScreenState extends State<MobileTFScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileNumber = TextEditingController();
  final cnt = Get.find<BusinessInfoViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileNumber =
        TextEditingController(text: widget.businessInfoModel!.user?.cellnumber??"");
  }

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
                  checkMobileApiCall();
                } else {
                  Get.snackbar("error".tr, "Please enter valid data".tr);
                }
              },
              child: buildContainerWithoutImage(
                color: ColorsUtils.accent,
                text: "Save".tr,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              height24(),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Container(
                      height: Get.width * 0.13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: ColorsUtils.border, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.book,
                              color: ColorsUtils.maroon70122E,
                            ),
                            customSmallSemiText(
                                title: Utility.countryCodeNumber),
                          ],
                        ),
                      ),
                    ),
                    width10(),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        child: commonTextField(
                            contollerr: mobileNumber,
                            hint: 'Mobile Number'.tr,
                            validationType: '',
                            keyType: TextInputType.phone,
                            regularExpression:
                                TextValidation.digitsValidationPattern,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Mobile Number cannot be empty".tr;
                              } else if (value ==
                                  widget.businessInfoModel!.user!.cellnumber) {
                                return "Same value can not be allow".tr;
                              }
                              return null;
                            },
                            inputLength: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkMobileApiCall() async {
    showLoadingDialog(context: context);
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(
        '${Utility.baseUrl}users/count?where[cellnumber]=${mobileNumber.text}&where[agreement]=true');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.get(
      url,
      headers: header,
    );
    if (result.statusCode == 200) {
      if (jsonDecode(result.body)['count'] >= 1) {
        hideLoadingDialog(context: context);

        Get.snackbar('error', 'number already exist!!');
      } else {
        hideLoadingDialog(context: context);
        cnt.businessDataModel.value.mobileNumber = mobileNumber.text;
        Get.to(() => MoreOtpScreen(
              businessDataModel: cnt.businessDataModel.value,
              type: "Mobile number",
            ));
      }
    }
  }
}
