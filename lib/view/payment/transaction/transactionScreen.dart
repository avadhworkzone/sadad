// ignore_for_file: avoid_print, unrelated_type_equality_checks

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/disputesCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/transactionCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/transactionListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundTransactionScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/searchTransaction.dart';
import 'package:sadad_merchat_app/view/payment/transaction/transactionDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/disputeTransactionResponseModel.dart';
import '../../../viewModel/Payment/transaction/transactionViewModel.dart';
import 'filterTransaction.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with TickerProviderStateMixin {
  int differenceDays = 0;
  bool isTabVisible = false;
  String _range = '';
  double? tabWidgetPosition = 0.0;
  String startDate = '';
  String orderStatus = '';
  late TabController tabController;
  String endDate = '';
  String token = '';
  bool isPageFirst = true;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<String> selectedTimeZone = ['Today'];
  bool isSearch = false;
  String filterDate = '';
  String filter = '';
  int selectedTab = 0;
  TransactionViewModel transactionViewModel = Get.find();
  ScrollController? _scrollController;
  List<TransactionListResponseModel>? transactionListResponse;
  List<DisputeTransactionResponseModel>? disputeTransactionResponse;
  DisputesCountResponseModel? disputesCountResponseModel;
  TransactionCountResponseModel? transactionCountResponseModel;
  ConnectivityViewModel connectivityViewModel = Get.find();
  List selectedType = ['Transaction ID'];
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  DateTime now = DateTime.now();
  @override
  void initState() {
    endDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime(now.year, now.month, now.day, 23, 59, 59));
    startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(DateTime(now.year, now.month, now.day, 00, 00, 00));
    filterDate = ',{"created":{"between":["$startDate","$endDate"]}}';
    connectivityViewModel.startMonitoring();

    transactionViewModel.setTransactionInit();
    tabController = TabController(length: 3, vsync: this);
    Utility.isDisputeDetailTransaction = false;
    initData();
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
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            body: Column(
          children: [
            topView(),
            tabBar(),
          ],
        ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                transactionViewModel.setTransactionInit();
                tabController = TabController(length: 3, vsync: this);
                Utility.isDisputeDetailTransaction = false;
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
              transactionViewModel.setTransactionInit();
              tabController = TabController(length: 3, vsync: this);
              Utility.isDisputeDetailTransaction = false;
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

  Widget topView() {
    return Container(
      color: ColorsUtils.lightBg,
      child: Column(
        children: [
          height60(),
          topRow(),
          height10(),
          timeZone(),
          height20(),
        ],
      ),
    );
  }

  Widget topRow() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    if (isSearch == true) {
                      searchKey = '';
                      initData();
                    }
                    isSearch == true ? isSearch = false : Get.back();
                    setState(() {});
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              width10(),
              isSearch == false
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text('Transactions'.tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                    fontSize: FontUtils.medLarge,
                                  )),
                            ),
                          ),
                          //const Spacer(),
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
                          //width30(),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (value) async {
                            transactionViewModel.clearResponseList();
                            transactionViewModel.setTransactionInit();
                            searchKey = value;
                            setState(() {});
                            initData();
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
                                        setState(() {});

                                        transactionViewModel
                                            .clearResponseList();
                                        transactionViewModel
                                            .setTransactionInit();

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
                              hintText: 'ex. ${selectedType.first}...',
                              hintStyle: ThemeUtils.blackRegular.copyWith(
                                  color: ColorsUtils.grey,
                                  fontSize: FontUtils.small)),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        //isSearch == true ? SizedBox() : height20(),
        isSearch == false
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  // padding: EdgeInsets.all,
                  // decoration: BoxDecoration(
                  //     border: Border.all(
                  //         color: ColorsUtils.grey.withOpacity(0.3),
                  //         width: 1),
                  //     borderRadius: BorderRadius.circular(10)),
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: customVerySmallBoldText(
                          title: 'Search for :'.tr,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          runSpacing: 10,
                          direction: Axis.horizontal,
                          children: List.generate(
                              selectedTab == 0
                                  ? StaticData().TrnxPaymentSearchType.length
                                  : selectedTab == 1
                                      ? StaticData().TrnxRefundSearchType.length
                                      : StaticData()
                                          .TrnxDisputeSearchType
                                          .length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: InkWell(
                                      onTap: () async {
                                        selectedType.clear();
                                        searchKey = '';
                                        searchController.clear();
                                        selectedType.add(selectedTab == 0
                                            ? StaticData()
                                                .TrnxPaymentSearchType[index]
                                            : selectedTab == 1
                                                ? StaticData()
                                                    .TrnxRefundSearchType[index]
                                                : StaticData()
                                                        .TrnxDisputeSearchType[
                                                    index]);
                                        initData();
                                        // cardEntryType == index.toString();
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
                                            color: selectedType.contains(selectedTab ==
                                                        0
                                                    ? StaticData()
                                                            .TrnxPaymentSearchType[
                                                        index]
                                                    : selectedTab == 1
                                                        ? StaticData()
                                                                .TrnxRefundSearchType[
                                                            index]
                                                        : StaticData()
                                                                .TrnxDisputeSearchType[
                                                            index])
                                                ? ColorsUtils.primary
                                                : ColorsUtils.white),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            selectedTab == 0
                                                ? StaticData()
                                                        .TrnxPaymentSearchType[
                                                    index]
                                                : selectedTab == 1
                                                    ? StaticData()
                                                            .TrnxRefundSearchType[
                                                        index]
                                                    : StaticData()
                                                        .TrnxDisputeSearchType[
                                                            index]
                                                        .tr,
                                            style: ThemeUtils.blackBold
                                                .copyWith(
                                                    fontSize: FontUtils
                                                        .verySmall,
                                                    color: selectedType.contains(selectedTab ==
                                                                0
                                                            ? StaticData()
                                                                    .TrnxPaymentSearchType[
                                                                index]
                                                            : selectedTab == 1
                                                                ? StaticData()
                                                                        .TrnxRefundSearchType[
                                                                    index]
                                                                : StaticData()
                                                                        .TrnxDisputeSearchType[
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
      ],
    );
  }

  SizedBox timeZone() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().timeZone.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return index == 0
              ? SizedBox()
              : Padding(
                  padding: index == 0 && Get.locale!.languageCode == 'en'
                      ? const EdgeInsets.only(left: 20, right: 5)
                      : index == StaticData().timeZone.length - 1 &&
                              Get.locale!.languageCode == 'en'
                          ? const EdgeInsets.only(right: 20, left: 5)
                          : const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () async {
                      selectedTimeZone.clear();
                      // startDate = '';
                      // endDate = '';
                      selectedTimeZone.add(StaticData().timeZone[index]);

                      if (selectedTimeZone.contains('Custom')) {
                        // startDate = '';
                        // endDate = '';

                        selectedTimeZone.clear();
                        await datePicker(context);
                        if (startDate != '' && endDate != '') {
                          selectedTimeZone.add('Custom');
                          filterDate =
                              ',{"created":{"between":["$startDate","$endDate"]}}';
                          print('filter date=$filterDate');
                          initData();
                        }
                      } else {
                        _range = '';
                        final now = DateTime.now();
                        endDate = selectedTimeZone.first == 'Yesterday'
                            ? intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                DateTime(now.year, now.month, now.day - 1, 23,
                                    59, 59))
                            : intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                DateTime(
                                    now.year, now.month, now.day, 23, 59, 59));
                        selectedTimeZone.first == 'Today'
                            ? startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(DateTime(
                                    now.year, now.month, now.day, 00, 00, 00))
                            : selectedTimeZone.first == 'Yesterday'
                                ? startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(DateTime(now.year, now.month,
                                        now.day - 1, 00, 00, 00))
                                : selectedTimeZone.first == 'Week'
                                    ? startDate =
                                        intl.DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .format(DateTime(
                                                now.year,
                                                now.month,
                                                now.day - 6,
                                                00,
                                                00,
                                                00))
                                    : selectedTimeZone.first == 'Month'
                                        ? startDate =
                                            intl.DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(DateTime(now.year, now.month - 1, now.day, 00, 00, 00))
                                        : selectedTimeZone.first == 'Year'
                                            ? startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime(now.year, now.month, now.day - 365, 00, 00, 00))
                                            : '';

                        filterDate = selectedTimeZone.first == 'All'
                            ? ""
                            : ',{"created":{"between":["$startDate","$endDate"]}}';
                        print('filterDate::$filterDate');
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
                          color: selectedTimeZone
                                  .contains(StaticData().timeZone[index])
                              ? ColorsUtils.primary
                              : ColorsUtils.tabUnselect),
                      child: Center(
                        child: Text(
                          index == 6
                              ? _range == ''
                                  ? StaticData().timeZone[index].tr
                                  : _range
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
                                          '${intl.DateFormat('dd MMM’ yy').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                          ' ${intl.DateFormat('dd MMM’ yy').format(dateRangePickerSelectionChangedArgs.value.endDate)}';
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
                                    startDate = intl.DateFormat(
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
                                        : endDate = intl.DateFormat(
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
                                        // startDate = '';
                                        // endDate = '';
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

  Widget tabBar() {
    return Expanded(
      child: Column(
        children: [
          Container(
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
                  selectedType.clear();
                  value == 0
                      ? selectedType.add(StaticData().TrnxPaymentSearchType[0])
                      : value == 1
                          ? selectedType
                              .add(StaticData().TrnxRefundSearchType[0])
                          : selectedType
                              .add(StaticData().TrnxDisputeSearchType[0]);

                  if (value == 0) {
                    //refund
                    Utility.refundedFilterStatus = '';
                    Utility.refundedFilterPaymentMethod = '';
                    Utility.refundedFilterTransactionModes = '';
                    Utility.holdRefundedFilterStatus = '';
                    Utility.holdRefundedFilterPaymentMethod = '';
                    Utility.holdRefundedFilterTransactionModes = '';
                    //dispute
                    Utility.disputeStatusFilter = '';
                    Utility.disputeTypeFilter = '';
                    Utility.holdDisputeStatusFilter = '';
                    Utility.holdDisputeTypeFilter = '';
                  } else if (value == 1) {
                    //payment
                    Utility.transactionFilterStatus = '';
                    Utility.transactionFilterPaymentMethod = '';
                    Utility.transactionFilterTransactionModes = '';
                    Utility.transactionFilterTransactionSources = '';
                    Utility.holdTransactionFilterStatus = '';
                    Utility.holdTransactionFilterPaymentMethod = '';
                    Utility.holdTransactionFilterTransactionModes = '';
                    Utility.holdTransactionFilterTransactionSources = '';
                    //dispute
                    Utility.disputeStatusFilter = '';
                    Utility.disputeTypeFilter = '';
                    Utility.holdDisputeStatusFilter = '';
                    Utility.holdDisputeTypeFilter = '';
                  } else if (value == 2) {
                    //payment
                    Utility.transactionFilterStatus = '';
                    Utility.transactionFilterPaymentMethod = '';
                    Utility.transactionFilterTransactionModes = '';
                    Utility.transactionFilterTransactionSources = '';
                    Utility.holdTransactionFilterStatus = '';
                    Utility.holdTransactionFilterPaymentMethod = '';
                    Utility.holdTransactionFilterTransactionModes = '';
                    Utility.holdTransactionFilterTransactionSources = '';
                    //refund
                    Utility.refundedFilterStatus = '';
                    Utility.refundedFilterPaymentMethod = '';
                    Utility.refundedFilterTransactionModes = '';
                    Utility.holdRefundedFilterStatus = '';
                    Utility.holdRefundedFilterPaymentMethod = '';
                    Utility.holdRefundedFilterTransactionModes = '';
                  }
                  isSearch = false;
                  setState(() {});
                  initData();
                },
                isScrollable: false,
                labelStyle:
                    ThemeUtils.blackSemiBold.copyWith(color: ColorsUtils.white),
                unselectedLabelColor: ColorsUtils.white,
                labelColor: ColorsUtils.white,
                labelPadding: const EdgeInsets.all(3),
                tabs: [
                  Tab(text: 'Payments'.tr),
                  Tab(text: 'Refunds'.tr),
                  Tab(text: 'Disputes'.tr),
                ],
              )),
          height20(),
          Expanded(
            child: GetBuilder<TransactionViewModel>(
              builder: (controller) {
                if (selectedTab == 2) {
                  if (controller.disputeTransactionListApiResponse.status ==
                          Status.LOADING ||
                      controller.disputesCountApiResponse.status ==
                          Status.LOADING ||
                      controller.disputesCountApiResponse.status ==
                          Status.INITIAL ||
                      controller.disputeTransactionListApiResponse.status ==
                          Status.INITIAL) {
                    return const Center(child: Loader());
                    // return const SizedBox();
                  }
                  if (controller.disputesCountApiResponse.status ==
                          Status.ERROR ||
                      controller.disputeTransactionListApiResponse.status ==
                          Status.ERROR) {
                    return const SessionExpire();
                    //return const Text('Error');
                  }
                  disputesCountResponseModel =
                      transactionViewModel.disputesCountApiResponse.data;
                  disputeTransactionResponse = transactionViewModel
                      .disputeTransactionListApiResponse.data;
                } else {
                  if (controller.transactionListApiResponse.status ==
                          Status.LOADING ||
                      controller.transactionCountApiResponse.status ==
                          Status.LOADING ||
                      controller.transactionCountApiResponse.status ==
                          Status.INITIAL ||
                      controller.transactionListApiResponse.status ==
                          Status.INITIAL) {
                    // return SizedBox();
                    return const Center(child: Loader());
                  }
                  if (controller.transactionListApiResponse.status ==
                          Status.ERROR ||
                      controller.transactionCountApiResponse.status ==
                          Status.ERROR ||
                      controller.disputesCountApiResponse.status ==
                          Status.ERROR ||
                      controller.disputeTransactionListApiResponse.status ==
                          Status.ERROR) {
                    return const SessionExpire();
                    //return const Text('Error');
                  }

                  transactionListResponse =
                      transactionViewModel.transactionListApiResponse.data;

                  transactionCountResponseModel =
                      transactionViewModel.transactionCountApiResponse.data;
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Text(
                              '${selectedTab == 2 ? disputesCountResponseModel!.count ?? "" : transactionCountResponseModel!.count ?? ""} ${selectedTab == 0 ? 'Payments'.tr : selectedTab == 1 ? 'Refunds'.tr : 'Disputes'.tr}'),
                          const Spacer(),
                          InkWell(
                              onTap: () async {
                                await Get.to(() => FilterTransaction(
                                      tab: selectedTab,
                                    ));
                                transactionViewModel.setTransactionInit();

                                initData();
                              },
                              child: Image.asset(
                                Images.filter,
                                color: Utility.transactionFilterStatus == '' &&
                                        Utility.transactionFilterPaymentMethod ==
                                            '' &&
                                        Utility.transactionFilterTransactionModes ==
                                            '' &&
                                        Utility.transactionFilterTransactionSources ==
                                            '' &&
                                        Utility.refundedFilterStatus == '' &&
                                        Utility.refundedFilterPaymentMethod ==
                                            '' &&
                                        Utility.refundedFilterTransactionModes ==
                                            '' &&
                                        Utility.disputeStatusFilter == '' &&
                                        Utility.disputeTypeFilter == ''
                                    ? ColorsUtils.black
                                    : ColorsUtils.accent,
                                height: 20,
                                width: 20,
                              )),
                        ],
                      ),
                    ),
                    height20(),
                    // if (transactionViewModel.isPaginationLoading && isPageFirst)
                    //   const Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 20),
                    //     child: Center(child: Loader()),
                    //   ),
                    selectedTab == 2
                        ? disputeTransactionResponse!.isEmpty &&
                                !transactionViewModel.isPaginationLoading
                            ? noDataFound()
                            : disputeTabListData()
                        : transactionListResponse!.isEmpty &&
                                !transactionViewModel.isPaginationLoading
                            ? noDataFound()
                            : tabListData(),
                    if (transactionViewModel.isPaginationLoading &&
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
        ],
      ),
    );
  }

  Center noDataFound() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Text('No data found'.tr),
    ));
  }

  Expanded tabListData() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: transactionListResponse!.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: InkWell(
                  onTap: () {
                    Utility.isDisputeDetailTransaction = false;
                    Get.to(() => selectedTab == 1
                        ? RefundDetailScreen(
                            id: transactionListResponse![index].id.toString(),
                          )
                        : TransactionDetailScreen(
                            id: transactionListResponse![index].id.toString(),
                          ));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: ColorsUtils.lightBg,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Image.asset(
                                transactionListResponse![index].cardtype ==
                                        'VISA'
                                    ? Images.visaCard
                                    : transactionListResponse![index]
                                                .cardtype ==
                                            'SADAD PAY'
                                        ? Images.sadadWalletPay
                                        : transactionListResponse![index]
                                                    .cardtype ==
                                                'MASTERCARD'
                                            ? Images.masterCard
                                            : transactionListResponse![index]
                                                        .cardtype ==
                                                    'GOOGLE PAY'
                                                ? Images.googlePay
                                                : transactionListResponse![index]
                                                            .cardtype ==
                                                        'APPLE PAY'
                                                    ? Images.applePay
                                                    : transactionListResponse![
                                                                    index]
                                                                .cardtype ==
                                                            'JCB'
                                                        ? Images.jcb
                                                        : transactionListResponse![
                                                                        index]
                                                                    .cardtype ==
                                                                'AMEX'
                                                            ? Images.amex
                                                            : transactionListResponse![index]
                                                                        .cardtype ==
                                                                    'AMERICAN EXPRESS'
                                                                ? Images.amex
                                                                : transactionListResponse![index]
                                                                            .cardtype ==
                                                                        'UPI'
                                                                    ? Images.upi
                                                                    : transactionListResponse![index].cardtype ==
                                                                            'SADAD'
                                                                        ? Images
                                                                            .sadadWalletPay
                                                                        : Images
                                                                            .invoice,
                                height: 40,
                              )
                              // Image.asset(
                              //   selectedTab == 1
                              //       ? Images.refundBack
                              //       : Images.invoice,
                              //   width: 20,
                              //   height: 20,
                              // ),
                              )),
                      width10(),
                      Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ID: ${transactionListResponse![index].invoicenumber}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeUtils.blackBold
                                          .copyWith(fontSize: FontUtils.small),
                                    ),
                                  ),
                                  selectedTab == 1 ||
                                          transactionListResponse![index]
                                                  .transactionstatusId
                                                  .toString() ==
                                              '1'
                                      ? SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            bottomSheetforDownloadAndRefund(
                                                context, index);
                                          },
                                          child: const Icon(
                                            Icons.more_vert,
                                          ),
                                        )
                                ],
                              ),
                              height10(),
                              transactionListResponse![index].transactionmode ==
                                      null
                                  ? SizedBox()
                                  : Text(
                                      '${transactionListResponse![index].transactionmode!.name.toString().capitalize == 'Google Pay' || transactionListResponse![index].transactionmode!.name.toString().capitalize == 'Apple Pay' || transactionListResponse![index].transactionmode!.name.toString().capitalize == 'Sadad' || transactionListResponse![index].transactionmode!.name.toString().capitalize == 'Sadad Pay' ? 'Wallet' : transactionListResponse![index].transactionmode!.name.toString().capitalize}',
                                      style: ThemeUtils.blackRegular
                                          .copyWith(fontSize: FontUtils.small),
                                    ),
                              height10(),
                              Text(
                                textDirection: TextDirection.ltr,
                                '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(transactionListResponse![index].created))}',
                                style: ThemeUtils.blackRegular.copyWith(
                                    fontSize: FontUtils.small,
                                    color: ColorsUtils.grey),
                              ),
                              height10(),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: transactionListResponse![index]
                                                  .transactionstatusId
                                                  .toString() ==
                                              '1'
                                          ? ColorsUtils.yellow
                                          : transactionListResponse![index]
                                                      .transactionstatusId
                                                      .toString() ==
                                                  '2'
                                              ? ColorsUtils.reds
                                              : transactionListResponse![index]
                                                          .transactionstatusId
                                                          .toString() ==
                                                      '3'
                                                  ? ColorsUtils.green
                                                  : transactionListResponse![
                                                                  index]
                                                              .transactionstatusId
                                                              .toString() ==
                                                          '4'
                                                      ? ColorsUtils.green
                                                      : transactionListResponse![
                                                                      index]
                                                                  .transactionstatusId
                                                                  .toString() ==
                                                              '5'
                                                          ? ColorsUtils.yellow
                                                          : transactionListResponse![
                                                                          index]
                                                                      .transactionstatusId
                                                                      .toString() ==
                                                                  '6'
                                                              ? ColorsUtils
                                                                  .blueBerryPie
                                                              : ColorsUtils
                                                                  .accent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      child: Text(
                                        transactionListResponse![index]
                                                    .transactionstatusId ==
                                                5
                                            ? 'REQUESTED'
                                            : '${transactionListResponse![index].transactionstatus!.name ?? ""}',
                                        // transactionListResponse[index]
                                        //             .transactionstatusId
                                        //             .toString() ==
                                        //         '1'
                                        //     ? 'Inprogress'
                                        //     : transactionListResponse[index]
                                        //                 .transactionstatusId
                                        //                 .toString() ==
                                        //             '2'
                                        //         ? 'Failed'
                                        //         : transactionListResponse[index]
                                        //                     .transactionstatusId
                                        //                     .toString() ==
                                        //                 '3'
                                        //             ? 'Success'
                                        //             : transactionListResponse[
                                        //                             index]
                                        //                         .transactionstatusId
                                        //                         .toString() ==
                                        //                     '4'
                                        //                 ? 'Refund'
                                        //                 : transactionListResponse[
                                        //                                 index]
                                        //                             .transactionstatusId
                                        //                             .toString() ==
                                        //                         '5'
                                        //                     ? 'Pending'
                                        //                     : transactionListResponse[
                                        //                                     index]
                                        //                                 .transactionstatusId
                                        //                                 .toString() ==
                                        //                             '6'
                                        //                         ? 'Onhold'
                                        //                         : 'Rejected',
                                        style: ThemeUtils.blackRegular.copyWith(
                                            fontSize: FontUtils.verySmall,
                                            color: ColorsUtils.white),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      selectedTab == 1
                                          ? Text('Refund Amount'.tr,
                                              style: ThemeUtils.blackRegular
                                                  .copyWith(
                                                      fontSize:
                                                          FontUtils.verySmall))
                                          : SizedBox(),
                                      Text(
                                        '${double.parse(transactionListResponse![index].amount.toString()).toStringAsFixed(2)} QAR',
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.mediumSmall,
                                            color: ColorsUtils.accent),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              const Divider()
            ],
          );
        },
      ),
    );
  }

  Expanded disputeTabListData() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: disputeTransactionResponse!.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: InkWell(
                  onTap: () {
                    Utility.isDisputeDetailTransaction = true;
                    Get.to(() => TransactionDetailScreen(
                          id: disputeTransactionResponse![index]
                              .transactionId
                              .toString(),
                        ));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: ColorsUtils.lightBg,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Image.asset(
                              selectedTab == 1
                                  ? Images.refundBack
                                  : Images.invoice,
                              width: 20,
                              height: 20,
                            ),
                          )),
                      width10(),
                      Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'ID: ${disputeTransactionResponse![index].transaction!.invoicenumber}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeUtils.blackBold
                                          .copyWith(fontSize: FontUtils.small),
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     bottomSheetforDownloadAndRefund(
                                  //         context, index);
                                  //   },
                                  //   child: const Icon(
                                  //     Icons.more_vert,
                                  //   ),
                                  // )
                                ],
                              ),
                              height10(),
                              disputeTransactionResponse![index].transaction ==
                                      null
                                  ? SizedBox()
                                  : Text(
                                      disputeTransactionResponse![index]
                                                  .transaction!
                                                  .transactionmodeId ==
                                              1
                                          ? 'Credit Card'
                                          : disputeTransactionResponse![index]
                                                      .transaction!
                                                      .transactionmodeId ==
                                                  2
                                              ? 'Debit Card'
                                              : 'Sadad',
                                      style: ThemeUtils.blackRegular
                                          .copyWith(fontSize: FontUtils.small),
                                    ),
                              height10(),
                              Text(
                                textDirection: TextDirection.ltr,
                                '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(disputeTransactionResponse![index].transaction!.created.toString()))}',
                                style: ThemeUtils.blackRegular.copyWith(
                                    fontSize: FontUtils.small,
                                    color: ColorsUtils.grey),
                              ),
                              height10(),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: disputeTransactionResponse![index]
                                                  .disputestatus!
                                                  .id ==
                                              1
                                          ? ColorsUtils.green
                                          : disputeTransactionResponse![index]
                                                      .disputestatus!
                                                      .id ==
                                                  2
                                              ? ColorsUtils.yellow
                                              : disputeTransactionResponse![
                                                              index]
                                                          .disputestatus!
                                                          .id ==
                                                      3
                                                  ? ColorsUtils.accent
                                                  : ColorsUtils.accent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      child: Text(
                                        disputeTransactionResponse![index]
                                            .disputestatus!
                                            .name,
                                        style: ThemeUtils.blackRegular.copyWith(
                                            fontSize: FontUtils.verySmall,
                                            color: ColorsUtils.white),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${disputeTransactionResponse![index].amount} QAR',
                                    style: ThemeUtils.blackBold.copyWith(
                                        fontSize: FontUtils.mediumSmall,
                                        color: ColorsUtils.accent),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              const Divider()
            ],
          );
        },
      ),
    );
  }

  void bottomSheetforDownloadAndRefund(BuildContext context, int index) {
    showModalBottomSheet<void>(
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
                      downloadFile(
                          context: context,
                          isRadioSelected: 1,
                          isEmail: false,
                          url:
                              '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${selectedTab == 2 ? disputeTransactionResponse![index].transaction!.invoicenumber : transactionListResponse![index].invoicenumber}&isPOS=false');
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          Images.download,
                          width: 25,
                          height: 25,
                          color: ColorsUtils.black,
                        ),
                        width20(),
                        Text(
                          'Download Receipt'.tr,
                          style: ThemeUtils.blackSemiBold
                              .copyWith(fontSize: FontUtils.mediumSmall),
                        )
                      ],
                    ),
                  ),
                  transactionListResponse![index]
                                  .transactionstatusId
                                  .toString() ==
                              '3' &&
                          selectedTab == 0 &&
                          transactionListResponse![index].isRefund == false
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(),
                        )
                      : height10(),
                  transactionListResponse![index]
                                  .transactionstatusId
                                  .toString() ==
                              '3' &&
                          selectedTab == 0
                      ? InkWell(
                          onTap: () {
                            if ((transactionListResponse![index].isRefund ==
                                    false &&
                                (transactionListResponse![index]
                                        .priorRefundRequestedAmount <=
                                    0))) {
                              Get.back();
                              Map<String, dynamic> transactionDetail = {
                                'id': transactionListResponse![index]
                                    .invoicenumber,
                                'type':
                                    transactionListResponse![index].cardtype,
                                'amount':
                                    transactionListResponse![index].amount,
                                'isCredit': transactionListResponse![index]
                                    .transactionmode!
                                    .id,
                                'PriorAmount': transactionListResponse![index]
                                    .priorRefundRequestedAmount
                              };
                              print(
                                  '-----=====${transactionListResponse![index].transactionmode!.name}====${transactionListResponse![index].transactionmode!.id}');
                              print('id is ${transactionDetail['id']}');
                              Get.to(() => RefundTransactionScreen(
                                    transactionDetail: transactionDetail,
                                  ));
                            } else {
                              Get.back();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Dialog(
                                        elevation: 0,

                                        // backgroundColor: Colors.transparent,
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  // border: Border.all(
                                                  //   color: ColorsUtils.accent,
                                                  //   width: 2,
                                                  // ),
                                                  color: ColorsUtils.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    //selectedRefundedStatus.first == 'Refunded'
                                                    //               ? ',{"transactionstatusId":"4"}'
                                                    //               : selectedRefundedStatus.first == 'Requested'
                                                    //                   ? ',{"transactionstatusId":"5"}'
                                                    //                   : selectedRefundedStatus.first == 'Rejected'
                                                    //                       ? ',{"transactionstatusId":"7"}'
                                                    //                       : '';
                                                    RichText(
                                                      text: TextSpan(
                                                          style: TextStyle(
                                                            color: ColorsUtils
                                                                .black,
                                                          ),
                                                          text:
                                                              'Sorry, you have your already raised Refund transaction.\n\nYour refund status is ',
                                                          children: [
                                                            TextSpan(
                                                                style: TextStyle(
                                                                    color: ColorsUtils
                                                                        .accent,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                text:
                                                                    '${transactionListResponse![index].refundId == null ? 'NA' : transactionListResponse![index].refundId!.first.transactionstatusId == 4 ? 'Refunded' : transactionListResponse![index].refundId!.first.transactionstatusId == 5 ? 'Pending' : 'Rejected'}')
                                                          ]),
                                                    ),
                                                    height20(),
                                                    Row(
                                                      children: [
                                                        customSmallSemiText(
                                                            title:
                                                                'Your refund ID is : '),
                                                        customSmallBoldText(
                                                            title:
                                                                '${(transactionListResponse![index].refundId == null ? 'NA' : transactionListResponse![index].refundId!.first.invoicenumber ?? "NA")}',
                                                            color: ColorsUtils
                                                                .accent)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                Images.refund,
                                width: 25,
                                height: 25,
                                color: ColorsUtils.black,
                              ),
                              width20(),
                              Text(
                                'Refund'.tr,
                                style: ThemeUtils.blackSemiBold
                                    .copyWith(fontSize: FontUtils.mediumSmall),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  height40()
                ],
              ),
            );
          },
        );
      },
    );
  }

  initData() async {
    Utility.transactionFilterSorted = 'created DESC';
    String id = await encryptedSharedPreferences.getString('id');
    String include = selectedTab == 0
        ? '["senderId", "receiverId", "guestuser", "transactionentity", "transactionmode", "transactionstatus", "postransaction", "dispute"]}'
        : '["senderId", "receiverId", "guestuser", "transactionentity", "transactionmode", "transactionstatus", "dispute"]}';
    String transactionStatus = selectedTab == 1
        ? ',{"transactionentityId":{"neq":[17]}},{"transactionstatusId":{"inq":[4,5,7]}}$filterDate${Utility.refundedFilterStatus}${Utility.refundedFilterPaymentMethod}${Utility.refundedFilterTransactionModes}${searchKey != '' ? selectedType.contains('Refund ID') ? ',{"invoicenumber":"$searchKey"}' : selectedType.contains('Refund Amount') ? ',{"amount":"$searchKey"}' : selectedType.contains('Transaction ID') ? ',{"actualTxnId":"$searchKey"}' : "" : ""}]}'
        : ',{"transactionentityId":{"inq": [1,2,3,5,6,7,8,9,12]}},{"transactionstatusId":${Utility.transactionFilterStatus == '' ? '{"inq":[1,2,3,6]}' : '"${Utility.transactionFilterStatus}"'}}${searchKey != '' ? selectedType.contains('Transaction ID') ? ',{"invoicenumber":"$searchKey"}' : selectedType.contains('Transaction Amount') ? ',{"amount":"$searchKey"}' : "" : ""}$filterDate${Utility.transactionFilterPaymentMethod}${Utility.transactionFilterTransactionModes}${Utility.transactionFilterTransactionSources}]${searchKey != '' ? selectedType.contains('Auth Number') ? ',"authorizationnumber":"$searchKey"' : selectedType.contains('Customer Name') ? ',"name":"$searchKey"' : selectedType.contains('Customer Email ID') ? ',"email":"$searchKey"' : selectedType.contains('Customer Mobile no') ? ',"cellnumber":"$searchKey"' : selectedType.contains('RRN') ? ',"transactionrrnnumber":"$searchKey"' : "" : ""}}';
    transactionViewModel.clearResponseList();
    transactionViewModel.setTransactionInit();

    scrollData(id, transactionStatus, include);

    ///api calling.......
    await apiCalling(id, transactionStatus, include);

    if (isPageFirst == true) {
      isPageFirst = false;
    }
  }

  Future<void> apiCalling(
      String id, String transactionStatus, String include) async {
    if (selectedTab == 2) {
      await transactionViewModel.disputesCount(
          id: id,
          transactionStatus:
              '${filterDate + Utility.disputeStatusFilter + Utility.disputeTypeFilter},{"isPOS":false}${searchKey != '' ? selectedType.contains('Dispute ID') ? ',{"disputeId":"$searchKey"}' : selectedType.contains('Transaction ID') ? ',{"transactionId":"$searchKey"}' : "" : ""}]}');
      await transactionViewModel.disputeTransactionList(
          id: id,
          transactionStatus:
              '${filterDate + Utility.disputeStatusFilter + Utility.disputeTypeFilter},{"isPOS":false}${searchKey != '' ? selectedType.contains('Dispute ID') ? ',{"disputeId":"$searchKey"}' : selectedType.contains('Transaction ID') ? ',{"transactionId":"$searchKey"}' : "" : ""}]},',
          filter: Utility.transactionFilterSorted,
          include:
              '["senderId","receiverId","transaction", "disputestatus", "disputetype"]}');
    } else {
      await transactionViewModel.transactionCount(
          id: id, transactionStatus: transactionStatus);

      await transactionViewModel.transactionList(
          id: id,
          transactionStatus: '$transactionStatus,',
          filter: Utility.transactionFilterSorted,
          include: include);
    }
  }

  void scrollData(String id, String transactionStatus, String include) {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !transactionViewModel.isPaginationLoading) {
          transactionViewModel.disputeTransactionList(
              id: id,
              transactionStatus: '$filterDate]},',
              filter: Utility.transactionFilterSorted,
              include:
                  '["senderId","receiverId","transaction", "disputestatus", "disputetype"]}');
          transactionViewModel.transactionList(
              id: id,
              transactionStatus: '$transactionStatus,',
              filter: Utility.transactionFilterSorted,
              include: include);
        }
      });
  }
}
