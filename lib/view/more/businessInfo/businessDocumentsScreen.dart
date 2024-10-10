import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'dart:developer' as log;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/documentRegisterScreen/commercialRegisterScreen.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/widget/businessDocumentHelperWidget.dart';
import 'package:sadad_merchat_app/view/more/docUpdateOtpScreen.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/view/more/signedContract/signedContract.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;

import '../../../main.dart';
import '../../../model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import '../../../model/repo/more/bank/bankAccountRepo.dart';
import '../../../widget/webView.dart';

class BusinessDocumentsScreen extends StatefulWidget {
  const BusinessDocumentsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessDocumentsScreen> createState() => _BusinessDocumentsScreenState();
}

class _BusinessDocumentsScreenState extends State<BusinessDocumentsScreen> {
  bool isSubmit = false;
  final bankA = Get.find<BankAccountViewModel>();
  String? tokenMain;
  final cnt = Get.find<BusinessInfoViewModel>();

  BankAccountRepo bankAccountRepo = BankAccountRepo();
  BankAccountResponseModel bankAccountResponseModel = BankAccountResponseModel();
  RxList<Userbankstatus> userBankStatusList = <Userbankstatus>[].obs;
  RxList<BusinessmediaMultiPage> businessMediaMultiPageList = <BusinessmediaMultiPage>[].obs;

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
    bool isOther = false;
    for (int i = 0; i < cnt.uploadedBusinessMediaList.length; i++) {
      var isFounded = false;
      for (int j = 0; j < businessMediaMultiPageList.length; j++) {
        if (cnt.uploadedBusinessMediaList[i].unique_id == businessMediaMultiPageList[j].unique_id &&
            cnt.uploadedBusinessMediaList[i].businessmediatypeId == businessMediaMultiPageList[j].businessmediatypeId) {
          businessMediaMultiPageList[j].metadata!.add(cnt.uploadedBusinessMediaList[i].metadata ?? '');
          businessMediaMultiPageList[j].id!.add(cnt.uploadedBusinessMediaList[i].id ?? 0);
          businessMediaMultiPageList[j].name!.add(cnt.uploadedBusinessMediaList[i].name ?? '');
          businessMediaMultiPageList[j].docStatus!.add('old');
          businessMediaMultiPageList[j].businessmediastatusId = businessMediaMultiPageList[j].businessmediastatusId;
          businessMediaMultiPageList[j].comment = businessMediaMultiPageList[j].comment;
          isFounded = true;
        } else if (cnt.uploadedBusinessMediaList[i].unique_id == businessMediaMultiPageList[j].unique_id &&
            cnt.uploadedBusinessMediaList[i].businessmediatypeId == null) {
          isOther = true;
          businessMediaMultiPageList[j].metadata!.add(cnt.uploadedBusinessMediaList[i].metadata ?? '');
          businessMediaMultiPageList[j].id!.add(cnt.uploadedBusinessMediaList[i].id ?? 0);
          businessMediaMultiPageList[j].name!.add(cnt.uploadedBusinessMediaList[i].name ?? '');
          businessMediaMultiPageList[j].docStatus!.add('old');
          businessMediaMultiPageList[j].businessmediastatusId = businessMediaMultiPageList[j].businessmediastatusId;
          businessMediaMultiPageList[j].comment = businessMediaMultiPageList[j].comment;
          isFounded = true;
        }
      }
      if (!isFounded) {
        if (cnt.uploadedBusinessMediaList[i].businessmediatypeId != null) {
          businessMediaMultiPageList.add(BusinessmediaMultiPage(
            id: [cnt.uploadedBusinessMediaList[i].id ?? 0],
            status: cnt.uploadedBusinessMediaList[i].status,
            businessmediatypeId: cnt.uploadedBusinessMediaList[i].businessmediatypeId ?? "",
            name: [cnt.uploadedBusinessMediaList[i].name ?? ""],
            created: cnt.uploadedBusinessMediaList[i].created ?? "",
            doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
            metadata: [cnt.uploadedBusinessMediaList[i].metadata ?? ""],
            unique_id: cnt.uploadedBusinessMediaList[i].unique_id,
            businessmediastatusId: cnt.uploadedBusinessMediaList[i].businessmediastatusId,
            comment: cnt.uploadedBusinessMediaList[i].comment,
            docStatus: ["old"],
          ));
          for (int k = 0; k < cnt.businessMediaList.length; k++) {
            if (cnt.businessMediaList[k].businessmediatypeId == cnt.uploadedBusinessMediaList[i].businessmediatypeId) {
              cnt.businessMediaList.removeAt(k);
            }
          }
        } else {
          isOther = true;
          businessMediaMultiPageList.add(BusinessmediaMultiPage(
            id: [cnt.uploadedBusinessMediaList[i].id ?? 0],
            status: cnt.uploadedBusinessMediaList[i].status,
            businessmediatypeId: cnt.uploadedBusinessMediaList[i].businessmediatypeId ?? "",
            name: [cnt.uploadedBusinessMediaList[i].name ?? ""],
            created: cnt.uploadedBusinessMediaList[i].created ?? "",
            doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
            metadata: [cnt.uploadedBusinessMediaList[i].metadata ?? ""],
            unique_id: cnt.uploadedBusinessMediaList[i].unique_id,
            businessmediastatusId: cnt.uploadedBusinessMediaList[i].businessmediastatusId,
            comment: cnt.uploadedBusinessMediaList[i].comment,
            docStatus: ["old"],
          ));
        }
      }
    }
    for (int i = 0; i < cnt.businessMediaList.length; i++) {
      businessMediaMultiPageList.add(BusinessmediaMultiPage(
        id: [cnt.businessMediaList[i].id ?? 0],
        title: cnt.businessMediaList[i].title.toString(),
        status: cnt.businessMediaList[i].status,
        businessmediatypeId: cnt.businessMediaList[i].businessmediatypeId ?? "",
        name: [cnt.businessMediaList[i].name ?? ""],
        created: cnt.businessMediaList[i].created ?? "",
        doc_expiry: cnt.businessMediaList[i].doc_expiry ?? "",
        metadata: [cnt.businessMediaList[i].metadata ?? ""],
        unique_id: cnt.businessMediaList[i].unique_id ?? "",
        businessmediastatusId: cnt.businessMediaList[i].businessmediastatusId,
        comment: cnt.businessMediaList[i].comment,
        docStatus: ["old"],
      ));
    }
    if (!isOther) {
      businessMediaMultiPageList.add(BusinessmediaMultiPage(
        id: [0],
        title: 'Other'.tr,
        status: false,
        businessmediatypeId: "6",
        name: ["Upload other type of document here".tr],
        created: "",
        doc_expiry: "",
        metadata: [""],
        unique_id: "",
        businessmediastatusId: null,
        comment: "",
        docStatus: ["old"],
      ));
    }
    //businessMediaMultiPageList >>> businessmediatypeId >> 4,1,2,3
    List<BusinessmediaMultiPage> tempList = [];
    List<int> seq = [4, 1, 2, 3];
    for (int i = 0; i < seq.length; i++) {
      for (int j = 0; j < businessMediaMultiPageList.length; j++) {
        if (businessMediaMultiPageList[j].businessmediatypeId == seq[i]) {
          tempList.add(businessMediaMultiPageList[j]);
        }
      }
    }
    for (int j = 0; j < businessMediaMultiPageList.length; j++) {
      if (!seq.contains(businessMediaMultiPageList[j].businessmediatypeId)) {
        tempList.add(businessMediaMultiPageList[j]);
      }
    }
    businessMediaMultiPageList.clear();
    businessMediaMultiPageList.value = tempList;

