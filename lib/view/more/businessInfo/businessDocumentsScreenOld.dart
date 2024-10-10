import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as log;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/model/repo/more/bank/bankAccountRepo.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/documentRegisterScreen/commercialRegisterScreen.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/documentRegisterScreen/commercialRegisterScreenOld.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/widget/businessDocumentHelperWidget.dart';
import 'package:sadad_merchat_app/view/more/docUpdateOtpScreen.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';
import 'package:sadad_merchat_app/widget/webView.dart';

class BusinessDocumentsScreenOld extends StatefulWidget {
  const BusinessDocumentsScreenOld({Key? key}) : super(key: key);

  @override
  State<BusinessDocumentsScreenOld> createState() =>
      _BusinessDocumentsScreenOldState();
}

class _BusinessDocumentsScreenOldState extends State<BusinessDocumentsScreenOld> {
  bool isSubmit = false;
  final bankA = Get.find<BankAccountViewModel>();
  String? tokenMain;
  final cnt = Get.find<BusinessInfoViewModel>();
  BankAccountRepo bankAccountRepo = BankAccountRepo();
  BankAccountResponseModel bankAccountResponseModel =
      BankAccountResponseModel();
  RxList<Userbankstatus> userBankStatusList = <Userbankstatus>[].obs;

  // String commerRegDate = '';
  // String commerLiceDate = '';
  // String comCardDate = '';
  // String ownId = '';
  // File? commerRegImg;
  // File? commerLiceImg;
  // File? comCardImg;
  // File? ownIdImg;
  Map<String, Map<String, dynamic>> docData = {};

