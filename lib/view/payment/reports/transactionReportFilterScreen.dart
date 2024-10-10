// ignore_for_file: unrelated_type_equality_checks, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import '../../../staticData/common_widgets.dart';
import '../../../staticData/utility.dart';

class TransactionReportFilterScreen extends StatefulWidget {
  TransactionReportFilterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TransactionReportFilterScreen> createState() =>
      _TransactionReportFilterScreenState();
}

class _TransactionReportFilterScreenState
    extends State<TransactionReportFilterScreen> {
  ///transaction
  List<String> selectedTransactionStatus = [];
  List<String> selectedTransactionTypes = [];
  List<String> selectedTransactionModes = [];
  List<String> selectedIntegrationTypes = [];
  List<String> selectedTransactionSources = [];
  List<String> selectedPaymentMethod = [];
  String transSources = '';

  ///refund
  List<String> selectedRefundedStatus = [];
  @override
  void initState() {
    transSources = Utility.holdTransactionFilterTransactionSources;
    selectedTransactionModes.add(Utility.holdTransactionFilterTransactionModes);
    selectedTransactionStatus.add(Utility.holdTransactionFilterStatus);
    selectedPaymentMethod.add(Utility.holdTransactionFilterPaymentMethod);
    selectedTransactionTypes.add(Utility.holdTransactionFilterTransactionType);
    selectedIntegrationTypes.add(Utility.holdTransactionFilterIntegrationType);
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
                    Utility.transactionFilterStatus = '';
                    Utility.transactionFilterPaymentMethod = '';
                    Utility.transactionFilterTransactionModes = '';
                    Utility.transactionFilterTransactionSources = '';
                    Utility.holdTransactionFilterTransactionType = '';
                    Utility.transactionFilterTransactionType = '';
                    Utility.holdTransactionFilterStatus = '';
                    Utility.holdTransactionFilterPaymentMethod = '';
                    Utility.holdTransactionFilterTransactionModes = '';
                    Utility.holdTransactionFilterTransactionSources = '';
                    Utility.transactionFilterIntegrationType = '';
                    Utility.holdTransactionFilterIntegrationType = '';
                    selectedTransactionStatus = [];
                    selectedTransactionModes = [];
                    selectedTransactionSources = [];
                    selectedPaymentMethod = [];
                    selectedTransactionTypes = [];
                    selectedIntegrationTypes = [];
                    transSources = '';
                    setState(() {});
                    Get.snackbar('Noted', 'Filter Cleared!');
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
                    transactionTypes(),
                    transactionSources(),
                    paymentMethod(),
                    transactionModes(),
                    integrationTypes(),
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
          'Transaction status'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        selectedTransactionTypes.isNotEmpty
            ? selectedTransactionTypes.first == 'Purchase'
                ? transactionStatusData()
                : selectedTransactionTypes.first == 'Refund'
                    ? refundedStatusData()
                    : selectedTransactionTypes.first == 'Dispute'
                        ? disputeStatusData()
                        : transactionStatusData()
            : transactionStatusData(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
      ],
    );
  }

  Widget transactionTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height30(),
        Text(
          'Transaction Types',
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        transactionTypesData(),
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
        const Divider(),
      ],
    );
  }

  Widget integrationTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height10(),
        Text(
          'Integration Types'.tr,
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
              itemCount: StaticData().integrationTypes.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () async {
                      selectedIntegrationTypes.clear();
                      selectedIntegrationTypes
                          .add(StaticData().integrationTypes[index]);
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
                          color: selectedIntegrationTypes.contains(
                                  StaticData().integrationTypes[index])
                              ? ColorsUtils.primary
                              : ColorsUtils.white),
                      child: Center(
                        child: Text(
                          StaticData().integrationTypes[index].tr,
                          style: ThemeUtils.blackBold.copyWith(
                              fontSize: FontUtils.verySmall,
                              color: selectedIntegrationTypes.contains(
                                      StaticData().integrationTypes[index])
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
        // const Divider(),
        height30(),
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
                    StaticData().transactionReportSources.length,
                    (index) => index == 1 || index == 4 || index == 6
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () async {
                                selectedTransactionSources.clear();
                                selectedTransactionSources.add(StaticData()
                                    .transactionReportSources[index]);
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
                                    StaticData()
                                        .transactionReportSources[index]
                                        .tr,
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
        ? '&filter[where][transactionSource]=Pg Api'
        : transSources == '1'
            ? '&filter[where][transactionSource]=Mawaid'
            : transSources == '2'
                ? '&filter[where][transactionSource]=Invoice'
                : transSources == '3'
                    ? '&filter[where][transactionSource]=WalletTransfer'
                    : transSources == '4'
                        ? '&filter[where][transactionSource]=Subscription'
                        : transSources == '5'
                            ? '&filter[where][transactionSource]=Order'
                            : '';
    print('source is${Utility.transactionFilterTransactionSources} ');
  }

  void transactionModesFilter() {
    Utility.holdTransactionFilterTransactionModes =
        selectedTransactionModes.isEmpty ? "" : selectedTransactionModes.first;

    Utility.transactionFilterTransactionModes = selectedTransactionModes.isEmpty
        ? ""
        : selectedTransactionModes.first == 'Credit card'
            ? '&filter[where][cardtype]=CREDIT'
            : selectedTransactionModes.first == 'Debit card'
                ? '&filter[where][cardtype]=DEBIT'
                : selectedTransactionModes.first == 'Wallet'
                    ? '&filter[where][cardtype]=WALLET'
                    : '';
    print('transaction Modes ${Utility.transactionFilterTransactionModes}');
  }

  void transactionIntegrationTypesFilter() {
    Utility.holdTransactionFilterIntegrationType =
        selectedIntegrationTypes.isEmpty ? "" : selectedIntegrationTypes.first;

    Utility.transactionFilterIntegrationType = selectedIntegrationTypes.isEmpty
        ? ""
        : selectedIntegrationTypes.first == 'Website'
            ? '&filter[where][transactionentityId]=7'
            : selectedIntegrationTypes.first == 'Mobile'
                ? '&filter[where][transactionentityId]=9'
                : "";
    print(
        'transaction Integration Type ${Utility.transactionFilterIntegrationType}');
  }

  void transactionPaymentFilter() {
    Utility.holdTransactionFilterPaymentMethod =
        selectedPaymentMethod.isEmpty ? '' : selectedPaymentMethod.first;

    Utility.transactionFilterPaymentMethod = selectedPaymentMethod.isEmpty
        ? ''
        : '${selectedPaymentMethod.first == 'Visa' ? '&filter[where][paymentmethod]=VISA' : selectedPaymentMethod.first == 'Mastercard' ? "&filter[where][paymentmethod]=MASTERCARD" : selectedPaymentMethod.first == 'AMEX' ? "&filter[where][paymentmethod]=AMERICAN EXPRESS" : selectedPaymentMethod.first == 'JCB' ? "&filter[where][paymentmethod]=JCB" : selectedPaymentMethod.first == 'UPI' ? "&filter[where][paymentmethod]=UPI" : selectedPaymentMethod.first == 'Sadad Pay' ? "&filter[where][paymentmethod]=SADAD PAY" : selectedPaymentMethod.first == 'Apple Pay' ? "&filter[where][paymentmethod]=APPLE PAY" : selectedPaymentMethod.first == 'Google Pay' ? "&filter[where][paymentmethod]=GOOGLE PAY" : ''}';

    print(
        'payment method is ${Utility.transactionFilterPaymentMethod}${Utility.refundedFilterPaymentMethod}');
  }

  void transactionStatusFilter() {
    Utility.holdTransactionFilterStatus = selectedTransactionStatus.isEmpty
        ? ''
        : selectedTransactionStatus.first;

    print('value---${Utility.holdRefundedFilterStatus}');

    Utility.transactionFilterStatus = selectedTransactionStatus.isEmpty
        ? ''
        : selectedTransactionStatus.first == 'InProgress'
            ? '&filter[where][transactionstatusId]=1'
            : selectedTransactionStatus.first == 'Success'
                ? '&filter[where][transactionstatusId]=3'
                : selectedTransactionStatus.first == 'Failed'
                    ? '&filter[where][transactionstatusId]=2'
                    : selectedTransactionStatus.first == 'On-Hold'
                        ? '&filter[where][transactionstatusId]=6'
                        : selectedTransactionStatus.first == 'Refunded'
                            ? '&filter[where][transactionstatusId]=4'
                            : selectedTransactionStatus.first == 'Requested'
                                ? '&filter[where][transactionstatusId]=5'
                                : selectedTransactionStatus.first == 'Rejected'
                                    ? '&filter[where][transactionstatusId]=7'
                                    : selectedTransactionStatus.first == 'Open'
                                        ? '&filter[where][disputestatusId]=1'
                                        : selectedTransactionStatus.first ==
                                                'Under Review'
                                            ? '&filter[where][disputestatusId]=2'
                                            : selectedTransactionStatus.first ==
                                                    'Close'
                                                ? '&filter[where][disputestatusId]=3'
                                                : '';

    print(
        'refund status is ${Utility.transactionFilterStatus}${Utility.refundedFilterStatus}');
  }

  void transactionTypesFilter() {
    Utility.holdTransactionFilterTransactionType =
        selectedTransactionTypes.isEmpty ? '' : selectedTransactionTypes.first;
    //&filter[where][transactionType]=payments
    Utility.transactionFilterTransactionType = selectedTransactionTypes.isEmpty
        ? ''
        : selectedTransactionTypes.first == 'Purchase'
            ? '&filter[where][transactionType]=payments'
            : selectedTransactionTypes.first == 'Refund'
                ? '&filter[where][transactionType]=refund'
                : selectedTransactionTypes.first == 'Dispute'
                    ? '&filter[where][transactionType]=dispute'
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

  ///transaction status filter
  SizedBox transactionTypesData() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().transactionTypes.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedTransactionStatus.clear();
                selectedTransactionTypes.clear();
                selectedTransactionTypes
                    .add(StaticData().transactionTypes[index]);

                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorsUtils.border, width: 1),
                    color: selectedTransactionTypes
                            .contains(StaticData().transactionTypes[index])
                        ? ColorsUtils.primary
                        : ColorsUtils.white),
                child: Center(
                  child: Text(
                    StaticData().transactionTypes[index].tr,
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedTransactionTypes
                                .contains(StaticData().transactionTypes[index])
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
                selectedTransactionStatus.clear();
                selectedTransactionStatus.add(StaticData().refundStatus[index]);

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
                            .contains(StaticData().refundStatus[index])
                        ? ColorsUtils.primary
                        : ColorsUtils.white),
                child: Center(
                  child: Text(
                    StaticData().refundStatus[index].tr,
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedTransactionStatus
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

  ///Dispute status filter

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
                selectedTransactionStatus.clear();
                selectedTransactionStatus
                    .add(StaticData().disputeStatus[index]);
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
                            .contains(StaticData().disputeStatus[index])
                        ? ColorsUtils.primary
                        : ColorsUtils.white),
                child: Center(
                  child: Text(
                    StaticData().disputeStatus[index].tr,
                    style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedTransactionStatus
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

              ///transaction type
              transactionTypesFilter();

              ///transaction modes
              transactionModesFilter();

              ///payment method
              transactionPaymentFilter();

              ///transaction sources
              transactionSourcesFilter();

              ///transaction Integration Type
              transactionIntegrationTypesFilter();
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
