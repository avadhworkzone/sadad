import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccount.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccountDetail.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';

import '../../../viewModel/more/businessInfo/businessInfoViewModel.dart';

class BankAccountInfo extends StatefulWidget {
  const BankAccountInfo({Key? key}) : super(key: key);

  @override
  State<BankAccountInfo> createState() => _BankAccountInfoState();
}

class _BankAccountInfoState extends State<BankAccountInfo> {
  String? token;
  BankAccountResponseModel bankAccountResponseModel =
      BankAccountResponseModel();
  String? userName;
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  final bankAccountViewModel = Get.find<BankAccountViewModel>();

  @override
  void initState() {
    setToken();
    // TODO: implement initState
    super.initState();
    bankAccountResponseModel = Get.arguments[0];
    userName = Get.arguments[1];
  }

  void setToken() async {
    token = await encryptedSharedPreferences.getString('token');
  }

  void showExportDialog(String? id) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (_) {
          return Container(
            height: bankAccountResponseModel.primary ?? false ? 120 : 180,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height12(),
                  Center(
                    child: Container(
                      height: 4,
                      width: 65,
                      decoration: BoxDecoration(
                          color: ColorsUtils.border,
                          borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                  height16(),
                  bankAccountResponseModel.primary ?? false
                      ? SizedBox()
                      : Column(
                          children: [
                            bankAccountResponseModel.userbankstatusId == 1
                                ? InkWell(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await bankAccountViewModel.setAsDefault(
                                          context: context, id: id.toString());
                                      await bankAccountViewModel
                                          .getBankData(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Row(
                                        children: [
                                          SvgIcon(Images.SetAsDefault),
                                          width20(),
                                          Text(
                                            'Set as Default'.tr,
                                            style: ThemeUtils.blackSemiBold
                                                .copyWith(
                                                    fontSize:
                                                        FontUtils.mediumSmall),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            bankAccountResponseModel.userbankstatusId == 1
                                ? Divider(
                                    color: ColorsUtils.line,
                                    thickness: 1,
                                  )
                                : SizedBox(),
                          ],
                        ),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Remove account'.tr),
                              content: Text(
                                  'Are you sure you want to remove the account'
                                      .tr),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('No'.tr),
                                  onPressed: () =>
                                      Navigator.pop(context, 'Ok'.tr),
                                ),
                                TextButton(
                                    child: Text('Yes'.tr),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await bankAccountViewModel.deleteBankUser(
                                          id: id.toString(), context: context);
                                      await bankAccountViewModel
                                          .getBankData(context);
                                    }),
                              ],
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Image.asset(
                            Images.delete,
                            color: ColorsUtils.black,
                            height: 24,
                            width: 24,
                          ),
                          width20(),
                          Text(
                            "Delete".tr,
                            style: ThemeUtils.blackSemiBold
                                .copyWith(fontSize: FontUtils.mediumSmall),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => BankAccount());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsUtils.lightBg,
          leading: ButtonTheme(
            minWidth: 60,
            // splashColor: ColorsUtils.black,
            child: TextButton(
              onPressed: () {
                Future.delayed(
                  Duration(seconds: 0),
                  () => Get.off(BankAccount()),
                );
              },
              style: ButtonStyle(
                overlayColor: MaterialStateColor.resolveWith(
                    (states) => ColorsUtils.white),
              ),
              child:
                  Icon(Icons.arrow_back_ios_rounded, color: ColorsUtils.black),
            ),
          ),
          actions: [
            ButtonTheme(
              minWidth: 60,
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => ColorsUtils.white),
                ),
                onPressed: () {
                  showExportDialog(bankAccountResponseModel.id.toString());
                },
                child: SvgIcon(Images.menuIcon),
              ),
            )
          ],
        ),
        backgroundColor: ColorsUtils.white,
        body: Column(
          children: [
            // height30(),
            Container(color: ColorsUtils.lightBg, height: 30),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    // height: 645,
                    color: ColorsUtils.white,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // height60(),
                          Container(color: ColorsUtils.white, height: 60),

                          Center(
                            child: Text(bankAccountResponseModel.bank!.name!,
                                style: ThemeUtils.blackSemiBold
                                    .copyWith(fontSize: FontUtils.mediumSmall)),
                          ),
                          height24(),
                          Center(
                            child: Text(userName ?? "",
                                style: ThemeUtils.blackSemiBold
                                    .copyWith(fontSize: FontUtils.small)),
                          ),
                          height12(),
                          Center(
                            child: Text('IBAN: '.tr,
                                style: ThemeUtils.blackRegular
                                    .copyWith(fontSize: FontUtils.small)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(bankAccountResponseModel.ibannumber!,
                                  style: ThemeUtils.blackRegular
                                      .copyWith(fontSize: FontUtils.small)),
                              width22(),
                              InkWell(
                                child: SvgIcon(
                                  Images.copy,
                                ),
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                        text: bankAccountResponseModel
                                            .ibannumber!),
                                  );
                                  Get.showSnackbar(
                                    GetSnackBar(
                                      message: 'Copied to clipboard'.tr,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                          height25(),
                          dividerWidth1(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 23, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Default Account'.tr,
                                    style: ThemeUtils.blackSemiBold.copyWith(
                                        fontSize: FontUtils.mediumSmall)),
                                Text(
                                    bankAccountResponseModel.primary ?? false
                                        ? "YES".tr
                                        : 'NO'.tr,
                                    style: ThemeUtils.maroonSemiBold.copyWith(
                                        fontSize: FontUtils.verySmall)),
                              ],
                            ),
                          ),
                          dividerWidth1(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 23, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Account status'.tr,
                                    style: ThemeUtils.blackSemiBold.copyWith(
                                        fontSize: FontUtils.mediumSmall)),
                                Spacer(),
                                SvgIcon(getAccountStatus(
                                    "${bankAccountResponseModel.userbankstatus!.id}")),
                                width8(),
                                Text(
                                    bankAccountResponseModel
                                        .userbankstatus!.name
                                        .toString(),
                                    style: ThemeUtils.blackRegular.copyWith(
                                        fontSize: FontUtils.verySmall)),
                              ],
                            ),
                          ),
                          dividerWidth1(),
                          bankAccountResponseModel.userbankstatus!.name
                                      .toString() !=
                                  'Need action'
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 23, vertical: 14),
                                  child: Text('Actions'.tr,
                                      style: ThemeUtils.blackSemiBold.copyWith(
                                          fontSize: FontUtils.mediumSmall)),
                                ),
                          bankAccountResponseModel.userbankstatus!.name
                                      .toString() !=
                                  'Need action'
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 23),
                                  child: Text(
                                      'The Authorization letter is not right, kindly check it an upload another one.'
                                          .tr,
                                      style: ThemeUtils.blackRegular.copyWith(
                                          fontSize: FontUtils.mediumSmall)),
                                ),
                          bankAccountResponseModel.userbankstatus!.id == 5
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 23, vertical: 32),
                                  child: InkWell(
                                    onTap: () {
                                      Get.off(
                                        () => BankAccountDetail(
                                          isEdit: true,
                                          iban: bankAccountResponseModel
                                              .ibannumber!,
                                          accountname: bankAccountResponseModel
                                              .bank!.name!,
                                        ),
                                      );
                                    },
                                    child: buildContainerWithoutImage(
                                        width: 90,
                                        borderRadius: BorderRadius.circular(12),
                                        color: ColorsUtils.accent,
                                        text: 'Edit'.tr),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 95.0 / 2,
                  width: double.infinity,
                  color: ColorsUtils.lightBg,
                ),
                Center(
                  child: Container(
                    height: 95.0,
                    width: 95.0,
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
                      child: Image.network(
                        "${Constants.bankContainer}${bankAccountResponseModel.bank?.logo}",
                        headers: {HttpHeaders.authorizationHeader: token ?? ""},
                        height: 52.0,
                        width: 52.0,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
