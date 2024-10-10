// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalListResponse.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/withdrawal/activityWithdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/withdrawal/activityWithdrawalFilterScreen.dart';
import 'package:sadad_merchat_app/view/Activity/withdrawal/activityWithdrawalSearchScreen.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  GlobalKey _key = GlobalKey();

  List<String> selectedTimeZone = ['All'];
  String _range = '';
  String endDate = '';
  String startDate = '';
  int differenceDays = 0;
  String filterDate = '';
  bool isPageFirst = true;
  String token = '';
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  String searchingFilter = '';
  String filterValue = 'All';
  List selectedType = ['Withdrawal Id'];
  List<SettlementWithdrawalListResponseModel>? withdrawalRes;
  ScrollController? _scrollController;

  SettlementWithdrawalListViewModel settlementWithdrawalListViewModel =
      Get.find();

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
    return Scaffold(
      body: Column(
        children: [
          height40(),

          ///upperbar
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20),
          //   child: Row(
          //     children: [
          //       InkWell(
          //           onTap: () {
          //             Get.back();
          //           },
          //           child: const Icon(Icons.arrow_back_ios)),
          //       width20(),
          //       const Spacer(),
          //       Text('Withdrawals',
          //           style: ThemeUtils.blackBold.copyWith(
          //             fontSize: FontUtils.medLarge,
          //           )),
          //       const Spacer(),
          //       InkWell(
          //           onTap: () async {
          //             await Get.to(() => ActivitySearchWithdrawalScreen());
          //             initData();
          //           },
          //           child: Image.asset(
          //             Images.search,
          //             height: 20,
          //             width: 20,
          //           )),
          //       width20(),
          //       InkWell(
          //           onTap: () async {
          //             await Get.to(() => ActivityFilterWithdrawalScreen());
          //             initData();
          //           },
          //           child: Image.asset(Images.filter,
          //               height: 20,
          //               width: 20,
          //               color: Utility.settlementWithdrawFilterStatus != '' ||
          //                       Utility.settlementWithdrawFilterType != '' ||
          //                       Utility.settlementPayoutFilterStatus != '' ||
          //                       Utility.settlementPayoutFilterBank != ''
          //                   ? ColorsUtils.accent
          //                   : ColorsUtils.black)),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      if (isSearch == true) {
                        searchKey = '';
                        initData();
                        searchController.clear();
                      }
                      isSearch == true ? isSearch = false : Get.back();

                      setState(() {});
                    },
                    child: const Icon(Icons.arrow_back_ios)),
                width10(),
                isSearch == false
                    ? Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text('Withdrawals'.tr,
                                    style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.medLarge,
                                    )),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                isSearch = !isSearch;
                                setState(() {});
                              },
                              child: Image.asset(
                                Images.search,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            width10(),
                          ],
                        ),
                      )
                    : Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            onChanged: (value) async {
                              searchKey = value;
                              setState(() {});

                              initData(fromSearch: true);
                            },
                            controller: searchController,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(0.0),
                                isDense: true,
                                prefixIcon: Image.asset(
                                  Images.search,
                                  scale: 3,
                                ),
                                suffixIcon: searchController.text.isEmpty
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          searchController.clear();
                                          searchKey = '';
                                          searchingFilter = '';
                                          setState(() {});
                                          initData();
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
                                hintText: 'ex. ${selectedType.first}',
                                hintStyle: ThemeUtils.blackRegular.copyWith(
                                    color: ColorsUtils.grey,
                                    fontSize: FontUtils.small)),
                          ),
                        ),
                      ),
                isSearch == false ? const SizedBox() : width10(),
                InkWell(
                    onTap: () async {
                      await Get.to(() => ActivityFilterWithdrawalScreen());
                      initData();
                    },
                    child: Image.asset(Images.filter,
                        height: 20,
                        width: 20,
                        color: Utility.settlementWithdrawFilterStatus != '' ||
                                Utility.settlementWithdrawFilterType != '' ||
                                Utility.settlementPayoutFilterStatus != '' ||
                                Utility.settlementPayoutFilterBank != ''
                            ? ColorsUtils.accent
                            : ColorsUtils.black)),
              ],
            ),
          ),
          isSearch == false
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Container(
                    width: Get.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: customVerySmallBoldText(
                            title: 'Search for :'.tr,
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            runSpacing: 10,
                            direction: Axis.horizontal,
                            children: List.generate(
                                StaticData().withdrawalSearchFilter.length,
                                (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: InkWell(
                                        onTap: () async {
                                          selectedType.clear();
                                          searchKey = '';
                                          searchController.clear();
                                          selectedType.add(StaticData()
                                              .withdrawalSearchFilter[index]);
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: ColorsUtils.border,
                                                  width: 1),
                                              color: selectedType.contains(
                                                      StaticData()
                                                              .withdrawalSearchFilter[
                                                          index])
                                                  ? ColorsUtils.primary
                                                  : ColorsUtils.white),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              StaticData()
                                                  .withdrawalSearchFilter[index]
                                                  .tr,
                                              style: ThemeUtils.blackBold.copyWith(
                                                  fontSize: FontUtils.verySmall,
                                                  color: selectedType.contains(
                                                          StaticData()
                                                                  .withdrawalSearchFilter[
                                                              index])
                                                      ? ColorsUtils.white
                                                      : ColorsUtils
                                                          .tabUnselectLabel),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          height20(),

          ///time zone
          timeZone(),
          height10(),
          Divider(),
          height10(),

          ///list of data
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: GetBuilder<SettlementWithdrawalListViewModel>(
                builder: (controller) {
                  if (controller.settlementWithdrawalListApiResponse.status ==
                          Status.LOADING ||
                      controller.settlementWithdrawalListApiResponse.status ==
                          Status.INITIAL) {
                    return const Center(child: Loader());
                  }

                  if (controller.settlementWithdrawalListApiResponse.status ==
                      Status.ERROR) {
                    return const SessionExpire();
                    //return Text('something wrong');
                  }

                  withdrawalRes =
                      controller.settlementWithdrawalListApiResponse.data;

                  return (withdrawalRes!.isEmpty || withdrawalRes == null) &&
                          !settlementWithdrawalListViewModel.isPaginationLoading
                      ? noDataFound()
                      : Column(
                          key: _key,
                          children: [
                            listOfData(),
                            if (settlementWithdrawalListViewModel
                                    .isPaginationLoading &&
                                !isPageFirst)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(child: Loader()),
                              ),
                          ],
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listOfData() {
    return withdrawalRes!.isEmpty
        ? noDataFound()
        : ListView.builder(
            // controller: _scrollController,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: withdrawalRes!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => ActivityWithdrawalDetailScreen(
                            id: withdrawalRes![index].id.toString(),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorsUtils.border, width: 1),
                            ),
                            child: Image.network(
                              '${Utility.baseUrl}containers/api-banks/download/${withdrawalRes![index].userbank!.bank!.logo}',
                              headers: {HttpHeaders.authorizationHeader: token},
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          width10(),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  customSmallBoldText(
                                      title: withdrawalRes![index]
                                              .userbank!
                                              .bank!
                                              .name ??
                                          "NA"),
                                  // Icon(Icons.more_vert)
                                ],
                              ),
                              height5(),
                              Row(
                                children: [
                                  customSmallSemiText(
                                      title:
                                          'ID: ${withdrawalRes![index].withdrawnumber ?? "NA"}'),
                                  Spacer(),
                                  (withdrawalRes![index]
                                                  .withdrawaltype
                                                  .toString()
                                                  .toLowerCase() ==
                                              'manual' &&
                                          withdrawalRes![index]
                                                  .withdrawalrequeststatus!
                                                  .name ==
                                              'REQUESTED')
                                      ? InkWell(
                                          onTap: () {
                                            cancelRequestBottomSheet(
                                                context, index);
                                          },
                                          child: Icon(
                                            Icons.more_vert,
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                              height10(),
                              customSmallSemiText(
                                  title:
                                      '${DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(withdrawalRes![index].created.toString()))}',
                                  color: ColorsUtils.grey),
                              height10(),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: (withdrawalRes![index]
                                                    .withdrawalrequeststatus!
                                                    .name ==
                                                'REJECTED')
                                            ? ColorsUtils.accent
                                            : (withdrawalRes![index]
                                                        .withdrawalrequeststatus!
                                                        .name ==
                                                    'CANCELLED')
                                                ? ColorsUtils.reds
                                                : withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'REQUESTED'
                                                    ? ColorsUtils.yellow
                                                    : withdrawalRes![index]
                                                                .withdrawalrequeststatus!
                                                                .name ==
                                                            'ON HOLD'
                                                        ? ColorsUtils
                                                            .tabUnselectLabel
                                                        : ColorsUtils.green,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: Center(
                                        child: customSmallSemiText(
                                            color: ColorsUtils.white,
                                            title:
                                                '${(withdrawalRes![index].withdrawalrequeststatus!.name == 'APPROVED' ? 'ACCEPTED' : withdrawalRes![index].withdrawalrequeststatus!.name == 'IN PROGRESS' ? 'ACCEPTED' : withdrawalRes![index].withdrawalrequeststatus!.name)}'),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  // Expanded(
                                  //   child: Image.asset(
                                  //     Images.onlinePayment,
                                  //     width: 25,
                                  //     height: 25,
                                  //   ),
                                  // ),
                                  // width30(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      // width: Get.width * 0.375,
                                      child: customMediumBoldText(
                                          title:
                                              '${withdrawalRes![index].amount ?? "0"} QAR',
                                          color: ColorsUtils.accent),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  )
                ],
              );
            },
          );
  }

  Future<void> cancelRequestBottomSheet(BuildContext context, int index) {
    return showModalBottomSheet<void>(
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
                  height20(),
                  InkWell(
                    onTap: () {
                      Get.back();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text(
                                    'Are you sure you want to cancel this withdraw Request ?'
                                        .tr,
                                    style: TextStyle(fontSize: 14)),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('Cancel'.tr)),
                                  ElevatedButton(
                                      onPressed: () {
                                        cancelWithdrawAPiCall(
                                            withdrawalRes![index]
                                                .id
                                                .toString());
                                      },
                                      child: Text('Ok'.tr)),
                                ],
                              );
                              // return Dialog(
                              //   elevation: 0,
                              //
                              //   // backgroundColor: Colors.transparent,
                              //   insetPadding:
                              //       EdgeInsets.symmetric(
                              //           horizontal: 20),
                              //   shape:
                              //       RoundedRectangleBorder(
                              //           borderRadius:
                              //               BorderRadius
                              //                   .circular(
                              //                       20.0)),
                              //   child: Column(
                              //     mainAxisSize:
                              //         MainAxisSize.min,
                              //     children: [
                              //       Container(
                              //         decoration:
                              //             BoxDecoration(
                              //                 borderRadius:
                              //                     BorderRadius.circular(
                              //                         20),
                              //                 // border: Border.all(
                              //                 //   color: ColorsUtils.accent,
                              //                 //   width: 2,
                              //                 // ),
                              //                 color: ColorsUtils
                              //                     .lightPink),
                              //         child: Padding(
                              //           padding:
                              //               const EdgeInsets
                              //                   .all(20),
                              //           child: Column(
                              //             children: [
                              //               customSmallBoldText(
                              //                   title:
                              //                       'are you sure you want to cancel this withdraw request ?')
                              //             ],
                              //           ),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // );
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset(Images.delete,
                            color: ColorsUtils.black, height: 20, width: 20),
                        width10(),
                        customSmallBoldText(title: 'Cancel request'),
                      ],
                    ),
                  ),
                  height40()
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> cancelWithdrawAPiCall(String? id) async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(
      '${Utility.baseUrl}withdrawalrequests/$id',
    );
    var body = {"withdrawalrequeststatusId": "6"};
    Map<String, String> header = {'Authorization': token};
    print(url);
    print('req::${jsonEncode(body)}');
    var result = await http.patch(
      url,
      body: body,
      headers: header,
    );

    print('token is:$token }  \n response is :${result.body} ');
    if (result.statusCode == 401) {
      SessionExpire();
    }

    if (result.statusCode == 200) {
      print('hiiiii');
      Get.back();
      Get.snackbar('success', 'Withdrawal request has been cancelled!!');
      initData();
    } else {
      Get.back();

      Get.snackbar(
          'error'.tr, '${jsonDecode(result.body)['error']['message']}');
    }
  }

  Widget timeZone() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().timeZone.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 && Get.locale!.languageCode == 'en'
                ? const EdgeInsets.only(left: 20, right: 5)
                : index == StaticData().timeZone.length - 1 &&
                        Get.locale!.languageCode == 'en'
                    ? const EdgeInsets.only(right: 20, left: 5)
                    : const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedTimeZone.clear();
                startDate = '';
                endDate = '';

                selectedTimeZone.add(StaticData().timeZone[index]);
                if (selectedTimeZone.contains('Custom')) {
                  startDate = '';
                  endDate = '';

                  selectedTimeZone.clear();
                  await datePicker(context);
                  if (startDate != '' && endDate != '') {
                    selectedTimeZone.add('Custom');
                    filterDate =
                        '&filter[where][created][between][0]=$startDate&filter[where][created][between][1]=$endDate';
                    print('filter date=$filterDate');
                    initData();
                  }
                } else {
                  startDate = '';
                  endDate = '';
                  final now = DateTime.now();
                  endDate = selectedTimeZone.first == 'Yesterday'
                      ? DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
                          now.year, now.month, now.day - 1, 23, 59, 59))
                      : DateFormat('yyyy-MM-dd HH:mm:ss').format(
                          DateTime(now.year, now.month, now.day, 23, 59, 59));
                  selectedTimeZone.first == 'Today'
                      ? startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
                          DateTime(now.year, now.month, now.day, 00, 00, 00))
                      : selectedTimeZone.first == 'Yesterday'
                          ? startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
                              DateTime(
                                  now.year, now.month, now.day - 1, 00, 00, 00))
                          : selectedTimeZone.first == 'Week'
                              ? startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(
                                  now.year, now.month, now.day - 6, 00, 00, 00))
                              : selectedTimeZone.first == 'Month'
                                  ? startDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(DateTime(now.year, now.month - 1,
                                          now.day, 00, 00, 00))
                                  : selectedTimeZone.first == 'Year'
                                      ? startDate =
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(DateTime(now.year, now.month, now.day - 365, 00, 00, 00))
                                      : '';

                  filterDate = selectedTimeZone.first == 'All'
                      ? ""
                      : '&filter[where][created][between][0]=$startDate&filter[where][created][between][1]=$endDate';
                  print('filterDate::$filterDate');
                  _range = '';
                  initData();
                }
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        selectedTimeZone.contains(StaticData().timeZone[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                child: Center(
                  child: Text(
                    index == 6
                        ? _range == ''
                            ? StaticData().timeZone[index].tr
                            : '$_range'
                        : StaticData().timeZone[index].tr,
                    style: ThemeUtils.maroonSemiBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedTimeZone
                                .contains(StaticData().timeZone[index])
                            ? ColorsUtils.white
                            : ColorsUtils.tabUnselectLabel),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> datePicker(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // _range = '';
          // startDate = '';
          // endDate = '';
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorsUtils.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsUtils.border)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Select Dates'.tr,
                                style: ThemeUtils.blackBold.copyWith(
                                    color: ColorsUtils.accent,
                                    fontSize: FontUtils.medium),
                              ),
                              height20(),
                              SfDateRangePicker(
                                onSelectionChanged:
                                    (dateRangePickerSelectionChangedArgs) {
                                  if (dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          null ||
                                      dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          '') {
                                    endDate = '';
                                    _range = '';
                                  } else {
                                    if (dateRangePickerSelectionChangedArgs
                                        .value is PickerDateRange) {
                                      _range =
                                          '${DateFormat('dd MMM’ yy').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                          ' ${DateFormat('dd MMM’ yy').format(dateRangePickerSelectionChangedArgs.value.endDate)}';
                                      setState(() {});
                                    }
                                    final difference =
                                        dateRangePickerSelectionChangedArgs
                                            .value.endDate
                                            .difference(
                                                dateRangePickerSelectionChangedArgs
                                                    .value.startDate)
                                            .inDays;
                                    differenceDays =
                                        int.parse(difference.toString());
                                    print('days is :::$difference');
                                  }
                                  if (differenceDays >= 364) {
                                    Get.snackbar('warning'.tr,
                                        'Please select range in 12 month'.tr);
                                    startDate = '';
                                    endDate = '';
                                  } else {
                                    startDate = DateFormat(
                                            'yyyy-MM-dd HH:mm:ss')
                                        .format(DateTime.parse(
                                            '${dateRangePickerSelectionChangedArgs.value.startDate}'));

                                    dateRangePickerSelectionChangedArgs
                                                    .value.endDate ==
                                                null ||
                                            dateRangePickerSelectionChangedArgs
                                                    .value.endDate ==
                                                ''
                                        ? ''
                                        : endDate = DateFormat(
                                                'yyyy-MM-dd 23:59:59')
                                            .format(DateTime.parse(
                                                '${dateRangePickerSelectionChangedArgs.value.endDate}'));
                                  }

                                  setDialogState(() {});
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                maxDate: DateTime.now(),
                                initialSelectedRange: PickerDateRange(
                                    startDate == ''
                                        ? DateTime.now()
                                            .subtract(const Duration(days: 7))
                                        : DateTime.parse(startDate),
                                    endDate == ''
                                        ? DateTime.now()
                                        : DateTime.parse(endDate)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: ColorsUtils.border)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Selected Dates: '.tr,
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.verySmall),
                                      ),
                                      Text(
                                        _range,
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.verySmall),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              height20(),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: buildContainerWithoutImage(
                                          color: ColorsUtils.accent,
                                          text: 'Select'.tr),
                                    ),
                                  ),
                                  width10(),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                        // _range = '';
                                        startDate = '';
                                        endDate = '';
                                        setState(() {});
                                      },
                                      child: buildContainerWithoutImage(
                                          color: ColorsUtils.accent,
                                          text: 'Cancel'.tr),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  initData({bool fromSearch = false}) async {
    token = await encryptedSharedPreferences.getString('token');

    print('hiiii');
    String id = await encryptedSharedPreferences.getString('id');

    settlementWithdrawalListViewModel.clearResponseList();
    scrollApiData(id);

    await apiCall(id, fromSearch: fromSearch);
    print('filter Date is $filterDate');

    if (isPageFirst == true) {
      isPageFirst = false;
      setState(() {});
    }
  }

  scrollApiData(String id) {
    print('SCROLL CONTROLLER CALL==========');

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !settlementWithdrawalListViewModel.isPaginationLoading) {
          print('hiiii');
          settlementWithdrawalListViewModel.settlementWithdrawalList(
              filter: filterDate +
                  Utility.settlementWithdrawFilterType +
                  Utility.settlementPayoutFilterStatus +
                  Utility.settlementPayoutFilterBank +
                  Utility.settlementWithdrawFilterStatus +
                  ((searchKey == '' || searchKey == null)
                      ? ""
                      : selectedType.contains('Withdrawal Id')
                          ? '&filter[where][withdrawnumber][like]=%25$searchKey%'
                          : selectedType.contains('Withdrawal Amount')
                              ? '&filter[where][amount]=$searchKey'
                              : ""),
              id: id,
              isLoading: false,
              fromSearch: false);
        }
      });
  }

  apiCall(String id, {bool fromSearch = false}) async {
    ///api calling.......

    print(
        'Utility.settlementPayoutFilterStatus====${Utility.settlementPayoutFilterStatus} ');
    await settlementWithdrawalListViewModel.settlementWithdrawalList(
        filter: filterDate +
            Utility.settlementWithdrawFilterType +
            Utility.settlementPayoutFilterStatus +
            Utility.settlementPayoutFilterBank +
            Utility.settlementWithdrawFilterStatus +
            ((searchKey == '' || searchKey == null)
                ? ""
                : selectedType.contains('Withdrawal Id')
                    ? '&filter[where][withdrawnumber][like]=%25$searchKey%'
                    : selectedType.contains('Withdrawal Amount')
                        ? '&filter[where][amount]=$searchKey'
                        : ""),
        id: id,
        isLoading: true,
        fromSearch: fromSearch);
    setState(() {});
  }
}
