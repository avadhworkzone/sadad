import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/terminals/terminalDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/device/deviceViewModel.dart';

class DeviceDetailScreen extends StatefulWidget {
  final String id;
  const DeviceDetailScreen({Key? key, required this.id}) : super(key: key);
  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  DeviceViewModel deviceViewModel = Get.find();
  List<DeviceDetailResponseModel>? deviceDetailRes;
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
        print(
            'date tiem ${intl.DateFormat('dd MMM yyyy,').format(DateTime.parse('2021-12-09T00:00:00.000Z'))}');
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<DeviceViewModel>(
              builder: (controller) {
                if (controller.deviceDetailApiResponse.status ==
                    Status.LOADING) {
                  return Center(child: Loader());
                }
                if (controller.deviceDetailApiResponse.status == Status.ERROR) {
                  // return Center(child: Text('Error'));
                  return SessionExpire();
                }
                deviceDetailRes = controller.deviceDetailApiResponse.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      height40(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.arrow_back_ios)),
                          // width20(),
                          // const Spacer(),
                          Text('Device Details'.tr,
                              style: ThemeUtils.blackBold.copyWith(
                                fontSize: FontUtils.medLarge,
                              )),

                          width20()
                          // const Spacer(),
                          // InkWell(
                          //     child: Image.asset(
                          //   Images.search,
                          //   height: 20,
                          //   width: 20,
                          // )),
                          // width20(),
                          // InkWell(
                          //     child: Image.asset(
                          //   Images.filter,
                          //   height: 20,
                          //   width: 20,
                          // )),
                        ],
                      ),
                      height20(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1),
                                    color: ColorsUtils.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: Get.height * 0.225,
                                        width: Get.width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                  Images.deviceDetail,
                                                ),
                                                fit: BoxFit.fill)),
                                      ),
                                      height10(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          commonColumnField(
                                              color: ColorsUtils.black,
                                              title: 'Device Id.'.tr,
                                              value:
                                                  '${deviceDetailRes!.first.deviceId}'),
                                          const Spacer(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: deviceDetailRes!
                                                            .first
                                                            .terminal!
                                                            .isActive ==
                                                        true
                                                    ? ColorsUtils.green
                                                    : ColorsUtils.accent,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                        horizontal: 8),
                                                child: customVerySmallSemiText(
                                                    color: ColorsUtils.white,
                                                    title: deviceDetailRes!
                                                                .first
                                                                .terminal!
                                                                .isActive ==
                                                            true
                                                        ? 'Active'.tr
                                                        : 'InActive'.tr),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      commonColumnField(
                                          title: 'Device Type'.tr,
                                          color: ColorsUtils.black,
                                          value:
                                              '${deviceDetailRes!.first.devicetype ?? 'NA'}'),
                                      commonColumnField(
                                          title: 'Device Serial Number'.tr,
                                          color: ColorsUtils.black,
                                          value:
                                              '${deviceDetailRes!.first.terminal!.deviceSerialNo ?? "NA"}'),
                                      commonColumnField(
                                          title: 'Device status'.tr,
                                          color: deviceDetailRes!.first
                                                      .terminal!.isOnline ==
                                                  true
                                              ? ColorsUtils.green
                                              : ColorsUtils.red,
                                          // value: 'Offline'
                                          value:
                                              '${deviceDetailRes!.first.terminal!.isOnline == true ? 'Online' : 'Offline'}'),
                                    ],
                                  ),
                                ),
                              ),
                              height10(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1),
                                    color: ColorsUtils.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      commonColumnField(
                                          title: 'Rental Amount'.tr,
                                          color: ColorsUtils.accent,
                                          value:
                                              '${double.parse(deviceDetailRes!.first.deviceRentalAmount.toString()).toStringAsFixed(2)} QAR'),
                                      commonColumnField(
                                          title: 'Setup Fees'.tr,
                                          color: ColorsUtils.black,
                                          value:
                                              '${deviceDetailRes!.first.terminal!.installFee ?? "0"} QAR'),
                                      commonColumnFieldLtr(
                                          title: 'Rental Start Date'.tr,
                                          color: ColorsUtils.black,
                                          value: deviceDetailRes!
                                                      .first
                                                      .terminal!
                                                      .rentalStartDate ==
                                                  null
                                              ? "NA"
                                              : '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(deviceDetailRes!.first.terminal!.rentalStartDate.toString()))}'),
                                      commonColumnFieldLtr(
                                          title: 'Device Activated Date'.tr,
                                          color: ColorsUtils.black,
                                          value: deviceDetailRes!.first
                                                      .terminal!.activated ==
                                                  null
                                              ? "NA"
                                              : '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(deviceDetailRes!.first.terminal!.activated.toString()))}'),
                                    ],
                                  ),
                                ),
                              ),
                              height10(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1),
                                    color: ColorsUtils.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          deviceDetailRes!.first.terminal !=
                                                  null
                                              ? Get.to(
                                                  () => TerminalDetailScreen(
                                                        id: deviceDetailRes!
                                                            .first
                                                            .terminal!
                                                            .terminalId,
                                                      ))
                                              : SizedBox();
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            commonColumnField(
                                                title: 'Terminal ID'.tr,
                                                color: ColorsUtils.accent,
                                                value:
                                                    '${deviceDetailRes!.first.terminal!.terminalId ?? 'NA'}'),
                                            width10(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color:
                                                            ColorsUtils.black,
                                                        width: 1)),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(3),
                                                  child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      commonColumnField(
                                          title: 'Sim  Number'.tr,
                                          color: ColorsUtils.black,
                                          value:
                                              '${deviceDetailRes!.first.terminal!.simNumber ?? 'NA'}'),
                                      commonColumnField(
                                          title: 'IMEI Number'.tr,
                                          color: ColorsUtils.black,
                                          value:
                                              '${deviceDetailRes!.first.imei ?? "NA"}'),
                                    ],
                                  ),
                                ),
                              ),
                              height10(),
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1),
                                    color: ColorsUtils.white),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      commonColumnField(
                                          title:
                                              'Total Success Transaction (Amount)'
                                                  .tr,
                                          color: ColorsUtils.accent,
                                          value:
                                              '${double.parse(deviceDetailRes!.first.totalSuccessTransactionAmount.toString()).toStringAsFixed(2)} QAR'),
                                      commonColumnField(
                                          title:
                                              'Total Success Transaction (Count)'
                                                  .tr,
                                          color: ColorsUtils.black,
                                          value:
                                              '${deviceDetailRes!.first.totalSuccessTransactionCount} QAR'),
                                      commonColumnFieldLtr(
                                          title: 'Last Transaction Date'.tr,
                                          color: ColorsUtils.black,
                                          value: deviceDetailRes!.first
                                                      .lastTransactionDate ==
                                                  null
                                              ? 'NA'
                                              : '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(deviceDetailRes!.first.lastTransactionDate.toString()))}'),
                                      commonColumnField(
                                          title: 'Currency'.tr,
                                          color: ColorsUtils.black,
                                          value:
                                              '${deviceDetailRes!.first.currency ?? "NA"}'),
                                    ],
                                  ),
                                ),
                              ),
                              height20(),
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
                Get.snackbar('error', 'Please check your connection');
              }
            } else {
              Get.snackbar('error', 'Please check your connection');
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
              Get.snackbar('error', 'Please check your connection');
            }
          } else {
            Get.snackbar('error', 'Please check your connection');
          }
        },
      );
    }
  }

  void initData() async {
    await deviceViewModel.deviceDetail(id: widget.id);
  }
}
