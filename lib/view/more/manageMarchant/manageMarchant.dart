import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/controller/merchantInformationController.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:dio/dio.dart' as dio;

import 'package:sadad_merchat_app/model/services/base_service.dart';
import 'package:sadad_merchat_app/view/home.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/documentRegisterScreen/AppDialog.dart';
import 'package:sadad_merchat_app/view/more/manageMarchant/createNewSubMarchant/createSubMarchantInsert.dart';

import '../../../model/apimodels/responseModel/subMerchantListModel.dart';
import '../../../staticData/utility.dart';
import '../../../viewModel/more/businessInfo/businessInfoViewModel.dart';
import '../../auth/register/TermsAndConditionRegister.dart';
import 'TermsAndConditionLinkMarchant.dart';
import 'manageMerchantOTP.dart';

class ManageMarchant extends StatefulWidget {
  BusinessInfoViewModel? bussinessDetails;
  bool fromMoreScreen;

  ManageMarchant({Key? key, this.bussinessDetails, required this.fromMoreScreen}) : super(key: key);

  @override
  State<ManageMarchant> createState() => _ManageMarchantState();
}

class _ManageMarchantState extends State<ManageMarchant> with BaseService {
  @override
  List<SubMerchantModel> subMerchantList = [];
  TextEditingController emailId = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController sadadIdForLink = TextEditingController();
  String token = "";
  String sadadId = "";
  final formKeyForLinkMerchant = GlobalKey<FormState>();
  final formKeyForUnlinkMerchant = GlobalKey<FormState>();
  SubMerchantModel primaryMarchant = SubMerchantModel();
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  MerchantInformationController merchantInformationController = Get.put(MerchantInformationController());
  String noDataFoundMessage = "";
  initState() {
    getSubMarchantList();
    getData();
    super.initState();
  }

  getData() async {
    sadadId = await encryptedSharedPreferences.getString('sadadId');
    token = await encryptedSharedPreferences.getString('token');
  }

