import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/IdentityDocumentProofingModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/documentRegisterScreen/AppDialog.dart';
import 'package:sadad_merchat_app/view/more/docUpdateOtpScreen.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';

import '../../../../main.dart';
import '../../../../staticData/loading_dialog.dart';
import '../../../../staticData/utility.dart';
import '../../../../viewModel/more/businessInfo/businessInfoViewModel.dart';

class CommercialRegistrationScreen extends StatefulWidget {
  String? title;
  String? subtitle;
  List<int>? imgId;
  List<String>? url;
  List<String>? status;
  List<String>? metadata;
  String? id;
  bool? isFirstTime;
  String? uniqueID;
  String? docStatus;
  String? businessStatus;
  RxList<BusinessmediaMultiPage>? businessMediaMultiPageList;

  Map<String, Map<String, dynamic>>? mainDocData;

  // Map<String, Map<String, dynamic>>? docData;

  CommercialRegistrationScreen(
      {Key? key,
      this.title,
      this.subtitle,
      this.url,
      this.status,
      this.metadata,
      this.id,
      this.imgId,
      this.isFirstTime,
      this.uniqueID,
      this.mainDocData,
      this.docStatus,
      this.businessStatus,
      required this.businessMediaMultiPageList})
      : super(key: key);

  @override
  State<CommercialRegistrationScreen> createState() => _CommercialRegistrationScreenState();
}

class _CommercialRegistrationScreenState extends State<CommercialRegistrationScreen> {
  final cnt = Get.find<BusinessInfoViewModel>();
  final bankA = Get.find<BankAccountViewModel>();
  final _formKey = GlobalKey<FormState>();
  RxList<Businessmedia> businessMediaList = <Businessmedia>[].obs;
  Map<String, Map<String, dynamic>> docData = {};

  List<String> docOcrDataList = [];
  String docOcrAllDataString = '';
  List<String> docImageUrlList = [];
  List<String> docStatusManager = [];
  List<int> docImageId = [];
  List<File> docSelectedfile = [];
  String visionAPIRejectedFileName = '';
  String? tokenMain;
  String? curruntDocType = '';
  bool addButtonDisable = true;
  String? currentErrorMsg = '';
  List<String>? expiryDateList = [];
  List<String>? ownerIdList = [];
  int multipleDocWithSameType = 0;

  List<String> docOcrDataListCopy = [];
  List<int> docImageIdCopy = [];
  List<String> docImageUrlListCopy = [];
  List<String> docStatusManagerCopy = [];

  @override
  void initState() {
    // TODO: implement initState
    print("==-=>${widget.title}");
    cnt.dateCnt.clear();
    cnt.image = null;
    gettingToken();
    super.initState();
  }

  setupEditDocData() {
    if (widget.isFirstTime != true && widget.url != null) {
      docOcrDataListCopy = widget.metadata!;
      docImageIdCopy = widget.imgId!;
      docImageUrlListCopy = widget.url!;
      docStatusManagerCopy = widget.status!;

      // docOcrDataList = widget.metadata!;
      // docImageId = widget.imgId!;
      // docImageUrlList = widget.url!;
      // docStatusManager = widget.status!;
      for (int i = 0; i < widget.imgId!.length; i++) {
        docStatusManager.add(widget.status![i]);
        docImageUrlList.add(widget.url![i]);
        docImageId.add(widget.imgId![i]);
        docOcrDataList.add(widget.metadata![i]);
        String extension = widget.url![i].substring(widget.url![i].lastIndexOf('.') + 1);
        if (extension == 'pdf') {
          curruntDocType = "PDF";
        } else {
          curruntDocType = "Image";
        }
      }
      ;
      setState(() {});
    }
    if (widget.isFirstTime == true) {
      docOcrDataListCopy = widget.metadata!;
      docImageIdCopy = widget.imgId!;
      docImageUrlListCopy = widget.url!;
      docStatusManagerCopy = widget.status!;

      // docOcrDataList = widget.metadata!;
      // docImageId = widget.imgId!;
      // docImageUrlList = widget.url!;
      // docStatusManager = widget.status!;
      for (int i = 0; i < widget.imgId!.length; i++) {
        if (widget.metadata![i] != "") {
          docStatusManager.add(widget.status![i]);
          docImageUrlList.add(widget.url![i]);
          docImageId.add(widget.imgId![i]);
          docOcrDataList.add(widget.metadata![i]);
          String extension = widget.url![i].substring(widget.url![i].lastIndexOf('.') + 1);
          if (extension == 'pdf') {
            curruntDocType = "PDF";
          } else {
            curruntDocType = "Image";
          }
        }
      }
      ;
      setState(() {});
    }
    currentErrorMsg = widget.isFirstTime == true ? '' : "You can edit this document's pages or can upload a new document.";
  }

  gettingToken() async {
    tokenMain = await encryptedSharedPreferences.getString('token');
    setupEditDocData();
    setState(() {});
    print(tokenMain);
  }

  List assetList = [
    "assets/images/bank.png",
    "assets/images/bank.png",
    "assets/images/bank.png",
    "assets/images/bank.png",
    "assets/images/bank.png"
  ];

