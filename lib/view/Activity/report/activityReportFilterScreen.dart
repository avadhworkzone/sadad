// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/activityWithdrawalFilterGetSubUserResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/userBankListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityReport.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';

class ActivityReportFilterWithdrawalScreen extends StatefulWidget {
  const ActivityReportFilterWithdrawalScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivityReportFilterWithdrawalScreen> createState() =>
      _ActivityReportFilterWithdrawalScreenState();
}

class _ActivityReportFilterWithdrawalScreenState
    extends State<ActivityReportFilterWithdrawalScreen> {
  List<String> withStatus = [];
  ActivityReportViewModel activityReportViewModel = Get.find();
  List<GetSubUserNamesResponseModel>? getSubUserList;
  TextEditingController subUSerController = TextEditingController();
  List<String> payoutStatus = [];
  List<String> withType = [];
  List selectBank = [];
  String? subUserId;
  List selectBankId = [];
  String token = '';
  SettlementWithdrawalListViewModel settlementListViewModel = Get.find();
  List<UserBankListResponseModel> userBankRes = [];
  @override
  void initState() {
    withStatus.add(Utility.activityReportHoldSettlementWithdrawFilterStatus);

    withType.add(Utility.activityReportHoldSettlementWithdrawFilterType);

    payoutStatus.add(Utility.activityReportHoldSettlementPayoutFilterStatus);

    selectBank.add(Utility.activityReportHoldSettlementPayoutFilterBank);

    subUserId = Utility.activityReportHoldGetSubUSerId;

    subUSerController.text = Utility.activityReportHoldGetSubUSer;
    setState(() {});

    // TODO: implement initState
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      body: SingleChildScrollView(
        child: Padding(
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
                      Utility.activityReportSettlementWithdrawFilterStatus = '';
                      Utility.activityReportSettlementWithdrawFilterType = '';
                      Utility.activityReportSettlementPayoutFilterStatus = '';
                      Utility.activityReportSettlementPayoutFilterBank = '';
                      Utility.activityReportHoldSettlementPayoutFilterStatus =
                          '';
                      Utility.activityReportHoldSettlementPayoutFilterBank = '';
                      Utility.activityReportHoldSettlementWithdrawFilterStatus =
                          '';
                      Utility.activityReportHoldSettlementWithdrawFilterType =
                          '';
                      Utility.activityReportHoldGetSubUSer = '';
                      Utility.activityReportGetSubUSer = '';
                      Utility.activityReportHoldGetSubUSerId = '';

                      subUSerController.clear();
                      withStatus = [];
                      payoutStatus = [];
                      withType = [];
                      selectBank = [];
                      selectBankId = [];
                      subUserId = '';
                      setState(() {});
                      // Get.back();
                      Get.snackbar('Success', 'Filter Cleared!');
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
              Text(
                'Filter'.tr,
                style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.large),
              ),
              height30(),

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
              height30(),

              ///Withdrawal Type
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customMediumSemiText(title: 'Withdrawal Type'.tr),
                  height20(),
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    direction: Axis.horizontal,
                    children: List.generate(
                        StaticData().withTypeFilter.length,
                        (index) => InkWell(
                              onTap: () {
                                withType.clear();
                                withType
                                    .add(StaticData().withTypeFilter[index]);
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: withType.contains(
                                            StaticData().withTypeFilter[index])
                                        ? ColorsUtils.accent
                                        : ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: customSmallSemiText(
                                    title: StaticData().withTypeFilter[index],
                                    color: withType.contains(
                                            StaticData().withTypeFilter[index])
                                        ? ColorsUtils.white
                                        : ColorsUtils.black,
                                  ),
                                ),
                              ),
                            )),
                  ),
                  height20(),
                  Divider(),
                  height20(),
                ],
              ),

              ///Withdrawal Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customMediumSemiText(
                      title: 'Withdrawal Status (Sadad Action)'),
                  height20(),
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    direction: Axis.horizontal,
                    children: List.generate(
                        StaticData().withStatusFilter.length,
                        (index) => InkWell(
                              onTap: () {
                                withStatus.clear();

                                withStatus
                                    .add(StaticData().withStatusFilter[index]);

                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: withStatus.contains(StaticData()
                                            .withStatusFilter[index])
                                        ? ColorsUtils.accent
                                        : ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: customSmallSemiText(
                                    title:
                                        StaticData().withStatusFilter[index].tr,
                                    color: withStatus.contains(StaticData()
                                            .withStatusFilter[index])
                                        ? ColorsUtils.white
                                        : ColorsUtils.black,
                                  ),
                                ),
                              ),
                            )),
                  ),
                ],
              ),

              ///Payout Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height20(),
                  Divider(),
                  height20(),
                  customMediumSemiText(title: 'Payout Status (Bank Action)'),
                  height20(),
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    direction: Axis.horizontal,
                    children: List.generate(
                        StaticData().payOutStatusFilter.length,
                        (index) => InkWell(
                              onTap: () {
                                payoutStatus.clear();

                                payoutStatus.add(
                                    StaticData().payOutStatusFilter[index]);

                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: payoutStatus.contains(StaticData()
                                            .payOutStatusFilter[index])
                                        ? ColorsUtils.accent
                                        : ColorsUtils.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: customSmallSemiText(
                                    title: StaticData()
                                        .payOutStatusFilter[index]
                                        .tr,
                                    color: payoutStatus.contains(StaticData()
                                            .payOutStatusFilter[index])
                                        ? ColorsUtils.white
                                        : ColorsUtils.black,
                                  ),
                                ),
                              ),
                            )),
                  ),
                  height20(),
                ],
              ),

              ///select bank
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  height20(),
                  customMediumSemiText(title: 'Select Bank'.tr),
                  (userBankRes.isEmpty || userBankRes == null)
                      ? SizedBox()
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userBankRes.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  selectBank.clear();
                                  selectBankId.clear();
                                  selectBank.add(index.toString());
                                  selectBankId.add(userBankRes[index].id);
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          selectBank.contains(index.toString())
                                              ? ColorsUtils.lightPink
                                              : Colors.transparent),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              // color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: ColorsUtils.black)),
                                          child: selectBank
                                                  .contains(index.toString())
                                              ? Icon(
                                                  Icons.check,
                                                  size: 15,
                                                )
                                              : SizedBox(),
                                        ),
                                        width20(),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: ColorsUtils.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: ColorsUtils.border,
                                                width: 1),
                                          ),
                                          child: Image.network(
                                            '${Utility.baseUrl}containers/api-banks/download/${userBankRes[index].bank!.logo}',
                                            headers: {
                                              HttpHeaders.authorizationHeader:
                                                  token
                                            },
                                            fit: BoxFit.contain,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        width20(),
                                        Expanded(
                                            child: Wrap(
                                          children: [
                                            customSmallSemiText(
                                                title: userBankRes[index]
                                                        .bank!
                                                        .name ??
                                                    'NA'),
                                            customSmallSemiText(
                                                title:
                                                    ' - ****${userBankRes[index].ibannumber.toString().substring(userBankRes[index].ibannumber.toString().length - 4)}'),
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              )
            ],
          ),
        ),
      ),
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
              GetBuilder<ActivityReportViewModel>(
                builder: (controller) {
                  if (controller.activityGetSubUserApiResponse.status ==
                      Status.ERROR) {
                    return Expanded(child: noDataFound());
                  }
                  if (controller.activityGetSubUserApiResponse.status ==
                      Status.LOADING) {
                    return Expanded(child: Loader());
                  }
                  getSubUserList = activityReportViewModel
                      .activityGetSubUserApiResponse.data;
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

  Column bottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: InkWell(
            onTap: () {
              if (withStatus.isNotEmpty) {
                Utility.activityReportHoldSettlementWithdrawFilterStatus =
                    withStatus.first;
                Utility
                    .activityReportSettlementWithdrawFilterStatus = withStatus
                        .contains('Accepted')
                    ? '&filter[where][withdrawalrequeststatusId][inq][0]=1&filter[where][withdrawalrequeststatusId][inq][1]=5'
                    : withStatus.contains('Requested')
                        ? '&filter[where][withdrawalrequeststatusId][inq][0]=3'
                        : withStatus.contains('Rejected')
                            ? '&filter[where][withdrawalrequeststatusId][inq][0]=2'
                            : withStatus.contains('On Hold')
                                ? '&filter[where][withdrawalrequeststatusId][inq][0]=4'
                                : withStatus.contains('Cancelled')
                                    ? '&filter[where][withdrawalrequeststatusId][inq][0]=6'
                                    : '';
              }
              if (withType.isNotEmpty) {
                Utility.activityReportHoldSettlementWithdrawFilterType =
                    withType.first;

                Utility.activityReportSettlementWithdrawFilterType =
                    withType.contains('Manual')
                        ? '&filter[where][withdrawaltype]=manual'
                        : withType.contains('Daily')
                            ? '&filter[where][withdrawaltype]=daily'
                            : withType.contains('Monthly')
                                ? '&filter[where][withdrawaltype]=monthly'
                                : withType.contains('Weekly')
                                    ? '&filter[where][withdrawaltype]=weekly'
                                    : '';
              }

              print('selectBankId$selectBankId');
              if (selectBank.isNotEmpty) {
                Utility.activityReportHoldSettlementPayoutFilterBank =
                    selectBank.first.toString();
              }
              Utility.activityReportSettlementPayoutFilterBank =
                  (selectBankId.isEmpty || selectBankId.first == '')
                      ? ''
                      : '&filter[where][userbankId]=${selectBankId.first}';
              if (payoutStatus.isNotEmpty) {
                Utility.activityReportHoldSettlementPayoutFilterStatus =
                    payoutStatus.first;
                Utility.activityReportSettlementPayoutFilterStatus =
                    payoutStatus.contains('Processed')
                        ? '&filter[where][payoutstatus]=3'
                        : payoutStatus.contains('Rejected')
                            ? '&filter[where][payoutstatus]=4'
                            : '';
              }

              Utility.activityReportHoldGetSubUSer = subUSerController.text;
              Utility.activityReportHoldGetSubUSerId = subUserId ?? "NA";
              if (subUserId!.isNotEmpty || subUserId != '') {
                Utility.activityReportGetSubUSer =
                    '&filter[where][createdby]=$subUserId';
              }

              Get.back();
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Filter'),
          ),
        )
      ],
    );
  }

  initData() async {
    token = await encryptedSharedPreferences.getString('token');
    await settlementListViewModel.userBankList();
    if (settlementListViewModel.userBankListApiResponse.status ==
        Status.COMPLETE) {
      userBankRes = settlementListViewModel.userBankListApiResponse.data;
    }

    await activityReportViewModel.getSubUser();

    // if (activityReportViewModel.activityGetSubUserApiResponse.status ==
    //     Status.COMPLETE) {
    //

    setState(() {});
    print('userBankRes $userBankRes ');
    // }
  }

  Center noDataFound() => Center(child: Text('No data found'.tr));
}
