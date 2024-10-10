import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalFilterGetSubUserResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/invoiceListViewModel.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? subUserId;
  List<GetSubUserNamesResponseModel>? getSubUserList;
  TextEditingController subUSerController = TextEditingController();
  InvoiceListViewModel invoiceListViewModel = Get.find();
  bool? groupValue;
  RangeValues _currentRangeValues =
      RangeValues(Utility.holdStartRange, Utility.holdEndRange);

  int isRadioSelected =
      Utility.holdFilterSorted == 4 ? 0 : Utility.holdFilterSorted;
  bool isFiltered = false;
  double startValue = 0;
  double endValue = 0;
  @override
  void initState() {
    subUserId = Utility.activityReportHoldGetSubUSerId;
    subUSerController.text = Utility.activityReportHoldGetSubUSer;
    initData();
    startValue = Utility.holdStartRange;
    endValue = Utility.holdEndRange;
    Utility.startRange = 0;
    Utility.endRange = 0;
    super.initState();
  }

  initData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await invoiceListViewModel.getSubUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height20(),
          topView(),
          centerView(),
          const Spacer(),
          InkWell(
              onTap: () {
                if (isFiltered == false) {
                  Utility.endRange = 0;
                  Utility.startRange = 0;
                }

                ///user name filter
                Utility.activityReportHoldGetSubUSer = subUSerController.text;
                Utility.activityReportHoldGetSubUSerId = subUserId ?? "NA";
                if (subUserId!.isNotEmpty || subUserId != '') {
                  Utility.activityReportGetSubUSer =
                      '&filter[where][createdby]=$subUserId';
                }
                print(
                    'Utility.activityReportHoldGetSubUSer==${Utility.activityReportHoldGetSubUSer}');
                Utility.startRange = _currentRangeValues.start;
                Utility.endRange = _currentRangeValues.end;
                Utility.holdEndRange = _currentRangeValues.end;
                Utility.holdStartRange = _currentRangeValues.start;
                Utility.holdFilterSorted = isRadioSelected;
                // isRadioSelected == 1
                //     ? Utility.filterSorted = '&filter[order]=created DESC'
                //     : isRadioSelected == 3
                //         ? Utility.filterSorted = '&filter[order]=invoiceno DESC'
                //         : isRadioSelected == 4
                //             ? Utility.filterSorted =
                //                 '&filter[order]=grossamount DESC'
                //             : Utility.filterSorted =
                //                 '&filter[order]=clientname ASC';
                Get.back();
              },
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Filter'.tr)),
          height20()
        ],
      ),
    ));
  }

  Column centerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //height20(),
        // Text(
        //   'Sort by'.tr,
        //   style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     LabeledRadio(
        //       label: 'Created date'.tr,
        //       value: 1,
        //       groupValue: isRadioSelected,
        //       onChanged: (newValue) {
        //         setState(() {
        //           isRadioSelected = newValue;
        //         });
        //       },
        //     ),
        //     LabeledRadio(
        //       label: 'Customer name'.tr,
        //       value: 2,
        //       groupValue: isRadioSelected,
        //       onChanged: (newValue) {
        //         setState(() {
        //           isRadioSelected = newValue;
        //         });
        //       },
        //     ),
        //     LabeledRadio(
        //       label: 'Invoice ID'.tr,
        //       value: 3,
        //       groupValue: isRadioSelected,
        //       onChanged: (newValue) {
        //         setState(() {
        //           isRadioSelected = newValue;
        //         });
        //       },
        //     ),
        //     LabeledRadio(
        //       label: 'Invoice amount'.tr,
        //       value: 4,
        //       groupValue: isRadioSelected,
        //       onChanged: (int newValue) {
        //         setState(() {
        //           isRadioSelected = newValue;
        //         });
        //       },
        //     ),
        //   ],
        // ),
        // Divider(),
        height20(),
        commonTextField(
            width: Get.width,
            onTap: () {
              print('hi');
              getSubUserBottomSheet(context);
            },
            hint: 'User name',
            contollerr: subUSerController,
            isRead: true,
            suffix: Icon(
              Icons.keyboard_arrow_down_outlined,
              size: 30,
            )),
      ],
    );
  }

  Future<void> getSubUserBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (BuildContext context) {
        return SizedBox(
          height: Get.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 65,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: ColorsUtils.dividerCreateInvoice,
                ),
              ),
              GetBuilder<InvoiceListViewModel>(
                builder: (controller) {
                  if (controller.activityGetSubUserApiResponse.status ==
                      Status.ERROR) {
                    return Expanded(child: noDataFound());
                  }
                  if (controller.activityGetSubUserApiResponse.status ==
                      Status.LOADING) {
                    return Expanded(child: Loader());
                  }
                  getSubUserList =
                      controller.activityGetSubUserApiResponse.data;
                  return getSubUserList == null
                      ? Expanded(child: noDataFound())
                      : Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.all(20),
                            shrinkWrap: true,
                            itemCount: getSubUserList!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: getSubUserList![index].name == null
                                    ? SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          Get.back();
                                          setState(() {
                                            // &filter[where][createdby]=2978"
                                            subUserId = getSubUserList![index]
                                                .id
                                                .toString();
                                            subUSerController.text =
                                                getSubUserList![index].name ??
                                                    'NA';
                                          });
                                        },
                                        child: customMediumBoldText(
                                            title: getSubUserList![index]
                                                .name
                                                .toString()
                                                .capitalize),
                                      ),
                              );
                            },
                          ),
                        );
                },
              )
            ],
          ),
        );
      },
    );
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
                subUSerController.clear();
                subUserId = '';
                Utility.activityReportGetSubUSer = '';
                Utility.activityReportHoldGetSubUSerId = '';
                Utility.activityReportHoldGetSubUSer = '';
                Utility.startRange = 0;
                Utility.endRange = 0;
                Utility.filterSorted = '&filter[order]=created DESC';
                Utility.holdFilterSorted = 4;
                Utility.holdStartRange = 0;
                Utility.holdEndRange = 0;

                _currentRangeValues =
                    RangeValues(Utility.holdStartRange, Utility.holdEndRange);

                isRadioSelected = Utility.holdFilterSorted == 4
                    ? 0
                    : Utility.holdFilterSorted;
                isFiltered = false;
                startValue = 0;
                endValue = 0;
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
        height30(),
        Text(
          'by Amount'.tr,
          style: ThemeUtils.blackSemiBold
              .copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        RangeSlider(
          values: _currentRangeValues,
          max: 20000,
          min: 0,
          divisions: 2000,
          labels: RangeLabels(
            _currentRangeValues.start.round().toString(),
            _currentRangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              isFiltered = true;
              _currentRangeValues = values;
              startValue = values.start;
              endValue = values.end;
              // Utility.startRange = values.start;
              // Utility.endRange = values.end;
            });
          },
        ),
        Row(
          children: [
            Text(
              '${startValue.toInt()} QAR',
              style:
                  ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small),
            ),
            const Spacer(),
            Text(
              '${endValue.toInt()} QAR',
              style:
                  ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small),
            ),
          ],
        ),
        height10(),
        const Divider(),
      ],
    );
  }
}
