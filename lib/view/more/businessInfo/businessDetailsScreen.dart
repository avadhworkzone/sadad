import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/repo/more/businessInfo/businessInfoRepo.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/businessDocumentsScreen.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/businessDocumentsScreenOld.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/editAddress.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/widget/BusinessDetails.dart';
import 'package:sadad_merchat_app/widget/mobileTextfiled.dart';
import 'package:sadad_merchat_app/widget/textfiledScreen.dart';

import '../../../staticData/utility.dart';

class BusinessDetails extends StatefulWidget {
  BusinessDetails({Key? key}) : super(key: key);

  @override
  State<BusinessDetails> createState() => _BusinessDetailsState();
}

class _BusinessDetailsState extends State<BusinessDetails> {
  final cnt = Get.find<BusinessInfoViewModel>();
  BusinessInfoRepo businessInfoRepo = BusinessInfoRepo();

  @override
  void initState() {
    // print('value:::::${cnt.businessInfoModel.value.userbusinessstatus!.id}');
    // TODO: implement initState
    init();
    getdata();
    super.initState();
  }

  Future init() async {
    await cnt.getBusinessInfo(context);
    setState(() {
    });
  }

  Future<void> getdata() async {
    await cnt.getBusinessInfo(context);
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(
          () => cnt.isLoading.value
              ? Center(child: Lottie.asset(Images.slogo, width: 60, height: 60))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height24(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Business details'.tr,
                          style: ThemeUtils.blackSemiBold
                              .copyWith(fontSize: FontUtils.medLarge)),
                    ),
                    height32(),
                    BusinessDetailsWidget(
                        name: 'Business name'.tr,
                        notification: 0,
                        subName: cnt.businessInfoModel.value.businessname,
                        onTap: () async {
                          if (cnt.businessInfoModel.value.userbusinessstatus!.id == 1 ||
                              cnt.businessInfoModel.value.userbusinessstatus!
                                      .id ==
                                  3 ||
                              cnt.businessInfoModel.value.userbusinessstatus!
                                      .id ==
                                  5) {
                            await cnt.onFieldTap(
                                context: context,
                                title: 'Business name'.tr,
                                value:
                                    cnt.businessInfoModel.value.businessname ==
                                            null
                                        ? ""
                                        : cnt.businessInfoModel.value
                                            .businessname!);
                          } else {
                            Get.snackbar(
                                'error', 'Business details are Under review');
                          }
                        }),
                    dividerData(),
                    BusinessDetailsWidget(
                        name: 'Business Registration Number'.tr,
                        notification: 0,
                        subName: cnt.businessInfoModel.value
                            .merchantregisterationnumber,
                        onTap: () {
                          if (cnt.businessInfoModel.value.userbusinessstatus!.id == 1 ||
                              cnt.businessInfoModel.value.userbusinessstatus!
                                      .id ==
                                  3 ||
                              cnt.businessInfoModel.value.userbusinessstatus!
                                      .id ==
                                  5) {
                            cnt.onFieldTap(
                                context: context,
                                title: 'Business Registration Number'.tr,
                                value: cnt.businessInfoModel.value
                                            .merchantregisterationnumber ==
                                        null
                                    ? ""
                                    : cnt.businessInfoModel.value
                                        .merchantregisterationnumber!);
                          } else {
                            Get.snackbar(
                                'error', 'Business details are Under review');
                          }
                        }),
                    dividerData(),
                    BusinessDetailsWidget(
                        name: 'Email ID'.tr,
                        notification: 0,
                        subName: cnt.businessInfoModel.value.user?.email ?? "",
                        onTap: () {
                          if (cnt.businessInfoModel.value.userbusinessstatus!.id == 1 ||
                              cnt.businessInfoModel.value.userbusinessstatus!
                                      .id ==
                                  3 ||
                              cnt.businessInfoModel.value.userbusinessstatus!
                                      .id ==
                                  5) {
                            cnt.onFieldTap(
                                context: context,
                                title: 'Email ID'.tr,
                                value:
                                    cnt.businessInfoModel.value.user?.email ??
                                        "");
                          } else {
                            Get.snackbar(
                                'error', 'Business details are Under review');
                          }
                        }),
                    dividerData(),
                    BusinessDetailsWidget(
                      name: "Mobile Number".tr,
                      notification: 0,
                      subName:
                          "${Utility.countryCodeNumber} - ${cnt.businessInfoModel.value.user?.cellnumber ?? ""}",
                      onTap: () {
                        if (cnt.businessInfoModel.value.userbusinessstatus!.id == 1 ||
                            cnt.businessInfoModel.value.userbusinessstatus!
                                    .id ==
                                3 ||
                            cnt.businessInfoModel.value.userbusinessstatus!
                                    .id ==
                                5) {
                          Get.to(MobileTFScreen(
                            businessInfoModel: cnt.businessInfoModel.value,
                          ));
                        } else {
                          Get.snackbar(
                              'error', 'Business details are Under review');
                        }
                      },
                    ),
                    dividerData(),
                    InkWell(
                      onTap: () {
                        if (cnt.businessInfoModel.value.userbusinessstatus!.id == 1 ||
                            cnt.businessInfoModel.value.userbusinessstatus!
                                    .id ==
                                3 ||
                            cnt.businessInfoModel.value.userbusinessstatus!
                                    .id ==
                                5) {
                          cnt.onFieldTap(
                            context: context,
                            isAddress: true,
                            title: "Address".tr,
                            bldgNo:
                                cnt.businessInfoModel.value.buildingnumber ??
                                    "",
                            streetNo:
                                cnt.businessInfoModel.value.streetnumber ?? "",
                            zone: cnt.businessInfoModel.value.zonenumber ?? "",
                            unitNo: "27",
                          );
                        } else {
                          Get.snackbar(
                              'error', 'Business details are Under review');
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Text('Address'.tr,
                                    style: ThemeUtils.blackSemiBold
                                        .copyWith(fontSize: FontUtils.small)),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                          ),
                          height5(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              '${"Zone".tr} ${cnt.businessInfoModel.value.zonenumber ?? ""} \n${"Street no.".tr} ${cnt.businessInfoModel.value.streetnumber ?? ""} \n${'Bldg.no.'.tr} ${cnt.businessInfoModel.value.buildingnumber ?? ""} \n${"Unit no.".tr} NA',
                              // '${"Zone".tr} ${cnt.businessInfoModel.value.zonenumber ?? ""} \n${"Street no.".tr} ${cnt.businessInfoModel.value.streetnumber ?? ""} \n${'Bldg.no.'.tr} ${cnt.businessInfoModel.value.buildingnumber ?? ""} \n${"Unit no.".tr} NA',
                              style: ThemeUtils.blackRegular.copyWith(
                                  fontSize: FontUtils.verySmall, height: 2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    dividerData(),
                    BusinessDetailsWidget(
                        onTap: () async {
                          bool isNewDocSet = false;
                          if (cnt.businessInfoModel.value.businessmedia
                                  ?.length !=
                              0) {
                            for (int i = 0;
                                i <
                                    cnt.businessInfoModel.value.businessmedia!
                                        .length;
                                i++) {
                              if (cnt.businessInfoModel.value.businessmedia![i]
                                          .businessmediatypeId ==
                                      1 ||
                                  cnt.businessInfoModel.value.businessmedia![i]
                                          .businessmediatypeId ==
                                      2 ||
                                  cnt.businessInfoModel.value.businessmedia![i]
                                          .businessmediatypeId ==
                                      3 ||
                                  cnt.businessInfoModel.value.businessmedia![i]
                                          .businessmediatypeId ==
                                      4) {
                                isNewDocSet = true;
                                break;
                              }
                            }
                          }

                          if (cnt.businessInfoModel.value.userbusinessstatus!
                                      .id !=
                                  4 &&
                              cnt.businessInfoModel.value.userbusinessstatus!
                                      .id !=
                                  6) {
                            var result = await Get.to(
                                () => isNewDocSet
                                    ? BusinessDocumentsScreen()
                                    : BusinessDocumentsScreenOld(),
                                arguments:
                                    cnt.businessInfoModel.value.businessmedia);
                            if (result != null) {
                              print("resultresultresultresultresult $result");
                              cnt.isLoading.value = true;
                              // showLoadingDialog(context: context);
                              cnt.businessInfoModel.value =
                                  await businessInfoRepo
                                      .getBusinessInformation();
                              cnt.isLoading.value = false;
                              // hideLoadingDialog(context: context);
                            }
                          } else {
                            Get.snackbar(
                                'error', 'Business details are Under review');
                          }
                        },
                        name: 'Business Documents'.tr,
                        subName:
                            "${cnt.businessInfoModel.value.businessmedia?.length ?? "0"} ${'files added'.tr}"
                                .tr,
                        notification: 0),
                    dividerData(),
                  ],
                ),
        ),
      ),
    );
  }
}
