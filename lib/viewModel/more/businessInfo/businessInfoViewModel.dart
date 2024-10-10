import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/model/repo/more/businessInfo/businessInfoRepo.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/editAddress.dart';
import 'package:sadad_merchat_app/view/more/moreScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessmodel.dart';
import 'package:sadad_merchat_app/widget/textfiledScreen.dart';
import '../../../model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import '../../../model/repo/more/bank/bankAccountRepo.dart';

class BusinessInfoViewModel extends GetxController {
  RxBool isLoading = true.obs;
  RxBool primary = true.obs;
  BankAccountResponseModel bankAccountResponseModel =
      BankAccountResponseModel();
  BusinessInfoRepo businessInfoRepo = BusinessInfoRepo();
  BankAccountRepo bankAccountRepo = BankAccountRepo();
  Rx<BusinessInfoResponseModel> businessInfoModel =
      BusinessInfoResponseModel().obs;
  Rx<BusinessDataModel> businessDataModel = BusinessDataModel().obs;
  RxString posVal = "0".obs;
  RxString activeVal = "0".obs;
  File? image;
  String imageName = "";
  String selectedDate = "";
  TextEditingController dateCnt = TextEditingController();
  List<Businessmedia> uploadedBusinessMediaList = <Businessmedia>[];
  RxList<Businessmedia> businessMediaList = <Businessmedia>[].obs;
  RxList<BankAccountResponseModel> bankAccountList =
      <BankAccountResponseModel>[].obs;
  RxInt businessInfoCount = 0.obs;
  RxInt bankInfoCount = 0.obs;

  // final bankAccountViewModel = Get.find<BankAccountViewModel>();

  void assignBusinessMedia() {
    businessMediaList.value = [
      Businessmedia(
          title: 'Owner’s ID card'.tr,
          name:
          "Upload your authorized person or owner's valid Residency ID card"
              .tr,
          businessmediatypeId: 4,
          status: false),
      Businessmedia(
          title: 'Commercial registration'.tr,
          name:
              "Upload your valid Commercial Registration copy as issued by the Ministry of Economy & Commerce"
                  .tr,
          businessmediatypeId: 1,
          status: false),
      Businessmedia(
          title: 'Commercial license'.tr,
          name:
              "Upload your valid Commercial License copy as issued by the Ministry of Municipality"
                  .tr,
          businessmediatypeId: 2,
          status: false),
      Businessmedia(
          title: 'Establishment card'.tr,
          name:
              "Upload your valid Company Establishment card "
                  .tr,
          businessmediatypeId: 3,
          status: false),
      Businessmedia(
          title: 'Other'.tr,
          name:
          "Upload other type of document here"
              .tr,
          businessmediatypeId: 6,
          status: false),
    ];
  }

  Future getBusinessInfo(context) async {
    isLoading.value = true;
    // try {
    businessInfoCount.value = 0;
    businessInfoModel.value = await businessInfoRepo.getBusinessInformation();
    if (businessInfoModel.value.userbusinessstatus?.id != null) {
      if (businessInfoModel.value.userbusinessstatus!.id == 4) {
        businessInfoCount.value = businessInfoCount.value + 1;
      }
    }
    await getActiveUserAndPOS(context);
    isLoading.value = false;
    update();
    // } catch (e) {
    //   isLoading.value = false;
    // }
  }

  Future getBankData(context) async {
    // isLoading.value = true;
    bankInfoCount.value = 0;
    bankAccountList.clear();
    var accountList = await bankAccountRepo.getBankAccountDetail();
    accountList.forEach((data) {
      bankAccountList.add(BankAccountResponseModel.fromJson(data));
    });
    print("Bank account list = ${bankAccountList.toString()}");

    await Future.forEach(bankAccountList, (bank) {
      bank as BankAccountResponseModel;

      if (bank.userbankstatus!.id == 4) {
        bankInfoCount.value = bankInfoCount.value + 1;
      }
      log("${bankInfoCount.value}", name: "bankInfoCount.value");
    });

    // isLoading.value = false;
  }

