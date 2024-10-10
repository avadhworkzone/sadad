import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';

class ActivityPosRentalTransactionScreen extends StatefulWidget {
  final String? id;
  const ActivityPosRentalTransactionScreen({Key? key, this.id})
      : super(key: key);

  @override
  State<ActivityPosRentalTransactionScreen> createState() =>
      _PosRentalTransactionScreenState();
}

class _PosRentalTransactionScreenState
    extends State<ActivityPosRentalTransactionScreen> {
  PosTransactionViewModel posTransactionViewModel = Get.find();
  PosRentalDetailResponseModel? rentalDetailRes;
  ConnectivityViewModel connectivityViewModel = Get.find();
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<PosTransactionViewModel>(
              builder: (controller) {
                if (controller.activityPosRentalDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.activityPosRentalDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(
                    child: Loader(),
                  );
                }
                if (controller.activityPosRentalDetailApiResponse.status ==
                    Status.ERROR) {
                  // return const Center(
                  //   child: Text('Error'),
                  // );
                  return SessionExpire();
                }
                rentalDetailRes = posTransactionViewModel
                    .activityPosRentalDetailApiResponse.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height40(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      height40(),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customMediumLargeBoldText(
                                color: ColorsUtils.black,
                                title: 'PosRental Details'.tr),
                            height20(),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: Get.height * 0.05,
                                                width: Get.width * 0.12,
                                                decoration: BoxDecoration(
                                                  color: ColorsUtils
                                                      .createInvoiceContainer,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                    child: Image.asset(
                                                        Images.posAccent,
                                                        height: 20,
                                                        width: 20)),
                                              ),
                                              height10(),
                                              customVerySmallSemiText(
                                                  title: 'Invoice No.'.tr,
                                                  color: ColorsUtils.black),
                                            ],
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: commonTextBox(
                                                title:
                                                    '${rentalDetailRes!.invoices!.first.invoicestatus!.name ?? "NA"}',
                                                color: ColorsUtils.green),
                                          )
                                        ],
                                      ),
                                      height10(),
                                      customMediumLargeBoldText(
                                          color: ColorsUtils.black,
                                          title:
                                              '${rentalDetailRes!.invoices!.first.invoiceno ?? "NA"}'),
                                      height10(),
                                      customSmallSemiText(
                                          color: ColorsUtils.black,
                                          title: 'Pos Rental'.tr),
                                      height10(),
                                      customSmallSemiText(
                                          color: ColorsUtils.grey,
                                          title: DateFormat(
                                                  'dd MMM yyyy, HH:mm:ss')
                                              .format(DateTime.parse(
                                                  rentalDetailRes!
                                                      .invoices!.first.created
                                                      .toString()))),
                                    ]),
                              ),
                            ),
                            height10(),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customSmallMedBoldText(
                                        title: 'Description'.tr,
                                        color: ColorsUtils.black),
                                    height5(),
                                    customSmallSemiText(
                                        color: ColorsUtils.black,
                                        title:
                                            '${rentalDetailRes!.invoices!.first.remarks ?? "NA"}')
                                  ],
                                ),
                              ),
                            ),
                            height30(),
                            customSmallMedBoldText(
                                color: ColorsUtils.black,
                                title:
                                    'We have charged the rental amount for following terminals.'
                                        .tr),
                            height30(),
                            rentalDetailRes!.invoices!.first.invoiceSummery ==
                                    null
                                ? noDataFound()
                                : ListView.builder(
                                    itemCount: rentalDetailRes!
                                        .invoices!.first.invoiceSummery!.length,
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Container(
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              color: ColorsUtils.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: ColorsUtils.border,
                                                  width: 1)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                commonTerminalChargeRow(
                                                    title: 'Device Type'.tr,
                                                    value:
                                                        '${rentalDetailRes!.invoices!.first.invoiceSummery![index].devicetype == '1' ? 'WPOS-3' : rentalDetailRes!.invoices!.first.invoiceSummery![index].devicetype == '2' ? 'WPOS-QT' : rentalDetailRes!.invoices!.first.invoiceSummery![index].devicetype}'),
                                                // '${rentalDetailRes!.invoices!.first.recurringposrentals![index].terminal!.devicetype!.name ?? 'NA'}'),
                                                commonTerminalChargeRow(
                                                    title: 'Quantities'.tr,
                                                    value: '1'),
                                                commonTerminalChargeRow(
                                                    title: 'Setup fees'.tr,
                                                    value:
                                                        '${rentalDetailRes!.invoices!.first.invoiceSummery![index].installationFees ?? '0'}'),
                                                commonTerminalChargeRow(
                                                    title: 'Rental amount'.tr,
                                                    value:
                                                        // '${rentalDetailRes!.invoices!.first.recurringposrentals![index].amount ?? '0'}'),
                                                        '${rentalDetailRes!.invoices!.first.invoiceSummery![index].amount ?? "0"}'),
                                                commonTerminalChargeRow(
                                                    title:
                                                        'Additional amount'.tr,
                                                    value:
                                                        '${rentalDetailRes!.invoices!.first.invoiceSummery![index].additionalCharges ?? '0'} QAR'),
                                                Row(
                                                  children: [
                                                    customSmallSemiText(
                                                        title: 'Sub Total'.tr,
                                                        color:
                                                            ColorsUtils.black),
                                                    const Spacer(),
                                                    customSmallSemiText(
                                                        title:
                                                            '${((double.parse(rentalDetailRes!.invoices!.first.invoiceSummery![index].additionalCharges.toString())) + double.parse((rentalDetailRes!.invoices!.first.invoiceSummery![index].amount.toString())) + double.parse((rentalDetailRes!.invoices!.first.invoiceSummery![index].installationFees.toString())))} QAR',
                                                        color:
                                                            ColorsUtils.accent)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            height30(),
                          ],
                        ),
                      ))
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

  Center noDataFound() => Center(child: Text('No data found'.tr));

  Column commonTerminalChargeRow({String? title, String? value}) {
    return Column(
      children: [
        Row(
          children: [
            customSmallSemiText(title: title, color: ColorsUtils.black),
            const Spacer(),
            customSmallSemiText(title: value, color: ColorsUtils.black)
          ],
        ),
        dividerData()
      ],
    );
  }

  void initData() async {
    await posTransactionViewModel.activityRentalDetail(
      id: widget.id,
    );
  }
}
