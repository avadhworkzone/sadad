import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/device/deviceViewModel.dart';

import '../../../model/apimodels/responseModel/posModule/terminal/terminalDetailResponseModel.dart';

class TerminalDeviceDetailScreen extends StatefulWidget {
  final String id;
  final List<Terminaldevicehistory> terminaldevicehistory;
  const TerminalDeviceDetailScreen(
      {Key? key, required this.id, required this.terminaldevicehistory})
      : super(key: key);
  @override
  State<TerminalDeviceDetailScreen> createState() =>
      _TerminalDeviceDetailScreenState();
}

class _TerminalDeviceDetailScreenState
    extends State<TerminalDeviceDetailScreen> {
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      height60(),
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
                          Text('Terminal History'.tr,
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
                          child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.terminaldevicehistory.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: ColorsUtils.border, width: 1),
                                color: ColorsUtils.white),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: CircleAvatar(
                                        backgroundColor: ColorsUtils.accent,
                                        radius: 20,
                                        child: customMediumBoldText(
                                            title: (index + 1).toString(),
                                            color: ColorsUtils.white)),
                                  ),
                                  height20(),
                                  Container(
                                    height: Get.height * 0.25,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color:
                                              ColorsUtils.grey.withOpacity(0.3), width: 1),
                                    ),
                                    child: Image.asset(widget.terminaldevicehistory[index].deviceTypeId == 1 ? Images.deviceBlank : Images.WPOSQTBlank, fit: BoxFit.cover),
                                  ),

                                  height10(),
                                  // Container(
                                  //   height: Get.height * 0.225,
                                  //   width: Get.width,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius:
                                  //           BorderRadius.circular(12),
                                  //       image: const DecorationImage(
                                  //           image: AssetImage(
                                  //             Images.deviceDetail,
                                  //           ),
                                  //           fit: BoxFit.fill)),
                                  // ),
                                  // height10(),
                                  commonColumnField(
                                      color: ColorsUtils.black,
                                      title: 'Device Serial Number'.tr,
                                      value:
                                          '${widget.terminaldevicehistory[index].deviceSerialNo ?? 'NA'}'),
                                  commonColumnField(
                                      color: ColorsUtils.black,
                                      title: 'Device Activation Date'.tr,
                                      value: widget.terminaldevicehistory[index]
                                                  .deviceActivationDate ==
                                              null
                                          ? 'NA'
                                          : '${intl.DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(widget.terminaldevicehistory[index].deviceActivationDate.toString())) ?? "NA"}'),
                                  commonColumnField(
                                      title: 'Device Deactivation Date'.tr,
                                      color: ColorsUtils.black,
                                      value: widget.terminaldevicehistory[index]
                                                  .deviceDeactivationDate ==
                                              null
                                          ? 'NA'
                                          : '${intl.DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(widget.terminaldevicehistory[index].deviceDeactivationDate.toString())) ?? "NA"}'),

                                  commonColumnField(
                                      title: 'Device Type/model'.tr,
                                      color: ColorsUtils.black,
                                      value: widget.terminaldevicehistory[index]
                                                      .deviceTypeId ==
                                                  1
                                              ? 'WPOS-3'
                                              : 'WPOS-QT'),
                                  // '${devicetype ?? "NA"}'),
                                  commonColumnField(
                                      title: 'Rental Start Date'.tr,
                                      color: ColorsUtils.black,
                                      value: widget.terminaldevicehistory[index]
                                                  .rentalStartDate ==
                                              null
                                          ? 'NA'
                                          : '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.terminaldevicehistory[index].rentalStartDate.toString())) ?? "NA"}'),
                                  commonColumnField(
                                      title: 'Sim Number'.tr,
                                      color: ColorsUtils.black,
                                      value:
                                          '${widget.terminaldevicehistory[index].simNumber ?? "NA"}'),
                                  commonColumnField(
                                      title: 'Device Rental Amount'.tr,
                                      //color: ColorsUtils.accent,
                                      value: widget.terminaldevicehistory[index]
                                                  .deviceRentalAmount ==
                                              null
                                          ? 'NA'
                                          : '${double.parse(widget.terminaldevicehistory[index].deviceRentalAmount.toString()).toStringAsFixed(2)} QAR'),
                                  commonColumnField(
                                      title: 'IMEI Number'.tr,
                                      color: ColorsUtils.black,
                                      value:
                                          '${widget.terminaldevicehistory[index].imeiNumber ?? "NA"}'),
                                  commonColumnField(
                                      title: 'Setup Fees'.tr,
                                      color: ColorsUtils.black,
                                      value:
                                          '${widget.terminaldevicehistory[index].setupFees ?? "0"} QAR'),
                                ],
                              ),
                            ),
                          );
                        },
                      )),
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
