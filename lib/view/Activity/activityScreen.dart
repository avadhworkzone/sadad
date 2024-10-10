// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/balanceListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityPosRendtalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/activityTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/activityWithdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/report/activityReportScreen.dart';
import 'package:sadad_merchat_app/view/Activity/transactionListScreen.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/transferScreen.dart';
import 'package:sadad_merchat_app/view/Activity/withdrawal/withdrawalScreen.dart';
import 'package:sadad_merchat_app/view/settlement/settlementWithdrawalScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/dashBoardViewModel.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String today = DateFormat('dd MMM').format(DateTime.now());
  DashBoardViewModel dashBoardViewModel = Get.find();
  ActivityViewModel activityViewModel = Get.find();
  final GlobalKey _key = GlobalKey();
  BalanceListResponseModel balanceListRes = BalanceListResponseModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
      if (_key.currentContext == null) {
        return;
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarData(),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              GetBuilder<DashBoardViewModel>(
                builder: (controller) {
                  if (controller.availableBalanceApiResponse.status ==
                          Status.LOADING ||
                      controller.availableBalanceApiResponse.status ==
                          Status.INITIAL) {
                    return const Center(child: Loader());
                  }
                  if (controller.availableBalanceApiResponse.status ==
                      Status.ERROR) {
                    return const SessionExpire();
                    // return Text('something wrong');
                  }
                  AvailableBalanceResponseModel avaBalResponse =
                      controller.availableBalanceApiResponse.data;
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 40),
                            color: ColorsUtils.lightPink,
                            height: Get.height * 0.2,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 20,
                            right: 20,
                            child: GestureDetector(
                              onTap: () async {
                                Utility.settlementWithdrawPeriodAlready = false;
                                Utility.settlementWithdrawPeriod = '';
                                await Get.to(
                                    () => SettlementWithdrawalScreen());

                                availBal();
                              },
                              child: Container(
                                width: Get.width,
                                // height: Get.height * 0.22,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment(-0.7, -1),
                                      end: Alignment(0.3, 1),
                                      stops: [0.1, 0.4, 0.9],
                                      colors: [
                                        ColorsUtils.orange,
                                        ColorsUtils.darkOrange,
                                        ColorsUtils.darkMaroon,
                                      ],
                                    ),
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            ColorsUtils.black.withOpacity(0.25),
                                            BlendMode.srcATop),
                                        image: const AssetImage(
                                            Images.carViewMaroon),
                                        fit: BoxFit.cover),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Total Available Balance".tr,
                                            style: ThemeUtils.whiteRegular
                                                .copyWith(
                                                    fontSize: FontUtils.small),
                                          )),
                                          Text(
                                            today,
                                            style: ThemeUtils.whiteRegular
                                                .copyWith(
                                                    fontSize:
                                                        FontUtils.verySmall),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      currencyText(
                                          avaBalResponse.totalavailablefunds!
                                              .toDouble(),
                                          ThemeUtils.whiteBold.copyWith(
                                              fontSize: FontUtils.large),
                                          ThemeUtils.whiteRegular.copyWith(
                                              fontSize: FontUtils.small)),
                                      height30(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              Utility.settlementWithdrawPeriodAlready =
                                                  false;
                                              Utility.settlementWithdrawPeriod =
                                                  '';
                                              await Get.to(() =>
                                                  SettlementWithdrawalScreen());
                                              availBal();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: ColorsUtils.white,
                                                textStyle: ThemeUtils
                                                    .maroonSemiBold
                                                    .copyWith(
                                                        fontSize: FontUtils
                                                            .verySmall),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12))),
                                            child: Text(
                                              "settlement".tr,
                                              style: ThemeUtils.maroonSemiBold
                                                  .copyWith(
                                                      fontSize:
                                                          FontUtils.verySmall),
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          InkWell(
                                              child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(6),
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color: Color(0xff8E1B3E),
                                                      size: 15,
                                                    ),
                                                  )))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              height30(),

              ///main modules
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: Get.width * 0.3,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Utility.settlementWithdrawFilterStatus = '';
                            Utility.settlementWithdrawFilterType = '';
                            Utility.settlementPayoutFilterStatus = '';
                            Utility.settlementPayoutFilterBank = '';
                            Utility.holdSettlementPayoutFilterStatus = '';
                            Utility.holdSettlementPayoutFilterBank = '';
                            Utility.holdSettlementWithdrawFilterStatus = '';
                            Utility.holdSettlementWithdrawFilterType = '';
                            Get.to(() => WithdrawalScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: ColorsUtils.border, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Images.withdrawImage,
                                    height: Get.height * 0.05,
                                  ),
                                  height20(),
                                  customSmallSemiText(title: 'Withdrawals')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      width8(),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => TransferScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: ColorsUtils.border, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Images.transferImage,
                                    height: Get.height * 0.05,
                                  ),
                                  height20(),
                                  customSmallSemiText(title: 'Transfer')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      width8(),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ActivityReportScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: ColorsUtils.border, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Images.report,
                                    height: Get.height * 0.05,
                                  ),
                                  height20(),
                                  customSmallSemiText(title: 'Reports')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              height10(),

              ///all list row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    customMediumSemiText(title: 'Last Transactions'),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        await Get.to(() => ActivityTransactionList());
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          activityViewModel.setTransactionInit();
                          initData();
                        });
                      },
                      child: customSmallSemiText(
                          title: 'View All', color: ColorsUtils.accent),
                    ),
                    width10(),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 15,
                      color: ColorsUtils.accent,
                    )
                  ],
                ),
              ),
              height30(),

              ///list transaction
              GetBuilder<ActivityViewModel>(
                builder: (controller) {
                  if (controller.balanceListApiResponse.status ==
                          Status.LOADING ||
                      controller.balanceListApiResponse.status ==
                          Status.INITIAL) {
                    return Loader();
                  }
                  if (controller.balanceListApiResponse.status ==
                      Status.ERROR) {
                    // return Center(child: Text('Error'));
                    return SessionExpire();
                  }

                  balanceListRes.data = controller.response;
                  if (balanceListRes.data == null ||
                      balanceListRes.data == []) {
                    return Center(child: Text('No data found'));
                  }
                  return ListView.builder(
                    itemCount: balanceListRes.data!.length > 2
                        ? 3
                        : balanceListRes.data!.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color: ColorsUtils.tabUnselect,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: customVerySmallSemiText(
                                  title: '${balanceListRes.data![index].date}'),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: InkWell(
                              onTap: () {
                                print(
                                    '===>${balanceListRes.data![index].txnSource}');
                                // Sadad Service Charge SADAD Paid Services
                                if (balanceListRes.data![index].txnSource !=
                                        'Sadad Service Charge' ||
                                    balanceListRes.data![index].txnSource !=
                                        'SADAD Paid Services') {
                                  if (balanceListRes.data![index].txnSource ==
                                          'Settlement Withdrawal' ||
                                      balanceListRes.data![index].txnSource ==
                                          'Withdrawal') {
                                    Get.to(() => ActivityWithdrawalDetailScreen(
                                          id: balanceListRes
                                              .data![index].transactionId
                                              .toString(),
                                        ));
                                  } else if (balanceListRes
                                          .data![index].txnSource ==
                                      'POS Rental') {
                                    Get.to(() =>
                                        ActivityPosRentalTransactionScreen(
                                          id: balanceListRes
                                              .data![index].transactionId
                                              .toString(),
                                        ));
                                  } else {
                                    Get.to(
                                        () => ActivityTransactionDetailScreen(
                                              id: balanceListRes
                                                  .data![index].transactionId
                                                  .toString(),
                                            ));
                                  }
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorsUtils.tabUnselect
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(Images.invoice,
                                          width: Get.width * 0.06),
                                    ),
                                  ),
                                  width10(),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          customSmallBoldText(
                                              title:
                                                  '${balanceListRes.data![index].txnSource ?? "NA"}'),
                                          Spacer(),
                                          customSmallBoldText(
                                              color: ColorsUtils.accent,
                                              title:
                                                  '${balanceListRes.data![index].txnAmount} QAR')
                                        ],
                                      ),
                                      height5(),
                                      customVerySmallNorText(
                                          title:
                                              '${balanceListRes.data![index].txnType ?? 'NA'}'),
                                      height5(),
                                      Row(
                                        children: [
                                          customVerySmallNorText(
                                              title:
                                                  'ID: ${balanceListRes.data![index].transactionId ?? "NA"}',
                                              color: ColorsUtils.grey),
                                          Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: (balanceListRes
                                                                .data![index]
                                                                .paymentIn ==
                                                            null ||
                                                        balanceListRes
                                                                .data![index]
                                                                .paymentIn ==
                                                            '0.00')
                                                    ? ColorsUtils.reds
                                                    : ColorsUtils.green,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: (balanceListRes
                                                                  .data![index]
                                                                  .paymentIn ==
                                                              null ||
                                                          balanceListRes
                                                                  .data![index]
                                                                  .paymentIn ==
                                                              '0.00')
                                                      ? ColorsUtils.reds
                                                      : ColorsUtils.green,
                                                  radius: 10,
                                                  child: Icon(
                                                      (balanceListRes
                                                                      .data![
                                                                          index]
                                                                      .paymentIn ==
                                                                  null ||
                                                              balanceListRes
                                                                      .data![
                                                                          index]
                                                                      .paymentIn ==
                                                                  '0.00')
                                                          ? Icons
                                                              .arrow_back_outlined
                                                          : Icons
                                                              .arrow_forward_outlined,
                                                      size: 15,
                                                      color: ColorsUtils.white),
                                                ),
                                                width10(),
                                                customVerySmallNorText(
                                                    color: (balanceListRes
                                                                    .data![
                                                                        index]
                                                                    .paymentIn ==
                                                                null ||
                                                            balanceListRes
                                                                    .data![
                                                                        index]
                                                                    .paymentIn ==
                                                                '0.00')
                                                        ? ColorsUtils.reds
                                                        : ColorsUtils.green,
                                                    title: (balanceListRes
                                                                    .data![
                                                                        index]
                                                                    .paymentIn ==
                                                                '0.00' ||
                                                            balanceListRes
                                                                    .data![
                                                                        index]
                                                                    .paymentIn ==
                                                                null)
                                                        ? 'Payment Out'
                                                        : 'Payment In'),
                                                width10(),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              height30(),
            ],
          ),
        ));
  }

  AppBar appBarData() {
    return AppBar(
      leadingWidth: Get.width * 0.2,
      backgroundColor: ColorsUtils.lightPink,
      centerTitle: true,
      title: customMediumLargeBoldText(title: 'Wallet Activity'.tr),
    );
  }

  availBal() async {
    String id = await encryptedSharedPreferences.getString('id');
    dashBoardViewModel.setInit();
    await dashBoardViewModel.availableBalance(id);
  }

  initData() async {
    Utility.settlementWithdrawFilterStatus = '';
    Utility.settlementWithdrawFilterType = '';
    Utility.settlementPayoutFilterStatus = '';
    Utility.settlementPayoutFilterBank = '';
    Utility.holdSettlementWithdrawFilterStatus = '';
    Utility.holdSettlementWithdrawFilterType = '';
    Utility.holdSettlementPayoutFilterStatus = '';
    Utility.holdSettlementPayoutFilterBank = '';
    Utility.holdActivityTransactionSources = '';
    Utility.holdActivityPaymentType = '';
    Utility.activityTransactionSources = '';
    Utility.activityPaymentType = '';
    dashBoardViewModel.setInit();
    activityViewModel.setTransactionInit();
    availBal();
    await activityViewModel.balanceList(filter: '&filter[date]=year');
  }
}
