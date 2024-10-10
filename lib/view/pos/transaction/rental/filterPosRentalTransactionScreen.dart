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

import '../../../../viewModel/pos/terminal/terminalViewModel.dart';

class FilterRentalPosTransaction extends StatefulWidget {
  String? terminalId;
  String? selectedTimeZone;
  String? startDate;
  String? endDate;
  bool? isFromSearch;
  FilterRentalPosTransaction(
      {Key? key,
      required this.terminalId,
      this.selectedTimeZone,
      this.startDate,
      this.isFromSearch,
      this.endDate})
      : super(key: key);

  @override
  State<FilterRentalPosTransaction> createState() =>
      _FilterRentalPosTransactionState();
}

class _FilterRentalPosTransactionState
    extends State<FilterRentalPosTransaction> {
  List<String> selectedPaymentStatus = [];
  bool isVolume = false;
  List terminalSelectList = [];
  TerminalViewModel terminalViewModel = Get.find();
  List<TerminalListResponseModel>? terminalListRes;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
    selectedPaymentStatus.add(Utility.holdPosRentalPaymentStatusFilter);
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
                      Utility.posRentalPaymentStatusFilter = '';
                      Utility.holdPosRentalPaymentStatusFilter = '';
                      Utility.holdPosPaymentTerminalSelectionFilter = [];
                      Utility.posPaymentTerminalSelectionFilter = [];
                      selectedPaymentStatus.clear();
                      widget.terminalId = '';
                      terminalSelectList.clear();
                      setState(() {});
                      Get.snackbar(
                        'Please Note'.tr,
                        'Filter cleared'.tr,
                      );
                      // Get.snackbar(
                      //   '',
                      //   'Filter cleared'.tr,
                      // );
                    },
                    child: customSmallMedBoldText(
                        color: ColorsUtils.accent, title: 'Clear Filter'.tr),
                  ),
                ],
              ),
              height40(),
              customLargeBoldText(title: 'Filter'.tr, color: ColorsUtils.black),
              height40(),
              customSmallMedBoldText(
                  color: ColorsUtils.black, title: 'Rental Payment Status'.tr),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    height20(),
                    SizedBox(
                      height: 25,
                      width: Get.width,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: StaticData().posTransaction.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: InkWell(
                              onTap: () async {
                                selectedPaymentStatus.clear();
                                selectedPaymentStatus
                                    .add(StaticData().posTransaction[index]);

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
                                    color: selectedPaymentStatus.contains(
                                            StaticData().posTransaction[index])
                                        ? ColorsUtils.primary
                                        : ColorsUtils.white),
                                child: Center(
                                  child: Text(
                                    StaticData().posTransaction[index].tr,
                                    style: ThemeUtils.blackBold.copyWith(
                                        fontSize: FontUtils.verySmall,
                                        color: selectedPaymentStatus.contains(
                                                StaticData()
                                                    .posTransaction[index])
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

  Widget bottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () {
              Utility.holdPosRentalPaymentStatusFilter =
                  selectedPaymentStatus.isEmpty
                      ? ''
                      : selectedPaymentStatus.first;
              Utility.posRentalPaymentStatusFilter =
                  selectedPaymentStatus.isEmpty
                      ? ''
                      : selectedPaymentStatus.first == 'Unpaid'
                          ? '&filter[where][invoicestatusId]=2'
                          : selectedPaymentStatus.first == 'Paid'
                              ? '&filter[where][invoicestatusId]=3'
                              : '';
              Utility.holdPosPaymentTerminalSelectionFilter =
                  terminalSelectList.isEmpty ? [] : terminalSelectList;

              ///terminal selection
              Utility.posPaymentTerminalSelectionFilter =
                  terminalSelectList.isEmpty ? [] : terminalSelectList;
              print('widget.terminalId===${widget.terminalId}');
              if (widget.isFromSearch == true) {
                Get.back();
              } else {
                Get.off(PosTransactionListScreen(
                  isFromPosRental: true,
                  terminalFilter: widget.terminalId,
                  endDate: widget.endDate,
                  startDate: widget.startDate,
                  selectedTimeZone: widget.selectedTimeZone,
                  selectedTab: 3,
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
}