  Future getImageFile() async {
    String title = widget.id!;
    int oversizeFileCounter = 0;
    if (curruntDocType == 'PDF') {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: true);
      if (result != null) {
        addButtonDisable = false;
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
            cnt.imageName = file.path.split("/").last;
            String str = file.path;
            String extension = str.substring(str.lastIndexOf('.') + 1);
            print('extension:::$extension');
            if (extension == 'pdf') {
              cnt.image = file;
              docSelectedfile.add(file);
            }
            // else {
            //   Get.snackbar(
            //       ''.tr,
            //       'Please select pdf file type'
            //           .tr);
            // }
          }
          if ((widget.isFirstTime == true ? !docUploadLimitReachedForFirstTimeUpload() : !docUploadLimitReached())) {
            addButtonDisable = true;
            currentErrorMsg =
                "Maximum number of page limits has been reached. You're allowed to upload only ${allowNumberOfDocument().toString()} pages for this document category.";
            //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
          }
          setState(() {});
        });
        if ((widget.isFirstTime == true ? !docUploadLimitReachedForFirstTimeUpload() : !docUploadLimitReached())) {
          addButtonDisable = true;
          currentErrorMsg =
              "Maximum number of page limits has been reached. You're allowed to upload only ${allowNumberOfDocument().toString()} pages for this document category.";
          setState(() {});
          //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
        }
      } else {
        // User canceled the picker
      }
    } else {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png'], allowMultiple: true);

      if (result != null) {
        addButtonDisable = false;
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
            cnt.imageName = file.path.split("/").last;
            String str = file.path;
            String extension = str.substring(str.lastIndexOf('.') + 1);
            print('extension:::$extension');
            if (extension == 'jpeg' ||
                extension == 'png' ||
                extension == 'jpg' ||
                extension == 'JPEG' ||
                extension == 'PNG' ||
                extension == 'JPG') {
              cnt.image = file;
              docSelectedfile.add(file);
            }
          }
          if ((widget.isFirstTime == true ? !docUploadLimitReachedForFirstTimeUpload() : !docUploadLimitReached())) {
            addButtonDisable = true;
            currentErrorMsg =
                "Maximum number of page limits has been reached. You're allowed to upload only ${allowNumberOfDocument().toString()} pages for this document category.";
            //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
          }
          setState(() {});
        });
        if ((widget.isFirstTime == true ? !docUploadLimitReachedForFirstTimeUpload() : !docUploadLimitReached())) {
          addButtonDisable = true;
          currentErrorMsg =
              "Maximum number of page limits has been reached. You're allowed to upload only ${allowNumberOfDocument().toString()} pages for this document category.";
          setState(() {});
          //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
        }
      } else {
        // User canceled the picker
      }
    }
    if (oversizeFileCounter > 0) {
      Get.snackbar('Oversize file'.tr, "There is ${oversizeFileCounter} file is founded more than 20 mb size.".tr);
    }
    setState(() {});
  }

  uploadAndVerifyAllDoc() {
    addButtonDisable = false;
    int counter = 0;

    if ((widget.isFirstTime == true ? !docUploadLimitReachedForFirstTimeUpload() : !docUploadLimitReached())) {
      addButtonDisable = true;
      currentErrorMsg =
          "Maximum number of page limits has been reached. You're allowed to upload only ${allowNumberOfDocument().toString()} pages for this document category.";
      //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
    } else {
      expiryDateList?.clear();
      ownerIdList?.clear();
      visionAPIRejectedFileName = '';
      if (docSelectedfile.length == 0) {
        docOcrAllDataString = '';
        multipleDocWithSameType = 0;
        for (int i = 0; i < docOcrDataList.length; i++) {
          if (docStatusManager[i] != 'delete') {
            var ocrMap = docOcrDataList[i] == "" ? null : jsonDecode(docOcrDataList[i]);
            if (ocrMap != null) {
              fetchOwnerIdNo((ocrMap['main_data'] is List) ? null : ocrMap['main_data']);
              fetchExpiryDate((ocrMap['main_data'] is List) ? null : ocrMap['main_data']);
              checkForMultipleDocWithSameType(ocrMap != null ? ocrMap['scanned_text'].toString() : '');
              docOcrAllDataString = docOcrAllDataString + (ocrMap != null ? ocrMap['scanned_text'].toString() : '');
            }
          }
        }
        for (int i = 0; i < docStatusManager.length; i++) {
          if (docStatusManager[i] == 'new') {
            docStatusManager[i] = 'added';
          }
        }
        bool verified = checkKeyinResponse(response: docOcrAllDataString);
        var otherDocNameInList = checkOtherDocKeyinResponse(response: docOcrAllDataString);
        if (otherDocNameInList != null && otherDocNameInList.length > 0 && verified) {
          addButtonDisable = true;
          currentErrorMsg =
              "You have uploaded ${otherDocNameInList.toString()} document with valid type document. Please remove it.";
        } else if (otherDocNameInList != null && otherDocNameInList.length > 0) {
          addButtonDisable = true;
          currentErrorMsg =
              "You have uploaded ${otherDocNameInList.toString()} document in ${widget.title.toString()} document category. Kindly remove this document from ${widget.title.toString()} category.";
        } else if (!verified) {
          addButtonDisable = true;
          currentErrorMsg = "Sorry! You didn't upload a valid ${widget.title} document.Kindly reupload the document.";
          //Get.snackbar('Image Quality'.tr, "Sorry! You didn't upload a valid ${widget.title} document.Kindly reupload the document.".tr);
        } else if (visionAPIRejectedFileName != '') {
          addButtonDisable = true;
          currentErrorMsg =
              "An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.";
          //Get.snackbar('Image Quality'.tr, 'An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.'.tr);
        } else if (compareDateExpiry(expiryDateList!) == false) {
          addButtonDisable = true;
          currentErrorMsg = "You have uploaded the expired document. Please reupload the valid document";
        } else if (multipleOwnerID(ownerIdList!) == false) {
          addButtonDisable = true;
          currentErrorMsg = "You have uploaded two different Owner's Id. Please upload single Owner's Id at once";
        } else if (multipleDocWithSameType > 1) {
          addButtonDisable = true;
          currentErrorMsg = "You have uploaded multiple ${widget.title} document. Kindly upload only one document here.";
        } else if (uploadedOwnerId()) {
          addButtonDisable = true;
          currentErrorMsg = "You have already uploaded this document so can not upload same document twice.";
        } else {
          List<String> docImageUrlListTemp = [];
          List<String> docStatusManagerTemp = [];
          List<int> docImageIdTemp = [];
          List<String> docOcrDataListTemp = [];

          for (int i = 0; i < docStatusManager.length; i++) {
            if (docStatusManager[i] != 'old') {
              docStatusManagerTemp.add(docStatusManager[i]);
              docImageUrlListTemp.add(docImageUrlList[i]);
              docOcrDataListTemp.add(docOcrDataList[i]);
              docImageIdTemp.add(docImageId[i]);
            }
          }
          if (docImageUrlList.length > 0) {
            String docStatusTemp = '';
            if (widget.businessStatus == '1') {
              if (widget.isFirstTime == true) {
                docStatusTemp = '4';
              } else {
                docStatusTemp = '6';
              }
            }
            if (widget.businessStatus == '3') {
              bool isAddEditAvailable = false;
              bool isDeleteAvailable = false;
              for (int i = 0; i < docStatusManagerTemp.length; i++) {
                if (docStatusManagerTemp[i] != 'delete') {
                  isAddEditAvailable = true;
                }
                if (docStatusManagerTemp[i] == 'delete') {
                  isDeleteAvailable = true;
                }
              }
              if (widget.isFirstTime == true) {
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
            String widgetIdTemp = widget.id.toString();
            if (widget.id == "") {
              widgetIdTemp = "6";
            }
            docData.addAll({
              widget.id!: {
                "id": docImageIdTemp,
                'date': cnt.selectedDate,
                'file': '',
                'status': docStatusManagerTemp,
                'mediaStatus': docStatusTemp,
                'url': docImageUrlListTemp,
                'doc_expiry': cnt.selectedDate,
                'metadata': docOcrDataListTemp,
                'unique_id': (widget.isFirstTime == true || widget.uniqueID == null)
                    ? DateTime.now().microsecondsSinceEpoch.toString()
                    : widget.uniqueID,
              }
            });
          }

          // for (int i = 0; i < docStatusManager.length; i++) {
          //   if (docStatusManager[i] == 'delete') {
          //     docStatusManager.removeAt(i);
          //     docImageUrlList.removeAt(i);
          //     docOcrDataList.removeAt(i);
          //     docImageId.removeAt(i);
          //   }
          // }
          print('doc------${docData}');
          Get.back(result: docData);
        }
        // if (visionAPIRejectedFileName == '') {
        //   bool verified = checkKeyinResponse(response: docOcrAllDataString);
        //   var otherDocNameInList = checkOtherDocKeyinResponse(response: docOcrAllDataString);
        //   if (otherDocNameInList != null && otherDocNameInList.length > 0 && verified) {
        //     addButtonDisable = true;
        //     currentErrorMsg =
        //     "You have uploaded ${otherDocNameInList.toString()} document with valid type document. Please remove it.";
        //   } else if (otherDocNameInList != null && otherDocNameInList.length > 0 && verified) {
        //     addButtonDisable = true;
        //     currentErrorMsg =
        //     "You have uploaded ${otherDocNameInList.toString()} document instead of ${widget.title.toString()} document. Please remove it.";
        //   } else if (!verified) {
        //     addButtonDisable = true;
        //     currentErrorMsg = "Sorry! You didn't upload a valid ${widget.title} document.Kindly reupload the document.";
        //     //Get.snackbar('Image Quality'.tr, "Sorry! You didn't upload a valid ${widget.title} document.Kindly reupload the document.".tr);
        //   } else if (visionAPIRejectedFileName != '') {
        //     addButtonDisable = true;
        //     currentErrorMsg =
        //     "An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.";
        //     //Get.snackbar('Image Quality'.tr, 'An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.'.tr);
        //   } else if (compareDateExpiry(expiryDateList!) == false) {
        //     addButtonDisable = true;
        //     currentErrorMsg = "You have uploaded the expired document. Please reupload the valid document";
        //   } else if (multipleOwnerID(ownerIdList!) == false) {
        //     addButtonDisable = true;
        //     currentErrorMsg = "You have uploaded two different Owner's Id. Please upload single Owner's Id";
        //   } else {
        //     List<String> docImageUrlListTemp = [];
        //     List<String> docStatusManagerTemp = [];
        //     List<int> docImageIdTemp = [];
        //     List<String> docOcrDataListTemp = [];
        //     for (int i = 0; i < docStatusManager.length; i++) {
        //       if (docStatusManager[i] != 'old') {
        //         docStatusManagerTemp.add(docStatusManager[i]);
        //         docImageUrlListTemp.add(docImageUrlList[i]);
        //         docOcrDataListTemp.add(docOcrDataList[i]);
        //         docImageIdTemp.add(docImageId[i]);
        //       }
        //     }
        //     if (docImageUrlList.length > 0) {
        //       docData.addAll({
        //         widget.id!: {
        //           "id": docImageIdTemp,
        //           'date': cnt.selectedDate,
        //           'file': '',
        //           'status': docStatusManagerTemp,
        //           'url': docImageUrlListTemp,
        //           'doc_expiry': cnt.selectedDate,
        //           'metadata': docOcrDataListTemp,
        //           'unique_id': (widget.isFirstTime == true || widget.uniqueID == null)
        //               ? DateTime.now().microsecondsSinceEpoch.toString()
        //               : widget.uniqueID,
        //         }
        //       });
        //     }
        //     for (int i = 0; i < docStatusManager.length; i++) {
        //       if (docStatusManager[i] == 'new') {
        //         docStatusManager[i] = 'added';
        //       }
        //     }
        //     // for (int i = 0; i < docStatusManager.length; i++) {
        //     //   if (docStatusManager[i] == 'delete') {
        //     //     docStatusManager.removeAt(i);
        //     //     docImageUrlList.removeAt(i);
        //     //     docOcrDataList.removeAt(i);
        //     //     docImageId.removeAt(i);
        //     //   }
        //     // }
        //     print('doc------${docData}');
        //     Get.back(result: docData);
        //   }
        // } else {
        //   addButtonDisable = true;
        //   currentErrorMsg =
        //       "An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.";
        // }
        setState(() {});
      } else {
        double time = (1.0 - (docSelectedfile.length / 10.0)) / 20;
        AppDialog.showGifLoader(context: context, time: time);
        // showLoadingDialog(context: context);
        docSelectedfile.forEach((element) async {
          await verifyBusinessDoc(element);
        });
      }
    }
  }

  verifyBusinessDoc(File imageFile) async {
    // List fileLIst = imageFile.path.split("/").last.split(".");
    //
    // String fileName = fileLIst[0];
    // if (fileLIst.length > 2) {
    //   for (int i = 1; i < fileLIst.length - 1; i++) {
    //     fileName = fileName + "_${fileLIst[i]}";
    //   }
    // }
    // Random random = Random();
    // var randumNumber = random.nextInt(50);
    // fileName = fileName + "${randumNumber}.${fileLIst.last.toString().toLowerCase()}";
    // Directory cachePath = await getTemporaryDirectory();
    // File newImage = await File(imageFile.path).rename("${cachePath.path}/$fileName");
    // imageFile = newImage;

    if (widget.id == "4") {
      String fileLIst = imageFile.path.split("/").last;
      Map? visionDocData = await bankA.verifyBusinessImage(file: imageFile, context: context, typeId: widget.id.toString());
      if (visionDocData?['calculatedCondidence'] == null) {
        visionAPIRejectedFileName = "";
        addButtonDisable = true;
        currentErrorMsg =
            "An Error occurred while uploading a lower quality version of this file: [${fileLIst}] Please upload a high quality version of the file.";
        for (int i = 0; i < docStatusManager.length; i++) {
          if (docStatusManager[i] == 'new') {
            docImageUrlList.removeAt(i);
            docStatusManager.removeAt(i);
            docOcrDataList.removeAt(i);
            docImageId.removeAt(i);
          }
        }
        hideLoadingDialog(context: context);
        setState(() {});
        return;
      } else {
        if (visionDocData?['detectionConfidence'] < 0.85) {
          visionAPIRejectedFileName = "";
          addButtonDisable = true;
          currentErrorMsg =
              "An Error occurred while uploading a lower quality version of this file: [${fileLIst}] Please upload a high quality version of the file.";
          for (int i = 0; i < docStatusManager.length; i++) {
            if (docStatusManager[i] == 'new') {
              docImageUrlList.removeAt(i);
              docStatusManager.removeAt(i);
              docOcrDataList.removeAt(i);
              docImageId.removeAt(i);
            }
          }
          hideLoadingDialog(context: context);
          setState(() {});
          return;
        }
      }
      Map? docOcrData = await bankA.fetchDocOcrData(file: imageFile, context: context, typeId: widget.id.toString());
      await bankA.uploadBusinessImage(file: imageFile, context: context);

      //Map? temp = await bankA.identityDocumentProofing(file: imageFile, context: context, typeId: widget.id.toString());
      //fetchExpiryDate(docOcrData?['main_data']);
      //fetchOwnerIdNo(docOcrData?['main_data']);
      //Map? visionDocData = docOcrData?['confidence_data'];

      //docOcrData?['identity_data'] = temp;
      docImageUrlList.add(bankA.uploadedUrl.value);
      docStatusManager.add('new');
      docOcrDataList.add(jsonEncode(docOcrData));
      //docOcrAllDataString = docOcrAllDataString + (docOcrData != null ? docOcrData['scanned_text'].toString() : '');
      docImageId.add(0);
      //hideLoadingDialog(context: context);
      //setState(() {});
    } else {
      Map? docOcrData = await bankA.fetchDocOcrData(file: imageFile, context: context, typeId: widget.id.toString());
      await bankA.uploadBusinessImage(file: imageFile, context: context);
      //Map? temp = await bankA.identityDocumentProofing(file: imageFile, context: context, typeId: widget.id.toString());
      //docOcrData?['identity_data'] = temp;
      //fetchExpiryDate(docOcrData?['main_data']);
      docImageUrlList.add(bankA.uploadedUrl.value);
      docStatusManager.add('new');
      docOcrDataList.add(jsonEncode(docOcrData));
      //docOcrAllDataString = docOcrAllDataString + (docOcrData != null ? docOcrData['scanned_text'].toString() : '');
      docImageId.add(0);
      //hideLoadingDialog(context: context);
    }
    int newDocCounter = countTotalNewDoc();
    if (docSelectedfile.length == newDocCounter) {
      hideLoadingDialog(context: context);
      docSelectedfile.clear();
      docOcrAllDataString = '';
      multipleDocWithSameType = 0;
      for (int i = 0; i < docOcrDataList.length; i++) {
        if (docStatusManager[i] != 'delete') {
          var ocrMap = docOcrDataList[i] == "" ? null : jsonDecode(docOcrDataList[i]);
          if (ocrMap != null) {
            print("ocrmap type  ${ocrMap['main_data'] is List}");
            fetchOwnerIdNo((ocrMap['main_data'] is List) ? null : ocrMap['main_data']);
            fetchExpiryDate((ocrMap['main_data'] is List) ? null : ocrMap['main_data']);
            checkForMultipleDocWithSameType(ocrMap != null ? ocrMap['scanned_text'].toString() : '');
            docOcrAllDataString = docOcrAllDataString + (ocrMap != null ? ocrMap['scanned_text'].toString() : '');
          }
        }
      }
      for (int i = 0; i < docStatusManager.length; i++) {
        if (docStatusManager[i] == 'new') {
          docStatusManager[i] = 'added';
        }
      }
      bool verified = checkKeyinResponse(response: docOcrAllDataString);
      var otherDocNameInList = checkOtherDocKeyinResponse(response: docOcrAllDataString);
      if (otherDocNameInList != null && otherDocNameInList.length > 0 && verified) {
        addButtonDisable = true;
        currentErrorMsg =
            "You have uploaded ${otherDocNameInList.toString()} document with valid type document. Please remove it.";
      } else if (otherDocNameInList != null && otherDocNameInList.length > 0) {
        addButtonDisable = true;
        currentErrorMsg =
            "You have uploaded ${otherDocNameInList.toString()} document in ${widget.title.toString()} document category. Kindly remove this document from ${widget.title.toString()} category.";
      } else if (!verified) {
        addButtonDisable = true;
        currentErrorMsg = "Sorry! You didn't upload a valid ${widget.title} document.Kindly reupload the document.";
        //Get.snackbar('Image Quality'.tr, "Sorry! You didn't upload a valid ${widget.title} document.Kindly reupload the document.".tr);
      } else if (visionAPIRejectedFileName != '') {
        addButtonDisable = true;
        currentErrorMsg =
            "An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.";
        //Get.snackbar('Image Quality'.tr, 'An Error occurred while uploading a lower quality version of this file: [${visionAPIRejectedFileName}] Please upload a high quality version of the file.'.tr);
      } else if (compareDateExpiry(expiryDateList!) == false) {
        addButtonDisable = true;
        currentErrorMsg = "You have uploaded the expired document. Please reupload the valid document";
      } else if (multipleOwnerID(ownerIdList!) == false) {
        addButtonDisable = true;
        currentErrorMsg = "You have uploaded two different Owner's Id. Please upload single Owner's Id";
      } else if (multipleDocWithSameType > 1) {
        addButtonDisable = true;
        currentErrorMsg = "You have uploaded multiple ${widget.title} document. Kindly upload only one document here.";
      } else if (uploadedOwnerId()) {
        addButtonDisable = true;
        currentErrorMsg = "You have already uploaded this document so can not upload same document twice.";
      } else {
        List<String> docImageUrlListTemp = [];
        List<String> docStatusManagerTemp = [];
        List<int> docImageIdTemp = [];
        List<String> docOcrDataListTemp = [];
        for (int i = 0; i < docStatusManager.length; i++) {
          if (docStatusManager[i] != 'old') {
            docStatusManagerTemp.add(docStatusManager[i]);
            docImageUrlListTemp.add(docImageUrlList[i]);
            docOcrDataListTemp.add(docOcrDataList[i]);
            docImageIdTemp.add(docImageId[i]);
          }
        }
        if (docImageUrlList.length > 0) {
          String docStatusTemp = '';
          if (widget.businessStatus == '1') {
            if (widget.isFirstTime == true) {
              docStatusTemp = '4';
            } else {
              docStatusTemp = '6';
            }
          }
          if (widget.businessStatus == '3') {
            bool isAddEditAvailable = false;
            bool isDeleteAvailable = false;
            for (int i = 0; i < docStatusManagerTemp.length; i++) {
              if (docStatusManagerTemp[i] != 'delete') {
                isAddEditAvailable = true;
              }
              if (docStatusManagerTemp[i] == 'delete') {
                isDeleteAvailable = true;
              }
            }
            if (widget.isFirstTime == true) {
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
          String widgetIdTemp = widget.id.toString();
          if (widget.id == "") {
            widgetIdTemp = "6";
          }
          docData.addAll({
            widgetIdTemp!: {
              "id": docImageIdTemp,
              'date': cnt.selectedDate,
              'file': '',
              'status': docStatusManagerTemp,
              'mediaStatus': docStatusTemp,
              'url': docImageUrlListTemp,
              'doc_expiry': cnt.selectedDate,
              'metadata': docOcrDataListTemp,
              'unique_id': (widget.isFirstTime == true || widget.uniqueID == null)
                  ? DateTime.now().microsecondsSinceEpoch.toString()
                  : widget.uniqueID,
            }
          });
        }

        // for (int i = 0; i < docStatusManager.length; i++) {
        //   if (docStatusManager[i] == 'delete') {
        //     docStatusManager.removeAt(i);
        //     docImageUrlList.removeAt(i);
        //     docOcrDataList.removeAt(i);
        //     docImageId.removeAt(i);
        //   }
        // }
        print('doc------${docData}');
        Get.back(result: docData);
      }
      setState(() {});
    }
  }

  bool checkKeyinResponse({required String response}) {
    var finalString = response.toLowerCase();
    if (widget.id == '1') {
      return isCommercialRegistration(finalString);
      // return ((finalString.contains('registration and commercial') && finalString.contains('licenses department')) &&
      //     (finalString.contains('commercial registration data') || finalString.contains('مستخرج ببعض بيانات السجل التجارى')) &&
      //     (finalString.contains('commercial reg. no.') || finalString.contains('رقم السجل التجارى')));
      // return ((finalString.contains('Registration and Commercial'.toLowerCase()) &&
      //         finalString.contains('Licenses Department'.toLowerCase()) &&
      //         finalString.contains('مستخرج ببعض بيانات السجل التجارى') &&
      //         finalString.contains('رقم السجل التجارى')) ||
      //     (finalString.contains('Registration and Commercial'.toLowerCase()) &&
      //         finalString.contains('Licenses Department'.toLowerCase()) &&
      //         finalString.contains('Commercial Registration Data'.toLowerCase()) &&
      //         finalString.contains('Commercial Reg. No.'.toLowerCase())));
    } else if (widget.id == '2') {
      return isCommercialLicense(finalString);
      // return ((finalString.contains('registration and commercial') && finalString.contains('licenses department')) &&
      //     (finalString.contains('رخصة تجارية') || finalString.contains('رخصة تجاربة')) && finalString.contains('رقم السجل التجارى'));
      // return ((finalString.contains('Registration and Commercial'.toLowerCase()) &&
      //     finalString.contains('Licenses Department'.toLowerCase()) &&
      //     finalString.contains('رخصة تجارية') &&
      //     finalString.contains('رقم السجل التجارى')));
    } else if (widget.id == '3') {
      return isComputerCard(finalString);
      //return (finalString.contains('est. name') && finalString.contains('establishment card') && finalString.contains('est. id'));
      // return ((finalString.contains('STATE OF QATAR'.toLowerCase()) &&
      //     finalString.contains('Establishment Card'.toLowerCase()) &&
      //     finalString.contains('Est. ID'.toLowerCase())));
    } else if (widget.id == '4') {
      return isOwnerId(finalString);
      // return ((finalString.contains('id. card') || finalString.contains('id.card') || finalString.contains('residency permit')) &&
      //     (finalString.contains('id. no') || finalString.contains('id.no')));
      // return ((finalString.contains('State of Qatar'.toLowerCase()) &&
      //         (finalString.contains('ID. Card'.toLowerCase()) || finalString.contains('ID.Card'.toLowerCase())) &&
      //         (finalString.contains('ID. No'.toLowerCase()) || finalString.contains('ID.No'.toLowerCase()))) ||
      //     (finalString.contains('State of Qatar'.toLowerCase()) &&
      //         finalString.contains('Residency Permit'.toLowerCase()) &&
      //         (finalString.contains('ID. No'.toLowerCase()) || finalString.contains('ID.No'.toLowerCase()))));
    } else {
      return true;
    }
    return false;
  }

  List<String>? checkOtherDocKeyinResponse({required String response}) {
    List<String>? otherDocKeyAvailable = [];
    var finalString = response.toLowerCase();
    if (widget.id == '1') {
      if (isCommercialLicense(finalString)) {
        //Commercial Licenses
        otherDocKeyAvailable.add('Commercial license');
      } else if (isComputerCard(finalString)) {
        //Computer Card
        otherDocKeyAvailable.add('Establishment card');
      } else if (isOwnerId(finalString)) {
        //Computer Card
        otherDocKeyAvailable.add("Owner’s ID card");
      }
    }
    if (widget.id == '2') {
      if (isCommercialRegistration(finalString)) {
        //Commercial Registration
        otherDocKeyAvailable.add('Commercial registration');
      } else if (isComputerCard(finalString)) {
        //Computer Card
        otherDocKeyAvailable.add('Establishment card');
      } else if (isOwnerId(finalString)) {
        //Computer Card
        otherDocKeyAvailable.add("Owner’s ID card");
      }
    }
    if (widget.id == '3') {
      if (isCommercialRegistration(finalString)) {
        //Commercial Registration
        otherDocKeyAvailable.add('Commercial registration');
      } else if (isCommercialLicense(finalString)) {
        //Commercial Licenses
        otherDocKeyAvailable.add('Commercial license');
      } else if (isOwnerId(finalString)) {
        //Computer Card
        otherDocKeyAvailable.add('Owner’s ID card');
      }
    }
    if (widget.id == '4') {
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
    }
    return otherDocKeyAvailable;
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

  bool isOwnerId(String finalString) {
    return ((finalString.contains('id. card') || finalString.contains('id.card') || finalString.contains('residency permit')) &&
        (finalString.contains('id. no') || finalString.contains('id.no')));
  }

  fetchExpiryDate(Map? mainData) {
    if (mainData != null) {
      if (mainData.containsKey('Expiry Date')) {
        expiryDateList?.add(mainData['Expiry Date']);
      } else if (mainData.containsKey('Date of expiry')) {
        expiryDateList?.add(mainData['Date of expiry']);
      } else if (mainData.containsKey('Expiry')) {
        expiryDateList?.add(mainData['Expiry']);
      } else {}
    }
  }

  fetchOwnerIdNo(Map? mainData) {
    if (mainData != null) {
      if (mainData.containsKey('ID. No')) {
        ownerIdList?.add(mainData['ID. No']);
      } else if (mainData.containsKey('ID. NO')) {
        ownerIdList?.add(mainData['ID. NO']);
      } else if (mainData.containsKey('ID.No')) {
        ownerIdList?.add(mainData['ID.No']);
      } else if (mainData.containsKey('ID.NO')) {
        ownerIdList?.add(mainData['ID.NO']);
      } else {}
    }
  }

  checkForMultipleDocWithSameType(String? ScannedDate) {
    var finalString = ScannedDate?.toLowerCase() ?? '';
    if (widget.id == '1') {
      if (isCommercialRegistration(finalString)) {
        multipleDocWithSameType++;
      }
    } else if (widget.id == '2') {
      if (isCommercialLicense(finalString)) {
        multipleDocWithSameType++;
      }
    } else if (widget.id == '3') {
      if (isComputerCard(finalString)) {
        multipleDocWithSameType++;
      }
    } else if (widget.id == '4') {
      if (isOwnerId(finalString)) {
        multipleDocWithSameType++;
      }
    } else {
      return false;
    }
    return false;
  }

  bottomSheet() {
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
                  "please select Document format to",
                  style: TextStyle(color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  "upload from below",
                  style: TextStyle(color: ColorsUtils.primary, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                height28(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    commonCardBottomSheet(title: 'PDF'.tr, imageText: "assets/images/docPDF.png", text: "PDF"),
                    commonCardBottomSheet(title: 'Image'.tr, imageText: "assets/images/uploadImageIcon.png", text: "Image"),
                  ],
                ),
                height28(),
                Text(
                  "File size limit 20 MB.",
                  style: TextStyle(color: ColorsUtils.primary, fontSize: 16, fontWeight: FontWeight.w700),
                ),
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

  Widget commonCardBottomSheet({required String title, required String text, required String imageText}) {
    return InkWell(
      onTap: () {
        curruntDocType = title;
        Get.back();
        getImageFile();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Image.asset(imageText),
            width: Get.width * 0.35,
            height: Get.width * 0.35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: ColorsUtils.white,
                boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black45, offset: Offset(0, 2.5))]),
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

  bool docUploadLimitReached() {
    if (widget.id == '1') {
      if (countTotalDoc() + docSelectedfile.length > 10) {
        return false;
      }
    } else if (widget.id == '2') {
      if (countTotalDoc() + docSelectedfile.length > 5) {
        return false;
      }
    } else if (widget.id == '3') {
      if (countTotalDoc() + docSelectedfile.length > 2) {
        return false;
      }
    } else if (widget.id == '4') {
      if (countTotalDoc() + docSelectedfile.length > 2) {
        return false;
      }
    } else {
      return true;
    }
    return true;
  }

  bool docUploadLimitReachedForFirstTimeUpload() {
    if (widget.id == '1') {
      if (countTotalDoc() + docSelectedfile.length > 10) {
        return false;
      }
    } else if (widget.id == '2') {
      if (countTotalDoc() + docSelectedfile.length > 5) {
        return false;
      }
    } else if (widget.id == '3') {
      if (countTotalDoc() + docSelectedfile.length > 2) {
        return false;
      }
    } else if (widget.id == '4') {
      if (countTotalDoc() + docSelectedfile.length > 2) {
        return false;
      }
    } else {
      return true;
    }
    return true;
  }

  int allowNumberOfDocument() {
    if (widget.id == '1') {
      return 10;
    } else if (widget.id == '2') {
      return 5;
    } else if (widget.id == '3') {
      return 2;
    } else if (widget.id == '4') {
      return 2;
    } else {
      return 1;
    }
  }

  int countTotalDoc() {
    int counter = 0;
    for (int i = 0; i < docStatusManager.length; i++) {
      if (docStatusManager[i] != 'delete') {
        counter++;
      }
    }
    return counter;
  }

  int countTotalNewDoc() {
    int counter = 0;
    for (int i = 0; i < docStatusManager.length; i++) {
      if (docStatusManager[i] == 'new') {
        counter++;
      }
    }
    return counter;
  }

  onBackWithoutSave() {
    if (widget.isFirstTime != true && widget.url != null) {
      docOcrDataList = docOcrDataListCopy;
      docImageId = docImageIdCopy;
      docImageUrlList = docImageUrlListCopy;
      docStatusManager = docStatusManagerCopy;
      setState(() {});
    }
    Get.back();
  }

  bool uploadedOwnerId() {
    List<String> ownerIdListTemp = [];
    for (int i = 0; i < widget.businessMediaMultiPageList!.length; i++) {
      if (widget.businessMediaMultiPageList![i].metadata != null) {
        if (widget.businessMediaMultiPageList![i].metadata!.length > 0) {
          for (int j = 0; j < widget.businessMediaMultiPageList![i].metadata!.length; j++) {
            if (widget.businessMediaMultiPageList![i].metadata?[j] != "" &&
                widget.businessMediaMultiPageList![i].metadata?[j] != null &&
                widget.businessMediaMultiPageList![i].businessmediatypeId == 4 &&
                widget.businessMediaMultiPageList![i].unique_id != widget.uniqueID &&
                widget.businessMediaMultiPageList![i].docStatus![j] != "delete") {
              Map ocrMap = jsonDecode(widget.businessMediaMultiPageList![i].metadata?[j] ?? "");
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
    if (ownerIdList != null) {
      if (ownerIdList!.length > 0) {
        if (ownerIdListTemp.contains(ownerIdList![0])) {
          return true;
        }
      }
    }
    return false;
  }

  Widget commonRowDataBottomSheet({String? img, String? title}) {
    return InkWell(
      onTap: () {
        curruntDocType = title;
        Get.back();
        getImageFile();
      },
      child: Row(
        children: [
          img == null
              ? SizedBox()
              : Image.asset(
                  img,
                  height: 25,
                  color: img == Images.link
                      ? ColorsUtils.black
                      : img == Images.delete
                          ? ColorsUtils.reds
                          : ColorsUtils.black,
                  width: 25,
                ),
          width8(),
          Text(
            title!,
            style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall, color: ColorsUtils.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          bottomSheet: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    if (!addButtonDisable) {
                      if (_formKey.currentState!.validate()) {
                        if (addButtonDisable) {
                          Get.snackbar('error'.tr, 'Please add or change document as per error message.'.tr);
                        } else if (countTotalDoc() == 0 && docSelectedfile.length == 0) {
                          print("Empty Ave che");
                          Get.snackbar('error'.tr, 'At least one document should be there.'.tr);
                        } else {
                          uploadAndVerifyAllDoc();
                        }
                      }
                    }
                  },
                  child: buildContainerWithoutImage(
                      color: addButtonDisable == true ? ColorsUtils.primaryTransparent : ColorsUtils.primary, text: 'Add'.tr),
                ),
              ),
            ],
          ),
          appBar: commonAppBar(onBack: onBackWithoutSave),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height24(),
                Text(widget.title.toString(), style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medLarge)),
                height12(),
                Text(widget.subtitle.toString()),
                height32(),
                Container(
                  child: InkWell(
                    onTap: () {
                      widget.isFirstTime == true
                          ? curruntDocType == null ||
                                  curruntDocType == '' ||
                                  (countTotalDoc() == 0 && docSelectedfile.length == 0)
                              ? bottomSheet()
                              : getImageFile()
                          : curruntDocType == null || curruntDocType == '' || countTotalDoc() == 0
                              ? bottomSheet()
                              : getImageFile();
                    },
                    child: Row(children: [
                      width16(),
                      Expanded(
                        child: Text(
                          "Upload Document",
                          style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      CircleAvatar(
                          child: Icon(Icons.add, color: ColorsUtils.white), radius: 13, backgroundColor: ColorsUtils.primary),
                      width16(),
                    ]),
                  ),
                  height: Get.height * 0.06,
                  width: Get.width,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5), blurRadius: 5, blurStyle: BlurStyle.normal, offset: Offset(0, 2))
                  ], borderRadius: BorderRadius.circular(12), color: ColorsUtils.lightBg),
                ),
                height32(),
                countTotalDoc() == 0 && widget.isFirstTime == false
                    ? SizedBox()
                    : Container(
                        height: Get.height * 0.21,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: docImageUrlList.length + docSelectedfile.length,
                          itemBuilder: (context, index) {
                            if (index < docImageUrlList.length) {
                              return docStatusManager[index] == 'delete'
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Container(
                                        width: Get.height * 0.125,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: Get.height * 0.125,
                                              height: Get.height * 0.125,
                                              decoration: BoxDecoration(
                                                  /*  image: curruntDocType == "PDF"
                                                      ? DecorationImage(image: AssetImage(Images.doc), fit: BoxFit.cover)
                                                      : DecorationImage(
                                                          image: NetworkImage(
                                                              "${Utility.baseUrl}containers/api-business/download/${docImageUrlList[index].toString()}?access_token=${tokenMain}"),
                                                          fit: BoxFit.cover),*/
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: ColorsUtils.border)),
                                              alignment: Alignment.topRight,
                                              child: Stack(
                                                children: [
                                                  curruntDocType == "PDF"
                                                      ? Image.asset(Images.docPDF, fit: BoxFit.cover)
                                                      : Image.network(
                                                          height: Get.height * 0.125,
                                                          width: Get.height * 0.125,
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
                                                          "${Utility.baseUrl}containers/api-business/download/${docImageUrlList[index].toString()}?access_token=${tokenMain}",
                                                          fit: BoxFit.cover,
                                                        ),
                                                  Align(
                                                    alignment: Alignment.topRight,
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (docStatusManager[index] == 'old') {
                                                          docStatusManager[index] = 'delete';
                                                        } else {
                                                          docImageUrlList.removeAt(index);
                                                          docStatusManager.removeAt(index);
                                                          docOcrDataList.removeAt(index);
                                                          docImageId.removeAt(index);
                                                        }
                                                        if (docImageUrlList.length + docSelectedfile.length == 0) {
                                                          curruntDocType = '';
                                                        }
                                                        if ((widget.isFirstTime == true
                                                            ? !docUploadLimitReachedForFirstTimeUpload()
                                                            : !docUploadLimitReached())) {
                                                          addButtonDisable = true;
                                                          currentErrorMsg =
                                                              "Maximum number of page limits has been reached. You're allowed to upload only ${allowNumberOfDocument().toString()} pages for this document category.";
                                                          //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
                                                        } else {
                                                          addButtonDisable = false;
                                                        }
                                                        bool onlyOldDoc = true;
                                                        for (int i = 0; i < docStatusManager.length; i++) {
                                                          if (docStatusManager[i] != 'old') {
                                                            onlyOldDoc = false;
                                                          }
                                                        }
                                                        if (onlyOldDoc == true && docSelectedfile.length == 0) {
                                                          currentErrorMsg = widget.isFirstTime == true
                                                              ? ''
                                                              : "You can edit this document's pages or can upload a new document.";
                                                          addButtonDisable = true;
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
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              docImageUrlList[index].toString(),
                                              style: TextStyle(fontSize: 13),
                                              maxLines: 3,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: Get.height * 0.125,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: Get.height * 0.125,
                                        height: Get.height * 0.125,
                                        decoration: BoxDecoration(
                                            image: curruntDocType == "PDF"
                                                ? DecorationImage(image: AssetImage(Images.docPDF), fit: BoxFit.cover)
                                                : DecorationImage(
                                                    image: FileImage(docSelectedfile[index - docImageUrlList.length]),
                                                    fit: BoxFit.cover),
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: ColorsUtils.border)),
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            docSelectedfile.removeAt(index - docImageUrlList.length);
                                            if (docImageUrlList.length + docSelectedfile.length == 0) {
                                              curruntDocType = '';
                                            }
                                            if ((widget.isFirstTime == true
                                                ? !docUploadLimitReachedForFirstTimeUpload()
                                                : !docUploadLimitReached())) {
                                              addButtonDisable = true;
                                              currentErrorMsg =
                                                  "Maximum number of page limits has been reached. You're allowed to upload only ${allowNumberOfDocument().toString()} pages for this document category.";
                                              //Get.snackbar('Upload limit'.tr, "Maximum number of doc limit reached allowed only ${allowNumberOfDocument().toString()}.".tr);
                                            } else {
                                              addButtonDisable = false;
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
                                      ),
                                      Text(
                                        docSelectedfile[index - docImageUrlList.length].path.split("/").last,
                                        style: TextStyle(fontSize: 13),
                                        maxLines: 3,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(
                    "You have selected ",
                    style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "${countTotalDoc() + docSelectedfile.length} ${countTotalDoc() + docSelectedfile.length > 1 ? "pages" : "page"} of the document.",
                    style: TextStyle(color: ColorsUtils.primary, fontSize: 15, fontWeight: FontWeight.w700),
                  )
                ]),
                height32(),
                addButtonDisable == true
                    ? Text(
                        currentErrorMsg ?? '',
                        style: TextStyle(color: ColorsUtils.primary, fontSize: 15, fontWeight: FontWeight.w700),
                      )
                    : SizedBox(),
                height24(),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
  bool docExpire = true;
  if (ownerIdList.length > 1) {
    if (ownerIdList[0] != ownerIdList[1]) {
      docExpire = false;
    }
  }
  return docExpire;
}

// class DateTextFormatter extends TextInputFormatter {
//   static const _maxChars = 8;
//
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     var text = _format(newValue.text, '/');
//     return newValue.copyWith(text: text, selection: updateCursorPosition(text));
//   }
//
//   String _format(String value, String seperator) {
//     value = value.replaceAll(seperator, '');
//     var newString = '';
//
//     for (int i = 0; i < min(value.length, _maxChars); i++) {
//       newString += value[i];
//       if ((i == 1 || i == 3) && i != value.length - 1) {
//         newString += seperator;
//       }
//     }
//
//     return newString;
//   }
//
//   TextSelection updateCursorPosition(String text) {
//     return TextSelection.fromPosition(TextPosition(offset: text.length));
//   }
// }
