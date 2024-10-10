import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class ActivityReportTransactionFilterScreen extends StatefulWidget {
  const ActivityReportTransactionFilterScreen({Key? key}) : super(key: key);

  @override
  State<ActivityReportTransactionFilterScreen> createState() =>
      _ActivityReportTransactionFilterScreenState();
}

class _ActivityReportTransactionFilterScreenState
    extends State<ActivityReportTransactionFilterScreen> {
  List transactionTypeFilter = [];
  List transactionSourceFilter = [];
  List transactionStatusFilter = [];
  List paymentMethodFilter = [];
  List transactionModeFilter = [];
  List integrationTypeFilter = [];
  bool isFiltered = false;

  @override
  void initState() {
    if (Utility.holdActivityTransactionReportTransactionTypeFilter != '') {
      transactionTypeFilter
          .add(Utility.holdActivityTransactionReportTransactionTypeFilter);
    }
    if (Utility.holdActivityTransactionReportTransactionSourceFilter != '') {
      transactionSourceFilter
          .add(Utility.holdActivityTransactionReportTransactionSourceFilter);
    }
    if (Utility.holdActivityTransactionReportTransactionStatusFilter != '') {
      transactionStatusFilter
          .add(Utility.holdActivityTransactionReportTransactionStatusFilter);
    }
    if (Utility.holdActivityTransactionReportPaymentMethodFilter != '') {
      paymentMethodFilter
          .add(Utility.holdActivityTransactionReportPaymentMethodFilter);
    }
    if (Utility.holdActivityTransactionReportTransactionModeFilter != '') {
      transactionModeFilter
          .add(Utility.holdActivityTransactionReportTransactionModeFilter);
    }
    if (Utility.holdActivityTransactionReportIntegrationTypeFilter != '') {
      integrationTypeFilter
          .add(Utility.holdActivityTransactionReportIntegrationTypeFilter);
    }

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                  onTap: () {
                    print(
                        'transactionTypeFilter    $transactionTypeFilter    ');
                    print(
                        'transactionSourceFilter  $transactionSourceFilter  ');
                    print(
                        'transactionStatusFilter  $transactionStatusFilter  ');
                    print(
                        'paymentMethodFilter      $paymentMethodFilter      ');
                    print(
                        'transactionModeFilter    $transactionModeFilter    ');
                    print(
                        'integrationTypeFilter    $integrationTypeFilter    ');

                    if (transactionTypeFilter.isNotEmpty) {
                      Utility.activityTransactionReportTransactionTypeFilter =
                          '&filter[where][transactionType]=${transactionTypeFilter.first == 'Purchase' ? 'payments' : transactionTypeFilter.first == 'Refund' ? 'refund' : 'dispute'}';
                      Utility.holdActivityTransactionReportTransactionTypeFilter =
                          transactionTypeFilter.first;
                    }
                    if (transactionSourceFilter.isNotEmpty) {
                      Utility.activityTransactionReportTransactionSourceFilter =
                          transactionSourceFilter.first == 'All'
                              ? ''
                              : '&filter[where][transactionSource]=${transactionSourceFilter.first == 'PG API' ? 'Pg Api' : transactionSourceFilter.first == 'Mawaid' ? "Mawaid" : transactionSourceFilter.first == 'Invoice' ? "Invoice" : transactionSourceFilter.first == 'Wallet Transfer' ? 'WalletTransfer' : transactionSourceFilter.first == 'Subscription' ? 'Subscription' : 'Order'}';
                      Utility.holdActivityTransactionReportTransactionSourceFilter =
                          transactionSourceFilter.first;
                    }
                    if (transactionStatusFilter.isNotEmpty) {
                      Utility.activityTransactionReportTransactionStatusFilter =
                          '&filter[where][transactionstatusId]=${transactionStatusFilter.first == 'InProgress' ? '1' : transactionStatusFilter.first == 'Failed' ? "2" : transactionStatusFilter.first == 'Success' ? "3" : "6"}';
                      Utility.holdActivityTransactionReportTransactionStatusFilter =
                          transactionStatusFilter.first;
                    }
                    if (paymentMethodFilter.isNotEmpty) {
                      Utility.activityTransactionReportPaymentMethodFilter =
                          '&filter[where][paymentmethod]='
                          '${paymentMethodFilter.first == 'Visa' ? 'VISA' : paymentMethodFilter.first == 'Mastercard' ? "MASTERCARD" : paymentMethodFilter.first == 'AMEX' ? "AMERICAN EXPRESS" : paymentMethodFilter.first == 'JCB' ? "JCB" : paymentMethodFilter.first == 'UPI' ? "UPI" : paymentMethodFilter.first == 'Sadad Pay' ? "SADAD PAY" : paymentMethodFilter.first == 'Apple Pay' ? "APPLE PAY" : "GOOGLE PAY"}';

                      Utility.holdActivityTransactionReportPaymentMethodFilter =
                          paymentMethodFilter.first;
                    }
                    if (transactionModeFilter.isNotEmpty) {
                      Utility.activityTransactionReportTransactionModeFilter =
                          '&filter[where][cardtype]=${transactionModeFilter.first == 'Credit card' ? 'CREDIT' : transactionModeFilter.first == 'Debit card' ? "DEBIT" : "WALLET"}';

                      Utility.holdActivityTransactionReportTransactionModeFilter =
                          transactionModeFilter.first;
                    }
                    if (integrationTypeFilter.isNotEmpty) {
                      Utility.activityTransactionReportIntegrationTypeFilter =
                          '&filter[where][transactionentityId]=${integrationTypeFilter.first == 'Website' ? '7' : "9"}';
                      Utility.holdActivityTransactionReportIntegrationTypeFilter =
                          integrationTypeFilter.first;
                    }
                    Get.back();
                  },
                  child: buildContainerWithoutImage(
                      color: ColorsUtils.accent, text: 'Filter'.tr)),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              topView(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///transaction type
                      commonWrapList(
                          listName: StaticData().activityTransactionType,
                          key: 'Transaction Types'.tr,
                          filterName: transactionTypeFilter),

                      ///transaction source
                      commonWrapList(
                          listName: StaticData().activityTransactionSources,
                          key: 'Transaction Source'.tr,
                          filterName: transactionSourceFilter),

                      ///transaction status
                      commonWrapList(
                          listName: StaticData().activityTransactionStatus,
                          key: 'Transaction Status'.tr,
                          filterName: transactionStatusFilter),

                      ///transaction mode
                      commonWrapList(
                          listName: StaticData().activityTransactionMode,
                          key: 'Transaction Mode'.tr,
                          filterName: transactionModeFilter),

                      ///payment method
                      paymentMethod(),

                      ///integration type
                      commonWrapList(
                          listName: StaticData().activityIntegrationType,
                          key: 'Integration Type'.tr,
                          filterName: integrationTypeFilter),
                      height20()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Column topView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height30(),
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
                transactionTypeFilter = [];
                transactionSourceFilter = [];
                transactionStatusFilter = [];
                paymentMethodFilter = [];
                transactionModeFilter = [];
                integrationTypeFilter = [];
                Utility.activityTransactionReportTransactionTypeFilter = '';
                Utility.activityTransactionReportTransactionSourceFilter = '';
                Utility.activityTransactionReportTransactionStatusFilter = '';
                Utility.activityTransactionReportPaymentMethodFilter = '';
                Utility.activityTransactionReportTransactionModeFilter = '';
                Utility.activityTransactionReportIntegrationTypeFilter = '';
                Utility.holdActivityTransactionReportTransactionTypeFilter = '';
                Utility.holdActivityTransactionReportTransactionSourceFilter =
                    '';
                Utility.holdActivityTransactionReportTransactionStatusFilter =
                    '';
                Utility.holdActivityTransactionReportPaymentMethodFilter = '';
                Utility.holdActivityTransactionReportTransactionModeFilter = '';
                Utility.holdActivityTransactionReportIntegrationTypeFilter = '';

                setState(() {});
                Get.snackbar('success', 'Filter Cleared!');

                // Get.back();
              },
              child: Text(
                'Clear Filter'.tr,
                style: ThemeUtils.blackBold.copyWith(
                    color: ColorsUtils.accent, fontSize: FontUtils.mediumSmall),
              ),
            ),
          ],
        ),
        height30(),
        Text(
          'Filter'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
        ),
        height20(),
      ],
    );
  }

  Column commonWrapList({String? key, var listName, dynamic filterName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        Text(
          key!,
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
                    listName.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              filterName.clear();
                              filterName.add(listName[index]);

                              print('list value===>$filterName');
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
                                  color: filterName.contains(listName[index])
                                      ? ColorsUtils.primary
                                      : ColorsUtils.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  listName[index],
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color:
                                          filterName.contains(listName[index])
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
                paymentMethodFilter.clear();
                paymentMethodFilter
                    .add(StaticData().transactionPaymentMethod[index]['title']);

                print('value==>$paymentMethodFilter');
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
                      child: paymentMethodFilter.contains(StaticData()
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
}
