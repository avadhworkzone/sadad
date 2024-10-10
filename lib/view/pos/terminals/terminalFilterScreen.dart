import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart' as intl;

class TerminalFilterScreen extends StatefulWidget {
  const TerminalFilterScreen({Key? key}) : super(key: key);

  @override
  State<TerminalFilterScreen> createState() => _TerminalFilterScreenState();
}

class _TerminalFilterScreenState extends State<TerminalFilterScreen> {
  List selectedTransactionModes = [];
  List selectedPaymentMethod = [];
  List selectedTransactionStatus = [];
  List selectedDeviceStatus = [];
  List selectedDeviceType = [];
  String customRange = '';
  String endDate = '';
  String startDate = '';
  String customEndDate = '';
  String customStartDate = '';
  int differenceDays = 0;
  DateTime activatedDate = DateTime.now();
  @override
  void initState() {
    getInitData();
    selectedTransactionModes.add(Utility.holdTransactionFilterTransactionModes);
    selectedPaymentMethod.add(Utility.holdTransactionFilterPaymentMethod);
    selectedTransactionStatus.add(Utility.holdTransactionFilterStatus);
    selectedDeviceStatus.add(Utility.holdDeviceFilterStatus);
    selectedDeviceType.add(Utility.holdDeviceFilterDeviceType);
    customStartDate = Utility.holdTerminalActivationStartDate;
    customEndDate = Utility.holdTerminalActivationEndDate;
    //${intl.DateFormat('dd MMM’ yy, 00:00:00').format(dateRangePickerSelectionChangedArgs.value.startDate)} -
    if (customStartDate != '' && customEndDate != '') {
      customRange =
          '${intl.DateFormat('dd MMM’ yy, 00:00:00').format(DateTime.parse(customStartDate))} - ${intl.DateFormat('dd MMM’ yy, 00:00:00').format(DateTime.parse(customEndDate))}';
    }
    // TODO: implement initState
    super.initState();
  }

