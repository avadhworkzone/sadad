import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlemetPayoutListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/get_storage_permission.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/settlement/filterSettlementScreen.dart';
import 'package:sadad_merchat_app/view/settlement/settlementPayoutDetailScreen.dart';
import 'package:sadad_merchat_app/view/settlement/withdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';
import 'package:http/http.dart' as http;

class SearchSettlementScreen extends StatefulWidget {
  final String? startDate;
  final String? endDate;
  final int? tab;
  const SearchSettlementScreen(
      {Key? key, this.startDate, this.endDate, this.tab})
      : super(key: key);

  @override
  State<SearchSettlementScreen> createState() => _SearchSettlementScreenState();
}

class _SearchSettlementScreenState extends State<SearchSettlementScreen>
    with TickerProviderStateMixin {
  List<SettlementWithdrawalListResponseModel>? withdrawalRes;
  List<SettlementPayoutListResponseModel>? payoutRes;
  late TabController tabController;
  ScrollController? _scrollController;
  String filterDate = '';
  bool isPageFirst = true;
  int selectedTab = 0;
  String token = '';
  String email = '';
  int isRadioSelected = 0;
  bool sendEmail = false;
  SettlementWithdrawalListViewModel settlementWithdrawalListViewModel =
      Get.find();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
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

  String? searchKey;
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                                    search.text = '';
                                    setState(() {});
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
                          hintText: widget.tab == 0
                              ? "ex. withdrawal ID, bank name..."
                              : 'ex. payout ID, bank name...',
                          hintStyle: ThemeUtils.blackRegular.copyWith(
                              color: ColorsUtils.grey,
                              fontSize: FontUtils.small)),
                    ),
                  ),
                ),
                width20(),
                search.text.isEmpty
                    ? SizedBox()
                    : InkWell(
                        onTap: () async {
                          await Get.to(() => FilterSettlementScreen(
                                tab: selectedTab,
                              ));
                          initData();
                        },
                        child: Image.asset(Images.filter,
                            height: 20,
                            color: Utility.settlementWithdrawFilterStatus !=
                                        '' ||
                                    Utility.settlementWithdrawFilterType != ''
                                ? ColorsUtils.accent
                                : ColorsUtils.black),
                      ),
              ],
            ),
          ),
          height10(),
          search.text.isEmpty
              ? Expanded(child: Center(child: Text('No data found'.tr)))
              : Expanded(
                  child: Column(
                    children: [
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
                                  smallBoldText(text: 'From'.tr),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: smallSemiBoldText(
                                        text:
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
                                  smallBoldText(text: 'To'.tr),
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: smallSemiBoldText(
                                        text:
                                            '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.endDate!))}'),
                                  ),
                                ],
                              ),
                            ),
                            width50(),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  print('hji');
                                  if (selectedTab == 0) {
                                    withdrawalRes!.isEmpty
                                        ? Get.showSnackbar(GetSnackBar(
                                            message: 'No Data Found'.tr,
                                          ))
                                        : exportBottomSheet();
                                  } else {
                                    payoutRes!.isEmpty
                                        ? Get.showSnackbar(GetSnackBar(
                                            message: 'No Data Found'.tr,
                                          ))
                                        : exportBottomSheet();
                                  }
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
                      tabBar(),
                      height20(),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: GetBuilder<SettlementWithdrawalListViewModel>(
                            builder: (controller) {
                              if (selectedTab == 0) {
                                if (controller
                                            .settlementWithdrawalListApiResponse
                                            .status ==
                                        Status.LOADING ||
                                    controller
                                            .settlementWithdrawalListApiResponse
                                            .status ==
                                        Status.INITIAL) {
                                  return const Center(child: Loader());
                                }
                              } else {
                                if (controller.settlementPayoutListApiResponse
                                            .status ==
                                        Status.LOADING ||
                                    controller.settlementPayoutListApiResponse
                                            .status ==
                                        Status.INITIAL) {
                                  return const Center(child: Loader());
                                }
                              }

                              if (selectedTab == 0
                                  ? controller.settlementPayoutListApiResponse
                                          .status ==
                                      Status.ERROR
                                  : controller
                                          .settlementWithdrawalListApiResponse
                                          .status ==
                                      Status.ERROR) {
                                return const SessionExpire();
                                // return Text('something wrong');
                              }

                              withdrawalRes = controller
                                  .settlementWithdrawalListApiResponse.data;
                              payoutRes = controller
                                  .settlementPayoutListApiResponse.data;
                              return (selectedTab == 0
                                          ? withdrawalRes!.isEmpty
                                          : payoutRes!.isEmpty) &&
                                      !settlementWithdrawalListViewModel
                                          .isPaginationLoading
                                  ? Center(
                                      child: Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: Text('No data found'.tr),
                                    ))
                                  : Column(
                                      children: [
                                        ListOfData(),
                                        if (settlementWithdrawalListViewModel
                                                .isPaginationLoading &&
                                            isPageFirst)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Center(child: Loader()),
                                          ),
                                        if (settlementWithdrawalListViewModel
                                                .isPaginationLoading &&
                                            !isPageFirst)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
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
                )
        ],
      ),
    );
  }

  Container tabBar() {
    return Container(
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorsUtils.accent,
      ),
      child: TabBar(
        controller: tabController,
        indicatorColor: ColorsUtils.white,
        onTap: (value) async {
          selectedTab = value;
          isPageFirst = true;
          setState(() {});
          initData();
        },
        padding: const EdgeInsets.symmetric(horizontal: 10),
        isScrollable: true,
        labelStyle: ThemeUtils.blackSemiBold
            .copyWith(color: ColorsUtils.white, fontSize: FontUtils.small),
        unselectedLabelColor: ColorsUtils.white,
        labelColor: ColorsUtils.white,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        tabs: [
          Tab(
            text: 'Withdrawals'.tr,
          ),
          Tab(text: 'Payouts'.tr),
        ],
      ),
    );
  }

  Text smallSemiBoldText({String? text}) {
    return Text(text!,
        style:
            ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.verySmall));
  }

  Text smallBoldText({String? text}) {
    return Text(text!,
        style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.verySmall));
  }

  void initData() async {
    token = await encryptedSharedPreferences.getString('token');

    email = await encryptedSharedPreferences.getString('email');

    String id = await encryptedSharedPreferences.getString('id');
    filterDate =
        '&filter[where][created][between][0]=${widget.startDate}&filter[where][created][between][1]=${widget.endDate}';

    apiCall(id);
    if (isPageFirst == true) {
      isPageFirst = false;
    }
    scrollApiData(id);
  }

  void scrollApiData(String id) {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !settlementWithdrawalListViewModel.isPaginationLoading) {
          selectedTab == 0
              ? settlementWithdrawalListViewModel.settlementWithdrawalList(
                  filter: filterDate +
                      Utility.settlementWithdrawFilterType +
                      Utility.settlementWithdrawFilterStatus,
                  id: id,
                  isLoading: false)
              : settlementWithdrawalListViewModel.settlementPayoutList(
                  filter: filterDate +
                      Utility.settlementWithdrawFilterType +
                      Utility.settlementWithdrawFilterStatus,
                  id: id,
                  isLoading: false);
        }
      });
  }

  void apiCall(String id) async {
    ///api calling.......

    if (selectedTab == 0) {
      print('page1 ');
      await settlementWithdrawalListViewModel.settlementWithdrawalList(
          filter: filterDate +
              Utility.settlementWithdrawFilterType +
              Utility.settlementWithdrawFilterStatus,
          id: id,
          isLoading: true);
    } else {
      print('page2');

      await settlementWithdrawalListViewModel.settlementPayoutList(
          filter: filterDate +
              Utility.settlementWithdrawFilterType +
              Utility.settlementWithdrawFilterStatus,
          id: id,
          isLoading: true);
    }
  }

  ListView ListOfData() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: selectedTab == 0 ? withdrawalRes!.length : payoutRes!.length,
      itemBuilder: (context, index) {
        if (searchKey != null && searchKey != "") {
          if (selectedTab == 0) {
            if (withdrawalRes![index]
                    .userbank!
                    .bank!
                    .name
                    .toString()
                    .toLowerCase()
                    .contains(searchKey!.toLowerCase()) ||
                withdrawalRes![index]
                    .user!
                    .name
                    .toString()
                    .toLowerCase()
                    .contains(searchKey!.toLowerCase()) ||
                withdrawalRes![index]
                    .withdrawnumber
                    .toString()
                    .toLowerCase()
                    .contains(searchKey!.toLowerCase())) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      selectedTab == 1
                          ? Get.to(() => SettlementPayoutDetailScreen(
                                id: payoutRes![index].id.toString(),
                              ))
                          : Get.to(() => SettlementWithdrawalDetailScreen(
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
                              '${Utility.baseUrl}containers/api-banks/download/${selectedTab == 0 ? withdrawalRes![index].userbank!.bank!.logo : payoutRes![index].withdrawalrequest!.userbank!.bank!.logo}',
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
                                      title: selectedTab == 0
                                          ? withdrawalRes![index]
                                                  .userbank!
                                                  .bank!
                                                  .name ??
                                              "NA"
                                          : payoutRes![index]
                                                  .withdrawalrequest!
                                                  .userbank!
                                                  .bank!
                                                  .name ??
                                              "NA"),
                                  // Icon(Icons.more_vert)
                                ],
                              ),
                              height10(),
                              customSmallSemiText(
                                  title:
                                      'ID: ${selectedTab == 0 ? withdrawalRes![index].withdrawnumber ?? "NA" : payoutRes![index].withdrawalrequest!.withdrawnumber ?? "NA"}'),
                              height10(),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: customSmallSemiText(
                                    title:
                                        '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(selectedTab == 1 ? payoutRes![index].created.toString() : withdrawalRes![index].created.toString()))}',
                                    color: ColorsUtils.grey),
                              ),
                              height10(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: selectedTab == 0
                                            ? (withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'REJECTED' ||
                                                    withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'CANCELLED')
                                                ? ColorsUtils.reds
                                                : withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'REQUESTED'
                                                    ? ColorsUtils.yellow
                                                    : ColorsUtils.green
                                            : (payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'REJECTED' ||
                                                    payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'CANCELLED')
                                                ? ColorsUtils.reds
                                                : payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'REQUESTED'
                                                    ? ColorsUtils.yellow
                                                    : ColorsUtils.green,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: customSmallSemiText(
                                          color: ColorsUtils.white,
                                          title:
                                              '${selectedTab == 0 ? withdrawalRes![index].withdrawalrequeststatus!.name : payoutRes![index].payoutstatus!.name}'),
                                    ),
                                  ),
                                  Image.asset(
                                    Images.onlinePayment,
                                    width: 25,
                                  ),
                                  customMediumBoldText(
                                      title:
                                          '${selectedTab == 0 ? withdrawalRes![index].amount : payoutRes![index].payoutAmount ?? "0"} QAR',
                                      color: ColorsUtils.accent)
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
            }
          } else {
            if (payoutRes![index]
                    .withdrawalrequest!
                    .userbank!
                    .bank!
                    .name
                    .toString()
                    .toLowerCase()
                    .contains(searchKey!.toLowerCase()) ||
                payoutRes![index]
                    .withdrawalrequest!
                    .withdrawnumber
                    .toString()
                    .toLowerCase()
                    .contains(searchKey!.toLowerCase())) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      selectedTab == 1
                          ? Get.to(() => SettlementPayoutDetailScreen(
                                id: payoutRes![index].id.toString(),
                              ))
                          : Get.to(() => SettlementWithdrawalDetailScreen(
                                id: withdrawalRes![index].id.toString(),
                              ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: Get.height * 0.06,
                            width: Get.width * 0.12,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(Images.dohaBank)),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: ColorsUtils.border, width: 1)),
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
                                      title: selectedTab == 0
                                          ? withdrawalRes![index]
                                                  .userbank!
                                                  .bank!
                                                  .name ??
                                              "NA"
                                          : payoutRes![index]
                                                  .withdrawalrequest!
                                                  .userbank!
                                                  .bank!
                                                  .name ??
                                              "NA"),
                                  // Icon(Icons.more_vert)
                                ],
                              ),
                              height10(),
                              customSmallSemiText(
                                  title:
                                      'ID: ${selectedTab == 0 ? withdrawalRes![index].withdrawnumber ?? "NA" : payoutRes![index].withdrawalrequest!.withdrawnumber ?? "NA"}'),
                              height10(),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: customSmallSemiText(
                                    title:
                                        '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(selectedTab == 1 ? payoutRes![index].created.toString() : withdrawalRes![index].created.toString()))}',
                                    color: ColorsUtils.grey),
                              ),
                              height10(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: selectedTab == 0
                                            ? (withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'REJECTED' ||
                                                    withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'CANCELLED')
                                                ? ColorsUtils.reds
                                                : withdrawalRes![index]
                                                            .withdrawalrequeststatus!
                                                            .name ==
                                                        'REQUESTED'
                                                    ? ColorsUtils.yellow
                                                    : ColorsUtils.green
                                            : (payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'REJECTED' ||
                                                    payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'CANCELLED')
                                                ? ColorsUtils.reds
                                                : payoutRes![index]
                                                            .payoutstatus!
                                                            .name ==
                                                        'REQUESTED'
                                                    ? ColorsUtils.yellow
                                                    : ColorsUtils.green,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: customSmallSemiText(
                                          color: ColorsUtils.white,
                                          title:
                                              '${selectedTab == 0 ? withdrawalRes![index].withdrawalrequeststatus!.name : payoutRes![index].payoutstatus!.name}'),
                                    ),
                                  ),
                                  Image.asset(
                                    Images.onlinePayment,
                                    width: 25,
                                  ),
                                  customMediumBoldText(
                                      title:
                                          '${selectedTab == 0 ? withdrawalRes![index].amount : payoutRes![index].payoutAmount ?? "0"} QAR',
                                      color: ColorsUtils.accent)
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
            }
          }
        }

        return SizedBox();
      },
    );
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
                          showLoadingDialog(context: context);
                          String token = await encryptedSharedPreferences
                              .getString('token');
                          final url = Uri.parse(
                            '${Utility.baseUrl}reporthistories/settlementReports?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
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
                            hideLoadingDialog(context: context);
                            Get.back();
                            Get.snackbar('Success'.tr,
                                'Email has been sent successfully');
                          } else {
                            Get.back();
                            hideLoadingDialog(context: context);

                            // const SessionExpire();
                            Get.snackbar('error', 'something Wrong');
                          }
                        } else {
                          await downloadFiles(
                            isEmail: sendEmail,
                            isRadioSelected: isRadioSelected,
                            url:
                                '${Utility.baseUrl}reporthistories/settlementReports?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
                            context: context,
                          );
                        }
                      }
                    },
                    child: commonButtonBox(
                        color: ColorsUtils.accent,
                        text: sendEmail == true ? 'Send'.tr : 'DownLoad'.tr,
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

  Future<void> downloadFiles(
      {String? url,
      int? isRadioSelected,
      bool? isEmail,
      BuildContext? context}) async {
    String downloadUrl = url!;
    if (downloadUrl == '' || downloadUrl == null) {
      return;
    }
    print('DOWNLOAD LINK : => $downloadUrl');
    final storagePermissionStatus = await getStoragePermission();
    if (!storagePermissionStatus) {
      print('permisiion not ');
      return;
    }
    Dio dio = Dio();
    String savePath = (await getDownloadPath()) ?? '';
    if (savePath == "") {
      return;
    }
    print('PATH :=>$savePath');
    savePath = savePath +
        '/' +
        DateTime.now().microsecondsSinceEpoch.toString() +
        (isRadioSelected == 2
            ? '.csv'
            : isRadioSelected == 3
                ? '.xlsx'
                : '.pdf');
    // final url = Uri.parse(
    //     'http://176.58.99.102:3001/api-v1/products/pdfexport?filter={}');
    String token = await encryptedSharedPreferences.getString('token');

    Map<String, String> header = {
      'Authorization': token,
    };
    print('AFTER FILE NAME ADD PATH :=>$savePath');
    final response = await dio.download(downloadUrl, savePath,
        options: Options(headers: header));

    if (response.statusCode == 200) {
      Get.back();
      // Get.showSnackbar(GetSnackBar(
      //   message: 'successfully download',
      // ));
      Get.snackbar('success'.tr, 'successfully download');
      print('successfully download');
      String email = await encryptedSharedPreferences.getString('email');
      print('email is $email');
      // isEmail == true
      //     ? sendToMail(path: savePath, emailId: email)
      //     :
      openFile(savePath);
    } else {
      Get.back();

      print('failed');
    }
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        final existsPathStatus = await directory.exists();
        // print('EXIS PATH :=>$existsPathStatus');
        if (!existsPathStatus) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
}
