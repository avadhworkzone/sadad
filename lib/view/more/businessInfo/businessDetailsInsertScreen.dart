import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/model/repo/more/businessInfo/businessInfoRepo.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/uploadCL/CLUploadNewFlowScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';

import '../../../controller/moreController.dart';
import '../../../util/downloadFile.dart';
import '../../../widget/moreScreenWidget.dart';
import '../moreOtpScreen.dart';
import '../signedContract/signedContract.dart';
import 'documentRegisterScreen/commercialRegisterScreen.dart';
import 'uploadCR/CRUploadNewFlowScreen.dart';
import 'uploadEstablishmentCard/EstablishmentCardUploadNewFlowScreen.dart';
import 'uploadOther/OtherDocumentUploadNewFlowScreen.dart';
import 'uploadOwnerID/ownerIDUploadNewFlowScreen.dart';

class BusinessDetailInsert extends StatefulWidget {
  bool? isFirstTime;

  BusinessDetailInsert({Key? key, this.isFirstTime}) : super(key: key);

  @override
  _BusinessDetailInsertState createState() => _BusinessDetailInsertState();
}

class _BusinessDetailInsertState extends State<BusinessDetailInsert> with BaseService {
  TextEditingController zone = TextEditingController();
  TextEditingController streetNo = TextEditingController();
  TextEditingController bldgNo = TextEditingController();
  TextEditingController unitNo = TextEditingController();
  TextEditingController businessName = TextEditingController();
  TextEditingController businessRegistrationNumber = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  BusinessInfoRepo businessInfoRepo = BusinessInfoRepo();
  bool expansionKey1 = false;
  bool expansionKey2 = false;
  bool isbusinessNameChange = false;
  bool isbusinessRegistrationNumberChange = false;
  bool isemailIdChange = false;
  bool isunitNoChange = false;
  bool isbldgNoChange = false;
  bool isstreetNoChange = false;
  bool iszoneChange = false;
  bool ismobileNumberChange = false;
  bool hideActionBtn = false;
  Rx<BusinessInfoResponseModel> businessInfoModel = BusinessInfoResponseModel().obs;
  final cnt = Get.find<BusinessInfoViewModel>();
  final _formKey = GlobalKey<FormState>();
  bool isSelected = false;
  String? currentMediaTypeID = '';
  final bankA = Get.find<BankAccountViewModel>();
  RxList<Businessmedia> businessMediaList = <Businessmedia>[].obs;
  Map<String, Map<String, dynamic>> businessDoc = {};
  String? tokenMain;
  RxList<BusinessmediaMultiPage> businessMediaMultiPageList = <BusinessmediaMultiPage>[].obs;
  RxList<BusinessmediaMultiPage> businessMediaListToForward = <BusinessmediaMultiPage>[].obs;
  final cntTemp = Get.put(MoreController());
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  bool readOnly = false;
  init() async {
    if (widget.isFirstTime == true) {
      businessName.text = await encryptedSharedPreferences.getString("name");
      emailId.text = await encryptedSharedPreferences.getString("email");
      mobileNumber.text = Utility.userPhone;
    }
    //getAllBusinessDetails();
  }

