import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/addBankAccountModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/uploadImageResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/more/bank/bankAccountRepo.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccount.dart';

import '../../../model/apimodels/responseModel/more/IdentityDocumentProofingModel.dart';

class BankAccountViewModel extends GetxController {
  RxBool isLoading = false.obs;
  RxInt statusCode = 0.obs;
  // RxBool isIBANNumberValid = false.obs;
  RxInt bankId = 0.obs;
  RxString uploadedUrl = "".obs;

  BankAccountRepo bankAccountRepo = BankAccountRepo();
  RxList<BankAccountResponseModel> bankAccountList =
      <BankAccountResponseModel>[].obs;

  RxList<Bank> masterBanks = <Bank>[].obs;
  Rx<AddBankAccountModel> addBankAccountModel = AddBankAccountModel().obs;
  Rx<TextEditingController> ibanController = TextEditingController().obs;
  Rx<TextEditingController> accountNameController = TextEditingController().obs;
  ApiResponse uploadImageApiResponse = ApiResponse.initial('Initial');

  void updateBankID(int val) {
    bankId.value = val;
  }

  Future<void> getBankData(context) async {
    isLoading.value = true;
    showLoadingDialog(context: context);
    bankAccountList.clear();
    var accountList = await bankAccountRepo.getBankAccountDetail();
    accountList.forEach((data) {
      bankAccountList.add(BankAccountResponseModel.fromJson(data));
    });
    print("Bank account list = ${bankAccountList.toString()}");
    isLoading.value = false;
    hideLoadingDialog(context: context);
  }

  Future<void> addBankData(
      {context, required String ibanNumber, int? bankId, bool? primary, required String accountName}) async {
    // isLoading.value = true;
    showLoadingDialog(context: context);
    addBankAccountModel.value = await bankAccountRepo.addBankAccount(
        authorizationdetails: uploadedUrl.value,
        ibanNumber: ibanNumber,
        bankId: bankId,
        primary: primary, accountName: accountName);
    // isLoading.value = false;
    hideLoadingDialog(context: context);
    if(addBankAccountModel.value.userbankstatusId != null) {
      Future.delayed(
        Duration(seconds: 0),
            () {
          // Get.back(result: true);
          Get.off(() => BankAccount());
        },
      );
    }
  }

  Future<void> deleteBankUser({context, required String id}) async {
    // isLoading.value = true;
    showLoadingDialog(context: context);
    await bankAccountRepo.deleteBankAccount(id: id);
    Future.delayed(
      Duration(seconds: 1),
      () {
        Get.off(BankAccount());
      },
    );
    hideLoadingDialog(context: context);
    // isLoading.value = false;
  }

