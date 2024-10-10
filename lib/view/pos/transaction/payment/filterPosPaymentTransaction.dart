import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/posTransactionListScreen.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';

class FilterPosPaymentScreen extends StatefulWidget {
  String? isTerminal;
  String? selectedTimeZone;
  String? startDate;
  String? endDate;
  bool? isFromSearch;

  FilterPosPaymentScreen(
      {Key? key,
      this.isTerminal,
      this.selectedTimeZone,
      this.startDate,
      this.isFromSearch,
      this.endDate})
      : super(key: key);

  @override
  State<FilterPosPaymentScreen> createState() => _FilterPosPaymentScreenState();
}

class _FilterPosPaymentScreenState extends State<FilterPosPaymentScreen> {
  List selectedPaymentMethod = [];
  List selectedTransactionStatus = [];
  List selectedTransactionModes = [];
  List selectedTransactionType = [];
  List selectedCardEntryType = [];
  bool isVolume = false;
  List terminalSelectList = [];
  int isRadioSelected = 0;
  bool? clearFilter;

  TerminalViewModel terminalViewModel = Get.find();
  List<TerminalListResponseModel>? terminalListRes;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
    print('widget.isTerminal==>${widget.isTerminal}');
    selectedPaymentMethod.add(Utility.holdPosPaymentPaymentMethodFilter);

    selectedTransactionStatus
        .add(Utility.holdPosPaymentTransactionStatusFilter);
    selectedTransactionModes.add(Utility.holdPosPaymentTransactionModesFilter);
    selectedTransactionType.addAll(Utility.holdPosPaymentTransactionTypeFilter);
    selectedCardEntryType.add(Utility.holdPosPaymentCardEntryTypeFilter);
    if (Utility.holdPosPaymentTerminalSelectionFilter.length > 0 ||
        Utility.holdPosPaymentTerminalSelectionFilter.isNotEmpty) {
      terminalSelectList = Utility.holdPosPaymentTerminalSelectionFilter;
      print('terminalSelectList===$terminalSelectList');
    }

