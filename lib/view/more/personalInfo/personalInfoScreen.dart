import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/changePassword.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessmodel.dart';
import 'package:sadad_merchat_app/widget/BusinessDetails.dart';

class PersonalInfoScreen extends StatefulWidget {
  final BusinessDataModel? model;
  PersonalInfoScreen({Key? key, this.model}) : super(key: key);

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  String userName = '';
  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  initData() async {
    userName = await encryptedSharedPreferences.getString('name');
    print('user Name$userName');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height24(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text("Personal Information".tr,
                style: ThemeUtils.blackSemiBold
                    .copyWith(fontSize: FontUtils.medLarge)),
          ),
          height36(),
          Obx(
            () => BusinessDetailsWidget(
                name: 'My Name'.tr,
                notification: 0,
                subName:
                    businessDetailCnt.businessInfoModel.value.businessname ??
                        userName,
                onTap: () async {
                  if (businessDetailCnt.businessInfoModel.value.userbusinessstatus?.id == 1 ||
                      businessDetailCnt
                              .businessInfoModel.value.userbusinessstatus?.id ==
                          3 ||
                      businessDetailCnt
                              .businessInfoModel.value.userbusinessstatus?.id ==
                          5) {
                    await businessDetailCnt.onFieldTap(
                        context: context,
                        title: 'Business name'.tr,
                        value: businessDetailCnt
                            .businessInfoModel.value.businessname!);
                  } else {
                    if (businessDetailCnt
                            .businessInfoModel.value.userbusinessstatus?.id ==
                        4) {
                      Get.snackbar(
                          'error', 'Business details are Under review');
                    }
                  }
                }),
          ),
          dividerData(),
          BusinessDetailsWidget(
            name: 'Change Password'.tr,
            notification: 0,
            subName: '*****'.tr,
            onTap: () {
              if (businessDetailCnt.businessInfoModel.value.userbusinessstatus?.id == 1 ||
                  businessDetailCnt
                          .businessInfoModel.value.userbusinessstatus?.id ==
                      3 ||
                  businessDetailCnt
                          .businessInfoModel.value.userbusinessstatus?.id ==
                      5) {
                Get.to(
                  ChangePassword(),
                );
              } else {
                if (businessDetailCnt
                        .businessInfoModel.value.userbusinessstatus?.id ==
                    4) {
                  Get.snackbar('error', 'Business details are Under review');
                }
              }
            },
          ),
          dividerData(),
          BusinessDetailsWidget(
              notification: 0,
              name: 'Status'.tr,
              subName: 'Admin'.tr,
              hideArrow: true),
          dividerData(),
        ],
      ),
    );
  }
}
