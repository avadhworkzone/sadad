import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/addBankAccount.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccountDetail.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccountinfo.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/widget/bankAccountCard.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';

class BankAccount extends StatefulWidget {
  BankAccount({Key? key}) : super(key: key);

  @override
  State<BankAccount> createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
  BankAccountResponseModel bankAccountResponseModel =
      BankAccountResponseModel();
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  var bankAccountViewModel = Get.find<BankAccountViewModel>();
  String? token;
  bool? setAsDefault;
  ConnectivityViewModel connectivityViewModel = Get.find();
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    super.initState();
    initFunc();
  }

  void initFunc() async {
    token = await encryptedSharedPreferences.getString('token');
    await bankAccountViewModel.getBankData(context);
  }

  void showExportDialog(
      {String? id, int? statusId, List<BankAccountResponseModel>? model}) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (_) {
          return Container(
            height: setAsDefault ?? false ? 110 : 180,
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
                  setAsDefault ?? false
                      ? SizedBox()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                print('Status is $statusId');
                                if (statusId == 1) {
                                  await bankAccountViewModel.setAsDefault(
                                      context: context, id: id.toString());
                                  await bankAccountViewModel
                                      .getBankData(context);
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  Get.snackbar("Error",
                                      "Bank Account need to be verified to use it as default account");
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    SvgIcon(Images.SetAsDefault),
                                    width20(),
                                    Text(
                                      'Set as Default'.tr,
                                      style: ThemeUtils.blackSemiBold.copyWith(
                                          fontSize: FontUtils.mediumSmall),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: ColorsUtils.line,
                              thickness: 1,
                            ),
                          ],
                        ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      await bankAccountViewModel
                          .deleteBankUser(id: id.toString(), context: context)
                          .then((value) async {
                        if (setAsDefault ?? false) {
                          print(
                              "call set as primary api and make 2nd one as primary");
                          var str;
                          model?.forEach((element) async {
                            print(
                                "element.userbankstatusId ${element.userbankstatusId}");
                            print(statusId);
                            if (element.id.toString() == id.toString()) {
                            } else {
                              str = element.id;
                            }
                          });
                          if (statusId == 1) {
                            await bankAccountViewModel.setAsDefault(
                                context: context, id: str.toString());
                            print("str ---------- $str");
                          }
                        } else {}
                      });
                      await bankAccountViewModel.getBankData(context);
                      businessDetailCnt.getBankData(context);
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
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        log("${bankAccountViewModel.bankAccountList.length}",
            name: "bankAccountViewModel.bankAccountList.length");
        return WillPopScope(
          onWillPop: () async {
            Get.back();
            return false;
          },
          child: Scaffold(
            floatingActionButton: Obx(
              () => bankAccountViewModel.isLoading.value
                  ? SizedBox()
                  : bankAccountViewModel.bankAccountList.isEmpty || bankAccountViewModel.bankAccountList.length >= 2
                      ? SizedBox() : FloatingActionButton(
                          onPressed: () {
                            Get.off(() => BankAccountDetail());
                          },
                          child: Icon(Icons.add, color: ColorsUtils.white),
                          backgroundColor: ColorsUtils.primary,
                        ),
            ),
            appBar: commonAppBar(),
            body: Obx(
              () => bankAccountViewModel.isLoading.value
                  ? SizedBox()
                  : bankAccountViewModel.bankAccountList.isEmpty
                      ? AddBankAccountScreen()
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height24(),
                                Text(
                                  'Bank Account'.tr,
                                  style: ThemeUtils.blackSemiBold
                                      .copyWith(fontSize: FontUtils.medLarge),
                                ),
                                height12(),
                                Text(
                                  'Add your bank account details to transfer your account amount to it.'
                                      .tr,
                                  style: ThemeUtils.blackRegular
                                      .copyWith(fontSize: FontUtils.small),
                                ),
                                height32(),
                                Obx(
                                  () => ListView.builder(
                                    itemCount: bankAccountViewModel
                                        .bankAccountList.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          onTap: () async {
                                            Get.off(() => BankAccountInfo(),
                                                arguments: [
                                                  bankAccountViewModel
                                                      .bankAccountList[index],
                                                  businessDetailCnt
                                                              .businessInfoModel
                                                              .value
                                                              .user ==
                                                          null
                                                      ? ""
                                                      : businessDetailCnt
                                                          .businessInfoModel
                                                          .value
                                                          .user!
                                                          .name
                                                ]);
                                          },
                                          child: BankAccountCard(
                                            onUpdate: () {
                                              showExportDialog(
                                                  id: bankAccountViewModel
                                                      .bankAccountList[index].id
                                                      .toString(),
                                                  model: bankAccountViewModel
                                                      .bankAccountList,
                                                  statusId: bankAccountViewModel
                                                      .bankAccountList[index]
                                                      .userbankstatusId);
                                              setAsDefault =
                                                  bankAccountViewModel
                                                      .bankAccountList[index]
                                                      .primary;
                                            },
                                            token: token,
                                            bankAccountResponseModel:
                                                bankAccountViewModel
                                                    .bankAccountList[index],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
            ),
          ),
        );
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                setState(() {});
                initFunc();
              } else {
                Get.snackbar('error'.tr, 'Please check your connection'.tr);
              }
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          },
        );
      }
    } else {
      return InternetNotFound(
        onTap: () async {
          connectivityViewModel.startMonitoring();

          if (connectivityViewModel.isOnline != null) {
            if (connectivityViewModel.isOnline!) {
              setState(() {});
              initFunc();
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection'.tr);
          }
        },
      );
    }
  }
}
