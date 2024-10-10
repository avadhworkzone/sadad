import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/devices/diviceDetailScreen.dart';
import 'package:sadad_merchat_app/view/pos/devices/filterDeviceScreen.dart';
import 'package:sadad_merchat_app/viewModel/pos/device/deviceViewModel.dart';

class PosDeviceSearchScreen extends StatefulWidget {
  const PosDeviceSearchScreen({Key? key}) : super(key: key);

  @override
  State<PosDeviceSearchScreen> createState() => _PosDeviceSearchScreenState();
}

class _PosDeviceSearchScreenState extends State<PosDeviceSearchScreen> {
  int differenceDays = 0;
  bool isTabVisible = false;
  String _range = '';
  ScrollController? _scrollController;
  String startDate = '';
  String filter = '';
  String filterCount = '';
  GlobalKey _key = GlobalKey();
  String endDate = '';
  bool isPageFirst = false;
  bool isFirstTime = true;
  DeviceViewModel deviceViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<String> selectedTimeZone = ['All'];
  int selectedTab = 0;
  List<DeviceListResponseModel>? deviceListRes;
  DeviceCountResponseModel? deviceCountRes;
  String? searchKey;
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<DeviceViewModel>(
      builder: (controller) {
        if (controller.deviceListApiResponse.status == Status.LOADING ||
            controller.deviceCountApiResponse.status == Status.LOADING) {
          return Center(child: Loader());
        }
        if (controller.deviceListApiResponse.status == Status.ERROR ||
            controller.deviceCountApiResponse.status == Status.ERROR) {
          // return Center(child: Text('Error'));
          return SessionExpire();
        }
        deviceListRes = deviceViewModel.deviceListApiResponse.data;
        deviceCountRes = deviceViewModel.deviceCountApiResponse.data;
        return Column(
          children: [
            height40(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (value) async {
                          isFirstTime = false;
                          searchKey = value;
                          setState(() {});
                        },
                        controller: search,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(0.0),
                            isDense: true,
                            prefixIcon: Image.asset(
                              Images.search,
                              scale: 3,
                            ),
                            suffixIcon: search.text.isEmpty
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () {
                                      search.clear();
                                    },
                                    child: const Icon(
                                      Icons.cancel_rounded,
                                      color: ColorsUtils.border,
                                      size: 25,
                                    ),
                                  ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: ColorsUtils.border, width: 1)),
                            hintText: 'ex. device Id...'.tr,
                            hintStyle: ThemeUtils.blackRegular.copyWith(
                                color: ColorsUtils.grey,
                                fontSize: FontUtils.small)),
                      ),
                    ),
                  ),
                  search.text.isEmpty ? const SizedBox() : width10(),
                  search.text.isEmpty
                      ? SizedBox()
                      : InkWell(
                          onTap: () async {
                            await Get.to(() => DeviceFilterScreen());
                            initData(isLoading: true);
                          },
                          child: Image.asset(
                            Images.filter,
                            height: 20,
                            width: 20,
                            color: Utility.deviceFilterCountDeviceStatus
                                        .isNotEmpty ||
                                    Utility
                                        .deviceFilterCountDeviceType.isNotEmpty
                                ? ColorsUtils.accent
                                : ColorsUtils.black,
                          )),
                ],
              ),
            ),
            search.text.isEmpty
                ? Expanded(
                    child: Center(
                        child: Text(
                            isFirstTime == false ? 'No data found'.tr : '')))
                : Expanded(
                    child: Column(
                      children: [
                        height40(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: customSmallSemiText(
                                color: ColorsUtils.black,
                                title:
                                    // '${deviceCountRes!.count ?? "NA"} ${'Devices'.tr}'),
                                    '${getCount(deviceListRes)} ${'Devices'.tr}'),
                          ),
                        ),
                        height30(),
                        deviceListRes!.isEmpty &&
                                !deviceViewModel.isPaginationLoading
                            ? Center(child: Text('No data found'.tr))
                            : Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: deviceListRes!.length,
                                  itemBuilder: (context, index) {
                                    if (searchKey != null && searchKey != "") {
                                      if (deviceListRes![index]
                                          .deviceId
                                          .toString()
                                          .toLowerCase()
                                          .contains(searchKey!.toLowerCase())) {
                                        return Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.to(() => DeviceDetailScreen(
                                                      id: deviceListRes![index]
                                                          .deviceId
                                                          .toString(),
                                                    ));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: Get.height * 0.1,
                                                      width: Get.width * 0.2,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  Images
                                                                      .device))),
                                                    ),
                                                    width10(),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              customSmallMedBoldText(
                                                                  color:
                                                                      ColorsUtils
                                                                          .black,
                                                                  title: "Device ID"
                                                                          .tr +
                                                                      ": ${deviceListRes![index].deviceId}"),
                                                              Spacer(),
                                                              Icon(Icons
                                                                  .more_vert),
                                                            ],
                                                          ),
                                                          height5(),
                                                          customSmallSemiText(
                                                              title:
                                                                  '${deviceListRes![index].devicetype ?? "NA"}',
                                                              color: ColorsUtils
                                                                  .black),
                                                          height10(),
                                                          Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .ltr,
                                                            child: customSmallSemiText(
                                                                title: intl.DateFormat(
                                                                        'dd MMM yyyy, HH:mm:ss')
                                                                    .format(DateTime.parse(deviceListRes![
                                                                            index]
                                                                        .created
                                                                        .toString())),
                                                                color:
                                                                    ColorsUtils
                                                                        .grey),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: customVerySmallSemiText(
                                                                color:
                                                                    ColorsUtils
                                                                        .black,
                                                                title:
                                                                    'Rental Amount'
                                                                        .tr),
                                                          ),
                                                          height10(),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: deviceListRes![index]
                                                                              .terminal!
                                                                              .isActive ==
                                                                          true
                                                                      ? ColorsUtils
                                                                          .green
                                                                      : ColorsUtils
                                                                          .accent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2,
                                                                      horizontal:
                                                                          8),
                                                                  child: customVerySmallSemiText(
                                                                      color: ColorsUtils
                                                                          .white,
                                                                      title: deviceListRes![index].terminal!.isActive ==
                                                                              true
                                                                          ? 'Active'
                                                                              .tr
                                                                          : 'InActive'
                                                                              .tr),
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              customSmallMedBoldText(
                                                                  title:
                                                                      '${double.parse(deviceListRes![index].deviceRentalAmount.toString()).toStringAsFixed(2)} QAR',
                                                                  color:
                                                                      ColorsUtils
                                                                          .accent)
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Divider(),
                                            )
                                          ],
                                        );
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                    return SizedBox();
                                  },
                                ),
                              ),
                        if (controller.isPaginationLoading && isPageFirst)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: Center(child: Loader()),
                          ),
                        if (controller.isPaginationLoading && !isPageFirst)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            child: Center(child: Loader()),
                          ),
                      ],
                    ),
                  ),
          ],
        );
      },
    ));
  }

  int getCount(List<DeviceListResponseModel>? result) {
    int count = 0;
    result!.forEach((e) {
      if ((e.deviceId as String)
          .toLowerCase()
          .contains(searchKey!.toLowerCase())) {
        count++;
      }
    });
    return count;
  }

  void initData({bool isLoading = false}) async {
    filterCount = (Utility.deviceFilterCountDeviceStatus.isNotEmpty ||
                Utility.deviceFilterCountDeviceType.isNotEmpty
            ? "?filter"
            : "") +
        Utility.deviceFilterCountDeviceStatus +
        Utility.deviceFilterCountDeviceType;
    filter = Utility.deviceFilterDeviceStatus + Utility.deviceFilterDeviceType;
    deviceViewModel.clearResponseList();
    scrollData();
    await deviceViewModel.deviceList(filter: filter, isLoading: isLoading);
    await deviceViewModel.deviceCount(filter: filterCount);
    if (isPageFirst == false) {
      isPageFirst = true;
    }
  }

  void scrollData() async {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !deviceViewModel.isPaginationLoading) {
          deviceViewModel.deviceList(filter: filter, isLoading: false);
          // deviceViewModel.deviceCount(filter: filterCount);
        }
      });
  }
}
