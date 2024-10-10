import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalFilterGetSubUserResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityReport.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/invoiceListViewModel.dart';

class InvoiceReportFilterScreen extends StatefulWidget {
  const InvoiceReportFilterScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceReportFilterScreen> createState() =>
      _InvoiceReportFilterScreenState();
}

class _InvoiceReportFilterScreenState extends State<InvoiceReportFilterScreen> {
  String? subUserId;

  List<GetSubUserNamesResponseModel>? getSubUserList;
  TextEditingController subUSerController = TextEditingController();
  int isRadioSelected =
      Utility.holdFilterSorted == 4 ? 0 : Utility.holdFilterSorted;
  bool isFiltered = false;
  double startValue = 0;
  double endValue = 0;
  InvoiceListViewModel invoiceListViewModel = Get.find();
  List invoiceStatus = [];

  @override
  void initState() {
    invoiceStatus.add(Utility.holdOnlineInvoiceFilterStatus);
    subUserId = Utility.activityReportHoldGetSubUSerId;
    subUSerController.text = Utility.activityReportHoldGetSubUSer;
    initData();
    Utility.startRange = 0;
    Utility.endRange = 20000;
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
                ///user name filter
                Utility.activityReportHoldGetSubUSer = subUSerController.text;
                Utility.activityReportHoldGetSubUSerId = subUserId ?? "NA";
                if (subUserId!.isNotEmpty || subUserId != '') {
                  Utility.activityReportGetSubUSer =
                      '&filter[where][createdby]=$subUserId';
                }
                print(
                    'Utility.activityReportHoldGetSubUSer==${Utility.activityReportHoldGetSubUSer}');

                ///invoice status
                if (invoiceStatus.isNotEmpty || invoiceStatus.length > 0) {
                  Utility.onlineInvoiceFilterStatus =
                      invoiceStatus.first == 'Rejected'
                          ? '&filter[where][invoicestatusId]=5'
                          : invoiceStatus.first == 'Paid'
                              ? '&filter[where][invoicestatusId]=3'
                              : invoiceStatus.first == 'Draft'
                                  ? '&filter[where][invoicestatusId]=1'
                                  : invoiceStatus.first == 'Unpaid'
                                      ? '&filter[where][invoicestatusId]=2'
                                      : '';
                  Utility.holdOnlineInvoiceFilterStatus = invoiceStatus.first;
                }

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
        ///user
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

        ///invoice status
        commonWrapList(
            listName: StaticData().invoiceType,
            key: 'Invoice Status',
            filterName: invoiceStatus),
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
                Utility.holdOnlineInvoiceFilterStatus = '';
                Utility.onlineInvoiceFilterStatus = '';
                Utility.activityReportHoldGetSubUSer = '';
                invoiceStatus = [];
                Get.snackbar('Noted', 'Filter Cleared!');
                setState(() {});
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
}
