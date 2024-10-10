// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/lastTransferListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/transferListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/lastTransferAllScreen.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/qrscan/generateQrAmountScreen.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/qrscan/scanQrScreen.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/transferAccountDetail.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/transferToPayScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/transferViewModel.dart';
import 'package:http/http.dart' as http;

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  TransferViewModel transferViewModel = Get.find();
  List<ActivityTransferListResponse>? activityTransferListRes;
  List<LastTransferListResponse>? lastRes;
  String userId = '';
  @override
  void initState() {
    transferViewModel.transferListApiResponse = ApiResponse.initial('Initial');
    initData();
    // TODO: implement initState
    super.initState();
  }

  initData() async {
    userId = await encryptedSharedPreferences.getString('id');

    transferViewModel.setTransactionInit();
    // transferViewModel.clearResponseList();
    await transferViewModel.transferList(filter: '/recent-ten');
    await transferViewModel.transferLastList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUtils.transferBg,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height40(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back_ios_rounded)),
            ),
            height10(),
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customLargeBoldText(title: 'Transfer'),
                                customSmallMedNorText(
                                    color: ColorsUtils.grey,
                                    title:
                                        'Transfer or pay to another sadad account')
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => ScanQrScreen());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(Images.qrCode, width: 30),
                                customSmallMedSemiText(title: 'Scan')
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    height20(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: InkWell(
                        onTap: () {
                          Get.to(() => GenerateQrAmountScreen());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: ColorsUtils.grey.withOpacity(0.1),
                                    blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.circular(15),
                              color: ColorsUtils.white),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Image.asset(
                                  Images.qrTransfer,
                                  width: 30,
                                  height: 30,
                                ),
                                width30(),
                                customMediumBoldText(title: 'Generate QR code'),
                                Spacer(),
                                CircleAvatar(
                                  backgroundColor: ColorsUtils.tabUnselectLabel,
                                  radius: 12,
                                  child: Icon(Icons.add,
                                      size: 15, color: ColorsUtils.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    height20(),
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.05),
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: ColorsUtils.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height60(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: customMediumLargeSemiText(
                                      title: 'Send to Recent'),
                                ),
                                height10(),
                                SizedBox(
                                  height: Get.height * 0.18,
                                  width: Get.width,
                                  child: GetBuilder<TransferViewModel>(
                                    builder: (controller) {
                                      if (controller.transferListApiResponse
                                                  .status ==
                                              Status.INITIAL ||
                                          controller.transferListApiResponse
                                                  .status ==
                                              Status.LOADING) {
                                        return Loader();
                                      }
                                      if (controller
                                              .transferListApiResponse.status ==
                                          Status.ERROR) {
                                        return SessionExpire();
                                        //return Text('error');
                                      }
                                      activityTransferListRes = controller
                                          .transferListApiResponse.data;
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount:
                                            activityTransferListRes!.length > 10
                                                ? 10
                                                : activityTransferListRes!
                                                    .length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: InkWell(
                                              onTap: () async {
                                                showLoadingDialog(
                                                    context: context);
                                                String token =
                                                    await encryptedSharedPreferences
                                                        .getString('token');
                                                final url = Uri.parse(
                                                    '${Utility.baseUrl}users/user-info?cellnumber=${activityTransferListRes![index].cellnumber.toString()}');
                                                Map<String, String> header = {
                                                  'Authorization': token,
                                                  'Content-Type':
                                                      'application/json'
                                                };
                                                var result = await http.get(
                                                  url,
                                                  headers: header,
                                                );
                                                print(
                                                    'user info res is ${result.body}');

                                                if (result.statusCode == 200) {
                                                  Future.delayed(
                                                      Duration(seconds: 1), () {
                                                    hideLoadingDialog(
                                                        context: context);
                                                    Get.to(() =>
                                                        TransferAccountDetails(
                                                          name: jsonDecode(result
                                                                      .body)[
                                                                  'name'] ??
                                                              "NA",
                                                          number:
                                                              activityTransferListRes![
                                                                      index]
                                                                  .cellnumber
                                                                  .toString(),
                                                          accountId: jsonDecode(
                                                                      result
                                                                          .body)[
                                                                  'SadadId'] ??
                                                              "NA",
                                                        ));
                                                    // Get.to(() => InvoiceList());
                                                  });
                                                } else {
                                                  hideLoadingDialog(
                                                      context: context);
                                                  Get.snackbar(
                                                    'error'.tr,
                                                    '${jsonDecode(result.body)['error']['message']}',
                                                  );
                                                }

                                                // Get.to(() => TransferAccountDetails(
                                                //       name: activityTransferListRes![
                                                //                   index]
                                                //               .name ??
                                                //           "NA",
                                                //       number:
                                                //           activityTransferListRes![
                                                //                   index]
                                                //               .cellnumber
                                                //               .toString(),
                                                //       accountId:
                                                //           activityTransferListRes![
                                                //                   index]
                                                //               .roleId
                                                //               .toString(),
                                                //     ));
                                              },
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor:
                                                        ColorsUtils.lightYellow,
                                                    child: Icon(Icons.person,
                                                        color:
                                                            ColorsUtils.yellow,
                                                        size: 32),
                                                  ),
                                                  height10(),
                                                  customVerySmallSemiText(
                                                      title: activityTransferListRes![
                                                                      index]
                                                                  .name ==
                                                              null
                                                          ? '+974-${activityTransferListRes![index].cellnumber}'
                                                          : activityTransferListRes![
                                                                      index]
                                                                  .name ??
                                                              "NA")
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      customMediumLargeSemiText(
                                          title: 'Last Transfer'),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => LastTransferScreen());
                                        },
                                        child: customMediumSemiText(
                                            title: 'View All',
                                            color: ColorsUtils.accent),
                                      ),
                                      width10(),
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => LastTransferScreen());
                                        },
                                        child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: ColorsUtils.accent,
                                            size: 20),
                                      )
                                    ],
                                  ),
                                ),
                                height30(),
                                GetBuilder<TransferViewModel>(
                                  builder: (controller) {
                                    if (controller.lastTransferListApiResponse
                                                .status ==
                                            Status.LOADING ||
                                        controller.lastTransferListApiResponse
                                                .status ==
                                            Status.INITIAL) {
                                      return Loader();
                                    }
                                    if (controller.lastTransferListApiResponse
                                            .status ==
                                        Status.ERROR) {
                                      // return Text('Error');
                                      return SessionExpire();
                                    }
                                    lastRes = controller
                                        .lastTransferListApiResponse.data;

                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: lastRes!.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        // dataShow(index);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: InkWell(
                                            onTap: () {
                                              if (lastRes![index]
                                                      .invoicenumber !=
                                                  null) {
                                                Get.to(() =>
                                                    ActivityTransactionDetailScreen(
                                                      id: lastRes![index]
                                                          .invoicenumber
                                                          .toString(),
                                                    ));
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor:
                                                          ColorsUtils
                                                              .lightYellow,
                                                      child: Icon(Icons.person,
                                                          color: ColorsUtils
                                                              .yellow,
                                                          size: 32),
                                                    ),
                                                    width20(),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    customSmallMedBoldText(
                                                                        title:
                                                                            '${lastRes![index].receiverId != null ? lastRes![index].receiverId!.id.toString() == userId ? lastRes![index].senderId!.name == null ? '+${lastRes![index].senderId!.cellnumber ?? "NA"}' : lastRes![index].senderId!.name : lastRes![index].receiverId!.name == null ? '+${lastRes![index].receiverId!.cellnumber ?? "NA"}' : lastRes![index].receiverId!.name ?? "NA" : lastRes![index].senderId!.name == null ? '+${lastRes![index].senderId!.cellnumber ?? "NA"}' : lastRes![index].senderId!.name}'),
                                                              ),
                                                              customSmallMedSemiText(
                                                                  color: lastRes![index]
                                                                              .receiverId ==
                                                                          null
                                                                      ? ColorsUtils
                                                                          .green
                                                                      : lastRes![index].receiverId!.id.toString() ==
                                                                              userId
                                                                          ? ColorsUtils
                                                                              .green
                                                                          : ColorsUtils
                                                                              .red,
                                                                  title: lastRes![index]
                                                                              .receiverId ==
                                                                          null
                                                                      ? '+ ${lastRes![index].amount ?? 0} QAR'
                                                                      : '${(lastRes![index].receiverId!.id.toString() == userId ? '+ ' : '- ') + '${lastRes![index].amount ?? 0}'} QAR')
                                                            ],
                                                          ),
                                                          height10(),
                                                          customSmallNorText(
                                                              title:
                                                                  // '26 Mar 2022, 11:19:39',
                                                                  lastRes![index]
                                                                              .receiverId ==
                                                                          null
                                                                      ? '${DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(lastRes![index].senderId!.created.toString()))}'
                                                                      : '${lastRes![index].receiverId!.id.toString() == userId ? DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(lastRes![index].senderId!.created.toString())) ?? "NA" : DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(lastRes![index].receiverId!.created.toString())) ?? "NA"}',
                                                              color: ColorsUtils
                                                                  .grey)
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                height20()
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: InkWell(
                            onTap: () async {
                              await Get.to(() => TransferToPayScreen());
                              // transferViewModel.transferListApiResponse =
                              //     ApiResponse.initial('Initial');
                              //
                              // await transferViewModel.transferList(
                              //     filter: '/recent-ten');
                              initData();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: ColorsUtils.tabUnselectLabel),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Images.transferImage,
                                      width: 30,
                                      height: 30,
                                    ),
                                    width30(),
                                    Expanded(
                                      // child: Column(
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.start,
                                      //   children: [
                                      child: customMediumBoldText(
                                          color: ColorsUtils.white,
                                          title: 'Transfer or pay'),
                                      // height5(),
                                      // customSmallNorText(
                                      //     color: ColorsUtils.white,
                                      //     title:
                                      //         'View Your live terminal location'),
                                      //   ],
                                      // ),
                                    ),
                                    CircleAvatar(
                                      backgroundColor: ColorsUtils.white,
                                      radius: 12,
                                      child: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: ColorsUtils.tabUnselectLabel,
                                        size: 15,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // dataShow(int index) async {
  //   amount = lastRes![index].amount.toString() ?? "0";
  //
  //   if (lastRes![index].receiverId!.id == userId) {
  //     setState(() {
  //       cell = lastRes![index].receiverId!.cellnumber ?? "NA";
  //       date = lastRes![index].receiverId!.created ?? "NA";
  //     });
  //   } else {
  //     setState(() {
  //       cell = lastRes![index].senderId!.cellnumber ?? "NA";
  //       date = lastRes![index].senderId!.created ?? "NA";
  //     });
  //   }
  // }
}
