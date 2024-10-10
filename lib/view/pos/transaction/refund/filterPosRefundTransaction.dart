import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';

class FilterPosRefundScreen extends StatefulWidget {
  const FilterPosRefundScreen({Key? key}) : super(key: key);

  @override
  State<FilterPosRefundScreen> createState() => _FilterPosRefundScreenState();
}

class _FilterPosRefundScreenState extends State<FilterPosRefundScreen> {
  List selectedPaymentMethod = [];
  List selectedTransactionStatus = [];
  List selectedTransactionModes = [];
  List selectedCardEntryType = [];

  bool isVolume = false;
  List terminalSelectList = [];
  List selectedDisputeType = [];
  TerminalViewModel terminalViewModel = Get.find();
  List<TerminalListResponseModel>? terminalListRes;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
    if (Utility.holdPosPaymentTerminalSelectionFilter.length > 0 ||
        Utility.holdPosPaymentTerminalSelectionFilter.isNotEmpty) {
      terminalSelectList = Utility.holdPosPaymentTerminalSelectionFilter;
      print('terminalSelectList===$terminalSelectList');
    }
    selectedPaymentMethod.add(Utility.holdPosRefundPaymentMethodFilter);
    selectedTransactionStatus.add(Utility.holdPosRefundTransactionStatusFilter);
    selectedTransactionModes.add(Utility.holdPosRefundTransactionModesFilter);
    selectedCardEntryType.add(Utility.holdPosRefundCardEntryTypeFilter);
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
                      Utility.posRefundTransactionModesFilter = '';
                      Utility.posRefundCardEntryTypeFilter = '';
                      Utility.posRefundPaymentMethodFilter = '';
                      Utility.posRefundTransactionStatusFilter = '';
                      Utility.holdPosRefundTransactionStatusFilter = '';
                      Utility.holdPosRefundPaymentMethodFilter = '';
                      Utility.holdPosRefundTransactionModesFilter = '';
                      Utility.holdPosRefundCardEntryTypeFilter = '';
                      selectedPaymentMethod.clear();
                      selectedTransactionStatus.clear();
                      selectedTransactionModes.clear();
                      selectedCardEntryType.clear();

                      ///terminal selection
                      Utility.posPaymentTerminalSelectionFilter = [];
                      Utility.holdPosPaymentTerminalSelectionFilter = [];
                      selectedTransactionStatus.clear();
                      selectedDisputeType.clear();
                      terminalSelectList.clear();

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
              height40(),
              customLargeBoldText(title: 'Filter'.tr, color: ColorsUtils.black),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    height40(),
                    refundStatus(),
                    terminalSelection(),
                    paymentMethods(),
                    transactionModes(),
                    cardEntryType(),
                  ],
                ),
              ))
            ],
          ),
        ));
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
                        StaticData().posTransactionMode[index],
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

  Column refundStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Refund Status'.tr),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().posRefundStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedTransactionStatus.clear();
                    selectedTransactionStatus
                        .add(StaticData().posRefundStatus[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedTransactionStatus
                                .contains(StaticData().posRefundStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posRefundStatus[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedTransactionStatus.contains(
                                    StaticData().posRefundStatus[index])
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

  Widget bottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () {
              Get.back();
              filter();
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Filter'.tr),
          ),
        ),
      ],
    );
  }

  void filter() {
    Utility.holdPosRefundTransactionStatusFilter =
        selectedTransactionStatus.isEmpty
            ? ''
            : selectedTransactionStatus.first;
    Utility.holdPosRefundPaymentMethodFilter =
        selectedPaymentMethod.isEmpty ? '' : selectedPaymentMethod.first;
    Utility.holdPosRefundTransactionModesFilter =
        selectedTransactionModes.isEmpty ? '' : selectedTransactionModes.first;
    Utility.holdPosRefundCardEntryTypeFilter =
        selectedCardEntryType.isEmpty ? '' : selectedCardEntryType.first;

    ///terminal selection
    Utility.holdPosPaymentTerminalSelectionFilter =
        terminalSelectList.isEmpty ? [] : terminalSelectList;

    Utility.posPaymentTerminalSelectionFilter =
        terminalSelectList.isEmpty ? [] : terminalSelectList;

    ///refund status
    Utility.posRefundTransactionStatusFilter = selectedTransactionStatus.isEmpty
        ? ''
        : selectedTransactionStatus.first == 'Refunded'
            ? ',{"transactionstatusId":"4"}'
            : selectedTransactionStatus.first == 'Requested'
                ? ',{"transactionstatusId":"5"}'
                : selectedTransactionStatus.first == 'Rejected'
                    ? ',{"transactionstatusId":"7"}'
                    : '';

    ///payment method
    Utility.posRefundPaymentMethodFilter = selectedPaymentMethod.isEmpty
        ? ''
        : selectedPaymentMethod.first == 'Visa'
            ? ',{"cardtype":"VISA"}'
            : selectedPaymentMethod.first == 'Mastercard'
                ? ',{"cardtype":"MASTERCARD"}'
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
    Utility.posRefundTransactionModesFilter = selectedTransactionModes.isEmpty
        ? ''
        : selectedTransactionModes.first == 'Credit card'
            ? ',{"card_type":"credit"}'
            : selectedTransactionModes.first == 'Debit card'
                ? ',{"card_type":"debit"}'
                : '';

    ///card entry type
    Utility.posRefundCardEntryTypeFilter = selectedCardEntryType.isEmpty
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
  }
}