  getAllBusinessDetails() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //showLoadingDialog(context: context);
      cntTemp.getToken();
      cntTemp.getToken();
      await businessDetailCnt.getBusinessInfo(context);
      // log("${businessDetailCnt.bankAccountList.length}",
      //await businessDetailCnt.getBankData(context);
      print(".../..../..../..../${businessDetailCnt.businessInfoModel.value.streetnumber}");
      Utility.userPhone = businessDetailCnt.businessInfoModel.value.user?.cellnumber ?? "";
      Utility.userbusinessstatus = businessDetailCnt.businessInfoModel.value.userbusinessstatusId ?? 0;
      setupData();
      setupOnlineData();
      setState(() {});
      //Get.back();
      //hideLoadingDialog();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
    getAllBusinessDetails();
    cnt.image = null;
    //setupData();
    //setupOnlineData();
    gettingToken();
  }

  int key = 0;

  setupOnlineData() {
    businessMediaListToForward.clear();
    cnt.uploadedBusinessMediaList = businessDetailCnt.businessInfoModel.value.businessmedia ?? [];
    cnt.businessMediaList.clear();
    cnt.assignBusinessMedia();
    bool isOther = false;
    for (int i = 0; i < cnt.uploadedBusinessMediaList.length; i++) {
      var isFounded = false;
      for (int j = 0; j < businessMediaListToForward.length; j++) {
        if (cnt.uploadedBusinessMediaList[i].unique_id == businessMediaListToForward[j].unique_id &&
            cnt.uploadedBusinessMediaList[i].businessmediatypeId == businessMediaListToForward[j].businessmediatypeId) {
          businessMediaListToForward[j].metadata!.add(cnt.uploadedBusinessMediaList[i].metadata ?? '');
          businessMediaListToForward[j].id!.add(cnt.uploadedBusinessMediaList[i].id ?? 0);
          businessMediaListToForward[j].name!.add(cnt.uploadedBusinessMediaList[i].name ?? '');
          businessMediaListToForward[j].docStatus!.add('old');
          businessMediaListToForward[j].businessmediastatusId = businessMediaListToForward[j].businessmediastatusId;
          businessMediaListToForward[j].comment = businessMediaListToForward[j].comment;
          isFounded = true;
        } else if (cnt.uploadedBusinessMediaList[i].unique_id == businessMediaListToForward[j].unique_id &&
            cnt.uploadedBusinessMediaList[i].businessmediatypeId == null) {
          isOther = true;
          businessMediaListToForward[j].metadata!.add(cnt.uploadedBusinessMediaList[i].metadata ?? '');
          businessMediaListToForward[j].id!.add(cnt.uploadedBusinessMediaList[i].id ?? 0);
          businessMediaListToForward[j].name!.add(cnt.uploadedBusinessMediaList[i].name ?? '');
          businessMediaListToForward[j].docStatus!.add('old');
          businessMediaListToForward[j].businessmediastatusId = businessMediaListToForward[j].businessmediastatusId;
          businessMediaListToForward[j].comment = businessMediaListToForward[j].comment;
          isFounded = true;
        }
      }
      if (!isFounded) {
        if (cnt.uploadedBusinessMediaList[i].businessmediatypeId != null) {
          businessMediaListToForward.add(BusinessmediaMultiPage(
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
          businessMediaListToForward.add(BusinessmediaMultiPage(
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
    // for (int i = 0; i < cnt.businessMediaList.length; i++) {
    //   businessMediaListToForward.add(BusinessmediaMultiPage(
    //     id: [cnt.businessMediaList[i].id ?? 0],
    //     title: cnt.businessMediaList[i].title.toString(),
    //     status: cnt.businessMediaList[i].status,
    //     businessmediatypeId: cnt.businessMediaList[i].businessmediatypeId ?? "",
    //     name: [cnt.businessMediaList[i].name ?? ""],
    //     created: cnt.businessMediaList[i].created ?? "",
    //     doc_expiry: cnt.businessMediaList[i].doc_expiry ?? "",
    //     metadata: [cnt.businessMediaList[i].metadata ?? ""],
    //     unique_id: cnt.businessMediaList[i].unique_id ?? "",
    //     businessmediastatusId: cnt.businessMediaList[i].businessmediastatusId,
    //     comment: cnt.businessMediaList[i].comment,
    //     docStatus: ["old"],
    //   ));
    // }
//businessMediaListToForward >>> businessmediatypeId >> 4,1,2,3
    List<BusinessmediaMultiPage> tempList = [];
    List<int> seq = [4, 1, 2, 3];
    for (int i = 0; i < seq.length; i++) {
      for (int j = 0; j < businessMediaListToForward.length; j++) {
        if (businessMediaListToForward[j].businessmediatypeId == seq[i]) {
          tempList.add(businessMediaListToForward[j]);
        }
      }
    }
    for (int j = 0; j < businessMediaListToForward.length; j++) {
      if (!seq.contains(businessMediaListToForward[j].businessmediatypeId)) {
        tempList.add(businessMediaListToForward[j]);
      }
    }
    businessMediaListToForward.clear();
    businessMediaListToForward.value = tempList;
    gettingToken();
  }

  setupData() {
    businessMediaMultiPageList.clear();
    if (cnt.businessInfoModel.value.basicdetailsstatusId == 4 || cnt.businessInfoModel.value.basicdetailsstatusId == 6) {
      hideActionBtn = true;
      readOnly = true;
    }
    if (widget.isFirstTime == false) {
      businessName.text = cnt.businessInfoModel.value.businessname!;
      emailId.text = cnt.businessInfoModel.value.user!.email ?? "";
      mobileNumber.text = cnt.businessInfoModel.value.user?.cellnumber ?? "";
      businessRegistrationNumber.text = cnt.businessInfoModel.value.merchantregisterationnumber ?? "";
      streetNo.text = cnt.businessInfoModel.value.streetnumber ?? "";
      bldgNo.text = cnt.businessInfoModel.value.buildingnumber ?? "";
      unitNo.text = cnt.businessInfoModel.value.unitnumber ?? "";
      zone.text = cnt.businessInfoModel.value.zonenumber ?? "";
    }

    cnt.assignBusinessMedia();
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
    orderringDocList();
    setState(() {});
  }

  orderringDocList() {
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
  }

  gettingToken() async {
    tokenMain = await encryptedSharedPreferences.getString('token');
    setState(() {});
    print(tokenMain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Information'.tr,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.left,
                ),
                height15(),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: ColorsUtils.lightBg,
                      width: 1.5,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  child: ExpansionTile(key: Key(key.toString()),
                    initiallyExpanded: expansionKey1,
                      onExpansionChanged: ((newState) {
                        setState(() {
                          key = 0;
                        });
                        expansionKey2 = false;
                        expansionKey1 = true;
                        setState(() {
                        });
                      }),
                    title: Row(children: [
                      Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(right: 0, left: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Image.asset(Images.business_profile_icon),
                      ),
                      Text(
                        "Business Profile Details".tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      SvgIcon(
                        getAccountStatus("${cnt.businessInfoModel.value.basicdetailsstatusId.toString() ?? ""}"),
                        height: 20,
                        width: 20,
                      ),
                    ]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                        child: Column(
                          children: [
                            commonTextField(
                              contollerr: businessName,
                              hint: "Business name".tr,
                              isRead: readOnly,
                              regularExpression: r'[A-Za-z ]',
                              validator: (value) {
                                if (value == cnt.businessInfoModel.value.businessname!) {
                                  isbusinessNameChange = false;
                                } else {
                                  isbusinessNameChange = true;
                                }
                                if (value!.isEmpty) {
                                  return "Business name cannot be empty".tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            height20(),
                            commonTextField(
                              contollerr: businessRegistrationNumber,
                              keyType: TextInputType.emailAddress,
                              validationType: TextValidation.digitsValidationPattern,
                              regularExpression: r'[0-9-/]',
                              isRead: readOnly,
                              hint: "Business Registration Number".tr,
                              inputLength: 12,
                              onChange: (str) {
                                if (isSelected == true) {
                                  _formKey.currentState!.validate();
                                }
                              },
                              validator: (value) {
                                if (value == cnt.businessInfoModel.value.merchantregisterationnumber) {
                                  isbusinessRegistrationNumberChange = false;
                                } else {
                                  isbusinessRegistrationNumberChange = true;
                                }
                                if (value!.isEmpty) {
                                  return "Business Registration Number cannot be empty".tr;
                                }
                                if (value.length < 3) {
                                  return "Required minimum 3 characters".tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            height20(),
                            commonTextField(
                              errorText: emailError,
                              isRead: readOnly,
                              onChange: (str) {
                                bool changeEmail = false;
                                if (str == cnt.businessInfoModel.value.user!.email) {
                                  changeEmail = false;
                                } else {
                                  changeEmail = true;
                                }

                                if (changeEmail && str.contains("@")) {
                                  checkEmail();
                                }
                              },
                              contollerr: emailId,
                              hint: "Email ID",
                              validator: (value) {
                                if (value == cnt.businessInfoModel.value.user!.email) {
                                  isemailIdChange = false;
                                } else {
                                  isemailIdChange = true;
                                }
                                if(emailError != null) {
                                  return emailError;
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
                            ),
                            height20(),
                            commonTextField(
                              errorText: mobileError,
                              isRead: readOnly,
                              inputLength: 8,
                              onChange: (str) {
                                bool mobileChange = false;
                                if (str == cnt.businessInfoModel.value.user!.cellnumber) {
                                  mobileChange = false;
                                } else {
                                  mobileChange = true;
                                }
                                print(mobileChange);
                                if (mobileChange && str.length >= 8) {
                                  checkMobileNumber();
                                }
                              },
                              contollerr: mobileNumber,
                              keyType: TextInputType.number,
                              hint: "Mobile Number".tr,

                              validator: (value) {
                                if (value == cnt.businessInfoModel.value.user!.cellnumber) {
                                  ismobileNumberChange = false;
                                } else {
                                  ismobileNumberChange = true;
                                }
                                if(mobileError != null) {
                                  return mobileError;
                                }
                                if (value!.isEmpty) {
                                  return "Mobile Number cannot be empty".tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            height20(),
                            commonTextField(
                              contollerr: zone,
                              isRead: readOnly,
                              // maxLength: 4,
                              validationType: TextValidation.digitsValidationPattern,
                              keyType: TextInputType.number,
                              regularExpression: r'[0-9]',
                              hint: "Zone".tr,
                              inputLength: 3,

                              onChange: (str) {
                                if (isSelected == true) {
                                  _formKey.currentState!.validate();
                                }
                              },
                              validator: (value) {
                                if (value == cnt.businessInfoModel.value.zonenumber) {
                                  iszoneChange = false;
                                } else {
                                  iszoneChange = true;
                                }
                                if (value!.isEmpty) {
                                  return "Zone cannot be empty".tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            height20(),
                            Row(
                              children: [
                                commonTextField(
                                  contollerr: streetNo,
                                  isRead: readOnly,
                                  hint: 'Street no.'.tr,
                                  width: 155,
                                  validationType: TextValidation.digitsValidationPattern,
                                  keyType: TextInputType.number,
                                  regularExpression: r'[0-9]',
                                  inputLength: 3,
                                  onChange: (str) {
                                    if (isSelected == true) {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  validator: (value) {
                                    if (value == cnt.businessInfoModel.value.streetnumber) {
                                      isstreetNoChange = false;
                                    } else {
                                      isstreetNoChange = true;
                                    }
                                    if (value!.isEmpty) {
                                      return "Street cannot be empty".tr;
                                    }
                                    return null;
                                  },
                                ),
                                Spacer(),
                                commonTextField(
                                  contollerr: bldgNo,
                                  hint: 'Bldg.no.'.tr,
                                  isRead: readOnly,
                                  validationType: TextValidation.digitsValidationPattern,
                                  keyType: TextInputType.number,
                                  regularExpression: r'[0-9]',
                                  inputLength: 3,
                                  width: 155,
                                  onChange: (str) {
                                    if (isSelected == true) {
                                      _formKey.currentState!.validate();
                                    }
                                  },
                                  validator: (value) {
                                    if (value == cnt.businessInfoModel.value.buildingnumber) {
                                      isbldgNoChange = false;
                                    } else {
                                      isbldgNoChange = true;
                                    }
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
                              contollerr: unitNo,
                              hint: 'Unit no.'.tr,
                              isRead: readOnly,
                              validationType: TextValidation.digitsValidationPattern,
                              keyType: TextInputType.number,
                              regularExpression: r'[0-9]',
                              inputLength: 3,
                              onChange: (str) {
                                if (isSelected == true) {
                                  _formKey.currentState!.validate();
                                }
                              },
                              validator: (value) {
                                if (value == cnt.businessInfoModel.value.unitnumber) {
                                  isunitNoChange = false;
                                } else {
                                  isunitNoChange = true;
                                }
                                return null;
                              },
                            ),
                            height20(),
                            cnt.businessInfoModel.value.basicdetailsstatusId == 3
                                ? Text(
                                    "Alert : ".tr + cnt.businessInfoModel.value.basicdetailsstatuscommet.toString(),
                                    style: TextStyle(
                                      color: ColorsUtils.red,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                : SizedBox(),
                            hideActionBtn
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              String userBusinessId =
                                                  await encryptedSharedPreferences.getString('userbusinessId');
                                              if (_formKey.currentState!.validate()) {
                                                // if (widget.isFirstTime == true) {
                                                //   await cnt
                                                //       .storeBusiness(
                                                //     context: context,
                                                //     zoneNumber: zone.text,
                                                //     businessReGiSteRationNumber: businessRegistrationNumber.text,
                                                //     buildingNumber: bldgNo.text,
                                                //     streetNumber: streetNo.text,
                                                //     businessName: businessName.text,
                                                //     img: bankA.uploadedUrl.value,
                                                //     businessDoc: {},
                                                //     userId: userBusinessId,
                                                //   )
                                                //       .then((value) {
                                                //     if (value == 1) {
                                                //       Navigator.pop(context);
                                                //       Get.snackbar(
                                                //           'success'.tr,
                                                //           'Merchant details will be verified and it will be activate automatically.'
                                                //               .tr);
                                                //     } else if (value == 2) {
                                                //     } else {}
                                                //   });
                                                // } else {
                                                Map<String, dynamic> Body = {};
                                                if (isbusinessNameChange) {
                                                  Body.addEntries({"businessname": businessName.text}.entries);
                                                }
                                                if (isbusinessRegistrationNumberChange) {
                                                  Body.addEntries(
                                                      {"merchantregisterationnumber": businessRegistrationNumber.text}.entries);
                                                }
                                                if (isbldgNoChange) {
                                                  Body.addEntries({"buildingnumber": bldgNo.text}.entries);
                                                }
                                                if (isstreetNoChange) {
                                                  Body.addEntries({"streetnumber": streetNo.text}.entries);
                                                }
                                                if (iszoneChange) {
                                                  Body.addEntries({"zonenumber": zone.text}.entries);
                                                }
                                                if (isemailIdChange) {
                                                  Body.addEntries({"changedemail": emailId.text}.entries);
                                                }
                                                if (ismobileNumberChange) {
                                                  Body.addEntries({"newCellnumber": mobileNumber.text}.entries);
                                                  Utility.userPhone = mobileNumber.text;
                                                }
                                                if (isunitNoChange) {
                                                  Body.addEntries({"unitnumber": unitNo.text}.entries);
                                                }
                                                if (!Body.isEmpty) {
                                                  if ((ismobileNumberChange || isemailIdChange) &&
                                                      (!iszoneChange &&
                                                          !isstreetNoChange &&
                                                          !isbldgNoChange &&
                                                          !isbusinessRegistrationNumberChange &&
                                                          !isbusinessNameChange)) {
                                                  } else {
                                                    if (cnt.businessInfoModel.value.basicdetailsstatusId == 1) {
                                                      Body.addEntries({"userbusinessstatusId": 6}.entries);
                                                      Body.addEntries({"basicdetailsstatusId": 6}.entries);
                                                    } else {
                                                      Body.addEntries({"userbusinessstatusId": 4}.entries);
                                                      Body.addEntries({"basicdetailsstatusId": 4}.entries);
                                                    }
                                                  }

                                                  // cnt.updateBusinessDetailsNew(
                                                  //   context: context,body: Body
                                                  // );
                                                  if (cnt.businessInfoModel.value.basicdetailsstatusId == 1) {
                                                    showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text('Are you sure?'.tr),
                                                            content: Text(
                                                                'Your account status would be Under Review\nYour operation kept on hold until it gets verified.'
                                                                    .tr),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  child: Text('Yes'.tr),
                                                                  onPressed: () async {
                                                                    Get.close(1);
                                                                    Get.to(
                                                                      () => MoreOtpScreen(
                                                                        businessDataModel: cnt.businessDataModel.value,
                                                                        type: "AllBusinessUpdate",
                                                                        body: Body,
                                                                      ),
                                                                    );
                                                                  }),
                                                              TextButton(
                                                                  child: Text('No'.tr),
                                                                  onPressed: () async {
                                                                    Get.close(1);
                                                                  }),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    Get.to(
                                                      () => MoreOtpScreen(
                                                        businessDataModel: cnt.businessDataModel.value,
                                                        type: "AllBusinessUpdate",
                                                        body: Body,
                                                      ),
                                                    );
                                                  }
                                                }
                                              } else {
                                                Get.snackbar('error'.tr, 'Please provide valid details'.tr);
                                              }
                                            },
                                            child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Confirm'.tr),
                                          ),
                                        ),
                                        width10(),
                                        Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                _formKey.currentState!.validate();
                                                if (ismobileNumberChange ||
                                                    isemailIdChange ||
                                                    iszoneChange ||
                                                    isstreetNoChange ||
                                                    isbldgNoChange ||
                                                    isbusinessRegistrationNumberChange ||
                                                    isbusinessNameChange) {
                                                  showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Are you sure?'.tr),
                                                          content: Text("The changes won't be saved".tr),
                                                          actions: <Widget>[
                                                            TextButton(
                                                                child: Text('Yes'.tr),
                                                                onPressed: () async {
                                                                  Get.close(2);
                                                                }),
                                                            TextButton(
                                                                child: Text('No'.tr),
                                                                onPressed: () async {
                                                                  Get.close(1);
                                                                }),
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  Get.back();
                                                }
                                                setState(() {});
                                              },
                                              child: Container(
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1, color: ColorsUtils.accent),
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 15),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "Cancel".tr,
                                                          style:
                                                              ThemeUtils.maroonSemiBold.copyWith(fontSize: FontUtils.mediumSmall),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                height20(),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: ColorsUtils.lightBg,
                      width: 1.5,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.zero,
                  child: ExpansionTile(key: Key(key.toString()),
                    onExpansionChanged: ((newState) {
                      setState(() {
                        key = 1;
                      });
                      expansionKey1 = false;
                      expansionKey2 = true;
                      setState(() {
                      });
                    }),
                    initiallyExpanded: expansionKey2,
                    title: Row(children: [
                      Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(right: 0, left: 0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Image.asset(Images.business_document_icon),
                      ),
                      Text(
                        "Business Documents".tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      SvgIcon(
                        getAccountStatus("${provideDocumentStatusOverall()}"),
                        height: 20,
                        width: 20,
                      ),
                    ]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    customSmallBoldText(
                                      title: 'Upload Below Documents'.tr,
                                    ),
                                  ],
                                ),
                                width20(),
                                InkWell(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
                                                    commonRowData(title: 'Owner\'s ID card'.tr),
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
                            height20(),
                            ListView.builder(
                                itemCount: businessMediaMultiPageList.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final title = businessMediaMultiPageList[index].title;
                                  final id = '${index + 1}';
                                  String typeId = businessMediaMultiPageList[index].businessmediatypeId.toString();
                                  String nextDocType = "0";
                                  if (index + 1 == businessMediaMultiPageList.length) {
                                    nextDocType = businessMediaMultiPageList[index].businessmediatypeId.toString();
                                  } else {
                                    nextDocType = businessMediaMultiPageList[index + 1].businessmediatypeId.toString();
                                  }
                                  var totalPages = (getBusinessMediaPageList(index: index) - 1) > 0
                                      ? (getBusinessMediaPageList(index: index) - 1).toString()
                                      : "0";
                                  print("----${businessMediaMultiPageList[index].status}");
                                  return documentCommonWidget(
                                    title: title ?? "".toString(),
                                    totalPages: totalPages,
                                    index: index,
                                    nextDocType: nextDocType,
                                    docId: typeId,
                                    docCurrentStatus: businessMediaMultiPageList[index].businessmediastatusId.toString(),
                                    needActionComment: businessMediaMultiPageList[index].comment.toString(),
                                    subtitle: businessMediaMultiPageList[index].name?[0] ?? "".toString(),
                                    id: index,
                                    date: businessDoc.containsKey(id)
                                        ? businessDoc[id]!['date'].toString().isEmpty
                                            ? "Select Date".tr
                                            : dateformatChange(businessDoc[id]!['date'])
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
                                        if (businessDoc.containsKey(id)) {
                                          businessDoc[id]!['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(picked).toString();
                                        } else {
                                          businessDoc.addAll({
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
                                    onTap: () {
                                      List<OwnerIdUploadModel> allOwnerIdCardListForwarded = [];

                                      if (typeId == "4") {
                                        allOwnerIdCardListForwarded = collectSameTypeDoc(typeId);
                                        Get.to(() => OwnerIDUploadNewFlowScreen(
                                              businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                              allOwnerIdCardListForwarded: allOwnerIdCardListForwarded,
                                            ))?.then((value) {
                                          getAllBusinessDetails();
                                        });
                                      }
                                      if (typeId == "1") {
                                        allOwnerIdCardListForwarded = collectSameTypeDoc(typeId);

                                        Get.to(() => CRUploadNewFlowScreen(
                                          businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                          allOwnerIdCardListForwarded: allOwnerIdCardListForwarded,
                                        ))?.then((value) {
                                          getAllBusinessDetails();
                                        });
                                      }
                                      if (typeId == "2") {
                                        allOwnerIdCardListForwarded = collectSameTypeDoc(typeId);
                                        Get.to(() => CLUploadNewFlowScreen(
                                          businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                          allOwnerIdCardListForwarded: allOwnerIdCardListForwarded,
                                        ))?.then((value) {
                                          getAllBusinessDetails();
                                        });
                                      }

                                      if (typeId == "3") {
                                        allOwnerIdCardListForwarded = collectSameTypeDoc(typeId);
                                        Get.to(() => EstablishmentCardUploadNewFlowScreen(
                                          businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                          allOwnerIdCardListForwarded: allOwnerIdCardListForwarded,
                                        ))?.then((value) {
                                          getAllBusinessDetails();
                                        });
                                      }
                                      if (typeId == "6") {
                                        allOwnerIdCardListForwarded = collectSameTypeDoc(typeId);
                                        Get.to(() => OtherDocumentUploadNewFlowScreen(
                                          businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                          allOwnerIdCardListForwarded: allOwnerIdCardListForwarded,
                                        ))?.then((value) {
                                          getAllBusinessDetails();
                                        });
                                      }

                                      // if (typeId == "4") {
                                      //   for (int i = 0; i < businessMediaListToForward.length; i++) {
                                      //     if (businessMediaListToForward[i].businessmediatypeId == 4) {
                                      //       List<int>? id = businessMediaListToForward[i].id;
                                      //       List<String>? image = [];
                                      //       List<String>? onlineImage = businessMediaListToForward[i].name;
                                      //       List<String>? metaData = businessMediaListToForward[i].metadata;
                                      //       String? mediaStatus = businessMediaListToForward[i].businessmediastatusId.toString();
                                      //       List<String>? localDocStatus = businessMediaListToForward[i].docStatus;
                                      //       String? uniqueId = businessMediaListToForward[i].unique_id;
                                      //       String? currentDocType =
                                      //       businessMediaListToForward[i].name![0]
                                      //           .split('/')
                                      //           .last
                                      //           .contains('pdf')
                                      //           ? "PDF"
                                      //           : "Image";
                                      //       bool? isDocVerified = businessMediaListToForward[i].businessmediastatusId == 3 ? false : true;
                                      //       String? errorMessage = businessMediaListToForward[i].comment;
                                      //       bool? docUploadedSucess = false;
                                      //       List<String>? ownerIdList = [];
                                      //       List<String>? expiryDateList = [];
                                      //
                                      //       allOwnerIdCardListForwarded.add(OwnerIdUploadModel(
                                      //           currentDocType: currentDocType,
                                      //           localDocStatus: localDocStatus,
                                      //           mediaStatus: mediaStatus,
                                      //           metaData: metaData,
                                      //           onlineImage: onlineImage,
                                      //           uniqueId: uniqueId,
                                      //           errorMessage: errorMessage,
                                      //           image: image,
                                      //           isDocVerified: isDocVerified,id: id));
                                      //     }
                                      //   }
                                      // } else {
                                      //   Get.to(
                                      //     () => CommercialRegistrationScreen(
                                      //       // docData: docData,
                                      //       // docData: docData,
                                      //       imgId: businessMediaMultiPageList[index].id,
                                      //       businessMediaMultiPageList: businessMediaMultiPageList,
                                      //       url: businessMediaMultiPageList[index].name,
                                      //       status: businessMediaMultiPageList[index].docStatus,
                                      //       metadata: businessMediaMultiPageList[index].metadata,
                                      //       title: typeId == '1'
                                      //           ? 'Commercial registration'.tr
                                      //           : typeId == '2'
                                      //               ? 'Commercial license'.tr
                                      //               : typeId == '3'
                                      //                   ? 'Establishment card'.tr
                                      //                   : typeId == '4'
                                      //                       ? 'Owner’s ID card'.tr
                                      //                       : "Other" ?? "",
                                      //       subtitle: typeId == '1'
                                      //           ? "Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce"
                                      //               .tr
                                      //           : typeId == '2'
                                      //               ? "Upload your valid Commercial License copy as issued by the Ministry of Municipality"
                                      //                   .tr
                                      //               : typeId == '3'
                                      //                   ? "Upload your valid Company Establishment card".tr
                                      //                   : typeId == '4'
                                      //                       ? "Upload your authorized person or owner's valid Residency ID card"
                                      //                           .tr
                                      //                       : "Upload other type of document here" ?? "",
                                      //       id: typeId,
                                      //       uniqueID: businessMediaMultiPageList[index].unique_id ?? null,
                                      //       docStatus: businessMediaMultiPageList[index].businessmediastatusId.toString() ?? '',
                                      //       businessStatus: cnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? '',
                                      //       isFirstTime: true,
                                      //       // docData: docData,
                                      //     ),
                                      //   );
                                      // }
                                    },
                                  );
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
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

  int? getBusinessMediaPageListNotDeleted({required int index}) {
    for (int i = 0; i < businessMediaMultiPageList[index].docStatus!.length; i++) {
      if (businessMediaMultiPageList[index].docStatus![i] != "delete") {
        return i;
      }
    }
    return null;
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
    required String docCurrentStatus,
    required String needActionComment,
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
                      Row(
                        children: [
                          Text(title, style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small)),
                          width3(),
                          Text(
                              provideTotalTypeOfDocumentCount(docId) > 0
                                  ? "(${provideTotalTypeOfDocumentCount(docId)})"
                                  : "",
                              style: ThemeUtils.maroonSemiBold.copyWith(fontSize: FontUtils.mediumSmall)),
                          width8(),
                          SvgIcon(
                            getAccountStatus("${provideDocumentStatus(docId)}"),
                            height: 15,
                            width: 15,
                          ),
                          width3(),
                          getAccountStatusName("${provideDocumentStatus(docId)}" ?? ""),
                        ],
                      ),
                      height8(),
                      Text("$subtitle", style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small)),
                    ],
                  ),
                ),
                width20(),
                Column(
                  children: [
                    InkWell(
                      onTap: onTap,
                      child: Icon(
                        provideDocumentStatus(docId) == 4 ?Icons.remove_red_eye : Icons.file_upload_outlined,
                        color: ColorsUtils.accent,
                      ),
                    ),
                  ],
                ),
                width20(),
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

  String returnDocId(String docId, String name) {
    String temp = docId;
    bool isFounded = false;
    if (int.parse(docId) == 4) {
      businessDoc.keys.forEach((element) {
        print(businessDoc[element]!["url"][0]);
        if (name == businessDoc[element]!["url"][0].toString()) {
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

  String dateformatLocal(String? date) {
    if (date == null || date == '') {
      return '';
    } else {
      DateTime datetime = DateTime.parse(date);
      DateFormat tempDate = DateFormat("dd/MM/yyyy HH:mm:ss");
      String newdate = tempDate.format(datetime);
      return newdate;
    }
  }

  Future getImageFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf']);

    if (result != null) {
      File? file = File(result.files.single.path!);
      log('DOC=>${file}');
      cnt.imageName = file.path.split("/").last;
      String str = file.path;
      print(str);
      String extension = str.substring(str.lastIndexOf('.') + 1);
      log('extension:::$extension');
      if (extension == 'jpeg' ||
          extension == 'png' ||
          extension == 'jpg' ||
          extension == 'JPEG' ||
          extension == 'PNG' ||
          extension == 'JPG' ||
          extension == 'pdf') {
        cnt.image = file;
        await bankA.uploadBusinessImage(file: cnt.image!, context: context);

        if (businessDoc.containsKey(currentMediaTypeID)) {
          businessDoc[currentMediaTypeID]!["name"] = bankA.uploadedUrl.value;
          businessDoc[currentMediaTypeID]!["image"] = file;
        } else {
          businessDoc.addAll({
            '${currentMediaTypeID}': {
              'name': bankA.uploadedUrl.value,
              'businessmediatypeId': currentMediaTypeID,
              'doc_expiry': '',
              'image': file
            }
          });
        }
        // businessDoc.addAll({
        //     'name': ,
        //     'businessmediatypeId': currentMediaTypeID,
        // });
        // log('image is $cnt.image');
        setState(() {});
      }
    } else {
      // User canceled the picker
    }
  }

  List<OwnerIdUploadModel> collectSameTypeDoc(String typeId) {
    if(typeId == "6") {
      typeId = "";
    }
    List<OwnerIdUploadModel> allOwnerIdCardListForwarded = [];
    for (int i = 0; i < businessMediaListToForward.length; i++) {
      if (businessMediaListToForward[i].businessmediatypeId.toString() == typeId) {
        List<int>? id = businessMediaListToForward[i].id;
        List<String>? image = [];
        List<String>? onlineImage = businessMediaListToForward[i].name;
        List<String>? metaData = businessMediaListToForward[i].metadata;
        String? mediaStatus = businessMediaListToForward[i].businessmediastatusId.toString();
        List<String>? localDocStatus = businessMediaListToForward[i].docStatus;
        String? uniqueId = businessMediaListToForward[i].unique_id;
        String? currentDocType = businessMediaListToForward[i].name![0].split('/').last.contains('pdf') ? "PDF" : "Image";
        bool? isDocVerified = businessMediaListToForward[i].businessmediastatusId == 3 ? false : true;
        String? errorMessage = businessMediaListToForward[i].comment;
        bool? docUploadedSucess = false;
        List<String>? ownerIdList = [];
        List<String>? expiryDateList = [];

        allOwnerIdCardListForwarded.add(OwnerIdUploadModel(
            currentDocType: currentDocType,
            localDocStatus: localDocStatus,
            mediaStatus: mediaStatus,
            metaData: metaData,
            onlineImage: onlineImage,
            uniqueId: uniqueId,
            errorMessage: errorMessage,
            image: image,
            isDocVerified: isDocVerified,
            id: id));
      }
    }
    return allOwnerIdCardListForwarded;
  }

  int provideTotalTypeOfDocumentCount(String typeId) {
    if(typeId == "6") {
      typeId = "";
    }
    int counter = 0;
    for (int i = 0; i < businessMediaListToForward.length; i++) {
      if (businessMediaListToForward[i].businessmediatypeId.toString() == typeId) {
        counter++;
      }
    }
    return counter;
  }

  int provideDocumentStatus(String typeId) {
    if(typeId == "6") {
      typeId = "";
    }
    for (int i = 0; i < businessMediaListToForward.length; i++) {
      if (businessMediaListToForward[i].businessmediatypeId.toString() == typeId) {
        if (businessMediaListToForward[i].businessmediastatusId.toString() == "3") {
          return 3;
        }
      }
    }
    for (int i = 0; i < businessMediaListToForward.length; i++) {
      if (businessMediaListToForward[i].businessmediatypeId.toString() == typeId) {
        if (businessMediaListToForward[i].businessmediastatusId.toString() == "4" ||
            businessMediaListToForward[i].businessmediastatusId.toString() == "6") {
          return 4;
        }
      }
    }
    for (int i = 0; i < businessMediaListToForward.length; i++) {
      if (businessMediaListToForward[i].businessmediatypeId.toString() == typeId) {
        if (businessMediaListToForward[i].businessmediastatusId.toString() == "1") {
          return 1;
        }
      }
    }
    return 0;
  }
  int provideDocumentStatusOverall() {
    for (int i = 0; i < businessMediaListToForward.length; i++) {
      if (businessMediaListToForward[i].businessmediastatusId.toString() == "3") {
        return 3;
      }
    }
    for (int i = 0; i < businessMediaListToForward.length; i++) {
      if (businessMediaListToForward[i].businessmediastatusId.toString() == "4" ||
          businessMediaListToForward[i].businessmediastatusId.toString() == "6") {
        return 4;
      }
    }
    for (int i = 0; i < businessMediaListToForward.length; i++) {
      if (businessMediaListToForward[i].businessmediastatusId.toString() == "1") {
        return 1;
      }
    }
    return 0;
  }

  Dio dioForMobile = Dio();
  String? mobileError;

  Future<void> checkMobileNumber() async {
    dioForMobile.close();
    dioForMobile = Dio();
    String token = await encryptedSharedPreferences.getString('token');
    final url = 'users/count?where[cellnumber]=${mobileNumber.text}&amp;where[agreement]=true';

    var response = await dioForMobile.get(baseURL + url,
        options: Options(
          headers: {"Authorization": token, 'Content-Type': 'application/json'},
        ));
    if (response.data['count'] != 0) {
      setState(() {
        mobileError = "Mobile number already exist".tr;
      });
    } else {
      setState(() {
        mobileError = null;
      });
    }
    log("response mobile::${response.data}");
  }

  Dio dioForEmail = Dio();
  String? emailError;

  Future<void> checkEmail() async {
    dioForEmail.close();
    dioForEmail = Dio();
    String token = await encryptedSharedPreferences.getString('token');
    final url = 'users/count?where[email]=${emailId.text}&amp;where[agreement]=true';

    var response = await dioForEmail.get(baseURL + url,
        options: Options(
          headers: {"Authorization": token, 'Content-Type': 'application/json'},
        ));
    if (response.data['count'] != 0) {
      setState(() {
        emailError = "Email address already exist".tr;
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
    log("response of mail::${response.data}");
  }
}