    // TODO: implement initState
    super.initState();
  }

  initData() async {
    terminalViewModel.setTerminalInit();
    await terminalViewModel.terminalList(
        filter: '', ending: 100000, isLoading: true);

    if (terminalViewModel.terminalListApiResponse.status == Status.COMPLETE) {
      terminalListRes = terminalViewModel.terminalListApiResponse.data;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomSheet(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height60(),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back(result: false);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      clearData();
                      Get.snackbar(
                        'Please Note'.tr,
                        'Filter cleared'.tr,
                      );
                      // Get.showSnackbar(GetSnackBar(
                      //   duration: Duration(seconds: 5),
                      //   message: 'Filter cleared'.tr,
                      // )
                      //);
                    },
                    child: customSmallMedBoldText(
                        color: ColorsUtils.accent, title: 'Clear Filter'.tr),
                  ),
                ],
              ),
              height40(),
              customLargeBoldText(title: 'Filter'.tr, color: ColorsUtils.black),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    height40(),
                    transactionStatus(),
                    terminalSelection(),
                    paymentMethods(),
                    transactionModes(),
                    transactionType(),
                    cardEntryType(),
                    // terminalType(),
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  clearData() {
    Utility.posPaymentTransactionStatusFilter = '';
    Utility.posPaymentCardEntryTypeFilter = '';
    Utility.posPaymentTransactionTypeFilter = '';
    Utility.posPaymentPaymentMethodFilter = '';
    Utility.posPaymentTransactionModesFilter = '';
    Utility.holdPosPaymentTransactionStatusFilter = '';
    Utility.holdPosPaymentPaymentMethodFilter = '';
    Utility.holdPosPaymentTransactionModesFilter = '';
    Utility.holdPosPaymentTransactionTypeFilter = [];
    Utility.holdPosPaymentCardEntryTypeFilter = '';
    Utility.posPaymentTerminalSelectionFilter = [];
    Utility.holdPosPaymentTerminalSelectionFilter = [];
    Utility.posPaymentTransactionTypeTerminalFilter = [];
    Utility.holdPosPaymentTransactionTypeTerminalFilter = [];
    selectedPaymentMethod.clear();
    selectedTransactionStatus.clear();
    selectedTransactionModes.clear();
    selectedTransactionType.clear();
    selectedCardEntryType.clear();
    terminalSelectList.clear();

    setState(() {});
  }

  Column cardEntryType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        Text(
          'Card Entry Type'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: Get.width,
              child: Wrap(
                runSpacing: 10,
                direction: Axis.horizontal,
                children: List.generate(
                    StaticData().posCardEntryType.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              selectedCardEntryType.clear();
                              selectedCardEntryType
                                  .add(StaticData().posCardEntryType[index]);
                              cardEntryType == index.toString();
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1),
                                  color: selectedCardEntryType.contains(
                                          StaticData().posCardEntryType[index])
                                      ? ColorsUtils.primary
                                      : ColorsUtils.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  StaticData().posCardEntryType[index].tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color: selectedCardEntryType.contains(
                                              StaticData()
                                                  .posCardEntryType[index])
                                          ? ColorsUtils.white
                                          : ColorsUtils.tabUnselectLabel),
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            )),
      ],
    );
  }

  Column transactionType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        Text(
          'Transaction Types'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: Get.width,
              child: Wrap(
                runSpacing: 10,
                direction: Axis.horizontal,
                children: List.generate(
                    StaticData().posTransactionType.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              if (selectedTransactionType.contains(
                                  StaticData().posTransactionType[index])) {
                                selectedTransactionType.remove(
                                    StaticData().posTransactionType[index]);
                              } else {
                                selectedTransactionType.add(
                                    StaticData().posTransactionType[index]);
                              }

                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1),
                                  color: selectedTransactionType.contains(
                                          StaticData()
                                              .posTransactionType[index])
                                      ? ColorsUtils.primary
                                      : ColorsUtils.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  StaticData().posTransactionType[index].tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color: selectedTransactionType.contains(
                                              StaticData()
                                                  .posTransactionType[index])
                                          ? ColorsUtils.white
                                          : ColorsUtils.tabUnselectLabel),
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            )),
      ],
    );
  }

  Column transactionModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Transaction Modes'.tr),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().posTransactionMode.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedTransactionModes.clear();
                    selectedTransactionModes
                        .add(StaticData().posTransactionMode[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedTransactionModes.contains(
                                StaticData().posTransactionMode[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posTransactionMode[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedTransactionModes.contains(
                                    StaticData().posTransactionMode[index])
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
        Divider(),
      ],
    );
  }

  Column paymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        Text(
          'Payment methods'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: StaticData().posTransactionPaymentMethod.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                selectedPaymentMethod.clear();
                selectedPaymentMethod.add(
                    StaticData().posTransactionPaymentMethod[index]['title']);
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
                              .posTransactionPaymentMethod[index]['title'])
                          ? Center(
                              child: Image.asset(Images.check,
                                  height: 10, width: 10))
                          : SizedBox()),
                  width10(),
                  Image.asset(
                    StaticData().posTransactionPaymentMethod[index]['image'],
                    width: 30,
                    height: 30,
                  ),
                  width10(),
                  Text(
                    StaticData().posTransactionPaymentMethod[index]['title'],
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

  Column transactionStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Transaction Status'.tr),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().posTransactionStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedTransactionStatus.clear();
                    selectedTransactionStatus
                        .add(StaticData().posTransactionStatus[index]);

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
                                StaticData().posTransactionStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posTransactionStatus[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedTransactionStatus.contains(
                                    StaticData().posTransactionStatus[index])
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
        Divider(),
      ],
    );
  }

  Column terminalSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Terminal Selection'.tr),
        height20(),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 1, color: ColorsUtils.border)),
          child: Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
                iconColor: ColorsUtils.accent,
                key: UniqueKey(),
                initiallyExpanded: isVolume,
                onExpansionChanged: (value) {
                  isVolume = value;
                  setState(() {});
                },
                title: customSmallSemiText(
                    color: terminalSelectList.isEmpty
                        ? ColorsUtils.hintColor.withOpacity(0.5)
                        : ColorsUtils.black,
                    title: terminalSelectList.isEmpty ||
                            terminalSelectList == [] ||
                            terminalSelectList.length == 0
                        ? 'Choose your Terminal'.tr
                        : terminalSelectList
                            .toString()
                            .replaceAll('[', '')
                            .replaceAll(']', '')),
                children: [
                  terminalListRes == null
                      ? Text('No data found'.tr)
                      : SizedBox(
                          height: Get.height / 3.5,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: terminalListRes!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                child: InkWell(
                                    onTap: () {
                                      widget.isTerminal = '';
                                      if (terminalListRes != null) {
                                        // isVolume = !isVolume;
                                        if (terminalSelectList.contains(
                                            terminalListRes![index]
                                                .terminalId)) {
                                          terminalSelectList.remove(
                                              terminalListRes![index]
                                                  .terminalId);
                                        } else {
                                          terminalSelectList.add(
                                              "${terminalListRes![index].terminalId}");
                                        }
                                        print(
                                            'list is ==>${terminalSelectList}');
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: terminalSelectList.contains(
                                                    terminalListRes![index]
                                                        .terminalId)
                                                ? ColorsUtils.accent
                                                : ColorsUtils.grey
                                                    .withOpacity(0.3),
                                            width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: ColorsUtils.white,
                                                      border: Border.all(
                                                          color:
                                                              ColorsUtils.grey,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: terminalSelectList
                                                          .contains(
                                                              terminalListRes![
                                                                      index]
                                                                  .terminalId)
                                                      ? Center(
                                                          child: Image.asset(
                                                              Images.check,
                                                              height: 10,
                                                              width: 10))
                                                      : SizedBox(),
                                                ),
                                                width10(),
                                                Expanded(
                                                  child: customVerySmallBoldText(
                                                      title:
                                                          '${terminalListRes![index].terminalId} (${terminalListRes![index].deviceSerialNo})',
                                                      color: ColorsUtils.black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              );
                            },
                          ),
                        )
                ]

                // [
                //   InkWell(
                //       onTap: () {
                //         //volumeRange = 1;
                //         isVolume = !isVolume;
                //         transactionValue = '1-100000';
                //         setState(() {});
                //       },
                //       child: customSmallBoldText(
                //           title: '1-100000', color: ColorsUtils.grey)),
                //   height10(),
                //   InkWell(
                //       onTap: () {
                //         //volumeRange = 2;
                //
                //         isVolume = !isVolume;
                //         transactionValue = '100000-500000';
                //         setState(() {});
                //       },
                //       child: customSmallBoldText(
                //           title: '100000-500000', color: ColorsUtils.grey)),
                //   height10(),
                //   InkWell(
                //       onTap: () {
                //         //volumeRange = 3;
                //         isVolume = !isVolume;
                //         transactionValue = 'more than 500000'.tr;
                //         setState(() {});
                //       },
                //       child: customSmallBoldText(
                //           title: 'more than 500000'.tr, color: ColorsUtils.grey)),
                // ],
                ),
          ),
        ),
        height20(),
        Divider(),
      ],
    );
  }

  Widget bottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () {
              print(
                  "holdPosPaymentTransactionStatusFilter ==== ${Utility.holdPosPaymentTransactionStatusFilter}");
              filter();
              print("widget.isTerminal === ${widget.isTerminal}");
              if (widget.isFromSearch == true) {
                Get.back();
              } else {
                Get.off(() => PosTransactionListScreen(
                      endDate: widget.endDate,
                      startDate: widget.startDate,
                      selectedTimeZone: widget.selectedTimeZone,
                      terminalFilter: '',
                    ));
              }
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Filter'.tr),
          ),
        ),
      ],
    );
  }

  void filter() {
    Utility.posPaymentTransactionTypeTerminalFilter.clear();
    Utility.holdPosPaymentTransactionStatusFilter =
        selectedTransactionStatus.isEmpty
            ? ''
            : selectedTransactionStatus.first;
    Utility.holdPosPaymentPaymentMethodFilter =
        selectedPaymentMethod.isEmpty ? '' : selectedPaymentMethod.first;
    Utility.holdPosPaymentTransactionModesFilter =
        selectedTransactionModes.isEmpty ? '' : selectedTransactionModes.first;
    Utility.holdPosPaymentTransactionTypeFilter =
        selectedTransactionType.isEmpty ? [] : selectedTransactionType;
    Utility.holdPosPaymentCardEntryTypeFilter =
        selectedCardEntryType.isEmpty ? '' : selectedCardEntryType.first;
    Utility.holdPosPaymentTerminalSelectionFilter =
        terminalSelectList.isEmpty ? [] : terminalSelectList;

    ///transaction status
    Utility.posPaymentTransactionStatusFilter =
        selectedTransactionStatus.isEmpty
            ? ''
            : selectedTransactionStatus.first == 'InProgress'
                ? ''
                : selectedTransactionStatus.first == 'Success'
                    ? '{"transactionstatusId":"3"}'
                    : selectedTransactionStatus.first == 'Failed'
                        ? '{"transactionstatusId":"2"}'
                        : selectedTransactionStatus.first == 'On-Hold'
                            ? ''
                            : '';

    ///payment method
    Utility.posPaymentPaymentMethodFilter = selectedPaymentMethod.isEmpty
        ? ''
        : selectedPaymentMethod.first == 'Visa'
            ? ',{"cardtype":"VISA"}'
            : selectedPaymentMethod.first == 'Mastercard'
                ? ',{"cardtype":"MASTERCARD"}'
                : selectedPaymentMethod.first == 'NAPS'
                    ? ',{"cardtype":"naps"}'
                    : selectedPaymentMethod.first == 'AMEX'
                        ? ',{"cardtype":"AMERICAN EXPRESS"}'
                        : selectedPaymentMethod.first == 'JCB'
                            ? ',{"cardtype":"JCB"}'
                            : selectedPaymentMethod.first == 'UPI'
                                ? ',{"cardtype":"UPI"}'
                                : selectedPaymentMethod.first == 'TOKEN'
                                    ? ',{"cardtype":"TOKEN"}'
                                    : '';

    ///transaction modes
    Utility.posPaymentTransactionModesFilter = selectedTransactionModes.isEmpty
        ? ''
        : selectedTransactionModes.first == 'Credit card'
            ? ',{"card_type":"credit"}'
            : selectedTransactionModes.first == 'Debit card'
                ? ',{"card_type":"debit"}'
                : '';

    ///transaction type
    List transactionTypeValue = [];

    if (selectedTransactionType.contains('Purchase')) {
      transactionTypeValue.add("purchase");
    }
    if (selectedTransactionType.contains('Preauth Complete')) {
      transactionTypeValue.add("preauth_complete");
    }
    if (selectedTransactionType.contains('Preauth')) {
      transactionTypeValue.add("preauth");
    }
    if (selectedTransactionType.contains('Reversal')) {
      transactionTypeValue.add("reversal");
    }
    if (selectedTransactionType.contains('ManualEntry Purchase')) {
      transactionTypeValue.add("manual_entry");
    }
    if (selectedTransactionType.contains('Card Verification')) {
      transactionTypeValue.add("card_verification");
    }
    print('selectedTransactionType=====$selectedTransactionType');
    Utility.holdPosPaymentTransactionTypeFilter = selectedTransactionType;
    Utility.posPaymentTransactionTypeTerminalFilter = transactionTypeValue;
    print(
        'Utility.holdPosPaymentTransactionTypeFilter=${Utility.holdPosPaymentTransactionTypeFilter}');

    ///card entry type
    Utility.posPaymentCardEntryTypeFilter = selectedCardEntryType.isEmpty
        ? ''
        : selectedCardEntryType.first == 'Chip'
            ? ',{"cardEntry":"chip"}'
            : selectedCardEntryType.first == 'Magstripe'
                ? ',{"cardEntry":"magstripe"}'
                : selectedCardEntryType.first == 'Contactless'
                    ? ',{"cardEntry":"contactless"}'
                    : selectedCardEntryType.first == 'Fallback'
                        ? ',{"cardEntry":"Fallback"}'
                        : selectedCardEntryType.first == 'Manual Entry'
                            ? ',{"cardEntry":"manual_entry"}'
                            : '';

    ///terminal selection
    Utility.posPaymentTerminalSelectionFilter =
        terminalSelectList.isEmpty ? [] : terminalSelectList;
    print(
        'Utility.posPaymentTerminalSelectionFilter===${Utility.posPaymentTerminalSelectionFilter}');
    print(
        'trans status:${Utility.posPaymentTransactionStatusFilter}  pay method:${Utility.posPaymentPaymentMethodFilter} trans mode:${Utility.posPaymentTransactionTypeFilter}  trans type:${Utility.posPaymentTransactionTypeTerminalFilter}  card entry:${Utility.posPaymentCardEntryTypeFilter}   terminal selection    ${Utility.posPaymentTerminalSelectionFilter}');
  }
}