  @override
  void initState() {
    cnt.image = null;
    // TODO: implement initState
    docData = {};

    super.initState();
    cnt.uploadedBusinessMediaList = Get.arguments ?? [];
    cnt.businessMediaList.clear();
    cnt.assignBusinessMedia();
    for (int i = 0; i < cnt.uploadedBusinessMediaList.length; i++) {
      if (cnt.uploadedBusinessMediaList[i].businessmediatypeId == 1) {
        print('====??${cnt.uploadedBusinessMediaList[0].id}');
        print('====??${cnt.uploadedBusinessMediaList[0].name}');
        cnt.businessMediaList[0] = Businessmedia(
          id: cnt.uploadedBusinessMediaList[i].id,
          status: cnt.uploadedBusinessMediaList[i].status,
          businessmediatypeId:
              cnt.uploadedBusinessMediaList[i].businessmediatypeId ?? "",
          name: cnt.uploadedBusinessMediaList[i].name ?? "",
          created: cnt.uploadedBusinessMediaList[i].created ?? "",
          doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
        );
      } else if (cnt.uploadedBusinessMediaList[i].businessmediatypeId == 2) {
        cnt.businessMediaList[1] = Businessmedia(
          id: cnt.uploadedBusinessMediaList[i].id,
          status: cnt.uploadedBusinessMediaList[i].status,
          businessmediatypeId:
              cnt.uploadedBusinessMediaList[i].businessmediatypeId,
          name: cnt.uploadedBusinessMediaList[i].name,
          created: cnt.uploadedBusinessMediaList[i].created,
          doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
        );
      } else if (cnt.uploadedBusinessMediaList[i].businessmediatypeId == 3) {
        cnt.businessMediaList[2] = Businessmedia(
          id: cnt.uploadedBusinessMediaList[i].id,
          status: cnt.uploadedBusinessMediaList[i].status,
          businessmediatypeId:
              cnt.uploadedBusinessMediaList[i].businessmediatypeId,
          name: cnt.uploadedBusinessMediaList[i].name,
          created: cnt.uploadedBusinessMediaList[i].created,
          doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
        );
      } else if (cnt.uploadedBusinessMediaList[i].businessmediatypeId == 4) {
        cnt.businessMediaList[3] = Businessmedia(
          id: cnt.uploadedBusinessMediaList[i].id,
          status: cnt.uploadedBusinessMediaList[i].status,
          businessmediatypeId:
              cnt.uploadedBusinessMediaList[i].businessmediatypeId,
          name: cnt.uploadedBusinessMediaList[i].name,
          created: cnt.uploadedBusinessMediaList[i].created,
          doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
        );
      }
      print(
          "cnt.uploadedBusinessMediaList[i].businessmediatypeId ${cnt.uploadedBusinessMediaList[i].businessmediatypeId}");
      print(
          "cnt.uploadedBusinessMediaList[i].businessmediatypeId ${cnt.uploadedBusinessMediaList[i].name}");
    }
    print("cnt.businessMediaList.length ${cnt.businessMediaList.length}");
    print("=========${cnt.businessMediaList[0].name}");
    gettingToken();
  }
  gettingToken() async {
    tokenMain = await encryptedSharedPreferences.getString('token');
    setState(() {

    });
    print(tokenMain);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async {
      onBackCheck();
      return true;
    },
      child: Scaffold(
        appBar: commonAppBar(onBack: onBackCheck),
        bottomNavigationBar: docData.isEmpty ? SizedBox() : bottomBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height24(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Business Documents'.tr,
                    style: ThemeUtils.blackSemiBold
                        .copyWith(fontSize: FontUtils.medLarge)),
              ),
              height12(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "You have to add the below documents to verify\nyour account."
                      .tr,
                  style: ThemeUtils.blackRegular,
                ),
              ),
              height24(),
              dividerData(),
              height24(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text('Your account status'.tr,
                        style: ThemeUtils.blackSemiBold
                            .copyWith(fontSize: FontUtils.mediumSmall)),
                    Spacer(),
                    SvgIcon(getAccountStatus(
                        "${cnt.businessInfoModel.value.userbusinessstatus?.id ?? ""}")),
                    width13(),
                    Text(cnt.businessInfoModel.value.userbusinessstatus?.name ??
                        "".toString())
                  ],
                ),
              ),
              height24(),
              dividerData(),
              height24(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Requirement Documents".tr,
                          style: ThemeUtils.blackSemiBold
                              .copyWith(fontSize: FontUtils.mediumSmall),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setBottomState) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  width: 70,
                                                  height: 5,
                                                  child: Divider(
                                                      color: ColorsUtils.border,
                                                      thickness: 4),
                                                ),
                                              ),
                                            ),
                                            height20(),
                                            customSmallMedBoldText(
                                                color: ColorsUtils.accent,
                                                title:
                                                    'You can uploading following document for business registration certificate:'
                                                        .tr),
                                            height20(),
                                            commonRowData(
                                                title:
                                                    'Commercial registration'.tr),
                                            commonRowData(
                                                title: 'Commercial license'.tr),
                                            commonRowData(
                                                title: 'Establishment card'.tr),
                                            commonRowData(
                                                title: "Owner's ID card".tr),
                                            height40()
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: SvgIcon(Images.question))
                      ],
                    ),
                    ListView.builder(
                      itemCount: cnt.businessMediaList.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final title = cnt.businessMediaList[index].title;
                        final id = '${index + 1}';
                        print("----${cnt.businessMediaList[index].status}");
                        if (cnt.businessMediaList[index].status == false) {
                          return documentCommonWidget(
                            title: title ?? "".toString(),
                            docId: id,
                            subtitle: cnt.businessMediaList[index].name ??
                                "".toString(),
                            id: index,

                            date: docData.containsKey(id)
                                ? docData[id]!['date'].toString().isEmpty
                                    ? "Select Date".tr
                                    : dateformatChange(docData[id]!['date'])
                                : "Select Date".tr,
                            onDateTap: () async {
                              print("Inside the log");
                              // DateTime selectedDate = DateTime.now();
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate:
                                    DateTime.now().subtract(Duration(days: 0)),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                if (docData.containsKey(id)) {
                                  docData[id]!['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(picked).toString();
                                } else {
                                  docData.addAll({
                                    id: {
                                      'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(picked).toString(),
                                      'file': '',
                                      'url': ''
                                    }
                                  });
                                }
                                setState(() {});
                              }
                            },
                            onTap: () async {
                              print("isSubmit.toString()${isSubmit.toString()}");
                              print(".....>>>>>${index.toString()}");
                              getImageFile(id);
                            },
                          );
                        } else {
                          return documentUpdatedWidget(
                            editTap: () {
                              String id =
                                  cnt.businessMediaList[index].id.toString();
                              String typeId = cnt
                                  .businessMediaList[index].businessmediatypeId
                                  .toString();
                              print(
                                  'title:::${cnt.businessMediaList[index].title}');
                              print(
                                  'subtitle:::${cnt.businessMediaList[index].name}');
                              print('id:::${index + 1}');
                                Get.to(
                                      () => CommercialRegistrationScreenOld(
                                        // docData: docData,
                                        // imgId: [0],
                                        title: index == 0
                                            ? 'Commercial registration'.tr
                                            : index == 1
                                            ? 'Commercial license'.tr
                                            : index == 2
                                            ? 'Establishment card'.tr
                                            : index == 3
                                            ? 'Owner’s ID card'.tr
                                            : cnt.businessMediaList[index]
                                            .name ??
                                            "",
                                        subtitle: index == 0
                                            ? "Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce and enter CR number"
                                            .tr
                                            : index == 1
                                            ? "Upload your valid Commercial License copy as issued by the Ministry of Municipality and enter License number"
                                            .tr
                                            : index == 2
                                            ? "Upload your valid Company Establishment card and enter Establishment card number"
                                            .tr
                                            : index == 3
                                            ? "Upload your authorized person or owner's valid Residency ID card and enter ID card number"
                                            .tr
                                            : cnt.businessMediaList[index]
                                            .name ??
                                            "",
                                        id: typeId,
                                        // docData: docData,
                                      )
                                )?.then((value) {
                                  if (value != null) {
                                    for (var doc in docData.keys) {
                                      if (docData[doc]!['id'] == id) {
                                        docData.remove(doc);
                                        //cnt.businessMediaList[index].name = value[0][index+1]
                                        break;
                                      }
                                    }
                                    value.keys.forEach((element) {
                                      cnt.businessMediaList[index].name = value[element]!['url'];
                                    });
                                    Get.snackbar(
                                        'Added', 'Document added for edit.');
                                    docData.addAll(value);
                                    print(docData);
                                    setState(() {});
                                  }
                                });
                              //
                              // print(docData);
                              // Get.to(() => DocUpdateOtpScreen(
                              //       docData: docData,
                              //       isDelete: true,
                              //     ));
                            },
                            deleteTap: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Remove Document'.tr),
                                      content:
                                      Text('Are you sure you want to delete this document'.tr),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('No'.tr),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        TextButton(
                                            child: Text('Yes'.tr),
                                            onPressed: () async {
                                              print('====${jsonEncode(cnt.businessMediaList)}');

                                              String id =
                                              cnt.businessMediaList[index].id.toString();
                                              bool isalreadyadded = false;
                                              for (var doc in docData.keys) {
                                                if (docData[doc]!['deleteId'] == id || docData[doc]!['id'] == id) {
                                                  isalreadyadded = true;
                                                  break;
                                                }
                                              }
                                              int counter = 0;
                                              for (var doc in docData.keys) {
                                                if (docData[doc]!.containsKey("deleteId")) {
                                                  counter++;
                                                }
                                              }

                                              if (counter < cnt.uploadedBusinessMediaList.length - 1) {
                                                if (!isalreadyadded) {
                                                  Get.snackbar('',
                                                      'Doc will be ready to delete on save');
                                                  docData.addAll({
                                                    id: {
                                                      'date': DateTime.now()
                                                          .toString(),
                                                      'deleteId': id,
                                                    }
                                                  });
                                                } else {
                                                  Get.snackbar('Not allowed', 'This document is already added for edit or delete.');
                                                }
                                              } else {
                                                Get.snackbar('Cant remove', 'Atleast one document should be there.');
                                              }
                                              print(docData);
                                              Navigator.pop(context);
                                              setState(() {
                                              });
                                            }),
                                      ],
                                    );
                                  });
                            },
                            isDelete: false,
                            title: index == 0
                                ? 'Commercial registration'.tr
                                : index == 1
                                    ? 'Commercial license'.tr
                                    : index == 2
                                        ? 'Establishment card'.tr
                                        : index == 3
                                            ? 'Owner’s ID card'.tr
                                            : cnt.businessMediaList[index].name ??
                                                "",
                            date: dateformat(cnt.businessMediaList[index].doc_expiry),
                            image: cnt.businessMediaList[index].name,
                            token: tokenMain,
                            // onTap: () =>
                            onTap: () {
                              if (cnt.businessMediaList[index].name!.contains('pdf')) {
                                downloadFile(
                                    context: context,
                                    isEmail: false,
                                    url:
                                    '${Utility.baseUrl}containers/api-business/download/${cnt.businessMediaList[index].name}');
                              } else {
                                Get.to(WebViewPage(),
                                        arguments:
                                            cnt.businessMediaList[index].name ?? "");
                              }
                            },
                          );
                        }
                      },
                    ),
                    ListView.builder(
                      itemCount: cnt.uploadedBusinessMediaList.length,
                      primary: false,
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        if (cnt.businessInfoModel.value.businessmedia?[index]
                                .businessmediatypeId ==
                            null) {
                          log.log(
                              '0000000${jsonEncode(cnt.businessInfoModel.value)}');
                          log.log(
                              '--------${cnt.uploadedBusinessMediaList[0].businessmediatypeId.toString()}');
                          return documentUpdatedWidget(
                            isEdit: cnt.uploadedBusinessMediaList[index]
                                        .businessmediatypeId ==
                                    null
                                ? false
                                : true,
                            isDelete: true,
                            editTap: () {
                              Map<String, Map<String, dynamic>> docData = {};

                              String id = cnt.uploadedBusinessMediaList[index].id
                                  .toString();
                              String typeId = cnt.uploadedBusinessMediaList[index]
                                  .businessmediatypeId
                                  .toString();

                              docData.addAll({
                                id: {
                                  'id': id,
                                  'url':
                                      cnt.uploadedBusinessMediaList[index].name,
                                  'typeId': typeId
                                }
                              });
                              print(docData);
                              Get.to(() => DocUpdateOtpScreen(
                                    docData: docData,
                                    isDelete: true,
                                isOld: true,
                                  ));
                            },
                            // onTap: () => Get.to(WebViewPage(),
                            //     arguments:
                            //         cnt.uploadedBusinessMediaList[index].name ??
                            //             ""),

                            deleteTap: () {

                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Remove Document'.tr),
                                      content:
                                      Text('Are you sure you want to delete this document'.tr),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('No'.tr),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                        TextButton(
                                            child: Text('Yes'.tr),
                                            onPressed: () async {
                                              print('====${jsonEncode(cnt.businessMediaList)}');
                                              String id = cnt.uploadedBusinessMediaList[index].id.toString();
                                              bool isalreadyadded = false;
                                              for (var doc in docData.keys) {
                                                if (docData[doc]!['deleteId'] == id || docData[doc]!['id'] == id) {
                                                  isalreadyadded = true;
                                                  break;
                                                }
                                              }
                                              int counter = 0;
                                              for (var doc in docData.keys) {
                                                if (docData[doc]!.containsKey("deleteId")) {
                                                  counter++;
                                                }
                                              }

                                              if (counter < cnt.uploadedBusinessMediaList.length - 1) {
                                                if (!isalreadyadded) {
                                                  Get.snackbar('',
                                                      'Doc will be ready to delete on save');
                                                  docData.addAll({
                                                    id: {
                                                      'date': DateTime.now()
                                                          .toString(),
                                                      'deleteId': id,
                                                    }
                                                  });
                                                } else {
                                                  Get.snackbar('Not allowed', 'This document is already added for delete.');
                                                }
                                              } else {
                                                Get.snackbar('Cant remove', 'Atleast one document should be there.');
                                              }
                                              print(docData);
                                              Navigator.pop(context);
                                              setState(() {
                                              });
                                            }),
                                      ],
                                    );
                                  });
                              // print(
                              //     '====${jsonEncode(cnt.uploadedBusinessMediaList)}');
                              // Map<String, Map<String, dynamic>> docData = {};
                              //
                              // String id = cnt.uploadedBusinessMediaList[index].id
                              //     .toString();
                              //
                              // // if (docData.containsKey(id)) {
                              // //   docData[id]!['file'] = id;
                              // //   docData[id]!['date'] = DateTime.now().toString();
                              // // } else {
                              // //   docData.addAll({
                              // //     id: {
                              // //       'date': DateTime.now().toString(),
                              // //       'file': id,
                              // //     }
                              // //   });
                              // // }
                              //
                              // docData.addAll({
                              //   id: {
                              //     'date': DateTime.now().toString(),
                              //     'file': id,
                              //   }
                              // });
                              //
                              // print(docData);
                              // Get.to(() => DocUpdateOtpScreen(
                              //       docData: docData,
                              //       isDelete: true,
                              //     ));
                            },
                            onTap: () {
                              downloadFile(
                                  context: context,
                                  isEmail: false,
                                  url:
                                      '${Utility.baseUrl}containers/api-business/download/${cnt.uploadedBusinessMediaList[index].name}');
                            },
                            title:
                                cnt.uploadedBusinessMediaList[index].name ?? "",
                            date: dateformat(cnt.uploadedBusinessMediaList[index].created),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
              height24(),
              cnt.businessInfoModel.value.userbusinessstatus!.name.toString() !=
                      'Need Action'
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Actions'.tr,
                            style: ThemeUtils.blackSemiBold.copyWith(
                              fontSize: FontUtils.medium,
                            ),
                          ),
                          height15(),
                          Text(
                            "You must ensure that all details are accurate.\nPlease recheck your provided details and resubmit the application to approve your merchant account.",
                            textAlign: TextAlign.start,
                            style: ThemeUtils.blackSemiBold,
                          ),
                          height64()
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
  String dateformat(String? date) {
    if (date == null || date == '') {
      return 'NA';
    } else {
      DateTime datetime = DateTime.parse(date);
      DateFormat tempDate = DateFormat("dd/MM/yyyy");
      String newdate = tempDate.format(datetime);
      return newdate;
    }
  }
  String dateformatChange(String? date) {
    if (date == null || date == '') {
      return '';
    } else {
      date = date;
      DateTime parseDate =
      new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    }
  }

  onBackCheck() {
    if(docData.length > 0) {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure?'.tr),
              content:
              Text('By going back your edited changes will be removed.'.tr),
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
  Column bottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: () async {
              if (docData.isEmpty) {
                //change not
                Get.snackbar('error', 'Please update data!');
                return;
              }
              final dateList = docData.values
                  .toList()
                  .where((e) => e['date'].toString().isNotEmpty);
              final fileList = docData.values
                  .toList()
                  .where((e) => e['file'].toString().isNotEmpty);
              if (dateList.length != fileList.length) {
                Get.snackbar(
                    'error', 'File or ${'Expiration Date cannot be Empty'.tr}');
                //msg
                return;
              }
              Get.to(
                () => DocUpdateOtpScreen(
                  docData: docData,
                  isOld: true,
                ),
              );

              // await Get.to(
              //   () => CommercialRegistrationScreen(
              //     title: cnt.businessMediaList[index].title ?? "",
              //     subtitle:
              //         cnt.businessMediaList[index].name ?? "",
              //     id: index + 1,
              //   ),
              // );
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Save'),
          ),
        )
      ],
    );
  }

  Widget commonRowData({String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorsUtils.accent,
            radius: 5,
          ),
          width20(),
          customMediumNorText(title: title)
        ],
      ),
    );
  }

  Widget documentCommonWidget({
    required String title,
    required String subtitle,
    required String docId,
    required int id,
    required String date,
    required Function() onTap,
    required Function() onDateTap,
  }) {
    return Column(
      children: [
        height24(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: ThemeUtils.blackSemiBold
                              .copyWith(fontSize: FontUtils.small)),
                      height8(),
                      Text("$subtitle",
                          style: ThemeUtils.blackRegular
                              .copyWith(fontSize: FontUtils.small)),
                    ],
                  ),
                ),
                width20(),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: onTap,
                      child: Container(
                        height: 72.0,
                        width: 72.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsUtils.border)),
                        child: Stack(
                          children: [
                            !docData.containsKey(docId)
                                ? placeHolderImage()
                                : docData[docId]!['url'].toString().isEmpty
                                ? placeHolderImage()
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: docData[docId]!['url'].toString()!.contains('pdf') ? Image.asset(
                                Images.doc,
                                fit: BoxFit.fill,
                                height: Get.height * 0.125,
                                width: Get.width * 0.25,
                              ): Image.network(
                                "${Utility.baseUrl}containers/api-business/download/${docData[docId]!['url'].toString()}?access_token=${tokenMain}",
                                fit: BoxFit.fill,
                              ),
                            ),
                            const Positioned(
                              bottom: 5,
                              right: 5,
                              child: CircleAvatar(
                                backgroundColor: ColorsUtils.accent,
                                radius: 8,
                                child: Center(
                                    child: Icon(
                                  Icons.add,
                                  color: ColorsUtils.white,
                                  size: 15,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    height20(),
                    Text("Expiry date".tr + ':',
                        style:
                            TextStyle(color: ColorsUtils.reds, fontSize: 12)),
                    height5(),
                    InkWell(
                      onTap: onDateTap,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: ColorsUtils.border, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customVerySmallSemiText(
                              title: date, color: ColorsUtils.grey),
                        ),
                      ),
                    )
                    // commonTextField(
                    //   width: Get.width / 3,
                    //   hint: "Expiration date".tr,
                    //   contollerr: cnt.dateCnt,
                    //   isRead: true,
                    //   onTap: () async {
                    //     print("Inside the log");
                    //     DateTime selectedDate = DateTime.now();
                    //     final DateTime? picked = await showDatePicker(
                    //       context: context,
                    //       initialDate: DateTime.now(),
                    //       firstDate: DateTime.now().subtract(Duration(days: 0)),
                    //       lastDate: DateTime(2100),
                    //     );
                    //     if (picked != null) {
                    //       setState(() {
                    //         selectedDate = picked;
                    //         cnt.selectedDate = picked.toString();
                    //         cnt.dateCnt.text =
                    //             DateFormat.yMMMd().format(selectedDate);
                    //       });
                    //     }
                    //   },
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return "Expiration Date cannot be Empty".tr;
                    //     }
                    //     return null;
                    //   },
                    // )
                  ],
                ),
              ],
            ),
          ],
        ),
        height24(),
        dividerData(),
      ],
    );
  }

  ClipRRect placeHolderImage() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: Image.asset(
            Images.noImage,
            fit: BoxFit.cover,
            height: 25,
            width: 25,
          ),
        ));
  }

  Widget documentUpdatedWidget({
    String? title,
    String? date,
    String? image,
    String? token,
    bool? isVerified,
    bool? isEdit,
    bool? isDelete,
    Function()? onTap,
    Function()? deleteTap,
    Function()? editTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text("$title",
                                    overflow: TextOverflow.ellipsis,
                                    style: ThemeUtils.blackSemiBold
                                        .copyWith(fontSize: FontUtils.small)),
                              ),
                              isDelete == false
                                  ? SizedBox()
                                  :
                              InkWell(
                                onTap: deleteTap,
                                child: Icon(
                                  Icons.delete,
                                  color: ColorsUtils.accent,
                                ),
                              ),
                              width20(),
                              isEdit == false
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: editTap,
                                      child: Icon(
                                        Icons.edit,
                                        color: ColorsUtils.accent,
                                      ),
                                    ),
                            ],
                          ),
                          height8(),
                          Text("$date",
                              style: ThemeUtils.blackRegular
                                  .copyWith(fontSize: FontUtils.small)),
                          height8(),
                          getAccountStatusName(
                              "${cnt.businessInfoModel.value.userbusinessstatus!.id}")
                        ],
                      ),
                    ),
                    width16(),
                    Container(
                      height: 72.0,
                      width: 72.0,
                      decoration: BoxDecoration(
                        color: ColorsUtils.line.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: ColorsUtils.line,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: image == null ? Image.asset(
                          Images.doc,
                          fit: BoxFit.fill,
                          height: 20,
                          width: 20,
                        ) : image!.contains('pdf') ? Image.asset(
                          Images.doc,
                          fit: BoxFit.fill,
                          height: 20,
                          width: 20,
                        ): Image.network(
                          "${Utility.baseUrl}containers/api-business/download/${image}?access_token=${token}",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            height24(),
            dividerData(),
          ],
        ),
      ),
    );
  }

  Future getImageFile(String title) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png','pdf']);

    if (result != null) {
      File? file = File(result.files.single.path!);
      print('DOC=>${file}');
      cnt.imageName = file.path.split("/").last;
      String str = file.path;
      String extension = str.substring(str.lastIndexOf('.') + 1);
      print('extension:::$extension');
      if (extension == 'jpeg' || extension == 'png' || extension == 'jpg' || extension == 'pdf') {
        cnt.image = file;
        await bankA.uploadBusinessImage(file: cnt.image!, context: context);
        print('image is ${bankA.uploadedUrl.value}');
        if (docData.containsKey(title)) {
          docData[title]!['file'] = file.path;
          docData[title]!['url'] = bankA.uploadedUrl.value;
        } else {
          docData.addAll({
            title: {
              'date': '',
              'file': file.path,
              'url': bankA.uploadedUrl.value
            }
          });
        }
        // index==0?commerRegImg=file:index==1?commerLiceImg=file:index==2?comCardImg=file:index==3?ownIdImg=file:print('abc')
        setState(() {});
        //{
        //           "businessmedia": [
        //             {
        //               "userbusinessId": userBusinessId,
        //               "name": cnt.uploadedUrl.value,
        //               "businessmediatypeId": businessMedia!.businessmediatypeId,
        //             }
        //           ],
        //           "otp": businessData!.otp!,
        //           "userbusinessstatusId": 4
        //         };
      }
    } else {
      // User canceled the picker
    }
  }
}
