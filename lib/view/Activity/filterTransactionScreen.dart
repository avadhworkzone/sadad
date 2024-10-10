import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class TransactionFilterActivityScreen extends StatefulWidget {
  const TransactionFilterActivityScreen({Key? key}) : super(key: key);

  @override
  State<TransactionFilterActivityScreen> createState() =>
      _TransactionFilterActivityScreenState();
}

class _TransactionFilterActivityScreenState
    extends State<TransactionFilterActivityScreen> {
  bool? groupValue;
  List transactionFilter = [];
  List transactionTypeFilter = [];
  bool isFiltered = false;

  @override
  void initState() {
    if (Utility.holdActivityPaymentType != '') {
      transactionTypeFilter.add(Utility.holdActivityPaymentType);
    }
    if (Utility.holdActivityTransactionSources != '') {
      transactionFilter.add(Utility.holdActivityTransactionSources);
    }
    print('$transactionTypeFilter$transactionFilter');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topView(),
          sourcesType(),
          paymentType(),
          const Spacer(),
          InkWell(
              onTap: () {
                print(
                    '${transactionFilter.isNotEmpty}${transactionTypeFilter.isNotEmpty}');
                print(
                    '${transactionFilter.length}${transactionTypeFilter.length}');
                if (transactionFilter.length > 0) {
                  Utility.holdActivityTransactionSources =
                      transactionFilter.first;
                  Utility.activityTransactionSources =
                      '&filter[txnSource]=${transactionFilter.first}';
                }
                if (transactionTypeFilter.length > 0) {
                  print(
                      'Utility.activityPaymentType${transactionTypeFilter.first}');
                  Utility.holdActivityPaymentType = transactionTypeFilter.first;
                  Utility.activityPaymentType =
                      transactionTypeFilter.first == 'Payment In'
                          ? '&filter[paymentIn]=true'
                          : '&filter[paymentOut]=true';
                }
                print(Utility.activityPaymentType);
                print(Utility.activityTransactionSources);
                // Get.snackbar('success', 'Filter Cleared!');
                Get.back();
                //
              },
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Filter'.tr)),
          height20()
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
                Utility.holdActivityTransactionSources = '';
                Utility.holdActivityPaymentType = '';
                transactionTypeFilter.clear();
                transactionFilter.clear();
                Utility.activityTransactionSources = '';
                Utility.activityPaymentType = '';
                print('====$transactionFilter$transactionTypeFilter');
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

  Column sourcesType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
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
                    StaticData().activityTransaction.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              transactionFilter.clear();
                              transactionFilter
                                  .add(StaticData().activityTransaction[index]);
                              print(
                                  'resorce $transactionFilter\ntype$transactionTypeFilter');
                              // sourcesType == index.toString();
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
                                  color: transactionFilter.contains(StaticData()
                                          .activityTransaction[index])
                                      ? ColorsUtils.primary
                                      : ColorsUtils.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  StaticData().activityTransaction[index].tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color: transactionFilter.contains(
                                              StaticData()
                                                  .activityTransaction[index])
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

  Column paymentType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        Text(
          'Payment Type'.tr,
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
                    StaticData().activityPaymentType.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              transactionTypeFilter.clear();
                              transactionTypeFilter
                                  .add(StaticData().activityPaymentType[index]);
                              print(
                                  'resorce $transactionFilter\ntype$transactionTypeFilter');
                              // sourcesType == index.toString();
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
                                  color: transactionTypeFilter.contains(
                                          StaticData()
                                              .activityPaymentType[index])
                                      ? ColorsUtils.primary
                                      : ColorsUtils.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  StaticData().activityPaymentType[index].tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color: transactionTypeFilter.contains(
                                              StaticData()
                                                  .activityPaymentType[index])
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
}
