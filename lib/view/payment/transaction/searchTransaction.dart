import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/disputeTransactionResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/transactionListResponseModel.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundTransactionScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/transactionDetailScreen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../model/apis/api_response.dart';
import '../../../staticData/common_widgets.dart';
import '../../../viewModel/Payment/transaction/transactionViewModel.dart';
import 'filterTransaction.dart';

class SearchTransactionScreen extends StatefulWidget {
  int? tab;
  SearchTransactionScreen({Key? key, this.tab}) : super(key: key);

  @override
  State<SearchTransactionScreen> createState() =>
      _SearchTransactionScreenState();
}

class _SearchTransactionScreenState extends State<SearchTransactionScreen>
    with TickerProviderStateMixin {
  String? searchKey;
  TextEditingController search = TextEditingController();
  int differenceDays = 0;
  GlobalKey _key = GlobalKey();

  bool isTabVisible = false;
  String _range = '';
  double? tabWidgetPosition = 0.0;
  String startDate = '';
  String orderStatus = '';
  late TabController tabController;
  String endDate = '';
  bool isPageFirst = false;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<String> selectedTimeZone = ['All'];
  String filterDate = '';
  String filter = '';
  int selectedTab = 0;
  TransactionViewModel transactionViewModel = Get.find();
  ScrollController? _scrollController;
  @override
  void initState() {
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
    return Scaffold(
      body: GetBuilder<TransactionViewModel>(
        builder: (controller) {
          if (controller.transactionListApiResponse.status == Status.LOADING ||
              controller.disputeTransactionListApiResponse.status ==
                  Status.LOADING ||
              controller.disputeTransactionListApiResponse.status ==
                  Status.INITIAL ||
              controller.transactionListApiResponse.status == Status.INITIAL) {
            return const Center(child: Loader());
          }

          if (controller.transactionListApiResponse.status == Status.ERROR ||
              controller.disputeTransactionListApiResponse.status ==
                  Status.ERROR) {
            return const SessionExpire();
            // return const Text('Error');
          }

          List<TransactionListResponseModel> transactionListResponse =
              transactionViewModel.transactionListApiResponse.data;
          List<DisputeTransactionResponseModel> disputeTransactionResponse =
              transactionViewModel.disputeTransactionListApiResponse.data;

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
                              hintText: 'ex. customer name,invoice no...'.tr,
                              hintStyle: ThemeUtils.blackRegular.copyWith(
                                  color: ColorsUtils.grey,
                                  fontSize: FontUtils.small)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              search.text.isEmpty
                  ? const SizedBox()
                  : Expanded(
                      child: Column(
                        key: _key,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height20(),
                          timeZone(),
                          height20(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                          widget.tab == 0
                                              ? 'Payments'.tr
                                              : widget.tab == 1
                                                  ? 'Refunds'.tr
                                                  : 'Disputes'.tr,
                                          style: ThemeUtils.blackBold.copyWith(
                                              fontSize: FontUtils.medLarge)),
                                      const Spacer(),
                                      InkWell(
                                          onTap: () async {
                                            await Get.to(
                                                () => FilterTransaction(
                                                      tab: selectedTab,
                                                    ));
                                            initData();
                                          },
                                          child: Image.asset(
                                            Images.filter,
                                            color: Utility
                                                            .transactionFilterStatus ==
                                                        '' &&
                                                    Utility.transactionFilterPaymentMethod ==
                                                        '' &&
                                                    Utility.transactionFilterTransactionModes ==
                                                        '' &&
                                                    Utility.transactionFilterTransactionSources ==
                                                        '' &&
                                                    Utility.refundedFilterStatus ==
                                                        '' &&
                                                    Utility.refundedFilterPaymentMethod ==
                                                        '' &&
                                                    Utility.refundedFilterTransactionModes ==
                                                        ''
                                                ? ColorsUtils.black
                                                : ColorsUtils.accent,
                                            height: 20,
                                            width: 20,
                                          )),
                                    ],
                                  ),
                                ),
                                Text('Search Result'.tr,
                                    style: ThemeUtils.blackBold.copyWith(
                                        fontSize: FontUtils.mediumSmall)),
                                Text(
                                    // '${widget.tab == 0 ? transactionListResponse.length : disputeTransactionResponse.length} Result found',
                                    '${getCount(disputeTransactionResponse, transactionListResponse)} Result found',
                                    style: ThemeUtils.blackSemiBold
                                        .copyWith(fontSize: FontUtils.small)),
                                height20()
                              ],
                            ),
                          ),
                          widget.tab == 2
                              ? disputeTransactionResponse.isEmpty
                                  ? noDataFound()
                                  : disputeTabListData(
                                      disputeTransactionResponse)
                              : transactionListResponse.isEmpty
                                  ? noDataFound()
                                  : tabListData(transactionListResponse),
                          if (transactionViewModel.isPaginationLoading &&
                              isPageFirst)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Loader()),
                            ),
                          if (controller.isPaginationLoading && !isPageFirst)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Loader()),
                            )
                        ],
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  initData() async {
    selectedTab = widget.tab!;
    Utility.transactionFilterSorted = 'created DESC';
    String id = await encryptedSharedPreferences.getString('id');
    String include = selectedTab == 0
        ? '["senderId", "receiverId", "guestuser", "transactionentity", "transactionmode", "transactionstatus", "postransaction", "dispute"]}'
        : '["senderId", "receiverId", "guestuser", "transactionentity", "transactionmode", "transactionstatus", "dispute"]}';
    String transactionStatus = selectedTab == 1
        ? ',{"transactionentityId":{"neq":[17]}},{"transactionstatusId":{"inq":[4,5,7]}}$filterDate${Utility.refundedFilterStatus}${Utility.refundedFilterPaymentMethod}${Utility.refundedFilterTransactionModes}]},'
        : ',{"transactionentityId":{"inq": [1,2,3,5,6,7,8,9,11,12]}},{"transactionstatusId":${Utility.transactionFilterStatus == '' ? '{"inq":[1,2,3,6]}' : '"${Utility.transactionFilterStatus}"'}}$filterDate${Utility.transactionFilterPaymentMethod}${Utility.transactionFilterTransactionModes}${Utility.transactionFilterTransactionSources}]},';
    scrollData(id, transactionStatus, include);
    transactionViewModel.clearResponseList();

    ///api calling.......
    await apiCalling(id, transactionStatus, include);

    if (isPageFirst == false) {
      isPageFirst = true;
    }
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
                        ',{"created":{"between":["$startDate","$endDate"]}}';
                    print('filter date=$filterDate');
                    initData();
                  }
                } else {
                  final now = DateTime.now();
                  endDate =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                  selectedTimeZone.first == 'Today'
                      ? startDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                          .format(DateTime.now())
                      : selectedTimeZone.first == 'Yesterday'
                          ? startDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(
                                  DateTime(now.year, now.month, now.day - 1))
                          : selectedTimeZone.first == 'Week'
                              ? startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                  DateTime(now.year, now.month, now.day - 7))
                              : selectedTimeZone.first == 'Month'
                                  ? startDate = DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(DateTime(
                                          now.year, now.month, now.day - 31))
                                  : selectedTimeZone.first == 'Year'
                                      ? startDate =
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                              .format(DateTime(now.year,
                                                  now.month, now.day - 365))
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
                    color:
                        selectedTimeZone.contains(StaticData().timeZone[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.tabUnselect),
                child: Center(
                  child: Text(
                    StaticData().timeZone[index].tr,
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
          _range = '';
          startDate = '';
          endDate = '';
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
                                  if (dateRangePickerSelectionChangedArgs.value
                                      is PickerDateRange) {
                                    _range =
                                        '${DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                        ' ${DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.endDate ?? dateRangePickerSelectionChangedArgs.value.startDate)}';
                                  }
                                  if (dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          null ||
                                      dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          '') {
                                    '';
                                  } else {
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
                                                'yyyy-MM-dd HH:mm:ss')
                                            .format(DateTime.parse(
                                                '${dateRangePickerSelectionChangedArgs.value.endDate}'));
                                  }

                                  setDialogState(() {});
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                maxDate: DateTime.now(),
                                initialSelectedRange: PickerDateRange(
                                    DateTime.now()
                                        .subtract(const Duration(days: 7)),
                                    DateTime.now()),
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
                                        'SelectedDates: '.tr,
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
                                        startDate = '';
                                        endDate = '';
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

  Expanded disputeTabListData(
      List<DisputeTransactionResponseModel> disputeTransactionResponse) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: disputeTransactionResponse.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (searchKey != null && searchKey != "") {
            if (disputeTransactionResponse[index].transaction != null) {
              if (disputeTransactionResponse[index]
                  .transaction!
                  .invoicenumber
                  .toString()
                  .toLowerCase()
                  .contains(searchKey!.toLowerCase())) {
                return disputeListData(
                    disputeTransactionResponse, index, context);
              }
            } else {
              return SizedBox();
            }
          }
          return SizedBox();
        },
      ),
    );
  }

  Column disputeListData(
      List<DisputeTransactionResponseModel> disputeTransactionResponse,
      int index,
      BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: InkWell(
            onTap: () {
              Utility.isDisputeDetailTransaction = true;
              Get.to(() => TransactionDetailScreen(
                    id: disputeTransactionResponse[index]
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
                        selectedTab == 1 ? Images.refundBack : Images.invoice,
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
                                'ID: ${disputeTransactionResponse[index].transaction!.invoicenumber}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeUtils.blackBold
                                    .copyWith(fontSize: FontUtils.small),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomSheetforDownloadAndRefund(context, index,
                                    disputeTransactionResponse:
                                        disputeTransactionResponse);
                              },
                              child: const Icon(
                                Icons.more_vert,
                              ),
                            )
                          ],
                        ),
                        height10(),
                        disputeTransactionResponse[index].transaction == null
                            ? SizedBox()
                            : Text(
                                disputeTransactionResponse[index]
                                            .transaction!
                                            .transactionmodeId ==
                                        1
                                    ? 'Credit Card'
                                    : disputeTransactionResponse[index]
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
                          '${DateFormat('dd MM yyyy HH:mm:ss').format(DateTime.parse(disputeTransactionResponse[index].transaction!.created.toString()))}',
                          style: ThemeUtils.blackRegular.copyWith(
                              fontSize: FontUtils.small,
                              color: ColorsUtils.grey),
                        ),
                        height10(),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: disputeTransactionResponse[index]
                                            .disputestatus!
                                            .id ==
                                        1
                                    ? ColorsUtils.green
                                    : disputeTransactionResponse[index]
                                                .disputestatus!
                                                .id ==
                                            2
                                        ? ColorsUtils.yellow
                                        : disputeTransactionResponse[index]
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
                                  disputeTransactionResponse[index]
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
                              '${disputeTransactionResponse[index].amount} QAR',
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
  }

  // void bottomSheetforDownloadAndRefund(BuildContext context) {
  //   showModalBottomSheet<void>(
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(15), topRight: Radius.circular(15))),
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setBottomState) {
  //           return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 20),
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: SizedBox(
  //                       width: 70,
  //                       height: 5,
  //                       child: Divider(color: ColorsUtils.border, thickness: 4),
  //                     ),
  //                   ),
  //                 ),
  //                 height20(),
  //                 Row(
  //                   children: [
  //                     Image.asset(
  //                       Images.download,
  //                       width: 25,
  //                       height: 25,
  //                       color: ColorsUtils.black,
  //                     ),
  //                     width20(),
  //                     Text(
  //                       'Download Receipt'.tr,
  //                       style: ThemeUtils.blackSemiBold
  //                           .copyWith(fontSize: FontUtils.mediumSmall),
  //                     )
  //                   ],
  //                 ),
  //                 const Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 5),
  //                   child: Divider(),
  //                 ),
  //                 Row(
  //                   children: [
  //                     Image.asset(
  //                       Images.refund,
  //                       width: 25,
  //                       height: 25,
  //                       color: ColorsUtils.black,
  //                     ),
  //                     width20(),
  //                     Text(
  //                       'Refund'.tr,
  //                       style: ThemeUtils.blackSemiBold
  //                           .copyWith(fontSize: FontUtils.mediumSmall),
  //                     )
  //                   ],
  //                 ),
  //                 height40()
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  void bottomSheetforDownloadAndRefund(BuildContext context, int index,
      {List<TransactionListResponseModel>? transactionListResponse,
      List<DisputeTransactionResponseModel>? disputeTransactionResponse}) {
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
                          transactionListResponse[index].isRefund == false
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Divider(),
                        )
                      : SizedBox(),
                  transactionListResponse[index]
                                  .transactionstatusId
                                  .toString() ==
                              '3' &&
                          selectedTab == 0
                      ? InkWell(
                          onTap: () {
                            if ((transactionListResponse[index].isRefund ==
                                    false &&
                                (transactionListResponse[index]
                                        .priorRefundRequestedAmount <=
                                    0))) {
                              Get.back();
                              Map<String, dynamic> transactionDetail = {
                                'id': transactionListResponse[index]
                                    .invoicenumber,
                                'type': transactionListResponse[index].cardtype,
                                'amount': transactionListResponse[index].amount,
                                'isCredit': transactionListResponse[index]
                                    .transactionmode!
                                    .id,
                                'PriorAmount': transactionListResponse[index]
                                    .priorRefundRequestedAmount
                              };
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
                                                                    '${transactionListResponse[index].refundId == null ? 'NA' : transactionListResponse[index].refundId!.first.transactionstatusId == 4 ? 'Refunded' : transactionListResponse[index].refundId!.first.transactionstatusId == 5 ? 'Pending' : 'Rejected'}')
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
                                                                '${(transactionListResponse[index].refundId == null ? 'NA' : transactionListResponse[index].refundId!.first.invoicenumber ?? "NA")}',
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

  Center noDataFound() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Text('No data found'.tr),
    ));
  }

  Expanded tabListData(
      List<TransactionListResponseModel> transactionListResponse) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: transactionListResponse.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (searchKey != null && searchKey != "") {
            if (transactionListResponse[index]
                .invoicenumber
                .toString()
                .toLowerCase()
                .contains(searchKey!.toLowerCase())) {
              return transactionListData(
                  transactionListResponse, index, context);
            } else if (transactionListResponse[index].invoice != null) {
              if (transactionListResponse[index]
                  .invoice!
                  .clientname
                  .toLowerCase()
                  .contains(searchKey!.toLowerCase())) {
                return transactionListData(
                    transactionListResponse, index, context);
              }
            } else if (transactionListResponse[index].invoice != null) {
              if (transactionListResponse[index]
                  .invoice!
                  .cellno
                  .toLowerCase()
                  .contains(searchKey!.toLowerCase())) {
                return transactionListData(
                    transactionListResponse, index, context);
              }
            } else {
              return SizedBox();
            }
          }

          return SizedBox();
        },
      ),
    );
  }

  // Expanded tabListData(
  //     List<TransactionListResponseModel> transactionListResponse) {
  //   return Expanded(
  //     child: ListView.builder(
  //       padding: EdgeInsets.zero,
  //       shrinkWrap: true,
  //       controller: _scrollController,
  //       itemCount: transactionListResponse.length,
  //       scrollDirection: Axis.vertical,
  //       itemBuilder: (context, index) {
  //         if (searchKey != null && searchKey != "") {
  //           if (transactionListResponse[index]
  //               .invoicenumber
  //               .toString()
  //               .toLowerCase()
  //               .contains(searchKey!.toLowerCase())) {
  //             return transactionListData(
  //                 transactionListResponse, index, context);
  //           } else if (transactionListResponse[index].invoice != null) {
  //             if (transactionListResponse[index]
  //                 .invoice!
  //                 .clientname
  //                 .toLowerCase()
  //                 .contains(searchKey!.toLowerCase())) {
  //               return transactionListData(
  //                   transactionListResponse, index, context);
  //             }
  //           } else if (transactionListResponse[index].invoice != null) {
  //             if (transactionListResponse[index]
  //                 .invoice!
  //                 .cellno
  //                 .toLowerCase()
  //                 .contains(searchKey!.toLowerCase())) {
  //               return transactionListData(
  //                   transactionListResponse, index, context);
  //             }
  //           } else {
  //             return SizedBox();
  //           }
  //         }
  //   return SizedBox();
  // },
  //     ),
  //   );
  // }

  Column transactionListData(
      List<TransactionListResponseModel> transactionListResponse,
      int index,
      BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: InkWell(
            onTap: () {
              Utility.isDisputeDetailTransaction = false;
              Get.to(() => selectedTab == 1
                  ? RefundDetailScreen(
                      id: transactionListResponse[index].id.toString(),
                    )
                  : TransactionDetailScreen(
                      id: transactionListResponse[index].id.toString(),
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
                        selectedTab == 1 ? Images.refundBack : Images.invoice,
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
                                'ID: ${transactionListResponse[index].invoicenumber}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeUtils.blackBold
                                    .copyWith(fontSize: FontUtils.small),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                bottomSheetforDownloadAndRefund(context, index,
                                    transactionListResponse:
                                        transactionListResponse);
                              },
                              child: const Icon(
                                Icons.more_vert,
                              ),
                            )
                          ],
                        ),
                        height10(),
                        transactionListResponse[index].transactionmode == null
                            ? SizedBox()
                            : Text(
                                '${transactionListResponse[index].transactionmode!.name}',
                                style: ThemeUtils.blackRegular
                                    .copyWith(fontSize: FontUtils.small),
                              ),
                        height10(),
                        Text(
                          '${DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(transactionListResponse[index].created))}',
                          style: ThemeUtils.blackRegular.copyWith(
                              fontSize: FontUtils.small,
                              color: ColorsUtils.grey),
                        ),
                        height10(),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: transactionListResponse[index]
                                            .transactionstatusId
                                            .toString() ==
                                        '1'
                                    ? ColorsUtils.yellow
                                    : transactionListResponse[index]
                                                .transactionstatusId
                                                .toString() ==
                                            '2'
                                        ? ColorsUtils.reds
                                        : transactionListResponse[index]
                                                    .transactionstatusId
                                                    .toString() ==
                                                '3'
                                            ? ColorsUtils.green
                                            : transactionListResponse[index]
                                                        .transactionstatusId
                                                        .toString() ==
                                                    '4'
                                                ? ColorsUtils.green
                                                : transactionListResponse[index]
                                                            .transactionstatusId
                                                            .toString() ==
                                                        '5'
                                                    ? ColorsUtils.yellow
                                                    : transactionListResponse[
                                                                    index]
                                                                .transactionstatusId
                                                                .toString() ==
                                                            '6'
                                                        ? ColorsUtils
                                                            .blueBerryPie
                                                        : ColorsUtils.accent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: Text(
                                  transactionListResponse[index]
                                              .transactionstatusId ==
                                          5
                                      ? 'REQUESTED'
                                      : '${transactionListResponse[index].transactionstatus!.name ?? ""}',
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
                                        style: ThemeUtils.blackRegular.copyWith(
                                            fontSize: FontUtils.verySmall))
                                    : SizedBox(),
                                Text(
                                  '${double.parse(transactionListResponse[index].amount.toString()).toStringAsFixed(2)} QAR',
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
    // return Column(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    //       child: InkWell(
    //         onTap: () {
    //           Utility.isDisputeDetailTransaction = false;
    //           Get.to(() => selectedTab == 1
    //               ? RefundDetailScreen(
    //                   id: transactionListResponse[index].id.toString(),
    //                 )
    //               : TransactionDetailScreen(
    //                   id: transactionListResponse[index].id.toString(),
    //                 ));
    //         },
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Container(
    //                 decoration: BoxDecoration(
    //                     color: ColorsUtils.lightBg,
    //                     borderRadius: BorderRadius.circular(15)),
    //                 child: Padding(
    //                   padding: const EdgeInsets.symmetric(
    //                       horizontal: 10, vertical: 10),
    //                   child: Image.asset(
    //                     selectedTab == 1 ? Images.refundBack : Images.invoice,
    //                     width: 20,
    //                     height: 20,
    //                   ),
    //                 )),
    //             width10(),
    //             Expanded(
    //                 flex: 4,
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: [
    //                     Row(
    //                       children: [
    //                         Expanded(
    //                           child: Text(
    //                             'ID: ${transactionListResponse[index].invoicenumber}',
    //                             maxLines: 2,
    //                             overflow: TextOverflow.ellipsis,
    //                             style: ThemeUtils.blackBold
    //                                 .copyWith(fontSize: FontUtils.small),
    //                           ),
    //                         ),
    //                         InkWell(
    //                           onTap: () {
    //                             bottomSheetforDownloadAndRefund(context, index,
    //                                 transactionListResponse:
    //                                     transactionListResponse);
    //                           },
    //                           child: const Icon(
    //                             Icons.more_vert,
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                     height10(),
    //                     transactionListResponse[index].transactionmode == null
    //                         ? SizedBox()
    //                         : Text(
    //                             '${transactionListResponse[index].transactionmode!.name}',
    //                             style: ThemeUtils.blackRegular
    //                                 .copyWith(fontSize: FontUtils.small),
    //                           ),
    //                     height10(),
    //                     Text(
    //                       '${transactionListResponse[index].created}',
    //                       style: ThemeUtils.blackRegular.copyWith(
    //                           fontSize: FontUtils.small,
    //                           color: ColorsUtils.grey),
    //                     ),
    //                     height10(),
    //                     Row(
    //                       children: [
    //                         Container(
    //                           decoration: BoxDecoration(
    //                             color: transactionListResponse[index]
    //                                         .transactionstatusId
    //                                         .toString() ==
    //                                     '1'
    //                                 ? ColorsUtils.yellow
    //                                 : transactionListResponse[index]
    //                                             .transactionstatusId
    //                                             .toString() ==
    //                                         '2'
    //                                     ? ColorsUtils.reds
    //                                     : transactionListResponse[index]
    //                                                 .transactionstatusId
    //                                                 .toString() ==
    //                                             '3'
    //                                         ? ColorsUtils.green
    //                                         : transactionListResponse[index]
    //                                                     .transactionstatusId
    //                                                     .toString() ==
    //                                                 '4'
    //                                             ? ColorsUtils.green
    //                                             : transactionListResponse[index]
    //                                                         .transactionstatusId
    //                                                         .toString() ==
    //                                                     '5'
    //                                                 ? ColorsUtils.yellow
    //                                                 : transactionListResponse[
    //                                                                 index]
    //                                                             .transactionstatusId
    //                                                             .toString() ==
    //                                                         '6'
    //                                                     ? ColorsUtils
    //                                                         .blueBerryPie
    //                                                     : ColorsUtils.accent,
    //                             borderRadius: BorderRadius.circular(15),
    //                           ),
    //                           child: Padding(
    //                             padding: const EdgeInsets.symmetric(
    //                                 vertical: 2, horizontal: 10),
    //                             child: Text(
    //                               '${transactionListResponse[index].transactionstatus!.name ?? ""}',
    //                               // transactionListResponse[index]
    //                               //             .transactionstatusId
    //                               //             .toString() ==
    //                               //         '1'
    //                               //     ? 'Inprogress'
    //                               //     : transactionListResponse[index]
    //                               //                 .transactionstatusId
    //                               //                 .toString() ==
    //                               //             '2'
    //                               //         ? 'Failed'
    //                               //         : transactionListResponse[index]
    //                               //                     .transactionstatusId
    //                               //                     .toString() ==
    //                               //                 '3'
    //                               //             ? 'Success'
    //                               //             : transactionListResponse[
    //                               //                             index]
    //                               //                         .transactionstatusId
    //                               //                         .toString() ==
    //                               //                     '4'
    //                               //                 ? 'Refund'
    //                               //                 : transactionListResponse[
    //                               //                                 index]
    //                               //                             .transactionstatusId
    //                               //                             .toString() ==
    //                               //                         '5'
    //                               //                     ? 'Pending'
    //                               //                     : transactionListResponse[
    //                               //                                     index]
    //                               //                                 .transactionstatusId
    //                               //                                 .toString() ==
    //                               //                             '6'
    //                               //                         ? 'Onhold'
    //                               //                         : 'Rejected',
    //                               style: ThemeUtils.blackRegular.copyWith(
    //                                   fontSize: FontUtils.verySmall,
    //                                   color: ColorsUtils.white),
    //                             ),
    //                           ),
    //                         ),
    //                         const Spacer(),
    //                         Column(
    //                           children: [
    //                             selectedTab == 1
    //                                 ? Text('Refund Amount'.tr,
    //                                     style: ThemeUtils.blackRegular.copyWith(
    //                                         fontSize: FontUtils.verySmall))
    //                                 : SizedBox(),
    //                             Text(
    //                               '${transactionListResponse[index].amount} QAR',
    //                               style: ThemeUtils.blackBold.copyWith(
    //                                   fontSize: FontUtils.mediumSmall,
    //                                   color: ColorsUtils.accent),
    //                             ),
    //                           ],
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ))
    //           ],
    //         ),
    //       ),
    //     ),
    //     const Divider()
    //   ],
    // );
  }

  Future<void> apiCalling(
      String id, String transactionStatus, String include) async {
    await transactionViewModel.disputeTransactionList(
        id: id,
        transactionStatus: '$filterDate]},',
        filter: Utility.transactionFilterSorted,
        include:
            '["senderId","receiverId","transaction", "disputestatus", "disputetype"]}');
    await transactionViewModel.transactionList(
        id: id,
        transactionStatus: transactionStatus,
        filter: Utility.transactionFilterSorted,
        include: include);
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
              transactionStatus: transactionStatus,
              filter: Utility.transactionFilterSorted,
              include: include);
        }
      });
  }

  int getCount(List<DisputeTransactionResponseModel> dres,
      List<TransactionListResponseModel> tres) {
    int count = 0;

    count = tres.fold(
        0,
        (p, e) =>
            p +
            ((e.invoicenumber as String)
                    .toLowerCase()
                    .contains(searchKey!.toLowerCase())
                ? 1
                : 0));

    tres.forEach((e) {
      //   if ((e.invoicenumber as String)
      //       .toLowerCase()
      //       .contains(searchKey!.toLowerCase())) {
      //     count++;
      //
      //   } else
      if (e.invoice != null) {
        // if ((e.invoice!.cellno as String)
        //     .toLowerCase()
        //     .contains(searchKey!.toLowerCase())) {
        //   count++;
        // }
        count = tres.fold(
            0,
            (p, e) =>
                p +
                ((e.invoicenumber as String)
                        .toLowerCase()
                        .contains(searchKey!.toLowerCase())
                    ? 1
                    : 0));
      } else if (e.invoice != null) {
        // if ((e.invoice!.clientname as String)
        //     .toLowerCase()
        //     .contains(searchKey!.toLowerCase())) {
        //   count++;
        // }
        count = tres.fold(
            0,
            (p, e) =>
                p +
                ((e.invoice!.clientname as String)
                        .toLowerCase()
                        .contains(searchKey!.toLowerCase())
                    ? 1
                    : 0));
      }
    });

    return count;
  }
}
