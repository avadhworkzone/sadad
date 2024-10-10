// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/pospaymentResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/home.dart';
import 'package:sadad_merchat_app/view/pos/transaction/dispute/filterPosDisputesTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/filterPosPaymentTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/filterPosRefundTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/rental/filterPosRentalTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/dispute/posDisputeTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/posRefundTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/rental/posRentalTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/posTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'posTransacionSearchScreen.dart';

class PosTransactionListScreen extends StatefulWidget {
  String? terminalFilter;
  String? selectedTimeZone;
  String? startDate;
  int? selectedTab;
  String? endDate;
  bool? isFromPosRental;
  PosTransactionListScreen(
      {Key? key,
      this.terminalFilter,
      this.selectedTimeZone,
      this.startDate,
      this.selectedTab,
      this.isFromPosRental,
      this.endDate})
      : super(key: key);

  @override
  State<PosTransactionListScreen> createState() =>
      _PosTransactionListScreenState();
}

class _PosTransactionListScreenState extends State<PosTransactionListScreen>
    with TickerProviderStateMixin {
  String _range = '';
  bool isPageFirst = false;
  String endDate = '';
  String startDate = '';
  String filterDate = '';
  String rentalFilterDate = '';
  int differenceDays = 0;
  List<String> selectedTimeZone = ['All'];
  late TabController tabController;
  ScrollController? _scrollController;
  int selectedTab = 3;
  String? id = '';
  String? name = '';
  String? date = '';
  String? payment = '';
  String? amount = '';
  String? img = '';
  String? tranStatusId = '';
  PosTransactionViewModel posTransactionViewModel = Get.find();
  List<PosPaymentResponseModel>? posPaymentRes;
  List<PosDisputesResponseModel>? posDisputesRes;
  PosRentalResponseModel? posRentalRes;
  PosPaymentCountResponseModel? posPaymentCountRes;
  PosDisputesCountResponseModel? posDisputeCountRes;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  String? transactionEntityId;
  String? transactionStatus;
  String? include;
  String rentalFilter = '';
  ConnectivityViewModel connectivityViewModel = Get.find();
  @override
  void initState() {
    print("Selected Tab ===${widget.selectedTab}");
    selectedTab = widget.selectedTab ?? 0;
    startDate = widget.startDate ?? '';
    endDate = widget.endDate ?? '';
    selectedTimeZone.clear();
    selectedTimeZone.add(widget.selectedTimeZone == ''
        ? 'All'
        : widget.selectedTimeZone ?? 'All');

    if (widget.startDate != '' && widget.endDate != '') {
      filterDate = selectedTimeZone.first == 'All'
          ? ""
          : ',{"created":{"between":["${startDate}","${endDate}"]}}';

      rentalFilterDate = selectedTimeZone.first == 'All'
          ? ""
          : '&filter[where][date]=custom&filter[where][between][0]=${startDate}&filter[where][between][1]=${endDate}';
    }

    connectivityViewModel.startMonitoring();
    posTransactionViewModel.setTransactionInit();
    if (widget.terminalFilter != null &&
        widget.terminalFilter!.isNotEmpty &&
        widget.terminalFilter != '') {
      print("Terminal Filter not null==>${widget.terminalFilter}");
      setState(() {
        selectedTimeZone.clear();
        selectedTimeZone.add('Today');
        startDate =
            intl.DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now());
        endDate = intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now());
        filterDate = ',{"created":{"between":["$startDate","$endDate"]}}';
        rentalFilterDate =
            '&filter[where][date]=custom&filter[where][between][0]=$startDate&filter[where][between][1]=$endDate';
      });
      // widget.terminalFilter =
      //     '${widget.terminalFilter}{"transactionstatusId":"3"}';
    }
    // selectedTimeZone.clear();
    // selectedTimeZone.add('Today');
    // startDate = intl.DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now());
    // endDate = intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now());
    // filterDate = ',{"created":{"between":["$startDate","$endDate"]}}';
    initData();
    tabController = TabController(
        length: 4,
        vsync: this,
        initialIndex: widget.isFromPosRental == true ? 3 : 0);
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
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            body: Column(
          children: [topRow(), timeZone(), tabBar(), bottomListView()],
        ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                posTransactionViewModel.setTransactionInit();
                tabController = TabController(length: 4, vsync: this);
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
              posTransactionViewModel.setTransactionInit();
              tabController = TabController(length: 4, vsync: this);
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

  Column topRow() {
    return Column(
      children: [
        height60(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    if (widget.terminalFilter == null ||
                        widget.terminalFilter == '') {
                      Get.offAll(() => HomeScreen());
                    } else {
                      Get.offAll(() => HomeScreen());
                      //Get.back();
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              const Spacer(),
              Text('Transactions'.tr,
                  style: ThemeUtils.blackBold.copyWith(
                    fontSize: FontUtils.medLarge,
                  )),
              const Spacer(),
              InkWell(
                onTap: () async {
                  await Get.to(() => PosTransactionSearchScreen(
                        selectedTab: selectedTab,
                        terminalFilter: widget.terminalFilter,
                      ));
                  initData();
                },
                child: InkWell(
                    child: Image.asset(
                  Images.search,
                  height: 20,
                  width: 20,
                )),
              ),
            ],
          ),
        ),
        height20()
      ],
    );
  }

  Widget bottomListView() {
    return Expanded(child: GetBuilder<PosTransactionViewModel>(
      builder: (controller) {
        if (selectedTab == 0) {
          if (controller.posPaymentListApiResponse.status == Status.LOADING ||
              controller.posPaymentListApiResponse.status == Status.INITIAL ||
              controller.posDisputesListApiResponse.status == Status.LOADING ||
              controller.posRentalListApiResponse.status == Status.LOADING) {
            return const Center(
              child: Loader(),
            );
          }
        } else {
          if (controller.posPaymentListApiResponse.status == Status.LOADING ||
              controller.posDisputeCountApiResponse.status == Status.LOADING ||
              controller.posDisputesListApiResponse.status == Status.LOADING ||
              controller.posRentalListApiResponse.status == Status.LOADING) {
            return const Center(
              child: Loader(),
            );
          }
        }

        if (controller.posPaymentListApiResponse.status == Status.ERROR ||
            controller.posDisputesListApiResponse.status == Status.ERROR ||
            controller.posPaymentCountApiResponse.status == Status.ERROR ||
            controller.posDisputeCountApiResponse.status == Status.ERROR ||
            controller.posRentalListApiResponse.status == Status.ERROR) {
          // return const Center(
          //   child: Text('Error'),
          // );
          return SessionExpire();
        }
        posPaymentRes = posTransactionViewModel.posPaymentListApiResponse.data;
        posDisputesRes =
            posTransactionViewModel.posDisputesListApiResponse.data;
        posRentalRes = posTransactionViewModel.posRentalListApiResponse.data;
        posPaymentCountRes =
            posTransactionViewModel.posPaymentCountApiResponse.data;
        posDisputeCountRes =
            posTransactionViewModel.posDisputeCountApiResponse.data;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  widget.terminalFilter == null || widget.terminalFilter == ''
                      ? customSmallSemiText(
                          title:
                              '${selectedTab == 2 ? posDisputeCountRes!.count ?? '0' : selectedTab == 3 ? posRentalRes == null ? '0' : posRentalRes!.totalinvoices ?? "0" : posPaymentCountRes == null ? '0' : posPaymentCountRes!.count ?? "0"} ${selectedTab == 0 ? 'Payments'.tr : selectedTab == 1 ? 'Refunds'.tr : selectedTab == 2 ? 'Disputes'.tr : 'Rental Payments'.tr}',
                          color: ColorsUtils.black)
                      : SizedBox(),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      print("Start Date === ${startDate}");
                      print("End Date === ${endDate}");
                      print("Selected TimeZone === ${selectedTimeZone.first}");

                      selectedTab == 0
                          ? await Get.to(() => FilterPosPaymentScreen(
                              startDate: startDate,
                              endDate: endDate,
                              selectedTimeZone: selectedTimeZone.first,
                              isTerminal: widget.terminalFilter))
                          : selectedTab == 1
                              ? await Get.to(
                                  () => const FilterPosRefundScreen())
                              : selectedTab == 2
                                  ? await Get.to(
                                      () => const FilterPosDisputesScreen())
                                  : await Get.to(() =>
                                      FilterRentalPosTransaction(
                                        startDate: startDate,
                                        endDate: endDate,
                                        selectedTimeZone:
                                            selectedTimeZone.first,
                                        terminalId: widget.terminalFilter ?? '',
                                      ));
                      if (selectedTab == 1 || selectedTab == 2) {
                        initData();
                      }
                      setState(() {});

                      // widget.terminalFilter = '';
                    },
                    child: Image.asset(Images.filter,
                        height: 20,
                        color: selectedTab == 2
                            ?

                            ///pos transaction
                            Utility.posDisputeTransactionStatusFilter.isNotEmpty ||
                                    Utility
                                        .posDisputeTransactionTypeFilter.isNotEmpty ||
                                    Utility.posPaymentTerminalSelectionFilter.length >
                                        0
                                ? ColorsUtils.accent
                                : ColorsUtils.black
                            : selectedTab == 3
                                ? Utility.posRentalPaymentStatusFilter.isNotEmpty ||
                                        Utility.posPaymentTerminalSelectionFilter.length >
                                            0 ||
                                        Utility.posPaymentTerminalSelectionFilter.length >
                                            0
                                    ? ColorsUtils.accent
                                    : ColorsUtils.black
                                : selectedTab == 0
                                    ? Utility.posPaymentTransactionStatusFilter
                                                .isNotEmpty ||
                                            Utility.posPaymentCardEntryTypeFilter
                                                .isNotEmpty ||
                                            Utility.posPaymentTransactionTypeFilter
                                                .isNotEmpty ||
                                            Utility.posPaymentPaymentMethodFilter
                                                .isNotEmpty ||
                                            Utility
                                                .posPaymentTransactionModesFilter
                                                .isNotEmpty ||
                                            Utility.posPaymentTransactionTypeTerminalFilter
                                                    .length >
                                                0 ||
                                            Utility.posPaymentTerminalSelectionFilter
                                                    .length >
                                                0
                                        ? ColorsUtils.accent
                                        : ColorsUtils.black
                                    : selectedTab == 1
                                        ? Utility.posRefundTransactionModesFilter
                                                    .isNotEmpty ||
                                                Utility
                                                    .posRefundCardEntryTypeFilter
                                                    .isNotEmpty ||
                                                Utility
                                                    .posRefundPaymentMethodFilter
                                                    .isNotEmpty ||
                                                Utility
                                                    .posRefundTransactionStatusFilter
                                                    .isNotEmpty ||
                                                Utility.posPaymentTerminalSelectionFilter
                                                        .length >
                                                    0
                                            ? ColorsUtils.accent
                                            : ColorsUtils.black
                                        : ColorsUtils.black),
                  ),
                ],
              ),
            ),
            if (selectedTab == 0)
              posPaymentRes!.isEmpty ? noDataFound() : ListofData(),
            if (selectedTab == 1)
              posPaymentRes!.isEmpty ? noDataFound() : ListofData(),
            if (selectedTab == 2)
              posDisputesRes!.isEmpty ? noDataFound() : ListofData(),
            if (selectedTab == 3)
              // ignore: prefer_is_empty
              posTransactionViewModel.rentalResponse.length == 0
                  ? noDataFound()
                  : ListofData(),
            if (posTransactionViewModel.isPaginationLoading && isPageFirst)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: Center(child: Loader()),
              ),
            if (posTransactionViewModel.isPaginationLoading && !isPageFirst)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: Center(child: Loader()),
              ),
          ],
        );
      },
    ));
  }

  Center noDataFound() => Center(child: Text('No data found'.tr));

  Expanded ListofData() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: selectedTab == 2
            ? posDisputesRes!.length
            : selectedTab == 3
                ? posTransactionViewModel.rentalResponse.length
                : posPaymentRes!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          allListValue(index);
          return Column(
            children: [
              InkWell(
                onTap: () {
                  // print(
                  //     "posPaymentRes id == ${posPaymentRes![index].id.toString()}");
                  selectedTab == 0
                      ? Get.to(() => PosTransactionDetailScreen(
                          id: posPaymentRes![index].id.toString()))
                      : selectedTab == 1
                          ? Get.to(() => PosRefundTransactionScreen(
                                id: posPaymentRes![index].id.toString(),
                              ))
                          : selectedTab == 2
                              ? Get.to(() => PosDisputeTransactionScreen(
                                    id: posDisputesRes![index].id.toString(),
                                  ))
                              : Get.to(() => PosRentalTransactionScreen(
                                    id: posTransactionViewModel
                                        .rentalResponse[index].id
                                        .toString(),
                                  ));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Get.height * 0.07,
                        width: Get.width * 0.15,
                        decoration: BoxDecoration(
                          color: ColorsUtils.createInvoiceContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Image.asset(img!, height: 30, width: 30)),
                      ),
                      width10(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                customSmallMedBoldText(
                                    color: ColorsUtils.black, title: 'ID: $id'),
                                const Spacer(),
                                // selectedTab == 0
                                //     ? Icon(Icons.more_vert)
                                //     : SizedBox(),
                              ],
                            ),
                            height5(),
                            customSmallSemiText(
                                title: '$name', color: ColorsUtils.black),
                            height10(),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: customSmallSemiText(
                                  title: '$date', color: ColorsUtils.grey),
                            ),
                            height10(),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: selectedTab == 3
                                        ? payment == 'Paid'
                                            ? ColorsUtils.green
                                            : payment == 'Unpaid'
                                                ? ColorsUtils.yellow
                                                : ColorsUtils.red
                                        : selectedTab == 2
                                            ? tranStatusId == '1'
                                                ? ColorsUtils.green
                                                : tranStatusId == '2'
                                                    ? ColorsUtils.yellow
                                                    : ColorsUtils.accent
                                            : tranStatusId == '1'
                                                ? ColorsUtils.yellow
                                                : tranStatusId == '2'
                                                    ? ColorsUtils.reds
                                                    : tranStatusId == '3'
                                                        ? ColorsUtils.green
                                                        : tranStatusId == '4'
                                                            ? ColorsUtils.green
                                                            : tranStatusId ==
                                                                    '5'
                                                                ? ColorsUtils
                                                                    .yellow
                                                                : tranStatusId ==
                                                                        '6'
                                                                    ? ColorsUtils
                                                                        .blueBerryPie
                                                                    : ColorsUtils
                                                                        .accent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    child: customVerySmallSemiText(
                                        color: ColorsUtils.white,
                                        title: selectedTab == 1
                                            ? payment == 'PENDING'
                                                ? 'REQUESTED'
                                                : payment
                                            : '$payment'),
                                  ),
                                ),
                                // selectedTab == 0
                                //     ? Row(
                                //         children: [
                                //           const Padding(
                                //             padding: EdgeInsets.symmetric(
                                //                 horizontal: 10),
                                //             child: SizedBox(
                                //                 width: 1,
                                //                 height: 25,
                                //                 child: VerticalDivider()),
                                //           ),
                                //           customVerySmallSemiText(
                                //               title: 'Rental'.tr,
                                //               color: ColorsUtils.black),
                                //           const Padding(
                                //             padding: EdgeInsets.symmetric(
                                //                 horizontal: 10),
                                //             child: SizedBox(
                                //                 width: 1,
                                //                 height: 25,
                                //                 child: VerticalDivider()),
                                //           ),
                                //         ],
                                //       )
                                //     : SizedBox(),
                                const Spacer(),
                                Column(
                                  children: [
                                    selectedTab == 1
                                        ? customVerySmallSemiText(
                                            color: ColorsUtils.black,
                                            title: 'Refund Amount'.tr)
                                        : const SizedBox(),
                                    customSmallMedBoldText(
                                        title: '$amount QAR',
                                        color: ColorsUtils.accent),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Divider(),
              )
            ],
          );
        },
      ),
    );
  }

  void allListValue(int index) {
    if (selectedTab == 2) {
      id = '${posDisputesRes![index].disputeId ?? 'NA'}';
      name = '${posDisputesRes![index].disputetype!.name ?? "NA"}';
      date = '${posDisputesRes![index].created ?? "NA"}';

      //${DateFormat('dd MM yyyy, HH:mm:ss').format(DateTime.parse(posDisputesRes![index].created.toString()))}
      payment = '${posDisputesRes![index].disputestatus!.name ?? 'NA'}';
      tranStatusId = '${posDisputesRes![index].disputestatus!.id}';
      amount = '${posDisputesRes![index].amount ?? "0"}';
      img = Images.dispute;
    } else if (selectedTab == 3) {
      log('date is ${posTransactionViewModel.rentalResponse[index].created}');
      id = '${posTransactionViewModel.rentalResponse[index].invoiceno ?? "NA"}';

      name = 'Pos Rental';
      date = intl.DateFormat('dd MMM yyyy, HH:ss:mm').format(DateTime.parse(
          posTransactionViewModel.rentalResponse[index].created.toString()));
      payment = posTransactionViewModel.rentalResponse[index].invoicestatus ==
              null
          ? "NA"
          : '${posTransactionViewModel.rentalResponse[index].invoicestatus!.name! ?? "NA"}';
      tranStatusId = posTransactionViewModel
                  .rentalResponse[index].transaction ==
              null
          ? "NA"
          : '${posTransactionViewModel.rentalResponse[index].transaction!.transactionstatus!.id ?? "NA"}';
      // print('0-0--${posTransactionViewModel.rentalResponse[index].transaction!.transactionstatus!.id}');

      amount =
          '${posTransactionViewModel.rentalResponse[index].grossamount ?? "0"}';
      img = Images.posAccent;
    } else {
      id = '${posPaymentRes![index].invoicenumber ?? 'NA'}';
      if (posPaymentRes![index].postransaction!.is_tokenization == 'Yes' ||
          posPaymentRes![index].postransaction!.cardType == 'TOKEN') {
        name = "Wallet - Contactless";
      } else {
        var cardPaymentType =
            posPaymentRes![index].postransaction!.cardPaymentType ?? " ";
        if (cardPaymentType.toString().length > 0) {
          cardPaymentType = cardPaymentType.replaceRange(
              0, 1, cardPaymentType[0].toUpperCase());
        }
        var cardType = posPaymentRes![index].postransaction!.cardType ?? " ";
        if (cardType.toString().length > 0) {
          cardType = cardType.replaceRange(0, 1, cardType[0].toUpperCase());
        }
        if (cardType == "Chip") {
          //print("object");
        }
        cardPaymentType == ""
            ? name = '$cardType'
            : name = '$cardPaymentType Card - $cardType';
      }
      // name =
      //     '${posPaymentRes![index].postransaction!.cardPaymentType ?? ""} ${posPaymentRes![index].postransaction!.paymentMethod ?? ""} - ${posPaymentRes![index].postransaction!.cardType ?? ""} ';
      date = intl.DateFormat('dd MMM yyyy, HH:mm:ss')
          .format(DateTime.parse(posPaymentRes![index].created.toString()));
      payment = '${posPaymentRes![index].transactionstatus!.name ?? 'NA'}';
      // print('0-0--${posPaymentRes![index].transactionstatus!.id}');
      tranStatusId = '${posPaymentRes![index].transactionstatus!.id}';
      amount = '${posPaymentRes![index].amount ?? "0"}';
      img = selectedTab == 0
          ? posPaymentRes![index].cardtype == 'MASTERCARD'
              ? Images.masterCard
              : posPaymentRes![index].cardtype == 'VISA'
                  ? Images.visaCard
                  : posPaymentRes![index].cardtype == 'GOOGLE PAY'
                      ? Images.googlePay
                      : posPaymentRes![index].cardtype == 'APPLE PAY'
                          ? Images.applePay
                          : posPaymentRes![index].cardtype == 'APPLE PAY'
                              ? Images.applePay
                              : posPaymentRes![index].cardtype ==
                                      'AMERICAN EXPRESS'
                                  ? Images.amex
                                  : posPaymentRes![index].cardtype == 'UPI'
                                      ? Images.upi
                                      : posPaymentRes![index].cardtype == 'JCB'
                                          ? Images.jcb
                                          : posPaymentRes![index].cardtype ==
                                                  'SADAD PAY'
                                              ? Images.sadadWalletPay
                                              : posPaymentRes![index]
                                                          .cardtype ==
                                                      'NAPS'
                                                  ? Images.napsImage
                                                  : Images.mobilePay

          //icon == 'MASTERCARD'
          //                 ? Images.masterCard
          //                 : icon == 'VISA'
          //                     ? Images.visaCard
          //                     : icon == 'GOOGLE PAY'
          //                         ? Images.googlePay
          //                         : icon == 'APPLE PAY'
          //                             ? Images.applePay
          //                             : icon == 'AMERICAN EXPRESS'
          //                                 ? Images.amex
          //                                 : icon == 'UPI'
          //                                     ? Images.upi
          //                                     : icon == 'JCB'
          //                                         ? Images.jcb
          //                                         : Images.sadadWalletPay,
          : selectedTab == 1
              ? Images.refundBack
              : selectedTab == 2
                  ? Images.dispute
                  : Images.posAccent;
    }
    // 'MASTERCARD'
    //     ? Images.masterCard
    //     : icon == 'VISA'
    //     ? Images.visaCard
    //     : icon == 'GOOGLE PAY'
    //     ? Images.googlePay
    //     : icon == 'APPLE PAY'
    //     ? Images.applePay
    //     : Images.sadadWalletPay
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
            if (selectedTab != value) {
              Utility.posPaymentTerminalSelectionFilter = [];
              Utility.holdPosPaymentTerminalSelectionFilter = [];
            }
            selectedTab = value;

            initData();
            setState(() {});
          },
          labelStyle:
              ThemeUtils.blackSemiBold.copyWith(color: ColorsUtils.white),
          unselectedLabelColor: ColorsUtils.white,
          labelColor: ColorsUtils.white,
          labelPadding: const EdgeInsets.all(3),
          tabs: [
            Tab(text: "Payments".tr),
            Tab(text: "Refunds".tr),
            Tab(text: "Disputes".tr),
            Tab(text: "POS Rental".tr),
          ],
        ));
  }

  // Future<void> datePicker(BuildContext context) async {
  //   await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         _range = '';
  //         startDate = '';
  //         endDate = '';
  //         return StatefulBuilder(
  //           builder: (context, setDialogState) {
  //             return Dialog(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12.0)),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(20),
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                           color: ColorsUtils.white,
  //                           borderRadius: BorderRadius.circular(10),
  //                           border: Border.all(color: ColorsUtils.border)),
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(20),
  //                         child: Column(
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: <Widget>[
  //                             Text(
  //                               'Select Dates'.tr,
  //                               style: ThemeUtils.blackBold.copyWith(
  //                                   color: ColorsUtils.accent,
  //                                   fontSize: FontUtils.medium),
  //                             ),
  //                             height20(),
  //                             SfDateRangePicker(
  //                               onSelectionChanged:
  //                                   (dateRangePickerSelectionChangedArgs) {
  //                                 if (dateRangePickerSelectionChangedArgs.value
  //                                     is PickerDateRange) {
  //                                   _range =
  //                                       '${intl.DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
  //                                       ' ${intl.DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.endDate ?? dateRangePickerSelectionChangedArgs.value.startDate)}';
  //                                 }
  //                                 if (dateRangePickerSelectionChangedArgs
  //                                             .value.endDate ==
  //                                         null ||
  //                                     dateRangePickerSelectionChangedArgs
  //                                             .value.endDate ==
  //                                         '') {
  //                                   '';
  //                                 } else {
  //                                   final difference =
  //                                       dateRangePickerSelectionChangedArgs
  //                                           .value.endDate
  //                                           .difference(
  //                                               dateRangePickerSelectionChangedArgs
  //                                                   .value.startDate)
  //                                           .inDays;
  //                                   differenceDays =
  //                                       int.parse(difference.toString());
  //                                   print('days is :::$difference');
  //                                 }
  //                                 if (differenceDays >= 364) {
  //                                   Get.snackbar('warning'.tr,
  //                                       'Please select range in 12 month'.tr);
  //                                   startDate = '';
  //                                   endDate = '';
  //                                 } else {
  //                                   startDate = intl.DateFormat(
  //                                           'yyyy-MM-dd HH:mm:ss')
  //                                       .format(DateTime.parse(
  //                                           '${dateRangePickerSelectionChangedArgs.value.startDate}'));
  //
  //                                   dateRangePickerSelectionChangedArgs
  //                                                   .value.endDate ==
  //                                               null ||
  //                                           dateRangePickerSelectionChangedArgs
  //                                                   .value.endDate ==
  //                                               ''
  //                                       ? ''
  //                                       : endDate = intl.DateFormat(
  //                                               'yyyy-MM-dd 23:59:59')
  //                                           .format(DateTime.parse(
  //                                               '${dateRangePickerSelectionChangedArgs.value.endDate}'));
  //                                 }
  //
  //                                 setDialogState(() {});
  //                               },
  //                               selectionMode:
  //                                   DateRangePickerSelectionMode.range,
  //                               maxDate: DateTime.now(),
  //                               initialSelectedRange: PickerDateRange(
  //                                   DateTime.now()
  //                                       .subtract(const Duration(days: 7)),
  //                                   DateTime.now()),
  //                             ),
  //                             Container(
  //                               decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   border:
  //                                       Border.all(color: ColorsUtils.border)),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(10.0),
  //                                 child: Column(
  //                                   children: [
  //                                     Text(
  //                                       'SelectedDates: '.tr,
  //                                       style: ThemeUtils.blackBold.copyWith(
  //                                           fontSize: FontUtils.verySmall),
  //                                     ),
  //                                     Text(
  //                                       _range,
  //                                       style: ThemeUtils.blackBold.copyWith(
  //                                           fontSize: FontUtils.verySmall),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             height20(),
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: InkWell(
  //                                     onTap: () {
  //                                       Get.back();
  //                                     },
  //                                     child: buildContainerWithoutImage(
  //                                         color: ColorsUtils.accent,
  //                                         text: 'Select'.tr),
  //                                   ),
  //                                 ),
  //                                 width10(),
  //                                 Expanded(
  //                                   child: InkWell(
  //                                     onTap: () {
  //                                       Get.back();
  //                                       startDate = '';
  //                                       endDate = '';
  //                                     },
  //                                     child: buildContainerWithoutImage(
  //                                         color: ColorsUtils.accent,
  //                                         text: 'Cancel'.tr),
  //                                   ),
  //                                 ),
  //                               ],
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }
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

  Widget timeZone() {
    return Column(
      children: [
        SizedBox(
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
                    selectedTimeZone.add(StaticData().timeZone[index]);
                    print('time is $selectedTimeZone');
                    // endDate = '';
                    // startDate = '';
                    if (selectedTimeZone.contains('Custom')) {
                      // _selectDate(context);

                      await datePicker(context);
                      setState(() {});
                      print('dates $startDate$endDate');

                      if (startDate != '' && endDate != '') {
                        filterDate =
                            ',{"created":{"between":["$startDate","$endDate"]}}';
                        print('selected date is $filterDate ');
                        rentalFilterDate =
                            '&filter[where][date]=custom&filter[where][between][0]=$startDate&filter[where][between][1]=$endDate';
                        initData();
                      }
                    } else {
                      final now = DateTime.now();

                      endDate = selectedTimeZone.first == 'Yesterday'
                          ? intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(
                              DateTime(
                                  now.year, now.month, now.day - 1, 23, 59, 59))
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
                                  ? startDate = intl.DateFormat('yyyy-MM-dd HH:mm:ss')
                                      .format(DateTime(now.year, now.month,
                                          now.day - 6, 00, 00, 00))
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

                      rentalFilterDate = selectedTimeZone.first == 'All'
                          ? ""
                          : '&filter[where][date]=custom&filter[where][between][0]=$startDate&filter[where][between][1]=$endDate';
                      print('filterDate::$filterDate');
                      print('$selectedTimeZone');

                      setState(() {});
                      initData();
                    }
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
                            ? selectedTimeZone.contains('Custom') &&
                                    startDate.isNotEmpty &&
                                    endDate.isNotEmpty
                                ? '${intl.DateFormat('dd-MM-yyyy').format(DateTime.parse(startDate)) + '-' + intl.DateFormat('dd-MM-yyyy').format(DateTime.parse(endDate))}'
                                : StaticData().timeZone[index].tr
                            : StaticData().timeZone[index].tr,
                        style: ThemeUtils.maroonBold.copyWith(
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
        ),
        height20(),
      ],
    );
  }

  void initData() async {
    String userId = await encryptedSharedPreferences.getString('id');
    filterOfApi();
    posTransactionViewModel.clearResponseList();
    scrollData(userId);
    await apiCalling(userId);
  }

  Future<void> apiCalling(String userId) async {
    print('widget.terminalFilter==>${widget.terminalFilter}');
    if (selectedTab == 2) {
      await posTransactionViewModel.disputesList(
          id: userId,
          isLoading: true,
          transactionStatus: transactionStatus,
          terminalFilter: (Utility.posPaymentTerminalSelectionFilter.length >
                      0 ||
                  Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
              ? ',{"terminalId":"${'${Utility.posPaymentTerminalSelectionFilter}'.replaceAll('[', '').replaceAll(']', '').removeAllWhitespace}"}'
              : widget.terminalFilter == null || widget.terminalFilter == ''
                  ? ""
                  : ',{"terminalId":"${widget.terminalFilter}"}',
          include: include,
          transactionEntityId: transactionEntityId);
      await posTransactionViewModel.disputeCount(
          id: userId,
          transactionStatus: transactionStatus,
          terminalFilter: (Utility.posPaymentTerminalSelectionFilter.length >
                      0 ||
                  Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
              ? ',{"terminalId":"${'${Utility.posPaymentTerminalSelectionFilter}'.replaceAll('[', '').replaceAll(']', '').removeAllWhitespace}"}'
              : widget.terminalFilter == null || widget.terminalFilter == ''
                  ? ""
                  : ',{"terminalId":"${widget.terminalFilter}"}',
          transactionEntityId: transactionEntityId);
    } else if (selectedTab == 3) {
      await posTransactionViewModel.rentalList(
          isLoading: true,
          filter:
              '$rentalFilter${(Utility.posPaymentTerminalSelectionFilter.length > 0 || Utility.posPaymentTerminalSelectionFilter.isNotEmpty) ? '&filter[where][terminalId]=${Utility.posPaymentTerminalSelectionFilter.length > 1 ? Utility.posPaymentTerminalSelectionFilter : "${Utility.posPaymentTerminalSelectionFilter.first}"}' : widget.terminalFilter == null || widget.terminalFilter == '' ? "" : '&filter[where][terminalId]=[${widget.terminalFilter}]'}');
    } else {
      await posTransactionViewModel.paymentCount(
          id: userId,
          transactionStatus: transactionStatus,
          terminalFilter: (Utility.posPaymentTerminalSelectionFilter.length >
                      0 ||
                  Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
              ? ',{"terminalId":"${'${Utility.posPaymentTerminalSelectionFilter}'.replaceAll('[', '').replaceAll(']', '').removeAllWhitespace}"}'
              : widget.terminalFilter == null || widget.terminalFilter == ''
                  ? ""
                  : ',{"terminalId":"${widget.terminalFilter}"}',
          transactionEntityId: transactionEntityId);
      await posTransactionViewModel.paymentList(
          id: userId,
          isLoading: true,
          transactionStatus: transactionStatus,
          include: include,
          terminalFilter: (Utility.posPaymentTerminalSelectionFilter.length >
                      0 ||
                  Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
              ? ',{"terminalId":"${'${Utility.posPaymentTerminalSelectionFilter}'.replaceAll('[', '').replaceAll(']', '').removeAllWhitespace}"}'
              : widget.terminalFilter == null || widget.terminalFilter == ''
                  ? ""
                  : ',{"terminalId":"${widget.terminalFilter}"}',
          transactionEntityId: transactionEntityId);
    }
  }

  void filterOfApi() {
    print('tttrttt==sss>${Utility.posPaymentTransactionTypeTerminalFilter}');

    if (selectedTab == 0) {
      print('filterdate======>>>>${filterDate}');
      include =
          '[{"relation":"senderId"},{"relation":"receiverId"},{"relation":"guestuser"},{"relation":"transactionentity"},{"relation":"transactionmode"},{"relation":"transactionstatus"},{"relation":"dispute"},{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}]';
      transactionEntityId = '{"transactionentityId": { "eq": [17] }},';
      print('widget.terminalFilter===---${widget.terminalFilter}');

      if (widget.terminalFilter != null && widget.terminalFilter!.isNotEmpty) {
        print('widget.terminalFilter===${widget.terminalFilter}');
        if (Utility.posPaymentTerminalSelectionFilter.isEmpty) {
          Utility.holdPosPaymentTerminalSelectionFilter = [
            widget.terminalFilter
          ];
          Utility.posPaymentTerminalSelectionFilter = [
            '${widget.terminalFilter}'
          ];
          print('===>${Utility.posPaymentTerminalSelectionFilter}');
        }

        if (Utility.posPaymentTransactionStatusFilter.isEmpty) {
          Utility.posPaymentTransactionStatusFilter =
              '{"transactionstatusId":"3"}';
          Utility.holdPosPaymentTransactionStatusFilter = 'Success';
        }

        if (Utility.posPaymentTransactionTypeTerminalFilter.isEmpty ||
            Utility.posPaymentTransactionTypeTerminalFilter.length < 0) {
          Utility.posPaymentTransactionTypeTerminalFilter.clear();
          Utility.posPaymentTransactionTypeTerminalFilter
              .addAll(["purchase", "preauth", "manual_entry"]);
          Utility.holdPosPaymentTransactionTypeFilter = [
            'Purchase',
            'Preauth',
            'ManualEntry Purchase'
          ];
        }
      }
      print('===-----===${Utility.posPaymentTransactionTypeTerminalFilter}');

      transactionStatus = (Utility.posPaymentTransactionStatusFilter == ''
              ? '{"transactionstatusId":{"inq":[1,2,3,6]}}'
              : Utility.posPaymentTransactionStatusFilter) +
          Utility.posPaymentCardEntryTypeFilter +
          Utility.posPaymentTransactionModesFilter +
          Utility.posPaymentPaymentMethodFilter +
          (Utility.posPaymentTransactionTypeTerminalFilter == [] ||
                      Utility.posPaymentTransactionTypeTerminalFilter.isEmpty
                  ? ''
                  : ',{"transaction_type":"${Utility.posPaymentTransactionTypeTerminalFilter}"}'
                      .replaceAll('[', '')
                      .replaceAll(']', '')
                      .replaceAll(" ", ''))
              .trim() +
          filterDate;

      //{"created":{"between":["2022-06-01 00:00:00","2022-06-17 23:59:59"]}}
    } else if (selectedTab == 1) {
      include =
          '[{"relation":"senderId"},{"relation":"receiverId"},{"relation":"guestuser"},{"relation":"transactionentity"},{"relation":"transactionmode"},{"relation":"transactionstatus"},{"relation":"dispute"},{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}]';
      transactionEntityId = '{"transactionentityId":  17 }, ';
      transactionStatus = '{"is_reversed":true}' +
          Utility.posRefundTransactionModesFilter +
          Utility.posRefundCardEntryTypeFilter +
          Utility.posRefundPaymentMethodFilter +
          Utility.posRefundTransactionStatusFilter +
          filterDate;
    } else if (selectedTab == 2) {
      include =
          '["senderId","receiverId","transaction"],"include":[{"relation":"disputestatus","fields":["name"]},{"relation":"disputetype","fields":["name"]},{"relation":"senderId"},{"relation":"receiverId"},{"relation":"transaction","scope":{"include":{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}}}]';
      transactionEntityId = '';
      transactionStatus = '{"isPOS":true}' +
          Utility.posDisputeTransactionTypeFilter +
          Utility.posDisputeTransactionStatusFilter +
          filterDate;
    } else if (selectedTab == 3) {
      rentalFilter = Utility.posRentalPaymentStatusFilter + rentalFilterDate;
    }
  }

  void scrollData(id) async {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !posTransactionViewModel.isPaginationLoading) {
          if (selectedTab == 2) {
            posTransactionViewModel.disputesList(
                id: id,
                isLoading: false,
                transactionStatus: transactionStatus,
                include: include,
                terminalFilter: (Utility
                                .posPaymentTerminalSelectionFilter.length >
                            0 ||
                        Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
                    ? ',{"terminalId":"${'${Utility.posPaymentTerminalSelectionFilter}'.replaceAll('[', '').replaceAll(']', '').removeAllWhitespace}"}'
                    : widget.terminalFilter == null ||
                            widget.terminalFilter!.isEmpty
                        ? ""
                        : ',{"terminalId":"${widget.terminalFilter}"}',
                transactionEntityId: transactionEntityId);
          } else if (selectedTab == 3) {
            posTransactionViewModel.rentalList(
                isLoading: false,
                filter:
                    '$rentalFilter${(Utility.posPaymentTerminalSelectionFilter.length > 0 || Utility.posPaymentTerminalSelectionFilter.isNotEmpty) ? '&filter[where][terminalId]=${Utility.posPaymentTerminalSelectionFilter.length > 1 ? Utility.posPaymentTerminalSelectionFilter : "${Utility.posPaymentTerminalSelectionFilter.first}"}' : widget.terminalFilter == null || widget.terminalFilter == '' ? "" : '&filter[where][terminalId]=[${widget.terminalFilter}]'}');
          } else {
            posTransactionViewModel.paymentList(
                id: id,
                isLoading: false,
                transactionStatus: transactionStatus,
                include: include,
                terminalFilter: (Utility
                                .posPaymentTerminalSelectionFilter.length >
                            0 ||
                        Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
                    ? ',{"terminalId":"${'${Utility.posPaymentTerminalSelectionFilter}'.replaceAll('[', '').replaceAll(']', '').removeAllWhitespace}"}'
                    : widget.terminalFilter == null ||
                            widget.terminalFilter == ''
                        ? ""
                        : ',{"terminalId":"${widget.terminalFilter}"}',
                transactionEntityId: transactionEntityId);
          }
        }
      });
  }
}
