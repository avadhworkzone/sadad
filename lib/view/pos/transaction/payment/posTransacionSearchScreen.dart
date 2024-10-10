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
import 'package:sadad_merchat_app/view/pos/transaction/dispute/filterPosDisputesTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/dispute/posDisputeTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/filterPosPaymentTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/filterPosRefundTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/posRefundTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/rental/filterPosRentalTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/rental/posRentalTransactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'posTransactionDetailScreen.dart';

class PosTransactionSearchScreen extends StatefulWidget {
  int? selectedTab;
  String? terminalFilter;
  PosTransactionSearchScreen({Key? key, this.selectedTab, this.terminalFilter})
      : super(key: key);

  @override
  State<PosTransactionSearchScreen> createState() =>
      _PosTransactionSearchScreenState();
}

class _PosTransactionSearchScreenState
    extends State<PosTransactionSearchScreen> {
  String _range = '';
  bool isPageFirst = false;
  String endDate = '';
  String startDate = '';
  String filterDate = '';
  String rentalFilterDate = '';
  int differenceDays = 0;
  List<String> selectedTimeZone = ['All'];

  ScrollController? _scrollController;
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
  String? searchKey;
  TextEditingController search = TextEditingController();
  String rentalFilter = '';
  ConnectivityViewModel connectivityViewModel = Get.find();
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
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
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: Column(
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
                              initData();
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
                                    'ex. ${widget.selectedTab == 0 ? 'transaction id' : widget.selectedTab == 1 ? 'Refund Id' : widget.selectedTab == 2 ? 'Dispute ID' : 'Invoice no.'} ',
                                hintStyle: ThemeUtils.blackRegular.copyWith(
                                    color: ColorsUtils.grey,
                                    fontSize: FontUtils.small)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                height20(),
                timeZone(),
                height20(),
                Expanded(
                  child: GetBuilder<PosTransactionViewModel>(
                    builder: (controller) {
                      if (controller.posPaymentListApiResponse.status ==
                              Status.LOADING ||
                          controller.posPaymentListApiResponse.status ==
                              Status.INITIAL ||
                          controller.posDisputesListApiResponse.status ==
                              Status.LOADING ||
                          controller.posDisputeCountApiResponse.status ==
                              Status.LOADING ||
                          controller.posRentalListApiResponse.status ==
                              Status.LOADING) {
                        return const Center(
                          child: Loader(),
                        );
                      }
                      if (controller.posPaymentListApiResponse.status ==
                              Status.ERROR ||
                          controller.posDisputesListApiResponse.status ==
                              Status.ERROR ||
                          controller.posPaymentCountApiResponse.status ==
                              Status.ERROR ||
                          controller.posDisputeCountApiResponse.status ==
                              Status.ERROR ||
                          controller.posRentalListApiResponse.status ==
                              Status.ERROR) {
                        // return const Center(
                        //   child: Text('Error'),
                        // );
                        return SessionExpire();
                      }
                      posPaymentRes = posTransactionViewModel
                          .posPaymentListApiResponse.data;
                      posDisputesRes = posTransactionViewModel
                          .posDisputesListApiResponse.data;
                      posRentalRes =
                          posTransactionViewModel.posRentalListApiResponse.data;
                      posPaymentCountRes = posTransactionViewModel
                          .posPaymentCountApiResponse.data;
                      posDisputeCountRes = posTransactionViewModel
                          .posDisputeCountApiResponse.data;

                      return Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                bottomListView(),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
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

  Widget bottomListView() {
    return Expanded(
      child: Container(
        color: ColorsUtils.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  customMediumLargeBoldText(
                      title: widget.selectedTab == 0
                          ? 'Payments'.tr
                          : widget.selectedTab == 1
                              ? 'Refund'.tr
                              : widget.selectedTab == 2
                                  ? 'Disputes'.tr
                                  : 'Pos Rental'.tr),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      widget.selectedTab == 0
                          ? await Get.to(() => FilterPosPaymentScreen(
                                isFromSearch: true,
                              ))
                          : widget.selectedTab == 1
                              ? await Get.to(
                                  () => const FilterPosRefundScreen())
                              : widget.selectedTab == 2
                                  ? await Get.to(
                                      () => const FilterPosDisputesScreen())
                                  : await Get.to(
                                      () => FilterRentalPosTransaction(
                                            terminalId: widget.terminalFilter,
                                            isFromSearch: true,
                                          ));
                      initData();
                    },
                    child: Image.asset(Images.filter,
                        height: 20,
                        color: widget.selectedTab == 2
                            ?

                            ///pos transaction
                            Utility.posDisputeTransactionStatusFilter.isNotEmpty ||
                                    Utility
                                        .posDisputeTransactionTypeFilter.isNotEmpty
                                ? ColorsUtils.accent
                                : ColorsUtils.black
                            : widget.selectedTab == 3
                                ? Utility.posRentalPaymentStatusFilter.isNotEmpty ||
                                        Utility.posPaymentTerminalSelectionFilter.length >
                                            0
                                    ? ColorsUtils.accent
                                    : ColorsUtils.black
                                : widget.selectedTab == 0
                                    ? Utility.posPaymentTransactionStatusFilter.isNotEmpty ||
                                            Utility.posPaymentCardEntryTypeFilter
                                                .isNotEmpty ||
                                            Utility
                                                .posPaymentTransactionTypeFilter
                                                .isNotEmpty ||
                                            Utility
                                                .posPaymentPaymentMethodFilter
                                                .isNotEmpty ||
                                            Utility
                                                .posPaymentTransactionModesFilter
                                                .isNotEmpty ||
                                            Utility.posPaymentTransactionTypeTerminalFilter.length >
                                                0 ||
                                            Utility.posPaymentTerminalSelectionFilter
                                                    .length >
                                                0
                                        ? ColorsUtils.accent
                                        : ColorsUtils.black
                                    : widget.selectedTab == 1
                                        ? Utility.posRefundTransactionModesFilter.isNotEmpty ||
                                                Utility
                                                    .posRefundCardEntryTypeFilter
                                                    .isNotEmpty ||
                                                Utility
                                                    .posRefundPaymentMethodFilter
                                                    .isNotEmpty ||
                                                Utility
                                                    .posRefundTransactionStatusFilter
                                                    .isNotEmpty ||
                                                Utility.posPaymentTransactionTypeTerminalFilter
                                                        .length >
                                                    0 ||
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
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: customMediumBoldText(title: 'Search result'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: customSmallSemiText(
                  title:
                      // '${widget.selectedTab == 2 ? posDisputeCountRes!.count ?? '0' : widget.selectedTab == 3 ? posRentalRes!.totalinvoices ?? "0" : posPaymentCountRes == null ? '0' : posPaymentCountRes!.count ?? "0"} ${'result found'}',
                      '${countSearchResult()} ${'result found'}',
                  color: ColorsUtils.black),
            ),
            height20(),
            if (widget.selectedTab == 0)
              posPaymentRes!.isEmpty ? noDataFound() : ListofData(),
            if (widget.selectedTab == 1)
              posPaymentRes!.isEmpty ? noDataFound() : ListofData(),
            if (widget.selectedTab == 2)
              posDisputesRes!.isEmpty ? noDataFound() : ListofData(),
            if (widget.selectedTab == 3)
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
        ),
      ),
    );
  }

  Center noDataFound() => Center(child: Text('No data found'.tr));

  Expanded ListofData() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: widget.selectedTab == 2
            ? posDisputesRes!.length
            : widget.selectedTab == 3
                ? posTransactionViewModel.rentalResponse.length
                : posPaymentRes!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          allListValue(index);
          return ListResData(index);
        },
      ),
    );
  }

  int countSearchResult() {
    int? count = 0;
    if (widget.selectedTab == 2) {
      count = posDisputesRes?.fold(
          0,
          (p, e) =>
              p +
              (e.disputeId
                      .toString()
                      .toLowerCase()
                      .contains((searchKey ?? "").toLowerCase())
                  ? 1
                  : 0));
    } else if (widget.selectedTab == 3) {
      count = posTransactionViewModel.rentalResponse.fold(
          0,
          (p, e) =>
              p +
              (e.invoiceno
                      .toString()
                      .toLowerCase()
                      .contains((searchKey ?? "").toLowerCase())
                  ? 1
                  : 0));
    } else {
      print('ID;+>${posPaymentRes?.map((e) => e.id).toList()}');
      count = posPaymentRes?.fold(
          0,
          (p, e) =>
              p +
              (e.invoicenumber
                      .toString()
                      .toLowerCase()
                      .contains((searchKey ?? "").toLowerCase())
                  ? 1
                  : 0));
    }
    return count ?? 0;
  }

  Column ListResData(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            widget.selectedTab == 0
                ? Get.to(() => PosTransactionDetailScreen(
                    id: posPaymentRes![index].id.toString()))
                : widget.selectedTab == 1
                    ? Get.to(() => PosRefundTransactionScreen(
                          id: posPaymentRes![index].id.toString(),
                        ))
                    : widget.selectedTab == 2
                        ? Get.to(() => PosDisputeTransactionScreen(
                              id: posDisputesRes![index].id.toString(),
                            ))
                        : Get.to(() => PosRentalTransactionScreen(
                              id: posRentalRes!.invoices![index].id.toString(),
                            ));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                  child:
                      Center(child: Image.asset(img!, height: 30, width: 30)),
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
                          const Icon(Icons.more_vert),
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
                              color: widget.selectedTab == 2
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
                                                  : tranStatusId == '5'
                                                      ? ColorsUtils.yellow
                                                      : tranStatusId == '6'
                                                          ? ColorsUtils
                                                              .blueBerryPie
                                                          : ColorsUtils.accent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              child: customVerySmallSemiText(
                                  color: ColorsUtils.white,
                                  title: widget.selectedTab == 1
                                      ? payment == 'PENDING'
                                          ? 'REQUESTED'
                                          : payment
                                      : '$payment'),
                            ),
                          ),
                          widget.selectedTab == 0
                              ? Row(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: SizedBox(
                                          width: 1,
                                          height: 25,
                                          child: VerticalDivider()),
                                    ),
                                    customVerySmallSemiText(
                                        title: 'Rental'.tr,
                                        color: ColorsUtils.black),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: SizedBox(
                                          width: 1,
                                          height: 25,
                                          child: VerticalDivider()),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                          const Spacer(),
                          Column(
                            children: [
                              widget.selectedTab == 1
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
  }

  void allListValue(int index) {
    if (widget.selectedTab == 2) {
      id = '${posDisputesRes![index].disputeId ?? 'NA'}';
      name = '${posDisputesRes![index].disputetype!.name ?? "NA"}';
      date = '${posDisputesRes![index].created ?? "NA"}';

      //${DateFormat('dd MM yyyy, HH:mm:ss').format(DateTime.parse(posDisputesRes![index].created.toString()))}
      payment = '${posDisputesRes![index].disputestatus!.name ?? 'NA'}';
      tranStatusId = '${posDisputesRes![index].disputestatus!.id}';
      amount = '${posDisputesRes![index].amount ?? "0"}';
      img = Images.dispute;
    } else if (widget.selectedTab == 3) {
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
      name =
          '${posPaymentRes![index].postransaction!.cardPaymentType ?? ""} ${posPaymentRes![index].postransaction!.paymentMethod ?? ""} - ${posPaymentRes![index].postransaction!.cardType ?? ""} ';
      date = intl.DateFormat('dd MMM yyyy, HH:mm:ss')
          .format(DateTime.parse(posPaymentRes![index].created.toString()));
      payment = '${posPaymentRes![index].transactionstatus!.name ?? 'NA'}';
      // print('0-0--${posPaymentRes![index].transactionstatus!.id}');
      tranStatusId = '${posPaymentRes![index].transactionstatus!.id}';
      amount = '${posPaymentRes![index].amount ?? "0"}';
      img = widget.selectedTab == 0
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
          : widget.selectedTab == 1
              ? Images.refundBack
              : widget.selectedTab == 2
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

  Future<void> datePicker(BuildContext context) async {
    await showDialog(
        context: context,
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
                                        '${intl.DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                        ' ${intl.DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.endDate ?? dateRangePickerSelectionChangedArgs.value.startDate)}';
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
                    endDate = '';
                    startDate = '';
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
                        StaticData().timeZone[index].tr,
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
    if (widget.selectedTab == 2) {
      await posTransactionViewModel.disputesList(
          fromSearch: true,
          id: userId,
          isLoading: true,
          transactionStatus: transactionStatus,
          terminalFilter: ((Utility.posPaymentTerminalSelectionFilter.length >
                      0 ||
                  Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
              ? ',{"terminalId":"${'${Utility.posPaymentTerminalSelectionFilter}'.replaceAll('[', '').replaceAll(']', '').removeAllWhitespace}"}'
              : widget.terminalFilter == null || widget.terminalFilter == ''
                  ? ""
                  : ',{"terminalId":"${widget.terminalFilter}"}'),
          include: include,
          transactionEntityId: transactionEntityId);
      await posTransactionViewModel.disputeCount(
          id: userId,
          transactionStatus: transactionStatus,
          transactionEntityId: transactionEntityId);
    } else if (widget.selectedTab == 3) {
      await posTransactionViewModel.rentalList(
          fromSearch: true,
          isLoading: true,
          filter:
              '$rentalFilter${(Utility.posPaymentTerminalSelectionFilter.length > 0 || Utility.posPaymentTerminalSelectionFilter.isNotEmpty) ? '&filter[where][terminalId]=${Utility.posPaymentTerminalSelectionFilter.length > 1 ? Utility.posPaymentTerminalSelectionFilter : "${Utility.posPaymentTerminalSelectionFilter.first}"}' : widget.terminalFilter == null || widget.terminalFilter == '' ? "" : '&filter[where][terminalId]=[${widget.terminalFilter}]'}');
    } else {
      await posTransactionViewModel.paymentList(
          fromSearch: true,
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
      await posTransactionViewModel.paymentCount(
          id: userId,
          transactionStatus: transactionStatus,
          transactionEntityId: transactionEntityId);
    }
  }

  void filterOfApi() {
    print('tttrttt==sss>${Utility.posPaymentTransactionTypeTerminalFilter}');

    if (widget.selectedTab == 0) {
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
          print('hcjdfgvjvdhjbvdf');
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
      transactionStatus = (Utility.posPaymentTransactionStatusFilter == ''
              ? '{"transactionstatusId":{"inq":[1,2,3,6]}}'
              : Utility.posPaymentTransactionStatusFilter) +
          Utility.posPaymentCardEntryTypeFilter +
          Utility.posPaymentTransactionModesFilter +
          ((searchKey != null && searchKey != "")
              ? ',{"invoicenumber":"$searchKey"}'
              : '') +
          Utility.posPaymentPaymentMethodFilter +
          (Utility.posPaymentTransactionTypeTerminalFilter == [] ||
                  Utility.posPaymentTransactionTypeTerminalFilter.isEmpty
              ? ''
              : ',{"transaction_type":"${Utility.posPaymentTransactionTypeTerminalFilter}"}'
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .replaceAll(" ", '')) +
          filterDate;
      //{"created":{"between":["2022-06-01 00:00:00","2022-06-17 23:59:59"]}}
    } else if (widget.selectedTab == 1) {
      include =
          '[{"relation":"senderId"},{"relation":"receiverId"},{"relation":"guestuser"},{"relation":"transactionentity"},{"relation":"transactionmode"},{"relation":"transactionstatus"},{"relation":"dispute"},{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}]';
      transactionEntityId = '{"transactionentityId":  17 }, ';
      transactionStatus = '{"is_reversed":true}' +
          Utility.posRefundTransactionModesFilter +
          Utility.posRefundCardEntryTypeFilter +
          ((searchKey != null && searchKey != "")
              ? ',{"invoicenumber":"$searchKey"}'
              : '') +
          Utility.posRefundPaymentMethodFilter +
          Utility.posRefundTransactionStatusFilter +
          filterDate;
    } else if (widget.selectedTab == 2) {
      include =
          '["senderId","receiverId","transaction"],"include":[{"relation":"disputestatus","fields":["name"]},{"relation":"disputetype","fields":["name"]},{"relation":"senderId"},{"relation":"receiverId"},{"relation":"transaction","scope":{"include":{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}}}]';
      transactionEntityId = '';
      transactionStatus = '{"isPOS":true}' +
          Utility.posDisputeTransactionTypeFilter +
          ((searchKey != null && searchKey != "")
              ? ',{"disputeId":"$searchKey"}'
              : '') +
          Utility.posDisputeTransactionStatusFilter +
          filterDate;
    } else if (widget.selectedTab == 3) {
      rentalFilter = Utility.posRentalPaymentStatusFilter +
          rentalFilterDate +
          ((searchKey != null && searchKey != "")
              ? '&filter[where][invoiceno][like]=$searchKey'
              : '');
    }
  }

  void scrollData(id) async {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !posTransactionViewModel.isPaginationLoading) {
          if (widget.selectedTab == 2) {
            posTransactionViewModel.disputesList(
                fromSearch: false,
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
          } else if (widget.selectedTab == 3) {
            posTransactionViewModel.rentalList(
                fromSearch: false,
                isLoading: false,
                filter:
                    '$rentalFilter${(Utility.posPaymentTerminalSelectionFilter.length > 0 || Utility.posPaymentTerminalSelectionFilter.isNotEmpty) ? '&filter[where][terminalId]=${Utility.posPaymentTerminalSelectionFilter.length > 1 ? Utility.posPaymentTerminalSelectionFilter : "${Utility.posPaymentTerminalSelectionFilter.first}"}' : widget.terminalFilter == null || widget.terminalFilter == '' ? "" : '&filter[where][terminalId]=[${widget.terminalFilter}]'}');
          } else {
            posTransactionViewModel.paymentList(
                fromSearch: false,
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