    // for (int i = 0; i < cnt.uploadedBusinessMediaList.length; i++) {
    //   if (cnt.uploadedBusinessMediaList[i].businessmediatypeId == 1) {
    //     print('====??${cnt.uploadedBusinessMediaList[0].id}');
    //     print('====??${cnt.uploadedBusinessMediaList[0].name}');
    //     cnt.businessMediaList[0] = Businessmedia(
    //       id: cnt.uploadedBusinessMediaList[i].id,
    //       status: cnt.uploadedBusinessMediaList[i].status,
    //       businessmediatypeId:
    //           cnt.uploadedBusinessMediaList[i].businessmediatypeId ?? "",
    //       name: cnt.uploadedBusinessMediaList[i].name ?? "",
    //       created: cnt.uploadedBusinessMediaList[i].created ?? "",
    //       doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
    //     );
    //   } else if (cnt.uploadedBusinessMediaList[i].businessmediatypeId == 2) {
    //     cnt.businessMediaList[1] = Businessmedia(
    //       id: cnt.uploadedBusinessMediaList[i].id,
    //       status: cnt.uploadedBusinessMediaList[i].status,
    //       businessmediatypeId:
    //           cnt.uploadedBusinessMediaList[i].businessmediatypeId,
    //       name: cnt.uploadedBusinessMediaList[i].name,
    //       created: cnt.uploadedBusinessMediaList[i].created,
    //       doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
    //     );
    //   } else if (cnt.uploadedBusinessMediaList[i].businessmediatypeId == 3) {
    //     cnt.businessMediaList[2] = Businessmedia(
    //       id: cnt.uploadedBusinessMediaList[i].id,
    //       status: cnt.uploadedBusinessMediaList[i].status,
    //       businessmediatypeId:
    //           cnt.uploadedBusinessMediaList[i].businessmediatypeId,
    //       name: cnt.uploadedBusinessMediaList[i].name,
    //       created: cnt.uploadedBusinessMediaList[i].created,
    //       doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
    //     );
    //   } else if (cnt.uploadedBusinessMediaList[i].businessmediatypeId == 4) {
    //     cnt.businessMediaList[3] = Businessmedia(
    //       id: cnt.uploadedBusinessMediaList[i].id,
    //       status: cnt.uploadedBusinessMediaList[i].status,
    //       businessmediatypeId:
    //           cnt.uploadedBusinessMediaList[i].businessmediatypeId,
    //       name: cnt.uploadedBusinessMediaList[i].name,
    //       created: cnt.uploadedBusinessMediaList[i].created,
    //       doc_expiry: cnt.uploadedBusinessMediaList[i].doc_expiry ?? "",
    //     );
    //   }
    //   print(
    //       "cnt.uploadedBusinessMediaList[i].businessmediatypeId ${cnt.uploadedBusinessMediaList[i].businessmediatypeId}");
    //   print(
    //       "cnt.uploadedBusinessMediaList[i].businessmediatypeId ${cnt.uploadedBusinessMediaList[i].name}");
    // }
    // print("cnt.businessMediaList.length ${cnt.businessMediaList.length}");
    // print("=========${cnt.businessMediaList[0].name}");
    gettingToken();
  }

  gettingToken() async {
    tokenMain = await encryptedSharedPreferences.getString('token');
    setState(() {});
    print(tokenMain);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
                child: Text('Business Documents'.tr, style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medLarge)),
              ),
              height12(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "You have to add the below documents to verify\nyour account.".tr,
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
                    Text('Your account status'.tr, style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.mediumSmall)),
                    Spacer(),
                    SvgIcon(getAccountStatus("${cnt.businessInfoModel.value.userbusinessstatus?.id ?? ""}")),
                    width13(),
                    Text((cnt.businessInfoModel.value.userbusinessstatus?.id == 4 ||
                            cnt.businessInfoModel.value.userbusinessstatus?.id == 6)
                        ? "UNDER REVIEW"
                        : cnt.businessInfoModel.value.userbusinessstatus?.name ?? "".toString())
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
                          style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.mediumSmall),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setBottomState) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 20),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  width: 70,
                                                  height: 5,
                                                  child: Divider(color: ColorsUtils.border, thickness: 4),
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
                                            commonRowData(title: 'Commercial registration'.tr),
                                            commonRowData(title: 'Commercial license'.tr),
                                            commonRowData(title: 'Establishment card'.tr),
                                            commonRowData(title: "Owner’s ID card".tr),
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
                    height24(),
                    ListView.builder(
                      itemCount: businessMediaMultiPageList.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final title = businessMediaMultiPageList[index].title;
                        final id = '${index + 1}';
                        String typeId = businessMediaMultiPageList[index].businessmediatypeId.toString();

                        print("----${businessMediaMultiPageList[index].status}");

                        String nextDocType = "0";

                        if (index + 1 == businessMediaMultiPageList.length) {
                          nextDocType = businessMediaMultiPageList[index].businessmediatypeId.toString();
                        } else {
                          nextDocType = businessMediaMultiPageList[index + 1].businessmediatypeId.toString();
                        }
                        var totalPages = (getBusinessMediaPageList(index: index) - 1) > 0
                            ? (getBusinessMediaPageList(index: index) - 1).toString()
                            : "0";
                        if (businessMediaMultiPageList[index].status == false) {
                          return documentCommonWidget(
                            title: title ?? "".toString(),
                            totalPages: totalPages,
                            nextDocType: nextDocType,
                            index: index,
                            docId: typeId,
                            subtitle: businessMediaMultiPageList[index].name?[0] ?? "".toString(),
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
                                firstDate: DateTime.now().subtract(Duration(days: 0)),
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
                            onTap: () {},
                          );
                        } else {
                          if (businessMediaMultiPageList[index].businessmediatypeId == '' ||
                              businessMediaMultiPageList[index].businessmediatypeId == null) {
                            log.log('0000000${jsonEncode(cnt.businessInfoModel.value)}');
                            log.log('--------${cnt.uploadedBusinessMediaList[0].businessmediatypeId.toString()}');
                            var totalPages = (getBusinessMediaPageList(index: index) - 1) > 0
                                ? (getBusinessMediaPageList(index: index) - 1).toString()
                                : "0";
                            return documentUpdatedWidget(
                              totalPages: totalPages,
                              docId: typeId,
                              docCurrentStatus: businessMediaMultiPageList[index].businessmediastatusId,
                              needActionComment: businessMediaMultiPageList[index].comment,
                              nextDocType: nextDocType,
                              isEdit: true,
                              isDelete: false,
                              editTap: () {
                                String id = businessMediaMultiPageList[index].id.toString();
                                String typeId = businessMediaMultiPageList[index].businessmediatypeId.toString();
                                print('title:::${businessMediaMultiPageList[index].title}');
                                print('subtitle:::${businessMediaMultiPageList[index].name?[0] ?? ''}');
                                print('id:::${index + 1}');
                                Get.to(
                                  () => CommercialRegistrationScreen(
                                    // docData: docData,
                                    imgId: businessMediaMultiPageList[index].id,
                                    businessMediaMultiPageList: businessMediaMultiPageList,
                                    url: businessMediaMultiPageList[index].name,
                                    status: businessMediaMultiPageList[index].docStatus,
                                    metadata: businessMediaMultiPageList[index].metadata,
                                    title: typeId == '1'
                                        ? 'Commercial registration'.tr
                                        : typeId == '2'
                                            ? 'Commercial license'.tr
                                            : typeId == '3'
                                                ? 'Establishment card'.tr
                                                : typeId == '4'
                                                    ? 'Owner’s ID card'.tr
                                                    : "Other".tr ?? "",
                                    subtitle: typeId == '1'
                                        ? "Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce"
                                            .tr
                                        : typeId == '2'
                                            ? "Upload your valid Commercial License copy as issued by the Ministry of Municipality"
                                                .tr
                                            : typeId == '3'
                                                ? "Upload your valid Company Establishment card".tr
                                                : typeId == '4'
                                                    ? "Upload your authorized person or owner's valid Residency ID card".tr
                                                    : "Upload other type of document here" ?? "",
                                    id: typeId,
                                    uniqueID: businessMediaMultiPageList[index].unique_id ?? null,
                                    docStatus: businessMediaMultiPageList[index].businessmediastatusId.toString() ?? '',
                                    businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                    // docData: docData,
                                  ),
                                )?.then((value) {
                                  if (value != null) {
                                    // for (var doc in docData.keys) {
                                    //   if (docData[doc]!['id'] == id) {
                                    //     docData.remove(doc);
                                    //     //cnt.businessMediaList[index].name = value[0][index+1]
                                    //     break;
                                    //   }
                                    // }
                                    Map<String, Map<String, dynamic>> tempDocData = {};
                                    bool isReplaced = false;
                                    if (value.containsKey("4")) {
                                      if (docData.containsKey("4") || docData.containsKey("40")) {
                                        docData.keys.forEach((element) {
                                          if (value["4"]!['unique_id'] == docData[element]!['unique_id']) {
                                            isReplaced = true;
                                            docData.addAll({
                                              element: {
                                                "id": value["4"]["id"],
                                                'date': value["4"]["date"],
                                                'file': value["4"]["file"],
                                                'status': value["4"]["status"],
                                                'mediaStatus': value["4"]["mediaStatus"],
                                                'url': value["4"]["url"],
                                                'doc_expiry': value["4"]["doc_expiry"],
                                                'metadata': value["4"]["metadata"],
                                                'unique_id': value["4"]["unique_id"],
                                              }
                                            });
                                          }
                                          ;
                                        });
                                        if (docData.containsKey("40")) {
                                          if (!isReplaced) {
                                            for (int i = 40; i < 49; i++) {
                                              if (!docData.containsKey(i.toString())) {
                                                tempDocData.addAll({
                                                  i.toString(): {
                                                    "id": value["4"]["id"],
                                                    'date': value["4"]["date"],
                                                    'file': value["4"]["file"],
                                                    'status': value["4"]["status"],
                                                    'mediaStatus': value["4"]["mediaStatus"],
                                                    'url': value["4"]["url"],
                                                    'doc_expiry': value["4"]["doc_expiry"],
                                                    'metadata': value["4"]["metadata"],
                                                    'unique_id': value["4"]["unique_id"],
                                                  }
                                                });
                                                break;
                                              }
                                            }
                                          }
                                        } else {
                                          tempDocData.addAll({
                                            41.toString(): {
                                              "id": value["4"]["id"],
                                              'date': value["4"]["date"],
                                              'file': value["4"]["file"],
                                              'status': value["4"]["status"],
                                              'mediaStatus': value["4"]["mediaStatus"],
                                              'url': value["4"]["url"],
                                              'doc_expiry': value["4"]["doc_expiry"],
                                              'metadata': value["4"]["metadata"],
                                              'unique_id': value["4"]["unique_id"],
                                            }
                                          });
                                          tempDocData.addAll({
                                            40.toString(): {
                                              "id": docData["4"]!["id"],
                                              'date': docData["4"]!["date"],
                                              'file': docData["4"]!["file"],
                                              'status': docData["4"]!["status"],
                                              'mediaStatus': docData["4"]!["mediaStatus"],
                                              'url': docData["4"]!["url"],
                                              'doc_expiry': docData["4"]!["doc_expiry"],
                                              'metadata': docData["4"]!["metadata"],
                                              'unique_id': docData["4"]!["unique_id"],
                                            }
                                          });
                                          docData.remove('4');
                                        }
                                      } else {
                                        tempDocData.addAll(value);
                                      }
                                    } else {
                                      tempDocData.addAll(value);
                                    }
                                    for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                      if (businessMediaMultiPageList[index].docStatus![i] == "added") {
                                        businessMediaMultiPageList[index].id?.removeAt(i);
                                        businessMediaMultiPageList[index].metadata?.removeAt(i);
                                        businessMediaMultiPageList[index].name?.removeAt(i);
                                        businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                        i=0;
                                      }
                                    }
                                    value.keys.forEach((element) {
                                      print(element);
                                      for (int i = 0; i < value[element]!['status'].length; i++) {
                                        if (value[element]!['status'][i] == "delete") {
                                          for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                            if(businessMediaMultiPageList[index].name![i] == value[element]!['url'][i]){
                                              businessMediaMultiPageList[index].id?.removeAt(i);
                                              businessMediaMultiPageList[index].metadata?.removeAt(i);
                                              businessMediaMultiPageList[index].name?.removeAt(i);
                                              businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                              i=0;
                                            }
                                          }
                                        }
                                      }
                                      businessMediaMultiPageList[index].id?.addAll(value[element]!['id']);
                                      businessMediaMultiPageList[index].metadata?.addAll(value[element]!['metadata']);
                                      businessMediaMultiPageList[index].name?.addAll(value[element]!['url']);
                                      businessMediaMultiPageList[index].docStatus?.addAll(value[element]!['status']);
                                    });
                                    Get.snackbar('Added', 'Document added for edit.');
                                    docData.addAll(tempDocData);
                                    print(docData);
                                    setState(() {});
                                  }
                                });

                                // Map<String, Map<String, dynamic>> docData = {};
                                //
                                // String id = businessMediaMultiPageList[index].id.toString();
                                // String typeId = businessMediaMultiPageList[index].businessmediatypeId.toString();
                                //
                                // docData.addAll({
                                //   id: {'id': id, 'url': businessMediaMultiPageList[index].name, 'typeId': typeId}
                                // });
                                // print(docData);
                                // Get.to(() => DocUpdateOtpScreen(
                                //       docData: docData,
                                //       isDelete: true,
                                //     ));
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
                                        content: Text('Are you sure you want to delete this document'.tr),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('No'.tr),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(
                                              child: Text('Yes'.tr),
                                              onPressed: () async {
                                                print('====${jsonEncode(cnt.businessMediaList)}');
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

                                                if (counter < businessMediaMultiPageList.length - 1) {
                                                  if (!isalreadyadded) {
                                                    Get.snackbar('', 'Doc will be ready to delete on save');
                                                    docData.addAll({
                                                      "6": {
                                                        'date': DateTime.now().toString(),
                                                        'deleteId': businessMediaMultiPageList[index].id,
                                                        'mediaStatus': '6',
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
                                                setState(() {});
                                              }),
                                        ],
                                      );
                                    });
                              },
                              onTap: () async {
                                if (businessMediaMultiPageList[index].name![0].contains('pdf')) {
                                  if (getBusinessMediaPageList(index: index) == 1) {
                                    Get.to(() => SignedContract(
                                        isFromBusinessDoc: true,
                                        title: businessMediaMultiPageList[index].name![getBusinessMediaPageListNotDeleted(index: index)??0],
                                        pdfUrl:
                                            '${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![getBusinessMediaPageListNotDeleted(index: index)??0]}'));
                                    // var pdfFlePath = await downloadAndSavePdf('${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![0]}');
                                    // Expanded(
                                    //   child: SfPdfViewer.file(
                                    //     pdfFlePath,
                                    //     scrollDirection: PdfScrollDirection.vertical,
                                    //     canShowHyperlinkDialog: true,
                                    //   ),
                                    // );
                                  } else {
                                    List<String?> urlList = [];
                                    for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                      if (businessMediaMultiPageList[index].docStatus![i] != "delete") {
                                        urlList.add('${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![i]}');
                                        // downloadFile(
                                        //     context: context,
                                        //     isEmail: false,
                                        //     url:
                                        //         '${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![i]}');
                                      }
                                    }
                                    downloadMultipleFiles(urlList: urlList,context: context,isEmail: false,);
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildPopupDialog(context, index),
                                  );
                                }
                              },
                              title: "Others",
                              date: "",
                              token: tokenMain,
                              image: businessMediaMultiPageList[index].name?.last ?? '',
                            );
                          } else {
                            var totalPages = (getBusinessMediaPageList(index: index) - 1) > 0
                                ? (getBusinessMediaPageList(index: index) - 1).toString()
                                : "0";
                            return documentUpdatedWidget(
                              totalPages: totalPages,
                              docId: typeId,
                              nextDocType: nextDocType,
                              editTap: () {
                                String id = businessMediaMultiPageList[index].id.toString();
                                String typeId = businessMediaMultiPageList[index].businessmediatypeId.toString();
                                print('title:::${businessMediaMultiPageList[index].title}');
                                print('subtitle:::${businessMediaMultiPageList[index].name?[0] ?? ''}');
                                print('id:::${index + 1}');
                                Get.to(
                                  () => CommercialRegistrationScreen(
                                    // docData: docData,
                                    imgId: businessMediaMultiPageList[index].id,
                                    businessMediaMultiPageList: businessMediaMultiPageList,
                                    url: businessMediaMultiPageList[index].name,
                                    status: businessMediaMultiPageList[index].docStatus,
                                    metadata: businessMediaMultiPageList[index].metadata,
                                    title: typeId == '1'
                                        ? 'Commercial registration'.tr
                                        : typeId == '2'
                                            ? 'Commercial license'.tr
                                            : typeId == '3'
                                                ? 'Establishment card'.tr
                                                : typeId == '4'
                                                    ? 'Owner’s ID card'.tr
                                                    : "Other" ?? "",
                                    subtitle: typeId == '1'
                                        ? "Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce"
                                            .tr
                                        : typeId == '2'
                                            ? "Upload your valid Commercial License copy as issued by the Ministry of Municipality"
                                                .tr
                                            : typeId == '3'
                                                ? "Upload your valid Company Establishment card".tr
                                                : typeId == '4'
                                                    ? "Upload your authorized person or owner's valid Residency ID card".tr
                                                    : "Upload other type of document here" ?? "",
                                    id: typeId,
                                    uniqueID: businessMediaMultiPageList[index].unique_id ?? null,
                                    docStatus: businessMediaMultiPageList[index].businessmediastatusId.toString() ?? '',
                                    businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                    // docData: docData,
                                  ),
                                )?.then((value) {
                                  if (value != null) {
                                    // for (var doc in docData.keys) {
                                    //   if (docData[doc]!['id'] == id) {
                                    //     docData.remove(doc);
                                    //     //cnt.businessMediaList[index].name = value[0][index+1]
                                    //     break;
                                    //   }
                                    // }
                                    Map<String, Map<String, dynamic>> tempDocData = {};
                                    bool isReplaced = false;
                                    if (value.containsKey("4")) {
                                      if (docData.containsKey("4") || docData.containsKey("40")) {
                                        docData.keys.forEach((element) {
                                          if (value["4"]!['unique_id'] == docData[element]!['unique_id']) {
                                            isReplaced = true;
                                            docData.addAll({
                                              element: {
                                                "id": value["4"]["id"],
                                                'date': value["4"]["date"],
                                                'file': value["4"]["file"],
                                                'status': value["4"]["status"],
                                                'mediaStatus': value["4"]["mediaStatus"],
                                                'url': value["4"]["url"],
                                                'doc_expiry': value["4"]["doc_expiry"],
                                                'metadata': value["4"]["metadata"],
                                                'unique_id': value["4"]["unique_id"],
                                              }
                                            });
                                          }
                                          ;
                                        });
                                        if (docData.containsKey("40")) {
                                          if (!isReplaced) {
                                            for (int i = 40; i < 49; i++) {
                                              if (!docData.containsKey(i.toString())) {
                                                tempDocData.addAll({
                                                  i.toString(): {
                                                    "id": value["4"]["id"],
                                                    'date': value["4"]["date"],
                                                    'file': value["4"]["file"],
                                                    'status': value["4"]["status"],
                                                    'mediaStatus': value["4"]["mediaStatus"],
                                                    'url': value["4"]["url"],
                                                    'doc_expiry': value["4"]["doc_expiry"],
                                                    'metadata': value["4"]["metadata"],
                                                    'unique_id': value["4"]["unique_id"],
                                                  }
                                                });
                                                break;
                                              }
                                            }
                                          }
                                        } else {
                                          tempDocData.addAll({
                                            41.toString(): {
                                              "id": value["4"]["id"],
                                              'date': value["4"]["date"],
                                              'file': value["4"]["file"],
                                              'status': value["4"]["status"],
                                              'mediaStatus': value["4"]["mediaStatus"],
                                              'url': value["4"]["url"],
                                              'doc_expiry': value["4"]["doc_expiry"],
                                              'metadata': value["4"]["metadata"],
                                              'unique_id': value["4"]["unique_id"],
                                            }
                                          });
                                          tempDocData.addAll({
                                            40.toString(): {
                                              "id": docData["4"]!["id"],
                                              'date': docData["4"]!["date"],
                                              'file': docData["4"]!["file"],
                                              'status': docData["4"]!["status"],
                                              'mediaStatus': docData["4"]!["mediaStatus"],
                                              'url': docData["4"]!["url"],
                                              'doc_expiry': docData["4"]!["doc_expiry"],
                                              'metadata': docData["4"]!["metadata"],
                                              'unique_id': docData["4"]!["unique_id"],
                                            }
                                          });
                                          docData.remove('4');
                                        }
                                      } else {
                                        tempDocData.addAll(value);
                                      }
                                    } else {
                                      tempDocData.addAll(value);
                                    }

                                    for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                      if (businessMediaMultiPageList[index].docStatus![i] == "added") {
                                        businessMediaMultiPageList[index].id?.removeAt(i);
                                        businessMediaMultiPageList[index].metadata?.removeAt(i);
                                        businessMediaMultiPageList[index].name?.removeAt(i);
                                        businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                        i=0;
                                      }
                                    }
                                    value.keys.forEach((element) {
                                      print(element);
                                      for (int i = 0; i < value[element]!['status'].length; i++) {
                                        if (value[element]!['status'][i] == "delete") {
                                          for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                            if(businessMediaMultiPageList[index].name![i] == value[element]!['url'][i]){
                                              businessMediaMultiPageList[index].id?.removeAt(i);
                                              businessMediaMultiPageList[index].metadata?.removeAt(i);
                                              businessMediaMultiPageList[index].name?.removeAt(i);
                                              businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                              i=0;
                                            }
                                          }
                                        }
                                      }
                                      businessMediaMultiPageList[index].id?.addAll(value[element]!['id']);
                                      businessMediaMultiPageList[index].metadata?.addAll(value[element]!['metadata']);
                                      businessMediaMultiPageList[index].name?.addAll(value[element]!['url']);
                                      businessMediaMultiPageList[index].docStatus?.addAll(value[element]!['status']);
                                    });
                                    Get.snackbar('Added', 'Document added for edit.');
                                    docData.addAll(tempDocData);
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
                                        content: Text('Are you sure you want to delete this document'.tr),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('No'.tr),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          TextButton(
                                              child: Text('Yes'.tr),
                                              onPressed: () async {
                                                print('====${jsonEncode(businessMediaMultiPageList)}');

                                                String id = businessMediaMultiPageList[index].id.toString();
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
                                                    Get.snackbar('', 'Doc will be ready to delete on save');
                                                    docData.addAll({
                                                      id: {
                                                        'date': DateTime.now().toString(),
                                                        'deleteId': id,
                                                        'mediaStatus': '6',
                                                      }
                                                    });
                                                  } else {
                                                    Get.snackbar(
                                                        'Not allowed', 'This document is already added for edit or delete.');
                                                  }
                                                } else {
                                                  Get.snackbar('Cant remove', 'Atleast one document should be there.');
                                                }
                                                print(docData);
                                                Navigator.pop(context);
                                                setState(() {});
                                              }),
                                        ],
                                      );
                                    });
                              },
                              isDelete: false,
                              title: businessMediaMultiPageList[index].businessmediatypeId == 1
                                  ? 'Commercial registration'.tr
                                  : businessMediaMultiPageList[index].businessmediatypeId == 2
                                      ? 'Commercial license'.tr
                                      : businessMediaMultiPageList[index].businessmediatypeId == 3
                                          ? 'Establishment card'.tr
                                          : businessMediaMultiPageList[index].businessmediatypeId == 4
                                              ? 'Owner’s ID card'.tr
                                              : businessMediaMultiPageList[index].name?[0] ?? "",
                              docCurrentStatus: businessMediaMultiPageList[index].businessmediastatusId,
                              needActionComment: businessMediaMultiPageList[index].comment,
                              date: dateformat(businessMediaMultiPageList[index].doc_expiry),
                              image: businessMediaMultiPageList[index].name?.last ?? '',
                              token: tokenMain,
                              // onTap: () =>
                              onTap: () async {
                                if (businessMediaMultiPageList[index].name![0].contains('pdf')) {
                                  if (getBusinessMediaPageList(index: index) == 1) {
                                    Get.to(() => SignedContract(
                                        isFromBusinessDoc: true,
                                        title: businessMediaMultiPageList[index].name![getBusinessMediaPageListNotDeleted(index: index)??0],
                                        pdfUrl:
                                            '${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![getBusinessMediaPageListNotDeleted(index: index)??0]}'));
                                    // var pdfFlePath = await downloadAndSavePdf('${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![0]}');
                                    // Expanded(
                                    //   child: SfPdfViewer.file(
                                    //     pdfFlePath,
                                    //     scrollDirection: PdfScrollDirection.vertical,
                                    //     canShowHyperlinkDialog: true,
                                    //   ),
                                    // );
                                  } else {
                                    List<String?> urlList = [];
                                    for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                      if (businessMediaMultiPageList[index].docStatus![i] != "delete") {
                                        urlList.add('${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![i]}');
                                        // downloadFile(
                                        //     context: context,
                                        //     isEmail: false,
                                        //     url:
                                        //         '${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![i]}');
                                      }
                                    }
                                    downloadMultipleFiles(urlList: urlList,context: context,isEmail: false,);
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => _buildPopupDialog(context, index),
                                  );
                                }
                              },
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              height24(),
              cnt.businessInfoModel.value.userbusinessstatus!.name.toString() != 'Need Action'.tr
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

  int getBusinessMediaPageList({required int index}) {
    int temp = 0;
    for (int i = 0; i < businessMediaMultiPageList[index].docStatus!.length; i++) {
      if (businessMediaMultiPageList[index].docStatus![i] != "delete") {
        temp++;
      }
    }
    return temp;
  }

  int? getBusinessMediaPageListNotDeleted({required int index}){
    for(int i=0;i<businessMediaMultiPageList[index].docStatus!.length;i++){
      if(businessMediaMultiPageList[index].docStatus![i] != "delete"){
        return i;
      }
    }
    return null;
  }

  Widget _buildPopupDialog(BuildContext context, int index) {
    List<String> imageList = [];
    for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
      if (businessMediaMultiPageList[index].docStatus![i] != 'delete') {
        imageList.add(businessMediaMultiPageList[index].name![i]);
      }
    }
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
                  imageProvider: NetworkImage(
                      "${Utility.baseUrl}containers/api-business/download/${imageList[counter].toString()}?access_token=${tokenMain}"),
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

  String dateformat(String? date) {
    if (date == null || date == '') {
      return '';
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
      DateTime parseDate = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('dd/MM/yyyy');
      var outputDate = outputFormat.format(inputDate);
      return outputDate.toString();
    }
  }

  onBackCheck() {
    if (docData.length > 0) {
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
              // final dateList = docData.values
              //     .toList()
              //     .where((e) => e['date'].toString().isNotEmpty);
              // final fileList = docData.values
              //     .toList()
              //     .where((e) => e['url'].isBlank);
              // if (dateList.length != fileList.length) {
              //   Get.snackbar(
              //       'error', 'File or ${'Expiration Date cannot be Empty'.tr}');
              //   //msg
              //   return;
              // }
              Get.to(
                () => DocUpdateOtpScreen(
                  docData: docData,
                ),
              );
            },
            child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Save'),
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
    required String nextDocType,
    required int index,
    required String totalPages,
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
                      Text(title, style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small)),
                      height8(),
                      Text("$subtitle", style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small)),
                    ],
                  ),
                ),
                width20(),
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        print("isSubmit.toString()${isSubmit.toString()}");
                        print(".....>>>>>${index.toString()}");
                        String typeId = businessMediaMultiPageList[index].businessmediatypeId.toString();
                        //getImageFile(id);
                        businessMediaMultiPageList[index].unique_id != "" && businessMediaMultiPageList[index].unique_id != null
                            ? Get.to(
                                () => CommercialRegistrationScreen(
                                  // docData: docData,
                                  imgId: businessMediaMultiPageList[index].id,
                                  businessMediaMultiPageList: businessMediaMultiPageList,
                                  url: businessMediaMultiPageList[index].name,
                                  status: businessMediaMultiPageList[index].docStatus,
                                  metadata: businessMediaMultiPageList[index].metadata,
                                  title: typeId == '1'
                                      ? 'Commercial registration'.tr
                                      : typeId == '2'
                                          ? 'Commercial license'.tr
                                          : typeId == '3'
                                              ? 'Establishment card'.tr
                                              : typeId == '4'
                                                  ? 'Owner’s ID card'.tr
                                                  : "Other".tr ?? "",
                                  subtitle: typeId == '1'
                                      ? "Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce"
                                          .tr
                                      : typeId == '2'
                                          ? "Upload your valid Commercial License copy as issued by the Ministry of Municipality"
                                              .tr
                                          : typeId == '3'
                                              ? "Upload your valid Company Establishment card".tr
                                              : typeId == '4'
                                                  ? "Upload your authorized person or owner's valid Residency ID card".tr
                                                  : "Upload other type of document here".tr ?? "",
                                  id: typeId,
                                  uniqueID: businessMediaMultiPageList[index].unique_id ?? null,
                                  docStatus: businessMediaMultiPageList[index].businessmediastatusId.toString() ?? '',
                                  businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                  isFirstTime: true,
                                  // docData: docData,
                                ),
                              )?.then((value) {
                                if (value != null) {
                                  Map<String, Map<String, dynamic>> tempDocData = {};
                                  bool isReplaced = false;
                                  if (value.containsKey("4")) {
                                    if (docData.containsKey("4") || docData.containsKey("40")) {
                                      docData.keys.forEach((element) {
                                        if (value["4"]!['unique_id'] == docData[element]!['unique_id']) {
                                          isReplaced = true;
                                          docData.addAll({
                                            element: {
                                              "id": value["4"]["id"],
                                              'date': value["4"]["date"],
                                              'file': value["4"]["file"],
                                              'status': value["4"]["status"],
                                              'mediaStatus': value["4"]["mediaStatus"],
                                              'url': value["4"]["url"],
                                              'doc_expiry': value["4"]["doc_expiry"],
                                              'metadata': value["4"]["metadata"],
                                              'unique_id': value["4"]["unique_id"],
                                            }
                                          });
                                        }
                                        ;
                                      });
                                      if (docData.containsKey("40")) {
                                        if (!isReplaced) {
                                          for (int i = 40; i < 49; i++) {
                                            if (!docData.containsKey(i.toString())) {
                                              tempDocData.addAll({
                                                i.toString(): {
                                                  "id": value["4"]["id"],
                                                  'date': value["4"]["date"],
                                                  'file': value["4"]["file"],
                                                  'status': value["4"]["status"],
                                                  'mediaStatus': value["4"]["mediaStatus"],
                                                  'url': value["4"]["url"],
                                                  'doc_expiry': value["4"]["doc_expiry"],
                                                  'metadata': value["4"]["metadata"],
                                                  'unique_id': value["4"]["unique_id"],
                                                }
                                              });
                                              break;
                                            }
                                          }
                                        }
                                      } else {
                                        tempDocData.addAll({
                                          41.toString(): {
                                            "id": value["4"]["id"],
                                            'date': value["4"]["date"],
                                            'file': value["4"]["file"],
                                            'status': value["4"]["status"],
                                            'mediaStatus': value["4"]["mediaStatus"],
                                            'url': value["4"]["url"],
                                            'doc_expiry': value["4"]["doc_expiry"],
                                            'metadata': value["4"]["metadata"],
                                            'unique_id': value["4"]["unique_id"],
                                          }
                                        });
                                        tempDocData.addAll({
                                          40.toString(): {
                                            "id": docData["4"]!["id"],
                                            'date': docData["4"]!["date"],
                                            'file': docData["4"]!["file"],
                                            'status': docData["4"]!["status"],
                                            'mediaStatus': docData["4"]!["mediaStatus"],
                                            'url': docData["4"]!["url"],
                                            'doc_expiry': docData["4"]!["doc_expiry"],
                                            'metadata': docData["4"]!["metadata"],
                                            'unique_id': docData["4"]!["unique_id"],
                                          }
                                        });
                                        docData.remove('4');
                                      }
                                    } else {
                                      tempDocData.addAll(value);
                                    }
                                  } else {
                                    tempDocData.addAll(value);
                                  }

                                  for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                    if (businessMediaMultiPageList[index].metadata![i] == "") {
                                      businessMediaMultiPageList[index].id?.removeAt(i);
                                      businessMediaMultiPageList[index].metadata?.removeAt(i);
                                      businessMediaMultiPageList[index].name?.removeAt(i);
                                      businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                      i=0;
                                    }
                                  }
                                  for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                    if (businessMediaMultiPageList[index].docStatus![i] == "added") {
                                      businessMediaMultiPageList[index].id?.removeAt(i);
                                      businessMediaMultiPageList[index].metadata?.removeAt(i);
                                      businessMediaMultiPageList[index].name?.removeAt(i);
                                      businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                      i=0;
                                    }
                                  }
                                  value.keys.forEach((element) {
                                    print(element);
                                    for (int i = 0; i < value[element]!['status'].length; i++) {
                                      if (value[element]!['status'][i] == "delete") {
                                        for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                          if(businessMediaMultiPageList[index].name![i] == value[element]!['url'][i]){
                                            businessMediaMultiPageList[index].id?.removeAt(i);
                                            businessMediaMultiPageList[index].metadata?.removeAt(i);
                                            businessMediaMultiPageList[index].name?.removeAt(i);
                                            businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                            i=0;
                                          }
                                        }
                                      }
                                    }
                                    businessMediaMultiPageList[index].id?.addAll(value[element]!['id']);
                                    businessMediaMultiPageList[index].metadata?.addAll(value[element]!['metadata']);
                                    businessMediaMultiPageList[index].name?.addAll(value[element]!['url']);
                                    businessMediaMultiPageList[index].docStatus?.addAll(value[element]!['status']);
                                  });
                                  Get.snackbar('Added', 'Document added to Save.');
                                  // if (docData.containsKey(data.keys.first)) {
                                  //   Map<String, dynamic>? tempMap = docData[data.keys.first];
                                  //   docData.remove(data.keys.first);
                                  //   docData.addAll(
                                  //       {(double.parse(data.keys.first.toString()) + 0.1).toString(): tempMap ?? {}});
                                  // }
                                  // double keyName = data.keys.first;
                                  // for (int i = 1; i <10; i++) {
                                  //   keyName = double.parse(data.keys.first.toString()) + 0.1;
                                  //   if (!docData.containsKey(keyName.toString())) {
                                  //     docData.addAll(value);
                                  //     break;
                                  //   }
                                  // }
                                  docData.addAll(tempDocData);
                                  print(docData);
                                  setState(() {});
                                }
                              })
                            : Get.to(
                                () => CommercialRegistrationScreen(
                                  // docData: docData,
                                  imgId: businessMediaMultiPageList[index].id,
                                  businessMediaMultiPageList: businessMediaMultiPageList,
                                  url: businessMediaMultiPageList[index].name,
                                  status: businessMediaMultiPageList[index].docStatus,
                                  metadata: businessMediaMultiPageList[index].metadata,
                                  title: typeId == '1'
                                      ? 'Commercial registration'.tr
                                      : typeId == '2'
                                      ? 'Commercial license'.tr
                                      : typeId == '3'
                                      ? 'Establishment card'.tr
                                      : typeId == '4'
                                      ? 'Owner’s ID card'.tr
                                      : "Other" ?? "",
                                  subtitle: typeId == '1'
                                      ? "Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce"
                                      .tr
                                      : typeId == '2'
                                      ? "Upload your valid Commercial License copy as issued by the Ministry of Municipality"
                                      .tr
                                      : typeId == '3'
                                      ? "Upload your valid Company Establishment card".tr
                                      : typeId == '4'
                                      ? "Upload your authorized person or owner's valid Residency ID card".tr
                                      : "Upload other type of document here" ?? "",
                                  id: typeId,
                                  uniqueID: businessMediaMultiPageList[index].unique_id ?? null,
                                  docStatus: businessMediaMultiPageList[index].businessmediastatusId.toString() ?? '',
                                  businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                  isFirstTime: true,

                                  // docData: docData,
                                ),
                              )?.then((value) {
                                if (value != null) {
                                  // for (var doc in docData.keys) {
                                  //   if (docData[doc]!['unique_id'] == value[doc]['unique_id']) {
                                  //     docData.remove(doc);
                                  //     //cnt.businessMediaList[index].name = value[0][index+1]
                                  //     break;
                                  //   }
                                  // }
                                  Map<String, Map<String, dynamic>> tempDocData = {};
                                  bool isReplaced = false;
                                  if (value.containsKey("4")) {
                                    if (docData.containsKey("4") || docData.containsKey("40")) {
                                      docData.keys.forEach((element) {
                                        if (value["4"]!['unique_id'] == docData[element]!['unique_id']) {
                                          isReplaced = true;
                                          docData.addAll({
                                            element: {
                                              "id": value["4"]["id"],
                                              'date': value["4"]["date"],
                                              'file': value["4"]["file"],
                                              'status': value["4"]["status"],
                                              'mediaStatus': value["4"]["mediaStatus"],
                                              'url': value["4"]["url"],
                                              'doc_expiry': value["4"]["doc_expiry"],
                                              'metadata': value["4"]["metadata"],
                                              'unique_id': value["4"]["unique_id"],
                                            }
                                          });
                                        }
                                        ;
                                      });
                                      if (docData.containsKey("40")) {
                                        if (!isReplaced) {
                                          for (int i = 40; i < 49; i++) {
                                            if (!docData.containsKey(i.toString())) {
                                              tempDocData.addAll({
                                                i.toString(): {
                                                  "id": value["4"]["id"],
                                                  'date': value["4"]["date"],
                                                  'file': value["4"]["file"],
                                                  'status': value["4"]["status"],
                                                  'mediaStatus': value["4"]["mediaStatus"],
                                                  'url': value["4"]["url"],
                                                  'doc_expiry': value["4"]["doc_expiry"],
                                                  'metadata': value["4"]["metadata"],
                                                  'unique_id': value["4"]["unique_id"],
                                                }
                                              });
                                              break;
                                            }
                                          }
                                        }
                                      } else {
                                        tempDocData.addAll({
                                          41.toString(): {
                                            "id": value["4"]["id"],
                                            'date': value["4"]["date"],
                                            'file': value["4"]["file"],
                                            'status': value["4"]["status"],
                                            'mediaStatus': value["4"]["mediaStatus"],
                                            'url': value["4"]["url"],
                                            'doc_expiry': value["4"]["doc_expiry"],
                                            'metadata': value["4"]["metadata"],
                                            'unique_id': value["4"]["unique_id"],
                                          }
                                        });
                                        tempDocData.addAll({
                                          40.toString(): {
                                            "id": docData["4"]!["id"],
                                            'date': docData["4"]!["date"],
                                            'file': docData["4"]!["file"],
                                            'status': docData["4"]!["status"],
                                            'mediaStatus': docData["4"]!["mediaStatus"],
                                            'url': docData["4"]!["url"],
                                            'doc_expiry': docData["4"]!["doc_expiry"],
                                            'metadata': docData["4"]!["metadata"],
                                            'unique_id': docData["4"]!["unique_id"],
                                          }
                                        });
                                        docData.remove('4');
                                      }
                                    } else {
                                      tempDocData.addAll(value);
                                    }
                                  } else {
                                    tempDocData.addAll(value);
                                  }
                                  for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                    if (businessMediaMultiPageList[index].metadata![i] == "") {
                                      businessMediaMultiPageList[index].id?.removeAt(i);
                                      businessMediaMultiPageList[index].metadata?.removeAt(i);
                                      businessMediaMultiPageList[index].name?.removeAt(i);
                                      businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                      i=0;
                                    }
                                  }
                                  for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                    if (businessMediaMultiPageList[index].docStatus![i] == "added") {
                                      businessMediaMultiPageList[index].id?.removeAt(i);
                                      businessMediaMultiPageList[index].metadata?.removeAt(i);
                                      businessMediaMultiPageList[index].name?.removeAt(i);
                                      businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                      i=0;
                                    }
                                  }
                                  value.keys.forEach((element) {
                                    print(element);
                                    for (int i = 0; i < value[element]!['status'].length; i++) {
                                      if (value[element]!['status'][i] == "delete") {
                                        for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                                          if(businessMediaMultiPageList[index].name![i] == value[element]!['url'][i]){
                                            businessMediaMultiPageList[index].id?.removeAt(i);
                                            businessMediaMultiPageList[index].metadata?.removeAt(i);
                                            businessMediaMultiPageList[index].name?.removeAt(i);
                                            businessMediaMultiPageList[index].docStatus?.removeAt(i);
                                            i=0;
                                          }
                                        }
                                      }
                                    }
                                    businessMediaMultiPageList[index].id?.addAll(value[element]!['id']);
                                    businessMediaMultiPageList[index].metadata?.addAll(value[element]!['metadata']);
                                    businessMediaMultiPageList[index].name?.addAll(value[element]!['url']);
                                    businessMediaMultiPageList[index].docStatus?.addAll(value[element]!['status']);
                                  });

                                  Get.snackbar('Added', 'Document added to Save.');
                                  docData.addAll(tempDocData);
                                  print(docData);
                                  setState(() {});
                                }
                              });
                      },
                      child: Icon(
                        Icons.file_upload_outlined,
                        color: ColorsUtils.accent,
                      ),
                    ),
                    height12(),
                    businessMediaMultiPageList[index].name![0].contains('.') ?
                    InkWell(
                      onTap: () async {
                        if (businessMediaMultiPageList[index].name![0].contains('pdf')) {
                          if (getBusinessMediaPageList(index: index) == 1) {
                            Get.to(() => SignedContract(
                                isFromBusinessDoc: true,
                                title: businessMediaMultiPageList[index].name![getBusinessMediaPageListNotDeleted(index: index)??0],
                                pdfUrl:
                                '${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![getBusinessMediaPageListNotDeleted(index: index)??0]}'));
                            // var pdfFlePath = await downloadAndSavePdf('${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![0]}');
                            // Expanded(
                            //   child: SfPdfViewer.file(
                            //     pdfFlePath,
                            //     scrollDirection: PdfScrollDirection.vertical,
                            //     canShowHyperlinkDialog: true,
                            //   ),
                            // );
                          } else {
                            List<String?> urlList = [];
                            for (int i = 0; i < businessMediaMultiPageList[index].name!.length; i++) {
                              if (businessMediaMultiPageList[index].docStatus![i] != "delete") {
                                urlList.add('${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![i]}');
                                // downloadFile(
                                //     context: context,
                                //     isEmail: false,
                                //     url:
                                //         '${Utility.baseUrl}containers/api-business/download/${businessMediaMultiPageList[index].name![i]}');
                              }
                            }
                            downloadMultipleFiles(urlList: urlList,context: context,isEmail: false,);
                          }
                        } else {
                          if (businessMediaMultiPageList[index].name![0].contains('.')) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => _buildPopupDialog(context, index),
                            );
                          }
                        }
                      },
                      child: Icon(
                        Icons.remove_red_eye,
                        color: ColorsUtils.accent,
                      ),
                    ) : SizedBox(),
                  ],
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
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: ColorsUtils.border)),
                        child: Stack(
                          children: [
                            !docData.containsKey(returnDocId(docId, subtitle))
                                ? placeHolderImage()
                                : docData[returnDocId(docId, subtitle)]!['url'][0].toString().isEmpty
                                    ? placeHolderImage()
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: docData[returnDocId(docId, subtitle)]!['url'][0].toString().contains('pdf')
                                            ? Image.asset(
                                                Images.docPDF,
                                                fit: BoxFit.fill,
                                                height: Get.height * 0.125,
                                                width: Get.width * 0.25,
                                              )
                                            : Image.network(
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value: loadingProgress.expectedTotalBytes != null
                                                          ? loadingProgress.cumulativeBytesLoaded /
                                                              loadingProgress.expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                                "${Utility.baseUrl}containers/api-business/download/${docData[returnDocId(docId, subtitle)]!['url'][0].toString()}?access_token=${tokenMain}",
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                            int.parse(totalPages) > 0
                                ? Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: ColorsUtils.accent.withOpacity(0.5))),
                                        child: Text(
                                          "+$totalPages",
                                          style: ThemeUtils.maroonBold
                                              .copyWith(fontSize: FontUtils.verySmall, color: ColorsUtils.accent),
                                        )),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        height24(),
        Row(
          children: [
            docId == "4" && moreThanOneOwnerID()
                ? InkWell(
                    onTap: () {
                      businessMediaMultiPageList.removeAt(index);
                      orderringDocList();
                      setState(() {});
                    },
                    child: Text(
                      'Remove'.tr,
                      style: ThemeUtils.blackBold.copyWith(color: ColorsUtils.accent),
                    ),
                  )
                : SizedBox(),
            Spacer(),
            docId == "4" && nextDocType != "4" && subtitle.contains(".") && !MaximumOwnerIdAdded()
                ? InkWell(
                    onTap: () {
                      businessMediaMultiPageList.add(BusinessmediaMultiPage(
                        id: [0],
                        title: 'Owner’s ID card'.tr,
                        status: false,
                        businessmediatypeId: 4,
                        name: ["Upload your authorized person or owner's valid Residency ID card".tr],
                        created: "",
                        doc_expiry: "",
                        metadata: [""],
                        unique_id: "",
                        businessmediastatusId: null,
                        comment: "",
                        docStatus: ["old"],
                      ));
                      orderringDocList();
                      setState(() {});
                    },
                    child: Text(
                      '+ Add More'.tr,
                      style: ThemeUtils.blackBold.copyWith(color: ColorsUtils.accent),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        dividerData(),
      ],
    );
  }

  bool moreThanOneOwnerID() {
    int counter = 0;
    for (int i = 0; i < businessMediaMultiPageList.length; i++) {
      if (businessMediaMultiPageList[i].businessmediatypeId == 4) {
        counter++;
      }
    }
    if (counter > 1) {
      return true;
    } else {
      return false;
    }
  }

  orderringDocList() {
    List<BusinessmediaMultiPage> tempList = [];
    List<int> seq = [4, 1, 2, 3];
    for (int i = 0; i < seq.length; i++) {
      // double tempid = seq[i].toDouble();
      for (int j = 0; j < businessMediaMultiPageList.length; j++) {
        if (businessMediaMultiPageList[j].businessmediatypeId == seq[i]) {
          // tempid = 0.1 + tempid;
          tempList.add(businessMediaMultiPageList[j]);
          // tempList.last.businessmediatypeId = tempid;
        }
      }
    }
    for (int j = 0; j < businessMediaMultiPageList.length; j++) {
      if (!seq.contains(businessMediaMultiPageList[j].businessmediatypeId)) {
        tempList.add(businessMediaMultiPageList[j]);
      }
    }
    businessMediaMultiPageList.clear();
    businessMediaMultiPageList.value = tempList;
  }

  String returnDocId(String docId, String name) {
    String temp = docId;
    bool isFounded = false;
    if (int.parse(docId) == 4) {
      docData.keys.forEach((element) {
        print(docData[element]!["url"][0]);
        if (name == docData[element]!["url"][0].toString()) {
          isFounded = true;
          temp = element;
        }
      });
      if (!isFounded) {
        temp = "50";
      }
      return temp;
    } else {
      return temp;
    }
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
    int? docCurrentStatus,
    String? needActionComment,
    required String nextDocType,
    required String docId,
    required String totalPages,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: InkWell(
        // onTap: onTap,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$title",
                                        overflow: TextOverflow.ellipsis,
                                        style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small)),
                                    height8(),
                                    isDelete == false
                                        ? ((docCurrentStatus == 4 || docCurrentStatus == 6)
                                            ? getAccountStatusName("${4}")
                                            : getAccountStatusName("${docCurrentStatus}"))
                                        : SizedBox(),
                                    height8(),
                                    docCurrentStatus == 3
                                        ? Text(needActionComment.toString(),
                                            style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small))
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              isDelete == false
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: deleteTap,
                                      child: Icon(
                                        Icons.delete,
                                        color: ColorsUtils.accent,
                                      ),
                                    ),
                              width20(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  isEdit == false
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: editTap,
                                          child: Icon(
                                            Icons.edit,
                                            color: ColorsUtils.accent,
                                          ),
                                        ),
                                  height12(),
                                  InkWell(
                                    onTap: onTap,
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: ColorsUtils.accent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // height8(),
                          // Text("$date", style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small)),
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
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: image == null
                                ? Image.asset(
                                    Images.docPDF,
                                    fit: BoxFit.fill,
                                    height: 20,
                                    width: 20,
                                  )
                                : image.contains('pdf')
                                    ? Image.asset(
                                        Images.docPDF,
                                        fit: BoxFit.fill,
                                        height: 20,
                                        width: 20,
                                      )
                                    : Image.network(
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
                                        "${Utility.baseUrl}containers/api-business/download/${image}?access_token=${token}",
                                        fit: BoxFit.fill,
                                      ),
                          ),
                          int.parse(totalPages) > 0
                              ? Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: ColorsUtils.accent.withOpacity(0.5))),
                                      child: Text(
                                        "+$totalPages",
                                        style: ThemeUtils.maroonBold
                                            .copyWith(fontSize: FontUtils.verySmall, color: ColorsUtils.accent),
                                      )),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            height24(),
            docId == "4" && nextDocType != "4" && image!.contains(".")
                ? Row(
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: () {
                          businessMediaMultiPageList.add(BusinessmediaMultiPage(
                            id: [0],
                            title: 'Owner’s ID card'.tr,
                            status: false,
                            businessmediatypeId: 4,
                            name: ["Upload your authorized person or owner's valid Residency ID card".tr],
                            created: "",
                            doc_expiry: "",
                            metadata: [""],
                            unique_id: "",
                            businessmediastatusId: null,
                            comment: "",
                            docStatus: ["old"],
                          ));
                          orderringDocList();
                          setState(() {});
                        },
                        child: Text(
                          '+ Add More'.tr,
                          style: ThemeUtils.blackBold.copyWith(color: ColorsUtils.accent),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            dividerData(),
          ],
        ),
      ),
    );
  }

  bottomSheetAddMore() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(bottom: 30, left: 24, right: 24, top: 24),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Please select Document type from below",
                  style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                height28(),
                Column(
                  children: [
                    commonCardBottomSheet(text: 'Owner\'s ID card'.tr),
                    commonCardBottomSheet(text: "Other".tr),
                  ],
                ),
                height12(),
              ],
            )
            /*Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Option'.tr,
                style:
                    ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
              ),
              height10(),
              Text(
                'Please select document format to upload from below'.tr,
                style: ThemeUtils.blackSemiBold
                    .copyWith(fontSize: FontUtils.small),
              ),
              height8(),
              dividerData(),
              height24(),
              commonRowDataBottomSheet(img: Images.addInvoice, title: 'PDF'.tr),
              height24(),
              commonRowDataBottomSheet(
                  img: Images.addInvoice, title: 'Image'.tr),
            ],
          ),*/
            );
      },
    );
  }

  Widget commonCardBottomSheet({required String text}) {
    return InkWell(
      // title: 'Owner’s ID card'.tr,
      // name:
      // "Upload your authorized persion or owner's valid Residency ID card"
      //     .tr,
      // businessmediatypeId: 4,
      // status: false),
      onTap: () {
        Get.back();
        if (text.contains("card")) {
          businessMediaMultiPageList.add(BusinessmediaMultiPage(
            id: [0],
            title: 'Owner’s ID card'.tr,
            status: false,
            businessmediatypeId: "4",
            name: ["Upload your authorized person or owner's valid Residency ID card".tr],
            created: "",
            doc_expiry: "",
            metadata: [""],
            unique_id: "",
            businessmediastatusId: null,
            comment: "",
            docStatus: ["old"],
          ));
        } else {
          businessMediaMultiPageList.add(BusinessmediaMultiPage(
            id: [0],
            title: 'Other'.tr,
            status: false,
            businessmediatypeId: "6",
            name: ["Upload other type of document here".tr],
            created: "",
            doc_expiry: "",
            metadata: [""],
            unique_id: "",
            businessmediastatusId: null,
            comment: "",
            docStatus: ["old"],
          ));
        }
        setState(() {});
      },
      child: Column(
        children: [
          height12(),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }

  bool MaximumOwnerIdAdded() {
    int counter = 0;
    for (int i = 0; i < businessMediaMultiPageList.length; i++) {
      if (businessMediaMultiPageList[i].businessmediatypeId == 4) {
        counter++;
      }
    }
    if (counter >= 7) {
      return true;
    } else {
      return false;
    }
  }

  Future<File> downloadAndSavePdf(String? pdfURL) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sadadContract_${DateTime.now().day}.pdf');
    // if (await file.exists()) {
    //   print('file==>>${file.path}');
    //   return file;
    // }
    final response = await http.get(Uri.parse(pdfURL.toString()), headers: {'Authorization': tokenMain.toString()});
    await file.writeAsBytes(response.bodyBytes);
    print('file==>>${file.path}');

    return file;
  }

  Future getImageFile(String title) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    if (result != null) {
      File? file = File(result.files.single.path!);
      print('DOC=>${file}');
      cnt.imageName = file.path.split("/").last;
      String str = file.path;
      String extension = str.substring(str.lastIndexOf('.') + 1);
      print('extension:::$extension');
      if (extension == 'jpeg' ||
          extension == 'png' ||
          extension == 'jpg' ||
          extension == 'JPEG' ||
          extension == 'PNG' ||
          extension == 'JPG' ||
          extension == 'pdf') {
        cnt.image = file;
        await bankA.uploadBusinessImage(file: cnt.image!, context: context);
        print('image is ${bankA.uploadedUrl.value}');
        if (docData.containsKey(title)) {
          docData[title]!['file'] = file.path;
          docData[title]!['url'] = bankA.uploadedUrl.value;
        } else {
          docData.addAll({
            title: {'date': '', 'file': file.path, 'url': bankA.uploadedUrl.value}
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
