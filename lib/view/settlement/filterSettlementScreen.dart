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

class FilterSettlementScreen extends StatefulWidget {
  final int tab;
  const FilterSettlementScreen({Key? key, required this.tab}) : super(key: key);

  @override
  State<FilterSettlementScreen> createState() => _FilterSettlementScreenState();
}

class _FilterSettlementScreenState extends State<FilterSettlementScreen> {
  List<String> withStatus = [];
  List<String> withType = [];
  List selectBank = [];
  List selectBankId = [];
  String token = '';
  SettlementWithdrawalListViewModel settlementListViewModel = Get.find();
  List<UserBankListResponseModel> userBankRes = [];
  @override
  void initState() {
    print(widget.tab);
    if (widget.tab == 0) {
      withStatus.add(Utility.holdSettlementWithdrawFilterStatus);
      print('status ${withStatus}');
      withType.add(Utility.holdSettlementWithdrawFilterType);
      print('type ${withType}');
      setState(() {});
    } else {
      print('status ${Utility.holdSettlementPayoutFilterStatus}');
      print('bank ${Utility.holdSettlementPayoutFilterBank}');
      withStatus.add(Utility.holdSettlementPayoutFilterStatus);
      selectBank.add(Utility.holdSettlementPayoutFilterBank);
      setState(() {});
    }
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
                      Get.back();
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
              customMediumBoldText(
                  title: widget.tab == 1
                      ? 'Payout Status'.tr
                      : 'Withdrawal Status'.tr),
              height20(),
              Wrap(
                runSpacing: 10,
                spacing: 10,
                direction: Axis.horizontal,
                children: List.generate(
                    widget.tab == 1
                        ? StaticData().payOutStatusFilter.length
                        : StaticData().withStatusFilter.length,
                    (index) => InkWell(
                          onTap: () {
                            withStatus.clear();
                            if (widget.tab == 1) {
                              withStatus
                                  .add(StaticData().payOutStatusFilter[index]);
                            } else {
                              withStatus
                                  .add(StaticData().withStatusFilter[index]);
                            }

                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: withStatus.contains(widget.tab == 1
                                        ? StaticData().payOutStatusFilter[index]
                                        : StaticData().withStatusFilter[index])
                                    ? ColorsUtils.accent
                                    : ColorsUtils.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: ColorsUtils.border, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: customSmallSemiText(
                                title: widget.tab == 1
                                    ? StaticData().payOutStatusFilter[index].tr
                                    : StaticData().withStatusFilter[index].tr,
                                color: withStatus.contains(widget.tab == 1
                                        ? StaticData().payOutStatusFilter[index]
                                        : StaticData().withStatusFilter[index])
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
              widget.tab == 1
                  ? SizedBox()
                  : customMediumBoldText(title: 'Withdrawal Type'.tr),
              height20(),
              widget.tab == 1
                  ? SizedBox()
                  : Wrap(
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
                                      color: withType.contains(StaticData()
                                              .withTypeFilter[index])
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
                                          StaticData().withTypeFilter[index].tr,
                                      color: withType.contains(StaticData()
                                              .withTypeFilter[index])
                                          ? ColorsUtils.white
                                          : ColorsUtils.black,
                                    ),
                                  ),
                                ),
                              )),
                    ),
              widget.tab == 1
                  ? customMediumBoldText(title: 'Select Bank'.tr)
                  : SizedBox(),
              widget.tab == 1
                  ? (userBankRes.isEmpty || userBankRes == null)
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
                        )
                  : SizedBox()
            ],
          ),
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
              if (widget.tab == 0) {
                Utility.holdSettlementWithdrawFilterStatus = withStatus.first;
                Utility.holdSettlementWithdrawFilterType = withType.first;
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
              } else {
                print('selectBankId$selectBankId');
                Utility.holdSettlementPayoutFilterBank =
                    selectBank.first.toString();
                Utility.holdSettlementPayoutFilterStatus = withStatus.first;
                Utility.settlementPayoutFilterBank =
                    (selectBankId.isEmpty || selectBankId.first == '')
                        ? ''
                        : '&filter[where][userbankId]=${selectBankId.first}';

                Utility.settlementPayoutFilterStatus =
                    withStatus.contains('Pending')
                        ? '&filter[where][payoutstatusId]=1'
                        : withStatus.contains('Processing')
                            ? '&filter[where][payoutstatusId]=2'
                            : withStatus.contains('Processed')
                                ? '&filter[where][payoutstatusId]=3'
                                : withStatus.contains('Rejected')
                                    ? '&filter[where][payoutstatusId]=4'
                                    : '';
              }

              Get.back();
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Filter'.tr),
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