  Future<void> uploadImage({required File file, context}) async {
    // uploadImageApiResponse = ApiResponse.loading('Loading');
    try {
      showLoadingDialog(context: context);

      UploadImageResponseModel response =
          await bankAccountRepo.uploadBusinessDocImageRepo(file: file);
      // uploadImageApiResponse = ApiResponse.complete(response);
      // print("uploadImageApiResponse RES:$response");
      uploadedUrl.value = "${response.result!.files!.file?[0].name}";
      print(uploadedUrl.value);
      hideLoadingDialog(context: context);
    } catch (e) {
      print('uploadImageApiResponse.....$e');
      // uploadImageApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> uploadBankImage({required File file, context}) async {
    // uploadImageApiResponse = ApiResponse.loading('Loading');
    try {
      showLoadingDialog(context: context);

      UploadImageResponseModel response =
          await bankAccountRepo.uploadBankingDocImageRepo(file: file);
      // uploadImageApiResponse = ApiResponse.complete(response);
      // print("uploadImageApiResponse RES:$response");
      uploadedUrl.value = "${response.result!.files!.file?[0].name}";
      print(uploadedUrl.value);
      hideLoadingDialog(context: context);
    } catch (e) {
      print('uploadImageApiResponse.....$e');
      // uploadImageApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> uploadBusinessImage({required File file, context}) async {
    // uploadImageApiResponse = ApiResponse.loading('Loading');
    try {
      //showLoadingDialog(context: context);

      UploadImageResponseModel response =
          await bankAccountRepo.uploadBusinessDocImageRepo(file: file);
      // uploadImageApiResponse = ApiResponse.complete(response);
      // print("uploadImageApiResponse RES:$response");
      uploadedUrl.value = "${response.result!.files!.file?[0].name}";
      print(uploadedUrl.value);
      //ideLoadingDialog(context: context);
    } catch (e) {
      print('uploadImageApiResponse.....$e');
      // uploadImageApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<Map?> uploadBusinessDocMultiple({required File file, context}) async {
    // uploadImageApiResponse = ApiResponse.loading('Loading');
    try {
      //showLoadingDialog(context: context);

      return await bankAccountRepo.uploadBusinessDocImageNewRepo(file: file);
      // uploadImageApiResponse = ApiResponse.complete(response);
      // print("uploadImageApiResponse RES:$response");
      // uploadedUrl.value = "${response.result!.files!.file?[0].name}";
      // print(uploadedUrl.value);
      // //ideLoadingDialog(context: context);
    } catch (e) {
      print('uploadImageApiResponse.....$e');
      // uploadImageApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<Map?> verifyBusinessImage({required File file, context, required typeId}) async {
    // uploadImageApiResponse = ApiResponse.loading('Loading');
    try {
      //showLoadingDialog(context: context);

      /*UploadImageResponseModel response =*/
      log("api calling");
      return await bankAccountRepo.verifyBusinessDocImageRepo(file: file, typeId: typeId);
      hideLoadingDialog(context: context);
      // uploadImageApiResponse = ApiResponse.complete(response);
      // print("uploadImageApiResponse RES:$response");
/*
      uploadedUrl.value = "${response.result!.files!.file?[0].name}";
*/
      print(uploadedUrl.value);

    } catch (e) {
      print('verifyImageApiResponse.....$e');
      // uploadImageApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<Map?> fetchDocOcrData({required File file, context, required String typeId}) async {
    // uploadImageApiResponse = ApiResponse.loading('Loading');
    try {
      // showLoadingDialog(context: context);

      /*UploadImageResponseModel response =*/
      log("api calling");
      return await bankAccountRepo.fetchDocOcrData(file: file,typeId: typeId);
      // uploadImageApiResponse = ApiResponse.complete(response);
      // print("uploadImageApiResponse RES:$response");
/*
      uploadedUrl.value = "${response.result!.files!.file?[0].name}";
*/
      print(uploadedUrl.value);
      hideLoadingDialog(context: context);
    } catch (e) {
      print('verifyImageApiResponse.....$e');
      // uploadImageApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<Map?> identityDocumentProofing({required File file, context,required String typeId}) async {
    // uploadImageApiResponse = ApiResponse.loading('Loading');
    /*try {*/
      //showLoadingDialog(context: context);
    try {
      Map? temp =  await bankAccountRepo.identityDocumentProofing(file: file,typeId: typeId);
      return temp;
    }
    catch (e) {
      print('verifyImageApiResponse.....$e');
      // uploadImageApiResponse = ApiResponse.error('error');
    }
      // uploadImageApiResponse = ApiResponse.complete(response);
      // print("uploadImageApiResponse RES:$response");


      hideLoadingDialog(context: context);
    /*} catch (e) {
      print('uploadImageApiResponse.....$e');
      // uploadImageApiResponse = ApiResponse.error('error');
    }*/
    update();
  }

  Future<void> getBanks(context) async {
    masterBanks.clear();
    bankId.value = 0;
    isLoading.value = true;
    // showLoadingDialog(context: context);
    bankAccountList.clear();
    var accountList = await bankAccountRepo.getBank();
    accountList.forEach((data) {
      masterBanks.add(Bank.fromJson(data));
      print('masterbank$masterBanks');
    });
    print("Bank account list = ${bankAccountList.toString()}");
    isLoading.value = false;
    // hideLoadingDialog(context: context);
  }

  Future setAsDefault({required BuildContext context, String? id}) async {
    isLoading.value = true;
    showLoadingDialog(context: context);
    await bankAccountRepo.updateSetAsDefault(true, id: id.toString());
    Future.delayed(
      Duration(seconds: 1),
      () {
        Get.off(BankAccount());
      },
    );
    // log("businessInfoModel.value.businessmedia[0].name :- ${businessInfoModel.value.businessmedia?[0].name}");
    hideLoadingDialog(context: context);
    isLoading.value = false;
    update();
  }
}

// class SetAsDefaultResponseModel extends GetxController {
//
//   RxBool isLoading = false.obs;
//   Rx<AddSetAsDefaultViewModel> addSetAsDefaultViewModel =
//       AddSetAsDefaultViewModel().obs;
//   RxBool primary = true.obs;
//
// ////
//   void getNotificationSettings(context) async {
//     isLoading.value = true;
//     primary.value = addSetAsDefaultViewModel.value.primary!;
//   }
//
//
//
//
// }
