import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/terminals/editTerminalName.dart';
import 'package:sadad_merchat_app/view/pos/terminals/terminalDeviceHistoryScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/posTransactionListScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';

class TerminalDetailScreen extends StatefulWidget {
  final String id;
  const TerminalDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<TerminalDetailScreen> createState() => _TerminalDetailScreenState();
}

class _TerminalDetailScreenState extends State<TerminalDetailScreen> {
  TerminalViewModel terminalViewModel = Get.find();
  List<TerminalDetailResponseModel>? terminalDetailRes;
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    Utility.posPaymentTerminalSelectionFilter = [];
    Utility.holdPosPaymentTerminalSelectionFilter = [];
    connectivityViewModel.startMonitoring();

    // TODO: implement initState
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<TerminalViewModel>(
              builder: (controller) {
                if (controller.terminalDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.terminalDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(
                    child: Loader(),
                  );
                }
                if (controller.terminalDetailApiResponse.status ==
                    Status.ERROR) {
                  return SessionExpire();
                  // return const Center(
                  //   child: Text('Error'),
                  // );
                }
                terminalDetailRes =
                    terminalViewModel.terminalDetailApiResponse.data;
                return terminalDetailRes == null || terminalDetailRes!.isEmpty
                    ? noDataFound()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            height60(),
                            Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: const Icon(Icons.arrow_back_ios)),
                                const Spacer(),
                                InkWell(
                                    onTap: () {
                                      bottomSheetSelectBalance(context);
                                    },
                                    child: Icon(Icons.more_vert)),
                              ],
                            ),
                            height10(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    height30(),
                                    customMediumLargeBoldText(
                                        color: ColorsUtils.black,
                                        title: 'Terminals Details'.tr),
                                    height20(),
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: ColorsUtils.white,
                                          border: Border.all(
                                              width: 1,
                                              color: ColorsUtils.border)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      customSmallSemiText(
                                                          color:
                                                              ColorsUtils.black,
                                                          title: 'Terminal ID.'
                                                              .tr),
                                                      height5(),
                                                      Row(
                                                        children: [
                                                          customMediumBoldText(
                                                              title:
                                                                  '${terminalDetailRes!.first.terminalId ?? 'NA'}'),
                                                          width15(),
                                                          // Container(
                                                          //   decoration:
                                                          //       BoxDecoration(
                                                          //     shape:
                                                          //         BoxShape.circle,
                                                          //     border: Border.all(
                                                          //         color: ColorsUtils
                                                          //             .black,
                                                          //         width: 1),
                                                          //   ),
                                                          //   child: const Padding(
                                                          //     padding:
                                                          //         EdgeInsets.all(3),
                                                          //     child: Icon(
                                                          //         Icons
                                                          //             .arrow_forward_ios_rounded,
                                                          //         size: 12),
                                                          //   ),
                                                          // )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // commonColumnField(
                                                //     color: ColorsUtils.black,
                                                //     title: 'Terminal ID.'.tr,
                                                //     value:
                                                //         '${terminalDetailRes!.first.terminalId ?? 'NA'}'),
                                                Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: terminalDetailRes!
                                                                    .first
                                                                    .isActive ==
                                                                true
                                                            ? ColorsUtils.green
                                                            : ColorsUtils
                                                                .accent),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 8,
                                                          vertical: 2),
                                                      child: customVerySmallSemiText(
                                                          color:
                                                              ColorsUtils.white,
                                                          title:
                                                              '${terminalDetailRes!.first.isActive == true ? 'Active'.tr : 'InActive'.tr ?? 'NA'}'),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title:
                                                    'Device Serial Number'.tr,
                                                value: terminalDetailRes!.first
                                                                .posdevice ==
                                                            null ||
                                                        terminalDetailRes!.first
                                                                .posdevice ==
                                                            ''
                                                    ? 'NA'
                                                    : '${terminalDetailRes!.first.posdevice!.serial ?? "NA"}'),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Device Model'.tr,
                                                value: terminalDetailRes!.first
                                                                .posdevice ==
                                                            null ||
                                                        terminalDetailRes!.first
                                                                .posdevice ==
                                                            ''
                                                    ? 'NA'
                                                    : '${terminalDetailRes!.first.posdevice!.devicetype ?? "NA"}'),
                                            Row(
                                              children: [
                                                commonColumnField(
                                                    color: ColorsUtils.black,
                                                    title: 'Terminal Name'.tr,
                                                    value:
                                                        '${terminalDetailRes!.first.name ?? "NA"}'),
                                                Spacer(),
                                                InkWell(
                                                  onTap: () async {
                                                    print(
                                                        'name is ${terminalDetailRes!.first.name} id is ${terminalDetailRes!.first.id}');
                                                    await Get.to(() => EditTerminalName(
                                                      terminalName: terminalDetailRes!.first.name,
                                                      id: terminalDetailRes!.first.id.toString(),
                                                    ));
                                                    initData();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        Images.edit,
                                                        height: 20,
                                                        color: ColorsUtils.accent,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Terminal Login Id'.tr,
                                                value:
                                                    '${terminalDetailRes!.first.loginId ?? "NA"}'),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Terminal Location'.tr,
                                                value:
                                                    '${terminalDetailRes!.first.location ?? "NA"}'),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'City'.tr,
                                                value:
                                                    '${terminalDetailRes!.first.city ?? "NA"}'),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  smallText(
                                                    title: 'Date & time'.tr,
                                                  ),
                                                  height5(),
                                                  Text(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(terminalDetailRes!.first.activated))}',
                                                    style: ThemeUtils.blackBold
                                                        .copyWith(
                                                      fontSize:
                                                          FontUtils.mediumSmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            // Directionality(
                                            //   textDirection: TextDirection.ltr,
                                            //   child: commonColumnField(
                                            //       color: ColorsUtils.black,
                                            //       title: 'Date & time'.tr,
                                            //       value:
                                            //           '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(terminalDetailRes!.first.created))}'),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    height15(),
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: ColorsUtils.white,
                                          border: Border.all(
                                              width: 1,
                                              color: ColorsUtils.border)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: InkWell(
                                          onTap: () async {
                                            ///pos transaction
                                            Utility.posDisputeTransactionStatusFilter =
                                                '';
                                            Utility.posDisputeTransactionTypeFilter =
                                                '';
                                            Utility.posPaymentTransactionStatusFilter =
                                                '';
                                            Utility.posPaymentCardEntryTypeFilter =
                                                '';
                                            Utility.posPaymentTransactionTypeFilter =
                                                '';
                                            Utility.posPaymentPaymentMethodFilter =
                                                '';
                                            Utility.posPaymentTransactionModesFilter =
                                                '';
                                            Utility.holdPosPaymentTransactionStatusFilter =
                                                '';
                                            Utility.holdPosPaymentPaymentMethodFilter =
                                                '';
                                            Utility.holdPosPaymentTransactionModesFilter =
                                                '';
                                            Utility.holdPosPaymentTransactionTypeFilter =
                                                [];
                                            Utility.holdPosPaymentCardEntryTypeFilter =
                                                '';
                                            Utility.posPaymentTerminalSelectionFilter =
                                                [];
                                            Utility.holdPosPaymentTerminalSelectionFilter =
                                                [];
                                            Utility.posPaymentTransactionTypeTerminalFilter =
                                                [];
                                            Utility.holdPosPaymentTransactionTypeTerminalFilter =
                                                [];

                                            ///
                                            await Get.to(
                                                () => PosTransactionListScreen(
                                                      terminalFilter:
                                                          terminalDetailRes!
                                                              .first.terminalId
                                                              .toString(),
                                                    ));
                                            initData();
                                          },
                                          child: Row(
                                            children: [
                                              customMediumBoldText(
                                                  title:
                                                      'View Transactions'.tr),
                                              width15(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: ColorsUtils.black,
                                                      width: 1),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(3),
                                                  child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    height15(),
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 1,
                                            color: ColorsUtils.border),
                                        color: ColorsUtils.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  smallText(
                                                    title:
                                                        'Rental Start Date'.tr,
                                                  ),
                                                  height5(),
                                                  Text(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(terminalDetailRes!.first.rentalStartDate))}',
                                                    style: ThemeUtils.blackBold
                                                        .copyWith(
                                                      fontSize:
                                                          FontUtils.mediumSmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // commonColumnField(
                                            //     color: ColorsUtils.black,
                                            //     title: 'Rental Start Date'.tr,
                                            //     value:
                                            //         '${terminalDetailRes!.first.rentalStartDate ?? "NA"}'),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Rental Amount'.tr,
                                                value: terminalDetailRes!.first
                                                                .rentalDetail ==
                                                            null ||
                                                        terminalDetailRes!.first
                                                                .rentalDetail ==
                                                            ''
                                                    ? 'NA'
                                                    : '${terminalDetailRes!.first.rentalDetail!.amount ?? "00"} QAR'),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Set Up Fees'.tr,
                                                value: terminalDetailRes!.first
                                                                .rentalDetail ==
                                                            null ||
                                                        terminalDetailRes!.first
                                                                .rentalDetail ==
                                                            ''
                                                    ? 'NA'
                                                    : '${terminalDetailRes!.first.rentalDetail!.installationFees ?? "00"} QAR'),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'SIM Number'.tr,
                                                value:
                                                    '${terminalDetailRes!.first.simNumber ?? "NA"}'),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'IMEI Number'.tr,
                                                value:
                                                    '${terminalDetailRes!.first.posdevice!.imei ?? "NA"}'),
                                            // commonColumnField(
                                            //     title: 'Device status'.tr,
                                            //     color: terminalDetailRes!
                                            //                 .first.isOnline ==
                                            //             true
                                            //         ? ColorsUtils.green
                                            //         : ColorsUtils.red,
                                            //     // value: 'Offline'
                                            //     value:
                                            //         '${terminalDetailRes!.first.isOnline == true ? 'Online' : 'Offline'}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    terminalDetailRes!.first
                                                    .terminaldevicehistory ==
                                                null ||
                                            terminalDetailRes!.first
                                                .terminaldevicehistory!.isEmpty
                                        ? SizedBox()
                                        : height15(),
                                    terminalDetailRes!.first
                                                    .terminaldevicehistory ==
                                                null ||
                                            terminalDetailRes!.first
                                                .terminaldevicehistory!.isEmpty
                                        ? SizedBox()
                                        : Container(
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: ColorsUtils.white,
                                                border: Border.all(
                                                    width: 1,
                                                    color: ColorsUtils.border)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: InkWell(
                                                onTap: () {
                                                  Get.to(() =>
                                                      TerminalDeviceDetailScreen(
                                                        id: terminalDetailRes!
                                                            .first
                                                            .posdevice!
                                                            .deviceId
                                                            .toString(),
                                                        terminaldevicehistory:
                                                            terminalDetailRes!
                                                                .first
                                                                .terminaldevicehistory!,
                                                      ));
                                                },
                                                child: Row(
                                                  children: [
                                                    customMediumBoldText(
                                                        title:
                                                            'View Terminal History'
                                                                .tr),
                                                    width15(),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: ColorsUtils
                                                                .black,
                                                            width: 1),
                                                      ),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        child: Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 12),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                    height15(),
                                    // Container(
                                    //   width: Get.width,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(15),
                                    //     border: Border.all(
                                    //         width: 1, color: ColorsUtils.border),
                                    //     color: ColorsUtils.white,
                                    //   ),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.all(15),
                                    //     child: Column(
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.start,
                                    //       children: [
                                    //         // commonColumnField(
                                    //         //     color: ColorsUtils.black,
                                    //         //     title: 'Payment Methods'.tr,
                                    //         //     value:
                                    //         //         '${terminalDetailRes!.first.paymentMethod ?? "NA"}'),
                                    //         commonColumnField(
                                    //             color: ColorsUtils.black,
                                    //             title: 'Currency'.tr,
                                    //             value:
                                    //                 '${terminalDetailRes!.first.currency ?? "NA"}'),
                                    //         commonColumnField(
                                    //             color: ColorsUtils.black,
                                    //             title: 'City'.tr,
                                    //             value:
                                    //                 '${terminalDetailRes!.first.city.toString().capitalize ?? "NA"}'),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    // height15(),
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 1,
                                            color: ColorsUtils.border),
                                        color: ColorsUtils.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Column(
                                            //   crossAxisAlignment:
                                            //       CrossAxisAlignment.start,
                                            //   children: [
                                            //     smallText(
                                            //         title:
                                            //             'Total Success Transaction(Amount)'
                                            //                 .tr),
                                            //     height5(),
                                            //     currencyText(
                                            //         double.parse(terminalDetailRes!
                                            //             .first
                                            //             .totalSuccessTransactionAmount
                                            //             .toString()),
                                            //         ThemeUtils.blackBold.copyWith(
                                            //             fontSize:
                                            //                 FontUtils.mediumSmall),
                                            //         ThemeUtils.maroonRegular.copyWith(
                                            //             fontSize:
                                            //                 FontUtils.verySmall)),
                                            //   ],
                                            // ),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title:
                                                    'Total Success Transaction (Amount)'
                                                        .tr,
                                                value:
                                                    '${oCcy.format(double.parse('${terminalDetailRes!.first.totalSuccessTransactionAmount ?? 0}'))} QAR'
                                                // '${double.parse(terminalDetailRes!.first.totalSuccessTransactionAmount.toString()).toStringAsFixed(2) ?? "0"} QAR'
                                                ),
                                            commonColumnField(
                                                color: ColorsUtils.black,
                                                title:
                                                    'Total Success Transactions (Count)'
                                                        .tr,
                                                value:
                                                    '${terminalDetailRes!.first.totalSuccessTransactionCount ?? "NA"}'),

                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  smallText(
                                                    title:
                                                        'Last Transaction Date & Time'
                                                            .tr,
                                                  ),
                                                  height5(),
                                                  Text(
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    terminalDetailRes!.first
                                                                .lastTransactionDate ==
                                                            null
                                                        ? "NA"
                                                        : '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(terminalDetailRes!.first.lastTransactionDate))}',
                                                    style: ThemeUtils.blackBold
                                                        .copyWith(
                                                      fontSize:
                                                          FontUtils.mediumSmall,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            // commonColumnField(
                                            //     color: ColorsUtils.black,
                                            //     title: 'Last Transaction Date'.tr,
                                            //     value: terminalDetailRes!.first
                                            //                 .lastTransactionDate ==
                                            //             null
                                            //         ? "NA"
                                            //         : '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(terminalDetailRes!.first.lastTransactionDate))}'),
                                            // commonColumnField(
                                            //     color: ColorsUtils.black,
                                            //     title: 'Transaction Mode'.tr,
                                            //     value: 'NA'),
                                          ],
                                        ),
                                      ),
                                    ),
                                    height20()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                setState(() {});
                initData();
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
              initData();
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

  void initData() async {
    await terminalViewModel.terminalDetail(id: widget.id);
  }

  Future<void> bottomSheetSelectBalance(
    BuildContext context,
  ) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
                  height10(),
                  const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 70,
                      height: 5,
                      child: Divider(color: ColorsUtils.border, thickness: 4),
                    ),
                  ),
                  height30(),
                  InkWell(
                    onTap: () async {
                      Get.back();
                      print(
                          'name is ${terminalDetailRes!.first.name} id is ${terminalDetailRes!.first.id}');
                      await Get.to(() => EditTerminalName(
                            terminalName: terminalDetailRes!.first.name,
                            id: terminalDetailRes!.first.id.toString(),
                          ));
                      initData();
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          Images.edit,
                          height: 20,
                        ),
                        width20(),
                        customSmallMedBoldText(title: 'Edit terminal name'.tr)
                      ],
                    ),
                  ),
                  height30(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
