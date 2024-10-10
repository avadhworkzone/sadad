import 'dart:convert';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/IdentityDocumentProofingModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/documentRegisterScreen/AppDialog.dart';
import 'package:sadad_merchat_app/view/more/docUpdateOtpScreen.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';

import '../../../../main.dart';
import '../../../../staticData/loading_dialog.dart';
import '../../../../staticData/utility.dart';
import '../../../../viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:http/http.dart' as http;

import '../../signedContract/signedContract.dart';

class OwnerIDUploadNewFlowScreen extends StatefulWidget {
  String? businessStatus;
  List<OwnerIdUploadModel> allOwnerIdCardListForwarded;

  OwnerIDUploadNewFlowScreen({Key? key, this.businessStatus, required this.allOwnerIdCardListForwarded}) : super(key: key);

  @override
  State<OwnerIDUploadNewFlowScreen> createState() => _OwnerIDUploadNewFlowScreenState();
}

class _OwnerIDUploadNewFlowScreenState extends State<OwnerIDUploadNewFlowScreen> {
  List<OwnerIdUploadModel> allOwnerIdCardListMain = [OwnerIdUploadModel(uniqueId: "", onlineImage: [], metaData: [], mediaStatus: '', localDocStatus: [], currentDocType: "", image: [])];
  List<OwnerIdUploadModel> removedOwnerId = [];
  String? tokenMain;
  final bankA = Get.find<BankAccountViewModel>();
  Map<String, Map<String, dynamic>> docData = {};
  bool tempBlockConfirmbtn = false;

  void init() {}

  @override
  void initState() {
    allOwnerIdCardListMain = widget.allOwnerIdCardListForwarded;
    super.initState();
    gettingToken();
    // TODO: implement initState
  }

  gettingToken() async {
    tokenMain = await encryptedSharedPreferences.getString('token');
    setState(() {});
    print(tokenMain);
  }

