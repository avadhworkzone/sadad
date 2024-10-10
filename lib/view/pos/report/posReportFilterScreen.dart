import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class PosReportFilterScreen extends StatefulWidget {
  const PosReportFilterScreen({Key? key}) : super(key: key);

  @override
  State<PosReportFilterScreen> createState() => _PosReportFilterScreenState();
}

class _PosReportFilterScreenState extends State<PosReportFilterScreen> {
  List selectedPaymentMethod = [];
  List selectedTransactionStatus = [];
  List selectedDisputesStatus = [];
  List selectedRefundStatus = [];
  List selectedDeviceType = [];
  List selectedDeviceStatus = [];
  List selectedTransactionModes = [];
  List selectedTransactionType = [];
  List selectedCardEntryType = [];

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
                      Utility.posReportPaymentMethodFilter = '';
                      Utility.posReportTransactionStatusFilter = '';
                      Utility.posReportDisputesStatusFilter = '';
                      Utility.posReportRefundStatusFilter = '';
                      Utility.posReportDeviceTypeFilter = '';
                      Utility.posReportDeviceStatusFilter = '';
                      Utility.posReportTransactionModesFilter = '';
                      Utility.posReportTransactionTypeFilter = '';
                      Utility.posReportCardEntryTypeFilter = '';
                      Get.showSnackbar(GetSnackBar(
                        message: 'Filter cleared'.tr,
                      ));
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
                    disputeStatus(),
                    paymentMethods(),
                    transactionModes(),
                    cardEntryType(),
                    refundStatus(),
                    deviceType(),
                    deviceStatus(),
                  ],
                ),
              ))
            ],
          ),
        ));
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

  Column transactionModes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Transaction Modes'),
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

  Column refundStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Refund status'),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().posReportRefundStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedRefundStatus.clear();
                    selectedRefundStatus
                        .add(StaticData().posReportRefundStatus[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedRefundStatus.contains(
                                StaticData().posReportRefundStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posReportRefundStatus[index],
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedRefundStatus.contains(
                                    StaticData().posReportRefundStatus[index])
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

  Column deviceType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        customSmallMedBoldText(color: ColorsUtils.black, title: 'Device Type'),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().posReportDeviceType.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedDeviceType.clear();
                    selectedDeviceType
                        .add(StaticData().posReportDeviceType[index]);

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
                                StaticData().posReportDeviceType[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posReportDeviceType[index],
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedDeviceType.contains(
                                    StaticData().posReportDeviceType[index])
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

  Column deviceStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Device Status'),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().posReportDeviceStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedDeviceStatus.clear();
                    selectedDeviceStatus
                        .add(StaticData().posReportDeviceStatus[index]);

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
                                StaticData().posReportDeviceStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posReportDeviceStatus[index],
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedDeviceStatus.contains(
                                    StaticData().posReportDeviceStatus[index])
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
            itemCount: StaticData().posReportTransactionStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedTransactionStatus.clear();
                    selectedTransactionStatus
                        .add(StaticData().posReportTransactionStatus[index]);

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
                                StaticData().posReportTransactionStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posReportTransactionStatus[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedTransactionStatus.contains(
                                    StaticData()
                                        .posReportTransactionStatus[index])
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

  Column disputeStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Disputes Status'),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().posReportDisputeStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedDisputesStatus.clear();
                    selectedDisputesStatus
                        .add(StaticData().posReportDisputeStatus[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedDisputesStatus.contains(
                                StaticData().posReportDisputeStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posReportDisputeStatus[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedDisputesStatus.contains(
                                    StaticData().posReportDisputeStatus[index])
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

  void filter() {
    ///transaction status
    Utility.posReportTransactionStatusFilter = selectedTransactionStatus.isEmpty
        ? ''
        : selectedTransactionStatus.first == 'Success'
            ? '&filter[where][transactionstatus]=3'
            : selectedTransactionStatus.first == 'Failed'
                ? '&filter[where][transactionstatus]=2'
                : '';

    ///payment method
    Utility.posReportPaymentMethodFilter = selectedPaymentMethod.isEmpty
        ? ''
        : selectedPaymentMethod.first == 'Visa'
            ? '&filter[where][network]=visa'
            : selectedPaymentMethod.first == 'Mastercard'
                ? '&filter[where][network]=master'
                : selectedPaymentMethod.first == 'AMEX'
                    ? '&filter[where][network]=amex'
                    : selectedPaymentMethod.first == 'JCB'
                        ? '&filter[where][network]=jcb'
                        : selectedPaymentMethod.first == 'UPI'
                            ? '&filter[where][network]=upi'
                            : selectedPaymentMethod.first == 'TOKEN'
                                ? ',{"cardtype":"TOKEN"}'
                                : '';

    ///transaction modes
    Utility.posReportTransactionModesFilter = selectedTransactionModes.isEmpty
        ? ''
        : selectedTransactionModes.first == 'Credit card'
            ? '&filter[where][card_payment_type]=credit'
            : selectedTransactionModes.first == 'Debit card'
                ? '&filter[where][card_payment_type]=debit'
                : '';

    ///card entry type
    Utility.posReportCardEntryTypeFilter = selectedCardEntryType.isEmpty
        ? ''
        : selectedCardEntryType.first == 'Chip'
            ? '&filter[where][card_type]=chip'
            : selectedCardEntryType.first == 'Magstripe'
                ? '&filter[where][card_type]=magstripe'
                : selectedCardEntryType.first == 'Contactless'
                    ? '&filter[where][card_type]=contactless'
                    : selectedCardEntryType.first == 'Fallback'
                        ? '&filter[where][card_type]=Fallback'
                        : selectedCardEntryType.first == 'Manual Entry'
                            ? '&filter[where][card_type]=manual_entry'
                            : '';

    ///disputes status
    Utility.posReportDisputesStatusFilter = selectedDisputesStatus.isEmpty
        ? ''
        : selectedDisputesStatus.first == 'Open'
            ? '&filter[where][disputestatusId]=1'
            : selectedDisputesStatus.first == 'Under Review'
                ? '&filter[where][disputestatusId]=2'
                : selectedDisputesStatus.first == 'Close'
                    ? '&filter[where][disputestatusId]=3'
                    : '';
    print('dis status${Utility.posReportDisputesStatusFilter} ');

    ///device type
    Utility.posReportDeviceTypeFilter = selectedDeviceType.isEmpty
        ? ''
        : selectedDeviceType.first == 'Wpos-QT'
            ? "&filter[where][devicetypeId]=2"
            : selectedDeviceType.first == 'Wpos-3'
                ? "&filter[where][devicetypeId]=1"
                : '';

    ///device status
    Utility.posReportDeviceStatusFilter = selectedDeviceStatus.isEmpty
        ? ''
        : selectedDeviceStatus.first == 'Active'
            ? '&filter[where][devicestatus]=1'
            : selectedDeviceStatus.first == 'InActive'
                ? '&filter[where][devicestatus]=0'
                : '';

    print(
        'trans status:${Utility.posReportCardEntryTypeFilter}  pay method:${Utility.posPaymentPaymentMethodFilter} trans mode:${Utility.posPaymentTransactionTypeFilter}  trans type:${Utility.posPaymentTransactionTypeFilter}  card entry:${Utility.posPaymentCardEntryTypeFilter}');
  }
}
