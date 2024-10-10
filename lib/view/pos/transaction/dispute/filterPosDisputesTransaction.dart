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

class FilterPosDisputesScreen extends StatefulWidget {
  const FilterPosDisputesScreen({Key? key}) : super(key: key);

  @override
  State<FilterPosDisputesScreen> createState() =>
      _FilterPosDisputesScreenState();
}

class _FilterPosDisputesScreenState extends State<FilterPosDisputesScreen> {
  List selectedTransactionStatus = [];
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
    selectedTransactionStatus
        .add(Utility.holdPosDisputeTransactionStatusFilter);
    selectedDisputeType.add(Utility.holdPosDisputeTransactionTypeFilter);
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
                      Utility.posDisputeTransactionStatusFilter = '';
                      Utility.posDisputeTransactionTypeFilter = '';
                      Utility.holdPosDisputeTransactionTypeFilter = '';
                      Utility.holdPosDisputeTransactionStatusFilter = '';
                      Utility.holdPosPaymentTerminalSelectionFilter = [];

                      ///terminal selection
                      Utility.posPaymentTerminalSelectionFilter = [];
                      Utility.holdPosPaymentTerminalSelectionFilter = [];
                      selectedTransactionStatus.clear();
                      selectedDisputeType.clear();
                      terminalSelectList.clear();

                      setState(() {});
                      Get.snackbar(
                        'Noted'.tr,
                        'Filter cleared'.tr,
                      );
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
                    disputeStatus(),
                    disputeType(),
                    height20(),
                    terminalSelection(),
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

  Column disputeType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        Text(
          'Dispute Type'.tr,
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
                    StaticData().posDisputesType.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              selectedDisputeType.clear();
                              selectedDisputeType
                                  .add(StaticData().posDisputesType[index]);
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
                                  color: selectedDisputeType.contains(
                                          StaticData().posDisputesType[index])
                                      ? ColorsUtils.primary
                                      : ColorsUtils.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  StaticData().posDisputesType[index].tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color: selectedDisputeType.contains(
                                              StaticData()
                                                  .posDisputesType[index])
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

  Column disputeStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customSmallMedBoldText(
            color: ColorsUtils.black, title: 'Disputes Status'.tr),
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
                        .add(StaticData().posDisputesStatus[index]);
                    print('status${selectedTransactionStatus}');
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
                                .contains(StaticData().posDisputesStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().posDisputesStatus[index].tr,
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedTransactionStatus.contains(
                                    StaticData().posDisputesStatus[index])
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
    Utility.holdPosDisputeTransactionTypeFilter =
        selectedDisputeType.isEmpty ? '' : selectedDisputeType.first;
    Utility.holdPosDisputeTransactionStatusFilter =
        selectedTransactionStatus.isEmpty
            ? ''
            : selectedTransactionStatus.first;

    ///disputes status
    Utility.posDisputeTransactionStatusFilter =
        selectedTransactionStatus.isEmpty
            ? ''
            : selectedTransactionStatus.first == 'Open'
                ? ',{"disputestatusId":"1"}'
                : selectedTransactionStatus.first == 'Under Review'
                    ? ',{"disputestatusId":"2"}'
                    : selectedTransactionStatus.first == 'Close'
                        ? ',{"disputestatusId":"3"}'
                        : '';

    ///disputes status
    Utility.posDisputeTransactionTypeFilter = selectedDisputeType.isEmpty
        ? ''
        : selectedDisputeType.first == 'ChargeBack'
            ? ',{"disputetypeId":"1"}'
            : selectedDisputeType.first == 'Fraud'
                ? ',{"disputetypeId":"2"}'
                : '';

    ///terminal selection
    Utility.holdPosPaymentTerminalSelectionFilter =
        terminalSelectList.isEmpty ? [] : terminalSelectList;

    Utility.posPaymentTerminalSelectionFilter =
        terminalSelectList.isEmpty ? [] : terminalSelectList;
    print(
        'type is ${Utility.posDisputeTransactionTypeFilter}  status ${Utility.posDisputeTransactionStatusFilter}');
  }
}
