// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:local_auth/local_auth.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sadad_merchat_app/demo.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/adListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/PoSplineChartResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/paymentMethodResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/posPaymentMethodResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/splineChartResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/transactionChartResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/qrscan/scanQrScreen.dart';
import 'package:sadad_merchat_app/view/auth/facedetection/biometricPinAuthService.dart';
import 'package:sadad_merchat_app/view/dashboard/createSubscriptionScreen.dart';
import 'package:sadad_merchat_app/view/dashboard/subMarchantSwitchList.dart';
import 'package:sadad_merchat_app/view/payment/products/createProduct.dart';
import 'package:sadad_merchat_app/view/payment/withdrawalAmountScreen.dart';
import 'package:sadad_merchat_app/view/settlement/settlementWithdrawalScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../base/constants.dart';
import '../../model/apimodels/requestmodel/dashboard/chartModel.dart';
import '../../model/apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
import '../../model/apis/api_response.dart';
import '../../viewModel/dashboard/dashBoardViewModel.dart';
import '../more/businessInfo/businessDetailsInsertScreen.dart';
import '../more/businessInfo/businessDetailsScreen.dart';
import 'dashboardInvoiceBottomSheet.dart';
import 'notificationScreen.dart';
import 'package:sadad_merchat_app/staticData/update_version_dialog.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  String today = intl.DateFormat('dd MMM').format(DateTime.now());
  List<String> selectedChartZone = ['Week'];
  String dateFilter = 'Week';
  String accountAmount = 'count';
  int isAuth = 0;
  int pageIndex = 0;
  ScrollController? _scrollController;
  bool? _hasBioSensor;
  final LocalAuthentication authentication = LocalAuthentication();
  double? chartWidgetPosition = 0.0;
  bool isChartVisible = false;
  String notificationCount = '';
  int listSize = 0;
  bool isGraphLoading = true;
  GlobalKey _key = GlobalKey();
  AnimationController? animationController;
  Animation<double>? animation;
  String? sadadId = "";
  String? userName = "";

  // List paymentMethodSelection = [];
  String selectedPaymentMethod = '';
  List<Map<String, dynamic>> data = [];
  bool enLng = false;
  int differenceDays = 0;
  String _range = '';
  String startDate = '';
  String endDate = '';
  bool isPos = true;
  SData? sData;
  PSData? psData;
  TooltipBehavior? _tooltipBehavior;
  List<SalesData> dataList = [];
  List<TransactionSourceData> transDataList = [];
  DateTime currentDate = DateTime.now();
  DashBoardViewModel dashBoardViewModel = Get.find();
  TransData? transData;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  PaymentMethodResponseModel? paymentMethodResponse;
  TransactionChartResponseModel? transactionChartResponse;
  SplineChartResponseModel? splineChartResponse;
  PosSplineChartResponseModel? pSplineChartResponse;
  PosPaymentMethodResponseModel? posPaymentMethodResponse;
  List<String>? transLabelsList;
  bool? transactionChartIsEmpty;
  bool? splineChartIsEmpty;
  bool? paymentChartIsEmpty;
  int graphVal1 = 1;
  int graphVal2 = 0;
  List<String> labelsList = [];
  int isOnlinePos = 1;
  String username = '';
  String token = '';
  String? isSubmerchantEnabled;
  String? isSubMarchantAvailable;
  String? isDocExpired;
  String? promtDocMessageEn;
  String? promtDocMessageAr;

  final now = DateTime.now();
  bool isLoaderNet = false;
  ConnectivityViewModel connectivityViewModel = Get.find();
  List<AdsListResponseModel>? adsListResponse;

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    dashBoardViewModel.setInit();
    initData();
    callBottomFingerSheet();
    getSadadId();
    super.initState();
  }

  getSadadId() async {
    sadadId = await encryptedSharedPreferences.getString('sadadId');
    userName = await encryptedSharedPreferences.getString('name');
    isSubmerchantEnabled =
        await encryptedSharedPreferences.getString('isSubmerchantEnabled');
    isSubMarchantAvailable =
        await encryptedSharedPreferences.getString('isSubMarchantAvailable');
    isDocExpired = await encryptedSharedPreferences.getString('isDocExpired');
    promtDocMessageEn = await encryptedSharedPreferences.getString('promtDocMessageEn');
    promtDocMessageAr = await encryptedSharedPreferences.getString('promtDocMessageAr');

    if(isDocExpired == "true") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        docExpiredAlert(context: context);
        await encryptedSharedPreferences.setString(
            'isDocExpired',"false");
      });
    }
    setState(() {});
  }

  callBottomFingerSheet() async {
    final isFirstTime =
        await encryptedSharedPreferences.getString('firstTimeFinger');
    // bool isFromReg=false;
    String isReg = await encryptedSharedPreferences.getString('fromReg');
    print('IsReg===$isReg');
    if (isReg == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        fingerprintAccessBottomSheet(context);
      });
    } else if (isFirstTime == 'false') {
      print('this is second time');
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        fingerprintAccessBottomSheet(context);
      });
    }
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    animationController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('====>${Get.width}');
    // print('DATE :=>${intl.DateFormat('MMM dd yy').format(DateTime.now())}');
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                dashBoardViewModel.isChartLoad &&
                        (dashBoardViewModel
                                    .availableBalanceApiResponse.status !=
                                Status.LOADING ||
                            dashBoardViewModel
                                    .availableBalanceApiResponse.status !=
                                Status.INITIAL)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Loader(),
                      )
                    : SizedBox()
              ],
            ),
            appBar: appBarView(),
            body: GetBuilder<DashBoardViewModel>(
              builder: (controller) {
                if (controller.availableBalanceApiResponse.status ==
                            Status.LOADING ||
                        controller.availableBalanceApiResponse.status ==
                            Status.INITIAL
                    // ||
                    // controller.isChartLoad
                    ) {
                  return const Center(child: Loader());
                }
                if (controller.availableBalanceApiResponse.status ==
                    Status.ERROR) {
                  return const SessionExpire();
                  // return Text('something wrong');
                }

                AvailableBalanceResponseModel avaBalResponse =
                    dashBoardViewModel.availableBalanceApiResponse.data;

                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: chartWidgetPosition == 0.0
                      ? NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ///user Detail
                      //userDetails(),
                      userDetailsContainer(),

                      ///balance container
                      balanceContainer(avaBalResponse),

                      ///createItems
                      createItemList(),

                      ///withdraw card
                      withdrawCard(),

                      ///charts
                      GetBuilder<DashBoardViewModel>(
                        builder: (controller) {
                          if (isPos == true) {
                            if (controller.posPaymentMethodApiResponse.status ==
                                    Status.LOADING ||
                                controller.pSplineChartApiResponse.status ==
                                    Status.LOADING ||
                                controller.posPaymentMethodApiResponse.status ==
                                    Status.INITIAL ||
                                controller.pSplineChartApiResponse.status ==
                                    Status.INITIAL) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: const Center(child: Loader()),
                              );
                            }
                          } else {
                            if (controller.paymentMethodApiResponse.status ==
                                    Status.LOADING ||
                                controller.splineChartApiResponse.status ==
                                    Status.LOADING ||
                                controller.transactionChartApiResponse.status ==
                                    Status.LOADING ||
                                controller.paymentMethodApiResponse.status ==
                                    Status.INITIAL ||
                                controller.splineChartApiResponse.status ==
                                    Status.INITIAL ||
                                controller.transactionChartApiResponse.status ==
                                    Status.INITIAL) {
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: const Center(child: Loader()),
                              );
                            }
                          }

                          if (controller.paymentMethodApiResponse.status ==
                                  Status.ERROR ||
                              controller.splineChartApiResponse.status ==
                                  Status.ERROR ||
                              controller.pSplineChartApiResponse.status ==
                                  Status.ERROR ||
                              controller.posPaymentMethodApiResponse.status ==
                                  Status.ERROR ||
                              controller.transactionChartApiResponse.status ==
                                  Status.ERROR) {
                            return const SessionExpire();
                            // return Text('something wrong');
                          }
                          if (isPos == true) {
                            pSplineChartResponse =
                                dashBoardViewModel.pSplineChartApiResponse.data;
                            posPaymentMethodResponse = dashBoardViewModel
                                .posPaymentMethodApiResponse.data;
                            labelsList = pSplineChartResponse!.labels!;
                            splineChartIsEmpty = pSplineChartResponse!.isEmpty;
                            paymentChartIsEmpty =
                                posPaymentMethodResponse!.isEmpty;
                            psData = pSplineChartResponse!.data;
                          } else {
                            splineChartResponse =
                                dashBoardViewModel.splineChartApiResponse.data;

                            transactionChartResponse = dashBoardViewModel
                                .transactionChartApiResponse.data;
                            paymentMethodResponse = dashBoardViewModel
                                .paymentMethodApiResponse.data;

                            labelsList = splineChartResponse!.labels!;
                            splineChartIsEmpty = splineChartResponse!.isEmpty;
                            paymentChartIsEmpty =
                                paymentMethodResponse!.isEmpty;
                          }

                          if (isPos == false) {
                            sData = splineChartResponse!.data;

                            transData = transactionChartResponse!.data;

                            transLabelsList = transactionChartResponse!.labels;
                            transactionChartIsEmpty =
                                transactionChartResponse!.isEmpty;

                            transDataList.clear();
                            dataList.clear();
                            for (int i = 0; i < transLabelsList!.length; i++) {
                              accountAmount == 'count'
                                  ? transDataList.add(TransactionSourceData(
                                      transLabelsList![i],
                                      transData!.counter!.success![i]
                                          .toDouble(),
                                      transData!.counter!.failure![i]
                                          .toDouble()))
                                  : transDataList.add(TransactionSourceData(
                                      transLabelsList![i],
                                      transData!.amount!.success![i].toDouble(),
                                      transData!.amount!.failure![i]
                                          .toDouble()));
                              // print('trans data is $transDataList');
                            }
                          }

                          // print('list is$labelsList');

                          for (int i = 0; i < labelsList.length; i++) {
                            // print('hiiiiii');
                            if (isPos == true) {
                              // print(
                              //     'Amount type is ${psData!.amount!.success!.all![i].runtimeType.toString()}');
                              accountAmount == 'count'
                                  ? dataList.add(SalesData(
                                      year: labelsList[i],
                                      sales: psData!.counter!.success!.all![i].runtimeType == 'double'
                                          ? psData!.counter!.success!.all![i]
                                          : psData!.counter!.success!.all![i]
                                              .toDouble(),
                                      sales2: psData!.counter!.failure!.all![i].runtimeType == 'double'
                                          ? psData!.counter!.failure!.all![i]
                                          : psData!.counter!.failure!.all![i]
                                              .toDouble()))
                                  : dataList.add(SalesData(
                                      year: labelsList[i],
                                      sales:
                                          psData!.amount!.success!.all![i].runtimeType == 'double'
                                              ? psData!.amount!.success!.all![i]
                                              : psData!.amount!.success!.all![i]
                                                  .toDouble(),
                                      sales2: psData!.amount!.failure!.all![i].runtimeType == 'double' ? psData!.amount!.failure!.all![i] : psData!.amount!.failure!.all![i].toDouble()));
                            } else {
                              accountAmount == 'count'
                                  ? dataList.add(SalesData(
                                      year: labelsList[i],
                                      sales: sData!.counter!.success![i]
                                          .toDouble(),
                                      sales2: sData!.counter!.failure![i]
                                          .toDouble()))
                                  : dataList.add(SalesData(
                                      year: labelsList[i],
                                      sales:
                                          sData!.amount!.success![i].toDouble(),
                                      sales2: sData!.amount!.failure![i]
                                          .toDouble()));
                            }

                            // print('data is $dataList');
                          }
                          return charts();
                        },
                      )
                    ],
                  ),
                );
              },
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                dashBoardViewModel.setInit();
                setState(() {});
                initData();
              } else {
                Get.snackbar('error'.tr, 'Please check your connection');
              }
            } else {
              Get.snackbar('error'.tr, 'Please check your connection');
            }
          },
        );
      }
    } else {
      return InternetNotFound(
        onTap: () {
          connectivityViewModel.startMonitoring();

          if (connectivityViewModel.isOnline!) {
            dashBoardViewModel.setInit();
            setState(() {});
            initData();
          } else {
            Get.snackbar('error'.tr, 'Please check your connection');
          }
        },
      );
    }
  }

  // authRequire() {
  //   Center(
  //     child: Text('Something Wrong'.tr),
  //   );
  //   // Future.delayed(Duration(seconds: 2), () {
  //   //   Get.offAll(() => SplashScreen());
  //   // });
  // }

  Widget balanceContainer(AvailableBalanceResponseModel avaBalResponse) {
    return GestureDetector(
      onTap: () async {
        Utility.settlementWithdrawPeriodAlready = false;
        Utility.settlementWithdrawPeriod = '';
        await Get.to(() => SettlementWithdrawalScreen());
        // bottomSheetSelectBalance(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Container(
          // height: Get.height * 0.22,
          padding: const EdgeInsets.all(20),
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
                      ColorsUtils.black.withOpacity(0.25), BlendMode.srcATop),
                  image: const AssetImage(Images.carViewMaroon),
                  fit: BoxFit.cover),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Total Available Balance".tr,
                    style: ThemeUtils.whiteRegular
                        .copyWith(fontSize: FontUtils.small),
                  )),
                  Text(
                    today,
                    style: ThemeUtils.whiteRegular
                        .copyWith(fontSize: FontUtils.verySmall),
                  )
                ],
              ),
              height8(),
              const SizedBox(
                height: 8,
              ),
              currencyText(
                  avaBalResponse.totalavailablefunds!.toDouble(),
                  ThemeUtils.whiteBold.copyWith(fontSize: FontUtils.large),
                  ThemeUtils.whiteRegular.copyWith(fontSize: FontUtils.small)),
              // const Expanded(child: SizedBox()),
              height30(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Utility.settlementWithdrawPeriodAlready = false;
                      Utility.settlementWithdrawPeriod = '';
                      await Get.to(() => SettlementWithdrawalScreen());
                      // bottomSheetSelectBalance(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: ColorsUtils.white,
                        textStyle: ThemeUtils.maroonSemiBold
                            .copyWith(fontSize: FontUtils.verySmall),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text(
                      "Withdraw".tr,
                      style: ThemeUtils.maroonSemiBold
                          .copyWith(fontSize: FontUtils.verySmall),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xff8E1B3E),
                          size: 15,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column charts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///chart text
        // Padding(
        //   padding: const EdgeInsets.all(20),
        //   child: Text(
        //     key: _key,
        //     "charts".tr,
        //     style:
        //         ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medLarge),
        //   ),
        // ),

        onlinePos(),

        ///timezone
        timeZone(),

        dividerData(),

        ///countAccount chart
        countAmountChart(),

        isOnlinePos == 0 ? spaceContainer() : SizedBox(),

        ///  transaction Source chart
        isOnlinePos == 0 ? transactionChart() : SizedBox(),

        spaceContainer(),

        /// paymentMethod
        paymentMethod(),
      ],
    );
  }

  Widget onlinePos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: ColorsUtils.tabUnselect,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        isOnlinePos = 0;
                        isPos = false;
                        isChartVisible = false;
                        chartWidgetPosition == 0.0;
                        // _scrollController!.animateTo(0.0,
                        //     duration: Duration(microseconds: 200),
                        //     curve: Curves.ease);
                        getChartData();

                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: isOnlinePos == 0
                                ? ColorsUtils.white
                                : ColorsUtils.tabUnselect,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: customSmallBoldText(
                                  title: "Online Payment".tr)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        isOnlinePos = 1;
                        isPos = true;
                        isChartVisible = false;
                        chartWidgetPosition == 0.0;
                        // _scrollController!.animateTo(0.0,
                        //     duration: Duration(microseconds: 200),
                        //     curve: Curves.ease);
                        getChartData();
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: isOnlinePos == 1
                                ? ColorsUtils.white
                                : ColorsUtils.tabUnselect,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child:
                                  customSmallBoldText(title: "POS Payment".tr)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column paymentMethod() {
    data.clear();
    // print('resposne is length :::;${pResponse.counter!.both!.length}');
    if (isPos == true) {
      if (accountAmount == 'count') {
        for (var element in posPaymentMethodResponse!.counter!.both!.all!) {
          // print('resposne is :::;${element.label}');
          // print('resposne is :::;${element.data!.perc}');
          data.add({
            'icon': element.label,
            'value': '${element.data!.value}',
            'name': '${element.label}',
            'percentage': '${(element.data!.perc)}'
          });
        }
      } else {
        for (var element in posPaymentMethodResponse!.amount!.both!.all!) {
          // print('resposne is :::;${element.label}');
          // print('resposne is :::;${element.data!.perc}');
          data.add({
            'icon': element.label,
            'name': '${element.label}',
            'value': '${element.data!.value}',
            'percentage': '${(element.data!.perc)}'
          });
        }
      }
    } else {
      if (accountAmount == 'count') {
        if (dashBoardViewModel.transactionChartLine.value == 'Success') {
          for (var element in paymentMethodResponse!.counter!.success!) {
            // print('resposne is :::;${element.label}');
            // print('resposne is :::;${element.data!.perc}');
            data.add({
              'icon': element.label,
              'name': '${element.label}',
              'value': '${element.data!.value}',
              'percentage': '${(element.data!.perc)}'
            });
          }
        } else if (dashBoardViewModel.transactionChartLine.value == 'Failure') {
          for (var element in paymentMethodResponse!.counter!.failure!) {
            // print('resposne is :::;${element.label}');
            // print('resposne is :::;${element.data!.perc}');
            data.add({
              'icon': element.label,
              'name': '${element.label}',
              'value': '${element.data!.value}',
              'percentage': '${(element.data!.perc)}'
            });
          }
        } else {
          for (var element in paymentMethodResponse!.counter!.both!) {
            // print('resposne is :::;${element.label}');
            // print('resposne is :::;${element.data!.perc}');
            data.add({
              'icon': element.label,
              'name': '${element.label}',
              'value': '${element.data!.value}',
              'percentage': '${(element.data!.perc)}'
            });
          }
        }
      } else {
        if (dashBoardViewModel.transactionChartLine.value == 'Success') {
          for (var element in paymentMethodResponse!.amount!.success!) {
            // print('resposne is :::;${element.label}');
            // print('resposne is :::;${element.data!.perc}');
            data.add({
              'icon': element.label,
              'name': '${element.label}',
              'value': '${element.data!.value}',
              'percentage': '${(element.data!.perc)}'
            });
          }
        } else if (dashBoardViewModel.transactionChartLine.value == 'Failure') {
          for (var element in paymentMethodResponse!.amount!.failure!) {
            // print('resposne is :::;${element.label}');
            // print('resposne is :::;${element.data!.perc}');
            data.add({
              'icon': element.label,
              'name': '${element.label}',
              'value': '${element.data!.value}',
              'percentage': '${(element.data!.perc)}'
            });
          }
        } else {
          for (var element in paymentMethodResponse!.amount!.both!) {
            // print('resposne is :::;${element.label}');
            // print('resposne is :::;${element.data!.perc}');
            data.add({
              'icon': element.label,
              'name': '${element.label}',
              'value': '${element.data!.value}',
              'percentage': '${(element.data!.perc)}'
            });
          }
        }
      }
    }

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                "paymentMethod".tr,
                style: ThemeUtils.blackSemiBold
                    .copyWith(fontSize: FontUtils.mediumSmall),
              )),
              Text(
                textDirection: TextDirection.ltr,
                selectedChartZone.first == 'Custom'
                    ? _range
                    : selectedChartZone.contains('Today')
                        ? '${intl.DateFormat("dd MMM’ yy", "en_US").format(DateTime.now())}'
                        : selectedChartZone.contains('Yesterday')
                            ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month, now.day - 1))}'
                            : selectedChartZone.contains('Week')
                                ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                : selectedChartZone.contains('Month')
                                    ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                    : selectedChartZone.contains('Year')
                                        ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year - 1, now.month, now.day))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                        : '',
                style: ThemeUtils.blackRegular.copyWith(
                    fontSize: FontUtils.verySmall,
                    color: ColorsUtils.black.withOpacity(0.6)),
              )
            ],
          ),
        ),
        paymentChartIsEmpty == true
            ? noDataFoundInChart()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: paymentMethodItem(
                          icon: data[index]['icon'],
                          // name: StaticData().paymentMethodItemList[index]['name'],
                          name: data[index]['name'],
                          value: data[index]['value'],
                          percentage: double.parse(data[index]['percentage'])
                              .toStringAsFixed(2),
                          index: index),
                    );
                  },
                ),
              ),
      ],
    );
  }

  Padding transactionChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                "transaction Source".tr,
                style:
                    ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
              )),
              Text(
                textDirection: TextDirection.ltr,
                selectedChartZone.first == 'Custom'
                    ? _range
                    : selectedChartZone.contains('Today')
                        ? '${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                        : selectedChartZone.contains('Yesterday')
                            ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month, now.day - 1))}'
                            : selectedChartZone.contains('Week')
                                ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                : selectedChartZone.contains('Month')
                                    ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                    : selectedChartZone.contains('Year')
                                        ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year - 1, now.month, now.day))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                        : '',
                style: ThemeUtils.blackRegular.copyWith(
                    fontSize: FontUtils.verySmall,
                    color: ColorsUtils.black.withOpacity(0.6)),
              )
            ],
          ),
          height10(),
          //chart
          transactionChartIsEmpty == true
              ? noDataFoundInChart()
              : Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Obx(() => SfCartesianChart(
                      margin: const EdgeInsets.all(0),
                      // tooltipBehavior: TooltipBehavior(
                      //     enable: true,
                      //     shared: true,
                      //     shouldAlwaysShow: true,
                      //     opacity: 0,
                      //     duration: 1000,
                      //     tooltipPosition: TooltipPosition.auto,
                      //     builder: (dynamic data, dynamic point, dynamic series,
                      //         int pointIndex, int seriesIndex) {
                      //       // Debug.trace("Series $seriesIndex $pointIndex");
                      //       return Container(
                      //         decoration: BoxDecoration(
                      //             color: seriesIndex == 0
                      //                 ? ColorsUtils.primary
                      //                 : ColorsUtils.chartYellow,
                      //             borderRadius: BorderRadius.circular(5)),
                      //         padding: const EdgeInsets.all(5),
                      //         child: Text(
                      //           seriesIndex == 0
                      //               ? (data as TransactionSourceData)
                      //                   .data1
                      //                   .toString()
                      //               : (data as TransactionSourceData)
                      //                   .data2
                      //                   .toString(),
                      //           style: ThemeUtils.whiteSemiBold.copyWith(
                      //               fontSize: FontUtils.verySmall,
                      //               color: seriesIndex == 0
                      //                   ? ColorsUtils.white
                      //                   : ColorsUtils.black),
                      //         ),
                      //       );
                      //     }),
                      palette: <Color>[
                        if (dashBoardViewModel.transactionChartLine.value ==
                                'All' ||
                            dashBoardViewModel.transactionChartLine.value ==
                                'Success')
                          ColorsUtils.primary,
                        ColorsUtils.chartYellow
                      ],
                      tooltipBehavior: TooltipBehavior(
                          enable: true,
                          duration: 1500,
                          builder: (dynamic data, dynamic point, dynamic series,
                              int pointIndex, int seriesIndex) {
                            String tsuccess = '';

                            String tfailure = '';
                            if (dashBoardViewModel.transactionChartLine.value ==
                                'Failure') {
                              seriesIndex = 1;
                            }
                            if (accountAmount == 'count') {
                              tsuccess = transData!
                                  .counter!.success![pointIndex]
                                  .toString();

                              tfailure = transData!
                                  .counter!.failure![pointIndex]
                                  .toString();
                            } else {
                              tsuccess = transData!.amount!.success![pointIndex]
                                  .toString();

                              tfailure = transData!.amount!.failure![pointIndex]
                                  .toString();
                            }

                            // Debug.trace("Series $seriesIndex $pointIndex");
                            return Container(
                                decoration: BoxDecoration(
                                    color: ColorsUtils.black,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    customSmallBoldText(
                                        title: transLabelsList![pointIndex],
                                        color: ColorsUtils.white),
                                    SizedBox(
                                      width: Get.width * 0.2,
                                      child: Divider(
                                        color: ColorsUtils.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 5,
                                          backgroundColor: seriesIndex == 0
                                              ? ColorsUtils.accent
                                              : ColorsUtils.yellow,
                                        ),
                                        width10(),
                                        customSmallBoldText(
                                            color: ColorsUtils.white,
                                            title: seriesIndex == 0
                                                ? 'Success : '
                                                : 'Failure : '),
                                        customSmallBoldText(
                                            title: seriesIndex == 0
                                                ? tsuccess
                                                : tfailure,
                                            color: ColorsUtils.white),
                                      ],
                                    )
                                  ],
                                ));
                          }),

                      // tooltipBehavior: TooltipBehavior(
                      //   enable: true,
                      // ),
                      primaryXAxis: CategoryAxis(
                          isVisible: true,
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          plotOffset: 5,
                          labelIntersectAction: AxisLabelIntersectAction.wrap,
                          labelAlignment: LabelAlignment.center,
                          visibleMaximum: 3,
                          labelStyle: ThemeUtils.blackSemiBold.copyWith(
                              fontSize: 10,
                              color: ColorsUtils.tabUnselectLabel),
                          // arrangeByIndex: true,
                          interval: 1,
                          majorGridLines: const MajorGridLines(width: 0.5),
                          labelPlacement: LabelPlacement.betweenTicks,
                          autoScrollingMode: AutoScrollingMode.start),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                      ),
                      plotAreaBorderWidth: 0,
                      series: <ChartSeries>[
                        // Renders spline chart
                        if (dashBoardViewModel.transactionChartLine.value ==
                                'All' ||
                            dashBoardViewModel.transactionChartLine.value ==
                                'Success')
                          ColumnSeries<TransactionSourceData, String>(
                              //Enables the tooltip for individual series
                              // isVisible: true,
                              // isVisible: accountAmount == 'count'
                              //     ? (transData!.counter!.success!.indexWhere(
                              //                 (element) => (element as int) > 0) >
                              //             -1
                              //         ? true
                              //         : false)
                              //     : (transData!.amount!.success!.indexWhere(
                              //                 (element) => (element as int) > 0) >
                              //             -1
                              //         ? true
                              //         : false),
                              enableTooltip: true,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              width: 0.5,
                              dataSource: transDataList,
                              name: 'Success'.tr,
                              // dataLabelSettings: const DataLabelSettings(
                              //     showZeroValue: false,
                              //     isVisible: true,
                              //     color: ColorsUtils.accent),
                              xValueMapper: (TransactionSourceData data, _) =>
                                  // data.transaction.length > 9
                                  //     ? data.transaction.substring(0, 10)
                                  //     :

                                  data.transaction,
                              // data.transaction,
                              yValueMapper: (TransactionSourceData data, _) =>
                                  data.data1),
                        if (dashBoardViewModel.transactionChartLine.value ==
                                'All' ||
                            dashBoardViewModel.transactionChartLine.value ==
                                'Failure')
                          ColumnSeries<TransactionSourceData, String>(
                              //Enables the tooltip for individual series
                              // isVisible: true,
                              // isVisible: accountAmount == 'count'
                              //     ? (transData!.counter!.failure!.indexWhere(
                              //                 (element) => (element as int) > 0) >
                              //             -1
                              //         ? true
                              //         : false)
                              //     : (transData!.amount!.failure!.indexWhere(
                              //                 (element) => (element as int) > 0) >
                              //             -1
                              //         ? true
                              //         : false),
                              // enableTooltip: true,
                              width: 0.5,
                              name: 'Failure'.tr,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              dataSource: transDataList,
                              enableTooltip: true,
                              // dataLabelSettings: const DataLabelSettings(
                              //     showZeroValue: false,
                              //     isVisible: true,
                              //     color: ColorsUtils.yellow),
                              xValueMapper: (TransactionSourceData data, _) =>
                                  // data.transaction.length > 9
                                  //     ? data.transaction.substring(0, 10)
                                  //     :
                                  data.transaction,
                              yValueMapper: (TransactionSourceData data, _) =>
                                  data.data2)
                      ])),
                ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            margin: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: ColorsUtils.primary, shape: BoxShape.circle),
                  width: 8,
                  height: 8,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "success".tr,
                  style: ThemeUtils.blackSemiBold
                      .copyWith(fontSize: FontUtils.verySmall),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: ColorsUtils.chartYellow, shape: BoxShape.circle),
                  width: 8,
                  height: 8,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "failure".tr,
                  style: ThemeUtils.blackSemiBold
                      .copyWith(fontSize: FontUtils.verySmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding noDataFoundInChart() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: Get.width,
        height: 100,
        child: Center(
          child: Text(
            'We are Sorry for your inconvenience. unable to fetch Data'.tr,
            textAlign: TextAlign.center,
            style:
                ThemeUtils.maroonSemiBold.copyWith(fontSize: FontUtils.medium),
          ),
        ),
      ),
    );
  }

  Padding countAmountChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        key: _key,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customMediumBoldText(title: 'Transaction Status'.tr),
              const Expanded(child: SizedBox()),
              Text(
                textDirection: TextDirection.ltr,
                selectedChartZone.first == 'Custom'
                    ? _range
                    : selectedChartZone.contains('Today')
                        ? '${intl.DateFormat(
                            "dd MMM’ yy",
                          ).format(DateTime.now())}'
                        : selectedChartZone.contains('Yesterday')
                            ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month, now.day - 1))}'
                            : selectedChartZone.contains('Week')
                                ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month, now.day - 6))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                : selectedChartZone.contains('Month')
                                    ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year, now.month - 1, now.day))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                    : selectedChartZone.contains('Year')
                                        ? '${intl.DateFormat("dd MMM’ yy").format(DateTime(now.year - 1, now.month, now.day))} - ${intl.DateFormat("dd MMM’ yy").format(DateTime.now())}'
                                        : '',
                style: ThemeUtils.blackRegular.copyWith(
                    fontSize: FontUtils.verySmall,
                    color: ColorsUtils.black.withOpacity(0.6)),
              )
            ],
          ),
          height20(),
          Row(
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorsUtils.countBackground)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          accountAmount = 'count';
                          setState(() {});
                          // getChartData();
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: accountAmount == 'count'
                                ? ColorsUtils.countBackground
                                : ColorsUtils.white,
                          ),
                          child: Center(
                            child: Text(
                              "count".tr,
                              style: accountAmount == 'count'
                                  ? ThemeUtils.whiteSemiBold
                                      .copyWith(fontSize: FontUtils.verySmall)
                                  : ThemeUtils.blackSemiBold
                                      .copyWith(fontSize: FontUtils.verySmall),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          accountAmount = 'amount';
                          setState(() {});
                          // getChartData();
                          // viewModel.setCountFilter(TransactionAmountCount.amount);
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: accountAmount == 'amount'
                                ? ColorsUtils.countBackground
                                : ColorsUtils.white,
                          ),
                          child: Center(
                            child: Text(
                              "amount".tr,
                              style: accountAmount == 'amount'
                                  ? ThemeUtils.whiteSemiBold
                                      .copyWith(fontSize: FontUtils.verySmall)
                                  : ThemeUtils.blackSemiBold
                                      .copyWith(fontSize: FontUtils.verySmall),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: ColorsUtils.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: ColorsUtils.border, width: 1)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      bottomSheetforGraphLine(context);
                    },
                    child: Row(
                      children: [
                        Obx(() => customSmallSemiText(
                            title: dashBoardViewModel
                                .transactionChartLine.value.tr,
                            color: ColorsUtils.black)),
                        width40(),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          //chart
          splineChartIsEmpty == true
              ? noDataFoundInChart()
              : Obx(() => splineChart()),

          Container(
            padding: const EdgeInsets.only(top: 20),
            margin: const EdgeInsets.symmetric(
              horizontal: 50,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: ColorsUtils.primary, shape: BoxShape.circle),
                  width: 8,
                  height: 8,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "success".tr,
                  style: ThemeUtils.blackSemiBold
                      .copyWith(fontSize: FontUtils.verySmall),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: ColorsUtils.chartYellow, shape: BoxShape.circle),
                  width: 8,
                  height: 8,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "failure".tr,
                  style: ThemeUtils.blackSemiBold
                      .copyWith(fontSize: FontUtils.verySmall),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget splineChart({bool isSheet = false}) {
    return Stack(
      children: [
        SfCartesianChart(
            margin: const EdgeInsets.all(0),
            palette: <Color>[
              if (dashBoardViewModel.transactionChartLine.value == 'All' ||
                  dashBoardViewModel.transactionChartLine.value == 'Success')
                ColorsUtils.primary,
              ColorsUtils.chartYellow
            ],
            tooltipBehavior: TooltipBehavior(
                enable: true,
                duration: 1500,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  String success = '';

                  String failure = '';
                  if (dashBoardViewModel.transactionChartLine.value ==
                      'Failure') {
                    seriesIndex = 1;
                  }
                  if (isPos == true) {
                    if (accountAmount == 'count') {
                      if (seriesIndex == 0) {
                        success = psData!.counter!.success!.all![pointIndex]
                                    .runtimeType ==
                                'double'
                            ? psData!.counter!.success!.all![pointIndex]
                            : psData!.counter!.success!.all![pointIndex]
                                .toString();
                      } else {
                        failure = psData!.counter!.failure!.all![pointIndex]
                                    .runtimeType ==
                                'double'
                            ? psData!.counter!.failure!.all![pointIndex]
                            : psData!.counter!.failure!.all![pointIndex]
                                .toString();
                      }
                    } else {
                      if (seriesIndex == 0) {
                        success = psData!.amount!.success!.all![pointIndex]
                                    .runtimeType ==
                                'double'
                            ? psData!.amount!.success!.all![pointIndex]
                            : psData!.amount!.success!.all![pointIndex]
                                .toString();
                      } else {
                        failure = psData!.amount!.failure!.all![pointIndex]
                                    .runtimeType ==
                                'double'
                            ? psData!.amount!.failure!.all![pointIndex]
                            : psData!.amount!.failure!.all![pointIndex]
                                .toString();
                      }
                    }
                  } else {
                    if (accountAmount == 'count') {
                      if (seriesIndex == 0) {
                        success =
                            sData!.counter!.success![pointIndex].toString();
                      } else {
                        failure =
                            sData!.counter!.failure![pointIndex].toString();
                      }
                    } else {
                      if (seriesIndex == 0) {
                        success =
                            sData!.amount!.success![pointIndex].toString();
                      } else {
                        failure =
                            sData!.amount!.failure![pointIndex].toString();
                      }
                    }
                  }
                  // Debug.trace("Series $seriesIndex $pointIndex");
                  return Container(
                      decoration: BoxDecoration(
                          color: ColorsUtils.black,
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          customSmallBoldText(
                              title: labelsList[pointIndex],
                              color: ColorsUtils.white),
                          SizedBox(
                            width: Get.width * 0.2,
                            child: Divider(
                              color: ColorsUtils.white,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: seriesIndex == 0
                                    ? ColorsUtils.accent
                                    : ColorsUtils.yellow,
                              ),
                              width10(),
                              customSmallBoldText(
                                  color: ColorsUtils.white,
                                  title: seriesIndex == 0
                                      ? 'Success : '.tr
                                      : 'Failure : '.tr),
                              customSmallBoldText(
                                  title: seriesIndex == 0 ? success : failure,
                                  color: ColorsUtils.white),
                            ],
                          )
                        ],
                      ));
                }),

            ///
            // tooltipBehavior: _tooltipBehavior,
            primaryXAxis: CategoryAxis(
                plotBands: isSheet == false
                    ? []
                    : <PlotBand>[
                        PlotBand(
                            color: Color(0xffF3E8EB),
                            size: 1,
                            start: graphVal1,
                            end: graphVal2,
                            sizeType: DateTimeIntervalType.auto,
                            isVisible: true,
                            isRepeatable: true,
                            repeatEvery: 2,
                            shouldRenderAboveSeries: false)
                      ],
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                plotOffset: 5,
                labelIntersectAction: AxisLabelIntersectAction.hide,
                visibleMaximum: 4,
                labelStyle: ThemeUtils.blackSemiBold.copyWith(
                    fontSize: 10, color: ColorsUtils.tabUnselectLabel),
                // arrangeByIndex: true,
                interval: 1,
                majorGridLines: const MajorGridLines(width: 0.5),
                labelPlacement: LabelPlacement.betweenTicks,
                autoScrollingMode: AutoScrollingMode.start),
            primaryYAxis: NumericAxis(
                numberFormat: intl.NumberFormat.simpleCurrency(
              // name: accountAmount == 'count' ? '' : 'QAR ',
              name: '',
              decimalDigits: 0,
            )),
            zoomPanBehavior: ZoomPanBehavior(
              enablePanning: true,
            ),
            series: <ChartSeries<SalesData, String>>[
              if (dashBoardViewModel.transactionChartLine.value == 'All' ||
                  dashBoardViewModel.transactionChartLine.value == 'Success')
                SplineSeries<SalesData, String>(
                  dataSource: dataList,
                  enableTooltip: true,

                  splineType: SplineType.monotonic,
                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales,
                  name: 'Success'.tr,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                  ),
                  // dataLabelSettings: const DataLabelSettings(
                  //   showZeroValue: true,
                  //   isVisible: false,
                  // )
                ),
              if (dashBoardViewModel.transactionChartLine.value == 'All' ||
                  dashBoardViewModel.transactionChartLine.value == 'Failure')
                SplineSeries<SalesData, String>(
                  name: 'Failure'.tr,
                  enableTooltip: true,
                  dataSource: dataList,
                  splineType: SplineType.monotonic,

                  xValueMapper: (SalesData sales, _) => sales.year,
                  yValueMapper: (SalesData sales, _) => sales.sales2,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                  ),
                  // dataLabelSettings: const DataLabelSettings(
                  //     showZeroValue: false,
                  //     isVisible: true,
                  //     color: ColorsUtils.yellow)
                ),
            ]),
        Positioned(
            child: Container(
          height: Get.height * 0.3,
          width: Get.width,
          child: GestureDetector(
            onDoubleTap: () {
              if (isSheet == false) {
                dashBoardViewModel.setCount(0);
                graphVal1 = 1;
                graphVal2 = 0;
                bottomSplineChartSheet(context);
              }
            },
          ),
        ))
      ],
    );
  }

  Future<void> bottomSplineChartSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return GetBuilder<DashBoardViewModel>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 70,
                          height: 5,
                          child:
                              Divider(color: ColorsUtils.border, thickness: 4),
                        ),
                      ),
                      height25(),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customMediumLargeBoldText(
                                title: accountAmount.capitalizeFirst),
                            Spacer(),
                            Text(
                                selectedChartZone.first == 'Custom'
                                    ? _range
                                    : selectedChartZone.first,
                                style: ThemeUtils.blackRegular.copyWith(
                                  fontSize: FontUtils.verySmall,
                                  color: ColorsUtils.black.withOpacity(0.6),
                                )),
                            width20(),
                            Text(
                              selectedChartZone.first == 'Custom'
                                  ? ''
                                  : selectedChartZone.contains('Today')
                                      ? '${intl.DateFormat('dd MMM’ yy').format(DateTime.now())}'
                                      : selectedChartZone.contains('Yesterday')
                                          ? '${intl.DateFormat('dd MMM’ yy').format(DateTime(now.year, now.month, now.day - 1))}'
                                          : selectedChartZone.contains('Week')
                                              ? '${intl.DateFormat('dd MMM’ yy').format(DateTime(now.year, now.month, now.day - 7))} - ${intl.DateFormat('dd MMM’ yy').format(DateTime.now())}'
                                              : selectedChartZone
                                                      .contains('Month')
                                                  ? '${intl.DateFormat('dd MMM’ yy').format(DateTime(now.year, now.month - 1, now.day))}-${intl.DateFormat('dd MMM’ yy').format(DateTime.now())}'
                                                  : selectedChartZone
                                                          .contains('Year')
                                                      ? '${intl.DateFormat('dd MMM’ yy').format(DateTime(now.year - 1, now.month, now.day))}-${intl.DateFormat('dd MMM’ yy').format(DateTime.now())}'
                                                      : '',
                              style: ThemeUtils.blackRegular.copyWith(
                                  fontSize: FontUtils.verySmall,
                                  color: ColorsUtils.black.withOpacity(0.6)),
                            )
                          ],
                        ),
                      ),
                      height10(),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: splineChart(isSheet: true),
                      ),
                      height20(),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 50,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                  color: ColorsUtils.primary,
                                  shape: BoxShape.circle),
                              width: 8,
                              height: 8,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "success".tr,
                              style: ThemeUtils.blackSemiBold
                                  .copyWith(fontSize: FontUtils.verySmall),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: ColorsUtils.chartYellow,
                                  shape: BoxShape.circle),
                              width: 8,
                              height: 8,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              "failure".tr,
                              style: ThemeUtils.blackSemiBold
                                  .copyWith(fontSize: FontUtils.verySmall),
                            ),
                          ],
                        ),
                      ),
                      height40(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (dashBoardViewModel.countGraph > 0) {
                                graphVal2--;
                                graphVal1--;
                                setBottomState(() {});
                                dashBoardViewModel.subCount();
                                print(
                                    '${labelsList.length}     ${dashBoardViewModel.countGraph}');
                              }
                              print('hiiii');
                            },
                            child: CircleAvatar(
                              backgroundColor: ColorsUtils.border,
                              radius: 12,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  size: 12,
                                  color: ColorsUtils.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: customMediumBoldText(
                                title: labelsList[controller.countGraph]),
                          ),
                          InkWell(
                            onTap: () {
                              if (labelsList.length - 1 !=
                                  dashBoardViewModel.countGraph) {
                                graphVal2++;
                                graphVal1++;
                                setBottomState(() {});
                                dashBoardViewModel.addCount();
                                print(
                                    '${labelsList.length}     ${dashBoardViewModel.countGraph}');
                              }
                              print('hiiii');
                            },
                            child: CircleAvatar(
                              backgroundColor: ColorsUtils.border,
                              radius: 12,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 12,
                                  color: ColorsUtils.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            isOnlinePos == 0
                                ? customSmallMedSemiText(
                                    title: 'Online payment'.tr)
                                : customSmallMedSemiText(title: 'pos'.tr),
                            Spacer(),
                            Column(
                              children: [
                                customMediumBoldText(
                                    title: isPos == true
                                        ? '${accountAmount == 'count' ? psData!.counter!.success!.all![controller.countGraph] : psData!.amount!.success!.all![controller.countGraph]}'
                                        : '${accountAmount == 'count' ? sData!.counter.success![controller.countGraph] : sData!.amount!.success![controller.countGraph]}',
                                    color: ColorsUtils.accent),
                                customVerySmallBoldText(title: 'Success'.tr)
                              ],
                            ),
                            width20(),
                            Column(
                              children: [
                                customMediumBoldText(
                                    title: isPos == true
                                        ? '${accountAmount == 'count' ? psData!.counter!.failure!.all![controller.countGraph] : psData!.amount!.failure!.all![controller.countGraph]}'
                                        : '${accountAmount == 'count' ? sData!.counter.failure![controller.countGraph] : sData!.amount!.failure![controller.countGraph]}',
                                    color: ColorsUtils.yellow),
                                customVerySmallBoldText(title: 'Failure'.tr)
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Column(
                      //     children: [
                      //       Divider(),
                      //       Padding(
                      //         padding: const EdgeInsets.only(right: 10),
                      //         child: Row(
                      //           children: [
                      //             Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 isOnlinePos == 0
                      //                     ? customSmallMedSemiText(
                      //                         title: 'Online payment')
                      //                     : customSmallMedSemiText(
                      //                         title: 'POS'),
                      //                 //    height10(),
                      //                 // ,
                      //               ],
                      //             ),
                      //             Spacer(),
                      //             Column(
                      //               children: [
                      //                 isOnlinePos == 0
                      //                     ? customMediumBoldText(
                      //                         title:
                      //                             '${accountAmount == 'count' ? sData!.counter.success![controller.countGraph] : sData!.amount!.success![controller.countGraph]}',
                      //                         color: ColorsUtils.accent)
                      //                     : customMediumBoldText(
                      //                         title:
                      //                             '${accountAmount == 'count' ? psData!.counter!.success!.all![controller.countGraph] : psData!.amount!.success!.all![controller.countGraph]}',
                      //                         color: ColorsUtils.accent),
                      //               ],
                      //             ),
                      //             width20(),
                      //             Column(
                      //               children: [
                      //                 isOnlinePos == 0
                      //                     ? customMediumBoldText(
                      //                         title:
                      //                             '${accountAmount == 'count' ? sData!.counter.failure![controller.countGraph] : sData!.amount!.failure![controller.countGraph]}',
                      //                         color: ColorsUtils.yellow)
                      //                     : customMediumBoldText(
                      //                         title:
                      //                             '${accountAmount == 'count' ? psData!.counter!.failure!.all![controller.countGraph] : psData!.amount!.failure!.all![controller.countGraph]}',
                      //                         color: ColorsUtils.yellow),
                      //               ],
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      height30(),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  fingerprintAccessBottomSheet(
    BuildContext context,
  ) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                height10(),
                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 70,
                    height: 5,
                    child: Divider(color: ColorsUtils.border, thickness: 4),
                  ),
                ),
                height25(),
                customMediumBoldText(title: 'Link your Fingerprint?'.tr),
                height40(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            await encryptedSharedPreferences.setString(
                                'firstTimeFinger', 'false');
                            await encryptedSharedPreferences.setString(
                                'bioDetectionFinger', 'false');
                            await encryptedSharedPreferences.setString(
                                'bioDetectionFace', 'false');
                          },
                          child:
                              customSmallBoldText(title: 'Skip, for later'.tr)),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          await encryptedSharedPreferences.setString(
                              'firstTimeFinger', 'false');
                          await encryptedSharedPreferences.setString(
                              'fromReg', 'false');
                          faceFingerDialog(context);
                        },
                        child: SizedBox(
                          width: Get.width / 4,
                          child: buildContainerWithoutImage(
                              color: ColorsUtils.accent, text: 'Link'.tr),
                        ),
                      )
                    ],
                  ),
                ),
                height40()
              ],
            );
          },
        );
      },
    );
  }

  Future<dynamic> faceFingerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorsUtils.auth,
                    ),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: ColorsUtils.black,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        isAuth = 0;

                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: isAuth == 0
                                                ? ColorsUtils.white
                                                : ColorsUtils.black,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: customSmallBoldText(
                                                  color: isAuth == 0
                                                      ? ColorsUtils.black
                                                      : ColorsUtils.white,
                                                  title: "Fingerprint".tr)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        isAuth = 1;

                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: isAuth == 1
                                                ? ColorsUtils.white
                                                : ColorsUtils.black,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                              child: customSmallBoldText(
                                                  color: isAuth == 1
                                                      ? ColorsUtils.black
                                                      : ColorsUtils.white,
                                                  title: "Face".tr)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          height30(),
                          customMediumBoldText(
                              title: 'Authentication required'.tr,
                              color: ColorsUtils.white),
                          height10(),
                          customSmallSemiText(
                              color: ColorsUtils.white,
                              title: 'Verify identity'.tr),
                          height20(),
                          InkWell(
                            onTap: () async {
                              if (isAuth == 1) {
                                //face
                                _checkBio();
                              }
                            },
                            child: customMediumSemiText(
                                title: isAuth == 1
                                    ? 'Scan your Face to authenticate'.tr
                                    : 'Scan your fingerprint to authenticate'
                                        .tr,
                                color: ColorsUtils.white),
                          ),
                          height30(),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: customMediumBoldText(
                                title: 'Cancel'.tr, color: ColorsUtils.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  height30(),
                  isAuth == 1
                      ? SizedBox()
                      : InkWell(
                          onTap: () async {
                            _checkBio();
                          },
                          child: Container(
                            width: Get.width * 0.2,
                            height: Get.height * 0.07,
                            child: Image.asset(Images.fingerAuth),
                          ),
                        )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _checkBio() async {
    try {
      _hasBioSensor = await authentication.canCheckBiometrics;

      if (_hasBioSensor!) {
        isAuth == 1
            ? Platform.isAndroid
                ? Utility.androidVersion >= 32
                    ? goToNextPage()
                    : Get.snackbar(
                        'error'.tr,
                        'device does not have hardware support for biometrics'
                            .tr)
                : goToNextPage()
            : _getAuth();
      }
      print('_hasBioSensor===$_hasBioSensor');
      if (_hasBioSensor == false) {
        Get.back();
        Get.snackbar('error'.tr, 'Device Not Supported'.tr);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuthe = false;
    String cellNo = await encryptedSharedPreferences.getString('bioNumber');
    String pass = await encryptedSharedPreferences.getString('bioPass');

    try {
      isAuthe = await authentication.authenticate(
          localizedReason: 'Scan your Fingerprint',
          options: const AuthenticationOptions(
              biometricOnly: true, useErrorDialogs: true, stickyAuth: true));

      if (isAuthe) {
        Get.back();
        await encryptedSharedPreferences.setString(
            'bioDetectionFinger', 'true');
        Get.snackbar('success', 'Fingerprint set Successfully');
      }
    } on PlatformException catch (e) {
      Get.back();
      print(e);
    }
  }

  void goToNextPage() async {
    bool authStatus = await BiometricPinAuthService.authenticateBioMetrics();
    // bool authStatus = await BiometricPinAuthService.checkEnrolledBiometrics();
    // String cellNo = await encryptedSharedPreferences.getString('bioNumber');
    // String pass = await encryptedSharedPreferences.getString('bioPass');
    // bool authStatus = await authentication.authenticate(
    //     localizedReason: 'Confirm Face',
    //     options: const AuthenticationOptions(
    //         biometricOnly: true, useErrorDialogs: true, stickyAuth: false));
    print('authStatus::;$authStatus');
    if (authStatus) {
      Get.back();
      await encryptedSharedPreferences.setString('bioDetectionFace', 'true');
      Get.snackbar('success'.tr, 'Authentication set Successfully'.tr);
    } else {
      print('failed');
      Get.back();
      Get.snackbar('error'.tr,
          'device does not have hardware support for biometrics'.tr);
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return const AlertDialog(
      //           title: Text("Authentication"),
      //           content: Text(
      //             "Failed",
      //             style: TextStyle(color: Colors.red),
      //           ));
      //     });
    }
  }

  // Future<void> bottomSheetSelectBalance(
  //   BuildContext context,
  // ) {
  //   return showModalBottomSheet<void>(
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(15), topRight: Radius.circular(15))),
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setBottomState) {
  //           return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 height10(),
  //                 const Align(
  //                   alignment: Alignment.center,
  //                   child: SizedBox(
  //                     width: 70,
  //                     height: 5,
  //                     child: Divider(color: ColorsUtils.border, thickness: 4),
  //                   ),
  //                 ),
  //                 height30(),
  //                 customMediumBoldText(title: 'Select the balance'.tr),
  //                 height20(),
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(15),
  //                     border: Border.all(color: ColorsUtils.border, width: 1),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(15),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Image.asset(
  //                           Images.onlinePayment,
  //                           height: 25,
  //                           width: 25,
  //                         ),
  //                         height5(),
  //                         customSmallBoldText(title: 'Online payment Balance'.tr),
  //                         height5(),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             currencyText(
  //                                 170918.88,
  //                                 ThemeUtils.whiteBold.copyWith(
  //                                     fontSize: FontUtils.large,
  //                                     color: ColorsUtils.accent),
  //                                 ThemeUtils.whiteRegular.copyWith(
  //                                     fontSize: FontUtils.small,
  //                                     color: ColorsUtils.accent)),
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 Get.to(() => WithdrawalAmountScreen(
  //                                       withdrawFrom: 'Online',
  //                                     ));
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                   primary: ColorsUtils.accent,
  //                                   textStyle: ThemeUtils.whiteSemiBold
  //                                       .copyWith(
  //                                           fontSize: FontUtils.verySmall),
  //                                   shape: RoundedRectangleBorder(
  //                                       borderRadius:
  //                                           BorderRadius.circular(12))),
  //                               child: Text(
  //                                 "settlement".tr,
  //                                 style: ThemeUtils.whiteSemiBold
  //                                     .copyWith(fontSize: FontUtils.verySmall),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 height20(),
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(15),
  //                     border: Border.all(color: ColorsUtils.border, width: 1),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(15),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Image.asset(
  //                           Images.pos,
  //                           height: 25,
  //                           width: 25,
  //                         ),
  //                         height5(),
  //                         customSmallBoldText(title: 'POS Balance'),
  //                         height5(),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             currencyText(
  //                                 5000.88,
  //                                 ThemeUtils.whiteBold.copyWith(
  //                                     fontSize: FontUtils.large,
  //                                     color: ColorsUtils.darkYellow),
  //                                 ThemeUtils.whiteRegular.copyWith(
  //                                     fontSize: FontUtils.small,
  //                                     color: ColorsUtils.darkYellow)),
  //                             ElevatedButton(
  //                               onPressed: () {
  //                                 Get.to(() => WithdrawalAmountScreen(
  //                                       withdrawFrom: 'Pos',
  //                                     ));
  //                                 // bottomSheetSelectBalance(context);
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                   primary: ColorsUtils.darkYellow,
  //                                   textStyle: ThemeUtils.whiteSemiBold
  //                                       .copyWith(
  //                                           fontSize: FontUtils.verySmall),
  //                                   shape: RoundedRectangleBorder(
  //                                       borderRadius:
  //                                           BorderRadius.circular(12))),
  //                               child: Text(
  //                                 "settlement".tr,
  //                                 style: ThemeUtils.whiteSemiBold
  //                                     .copyWith(fontSize: FontUtils.verySmall),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 height30()
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Padding dividerData() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Divider(height: 1.5, color: ColorsUtils.line),
    );
  }

  Widget withdrawCard() {
    return adsListResponse == null || adsListResponse?.length == 0
        ? SizedBox()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 0),
            height: Get.width,
            width: Get.width,
            //   child: Image.asset(
            //     Images.withdrawCard,
            //     fit: BoxFit.fill,
            //   ),
            // ));
            child: SizedBox(
                height: Get.width,
                width: Get.width,
                child: Column(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                          aspectRatio: 16 / 16,
                          height: Get.width * 0.88,
                          onPageChanged: (index, reason) {
                            setState(() {
                              pageIndex = index;
                            });
                          },
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          enlargeCenterPage: true,
                          autoPlayCurve: Curves.linear,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale),
                      items: adsListResponse!.map((pagePosition) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Image.network(
                              '${Utility.baseUrl}containers/api-ad/download/${pagePosition.filename}',
                              headers: {HttpHeaders.authorizationHeader: token},
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                    child: Image.asset(Images.noImage));
                              },
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }).toList(),
                    ),
                    CarouselIndicator(
                      count: adsListResponse!.length,
                      index: pageIndex,
                      activeColor: ColorsUtils.accent,
                      color: ColorsUtils.border,
                    ),
                  ],
                )));

    return adsListResponse == null || adsListResponse?.length == 0
        ? SizedBox()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: Get.width,
            width: Get.width,
            //   child: Image.asset(
            //     Images.withdrawCard,
            //     fit: BoxFit.fill,
            //   ),
            // ));
            child: SizedBox(
                height: Get.width,
                width: Get.width,
                child: PageView.builder(
                    itemCount: adsListResponse!.length,
                    pageSnapping: true,
                    itemBuilder: (context, pagePosition) {
                      return Image.network(
                        '${Utility.baseUrl}containers/api-ad/download/${adsListResponse![pagePosition].filename}',
                        headers: {HttpHeaders.authorizationHeader: token},
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Image.asset(Images.noImage));
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      );
                    })

                // ListView.builder(
                //         shrinkWrap: true,
                //         itemCount: adsListResponse!.length,
                //         scrollDirection: Axis.horizontal,
                //         itemBuilder: (context, index) {
                //           return Image.network(
                //             '${Utility.baseUrl}containers/api-ad/download/${adsListResponse![index].filename}',
                //             headers: {HttpHeaders.authorizationHeader: token},
                //             fit: BoxFit.contain,
                //             errorBuilder: (context, error, stackTrace) {
                //               return Center(child: Image.asset(Images.noImage));
                //             },
                //             loadingBuilder: (BuildContext context, Widget child,
                //                 ImageChunkEvent? loadingProgress) {
                //               if (loadingProgress == null) return child;
                //               return Center(
                //                 child: CircularProgressIndicator(
                //                   value: loadingProgress.expectedTotalBytes != null
                //                       ? loadingProgress.cumulativeBytesLoaded /
                //                           loadingProgress.expectedTotalBytes!
                //                       : null,
                //                 ),
                //               );
                //             },
                //           );
                //         },
                //       ),
                ));
  }

  Padding createItemList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Container(
        height: Get.height * 0.18,
        width: Get.width,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: StaticData().createModuleList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: index == 0
                  ? EdgeInsets.only(
                      left: Get.locale!.languageCode == 'en' ? 20 : 3,
                      right: Get.locale!.languageCode == 'en' ? 3 : 20)
                  : index == StaticData().createModuleList.length - 1
                      ? EdgeInsets.only(
                          right: Get.locale!.languageCode == 'en' ? 20 : 3,
                          left: Get.locale!.languageCode == 'en' ? 3 : 20)
                      : const EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                onTap: () {
                  index == 0
                      ? showCreateInvoiceDialog(context)
                      : index == 1
                          ? Get.to(() => CreateProductScreen())
                          : index == 2
                              ? Get.to(() => CreateSubscriptionScreen())
                              : Get.to(() => CreateSubscriptionScreen());
                },
                child: commonCreateModule(
                  title: StaticData().createModuleList[index]['title'],
                  icon: StaticData().createModuleList[index]['icon'],
                  addIcon: StaticData().createModuleList[index]['addIcon'],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget userDetailsContainer() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFF5F5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            boxShadow: [
              BoxShadow(
                  blurRadius: 2, color: Colors.black26, offset: Offset(0, 2))
            ]),
        padding: EdgeInsets.all(12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greetingsOfDay(),
                  style: TextStyle(
                      fontSize: FontUtils.verySmall,
                      color: ColorsUtils.hintColor),
                ),
                height4(),
                Text("${userName}",
                    style: TextStyle(
                        fontSize: FontUtils.large,
                        color: ColorsUtils.hintColor,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis)),
                height4(),
                Text("${'Sadad ID'.tr} : ${sadadId}",
                    style: TextStyle(
                        fontSize: FontUtils.small,
                        color: ColorsUtils.hintColor))
              ],
            ),
          ),
          isSubmerchantEnabled == "true" && isSubMarchantAvailable == "true"
              ? InkWell(
                  onTap: () {
                    Get.to(subMarchantSwitchList());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: ColorsUtils.accent.withOpacity(0.5),
                              blurRadius: 3,
                              offset: Offset(0.1, 2))
                        ]),
                    width: 30,
                    height: 30,
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: ColorsUtils.accent),
                  ),
                )
              : SizedBox()
        ]),
      ),
    );
  }

  String greetingsOfDay() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!'.tr;
    }
    if (hour < 17) {
      return 'Good Afternoon!'.tr;
    }
    return 'Good Evening!'.tr;
  }

  Padding userDetails() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "hi".tr + ", " + (username),
                  // Utility.name.substring(0, Utility.name.indexOf(' ')),
                  style:
                      ThemeUtils.blackBold.copyWith(fontSize: FontUtils.large),
                  softWrap: true,
                ),
                Text("Welcome Back,".tr,
                    style: ThemeUtils.blackRegular.copyWith(
                        fontSize: FontUtils.small,
                        color: ColorsUtils.black.withOpacity(0.5)))
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.to(() => ScanQrScreen());
              // Get.to(() => QRViewExample());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Images.qrCode,
                  height: FontUtils.large,
                  width: FontUtils.large,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text("scan".tr,
                    style: ThemeUtils.blackSemiBold.copyWith(
                      fontSize: FontUtils.verySmall,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container spaceContainer() {
    return Container(
      height: 8,
      color: ColorsUtils.tabUnselect,
      margin: const EdgeInsets.symmetric(vertical: 30),
    );
  }

  Row paymentMethodItem(
      {String? icon,
      String? name,
      String? percentage,
      int? index,
      String? value}) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: ColorsUtils.createInvoiceContainer,
              borderRadius: BorderRadius.circular(12)),
          child: Image.asset(
            icon == 'MASTERCARD'
                ? Images.masterCard
                : icon == 'VISA'
                    ? Images.visaCard
                    : icon == 'GOOGLE PAY'
                        ? Images.googlePay
                        : icon == 'APPLE PAY'
                            ? Images.applePay
                            : icon == 'AMERICAN EXPRESS'
                                ? Images.amex
                                : icon == 'UPI'
                                    ? Images.upi
                                    : icon == 'JCB'
                                        ? Images.jcb
                                        : icon == 'NAPS'
                                            ? Images.napsImage
                                            : icon == 'SADAD PAY'
                                                ? Images.sadadWalletPay
                                                : Images.mobilePay,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              selectedPaymentMethod = name!;
              setState(() {});
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      name!.tr,
                      style: ThemeUtils.blackSemiBold
                          .copyWith(fontSize: FontUtils.small),
                    ),
                    selectedPaymentMethod != name
                        ? SizedBox()
                        : Row(
                            children: [
                              Container(
                                  decoration:
                                      BoxDecoration(color: ColorsUtils.black),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    child: Center(
                                        child: Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: dashBoardViewModel
                                                        .transactionChartLine
                                                        .value ==
                                                    'Failure'
                                                ? ColorsUtils.chartYellow
                                                : ColorsUtils.accent,
                                            radius: 3),
                                        width10(),
                                        customVerySmallBoldText(
                                            color: ColorsUtils.white,
                                            title: dashBoardViewModel
                                                .transactionChartLine.value),
                                        width10(),
                                        customVerySmallSemiText(
                                            color: ColorsUtils.white,
                                            title: ':  ${value}'),
                                      ],
                                    )),
                                  )),
                            ],
                          ),
                    Text(
                      "$percentage%",
                      style: ThemeUtils.blackSemiBold
                          .copyWith(fontSize: FontUtils.small),
                    )
                  ],
                ),
                ProgressBar(
                    max: 100,
                    current: double.parse(percentage!),
                    color: dashBoardViewModel.transactionChartLine.value ==
                            'Failure'
                        ? ColorsUtils.chartYellow
                        : ColorsUtils.accent)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget commonCreateModule({String? icon, String? addIcon, String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Container(
        // padding: const EdgeInsets.all(16),

        width: Get.width * 0.33,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ColorsUtils.white,
            boxShadow: [
              BoxShadow(
                  color: ColorsUtils.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 0))
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    icon!,
                    width: 30,
                    height: 30,
                  ),
                  Image.asset(
                    addIcon!,
                    width: 20,
                    height: 20,
                  )
                ],
              ),
              height10(),
              SizedBox(
                width: Get.width * 0.22,
                child: Text(
                  title!.tr,
                  style: ThemeUtils.blackBold
                      .copyWith(fontSize: FontUtils.verySmall),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container timeZone() {
    return Container(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().chartsZone.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 && Get.locale!.languageCode == 'en'
                ? const EdgeInsets.only(left: 20, right: 5)
                : index == StaticData().chartsZone.length - 1 &&
                        Get.locale!.languageCode == 'en'
                    ? const EdgeInsets.only(right: 20, left: 5)
                    : const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedChartZone.clear();
                selectedChartZone.add(StaticData().chartsZone[index]);
                dateFilter = StaticData().chartsZone[index];
                if (selectedChartZone.contains('Custom')) {
                  // _selectDate(context);
                  await datePicker(context);
                  // if (startDate != '' && endDate == '') {
                  //   endDate = startDate;
                  //   setState(() {});
                  // }
                  print('dates $startDate$endDate');
                  if (startDate != '' && endDate != '') {
                    selectedChartZone.add('Custom');
                    dateFilter =
                        'custom&filter[between]=["$startDate", "$endDate"]';
                    // selectedChartZone.add(
                    //     'custom&filter[between]=["$startDate", "$endDate"]');
                    getChartData();
                  }
                } else {
                  _range = '';
                  print('$selectedChartZone');
                  getChartData();
                }
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: selectedChartZone
                            .contains(StaticData().chartsZone[index])
                        ? ColorsUtils.primary
                        : ColorsUtils.tabUnselect),
                child: Center(
                  child: Text(
                    index == 5
                        ? _range == ''
                            ? StaticData().chartsZone[index].tr
                            : _range
                        : StaticData().chartsZone[index].tr,
                    style: ThemeUtils.maroonSemiBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedChartZone
                                .contains(StaticData().chartsZone[index])
                            ? ColorsUtils.white
                            : ColorsUtils.tabUnselectLabel),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> datePicker(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // _range = '';
          // startDate = '';
          // endDate = '';
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorsUtils.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsUtils.border)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Select Dates'.tr,
                                style: ThemeUtils.blackBold.copyWith(
                                    color: ColorsUtils.accent,
                                    fontSize: FontUtils.medium),
                              ),
                              height20(),
                              SfDateRangePicker(
                                onSelectionChanged:
                                    (dateRangePickerSelectionChangedArgs) {
                                  if (dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          null ||
                                      dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          '') {
                                    endDate = '';
                                    _range = '';
                                  } else {
                                    if (dateRangePickerSelectionChangedArgs
                                        .value is PickerDateRange) {
                                      _range =
                                          '${intl.DateFormat('dd MMM’ yy').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                          ' ${intl.DateFormat('dd MMM’ yy').format(dateRangePickerSelectionChangedArgs.value.endDate)}';
                                      setState(() {});
                                    }
                                    final difference =
                                        dateRangePickerSelectionChangedArgs
                                            .value.endDate
                                            .difference(
                                                dateRangePickerSelectionChangedArgs
                                                    .value.startDate)
                                            .inDays;
                                    differenceDays =
                                        int.parse(difference.toString());
                                    print('days is :::$difference');
                                  }
                                  if (differenceDays >= 364) {
                                    Get.snackbar('warning'.tr,
                                        'Please select range in 12 month'.tr);
                                    startDate = '';
                                    endDate = '';
                                  } else {
                                    startDate = intl.DateFormat(
                                            'yyyy-MM-dd HH:mm:ss')
                                        .format(DateTime.parse(
                                            '${dateRangePickerSelectionChangedArgs.value.startDate}'));

                                    dateRangePickerSelectionChangedArgs
                                                    .value.endDate ==
                                                null ||
                                            dateRangePickerSelectionChangedArgs
                                                    .value.endDate ==
                                                ''
                                        ? ''
                                        : endDate = intl.DateFormat(
                                                'yyyy-MM-dd 23:59:59')
                                            .format(DateTime.parse(
                                                '${dateRangePickerSelectionChangedArgs.value.endDate}'));
                                  }

                                  setDialogState(() {});
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                maxDate: DateTime.now(),
                                initialSelectedRange: PickerDateRange(
                                    startDate == ''
                                        ? DateTime.now()
                                            .subtract(const Duration(days: 7))
                                        : DateTime.parse(startDate),
                                    endDate == ''
                                        ? DateTime.now()
                                        : DateTime.parse(endDate)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: ColorsUtils.border)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Selected Dates: '.tr,
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.verySmall),
                                      ),
                                      Text(
                                        _range,
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.verySmall),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              height20(),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: buildContainerWithoutImage(
                                          color: ColorsUtils.accent,
                                          text: 'Select'.tr),
                                    ),
                                  ),
                                  width10(),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                        // _range = '';
                                        startDate = '';
                                        endDate = '';
                                        setState(() {});
                                      },
                                      child: buildContainerWithoutImage(
                                          color: ColorsUtils.accent,
                                          text: 'Cancel'.tr),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  AppBar appBarView() {
    return AppBar(
      // leading: SizedBox(
      //   height: 100,
      //   width: 100,
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 10),
      //     child: Image.asset(
      //       Images.sadadLogo,
      //       height: 100,
      //       width: 100,
      //     ),
      //   ),
      // ),
      bottom: isChartVisible == true
          ? PreferredSize(
              preferredSize: Size(Get.width, Get.height * 0.125),
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedBuilder(
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: animation!,
                        child: Column(
                          children: [
                            onlinePos(),
                            timeZone(),
                          ],
                        ),
                      );
                    },
                    animation: animationController!,
                  )))
          : const PreferredSize(child: SizedBox(), preferredSize: Size(0, 0)),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            Images.sadadLogo,
            height: 80,
            width: 80,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // InkWell(
              //   onTap: () {
              //     enLng = !enLng;
              //     Get.updateLocale(Locale(enLng ? 'ar' : 'en'));
              //     setState(() {});
              //   },
              //   child: Text(
              //     enLng ? 'en' : 'ar',
              //     style: ThemeUtils.blackBold.copyWith(
              //         color: ColorsUtils.accent, fontSize: FontUtils.medium),
              //   ),
              // ),

              InkWell(
                onTap: () async {
                  await Get.to(() => NotificationScreen());
                  notiCount();
                  // setState(() {});
                  print('token    ${Utility.deviceId}');
                },
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      const SizedBox(
                        child: ImageIcon(
                          AssetImage(Images.notificationBlack),
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      notificationCount == '0'
                          ? SizedBox()
                          : Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: ColorsUtils.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    notificationCount,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
              width20(),
              InkWell(
                onTap: () {
                  Get.to(() => ScanQrScreen());
                  // Get.to(() => QRViewExample());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.qrCode,
                      height: FontUtils.large,
                      width: FontUtils.large,
                      fit: BoxFit.fitHeight,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text("scan".tr,
                        style: ThemeUtils.blackSemiBold.copyWith(
                          fontSize: FontUtils.verySmall,
                        ))
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> notiCount() async {
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');
    final url = Uri.parse(
      '${Utility.baseUrl}notificationreceivers/count?where[notificationreceiverId]=$id&where[isread]=0',
    );
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.get(
      url,
      headers: header,
    );

    print('token is:$token } \n url $url  \n response is :${result.body} ');
    if (result.statusCode == 200) {
      notificationCount = '${jsonDecode(result.body)['count']}';
      // setState(() {});
      print('notification count:::${jsonDecode(result.body)['count']}');
    } else {
      Get.back();
      Get.snackbar(
          'error'.tr, '${jsonDecode(result.body)['error']['message']}');
    }
  }

  initData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkAppVersion(context);
    });
    dashBoardViewModel.initIsChartLoad = true;
    token = await encryptedSharedPreferences.getString('token');
    String sadadId = await encryptedSharedPreferences.getString('sadadId');
    OneSignal.shared.setExternalUserId(sadadId);

    ///API CALL
    getData();

    ///ANIMATION
    animationScrollData();
  }

  void animationScrollData() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.pixels >= (chartWidgetPosition! - 30)) {
          if (!isChartVisible) {
            setState(() {
              isChartVisible = true;
              animationController!.forward();
            });
          }
        } else {
          if (isChartVisible) {
            setState(() {
              isChartVisible = false;
              animationController!.reverse();
            });
          }
        }
      });
    _tooltipBehavior = TooltipBehavior(
      enable: true,
    );
  }

  getData() async {
    username = await encryptedSharedPreferences.getString('name');
    String id = await encryptedSharedPreferences.getString('id');
    print('id is $id');
    await dashBoardViewModel.availableBalance(id);
    await dashBoardViewModel.adsList();
    if (dashBoardViewModel.adsListApiResponse.status == Status.COMPLETE) {
      adsListResponse = dashBoardViewModel.adsListApiResponse.data;
      print('====>>>${adsListResponse}');
      setState(() {});
    }
    await getChartData();
    notiCount();
    dashBoardViewModel.initIsChartLoad = false;
    await Future.delayed(const Duration(seconds: 1), () {
      print('go to pos');

      getPosition();
    });
  }

  getChartData() async {
    dataList.clear();
    transDataList.clear();

    if (isPos == true) {
      await dashBoardViewModel.posPaymentMethod(dateFilter.toLowerCase());
      await dashBoardViewModel.posSplineChart(dateFilter.toLowerCase());
    } else {
      await dashBoardViewModel.splineChart(dateFilter.toLowerCase());
      await dashBoardViewModel.transactionChart(dateFilter.toLowerCase());
      await dashBoardViewModel.paymentMethod(dateFilter.toLowerCase());
    }
  }

  void getPosition() {
    try {
      if (_key.currentContext == null) {
        print('null state');
        return;
      }
      RenderBox? box = _key.currentContext!.findRenderObject() as RenderBox?;
      Offset position =
          box!.localToGlobal(Offset.zero); //this is global position
      double y = position.dy;
      print("key  y position: " + y.toString());
      chartWidgetPosition = y;
      setState(() {});
    } on Exception catch (e) {
      print('error $e');
      // TODO
    }
  }

  getNotificationSettings() async {
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');

    final url = Uri.parse(
        Utility.baseUrl + "/usermetapreferences?filter[where][userId]=$id");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    var result = await http.get(url, headers: header);
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      List data = json.decode(result.body);
      // notificationResponseModel = NotificationResponseModel.fromJson(data[0]);
      // print("id is :- ${data[0]["id"]}");
      // userMetaPrefID.value = notificationResponseModel.id!;
      print("data is :- ${data[0]["receivedpaymentsms"]}");

      // notificationModel.value.isPlayaSound =
      //     notificationResponseModel.isplayasound;
    } else if (result.statusCode == 401) {
      //Get.back(result: true);
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }
  docExpiredAlert({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: ColorsUtils.black.withOpacity(0.3), blurRadius: 3, offset: Offset(0, 4), spreadRadius: 3)]),
                  padding: EdgeInsets.all(Get.width * .03),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      height20(),
                      Container(width: 50,height: 50,child: Image.asset(Images.information)),
                      height20(),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                        Get.locale.toString() == "en" ? promtDocMessageEn.toString() : promtDocMessageAr.toString(),
                          textAlign: TextAlign.center,
                          style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small, color: ColorsUtils.black),
                        ),
                      ),
                      height20(),
                      InkWell(
                          onTap: () {
                            Get.back();
                            Get.to(() => BusinessDetailInsert(isFirstTime: false,));
                          },
                          child: buildContainerWithoutImage(
                              width: Get.width * 0.65, style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.accent, text: 'Update'.tr)),
                      height12(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: buildContainerWithoutImage(
                              width: Get.width * 0.65, style: ThemeUtils.maroonSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.border, text: 'Cancel'.tr)),
                      height20(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  bottomSheetforGraphLine(BuildContext context) {
    showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 70,
                        height: 5,
                        child: Divider(color: ColorsUtils.border, thickness: 4),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        dashBoardViewModel.transactionChartLine.value = 'All';

                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'All'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        dashBoardViewModel.transactionChartLine.value =
                            'Success';

                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'Success'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        dashBoardViewModel.transactionChartLine.value =
                            'Failure';

                        Get.back();
                      },
                      child: customSmallMedBoldText(title: 'Failure'.tr)),
                  height40(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