  getInitData() async {
    String date =
        await encryptedSharedPreferences.getString('posActivatedDate');
    print('date is====$date');
    print(
        'date is====${DateTime(activatedDate.year, activatedDate.month, activatedDate.day)}');
    if (date.isNotEmpty) {
      activatedDate = DateTime.parse(date);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomSheet(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            height60(),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 25,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Utility.terminalFilterPaymentMethod = '';
                    Utility.terminalFilterTransModes = '';
                    Utility.terminalFilterTransStatus = '';
                    Utility.terminalFilterStartActivationDate = '';
                    Utility.terminalFilterEndActivationDate = '';
                    Utility.terminalFilterDeviceStatus = '';
                    Utility.terminalCountFilterPaymentMethod = '';
                    Utility.terminalCountFilterTransModes = '';
                    Utility.terminalCountFilterTransStatus = '';
                    Utility.holdTransactionFilterTransactionModes = '';
                    Utility.holdTerminalActivationStartDate = '';
                    Utility.holdTerminalActivationEndDate = '';
                    Utility.holdTransactionFilterPaymentMethod = '';
                    Utility.holdTransactionFilterStatus = '';
                    Utility.holdDeviceFilterStatus = '';
                    Utility.holdDeviceFilterDeviceType = '';
                    Utility.deviceFilterDeviceType = '';
                    Utility.terminalCountFilterDeviceStatus = '';
                    Utility.terminalCountFilterStartActivationDate = '';
                    Utility.terminalCountFilterEndActivationDate = '';
                    Utility.deviceFilterCountDeviceType = '';
                    selectedTransactionStatus.clear();
                    selectedPaymentMethod.clear();
                    selectedTransactionModes.clear();
                    selectedDeviceStatus.clear();
                    selectedDeviceType.clear();
                    customRange = '';
                    startDate = '';
                    endDate = '';
                    customStartDate = '';
                    customEndDate = '';
                    setState(() {});
                    Get.snackbar(
                      'Please Note'.tr,
                      'Filter cleared'.tr,
                    );
                    // Get.showSnackbar(GetSnackBar(
                    //   message: 'Filter cleared'.tr,
                    // ));
                  },
                  child: customSmallMedBoldText(
                      color: ColorsUtils.accent, title: 'Clear Filter'.tr),
                ),
              ],
            ),
            height5(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    transactionStatus(),
                    liveTerminalStatus(),
                    deviceType(),
                    activationDate()
                    //paymentMethod(),
                    // transactionModes(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () {
              filter();
              Get.back();
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Filter'.tr),
          ),
        ),
      ],
    );
  }

  Future<void> datePicker(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          String customRangePicker = '';

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
                                    customEndDate = '';
                                    customEndDate = '';
                                    customRangePicker = '';
                                  } else {
                                    if (dateRangePickerSelectionChangedArgs
                                        .value is PickerDateRange) {
                                      customRangePicker =
                                          '${intl.DateFormat('dd MMM’ yy, 00:00:00').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                          ' ${intl.DateFormat('dd MMM’ yy, 23:59:59').format(dateRangePickerSelectionChangedArgs.value.endDate)}';
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
                                  // if (differenceDays >= 364) {
                                  //   Get.snackbar('warning'.tr,
                                  //       'Please select range in 12 month'.tr);
                                  //   customStartDate = '';
                                  //   customEndDate = '';
                                  // } else {
                                  customStartDate = intl.DateFormat(
                                          'yyyy-MM-dd 00:00:00')
                                      .format(DateTime.parse(
                                          '${dateRangePickerSelectionChangedArgs.value.startDate}'));

                                  dateRangePickerSelectionChangedArgs
                                                  .value.endDate ==
                                              null ||
                                          dateRangePickerSelectionChangedArgs
                                                  .value.endDate ==
                                              ''
                                      ? ''
                                      : customEndDate = intl.DateFormat(
                                              'yyyy-MM-dd 23:59:59')
                                          .format(DateTime.parse(
                                              '${dateRangePickerSelectionChangedArgs.value.endDate}'));
                                  // }

                                  setDialogState(() {});
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                maxDate: DateTime.now(),
                                // minDate: DateTime(DateTime.now().year - 1,
                                //     DateTime.now().month, DateTime.now().day),
                                minDate: DateTime(activatedDate.year,
                                    activatedDate.month, activatedDate.day),
                                initialSelectedRange: PickerDateRange(
                                    customStartDate == ''
                                        ? DateTime.now()
                                            .subtract(const Duration(days: 7))
                                        : DateTime.parse(customStartDate),
                                    customEndDate == ''
                                        ? DateTime.now()
                                        : DateTime.parse(customEndDate)),
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
                                        customRangePicker,
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
                                        print(
                                            "custom range---$customRangePicker");
                                        customRange = customRangePicker;
                                        setState(() {});
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
                                        if (customRangePicker == '') {
                                          customRange = '';
                                          // selectedTimeZone.clear();
                                          // selectedTimeZone.add('Today');
                                          setState(() {});
                                        }
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

  void filter() {
    Utility.holdTransactionFilterTransactionModes =
        selectedTransactionModes.isEmpty ? "" : selectedTransactionModes.first;
    Utility.holdTransactionFilterPaymentMethod =
        selectedPaymentMethod.isEmpty ? '' : selectedPaymentMethod.first;
    Utility.holdTransactionFilterStatus = selectedTransactionStatus.isEmpty
        ? ''
        : selectedTransactionStatus.first;
    Utility.holdDeviceFilterStatus =
        selectedDeviceStatus.isEmpty ? '' : selectedDeviceStatus.first;
    Utility.holdDeviceFilterDeviceType =
        selectedDeviceType.isEmpty ? '' : selectedDeviceType.first;
    Utility.holdTerminalActivationStartDate =
        customStartDate == '' ? '' : customStartDate;
    Utility.holdTerminalActivationEndDate =
        customEndDate == '' ? '' : customEndDate;

    ///payment method
    Utility.terminalFilterPaymentMethod = selectedPaymentMethod.isEmpty
        ? ''
        : selectedPaymentMethod.first == 'Visa'
            ? '&filter[where][payment_method]=visa'
            : selectedPaymentMethod.first == 'Mastercard'
                ? '&filter[where][payment_method]=master'
                : selectedPaymentMethod.first == 'AMEX'
                    ? '&filter[where][payment_method]=amex'
                    : selectedPaymentMethod.first == 'JCB'
                        ? '&filter[where][payment_method]=jcb'
                        : selectedPaymentMethod.first == 'UPI'
                            ? '&filter[where][payment_method]=upi'
                            : '';
    Utility.terminalCountFilterPaymentMethod = selectedPaymentMethod.isEmpty
        ? ''
        : selectedPaymentMethod.first == 'Visa'
            ? '&where[payment_method]=visa'
            : selectedPaymentMethod.first == 'Mastercard'
                ? '&where[payment_method]=master'
                : selectedPaymentMethod.first == 'AMEX'
                    ? '&where[payment_method]=amex'
                    : selectedPaymentMethod.first == 'JCB'
                        ? '&where[payment_method]=jcb'
                        : selectedPaymentMethod.first == 'UPI'
                            ? '&where[payment_method]=upi'
                            : '';

    print('payment method is::$selectedPaymentMethod');

    ///transaction modes
    Utility.terminalFilterTransModes = selectedTransactionModes.isEmpty
        ? ""
        : selectedTransactionModes.first == 'Credit card'
            ? '&filter[where][card_type]=credit'
            : selectedTransactionModes.first == 'Debit card'
                ? '&filter[where][card_type]=debit'
                : '';
    Utility.terminalCountFilterTransModes = selectedTransactionModes.isEmpty
        ? ""
        : selectedTransactionModes.first == 'Credit card'
            ? '&where[card_type]=credit'
            : selectedTransactionModes.first == 'Debit card'
                ? '&where[card_type]=debit'
                : '';
    print('transaction modes::$selectedTransactionModes');

    ///transaction status
    Utility.terminalFilterTransStatus = selectedTransactionStatus.isEmpty
        ? ''
        : selectedTransactionStatus.first == 'Active'
            ? '&filter[where][is_active]=1'
            : selectedTransactionStatus.first == 'InActive'
                ? '&filter[where][is_active]=0'
                : '';

    Utility.terminalCountFilterTransStatus = selectedTransactionStatus.isEmpty
        ? ''
        : selectedTransactionStatus.first == 'Active'
            ? '&where[terminalStatus]=active'
            : selectedTransactionStatus.first == 'InActive'
                ? '&where[terminalStatus]=inactive'
                : '';

    ///Device status
    Utility.terminalFilterDeviceStatus = selectedDeviceStatus.isEmpty
        ? ''
        : selectedDeviceStatus.first == 'Online'
            ? '&filter[where][is_online]=1'
            : selectedDeviceStatus.first == 'Offline'
                ? '&filter[where][is_online]=0'
                : '';
    Utility.terminalCountFilterDeviceStatus = selectedDeviceStatus.isEmpty
        ? ''
        : selectedDeviceStatus.first == 'Online'
            ? '&where[is_online]=1'
            : selectedDeviceStatus.first == 'Offline'
                ? '&where[is_online]=0'
                : '';

    ///Device type
    Utility.deviceFilterDeviceType = selectedDeviceType.isEmpty
        ? ''
        : selectedDeviceType.first == 'WPOS-3'
            ? '&filter[where][devicetypeId]=1'
            : selectedDeviceType.first == 'WPOS-QT'
                ? '&filter[where][devicetypeId]=2'
                : '';
    Utility.deviceFilterCountDeviceType = selectedDeviceType.isEmpty
        ? ''
        : selectedDeviceType.first == 'WPOS-3'
            ? '&where[devicetypeId]=1'
            : selectedDeviceType.first == 'WPOS-QT'
                ? '&where[devicetypeId]=2'
                : '';

    ///Device Activation Date
    if (customRange.isNotEmpty || customRange != '') {
      Utility.terminalFilterStartActivationDate = customStartDate == ''
          ? ''
          : '&filter[where][activated][between][0]=$customStartDate';
      Utility.terminalFilterEndActivationDate = customEndDate == ''
          ? ''
          : '&filter[where][activated][between][1]=$customEndDate';

      Utility.terminalCountFilterStartActivationDate = customStartDate == ''
          ? ''
          : '&where[activated][between][0]=$customStartDate';
      Utility.terminalCountFilterEndActivationDate = customEndDate == ''
          ? ''
          : '&where[activated][between][1]=$customEndDate';
    }

    print('transaction status::$selectedTransactionStatus');
    print('device status::$selectedDeviceStatus');
  }

  Widget transactionStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height30(),
        Text(
          'Terminal status'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().terminalTransactionStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedTransactionStatus.clear();
                    selectedTransactionStatus
                        .add(StaticData().terminalTransactionStatus[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedTransactionStatus.contains(
                                StaticData().terminalTransactionStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().terminalTransactionStatus[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedTransactionStatus.contains(
                                    StaticData()
                                        .terminalTransactionStatus[index])
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
      ],
    );
  }

  Widget liveTerminalStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live Terminal Status'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().terminalDeviceStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedDeviceStatus.clear();
                    selectedDeviceStatus
                        .add(StaticData().terminalDeviceStatus[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedDeviceStatus.contains(
                                StaticData().terminalDeviceStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().terminalDeviceStatus[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedDeviceStatus.contains(
                                    StaticData().terminalDeviceStatus[index])
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
      ],
    );
  }

  Widget deviceType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Type'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().terminalDeviceType.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedDeviceType.clear();
                    selectedDeviceType
                        .add(StaticData().terminalDeviceType[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedDeviceType.contains(
                                StaticData().terminalDeviceType[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().terminalDeviceType[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedDeviceType.contains(
                                    StaticData().terminalDeviceType[index])
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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
      ],
    );
  }

  Widget activationDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Terminal Activation Date'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        InkWell(
          onTap: () {
            datePicker(context);
          },
          child: Container(
            //margin: EdgeInsets.only(right: 60),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ColorsUtils.border, width: 1),
                color: customRange == ''
                    ? ColorsUtils.white
                    : ColorsUtils.primary),
            child: customRange == ''
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        customRange == '' ? "Select Date".tr : customRange,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: customRange == ''
                                ? ColorsUtils.tabUnselectLabel
                                : ColorsUtils.white),
                      ),
                      width5(),
                      Image.asset(
                        Images.calender,
                        height: 15,
                        color: ColorsUtils.primary,
                      )
                    ],
                  )
                : Text(
                    customRange == '' ? "Select Date".tr : customRange,
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: customRange == ''
                            ? ColorsUtils.tabUnselectLabel
                            : ColorsUtils.white),
                  ),
          ),
        ),
        // SizedBox(
        //   height: 25,
        //   width: Get.width,
        //   child: ListView.builder(
        //     physics: const BouncingScrollPhysics(),
        //     shrinkWrap: true,
        //     itemCount: StaticData().terminalDeviceType.length,
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) {
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 5),
        //         child: InkWell(
        //           onTap: () async {
        //             selectedDeviceType.clear();
        //             selectedDeviceType
        //                 .add(StaticData().terminalDeviceType[index]);
        //
        //             setState(() {});
        //           },
        //           child:
        //           Container(
        //             padding: const EdgeInsets.symmetric(
        //               horizontal: 12,
        //             ),
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(8),
        //                 border: Border.all(color: ColorsUtils.border, width: 1),
        //                 color: selectedDeviceType.contains(
        //                         StaticData().terminalDeviceType[index])
        //                     ? ColorsUtils.primary
        //                     : ColorsUtils.white),
        //             child: Center(
        //               child: Text(
        //                 StaticData().terminalDeviceType[index].tr,
        //                 style: ThemeUtils.blackBold.copyWith(
        //                     fontSize: FontUtils.verySmall,
        //                     color: selectedDeviceType.contains(
        //                             StaticData().terminalDeviceType[index])
        //                         ? ColorsUtils.white
        //                         : ColorsUtils.tabUnselectLabel),
        //               ),
        //             ),
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
      ],
    );
  }

  Widget transactionModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height10(),
        Text(
          'Transaction Modes'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            height: 25,
            width: Get.width,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: StaticData().terminalTransactionModes.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () async {
                      selectedTransactionModes.clear();
                      selectedTransactionModes
                          .add(StaticData().terminalTransactionModes[index]);
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: ColorsUtils.border, width: 1),
                          color: selectedTransactionModes.contains(
                                  StaticData().transactionModes[index])
                              ? ColorsUtils.primary
                              : ColorsUtils.white),
                      child: Center(
                        child: Text(
                          StaticData().transactionModes[index].tr,
                          style: ThemeUtils.blackBold.copyWith(
                              fontSize: FontUtils.verySmall,
                              color: selectedTransactionModes.contains(
                                      StaticData().transactionModes[index])
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
        ),
      ],
    );
  }

  Widget paymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment methods'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: StaticData().terminalPaymentMethod.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                selectedPaymentMethod.clear();
                selectedPaymentMethod
                    .add(StaticData().terminalPaymentMethod[index]['title']);
                setState(() {});
              },
              child: Row(
                children: [
                  Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: ColorsUtils.black, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                      child: selectedPaymentMethod.contains(StaticData()
                              .terminalPaymentMethod[index]['title'])
                          ? Center(
                              child: Image.asset(Images.check,
                                  height: 10, width: 10))
                          : SizedBox()),
                  width10(),
                  Image.asset(
                    StaticData().terminalPaymentMethod[index]['image'],
                    width: 30,
                    height: 30,
                  ),
                  width10(),
                  Text(
                    StaticData().terminalPaymentMethod[index]['title'],
                    style: ThemeUtils.blackSemiBold
                        .copyWith(fontSize: FontUtils.mediumSmall),
                  )
                ],
              ),
            );
          },
        ),
        const Divider(),
      ],
    );
  }
}
