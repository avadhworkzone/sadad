import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalFilterGetSubUserResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/invoiceListViewModel.dart';

class FilterProductScreen extends StatefulWidget {
  const FilterProductScreen({Key? key}) : super(key: key);

  @override
  State<FilterProductScreen> createState() => _FilterProductScreenState();
}

class _FilterProductScreenState extends State<FilterProductScreen> {
  String? subUserId;
  List<GetSubUserNamesResponseModel>? getSubUserList;
  TextEditingController subUSerController = TextEditingController();
  InvoiceListViewModel invoiceListViewModel = Get.find();
  bool? groupValue;
  RangeValues _currentRangeValues =
      RangeValues(Utility.holdStartRange, Utility.holdEndRange);
  int isRadioSelected = 0;
  int isRadioSelectedSort = 0;
  bool isFiltered = false;
  double startRange = 0;
  double endRange = 0;
  @override
  void initState() {
    subUserId = Utility.activityReportHoldGetSubUSerId;
    subUSerController.text = Utility.activityReportHoldGetSubUSer;
    Utility.startRange = 0;
    Utility.endRange = 0;
    initData();
    startRange = Utility.holdStartRange;
    endRange = Utility.holdEndRange;
    isRadioSelectedSort = Utility.holdSortBy == 6 ? 0 : Utility.holdSortBy;
    isRadioSelected = Utility.holdViewBy == 4 ? 0 : Utility.holdViewBy;
    setState(() {});
    // TODO: implement initState
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
        bottomNavigationBar: bottomButton(),
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
                      child: const Icon(Icons.arrow_back_ios)),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      subUSerController.clear();
                      subUserId = '';
                      Utility.viewBy = '';
                      Utility.activityReportGetSubUSer = '';
                      Utility.activityReportHoldGetSubUSerId = '';
                      Utility.activityReportHoldGetSubUSer = '';
                      Utility.productPrice = '';
                      Utility.sortBy = '';
                      Utility.viewBy = '';
                      Utility.productPrice = '';
                      Utility.countSortBy = '';
                      Utility.countViewBy = '';
                      Utility.countProductPrice = '';
                      Utility.holdViewBy = 4;
                      Utility.holdSortBy = 6;
                      Utility.holdStartRange = 0;
                      Utility.holdEndRange = 0;
                      Utility.productViewBy = 0;
                      _currentRangeValues = RangeValues(
                          Utility.holdStartRange, Utility.holdEndRange);
                      isRadioSelected = 0;
                      isRadioSelectedSort = 0;
                      isFiltered = false;
                      startRange = 0;
                      endRange = 0;
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topView(),
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
                      height20(),
                      Divider(),
                      bottomData(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
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

  Column bottomData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        customMediumBoldText(title: 'View by'),
        height20(),
        LabeledRadio(
          label: 'All'.tr,
          groupValue: 1,
          value: isRadioSelected,
          onChanged: (value) {
            isRadioSelected = 1;
            setState(() {});
          },
        ),
        LabeledRadio(
          label: 'In stock'.tr,
          groupValue: 2,
          value: isRadioSelected,
          onChanged: (value) {
            isRadioSelected = 2;
            setState(() {});
          },
        ),
        LabeledRadio(
          label: 'Out of stock'.tr,
          groupValue: 3,
          value: isRadioSelected,
          onChanged: (value) {
            isRadioSelected = 3;
            setState(() {});
          },
        ),
        height20(),
        Divider(),
        height20(),
        customMediumBoldText(title: 'Sort by'.tr),
        height20(),
        LabeledRadio(
          label: 'Created date'.tr,
          groupValue: 1,
          value: isRadioSelectedSort,
          onChanged: (value) {
            Utility.sortBy = '&filter[order]=created DESC';
            isRadioSelectedSort = 1;
            setState(() {});
          },
        ),
        LabeledRadio(
          label: 'Available Quantity'.tr,
          groupValue: 2,
          value: isRadioSelectedSort,
          onChanged: (value) {
            Utility.sortBy = '&filter[order]=totalavailablequantity DESC';

            isRadioSelectedSort = 2;
            setState(() {});
          },
        ),
        LabeledRadio(
          label: 'Product View'.tr,
          groupValue: 3,
          value: isRadioSelectedSort,
          onChanged: (value) {
            isRadioSelectedSort = 3;
            Utility.sortBy = '&filter[order]=viewcount DESC';
            setState(() {});
          },
        ),
        LabeledRadio(
          label: 'Price'.tr,
          groupValue: 4,
          value: isRadioSelectedSort,
          onChanged: (value) {
            isRadioSelectedSort = 4;
            Utility.sortBy = '&filter[order]=price DESC';

            setState(() {});
          },
        ),
        LabeledRadio(
          label: 'Name'.tr,
          groupValue: 5,
          value: isRadioSelectedSort,
          onChanged: (value) {
            Utility.sortBy = "&filter[order]=name DESC";

            isRadioSelectedSort = 5;
            setState(() {});
          },
        ),
      ],
    );
  }

  Column bottomButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        height20(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () {
              ///user name filter
              Utility.activityReportHoldGetSubUSer = subUSerController.text;
              Utility.activityReportHoldGetSubUSerId = subUserId ?? "NA";
              if (subUserId == null || subUserId == '') {
                Utility.activityReportGetSubUSer = '';
              } else {
                Utility.activityReportGetSubUSer = '$subUserId';
              }
              Utility.holdSortBy = isRadioSelectedSort;
              Utility.holdViewBy = isRadioSelected;
              Utility.productViewBy = isRadioSelected;
              Utility.viewBy = isRadioSelected == 3
                  ? '&filter[where][isUnlimited]=0&filter[where][totalavailablequantity][lt]=1'
                  : isRadioSelected == 2
                      ? '&filter[where][isUnlimited]=0&filter[where][totalavailablequantity][gt]=0'
                      : '';
              Utility.countViewBy = isRadioSelected == 3
                  ? ',{"totalavailablequantity":{"lt":"1"}},{"isUnlimited":"0"}'
                  : isRadioSelected == 2
                      ? ',{"or":[{"totalavailablequantity":{"gt":"0"}},{"isUnlimited":true}]}'
                      : "";
              Utility.sortBy = isRadioSelectedSort == 1
                  ? '&filter[order]=created DESC'
                  : isRadioSelectedSort == 2
                      ? '&filter[order]=totalavailablequantity DESC'
                      : isRadioSelectedSort == 3
                          ? '&filter[order]=viewcount DESC'
                          : isRadioSelectedSort == 4
                              ? '&filter[order]=price DESC'
                              : isRadioSelectedSort == 5
                                  ? '&filter[order]=name DESC'
                                  : "";
              Utility.countSortBy = ',"order":["created DESC"]';
              Utility.holdEndRange = _currentRangeValues.end;
              Utility.holdStartRange = _currentRangeValues.start;
              if (startRange != 0 || endRange != 0) {
                Utility.productPrice =
                    '&filter[where][price][between][0]=$startRange&filter[where][price][between][1]=$endRange';
                Utility.countProductPrice =
                    ',{"price":{"between":[$startRange,$endRange]}}';
              }

              Get.back();
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Filter'.tr),
          ),
        ),
        height30()
      ],
    );
  }

  Column topView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height30(),
        Text(
          'Filter'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
        ),
        height30(),
        Text(
          'by Amount'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
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
              startRange = values.start;
              endRange = values.end;

              Utility.startRange = values.start;
              Utility.endRange = values.end;
            });
          },
        ),
        Row(
          children: [
            Text(
              '${startRange.toInt()} QAR',
              style:
                  ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small),
            ),
            const Spacer(),
            Text(
              '${endRange.toInt()} QAR',
              style:
                  ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small),
            ),
          ],
        ),
        height20(),
        const Divider(),
      ],
    );
  }
}
