import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/userBankListResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';

class ActivityFilterWithdrawalScreen extends StatefulWidget {
  const ActivityFilterWithdrawalScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ActivityFilterWithdrawalScreen> createState() =>
      _ActivityFilterWithdrawalScreenState();
}

class _ActivityFilterWithdrawalScreenState
    extends State<ActivityFilterWithdrawalScreen> {
  List<String> withStatus = [];
  List<String> payoutStatus = [];
  List<String> withType = [];
  List selectBank = [];
  List selectBankId = [];
  String token = '';
  SettlementWithdrawalListViewModel settlementListViewModel = Get.find();
  List<UserBankListResponseModel> userBankRes = [];
  @override
  void initState() {
    withStatus.add(Utility.holdSettlementWithdrawFilterStatus);
    print('status ${withStatus}');
    withType.add(Utility.holdSettlementWithdrawFilterType);
    print('type ${withType}');
    payoutStatus.add(Utility.holdSettlementPayoutFilterStatus);
    print('type ${withType}');
    selectBank.add(Utility.holdSettlementPayoutFilterBank);
    print('type ${withType}');
    setState(() {});

    // TODO: implement initState
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
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
                    Utility.settlementWithdrawFilterStatus = '';
                    Utility.settlementWithdrawFilterType = '';
                    Utility.settlementPayoutFilterStatus = '';
                    Utility.settlementPayoutFilterBank = '';
                    Utility.holdSettlementPayoutFilterStatus = '';
                    Utility.holdSettlementPayoutFilterBank = '';
                    Utility.holdSettlementWithdrawFilterStatus = '';
                    Utility.holdSettlementWithdrawFilterType = '';
                    withStatus = [];
                    payoutStatus = [];
                    withType = [];
                    selectBank = [];
                    selectBankId = [];
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                      withType.add(
                                          StaticData().withTypeFilter[index]);
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: withType.contains(StaticData()
                                                  .withTypeFilter[index])
                                              ? ColorsUtils.accent
                                              : ColorsUtils.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorsUtils.border,
                                              width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        child: customSmallSemiText(
                                          title: StaticData()
                                              .withTypeFilter[index],
                                          color: withType.contains(StaticData()
                                                  .withTypeFilter[index])
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

                                      withStatus.add(
                                          StaticData().withStatusFilter[index]);

                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: withStatus.contains(
                                                  StaticData()
                                                      .withStatusFilter[index])
                                              ? ColorsUtils.accent
                                              : ColorsUtils.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorsUtils.border,
                                              width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        child: customSmallSemiText(
                                          title: StaticData()
                                              .withStatusFilter[index]
                                              .tr,
                                          color: withStatus.contains(
                                                  StaticData()
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
                        customMediumSemiText(
                            title: 'Payout Status (Bank Action)'),
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

                                      payoutStatus.add(StaticData()
                                          .payOutStatusFilter[index]);

                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: payoutStatus.contains(
                                                  StaticData()
                                                          .payOutStatusFilter[
                                                      index])
                                              ? ColorsUtils.accent
                                              : ColorsUtils.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorsUtils.border,
                                              width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        child: customSmallSemiText(
                                          title: StaticData()
                                              .payOutStatusFilter[index]
                                              .tr,
                                          color: payoutStatus.contains(
                                                  StaticData()
                                                          .payOutStatusFilter[
                                                      index])
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: selectBank
                                                    .contains(index.toString())
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
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color:
                                                            ColorsUtils.black)),
                                                child: selectBank.contains(
                                                        index.toString())
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
                                                    HttpHeaders
                                                            .authorizationHeader:
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
            )
          ],
        ),
      ),
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
                Utility.holdSettlementWithdrawFilterStatus = withStatus.first;
                Utility.settlementWithdrawFilterStatus = withStatus
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
                Utility.holdSettlementWithdrawFilterType = withType.first;

                Utility.settlementWithdrawFilterType =
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
              if (selectBank.isNotEmpty) {
                Utility.holdSettlementPayoutFilterBank =
                    selectBank.first.toString();
              }
              if (payoutStatus.isNotEmpty) {
                Utility.holdSettlementPayoutFilterStatus = payoutStatus.first;
                Utility.settlementPayoutFilterStatus =
                    payoutStatus.contains('Processed')
                        ? '&filter[where][payoutstatus]=3'
                        : payoutStatus.contains('Rejected')
                            ? '&filter[where][payoutstatus]=4'
                            : '';
              }
              if (selectBankId.isNotEmpty) {
                print('selectBankId$selectBankId');
                Utility.settlementPayoutFilterBank =
                    (selectBankId.isEmpty || selectBankId.first == '')
                        ? ''
                        : '&filter[where][userbankId]=${selectBankId.first}';
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
    userBankRes = settlementListViewModel.userBankListApiResponse.data;
    setState(() {});
    print('userBankRes $userBankRes ');
  }
}