  Widget build(BuildContext context) {
    return GetBuilder(
        init: MerchantInformationController(),
        builder: (MerchantInformationController controller) {
          return WillPopScope(
            onWillPop: () {
              if (widget.fromMoreScreen) {
                Get.back();
              } else {
                Get.find<HomeController>().bottomIndex = 4;
                Get.offAll(HomeScreen());
              }
              return Future.value(true);
            },
            child: Scaffold(
                appBar: AppBar(
                    title: Text("Manage Merchants".tr, style: TextStyle(fontSize: FontUtils.medLarge, fontWeight: FontWeight.w600)),
                    leading: InkWell(
                        onTap: () {
                          if (widget.fromMoreScreen) {
                            Get.back();
                          } else {
                            Get.find<HomeController>().bottomIndex = 4;
                            Get.offAll(HomeScreen());
                          }
                        },
                        child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 25)),
                    backgroundColor: Colors.white,
                    elevation: 0),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(children: [
                      Row(
                        children: [
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                sadadIdForLink.text = "";
                                MerchantInformationController controller = Get.find<MerchantInformationController>();
                                controller.linkMessage.value = "";
                                controller.isTermsAndConditionsCheck.value = false;
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        color: Colors.transparent,

                                        child: Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 40,right: 18),
                                              child: Container(
                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),boxShadow: [
                                                  BoxShadow(
                                                      color: ColorsUtils.accent.withOpacity(0.3),
                                                      blurRadius: 3,
                                                      offset: Offset(0, 4),
                                                      spreadRadius: 3)
                                                ],),
                                                padding: EdgeInsets.all(Get.width * .07),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: Get.height * .01,
                                                    ),
                                                    Text(
                                                      "Link Merchant".tr,
                                                      style: TextStyle(color: const Color(0xff8E1B3E), fontSize: Get.textScaleFactor * 16, fontWeight: FontWeight.w700),
                                                    ),
                                                    SizedBox(
                                                      height: Get.height * .01,
                                                    ),
                                                    SizedBox(
                                                      height: Get.height * .02,
                                                    ),
                                                    Form(
                                                      key: formKeyForLinkMerchant,
                                                      child: commonTextField(
                                                        inputLength: 8,
                                                        onChange: (str) {},
                                                        contollerr: sadadIdForLink,
                                                        keyType: TextInputType.number,
                                                        hint: "Marchant Sadad ID".tr,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return "Marchant Sadad ID cannot be empty".tr;
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: Get.height * .02,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Obx(() => InkWell(
                                                              onTap: () {
                                                                controller.isTermsAndConditionsCheck.value = !controller.isTermsAndConditionsCheck.value;
                                                              },
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: ColorsUtils.black)),
                                                                child: controller.isTermsAndConditionsCheck.value
                                                                    ? Center(
                                                                        child: Image.asset(
                                                                          Images.GreenCheck,
                                                                          width: 20,
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                              ),
                                                            )),
                                                        width10(),
                                                        Expanded(
                                                          child: RichText(
                                                              maxLines: 6,
                                                              text: TextSpan(children: [
                                                                TextSpan(
                                                                    text: 'I hereby acknowledge that I have read, understood and agree to the'.tr,
                                                                    style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.verySmall, color: ColorsUtils.black)),
                                                                TextSpan(text: " "),
                                                                TextSpan(
                                                                    recognizer: TapGestureRecognizer()
                                                                      ..onTap = () {
                                                                        Get.to(() => TermsAndConditionLinkMarchant());
                                                                      },
                                                                    text: 'Terms and conditions'.tr,
                                                                    style:
                                                                        ThemeUtils.blackBold.copyWith(decoration: TextDecoration.underline, fontSize: FontUtils.verySmall, color: ColorsUtils.accent)),
                                                              ])),
                                                        ),
                                                        // customVerySmallSemiText(title: 'I hereby acknowledge that I have read, understood and agree to the'.tr),
                                                        // // width5(),
                                                        // InkWell(
                                                        //   onTap: () {
                                                        //     Get.to(() => TermsAndConditionLinkMarchant());
                                                        //   },
                                                        //   child: Text(' ${'Terms and conditions'.tr}',
                                                        //       style: ThemeUtils.blackBold.copyWith(decoration: TextDecoration.underline, fontSize: FontUtils.verySmall, color: ColorsUtils.accent)),
                                                        // ),
                                                      ],
                                                    ),
                                                    Obx(
                                                      () {
                                                        if (Get.find<MerchantInformationController>().linkMessage.value.isNotEmpty) {
                                                          return Column(
                                                            children: [
                                                              height12(),
                                                              Text(Get.find<MerchantInformationController>().linkMessage.value,
                                                                  style: TextStyle(color: ColorsUtils.accent, fontSize: Get.textScaleFactor * 16)),
                                                            ],
                                                          );
                                                        } else {
                                                          return SizedBox();
                                                        }
                                                      },
                                                    ),
                                                    height20(),
                                                    MaterialButton(
                                                      onPressed: () {
                                                        if (formKeyForLinkMerchant.currentState!.validate()) {
                                                          if (controller.isTermsAndConditionsCheck.value) {
                                                            linkMarchant();
                                                          } else {
                                                            Get.snackbar('Required', 'Please agree with terms and condition given below.', backgroundColor: ColorsUtils.white);
                                                          }
                                                        }
                                                      },
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                      color: const Color(0xff8E1B3E),
                                                      height: Get.height * .060,
                                                      minWidth: Get.width * .80,
                                                      child: Text("Confirm".tr, style: TextStyle(color: Colors.white, fontSize: Get.textScaleFactor * 16)),
                                                    ),
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
                                            Container(
                                              height: 67,
                                              width: 67,
                                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff8E1B3E)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Image.asset(
                                                  Images.link,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              height: 45,
                                              width: 45,
                                              right: 0,
                                              top: 20,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(0.0),
                                                  child: Image.asset(
                                                    Images.closeBlackWhiteBack,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: commonIconButton(
                                  height: 40,
                                  width: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      Images.linkSubMarchant,
                                      height: 20,
                                      width: 20,
                                    ),
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  Get.to(() => createMarchantInsertScreen(
                                        bussinessDetails: businessDetailCnt,
                                      ));
                                },
                                child: commonIconButton(
                                    height: 40,
                                    width: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        Images.addSubMarchant,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ))),
                          ),
                        ],
                      ),
                      subMerchantList.length > 0 ?
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: subMerchantList.length,
                        itemBuilder: (context, index) {
                          return primaryMarchant == subMerchantList[index]
                              ? SizedBox()
                              : Obx(() => Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: controller.selectedTile.value == index ? Color(0x9EE0DBDA) : Color(0xFFE4E7EB)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: controller.selectedTile.value == index ? ColorsUtils.accent.withOpacity(0.3) : Color(0xFFE4E7EB),
                                              blurRadius: 3,
                                              offset: Offset(0, 3),
                                              spreadRadius: 3)
                                        ]),
                                    padding: const EdgeInsets.all(17),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(
                                        children: [
                                          // CircleAvatar(
                                          //     backgroundImage: NetworkImage('${Utility.baseUrl}containers/api-businesslogo/download/${subMerchantList[index].profilepic.toString()}?access_token=${token}'),
                                          //     backgroundColor: Colors.white,
                                          //     radius: 20),
                                          CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 20,
                                            child: subMerchantList[index].profilepic == null
                                                ? Image.network(
                                                    "https://sadad.qa/wp-content/uploads/2022/02/Color-Logo.png",
                                                    fit: BoxFit.scaleDown,
                                                    height: 40,
                                                    width: 40,
                                                  )
                                                : Image.network(
                                                    "${Utility.baseUrl}containers/api-businesslogo/download/${subMerchantList[index].profilepic.toString()}?access_token=${token}",
                                                    fit: BoxFit.scaleDown,
                                                    height: 40,
                                                    width: 40,
                                                  ),
                                          ),
                                          const SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              controller.selectedTile.value == index
                                                  ? Text("Sadad ID".tr + " : ${subMerchantList[index].sadadId}",
                                                      style: TextStyle(fontSize: FontUtils.verySmall, fontWeight: FontWeight.w400, color: Color(0xFF000000).withOpacity(0.5)))
                                                  : Text("${subMerchantList[index].name}", style: TextStyle(fontSize: FontUtils.small, fontWeight: FontWeight.w500, color: Color(0xFF000000))),
                                              if (controller.selectedTile.value != index) const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  controller.selectedTile.value == index
                                                      ? Text("${subMerchantList[index].name}", style: TextStyle(fontSize: FontUtils.small, fontWeight: FontWeight.w500, color: Color(0xFF000000)))
                                                      : Text("Sadad ID".tr + " : ${subMerchantList[index].sadadId}",
                                                          style: TextStyle(fontSize: FontUtils.verySmall, fontWeight: FontWeight.w400, color: Color(0xFF000000).withOpacity(0.5))),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              (subMerchantList[index].parentmerchantId != null && subMerchantList[index].linkmerchantverificationstatusId != 2)
                                                  ? SizedBox()
                                                  : Text("Link Request".tr + " : "  + "Pending for Approval".tr,
                                                      style: TextStyle(fontSize: FontUtils.verySmall, fontWeight: FontWeight.w400, color: ColorsUtils.accent)),
                                            ],
                                          ),
                                          const Spacer(),
                                          subMerchantList[index].parentmerchantId != null
                                              ? InkWell(
                                                  onTap: () {
                                                    unlinkDialog(index: index);
                                                  },
                                                  child: Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Image.asset(
                                                        Images.unLinkSubMarchant,
                                                        height: 25,
                                                        width: 25,
                                                      ),
                                                    ),
                                                    height: controller.selectedTile.value != index ? 30 : 35,
                                                    width: controller.selectedTile.value != index ? 30 : 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(color: Color(0xFFDADCE0)),
                                                        color: Colors.white,
                                                        boxShadow: [BoxShadow(color: Color(0xFF8E1B3E).withOpacity(0.5), offset: Offset(0, 3), blurRadius: 5)]),
                                                  ),
                                                )
                                              : SizedBox(),
                                          const SizedBox(width: 10),
                                          if (controller.selectedTile.value != index)
                                            InkWell(
                                              onTap: () {
                                                if (subMerchantList[index].parentmerchantId != null && subMerchantList[index].linkmerchantverificationstatusId != 2) {
                                                  controller.selectedTile.value = index;
                                                }
                                              },
                                              child: Container(
                                                child: (subMerchantList[index].parentmerchantId != null && subMerchantList[index].linkmerchantverificationstatusId != 2) ? Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF202020).withOpacity(0.2)) : SizedBox(),
                                                height: 30,
                                                width: 30,
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (controller.selectedTile.value == index)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 5),
                                            subMerchantList[index].linkedAt != null
                                                ? Text(
                                                    "Linked Date :".tr + " ${dateformatChange(subMerchantList[index].linkedAt?.toString() ?? "")}",
                                                    style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall),
                                                  )
                                                : SizedBox(),
                                            const Divider(color: Colors.black, height: 15),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Available Balance".tr,
                                                      style: TextStyle(color: Color(0xFF121212), fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          subMerchantList[index].usermetapersonals?.totalavailablefunds?.toString() ?? "",
                                                          style: TextStyle(
                                                            color: Color(0xFF8E1B3E),
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.5,
                                                            fontSize: FontUtils.mediumSmall,
                                                          ),
                                                        ),
                                                        Text(
                                                          " QAR",
                                                          style: TextStyle(
                                                            color: Color(0xFF8E1B3E),
                                                            fontWeight: FontWeight.w600,
                                                            height: 1.5,
                                                            fontSize: 8,
                                                            fontFeatures: [
                                                              FontFeature.superscripts(),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      "CR Number".tr,
                                                      style: TextStyle(color: Color(0xFF121212), fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall),
                                                    ),
                                                    subMerchantList[index].userbusinesses!.length > 0
                                                        ? Text(
                                                            subMerchantList[index].userbusinesses?[0].merchantregisterationnumber.toString() ?? "",
                                                            style: TextStyle(color: Color(0xFF000000).withOpacity(0.5), fontWeight: FontWeight.w600, fontSize: FontUtils.verySmall),
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.email_outlined, color: ColorsUtils.accent, size: 20),
                                                const SizedBox(width: 7),
                                                Text(
                                                  "${subMerchantList[index].email.toString()}",
                                                  style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.call, color: ColorsUtils.accent, size: 20),
                                                const SizedBox(width: 7),
                                                Text(
                                                  "${subMerchantList[index].cellnumber.toString()}",
                                                  style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text("Business Status".tr, style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall)),
                                                    const SizedBox(height: 6),
                                                    Container(
                                                      height: 25,
                                                      width: 95,
                                                      decoration: BoxDecoration(
                                                          color: getAccountStatusColor(provideBusinessStatusOverall(subMerchantList[index].userbusinesses)), borderRadius: BorderRadius.circular(15)),
                                                      child: Center(
                                                        child: Text(getAccountStatusNameString(provideBusinessStatusOverall(subMerchantList[index].userbusinesses)),
                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(width: 20),
                                                subMerchantList[index].userbanks != null
                                                    ? Column(
                                                        children: [
                                                          Text("Bank Status".tr, style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall)),
                                                          const SizedBox(height: 6),
                                                          Container(
                                                            height: 25,
                                                            width: 95,
                                                            decoration: BoxDecoration(
                                                                color: getAccountStatusColor(provideBankStatusOverall(subMerchantList[index].userbanks) ?? ""),
                                                                borderRadius: BorderRadius.circular(15)),
                                                            child: Center(
                                                              child: Text(getAccountStatusNameString(provideBankStatusOverall(subMerchantList[index].userbanks) ?? ""),
                                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: FontUtils.verySmall)),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : SizedBox(),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () {
                                                    controller.selectedTile.value = 99999;
                                                  },
                                                  child: Container(
                                                    child: const Icon(Icons.keyboard_arrow_up_rounded, color: ColorsUtils.accent),
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                    ]),
                                  ));
                        },
                      ) : Center(child: Text(noDataFoundMessage.tr))
                    ]),
                  ),
                )),
          );
        });
  }

  unlinkDialog({required int index}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40,right: 15),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),boxShadow: [
                    BoxShadow(
                    color: ColorsUtils.accent.withOpacity(0.3),
                      blurRadius: 3,
                      offset: Offset(0, 4),
                      spreadRadius: 3)
              ]),
                    padding: EdgeInsets.all(Get.width * .07),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: Get.height * .01,
                        ),
                        Text(
                          "Unlink Merchant".tr,
                          style: TextStyle(color: const Color(0xff8E1B3E), fontSize: Get.textScaleFactor * 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: Get.height * .02,
                        ),
                        Text("Do you want to unlink the merchant account?".tr, style: TextStyle(), textAlign: TextAlign.center),
                        SizedBox(
                          height: Get.height * .03,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Get.back();
                            if (primaryMarchant.cellnumber == subMerchantList[index].cellnumber || primaryMarchant.email == subMerchantList[index].email) {
                              bool isMobileShow = (primaryMarchant.cellnumber == subMerchantList[index].cellnumber);
                              bool isEmailShow = (primaryMarchant.email == subMerchantList[index].email);
                              unlinkAlertDialog(index, isMobileShow, isEmailShow);
                            } else {
                              print("test");
                              unLinkMarchant(subMerchantList[index].sadadId.toString(), false, false);
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          color: const Color(0xff8E1B3E),
                          height: Get.height * .065,
                          minWidth: Get.width * .4,
                          child: Text("Confirm".tr, style: TextStyle(color: Colors.white, fontSize: Get.textScaleFactor * 16)),
                        ),
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
                Container(
                  height: 67,
                  width: 67,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff8E1B3E)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      Images.unLinkMarchantWhite,
                      height: 15,
                      width: 15,
                    ),
                  ),
                ),
                Positioned(
                  height: 45,
                  width: 45,
                  right: 0,
                  top: 20,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset(
                        Images.closeBlackWhiteBack,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  unlinkAlertDialog(int index, bool isMobileShow, bool isEmailShow) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                GetBuilder(
                    init: MerchantInformationController(),
                    builder: (MerchantInformationController controller) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 40,right: 15),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),boxShadow: [
                            BoxShadow(
                                color: ColorsUtils.accent.withOpacity(0.3),
                                blurRadius: 3,
                                offset: Offset(0, 4),
                                spreadRadius: 3)
                          ]),
                          padding: EdgeInsets.all(Get.width * .07),
                          child: Form(
                              key: formKeyForUnlinkMerchant,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: Get.height * .01,
                                  ),
                                  Text(
                                    "Alert".tr,
                                    style: TextStyle(color: const Color(0xff8E1B3E), fontSize: Get.textScaleFactor * 16, fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: Get.height * .01,
                                  ),
                                  Text("You need to change the mobile number & email id before unlinking the merchant account".tr,
                                      style: TextStyle(color: ColorsUtils.grey, fontSize: Get.textScaleFactor * 12, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                                  SizedBox(
                                    height: Get.height * .02,
                                  ),
                                  isMobileShow
                                      ? commonTextField(
                                          errorText: merchantInformationController.mobileError,
                                          inputLength: 8,
                                          onChange: (str) {
                                            bool mobileChange = false;
                                            print(mobileChange);
                                            if (str.length >= 8) {
                                              checkMobileNumber();
                                            }
                                          },
                                          contollerr: mobileNumber,
                                          keyType: TextInputType.number,
                                          hint: "Cell Number".tr,
                                          validator: (value) {
                                            if (merchantInformationController.mobileError != null) {
                                              return merchantInformationController.mobileError;
                                            }
                                            if (value!.isEmpty) {
                                              return "Mobile Number cannot be empty".tr;
                                            } else if (value.length < 8) {
                                              return "Invalid Mobile Number.".tr;
                                            } else {
                                              return null;
                                            }
                                          },
                                        )
                                      : SizedBox(),
                                  height20(),
                                  isEmailShow
                                      ? commonTextField(
                                          errorText: merchantInformationController.emailError,
                                          onChange: (str) {
                                            if (str.contains("@")) {
                                              checkEmail();
                                            }
                                          },
                                          contollerr: emailId,
                                          hint: "Email id".tr,
                                          validator: (value) {
                                            if (merchantInformationController.emailError != null) {
                                              return merchantInformationController.emailError;
                                            }
                                            if (value!.isEmpty) {
                                              return "Email ID cannot be empty".tr;
                                            } else {
                                              String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                              RegExp regex = RegExp(pattern);
                                              if (!regex.hasMatch(value))
                                                return 'Enter a valid email address'.tr;
                                              else
                                                return null;
                                            }
                                          },
                                        )
                                      : SizedBox(),
                                  height30(),
                                  MaterialButton(
                                    onPressed: () {
                                      if (formKeyForUnlinkMerchant.currentState!.validate()) {
                                        unLinkMarchant(subMerchantList[index].sadadId.toString(), isMobileShow, isEmailShow);
                                      }
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    color: const Color(0xff8E1B3E),
                                    height: Get.height * .065,
                                    minWidth: Get.width * .4,
                                    child: Text("Confirm".tr, style: TextStyle(color: Colors.white, fontSize: Get.textScaleFactor * 16)),
                                  ),
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
                              )),
                        ),
                      );
                    }),
                Container(
                  height: 67,
                  width: 67,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff8E1B3E)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      Images.unLinkAlertWhite,
                      height: 15,
                      width: 15,
                    ),
                  ),
                ),
                Positioned(
                  height: 45,
                  width: 45,
                  right: 0,
                  top: 20,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Image.asset(
                        Images.closeBlackWhiteBack,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  errorDialoag(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.all(Get.width * .07),
                    child: Form(
                        key: formKeyForUnlinkMerchant,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: Get.height * .01,
                            ),
                            Text(
                              "error".tr,
                              style: TextStyle(color: const Color(0xff8E1B3E), fontSize: Get.textScaleFactor * 16, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: Get.height * .01,
                            ),
                            Text(message, style: TextStyle(color: ColorsUtils.grey, fontSize: Get.textScaleFactor * 12, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                "Okay".tr,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
                Container(
                  height: 67,
                  width: 67,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff8E1B3E)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      Images.unLinkAlertWhite,
                      height: 15,
                      width: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget commonIconButton({required double height, required double width, required Widget child}) {
    return Container(
      child: child,
      height: height,
      width: width,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [BoxShadow(blurRadius: 5, color: ColorsUtils.accent.withOpacity(0.5), offset: Offset(0, 3))]),
    );
  }

  String provideBankStatusOverall(List<Userbanks>? bankList) {
    if (bankList != null) {
      for (int i = 0; i < bankList.length; i++) {
        if (bankList[i].userbankstatusId.toString() == "3") {
          return "3";
        }
      }
      for (int i = 0; i < bankList.length; i++) {
        if (bankList[i].userbankstatusId.toString() == "4" || bankList[i].userbankstatusId.toString() == "6") {
          return "4";
        }
      }
      for (int i = 0; i < bankList.length; i++) {
        if (bankList[i].userbankstatusId.toString() == "1") {
          return "1";
        }
      }
    }
    return "2";
  }

  String provideBusinessStatusOverall(List<Userbusinesses>? businessList) {
    if (businessList != null) {
      for (int i = 0; i < businessList.length; i++) {
        if (businessList[i].userbusinessstatusId.toString() == "3") {
          return "3";
        }
      }
      for (int i = 0; i < businessList.length; i++) {
        if (businessList[i].userbusinessstatusId.toString() == "4" || businessList[i].userbusinessstatusId.toString() == "6") {
          return "4";
        }
      }
      for (int i = 0; i < businessList.length; i++) {
        if (businessList[i].userbusinessstatusId.toString() == "1") {
          return "1";
        }
      }
    }
    return "2";
  }

  String dateformatChange(String? date) {
    if (date == null || date == '') {
      return '';
    } else {
      date = date;
      DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd MMM yyyy | HH:mm:ss');
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    }
  }

   getSubMarchantList() async {
    dio.Dio _dio = dio.Dio();
    String token = await encryptedSharedPreferences.getString('token');
    var response = await _dio.get(baseURL + "users/submerchantList",
        options: dio.Options(
          headers: {"Authorization": token},
        ));

    log("response:::${response.data}");
    if (response.statusCode == 200) {
      subMerchantList.clear();
      response.data.forEach((element) {
        subMerchantList.add(SubMerchantModel.fromJson(element));
      });
      bool submarchantFounded = false;
      for (int i = 0; i < subMerchantList.length; i++) {
        if (subMerchantList[i].parentmerchantId == null && subMerchantList[i].linkmerchantverificationstatusId != 2) {
          primaryMarchant = subMerchantList[i];
        }
        if (subMerchantList[i].parentmerchantId != null && subMerchantList[i].linkmerchantverificationstatusId != 2) {
          await encryptedSharedPreferences.setString('isSubmerchantEnabled','true');
          await encryptedSharedPreferences.setString('isSubMarchantAvailable','true');
          submarchantFounded = true;
        }
      }
      if(submarchantFounded == false) {
        await encryptedSharedPreferences.setString('isSubMarchantAvailable','false');
      }
      noDataFoundMessage = "No data found";
      setState(() {});
      log("subMerchantList:::${subMerchantList}");
    }
  }

  linkMarchant() async {

    ///api-v1/usermetaauths/resendOtp?type=linkmerchantotp&linkMerchantSadadId=3291461
    try {
      dio.Dio _dio = dio.Dio();
      String token = await encryptedSharedPreferences.getString('token');
      var response = await _dio.get(baseURL + "usermetaauths/resendOtp?type=linkmerchantotp&linkMerchantSadadId=${sadadIdForLink.text}",
          options: dio.Options(
            headers: {"Authorization": token},
          ));

      log("response:::${response.data}");

      if (response.statusCode == 200) {
        // if (response.data["result"] == true) {
        var message = response.data["result"];
        Get.back();
        getSubMarchantList();
        return showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'.tr),
                content: Text(message.runtimeType == String ? message : ""),
                actions: <Widget>[
                  TextButton(
                      child: Text('Okay'.tr),
                      onPressed: () async {
                        Get.back();
                      }),
                ],
              );
            });
        getSubMarchantList();
        // Get.to(() => ManageMerchantOTP(
        //       sadadId: sadadIdForLink.text,
        //     ))?.then((value) {
        //   getSubMarchantList();
        // });
        setState(() {});
        log("subMerchantList:::${subMerchantList}");
        // }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        //Get.back();
        Get.find<MerchantInformationController>().linkMessage.value = e.response?.data['error']['message'];
        print(e.message);
        // Future.delayed(Duration(seconds: 1), (){
        //   Get.snackbar('error', '${jsonDecode(e.response?.data)['error']['message']}',duration: Duration(seconds: 2));
        // });
        // Future.delayed(Duration(seconds: 1), ()
        // {
        //   errorDialoag(jsonDecode(e.response?.data)['error']['message']);
        // });
      }
    }
  }

  unLinkMarchant(String sadadId, bool isMobileShow, bool isEmailShow) async {
    try {
      dio.Dio _dio = dio.Dio();
      String token = await encryptedSharedPreferences.getString('token');
      var response = await _dio.get(baseURL + "usermetaauths/resendOtp?type=unlinkmerchantotp",
          options: dio.Options(
            headers: {"Authorization": token},
          ));

      log("response:::${response.data}");
      if (response.statusCode == 200) {
        if (response.data["result"] == true) {
          Get.back();
          Get.snackbar('success'.tr, 'OTP Send SuccessFully'.tr);
          if (isMobileShow && isEmailShow) {
            Get.to(() => ManageMerchantOTP(
                  sadadId: sadadId,
                  isUnlink: true,
                  unlinkCell: mobileNumber.text.toString(),
                  unlinkEmail: emailId.text.toString(),
                ))?.then((value) {
              getSubMarchantList();
            });
          } else if (isMobileShow) {
            Get.to(() => ManageMerchantOTP(
                  sadadId: sadadId,
                  isUnlink: true,
                  unlinkCell: mobileNumber.text.toString(),
                ))?.then((value) {
              getSubMarchantList();
            });
          } else if (isEmailShow) {
            Get.to(() => ManageMerchantOTP(
                  sadadId: sadadId,
                  isUnlink: true,
                  unlinkEmail: emailId.text.toString(),
                ))?.then((value) {
              getSubMarchantList();
            });
          } else {
            Get.to(() => ManageMerchantOTP(
                  sadadId: sadadId,
                  isUnlink: true,
                ))?.then((value) {
              getSubMarchantList();
            });
          }
          setState(() {});
          log("subMerchantList:::${subMerchantList}");
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print(e.message);
        Get.snackbar('error'.tr, '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }

  Dio dioForMobile = Dio();

  Future<void> checkMobileNumber() async {
    dioForMobile.close();
    dioForMobile = Dio();
    String token = await encryptedSharedPreferences.getString('token');
    final url = 'users/count?where[cellnumber]=${mobileNumber.text}&amp;where[agreement]=true';

    var response = await dioForMobile.get(Utility.baseUrl + url,
        options: Options(
          headers: {"Authorization": token, 'Content-Type': 'application/json'},
        ));
    if (response.data['count'] != 0) {
      setState(() {
        merchantInformationController.mobileError = "Mobile number already exist".tr;
        merchantInformationController.update();
      });
    } else {
      setState(() {
        merchantInformationController.mobileError = null;
        merchantInformationController.update();
      });
    }
    log("response mobile::${response.data}");
  }

  Dio dioForEmail = Dio();

  Future<void> checkEmail() async {
    dioForEmail.close();
    dioForEmail = Dio();
    String token = await encryptedSharedPreferences.getString('token');
    final url = 'users/count?where[email]=${emailId.text}&amp;where[agreement]=true';

    var response = await dioForEmail.get(Utility.baseUrl + url,
        options: Options(
          headers: {"Authorization": token, 'Content-Type': 'application/json'},
        ));
    if (response.data['count'] != 0) {
      setState(() {
        merchantInformationController.emailError = "Email address already exist".tr;
        merchantInformationController.update();
      });
    } else {
      setState(() {
        merchantInformationController.emailError = null;
        merchantInformationController.update();
      });
    }
    log("response of mail::${response.data}");
  }
}
