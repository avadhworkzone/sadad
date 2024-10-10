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
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/devices/diviceDetailScreen.dart';
import 'package:sadad_merchat_app/view/pos/devices/filterDeviceScreen.dart';
import 'package:sadad_merchat_app/viewModel/pos/device/deviceViewModel.dart';
import 'package:http/http.dart' as http;

class PosDeviceSearchReport extends StatefulWidget {
  String? startDate;
  String? endDate;
  String? selectedType;
  PosDeviceSearchReport(
      {Key? key, this.endDate, this.selectedType, this.startDate})
      : super(key: key);

  @override
  State<PosDeviceSearchReport> createState() => _PosDeviceSearchReportState();
}

class _PosDeviceSearchReportState extends State<PosDeviceSearchReport> {
  int differenceDays = 0;
  bool isTabVisible = false;
  String email = '';
  String _range = '';
  bool sendEmail = false;
  int isRadioSelected = 0;
  ScrollController? _scrollController;
  String startDate = '';
  String filter = '';
  String filterCount = '';
  GlobalKey _key = GlobalKey();
  String endDate = '';
  bool isPageFirst = false;
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
    deviceViewModel.setDeviceInit();
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
            controller.deviceListApiResponse.status == Status.INITIAL ||
            controller.deviceCountApiResponse.status == Status.INITIAL ||
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
            height60(),
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
                            hintText:
                                'ex. customer name,phone,invoice no,amount,id......'
                                    .tr,
                            hintStyle: ThemeUtils.blackRegular.copyWith(
                                color: ColorsUtils.grey,
                                fontSize: FontUtils.small)),
                      ),
                    ),
                  ),
                  search.text.isEmpty ? const SizedBox() : width10(),
                  search.text.isEmpty
                      ? const SizedBox()
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
                ? Expanded(child: Center(child: Text('No data found'.tr)))
                : Expanded(
                    child: Column(
                      children: [
                        height20(),
                        Container(
                            height: 1,
                            width: Get.width,
                            color: ColorsUtils.border),
                        SizedBox(
                          height: Get.height * 0.08,
                          width: Get.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              width20(),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customSmallBoldText(title: 'From'.tr),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: customSmallSemiText(
                                          title:
                                              '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.startDate!))}'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customSmallBoldText(title: 'To'.tr),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: customSmallSemiText(
                                          title:
                                              '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.endDate!))}'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    deviceListRes!.isEmpty
                                        ? Get.showSnackbar(GetSnackBar(
                                            message: 'No Data Found'.tr,
                                          ))
                                        : exportBottomSheet();
                                  },
                                  child: Container(
                                    color: ColorsUtils.accent,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            Images.download,
                                            height: 20,
                                          ),
                                          Text(
                                            'Download'.tr,
                                            style: ThemeUtils.blackSemiBold
                                                .copyWith(
                                                    fontSize: FontUtils.small,
                                                    color: ColorsUtils.white),
                                          )
                                        ]),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            height: 1,
                            width: Get.width,
                            color: ColorsUtils.border),
                        height40(),
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: customSmallSemiText(
                                      color: ColorsUtils.black,
                                      title:
                                          '${deviceCountRes!.count ?? "NA"} ${'Devices'.tr}'),
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
                                          if (searchKey != null &&
                                              searchKey != "") {
                                            if (deviceListRes![index]
                                                .deviceId
                                                .toString()
                                                .toLowerCase()
                                                .contains(
                                                    searchKey!.toLowerCase())) {
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          DeviceDetailScreen(
                                                            id: deviceListRes![
                                                                    index]
                                                                .deviceId
                                                                .toString(),
                                                          ));
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20,
                                                          vertical: 5),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: Get.height *
                                                                0.1,
                                                            width:
                                                                Get.width * 0.2,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
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
                                                                customSmallMedBoldText(
                                                                    color: ColorsUtils
                                                                        .black,
                                                                    title:
                                                                        'Device ID: ${deviceListRes![index].deviceId}'),
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
                                                                      title: intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(deviceListRes![
                                                                              index]
                                                                          .created
                                                                          .toString())),
                                                                      color: ColorsUtils
                                                                          .grey),
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: customVerySmallSemiText(
                                                                      color: ColorsUtils
                                                                          .black,
                                                                      title: 'Rental Amount'
                                                                          .tr),
                                                                ),
                                                                height10(),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: deviceListRes![index].terminal!.isActive ==
                                                                                true
                                                                            ? ColorsUtils.green
                                                                            : ColorsUtils.accent,
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                2,
                                                                            horizontal:
                                                                                8),
                                                                        child: customVerySmallSemiText(
                                                                            color: ColorsUtils
                                                                                .white,
                                                                            title: deviceListRes![index].terminal!.isActive == true
                                                                                ? 'Active'.tr
                                                                                : 'InActive'.tr),
                                                                      ),
                                                                    ),
                                                                    Spacer(),
                                                                    customSmallMedBoldText(
                                                                        title:
                                                                            '${double.parse(deviceListRes![index].deviceRentalAmount.toString()).toStringAsFixed(2)} QAR',
                                                                        color: ColorsUtils
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
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
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
                              if (controller.isPaginationLoading &&
                                  !isPageFirst)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 0),
                                  child: Center(child: Loader()),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        );
      },
    ));
  }

  void initData({bool isLoading = false}) async {
    email = await encryptedSharedPreferences.getString('email');
    filterCount =
        '?filter[date]=custom&filter[between]=["${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}", "${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.endDate!))}"]'
            // (Utility.deviceFilterCountDeviceStatus.isNotEmpty ||
            //         Utility.deviceFilterCountDeviceType.isNotEmpty
            //     ? "?filter"
            //     : "")
            +
            Utility.deviceFilterCountDeviceStatus +
            Utility.deviceFilterCountDeviceType;

    filter = Utility.deviceFilterDeviceStatus +
        Utility.deviceFilterDeviceType +
        '&filter[date]=custom&filter[between]=["${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}", "${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.endDate!))}"]';
    deviceViewModel.clearResponseList();
    scrollData();
    await deviceViewModel.deviceList(filter: filter, isLoading: isLoading);
    await deviceViewModel.deviceCount(filter: filterCount);
    if (isPageFirst == false) {
      isPageFirst = true;
    }
  }

  void exportBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 70,
                        height: 5,
                        child: Divider(color: ColorsUtils.border, thickness: 4),
                      ),
                    ),
                  ),
                  Text(
                    'Download Options'.tr,
                    style: ThemeUtils.blackBold.copyWith(
                      fontSize: FontUtils.medLarge,
                    ),
                  ),
                  height30(),
                  Text(
                    'Select Format'.tr,
                    style: ThemeUtils.blackSemiBold.copyWith(
                      fontSize: FontUtils.medium,
                    ),
                  ),
                  Column(
                    children: [
                      LabeledRadio(
                        label: 'PDF',
                        value: 1,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          setState(() {
                            isRadioSelected = newValue;
                          });
                        },
                      ),
                      LabeledRadio(
                        label: 'CSV',
                        value: 2,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          setState(() {
                            print('hi');
                            isRadioSelected = newValue;
                          });
                        },
                      ),
                      LabeledRadio(
                        label: 'XLS',
                        value: 3,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          setState(() {
                            isRadioSelected = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  height20(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          sendEmail = !sendEmail;
                          setState(() {});
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorsUtils.black, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: sendEmail == true
                              ? Center(
                                  child: Image.asset(Images.check,
                                      height: 10, width: 10))
                              : SizedBox(),
                        ),
                      ),
                      width20(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Send Email to'.tr,
                              style: ThemeUtils.blackBold.copyWith(
                                fontSize: FontUtils.verySmall,
                              ),
                            ),
                            Text(
                              email,
                              style: ThemeUtils.blackRegular.copyWith(
                                fontSize: FontUtils.verySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  height30(),
                  InkWell(
                    onTap: () async {
                      if (isRadioSelected == 0) {
                        Get.snackbar('error', 'Please select Format!'.tr);
                      } else {
                        if (sendEmail == true) {
                          String token = await encryptedSharedPreferences
                              .getString('token');
                          final url = Uri.parse(
                            '${Utility.baseUrl}reporthistories/${widget.selectedType}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
                          );
                          Map<String, String> header = {
                            'Authorization': token,
                            'Content-Type': 'application/json'
                          };
                          var result = await http.get(
                            url,
                            headers: header,
                          );
                          print(
                              'token is:$token \n req is : ${result.request}  \n response is :${result.body} ');
                          if (result.statusCode == 200) {
                            Get.snackbar('Success'.tr, 'send successfully'.tr);
                          } else {
                            // const SessionExpire();
                            Get.snackbar('error'.tr, 'something Wrong'.tr);
                          }
                        } else {
                          await downloadFile(
                            isEmail: sendEmail,
                            isRadioSelected: isRadioSelected,
                            url:
                                '${Utility.baseUrl}reporthistories/${widget.selectedType}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
                            context: context,
                          );
                        }
                      }
                    },
                    child: commonButtonBox(
                        color: ColorsUtils.accent,
                        text: 'DownLoad'.tr,
                        img: Images.download),
                  ),
                  height30(),
                ],
              ),
            );
          });
        },
        backgroundColor: ColorsUtils.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))));
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
