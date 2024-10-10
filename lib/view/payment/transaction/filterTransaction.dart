// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import '../../../staticData/common_widgets.dart';
import '../../../staticData/utility.dart';

class FilterTransaction extends StatefulWidget {
  int? tab;
  FilterTransaction({Key? key, this.tab}) : super(key: key);

  @override
  State<FilterTransaction> createState() => _FilterTransactionState();
}

class _FilterTransactionState extends State<FilterTransaction> {
  ///transaction
  List<String> selectedTransactionStatus = [];
  List<String> selectedTransactionModes = [];
  List<String> selectedTransactionSources = [];
  List<String> selectedPaymentMethod = [];
  String transSources = '';

  ///refund
  List<String> selectedRefundedStatus = [];

  ///dispute
  List<String> selectedDisputeStatus = [];
  List<String> selectedDisputeTypeStatus = [];
  @override
  void initState() {
    print('stattshjjnknl${Utility.holdRefundedFilterStatus}');
    transSources = Utility.holdTransactionFilterTransactionSources;
    widget.tab == 0
        ? selectedTransactionModes
            .add(Utility.holdTransactionFilterTransactionModes)
        : selectedTransactionModes
            .add(Utility.holdRefundedFilterTransactionModes);
    widget.tab == 0
        ? selectedTransactionStatus.add(Utility.holdTransactionFilterStatus)
        : selectedRefundedStatus.add(Utility.holdRefundedFilterStatus);
    widget.tab == 0
        ? selectedPaymentMethod.add(Utility.holdTransactionFilterPaymentMethod)
        : selectedPaymentMethod.add(Utility.holdRefundedFilterPaymentMethod);
    selectedDisputeStatus.add(Utility.holdDisputeStatusFilter);
    selectedDisputeTypeStatus.add(Utility.holdDisputeTypeFilter);

    print('selected tab ${widget.tab}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height40(),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios)),
                Spacer(),
                InkWell(
                  onTap: () {
                    Utility.refundedFilterStatus = '';
                    Utility.transactionFilterStatus = '';
                    Utility.transactionFilterPaymentMethod = '';
                    Utility.transactionFilterTransactionModes = '';
                    Utility.transactionFilterTransactionSources = '';
                    Utility.refundedFilterPaymentMethod = '';
                    Utility.refundedFilterTransactionModes = '';
                    Utility.disputeStatusFilter = '';
                    Utility.disputeTypeFilter = '';

                    Utility.holdRefundedFilterStatus = '';
                    Utility.holdTransactionFilterStatus = '';
                    Utility.holdTransactionFilterPaymentMethod = '';
                    Utility.holdTransactionFilterTransactionModes = '';
                    Utility.holdTransactionFilterTransactionSources = '';
                    Utility.holdRefundedFilterPaymentMethod = '';
                    Utility.holdRefundedFilterTransactionModes = '';
                    Utility.holdDisputeStatusFilter = '';
                    Utility.holdDisputeTypeFilter = '';
                    selectedTransactionStatus = [];
                    selectedTransactionModes = [];
                    selectedTransactionSources = [];
                    selectedPaymentMethod = [];
                    selectedDisputeStatus = [];
                    selectedDisputeTypeStatus = [];
                    selectedRefundedStatus = [];
                    transSources = '';
                    setState(() {});
                    Get.snackbar(
                      'Please Note'.tr,
                      'Filter cleared'.tr,
                    );
                    //Get.back();
                  },
                  child: Text(
                    'Clear Filter'.tr,
                    style: ThemeUtils.blackBold.copyWith(
                        color: ColorsUtils.accent,
                        fontSize: FontUtils.mediumSmall),
                  ),
                ),
              ],
            ),
            height30(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter'.tr,
                      style: ThemeUtils.blackBold
                          .copyWith(fontSize: FontUtils.medLarge),
                    ),
                    transactionStatus(),
                    widget.tab == 2 ? SizedBox() : paymentMethod(),
                    widget.tab == 2 ? disputeType() : SizedBox(),
                    widget.tab == 2 ? SizedBox() : transactionModes(),
                    widget.tab == 0 ? transactionSources() : SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height30(),
        Text(
          widget.tab == 1
              ? 'Refund status'.tr
              : widget.tab == 2
                  ? 'Dispute status'.tr
                  : 'Transaction status',
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        widget.tab == 0
            ? transactionStatusData()
            : widget.tab == 2
                ? disputeStatusData()
                : refundedStatusData(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
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
          itemCount: StaticData().transactionPaymentMethod.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                selectedPaymentMethod.clear();
                selectedPaymentMethod
                    .add(StaticData().transactionPaymentMethod[index]['title']);
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
                              .transactionPaymentMethod[index]['title'])
                          ? Center(
                              child: Image.asset(Images.check,
                                  height: 10, width: 10))
                          : SizedBox()),
                  width10(),
                  Image.asset(
                    StaticData().transactionPaymentMethod[index]['image'],
                    width: 30,
                    height: 30,
                  ),
                  width10(),
                  Text(
                    StaticData().transactionPaymentMethod[index]['title'],
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

  ///Dispute Type
  Column disputeType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dispute Type'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().disputeType.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedDisputeTypeStatus.clear();
                    selectedDisputeTypeStatus
                        .add(StaticData().disputeType[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedDisputeTypeStatus
                                .contains(StaticData().disputeType[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().disputeType[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedDisputeTypeStatus
                                    .contains(StaticData().disputeType[index])
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
        height10(),
        const Divider(),
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
              itemCount: StaticData().transactionModes.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () async {
                      selectedTransactionModes.clear();
                      selectedTransactionModes
                          .add(StaticData().transactionModes[index]);
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
                          StaticData().transactionModes[index],
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

  Widget transactionSources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        height10(),
        Text(
          'Transaction Sources'.tr,
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
                    StaticData().transactionSources.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              selectedTransactionSources.clear();
                              selectedTransactionSources
                                  .add(StaticData().transactionSources[index]);
                              transSources = index.toString();
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
                                  color: transSources == index.toString()
                                      ? ColorsUtils.primary
                                      : ColorsUtils.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  StaticData().transactionSources[index].tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color: transSources == index.toString()
                                          ? ColorsUtils.white
                                          : ColorsUtils.tabUnselectLabel),
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            )

            // SizedBox(
            //   height: 25,
            //   width: Get.width,
            //   child: ListView.builder(
            //     // padding: NeverScrollableScrollPhysics(),
            //     physics: const NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: StaticData().transactionSources.length,
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 5),
            //         child: InkWell(
            //           onTap: () async {
            //             selectedTransactionSources.clear();
            //             selectedTransactionSources
            //                 .add(StaticData().transactionSources[index]);
            //             setState(() {});
            //           },
            //           child: Container(
            //             padding: const EdgeInsets.symmetric(
            //               horizontal: 12,
            //             ),
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(8),
            //                 border: Border.all(color: ColorsUtils.border, width: 1),
            //                 color: selectedTransactionSources
            //                         .contains(StaticData().transactionSources[index])
            //                     ? ColorsUtils.primary
            //                     : ColorsUtils.white),
            //             child: Center(
            //               child: Text(
            //                 StaticData().transactionSources[index].tr,
            //                 style: ThemeUtils.blackBold.copyWith(
            //                     fontSize: FontUtils.verySmall,
            //                     color: selectedTransactionSources.contains(
            //                             StaticData().transactionSources[index])
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
            ),
        height30(),
      ],
    );
  }

  void transactionSourcesFilter() {
    Utility.holdTransactionFilterTransactionSources = transSources;

    Utility.transactionFilterTransactionSources = transSources == '0'
        ? ',{"transactionentityId":"5"}'
        : transSources == '1'
            ? ',{"transactionentityId":"6"}'
            : transSources == '2'
                ? ',{"transactionentityId":{"inq": [7,9]}}'
                : transSources == '3'
                    ? ',{"transactionentityId":"8"}'
                    : transSources == '4'
                        ? ',{"transactionentityId":"1"}'
                        // : transSources == '5'
                        //     ? ',{"transactionentityId":"8"}'
                        //     : transSources == '6'
                        //         ? ',{"transactionentityId":"11"}'
                        //         : transSources == '7'
                        //             ? ',{"transactionentityId":"12"}'
                        //             : transSources == '8'
                        //                 ? ',{"transactionentityId":"1"}'
                        : '';
    print('source is${Utility.transactionFilterTransactionSources} ');
  }

  void transactionModesFilter() {
    widget.tab == 0
        ? Utility.holdTransactionFilterTransactionModes =
            selectedTransactionModes.isEmpty
                ? ""
                : selectedTransactionModes.first
        : Utility.holdRefundedFilterTransactionModes =
            selectedTransactionModes.isEmpty
                ? ""
                : selectedTransactionModes.first;
    widget.tab == 0
        ? Utility.transactionFilterTransactionModes =
            selectedTransactionModes.isEmpty
                ? ""
                : selectedTransactionModes.first == 'Credit card'
                    ? ',{"transactionmodeId":"1"}'
                    : selectedTransactionModes.first == 'Debit card'
                        ? ',{"transactionmodeId":"2"}'
                        : selectedTransactionModes.first == 'Wallet'
                            ? ',{"transactionmodeId":{"inq": [3,4,5]}}'
                            : ''
        : Utility.refundedFilterTransactionModes =
            selectedTransactionModes.isEmpty
                ? ""
                : selectedTransactionModes.first == 'Credit card'
                    ? ',{"transactionmodeId":"1"}'
                    : selectedTransactionModes.first == 'Debit card'
                        ? ',{"transactionmodeId":"2"}'
                        : selectedTransactionModes.first == 'Wallet'
                            ? ',{"transactionmodeId":{"inq": [3,4,5]}}'
                            : '';
    print('transaction Modes ${Utility.transactionFilterTransactionModes}');
  }

  void transactionPaymentFilter() {
    widget.tab == 0
        ? Utility.holdTransactionFilterPaymentMethod =
            selectedPaymentMethod.isEmpty ? '' : selectedPaymentMethod.first
        : Utility.holdRefundedFilterPaymentMethod =
            selectedPaymentMethod.isEmpty ? '' : selectedPaymentMethod.first;

    widget.tab == 0
        ? Utility.transactionFilterPaymentMethod = selectedPaymentMethod.isEmpty
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
                                : selectedPaymentMethod.first == 'Sadad Pay'
                                    ? ',{"cardtype":"SADAD PAY"}'
                                    : selectedPaymentMethod.first == 'Apple Pay'
                                        ? ',{"cardtype":"APPLE PAY"}'
                                        : selectedPaymentMethod.first ==
                                                'Google Pay'
                                            ? ',{"cardtype":"GOOGLE PAY"}'
                                            : ''
        : Utility.refundedFilterPaymentMethod = selectedPaymentMethod.isEmpty
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
                                : selectedPaymentMethod.first == 'Sadad Pay'
                                    ? ',{"cardtype":"SADAD PAY"}'
                                    : selectedPaymentMethod.first == 'Apple Pay'
                                        ? ',{"cardtype":"APPLE PAY"}'
                                        : selectedPaymentMethod.first ==
                                                'Google Pay'
                                            ? ',{"cardtype":"GOOGLE PAY"}'
                                            : '';

    print(
        'payment method is ${Utility.transactionFilterPaymentMethod}${Utility.refundedFilterPaymentMethod}');
  }

  void transactionStatusFilter() {
    widget.tab == 0
        ? Utility.holdTransactionFilterStatus =
            selectedTransactionStatus.isEmpty
                ? ''
                : selectedTransactionStatus.first
        : Utility.holdRefundedFilterStatus =
            selectedRefundedStatus.isEmpty ? '' : selectedRefundedStatus.first;

    print('value---${Utility.holdRefundedFilterStatus}');
    if (widget.tab == 0) {
      Utility.transactionFilterStatus = selectedTransactionStatus.isEmpty
          ? ''
          : selectedTransactionStatus.first == 'InProgress'
              ? '1'
              : selectedTransactionStatus.first == 'Success'
                  ? '3'
                  : selectedTransactionStatus.first == 'Failed'
                      ? '2'
                      : selectedTransactionStatus.first == 'On-Hold'
                          ? '6'
                          : '';
    } else {
      Utility.refundedFilterStatus = selectedRefundedStatus.isEmpty
          ? ""
          : selectedRefundedStatus.first == 'Refunded'
              ? ',{"transactionstatusId":"4"}'
              : selectedRefundedStatus.first == 'Requested'
                  ? ',{"transactionstatusId":"5"}'
                  : selectedRefundedStatus.first == 'Rejected'
                      ? ',{"transactionstatusId":"7"}'
                      : '';
    }
    print(
        'refund status is ${Utility.transactionFilterStatus}${Utility.refundedFilterStatus}');
  }

  void disputeStatusFilter() {
    Utility.holdDisputeStatusFilter =
        selectedDisputeStatus.isEmpty ? "" : selectedDisputeStatus.first;

    Utility.disputeStatusFilter = selectedDisputeStatus.isEmpty
        ? ""
        : selectedDisputeStatus.first == 'Open'
            ? ',{"disputestatusId":"1"}'
            : selectedTransactionModes.first == 'Under Review'
                ? ',{"disputestatusId":"2"}'
                : selectedTransactionModes.first == 'Close'
                    ? ',{"disputestatusId":"3"}'
                    : '';
  }

  void disputeTypeFilter() {
    Utility.holdDisputeTypeFilter = selectedDisputeTypeStatus.isEmpty
        ? ""
        : selectedDisputeTypeStatus.first;

    Utility.disputeTypeFilter = selectedDisputeTypeStatus.isEmpty
        ? ""
        : selectedDisputeTypeStatus.first == 'ChargeBack'
            ? ',{"disputetypeId":"1"}'
            : selectedTransactionModes.first == 'Fraud'
                ? ',{"disputestatusId":"2"}'
                : '';
  }

  ///transaction status filter
  SizedBox transactionStatusData() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().transactionStatus.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedTransactionStatus.clear();
                selectedTransactionStatus
                    .add(StaticData().transactionStatus[index]);

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
                            .contains(StaticData().transactionStatus[index])
                        ? ColorsUtils.primary
                        : ColorsUtils.white),
                child: Center(
                  child: Text(
                    StaticData().transactionStatus[index].tr,
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedTransactionStatus
                                .contains(StaticData().transactionStatus[index])
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

  ///refund status filter

  SizedBox refundedStatusData() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().refundStatus.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedRefundedStatus.clear();
                selectedRefundedStatus.add(StaticData().refundStatus[index]);

                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorsUtils.border, width: 1),
                    color: selectedRefundedStatus
                            .contains(StaticData().refundStatus[index])
                        ? ColorsUtils.primary
                        : ColorsUtils.white),
                child: Center(
                  child: Text(
                    StaticData().refundStatus[index].tr,
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedRefundedStatus
                                .contains(StaticData().refundStatus[index])
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

  ///dispute status filter

  SizedBox disputeStatusData() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().disputeStatus.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedDisputeStatus.clear();
                selectedDisputeStatus.add(StaticData().disputeStatus[index]);

                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorsUtils.border, width: 1),
                    color: selectedDisputeStatus
                            .contains(StaticData().disputeStatus[index])
                        ? ColorsUtils.primary
                        : ColorsUtils.white),
                child: Center(
                  child: Text(
                    StaticData().disputeStatus[index].tr,
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedDisputeStatus
                                .contains(StaticData().disputeStatus[index])
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

  Column bottomButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: () {
              ///transaction status
              transactionStatusFilter();

              ///payment method
              transactionPaymentFilter();

              ///transaction modes
              transactionModesFilter();

              ///transaction sources
              transactionSourcesFilter();

              ///Dispute Status
              disputeStatusFilter();

              ///Dispute Type
              disputeTypeFilter();
              Get.back();
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Filter'.tr),
          ),
        ),
        height20(),
      ],
    );
  }
}