  onBackCheck() {
    if (isNewDocAdded()) {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure?'.tr),
              content: Text('By going back your edited changes will be removed.'.tr),
              actions: <Widget>[
                TextButton(
                  child: Text('No'.tr),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                    child: Text('Yes'.tr),
                    onPressed: () async {
                      Get.close(2);
                    }),
              ],
            );
          });
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: showConfirmButton() ? bottomBar() : SizedBox(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height15(),
            topView(),
            bottomView(),
          ],
        ),
      ),
    );
  }

  Column topView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height40(),
        InkWell(
          onTap: () {
            onBackCheck();
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
        height25(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customMediumBoldText(title: 'Owner ID card'.tr),
                  height5(),
                  customVerySmallNorText(title: "Upload your Owner's valid residency Card".tr, color: ColorsUtils.grey),
                ],
              ),
            ),
            Column(
              children: [
                customVerySmallNorText(title: 'Sample'.tr, color: ColorsUtils.grey),
                height10(),
                Row(
                  children: [
                    Container(
                      height: Get.width * 0.12,
                      width: Get.width * 0.12,
                      decoration: BoxDecoration(
                          color: ColorsUtils.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 1, color: ColorsUtils.grey.withOpacity(0.2)),
                          boxShadow: [BoxShadow(color: ColorsUtils.grey.withOpacity(0.1), offset: Offset(0, 3), blurRadius: 10)]),
                      child: Image.asset(Images.ownerIdSample),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
        height20(),
      ],
    );
  }

  Widget bottomView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            allOwnerIdCardListMain == null
                ? SizedBox()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: allOwnerIdCardListMain.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return showOwnerId(index)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    border: Border.all(color: ColorsUtils.grey.withOpacity(0.1)),
                                    borderRadius: BorderRadius.circular(15),
                                    color: ColorsUtils.white,
                                    boxShadow: [BoxShadow(color: ColorsUtils.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))]),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          customMediumBoldText(title: '${index + 1}.' + "Owner ID".tr),
                                          width20(),
                                          allOwnerIdCardListMain[index].mediaStatus == ""
                                              ? SizedBox()
                                              : SvgIcon(
                                                  getAccountStatus(provideDocumentStatus(allOwnerIdCardListMain[index].mediaStatus.toString()).toString()),
                                                  height: 16,
                                                  width: 16,
                                                ),
                                          width5(),
                                          allOwnerIdCardListMain[index].mediaStatus == ""
                                              ? SizedBox()
                                              : getAccountStatusName(provideDocumentStatus(allOwnerIdCardListMain[index].mediaStatus.toString()).toString()),
                                          Spacer(),
                                          allOwnerIdCardListMain.length <= 1 || !allowedToEdit(index, false)
                                              ? SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    if (allOwnerIdCardListMain[index].image!.length + allOwnerIdCardListMain[index].onlineImage!.length > 0) {
                                                      showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text('Are you sure?'.tr),
                                                              content: Text('Do you want to remove this Owner ID?'.tr),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child: Text('No'.tr),
                                                                  onPressed: () => Navigator.pop(context),
                                                                ),
                                                                TextButton(
                                                                    child: Text('Yes'.tr),
                                                                    onPressed: () async {
                                                                      for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
                                                                        if (allOwnerIdCardListMain[index].localDocStatus![i] == "old") {
                                                                          allOwnerIdCardListMain[index].localDocStatus![i] = "delete";
                                                                        } else {
                                                                          allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
                                                                          allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
                                                                          allOwnerIdCardListMain[index].metaData?.removeAt(i);
                                                                          allOwnerIdCardListMain[index].id?.removeAt(i);
                                                                          i = 0;
                                                                        }
                                                                      }
                                                                      removedOwnerId.add(allOwnerIdCardListMain[index]);
                                                                      allOwnerIdCardListMain.removeAt(index);
                                                                      Get.close(1);
                                                                      setState(() {});
                                                                    }),
                                                              ],
                                                            );
                                                          });
                                                    } else {
                                                      allOwnerIdCardListMain.removeAt(index);
                                                      setState(() {});
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: ColorsUtils.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [BoxShadow(color: ColorsUtils.grey.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 5))]),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Center(child: Icon(Icons.remove, color: ColorsUtils.red)),
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          width20(),
                                          customVerySmallNorText(title: '(Upload front and back of Qatar ID)'.tr),
                                        ],
                                      ),
                                      height10(),
                                      Container(
                                        height: Get.height * 0.10,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: (allOwnerIdCardListMain[index].image?.length ?? 0) + (allOwnerIdCardListMain[index].onlineImage?.length ?? 0) + 1,
                                            itemBuilder: (context, subIndex) {
                                              return ((allOwnerIdCardListMain[index].image?.length ?? 0) + (allOwnerIdCardListMain[index].onlineImage?.length ?? 0) == 0 ||
                                                      (subIndex == (allOwnerIdCardListMain[index].image?.length ?? 0) + (allOwnerIdCardListMain[index].onlineImage?.length ?? 0)))
                                                  ? ((allOwnerIdCardListMain[index].image?.length ?? 0) + (showUploadButton(index))) > 1
                                                      ? SizedBox()
                                                      : allowedToEdit(index, false)
                                                          ? Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                                              child: InkWell(
                                                                onTap: () async {
                                                                  if (showUploadButton(index) == 0) {
                                                                    allOwnerIdCardListMain[index].currentDocType = "";
                                                                  }
                                                                  if (allOwnerIdCardListMain[index].currentDocType != '') {
                                                                    getImageFile(index);
                                                                  } else {
                                                                    bottomSheet(index);
                                                                  }
                                                                },
                                                                child: Container(
                                                                  width: Get.width * 0.175,
                                                                  height: Get.width * 0.2,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      color: ColorsUtils.white,
                                                                      boxShadow: [BoxShadow(color: ColorsUtils.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))]),
                                                                  child: Stack(
                                                                    children: [
                                                                      Center(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(5),
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.drive_folder_upload_outlined,
                                                                                size: 30,
                                                                                color: ColorsUtils.grey,
                                                                              ),
                                                                              height10(),
                                                                              customVerySmallNorText(title: 'Upload'.tr, color: ColorsUtils.grey)
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox()
                                                  : subIndex < (allOwnerIdCardListMain[index].onlineImage?.length ?? 0)
                                                      ? allOwnerIdCardListMain[index].localDocStatus![subIndex] == 'delete'
                                                          ? SizedBox()
                                                          : Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                                              child: Container(
                                                                width: Get.height * 0.10,
                                                                child: Column(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        if (allOwnerIdCardListMain[index].onlineImage![subIndex].contains('pdf')) {
                                                                          Get.to(() => SignedContract(
                                                                              isFromBusinessDoc: true,
                                                                              title: allOwnerIdCardListMain[index].onlineImage![subIndex].split("/").last ?? "",
                                                                              pdfUrl: '${Utility.baseUrl}containers/api-business/download/${allOwnerIdCardListMain[index].onlineImage![subIndex]}'));
                                                                        } else {
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) => _buildPopupDialog(context, allOwnerIdCardListMain[index].onlineImage![subIndex]),
                                                                          );
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                        width: Get.height * 0.10,
                                                                        height: Get.height * 0.10,
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: ColorsUtils.border)),
                                                                        alignment: Alignment.topRight,
                                                                        child: Stack(
                                                                          children: [
                                                                            allOwnerIdCardListMain[index].currentDocType == "PDF"
                                                                                ? Image.asset(Images.docPDF, fit: BoxFit.cover)
                                                                                : Image.network(
                                                                                    height: Get.height * 0.10,
                                                                                    width: Get.height * 0.10,
                                                                                    loadingBuilder: (context, child, loadingProgress) {
                                                                                      if (loadingProgress == null) return child;
                                                                                      return Center(
                                                                                        child: CircularProgressIndicator(
                                                                                          value: loadingProgress.expectedTotalBytes != null
                                                                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                                                              : null,
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                    "${Utility.baseUrl}containers/api-business/download/${allOwnerIdCardListMain[index].onlineImage![subIndex].toString()}?access_token=${tokenMain}",
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                            allowedToEdit(index, false)
                                                                                ? Align(
                                                                                    alignment: Alignment.topRight,
                                                                                    child: InkWell(
                                                                                      onTap: () {
                                                                                        print("Testing for click");
                                                                                        if (allOwnerIdCardListMain[index].localDocStatus?[subIndex] == 'old') {
                                                                                          if (countTotalDoc(index) == 1) {
                                                                                            showDialog<String>(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return AlertDialog(
                                                                                                    title: Text('Are you sure?'.tr),
                                                                                                    content: Text('Do you want to remove this Owner ID?'.tr),
                                                                                                    actions: <Widget>[
                                                                                                      TextButton(
                                                                                                        child: Text('No'.tr),
                                                                                                        onPressed: () => Navigator.pop(context),
                                                                                                      ),
                                                                                                      TextButton(
                                                                                                          child: Text('Yes'.tr),
                                                                                                          onPressed: () async {
                                                                                                            for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
                                                                                                              if (allOwnerIdCardListMain[index].localDocStatus![i] == "old") {
                                                                                                                allOwnerIdCardListMain[index].localDocStatus![i] = "delete";
                                                                                                              } else {
                                                                                                                allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
                                                                                                                allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
                                                                                                                allOwnerIdCardListMain[index].metaData?.removeAt(i);
                                                                                                                allOwnerIdCardListMain[index].id?.removeAt(i);
                                                                                                                i = 0;
                                                                                                              }
                                                                                                            }
                                                                                                            if (allOwnerIdCardListMain[index].mediaStatus != '3') {
                                                                                                              removedOwnerId.add(allOwnerIdCardListMain[index]);
                                                                                                              allOwnerIdCardListMain.removeAt(index);
                                                                                                              setState(() {});
                                                                                                            }
                                                                                                            setState(() {});
                                                                                                            Get.close(1);
                                                                                                            setState(() {});
                                                                                                            afterDeleteCheckForExistingDoc(index);
                                                                                                          }),
                                                                                                    ],
                                                                                                  );
                                                                                                });
                                                                                          } else {
                                                                                            allOwnerIdCardListMain[index].localDocStatus?[subIndex] = 'delete';
                                                                                            afterDeleteCheckForExistingDoc(index);
                                                                                          }
                                                                                        } else {
                                                                                          allOwnerIdCardListMain[index].onlineImage?.removeAt(subIndex);
                                                                                          allOwnerIdCardListMain[index].localDocStatus?.removeAt(subIndex);
                                                                                          allOwnerIdCardListMain[index].metaData?.removeAt(subIndex);
                                                                                          if (allOwnerIdCardListMain[index].onlineImage!.length == 0) {
                                                                                            allOwnerIdCardListMain[index].currentDocType = "";
                                                                                          }
                                                                                          afterDeleteCheckForExistingDoc(index);
                                                                                        }
                                                                                        if ((allOwnerIdCardListMain[index].onlineImage!.length + allOwnerIdCardListMain[index].image!.length) == 0) {
                                                                                          allOwnerIdCardListMain[index].currentDocType = '';
                                                                                          allOwnerIdCardListMain[index].isDocVerified = false;
                                                                                        }
                                                                                        setState(() {});
                                                                                      },
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.all(8.0),
                                                                                        child: CircleAvatar(
                                                                                          radius: 10,
                                                                                          backgroundColor: ColorsUtils.accent,
                                                                                          child: Center(
                                                                                              child: Icon(
                                                                                            Icons.close,
                                                                                            color: ColorsUtils.white,
                                                                                            size: 15,
                                                                                          )),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : SizedBox(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                      : Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                                          child: Container(
                                                            width: Get.height * 0.10,
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Container(
                                                                  width: Get.height * 0.10,
                                                                  height: Get.height * 0.10,
                                                                  decoration: BoxDecoration(
                                                                      image: allOwnerIdCardListMain[index].currentDocType == "PDF"
                                                                          ? DecorationImage(image: AssetImage(Images.docPDF), fit: BoxFit.cover)
                                                                          : DecorationImage(
                                                                              image:
                                                                                  FileImage(File(allOwnerIdCardListMain[index].image![subIndex - allOwnerIdCardListMain[index].onlineImage!.length])),
                                                                              fit: BoxFit.cover),
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      border: Border.all(color: ColorsUtils.border)),
                                                                  alignment: Alignment.topRight,
                                                                  child: allowedToEdit(index, false)
                                                                      ? InkWell(
                                                                          onTap: () {
                                                                            allOwnerIdCardListMain[index].image?.removeAt(subIndex - allOwnerIdCardListMain[index].onlineImage!.length);
                                                                            if (allOwnerIdCardListMain[index].onlineImage!.length + allOwnerIdCardListMain[index].image!.length == 0) {
                                                                              allOwnerIdCardListMain[index].currentDocType = '';
                                                                            }
                                                                            if (!docUploadLimitReached(index)) {
                                                                              allOwnerIdCardListMain[index].isDocVerified = false;
                                                                              allOwnerIdCardListMain[index].errorMessage =
                                                                                  "Maximum number of page limits has been reached. You're allowed to upload only 2 pages for Owner ID document category."
                                                                                      .tr;
                                                                              //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
                                                                            } else {
                                                                              allOwnerIdCardListMain[index].isDocVerified = true;
                                                                              if (allOwnerIdCardListMain[index].image!.length > 0) {
                                                                                double time = (1.0 - (allOwnerIdCardListMain[index].image!.length / 10.0)) / 20;
                                                                                AppDialog.showGifLoader(context: context, time: time);
                                                                                allOwnerIdCardListMain[index].docUploadedSucess = false;
                                                                                if (isLowerQualityFounded = true) {
                                                                                  for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
                                                                                    if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
                                                                                      allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
                                                                                      allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
                                                                                      allOwnerIdCardListMain[index].metaData?.removeAt(i);
                                                                                      allOwnerIdCardListMain[index].id?.removeAt(i);
                                                                                    }
                                                                                  }
                                                                                }
                                                                                isLowerQualityFounded = false;
                                                                                allOwnerIdCardListMain[index].image!.forEach((element) {
                                                                                  verifyBusinessDoc(element, index, allOwnerIdCardListMain[index].image!.length);
                                                                                  setState(() {});
                                                                                });
                                                                              } else {
                                                                                VerifyOnlineImages(index);
                                                                              }
                                                                            }
                                                                            setState(() {});
                                                                          },
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: CircleAvatar(
                                                                              radius: 10,
                                                                              backgroundColor: ColorsUtils.accent,
                                                                              child: Center(
                                                                                  child: Icon(
                                                                                Icons.close,
                                                                                color: ColorsUtils.white,
                                                                                size: 15,
                                                                              )),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : SizedBox(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                            }),
                                      ),
                                      height12(),
                                      allOwnerIdCardListMain[index].isDocVerified == false && (allOwnerIdCardListMain[index].onlineImage!.length + allOwnerIdCardListMain[index].image!.length) > 0
                                          ? customVerySmallNorText(title: "Alert : ".tr + "${allOwnerIdCardListMain[index].errorMessage}", color: ColorsUtils.accent)
                                          : SizedBox(),
                                      height8(),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SizedBox();
                    },
                  ),
            height20(),

            ///add more document
            allowedToAddAnotherId()
                ? InkWell(
                    onTap: () {
                      allOwnerIdCardListMain.add(OwnerIdUploadModel(uniqueId: "", onlineImage: [], metaData: [], mediaStatus: "", localDocStatus: [], currentDocType: "", image: []));
                      setState(() {});
                    },
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: ColorsUtils.white,
                          border: Border.all(color: ColorsUtils.grey.withOpacity(0.1)),
                          boxShadow: [BoxShadow(color: ColorsUtils.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customSmallNorText(
                              title: "Upload".tr + " ${numberToWord(allOwnerIdCardListMain.length + 1)} " + "Owner ID".tr,
                              color: ColorsUtils.grey,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: ColorsUtils.grey.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 5))]),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(child: Icon(Icons.add, color: ColorsUtils.red)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            height30()
          ],
        ),
      ),
    );
  }

  bottomSheet(int index) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(bottom: 30, left: 24, right: 24, top: 24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "please select Document format to".tr,
                  style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  "upload from below".tr,
                  style: TextStyle(color: ColorsUtils.primary, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                height28(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    commonCardBottomSheet(title: 'PDF'.tr, imageText: "assets/images/docPDF.png", text: "PDF", index: index),
                    commonCardBottomSheet(title: 'Image'.tr, imageText: "assets/images/uploadImageIcon.png", text: "Image", index: index),
                  ],
                ),
                height28(),
                Text(
                  "File size limit 20 MB.".tr,
                  style: TextStyle(color: ColorsUtils.primary, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ));
      },
    );
  }

  Widget commonCardBottomSheet({required String title, required String text, required String imageText, required int index}) {
    return InkWell(
      onTap: () {
        allOwnerIdCardListMain[index].currentDocType = title;
        Get.back();
        getImageFile(index);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Image.asset(imageText),
            width: Get.width * 0.35,
            height: Get.width * 0.35,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: ColorsUtils.white, boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black45, offset: Offset(0, 2.5))]),
          ),
          height12(),
          Text(
            text,
            style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  Future getImageFile(int index) async {
    int oversizeFileCounter = 0;
    if (allOwnerIdCardListMain[index].currentDocType == 'PDF') {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: true);
      if (result != null) {
        result.files.forEach((singleFile) async {
          File? file = File(singleFile.path!);
          List fileLIst = file.path.split("/").last.split(".");
          String fileName = fileLIst[0];
          if (fileLIst.length > 2) {
            for (int i = 1; i < fileLIst.length - 1; i++) {
              fileName = fileName + "_${fileLIst[i]}";
            }
          }
          Random random = Random();
          var randumNumber = random.nextInt(100);
          fileName = fileName + "${randumNumber}.${fileLIst.last.toString().toLowerCase()}";
          Directory cachePath = await getTemporaryDirectory();
          File newImage = await File(file.path).rename("${cachePath.path}/$fileName");
          file = newImage;
          int sizeInBytes = file.lengthSync();
          double sizeInMb = sizeInBytes / (1024 * 1024);
          if (sizeInMb > 20) {
            oversizeFileCounter++;
          } else {
            print('DOC=>${file}');
            String str = file.path;
            String extension = str.substring(str.lastIndexOf('.') + 1);
            print('extension:::$extension');
            if (extension == 'pdf') {
              allOwnerIdCardListMain[index].image?.add(file.path);
              allOwnerIdCardListMain[index].currentDocType = "PDF";
              setState(() {});
            }
          }
          if(result.files.last == singleFile) {
            if (oversizeFileCounter > 0) {
              Get.snackbar('Oversize file'.tr, "There is".tr+" ${oversizeFileCounter} "+"file is founded more than 20 mb size.".tr);
            }
          }
          if (result.files.last == singleFile) {
            Future.delayed(Duration(milliseconds: 300), () {
              if (allOwnerIdCardListMain[index].image!.length + showUploadButton(index) > 2) {
                allOwnerIdCardListMain[index].isDocVerified = false;
                allOwnerIdCardListMain[index].errorMessage = "Maximum number of page limits has been reached. You're allowed to upload only 2 pages for Owner ID document category.".tr;
              } else if (allOwnerIdCardListMain[index].image!.length > 0) {
                double time = (1.0 - (allOwnerIdCardListMain[index].image!.length / 10.0)) / 20;
                AppDialog.showGifLoader(context: context, time: time);
                allOwnerIdCardListMain[index].docUploadedSucess = false;
                if (isLowerQualityFounded = true) {
                  for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
                    if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
                      allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
                      allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
                      allOwnerIdCardListMain[index].metaData?.removeAt(i);
                      allOwnerIdCardListMain[index].id?.removeAt(i);
                    }
                  }
                }
                allOwnerIdCardListMain[index].docUploadedSucess = false;
                isLowerQualityFounded = false;
                allOwnerIdCardListMain[index].image!.forEach((element) {
                  verifyBusinessDoc(element, index, allOwnerIdCardListMain[index].image!.length);
                  setState(() {});
                });
              }
            });
          }
          setState(() {});
        });
      }
    } else {
      List<File> result = [];
      if (Platform.isIOS) {
        ImagePicker picker = ImagePicker();
        List<XFile> photo = await picker.pickMultiImage();
        print(photo.length);
        photo.forEach((element) {
          result.add(File(element.path));
        });
      } else {
        FilePickerResult? files = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'heic', 'heif'], allowMultiple: true);
        files!.files.forEach((element) {
          result.add(File(element.path ?? ""));
        });
      }
      if (result != null) {
        result.forEach((singleFile) async {
          File? file = File(singleFile.path!);
          List fileLIst = file.path.split("/").last.split(".");
          String fileName = fileLIst[0];
          if (fileLIst.length > 2) {
            for (int i = 1; i < fileLIst.length - 1; i++) {
              fileName = fileName + "_${fileLIst[i]}";
            }
          }
          Random random = Random();

          var randumNumber = random.nextInt(100);
          String fileNameWithoutExtension = fileName + "$randumNumber";
          fileName = "$fileNameWithoutExtension.${fileLIst.last.toString().toLowerCase()}";
          Directory cachePath = await getTemporaryDirectory();
          File newImage = await File(file.path).rename("${cachePath.path}/$fileName");
          file = newImage;
          Directory tempDir = await getTemporaryDirectory();

          if (fileLIst.last.toString().toLowerCase() == "heic" || fileLIst.last.toString().toLowerCase() == "heif") {
            File? compressedImage = await FlutterImageCompress.compressAndGetFile(file.path, "${tempDir.path}/$fileNameWithoutExtension.jpeg", format: CompressFormat.jpeg, quality: 100);
            file = compressedImage ?? newImage;
          }
          int sizeInBytes = file.lengthSync();
          double sizeInMb = sizeInBytes / (1024 * 1024);
          if (sizeInMb > 20) {
            oversizeFileCounter++;
          } else {
            print('DOC=>${file}');
            String str = file.path;
            String extension = str.substring(str.lastIndexOf('.') + 1);
            print('extension:::$extension');
            if (extension == 'jpeg' || extension == 'png' || extension == 'jpg' || extension == 'JPEG' || extension == 'PNG' || extension == 'JPG') {
              allOwnerIdCardListMain[index].image?.add(file.path);
              allOwnerIdCardListMain[index].currentDocType = "Image";
              setState(() {});
            }
          }
          if(result.last == singleFile) {
            if (oversizeFileCounter > 0) {
              Get.snackbar('Oversize file'.tr, "There is".tr+" ${oversizeFileCounter} "+"file is founded more than 20 mb size.".tr);
            }
          }
          if (result.last == singleFile) {
            Future.delayed(Duration(milliseconds: 300), () {
              if (allOwnerIdCardListMain[index].image!.length + showUploadButton(index) > 2) {
                allOwnerIdCardListMain[index].isDocVerified = false;
                allOwnerIdCardListMain[index].errorMessage = "Maximum number of page limits has been reached. You're allowed to upload only 2 pages for Owner ID document category.".tr;
              } else if (allOwnerIdCardListMain[index].image!.length > 0) {
                double time = (1.0 - (allOwnerIdCardListMain[index].image!.length / 10.0)) / 20;
                AppDialog.showGifLoader(context: context, time: time);
                allOwnerIdCardListMain[index].docUploadedSucess = false;
                if (isLowerQualityFounded = true) {
                  for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
                    if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
                      allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
                      allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
                      allOwnerIdCardListMain[index].metaData?.removeAt(i);
                      allOwnerIdCardListMain[index].id?.removeAt(i);
                    }
                  }
                }
                allOwnerIdCardListMain[index].docUploadedSucess = false;
                isLowerQualityFounded = false;
                allOwnerIdCardListMain[index].image!.forEach((element) {
                  verifyBusinessDoc(element, index, allOwnerIdCardListMain[index].image!.length);
                  setState(() {});
                });
              }
            });
          }
        });
      }
    }

    setState(() {});
  }

  verifyBusinessDoc(String imageFile, int index, int totalPages) async {
    String fileLIst = imageFile.split("/").last;
    Map? visionDocData = await bankA.verifyBusinessImage(file: File(imageFile), context: context, typeId: "4");
    if (visionDocData?['calculatedCondidence'] == null) {
      isLowerQualityFounded = true;
      Future.delayed(Duration(seconds: 3), () {
        allOwnerIdCardListMain[index].isDocVerified = false;
        allOwnerIdCardListMain[index].errorMessage =
            "An Error occurred while uploading a lower quality version of this file:".tr + "[${fileLIst}]" + "Please upload a high quality version of the file.".tr;
        for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
          if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
            allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
            allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
            allOwnerIdCardListMain[index].metaData?.removeAt(i);
            allOwnerIdCardListMain[index].id?.removeAt(i);
          }
        }
        hideLoadingDialog(context: context);
        setState(() {});
      });
      return;
    } else {
      if (visionDocData?['detectionConfidence'] < 0.85) {
        isLowerQualityFounded = true;
        Future.delayed(Duration(seconds: 3), () {
          allOwnerIdCardListMain[index].isDocVerified = false;
          allOwnerIdCardListMain[index].errorMessage =
              "An Error occurred while uploading a lower quality version of this file:".tr + "[${fileLIst}]" + "Please upload a high quality version of the file.".tr;
          for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
            if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
              allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
              allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
              allOwnerIdCardListMain[index].metaData?.removeAt(i);
              allOwnerIdCardListMain[index].id?.removeAt(i);
            }
          }
          hideLoadingDialog(context: context);
          setState(() {});
        });
        return;
      }
    }
    if (isLowerQualityFounded == true) {
      for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
        if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
          allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
          allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
          allOwnerIdCardListMain[index].metaData?.removeAt(i);
          allOwnerIdCardListMain[index].id?.removeAt(i);
        }
      }
      setState(() {});
      return;
    }
    Map? docOcrData = await bankA.fetchDocOcrData(file: File(imageFile), context: context, typeId: "4");
    if (isLowerQualityFounded == true) {
      for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
        if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
          allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
          allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
          allOwnerIdCardListMain[index].metaData?.removeAt(i);
          allOwnerIdCardListMain[index].id?.removeAt(i);
        }
      }
      setState(() {});
      return;
    }
    await bankA.uploadBusinessImage(file: File(imageFile), context: context);
    if (isLowerQualityFounded == true) {
      for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
        if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
          allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
          allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
          allOwnerIdCardListMain[index].metaData?.removeAt(i);
          allOwnerIdCardListMain[index].id?.removeAt(i);
        }
      }
      setState(() {});
      return;
    }
    allOwnerIdCardListMain[index].onlineImage?.add(bankA.uploadedUrl.value);
    allOwnerIdCardListMain[index].localDocStatus?.add('new');
    allOwnerIdCardListMain[index].metaData?.add(jsonEncode(docOcrData));
    allOwnerIdCardListMain[index].id?.add(0);
    int newDocCounter = countTotalNewDoc(index);
    if (totalPages == newDocCounter) {
      allOwnerIdCardListMain[index].ownerIdList?.clear();
      allOwnerIdCardListMain[index].expiryDateList?.clear();
      allOwnerIdCardListMain[index].image?.clear();
      setState(() {});
      //allOwnerIdCardListMain[index].image?.addAll(allOwnerIdCardListMain[index].onlineImage!);
      hideLoadingDialog(context: context);
      var docOcrAllDataString = '';
      multipleDocWithSameType = 0;
      for (int i = 0; i < allOwnerIdCardListMain[index].metaData!.length; i++) {
        if (allOwnerIdCardListMain[index].localDocStatus?[i] != 'delete') {
          var ocrMap = allOwnerIdCardListMain[index].metaData![i] == "" ? null : jsonDecode(allOwnerIdCardListMain[index].metaData![i]);
          if (ocrMap != null) {
            print("ocrmap type  ${ocrMap['main_data'] is List}");
            fetchOwnerIdNo((ocrMap['main_data'] is List) ? null : ocrMap['main_data'], index);
            fetchExpiryDate((ocrMap['main_data'] is List) ? null : ocrMap['main_data'], index);
            checkForMultipleDocWithSameType(ocrMap != null ? ocrMap['scanned_text'].toString() : '');
            docOcrAllDataString = docOcrAllDataString + (ocrMap != null ? ocrMap['scanned_text'].toString() : '');
          }
        }
      }
      for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
        if (allOwnerIdCardListMain[index].localDocStatus![i] == 'new') {
          allOwnerIdCardListMain[index].localDocStatus![i] = 'added';
        }
      }
      setState(() {});
      // bool verified = checkKeyinResponse(response: docOcrAllDataString);
      // var otherDocNameInList = checkOtherDocKeyinResponse(response: docOcrAllDataString);
      // if (otherDocNameInList != null && otherDocNameInList.length > 0 && verified) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have uploaded".tr + "${otherDocNameInList.toString()}" + "document with valid type document. Please remove it.".tr;
      // } else if (otherDocNameInList != null && otherDocNameInList.length > 0) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage =
      //       "You have uploaded".tr + "${otherDocNameInList.toString()} document in Owner ID card document category. " + "Kindly remove this document from Owner ID card category.".tr;
      // } else if (!verified) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "Sorry! You didn't upload a valid Owner ID card document.Kindly reupload the document.".tr;
      //   //Get.snackbar('Image Quality'.tr, "Sorry! You didn't upload a valid ${widget.title} document.Kindly reupload the document.".tr);
      // } else if (visionAPIRejectedFileName != '') {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage =
      //       "An Error occurred while uploading a lower quality version of this file:".tr + "[${visionAPIRejectedFileName}]" + "Please upload a high quality version of the file.".tr;
      //   //Get.snackbar('Image Quality'.tr, 'An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.'.tr);
      // } else if (compareDateExpiry(allOwnerIdCardListMain[index].expiryDateList!) == false) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have uploaded the expired document. Please reupload the valid document".tr;
      // } else if (multipleOwnerID(allOwnerIdCardListMain[index].ownerIdList!) == true) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have uploaded two different Owner's Id. Please upload single Owner's Id".tr;
      // } else if (multipleDocWithSameType > 1) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have uploaded multiple Owner ID card document. Kindly upload only one document here.".tr;
      // } else if (uploadedOwnerId(index)) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have already uploaded this document so can not upload same document twice.".tr;
      // } else {
        tempBlockConfirmbtn = true;
        setState(() {});
        Get.snackbar('Success'.tr, "Your document uploaded and validated successfully.".tr, duration: Duration(milliseconds: 1000));
        Future.delayed(Duration(milliseconds: 1800), () {
          tempBlockConfirmbtn = false;
          setState(() {});
        });
        allOwnerIdCardListMain[index].isDocVerified = true;
        allOwnerIdCardListMain[index].errorMessage = "";
        allOwnerIdCardListMain[index].docUploadedSucess = true;
        if (allOwnerIdCardListMain[index].uniqueId == "") {
          allOwnerIdCardListMain[index].uniqueId = DateTime.now().microsecondsSinceEpoch.toString();
        }
        // if (allOwnerIdCardListMain[index].onlineImage!.length > 0) {
        //   String docStatusTemp = '4';
        //   if (widget.businessStatus == '1' || widget.businessStatus == '2') {
        //     if (isFirstTimeOwnerIDUploading(index) == true) {
        //       docStatusTemp = '4';
        //     } else {
        //       docStatusTemp = '6';
        //     }
        //   }
        //   if (widget.businessStatus == '3') {
        //     bool isAddEditAvailable = false;
        //     bool isDeleteAvailable = false;
        //     for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
        //       if (allOwnerIdCardListMain[index].localDocStatus![i] != 'delete') {
        //         isAddEditAvailable = true;
        //       }
        //       if (allOwnerIdCardListMain[index].localDocStatus![i] == 'delete') {
        //         isDeleteAvailable = true;
        //       }
        //     }
        //     if (isFirstTimeOwnerIDUploading(index) == true) {
        //       docStatusTemp = '4';
        //     } else {
        //       if (isAddEditAvailable) {
        //         docStatusTemp = '4';
        //       } else if (isAddEditAvailable == false && isDeleteAvailable == true) {
        //         docStatusTemp = '6';
        //       } else {
        //         docStatusTemp = '6';
        //       }
        //     }
        //   }
        //   allOwnerIdCardListMain[index].mediaStatus = docStatusTemp;
        // }
      //}
      setState(() {});
    }
  }

  VerifyOnlineImages(int index) {
    if (countTotalDoc(index) > 0) {
      allOwnerIdCardListMain[index].docUploadedSucess = false;
      allOwnerIdCardListMain[index].ownerIdList?.clear();
      allOwnerIdCardListMain[index].expiryDateList?.clear();
      allOwnerIdCardListMain[index].image?.clear();
      setState(() {});
      //allOwnerIdCardListMain[index].image?.addAll(allOwnerIdCardListMain[index].onlineImage!);
      var docOcrAllDataString = '';
      multipleDocWithSameType = 0;
      for (int i = 0; i < allOwnerIdCardListMain[index].metaData!.length; i++) {
        if (allOwnerIdCardListMain[index].localDocStatus?[i] != 'delete') {
          var ocrMap = allOwnerIdCardListMain[index].metaData![i] == "" ? null : jsonDecode(allOwnerIdCardListMain[index].metaData![i]);
          if (ocrMap != null) {
            print("ocrmap type  ${ocrMap['main_data'] is List}");
            fetchOwnerIdNo((ocrMap['main_data'] is List) ? null : ocrMap['main_data'], index);
            fetchExpiryDate((ocrMap['main_data'] is List) ? null : ocrMap['main_data'], index);
            checkForMultipleDocWithSameType(ocrMap != null ? ocrMap['scanned_text'].toString() : '');
            docOcrAllDataString = docOcrAllDataString + (ocrMap != null ? ocrMap['scanned_text'].toString() : '');
          }
        }
      }
      for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
        if (allOwnerIdCardListMain[index].localDocStatus![i] == 'new') {
          allOwnerIdCardListMain[index].localDocStatus![i] = 'added';
        }
      }
      setState(() {});
      // bool verified = checkKeyinResponse(response: docOcrAllDataString);
      // var otherDocNameInList = checkOtherDocKeyinResponse(response: docOcrAllDataString);
      // if (otherDocNameInList != null && otherDocNameInList.length > 0 && verified) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have uploaded".tr + "${otherDocNameInList.toString()}" + "document with valid type document. Please remove it.".tr;
      // } else if (otherDocNameInList != null && otherDocNameInList.length > 0) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage =
      //       "You have uploaded ${otherDocNameInList.toString()} document in Owner ID card document category.".tr + "Kindly remove this document from Owner ID card category.".tr;
      // } else if (!verified) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "Sorry! You didn't upload a valid Owner ID card document.Kindly reupload the document.".tr;
      //   //Get.snackbar('Image Quality'.tr, "Sorry! You didn't upload a valid ${widget.title} document.Kindly reupload the document.".tr);
      // } else if (visionAPIRejectedFileName != '') {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage =
      //       "An Error occurred while uploading a lower quality version of this file:".tr + "[${visionAPIRejectedFileName}]" + "Please upload a high quality version of the file.".tr;
      //   //Get.snackbar('Image Quality'.tr, 'An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.'.tr);
      // } else if (compareDateExpiry(allOwnerIdCardListMain[index].expiryDateList!) == false) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have uploaded the expired document. Please reupload the valid document".tr;
      // } else if (multipleOwnerID(allOwnerIdCardListMain[index].ownerIdList!) == true) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have uploaded two different Owner's Id. Please upload single Owner's Id".tr;
      // } else if (multipleDocWithSameType > 1) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have uploaded multiple Owner ID card document. Kindly upload only one document here.".tr;
      // } else if (uploadedOwnerId(index)) {
      //   allOwnerIdCardListMain[index].isDocVerified = false;
      //   allOwnerIdCardListMain[index].errorMessage = "You have already uploaded this document so can not upload same document twice.".tr;
      // } else {
        tempBlockConfirmbtn = true;
        setState(() {});
        Get.snackbar('Success'.tr, "Your document uploaded and validated successfully.".tr, duration: Duration(milliseconds: 1000));
        Future.delayed(Duration(milliseconds: 1800), () {
          tempBlockConfirmbtn = false;
          setState(() {});
        });
        allOwnerIdCardListMain[index].isDocVerified = true;
        allOwnerIdCardListMain[index].errorMessage = "";
        allOwnerIdCardListMain[index].docUploadedSucess = true;
        if (allOwnerIdCardListMain[index].uniqueId == "") {
          allOwnerIdCardListMain[index].uniqueId = DateTime.now().microsecondsSinceEpoch.toString();
        }
        // if (allOwnerIdCardListMain[index].onlineImage!.length > 0) {
        //   String docStatusTemp = '4';
        //   if (widget.businessStatus == '1' || widget.businessStatus == '2') {
        //     if (isFirstTimeOwnerIDUploading(index) == true) {
        //       docStatusTemp = '4';
        //     } else {
        //       docStatusTemp = '6';
        //     }
        //   }
        //   if (widget.businessStatus == '3') {
        //     bool isAddEditAvailable = false;
        //     bool isDeleteAvailable = false;
        //     for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
        //       if (allOwnerIdCardListMain[index].localDocStatus![i] != 'delete') {
        //         isAddEditAvailable = true;
        //       }
        //       if (allOwnerIdCardListMain[index].localDocStatus![i] == 'delete') {
        //         isDeleteAvailable = true;
        //       }
        //     }
        //     if (isFirstTimeOwnerIDUploading(index) == true) {
        //       docStatusTemp = '4';
        //     } else {
        //       if (isAddEditAvailable) {
        //         docStatusTemp = '4';
        //       } else if (isAddEditAvailable == false && isDeleteAvailable == true) {
        //         docStatusTemp = '6';
        //       } else {
        //         docStatusTemp = '6';
        //       }
        //     }
        //   }
        //   allOwnerIdCardListMain[index].mediaStatus = docStatusTemp;
        // }

        //   String widgetIdTemp = widget.id.toString();
        //   if (widget.id == "") {
        //     widgetIdTemp = "6";
        //   }
        //   docData.addAll({
        //     widgetIdTemp!: {
        //       "id": docImageIdTemp,
        //       'date': cnt.selectedDate,
        //       'file': '',
        //       'status': docStatusManagerTemp,
        //       'mediaStatus': docStatusTemp,
        //       'url': docImageUrlListTemp,
        //       'doc_expiry': cnt.selectedDate,
        //       'metadata': docOcrDataListTemp,
        //       'unique_id': (widget.isFirstTime == true || widget.uniqueID == null)
        //           ? DateTime.now().microsecondsSinceEpoch.toString()
        //           : widget.uniqueID,
        //     }
        //   });
        // }
        //
        // // for (int i = 0; i < docStatusManager.length; i++) {
        // //   if (docStatusManager[i] == 'delete') {
        // //     docStatusManager.removeAt(i);
        // //     docImageUrlList.removeAt(i);
        // //     docOcrDataList.removeAt(i);
        // //     docImageId.removeAt(i);
        // //   }
        // // }
        // print('doc------${docData}');
        // Get.back(result: docData);
      //}
    }
    setState(() {});
  }

  bool addButtonDisable = true;
  String? currentErrorMsg = '';
  String visionAPIRejectedFileName = '';
  bool isLowerQualityFounded = false;
  var multipleDocWithSameType = 0;

  fetchOwnerIdNo(Map? mainData, int index) {
    if (mainData != null) {
      if (mainData.containsKey('ID. No')) {
        allOwnerIdCardListMain[index].ownerIdList?.add(mainData['ID. No']);
      } else if (mainData.containsKey('ID. NO')) {
        allOwnerIdCardListMain[index].ownerIdList?.add(mainData['ID. NO']);
      } else if (mainData.containsKey('ID.No')) {
        allOwnerIdCardListMain[index].ownerIdList?.add(mainData['ID.No']);
      } else if (mainData.containsKey('ID.NO')) {
        allOwnerIdCardListMain[index].ownerIdList?.add(mainData['ID.NO']);
      } else {}
    }
  }

  bool uploadedOwnerId(int index) {
    List<String> ownerIdListTemp = [];
    for (int i = 0; i < allOwnerIdCardListMain.length; i++) {
      if (allOwnerIdCardListMain[i].metaData != null) {
        if (allOwnerIdCardListMain[i].metaData!.length > 0) {
          for (int j = 0; j < allOwnerIdCardListMain[i].metaData!.length; j++) {
            if (allOwnerIdCardListMain[i].metaData?[j] != "" &&
                allOwnerIdCardListMain[i].metaData?[j] != null &&
                allOwnerIdCardListMain[i].uniqueId != allOwnerIdCardListMain[index].uniqueId &&
                allOwnerIdCardListMain[i].localDocStatus![j] != "delete") {
              Map ocrMap = jsonDecode(allOwnerIdCardListMain[i].metaData?[j] ?? "");
              if (ocrMap != null && ocrMap != "") {
                if (ocrMap.containsKey("main_data")) {
                  var mainData = (ocrMap["main_data"] is List) ? null : ocrMap["main_data"];
                  if (mainData != null) {
                    if (mainData.containsKey('ID. No')) {
                      ownerIdListTemp.add(mainData['ID. No']);
                    } else if (mainData.containsKey('ID. NO')) {
                      ownerIdListTemp.add(mainData['ID. NO']);
                    } else if (mainData.containsKey('ID.No')) {
                      ownerIdListTemp.add(mainData['ID.No']);
                    } else if (mainData.containsKey('ID.NO')) {
                      ownerIdListTemp.add(mainData['ID.NO']);
                    } else {}
                  }
                }
              }
            }
          }
        }
      }
    }
    if (allOwnerIdCardListMain[index].ownerIdList != null) {
      if (allOwnerIdCardListMain[index].ownerIdList!.length > 0) {
        if (ownerIdListTemp.contains(allOwnerIdCardListMain[index].ownerIdList![0])) {
          return true;
        }
      }
    }
    return false;
  }

  fetchExpiryDate(Map? mainData, int index) {
    if (mainData != null) {
      if (mainData.containsKey('Expiry Date')) {
        allOwnerIdCardListMain[index].expiryDateList?.add(mainData['Expiry Date']);
      } else if (mainData.containsKey('Date of expiry')) {
        allOwnerIdCardListMain[index].expiryDateList?.add(mainData['Date of expiry']);
      } else if (mainData.containsKey('Expiry')) {
        allOwnerIdCardListMain[index].expiryDateList?.add(mainData['Expiry']);
      } else {}
    }
  }

  checkForMultipleDocWithSameType(String? ScannedDate) {
    var finalString = ScannedDate?.toLowerCase() ?? '';
    if (isOwnerId(finalString)) {
      multipleDocWithSameType++;
    }
  }

  bool isOwnerId(String finalString) {
    return ((finalString.contains('id. card') || finalString.contains('id.card') || finalString.contains('residency permit')) && (finalString.contains('id. no') || finalString.contains('id.no')));
  }

  bool isCommercialRegistration(String finalString) {
    return ((finalString.contains('registration and commercial') && finalString.contains('licenses department')) &&
        (finalString.contains('commercial registration data') || finalString.contains('مستخرج ببعض بيانات السجل التجارى')) &&
        (finalString.contains('commercial reg. no.') || finalString.contains('رقم السجل التجارى')));
  }

  bool isCommercialLicense(String finalString) {
    return ((finalString.contains('registration and commercial') && finalString.contains('licenses department')) &&
        (finalString.contains('رخصة تجارية') || finalString.contains('رخصة تجاربة')) &&
        finalString.contains('رقم السجل التجارى'));
  }

  bool isComputerCard(String finalString) {
    return (finalString.contains('est. name') && finalString.contains('establishment card') && finalString.contains('est. id'));
  }

  bool checkKeyinResponse({required String response}) {
    var finalString = response.toLowerCase();
    return isOwnerId(finalString);
  }

  List<String>? checkOtherDocKeyinResponse({required String response}) {
    List<String>? otherDocKeyAvailable = [];
    var finalString = response.toLowerCase();

    if (isCommercialRegistration(finalString)) {
      //Commercial Registration
      otherDocKeyAvailable.add('Commercial registration');
    } else if (isCommercialLicense(finalString)) {
      //Commercial Licenses
      otherDocKeyAvailable.add('Commercial license');
    } else if (isComputerCard(finalString)) {
      //Computer Card
      otherDocKeyAvailable.add('Establishment card');
    }
    return otherDocKeyAvailable;
  }

  bool compareDateExpiry(List<String> expiryDates) {
    bool docExpire = true;
    String dataFormate = '';
    expiryDates.forEach((date) {
      if (date == null || date == '') {
      } else {
        if (date.split("-").first.length < 3 || date.split("/").first.length < 3) {
          if (date.contains('-')) {
            dataFormate = 'dd-MM-yyyy';
          } else {
            dataFormate = 'dd/MM/yyyy';
          }
        } else {
          if (date.contains('-')) {
            dataFormate = 'yyyy-MM-dd';
          } else {
            dataFormate = 'yyyy/MM/dd';
          }
        }
      }
      try {
        DateTime parseDate = new DateFormat(dataFormate).parse(date);
        var inputDate = DateTime.parse(parseDate.toString());
        var currentDate = DateTime.now();
        if (inputDate.compareTo(currentDate) < 0) {
          print("Document Expire");
          docExpire = false;
        }
      } on FormatException {
      } catch (e) {}
    });
    return docExpire;
  }

  bool multipleOwnerID(List<String> ownerIdList) {
    if (ownerIdList.length > 1) {
      if (ownerIdList[0] != ownerIdList[1]) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  bool docUploadLimitReached(int index) {
    if (countTotalDoc(index) > 2) {
      return false;
    }
    return true;
  }

  int countTotalDoc(int index) {
    int counter = 0;
    for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
      if (allOwnerIdCardListMain[index].localDocStatus![i] != 'delete') {
        counter++;
      }
    }
    return counter;
  }

  int countTotalNewDoc(int index) {
    int counter = 0;
    for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
      if (allOwnerIdCardListMain[index].localDocStatus![i] == 'new') {
        counter++;
      }
    }
    return counter;
  }

  bool showOwnerId(int index) {
    if (allOwnerIdCardListMain[index].mediaStatus == "3" || allOwnerIdCardListMain[index].mediaStatus == "6" || allOwnerIdCardListMain[index].mediaStatus == "") {
      return true;
    } else {
      if (allOwnerIdCardListMain[index].localDocStatus!.length > 0) {
        return !isAllRemovedDoc(index);
      } else {
        return false;
      }
    }
  }

  bool isAllRemovedDoc(int index) {
    for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
      if (allOwnerIdCardListMain[index].localDocStatus![i] != 'delete') {
        return false;
      }
    }
    return true;
  }

  int showUploadButton(int index) {
    int counter = 0;
    for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
      if (allOwnerIdCardListMain[index].localDocStatus![i] != 'delete') {
        counter++;
      }
    }
    return counter;
  }

  Column bottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: () async {
              await setupSaveToServerData();
              showLoadingDialog(context: context);
              await addDocApiCall(docData);
            },
            child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Confirm'.tr),
          ),
        )
      ],
    );
  }

  setupSaveToServerData() async {
    int lastIndex = 0;
    for (int i = 0; i < allOwnerIdCardListMain.length + removedOwnerId.length; i++) {
      List<String> docImageUrlListTemp = [];
      List<String> docStatusManagerTemp = [];
      List<int> docImageIdTemp = [];
      List<String> docOcrDataListTemp = [];
      if (i < allOwnerIdCardListMain.length) {
        for (int j = 0; j < allOwnerIdCardListMain[i].localDocStatus!.length; j++) {
          if (allOwnerIdCardListMain[i].localDocStatus![j] != 'old') {
            docStatusManagerTemp.add(allOwnerIdCardListMain[i].localDocStatus![j]);
            docImageUrlListTemp.add(allOwnerIdCardListMain[i].onlineImage![j]);
            docOcrDataListTemp.add(allOwnerIdCardListMain[i].metaData![j]);
            docImageIdTemp.add(allOwnerIdCardListMain[i].id?[j] ?? 0);
          }
        }
        if (allOwnerIdCardListMain[i].onlineImage!.length > 0) {
          String docStatusTemp = '4';
          if (widget.businessStatus == '1' || widget.businessStatus == '2') {
            if (isFirstTimeOwnerIDUploading(i) == true) {
              docStatusTemp = '4';
            } else {
              docStatusTemp = '6';
            }
          }
          if (widget.businessStatus == '3') {
            bool isAddEditAvailable = false;
            bool isDeleteAvailable = false;
            for (int j = 0; j < allOwnerIdCardListMain[i].localDocStatus!.length; j++) {
              if (allOwnerIdCardListMain[i].localDocStatus![j] != 'delete') {
                isAddEditAvailable = true;
              }
              if (allOwnerIdCardListMain[i].localDocStatus![j] == 'delete') {
                isDeleteAvailable = true;
              }
            }
            if (isFirstTimeOwnerIDUploading(i) == true) {
              docStatusTemp = '4';
            } else {
              if (isAddEditAvailable) {
                docStatusTemp = '4';
              } else if (isAddEditAvailable == false && isDeleteAvailable == true) {
                docStatusTemp = '6';
              } else {
                docStatusTemp = '6';
              }
            }
          }
          allOwnerIdCardListMain[i].mediaStatus = docStatusTemp;
        }
        if (docStatusManagerTemp.length > 0) {
          if (multiplePagesOwnerIdUploadedOrDeleted()) {
            docData.addAll({
              (40 + i).toString(): {
                "id": docImageIdTemp,
                'date': "",
                'file': "",
                'status': docStatusManagerTemp,
                'mediaStatus': allOwnerIdCardListMain[i].mediaStatus,
                'url': docImageUrlListTemp,
                'doc_expiry': "",
                'metadata': docOcrDataListTemp,
                'unique_id': allOwnerIdCardListMain[i].uniqueId,
              }
            });
          } else {
            docData.addAll({
              4.toString(): {
                "id": docImageIdTemp,
                'date': "",
                'file': "",
                'status': docStatusManagerTemp,
                'mediaStatus': allOwnerIdCardListMain[i].mediaStatus,
                'url': docImageUrlListTemp,
                'doc_expiry': "",
                'metadata': docOcrDataListTemp,
                'unique_id': allOwnerIdCardListMain[i].uniqueId,
              }
            });
          }
        }
      } else {
        for (int j = 0; j < removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus!.length; j++) {
          if (removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus![j] != 'old') {
            docStatusManagerTemp.add(removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus![j]);
            docImageUrlListTemp.add(removedOwnerId[i - allOwnerIdCardListMain.length].onlineImage![j]);
            docOcrDataListTemp.add(removedOwnerId[i - allOwnerIdCardListMain.length].metaData![j]);
            docImageIdTemp.add(removedOwnerId[i - allOwnerIdCardListMain.length].id?[j] ?? 0);
          }
        }
        if (removedOwnerId[i - allOwnerIdCardListMain.length].onlineImage!.length > 0) {
          String docStatusTemp = '4';
          if (widget.businessStatus == '1' || widget.businessStatus == '2') {
            docStatusTemp = '6';
          }
          if (widget.businessStatus == '3') {
            bool isAddEditAvailable = false;
            bool isDeleteAvailable = false;
            for (int j = 0; j < removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus!.length; j++) {
              if (removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus![j] != 'delete') {
                isAddEditAvailable = true;
              }
              if (removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus![j] == 'delete') {
                isDeleteAvailable = true;
              }
            }

            if (isAddEditAvailable) {
              docStatusTemp = '4';
            } else if (isAddEditAvailable == false && isDeleteAvailable == true) {
              docStatusTemp = '6';
            } else {
              docStatusTemp = '6';
            }
          }
          removedOwnerId[i - allOwnerIdCardListMain.length].mediaStatus = docStatusTemp;
        }
        if (docStatusManagerTemp.length > 0) {
          if (multiplePagesOwnerIdUploadedOrDeleted()) {
            docData.addAll({
              (40 + i).toString(): {
                "id": docImageIdTemp,
                'date': "",
                'file': "",
                'status': docStatusManagerTemp,
                'mediaStatus': removedOwnerId[i - allOwnerIdCardListMain.length].mediaStatus,
                'url': docImageUrlListTemp,
                'doc_expiry': "",
                'metadata': docOcrDataListTemp,
                'unique_id': removedOwnerId[i - allOwnerIdCardListMain.length].uniqueId,
              }
            });
          } else {
            docData.addAll({
              4.toString(): {
                "id": docImageIdTemp,
                'date': "",
                'file': "",
                'status': docStatusManagerTemp,
                'mediaStatus': removedOwnerId[i - allOwnerIdCardListMain.length].mediaStatus,
                'url': docImageUrlListTemp,
                'doc_expiry': "",
                'metadata': docOcrDataListTemp,
                'unique_id': removedOwnerId[i - allOwnerIdCardListMain.length].uniqueId,
              }
            });
          }
        }
      }
    }
    print('doc------${docData}');
  }

  Future<void> addDocApiCall(Map<String, Map<String, dynamic>> docData) async {
    String token = await encryptedSharedPreferences.getString('token');
    // String id = await encryptedSharedPreferences.getString('id');
    String userBusinessId = await encryptedSharedPreferences.getString('userbusinessId');
    final url = Uri.parse(Utility.baseUrl + 'userbusinesses/' + "$userBusinessId");
    Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
    // String userBusinessId =
    // await encryptedSharedPreferences.getString('userbusinessId');
    List list = [];
    docData.keys.forEach((element) {
      if (docData[element]!.containsKey("deleteId")) {
        for (int i = 0; i < docData[element]!['deleteId'].length; i++) {
          list.add({
            "id": docData[element]!['deleteId'][i],
            "deletedAt": docData[element]!['date'],
            "businessmediastatusId": int.parse(docData[element]!['mediaStatus']),
            "unique_id": docData[element]!['unique_id'],
            "userbusinessId": userBusinessId,
          });
        }
      } else if (docData[element]!.containsKey("id")) {
        for (int i = 0; i < docData[element]!['url'].length; i++) {
          print(docData[element]!['url'][i]);

          // if (widget.docData[element]!['id'].length-1 < i) {
          if (docData[element]!['status'][i] == 'delete') {
            list.add({
              "id": docData[element]!['id'][i],
              "deletedAt": DateTime.now().toString(),
              "businessmediastatusId": int.parse(docData[element]!['mediaStatus']),
              "unique_id": docData[element]!['unique_id'],
              "userbusinessId": userBusinessId,
            });
          } else {
            String tempElement = element;
            if (int.parse(element) > 9) {
              tempElement = "4";
            }
            if (tempElement == '6') {
              list.add({
                "userbusinessId": userBusinessId,
                "name": docData[element]!['url'][i],
                "metadata": docData[element]!['metadata'][i],
                "unique_id": docData[element]!['unique_id'],
                "businessmediastatusId": 4,
              });
            } else {
              list.add({
                "userbusinessId": userBusinessId,
                "name": docData[element]!['url'][i],
                "businessmediatypeId": int.parse(tempElement),
                "doc_expiry": docData[element]!['date'],
                "metadata": docData[element]!['metadata'][i],
                "unique_id": docData[element]!['unique_id'],
                "businessmediastatusId": int.parse(docData[element]!['mediaStatus']),
              });
            }
          }
        }
      } else {
        for (int i = 0; i < docData[element]!['url'].length; i++) {
          print(docData[element]!['url'][i]);
          list.add({
            "userbusinessId": userBusinessId,
            "name": docData[element]!['url'][i],
            "businessmediatypeId": int.parse(element),
            "doc_expiry": docData[element]!['date'],
            "metadata": docData[element]!['metadata'][i],
            "unique_id": docData[element]!['unique_id'],
            "businessmediastatusId": int.parse(docData[element]!['mediaStatus']),
          });
        }
      }
    });

    var body = {
      "businessmedia": list,
    };
    print("body =======>>>  ${jsonEncode(body)}");

    var result = await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    hideLoadingDialog(context: context);

    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data ========>>>>>>$data");
      Get.back(result: true);
      Get.showSnackbar(GetSnackBar(
        message: 'Update Successfully',
        duration: Duration(seconds: 3),
      ));
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }

  bool isNewDocAdded() {
    for (int i = 0; i < allOwnerIdCardListMain.length + removedOwnerId.length; i++) {
      if (i < allOwnerIdCardListMain.length) {
        for (var j = 0; j < allOwnerIdCardListMain[i].localDocStatus!.length; j++) {
          if (allOwnerIdCardListMain[i].localDocStatus?[j] == "added" || allOwnerIdCardListMain[i].localDocStatus?[j] == "delete") {
            return true;
          }
        }
      } else {
        for (var j = 0; j < removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus!.length; j++) {
          if (removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus?[j] == "added" || removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus?[j] == "delete") {
            return true;
          }
        }
      }
    }
    return false;
  }

  bool showConfirmButton() {
    bool show = false;
    if (allOwnerIdCardListMain != null) {
      for (int i = 0; i < allOwnerIdCardListMain.length + removedOwnerId.length; i++) {
        if (i < allOwnerIdCardListMain.length) {
          for (int j = 0; j < allOwnerIdCardListMain[i].localDocStatus!.length; j++) {
            if (allOwnerIdCardListMain[i].localDocStatus?[j] == "delete" || allOwnerIdCardListMain[i].localDocStatus?[j] == "added") {
              show = true;
              break;
            }
          }
        } else {
          for (int j = 0; j < removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus!.length; j++) {
            if (removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus?[j] == "delete" || removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus?[j] == "added") {
              show = true;
              break;
            }
          }
        }
      }

      for (int i = 0; i < allOwnerIdCardListMain.length; i++) {
        if (allOwnerIdCardListMain[i].isDocVerified == true && (allOwnerIdCardListMain[i].mediaStatus == "4" || allOwnerIdCardListMain[i].mediaStatus == "6")) {
        } else if (allOwnerIdCardListMain[i].isDocVerified == true) {
        } else {
          show = false;
        }
      }
    }
    if (tempBlockConfirmbtn) {
      show = false;
    }
    return show;
  }

  bool allowedToEdit(int index, bool? isforRemoveAll) {
    if (allOwnerIdCardListMain[index].mediaStatus == "3" && isforRemoveAll != true) {
      return true;
    } else if (allOwnerIdCardListMain[index].mediaStatus == "3" && isforRemoveAll == true) {
      return false;
    } else {
      for (int i = 0; i < allOwnerIdCardListMain.length; i++) {
        if (allOwnerIdCardListMain[i].mediaStatus == "4" || allOwnerIdCardListMain[i].mediaStatus == "6") {
          return false;
        }
      }
    }
    return true;
  }

  bool allowedToAddAnotherId() {
    bool show = true;
    if (allOwnerIdCardListMain.length < 6) {
      show = true;
    } else {
      show = false;
    }
    if (allOwnerIdCardListMain.length > 0) {
      if (allOwnerIdCardListMain.last.isDocVerified == true && allOwnerIdCardListMain.length < 6) {
        show = true;
      } else {
        show = false;
      }
    }
    for (int i = 0; i < allOwnerIdCardListMain.length; i++) {
      if (allOwnerIdCardListMain[i].mediaStatus == "4" || allOwnerIdCardListMain[i].mediaStatus == "6") {
        show = false;
        return show;
      }
    }

    return show;
  }

  bool? isFirstTimeOwnerIDUploading(int index) {
    if (allOwnerIdCardListMain[index] != null) {
      for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
        if (allOwnerIdCardListMain[index].localDocStatus?[i] == "old" || allOwnerIdCardListMain[index].localDocStatus?[i] == "delete") {
          return false;
        }
      }
    }
    return true;
  }

  afterDeleteCheckForExistingDoc(int index) {
    if (showUploadButton(index) > 0) {
      if (!docUploadLimitReached(index)) {
        allOwnerIdCardListMain[index].isDocVerified = false;
        allOwnerIdCardListMain[index].errorMessage = "Maximum number of page limits has been reached. You're allowed to upload only 2 pages for Owner ID document category.".tr;
        //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
      } else {
        allOwnerIdCardListMain[index].isDocVerified = true;
        if (allOwnerIdCardListMain[index].image!.length > 0) {
          double time = (1.0 - (allOwnerIdCardListMain[index].image!.length / 10.0)) / 20;
          AppDialog.showGifLoader(context: context, time: time);
          allOwnerIdCardListMain[index].docUploadedSucess = false;
          if (isLowerQualityFounded = true) {
            for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
              if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
                allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
                allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
                allOwnerIdCardListMain[index].metaData?.removeAt(i);
                allOwnerIdCardListMain[index].id?.removeAt(i);
              }
            }
          }
          if (isLowerQualityFounded = true) {
            for (int i = 0; i < allOwnerIdCardListMain[index].localDocStatus!.length; i++) {
              if (allOwnerIdCardListMain[index].localDocStatus?[i] == 'new') {
                allOwnerIdCardListMain[index].onlineImage?.removeAt(i);
                allOwnerIdCardListMain[index].localDocStatus?.removeAt(i);
                allOwnerIdCardListMain[index].metaData?.removeAt(i);
                allOwnerIdCardListMain[index].id?.removeAt(i);
              }
            }
          }
          setState(() {});
          isLowerQualityFounded = false;
          allOwnerIdCardListMain[index].image!.forEach((element) {
            verifyBusinessDoc(element, index, allOwnerIdCardListMain[index].image!.length);
            setState(() {});
          });
        } else {
          VerifyOnlineImages(index);
          setState(() {});
        }
      }
    }
  }

  bool multiplePagesOwnerIdUploadedOrDeleted() {
    int counter = 0;
    if (allOwnerIdCardListMain != null) {
      for (int i = 0; i < allOwnerIdCardListMain.length + removedOwnerId.length; i++) {
        if (i < allOwnerIdCardListMain.length) {
          for (var j = 0; j < allOwnerIdCardListMain[i].localDocStatus!.length; j++) {
            if (allOwnerIdCardListMain[i].localDocStatus?[j] == "added" || allOwnerIdCardListMain[i].localDocStatus?[j] == "delete") {
              counter++;
            }
          }
        } else {
          for (var j = 0; j < removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus!.length; j++) {
            if (removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus?[j] == "added" || removedOwnerId[i - allOwnerIdCardListMain.length].localDocStatus?[j] == "delete") {
              counter++;
            }
          }
        }
      }
    }
    if (counter > 1) {
      return true;
    } else {
      return false;
    }
  }

  String numberToWord(int number) {
    if (number == 1) {
      return "First".tr;
    } else if (number == 2) {
      return "Second".tr;
    } else if (number == 3) {
      return "Third".tr;
    } else if (number == 4) {
      return "Fourth".tr;
    } else if (number == 5) {
      return "Fifth".tr;
    } else if (number == 6) {
      return "Sixth".tr;
    } else if (number == 7) {
      return "Seventh".tr;
    } else if (number == 8) {
      return "Eighth".tr;
    } else if (number == 9) {
      return "Ninth".tr;
    } else if (number == 10) {
      return "Tenth".tr;
    } else {
      return "";
    }
  }

  String provideDocumentStatus(String status) {
    if (status == "6") {
      return "4";
    } else {
      return status;
    }
  }

  Widget _buildPopupDialog(BuildContext context, String url) {
    List<String> imageList = [];
    // for (int i = 0; i < allOwnerIdCardListMain[index].onlineImage!.length; i++) {
    //   if (businessMediaMultiPageList[index].docStatus![i] != 'delete') {
    imageList.add(url);
    //   }
    // }
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int counter) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage("${Utility.baseUrl}containers/api-business/download/${imageList[counter].toString()}?access_token=${tokenMain}"),
                  initialScale: PhotoViewComputedScale.contained * 0.8,
                );
              },
              itemCount: imageList.length,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: 0,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: AssetImage(Images.closeWhite), //ExactAssetImage(Images.cancel),
                        )),
                    width: 25,
                    height: 25)),
          ),
        ],
      ),
    );
  }
}