  Future getActiveUserAndPOS(context) async {
    isLoading.value = true;
    List<String>? tempList;

    tempList = await businessInfoRepo.getPOSandActiveUser();
    posVal.value = tempList[1];
    activeVal.value = tempList[0];
    businessDataModel.value.businessName = businessInfoModel.value.businessname;
    businessDataModel.value.buildingNumber =
        businessInfoModel.value.buildingnumber;
    businessDataModel.value.streetNumber = businessInfoModel.value.streetnumber;
    businessDataModel.value.email = businessInfoModel.value.user?.email;
    businessDataModel.value.zoneNumber = businessInfoModel.value.zonenumber;
    businessDataModel.value.logo = businessInfoModel.value.logo;
    businessDataModel.value.merchantRegisTeRationNumber =
        businessInfoModel.value.merchantregisterationnumber;
    businessDataModel.value.modifiedBy = businessInfoModel.value.modifiedby;
    businessDataModel.value.mobileNumber =
        businessInfoModel.value.user?.cellnumber;
    isLoading.value = false;
    update();
  }

  Future<void> onFieldTap({
    String? title,
    String? value,
    bool? isAddress,
    context,
    String? zone,
    String? streetNo,
    String? bldgNo,
    String? unitNo,
  }) async {
    print("title $title");
    print("value $value");
    var result = isAddress ?? false
        ? await Get.to(EditAddress(), arguments: [
            title,
            zone,
            streetNo,
            bldgNo,
            unitNo,
          ])
        : await Get.to(
            () => TextFieldDisplay(),
            arguments: [title, value],
          );
    if (result != null) {
      print("resultresultresultresultresult $result");
      // isLoading.value = true;
      showLoadingDialog(context: context);

      businessInfoModel.value = await businessInfoRepo.getBusinessInformation();
      isLoading.value = false;
      hideLoadingDialog(context: context);
    }
  }

  Future<void> updateBusinessDetails({
    context,
    BusinessDataModel? businessDataModel,
    required type,
    Businessmedia? businessMedia,
  }) async {
    isLoading.value = true;
    showLoadingDialog(context: context);
    await businessInfoRepo.updateBusinessInfoM(
        businessData: businessDataModel!,
        type: type,
        businessMedia: businessMedia);
    hideLoadingDialog(context: context);
    isLoading.value = false;
    update();
  }
  Future<void> updateBusinessDetailsNew({
    context,required Map<String, dynamic>? body
  }) async {
    isLoading.value = true;
    showLoadingDialog(context: context);
    await businessInfoRepo.updateBusinessInfoNew(body);

    hideLoadingDialog(context: context);
    isLoading.value = false;
    update();
  }

  Future<int> storeBusiness({
    context,
    required String businessName,
    required String businessReGiSteRationNumber,
    required String zoneNumber,
    // required String sadadPartnerID,
    required String streetNumber,
    required String buildingNumber,
    required String img,
    required Map<String, Map<String, dynamic>> businessDoc,

    required String userId,
  }) async {
    final businessDetailCnt = Get.find<BusinessInfoViewModel>();
    showLoadingDialog(context: context);
    int val = await businessInfoRepo.storeBusinessDetail(
        buildingNumber: buildingNumber,
        zoneNumber: zoneNumber,
        businessReGiSteRationNumber: businessReGiSteRationNumber,
        businessName: businessName,
        streetNumber: streetNumber,
        userId: userId,
        businessDoc: businessDoc,
        img: img,
    );
    //hideLoadingDialog(context: context);
    Future.delayed(
      Duration(seconds: 0),
      () async {
        //Get.back();
        await businessDetailCnt.getBusinessInfo(context);
        // log("${businessDetailCnt.bankAccountList.length}",
        await businessDetailCnt.getBankData(context);
      },
    );
    update();
    return val;
  }
}
