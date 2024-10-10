import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';

import '../../../viewModel/more/businessInfo/businessmodel.dart';

class EditAddress extends StatefulWidget {
  final BusinessDataModel? businessDataModel;
  EditAddress({Key? key, this.businessDataModel}) : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  TextEditingController zone = TextEditingController();
  TextEditingController streetNo = TextEditingController();
  TextEditingController bldgNo = TextEditingController();
  TextEditingController unitNo = TextEditingController();
  final cnt = Get.find<BusinessInfoViewModel>();

  String type = "";
  @override
  void initState() {
    // TODO: implement initState
    type = Get.arguments[0];
    super.initState();
  }

  Future<bool> sameValue(String value) async {
    print(value);
    print(cnt.businessDataModel.value.businessName);
    if (Get.arguments[1] != zone.text ||
        Get.arguments[2] != streetNo.text ||
        Get.arguments[3] != bldgNo.text) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: ColorsUtils.white,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: InkWell(
                onTap: () async {
                  cnt.businessDataModel.value.zoneNumber = zone.text;
                  cnt.businessDataModel.value.streetNumber = streetNo.text;
                  cnt.businessDataModel.value.buildingNumber = bldgNo.text;
                  // cnt.businessDataModel.value.unitNo = unitNo.text;
                  sameValue(type).then((value) {
                    if (value == false) {
                      Get.snackbar(
                          "error".tr, "Same value can not be allow".tr);
                    } else {
                      if (_formKey.currentState!.validate()) {
                        Get.to(
                          () => MoreOtpScreen(
                            type: type,
                            businessDataModel: cnt.businessDataModel.value,
                          ),
                        );
                      } else {
                        Get.snackbar(
                            'error'.tr, 'Please provide valid details'.tr);
                      }
                    }
                  });
                },
                child: buildContainerWithoutImage(
                    color: ColorsUtils.accent, text: "Save".tr)),
          ),
        ],
      ),
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                height32(),
                commonTextField(
                  hint: 'Zone'.tr,
                  contollerr: zone..text = Get.arguments[1],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Zone cannot be empty".tr;
                    }
                    return null;
                  },
                ),
                height20(),
                Row(
                  children: [
                    commonTextField(
                      hint: 'Street no.'.tr,
                      width: 155,
                      contollerr: streetNo..text = Get.arguments[2],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Street cannot be empty".tr;
                        }
                        return null;
                      },
                    ),
                    Spacer(),
                    commonTextField(
                      hint: 'Bldg.no.'.tr,
                      width: 155,
                      contollerr: bldgNo..text = Get.arguments[3],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Bldg cannot be empty".tr;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                height20(),
                commonTextField(
                  hint: 'Unit no.'.tr,
                  contollerr: unitNo..text = Get.arguments[4],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Unit cannot be empty".tr;
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
