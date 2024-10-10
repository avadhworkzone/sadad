// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/posAllTransactionResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/posCounterResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/batchSummary/batchSummaryScreen.dart';
import 'package:sadad_merchat_app/view/pos/liveTerminalScreen.dart';
import 'package:sadad_merchat_app/view/pos/report/posReportScreen.dart';
import 'package:sadad_merchat_app/view/pos/terminals/terminalScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/posTransactionListScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/posTransactionCountViewModel.dart';

import 'posTerminalRequestScreen.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  String selectedDate = 'week';
  double? posWidgetPosition = 0.0;
  bool isPosVisible = false;
  final GlobalKey _key = GlobalKey();
  AnimationController? animationController;
  Animation<double>? animation;
  ScrollController? _scrollController;
  PosTransactionCountViewModel posTransactionCountViewModel = Get.find();
  PosAllTransactionCountResponseModel? posTransactionCountRes;
  PosCounterResponseModel? posCounterRes;
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    AnalyticsService.sendAppCurrentScreen('Pos Screen');
    _tabController = TabController(length: 3, vsync: this);
    posTransactionCountViewModel.setInit();
    initData();
    super.initState();
  }

  // locationPermission() async {
  //   var location = await Permission.location.request();
  //
  //   log("LOCATION PERMISSION $location");
  //   if (location.isPermanentlyDenied) {
  //     // We didn't ask for permission yet or the permission has been denied before but not permanently.
  //     openAppSettings().then((value) async {
  //       log("STATUS vale ${value}");
  //
  //       if (value == false) {
  //         await Permission.location.request();
  //       }
  //     });
  //   }
  // }

  @override
  void dispose() {
    _scrollController?.dispose();
    animationController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            appBar: isPosVisible == true
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(80),
                    child: AnimatedBuilder(
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: animation!,
                          child: Container(
                            padding: const EdgeInsets.only(top: 50),
                            height: 80,
                            decoration: const BoxDecoration(
                                color: ColorsUtils.posYellowBg),
                            width: Get.width,
                            child: Center(
                              child: customMediumLargeBoldText(
                                  color: ColorsUtils.black,
                                  title: 'Sadad POS'.tr),
                            ),
                          ),
                        );
                      },
                      animation: animationController!,
                    ))
                : const PreferredSize(
                    child: SizedBox(), preferredSize: Size(0, 0)),
            body: GetBuilder<PosTransactionCountViewModel>(
              builder: (controller) {
                if (controller.posTransactionCountApiResponse.status ==
                        Status.LOADING ||
                    controller.posCounterApiResponse.status == Status.LOADING) {
                  return const Center(
                    child: Loader(),
                  );
                }
                if (controller.posTransactionCountApiResponse.status ==
                        Status.ERROR ||
                    controller.posCounterApiResponse.status == Status.ERROR) {
                  // return const Center(
                  //   child: Text('Error'),
                  // );
                  return SessionExpire();
                }
                posTransactionCountRes = posTransactionCountViewModel
                    .posTransactionCountApiResponse.data;
                posCounterRes =
                    posTransactionCountViewModel.posCounterApiResponse.data;
                return SingleChildScrollView(
                    controller: _scrollController,
                    physics: posWidgetPosition == 0.0
                        ? NeverScrollableScrollPhysics()
                        : const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        topView(),
                        bottomGridview(),
                      ],
                    ));
              },
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                AnalyticsService.sendAppCurrentScreen('Pos Screen');

                _tabController = TabController(length: 3, vsync: this);
                posTransactionCountViewModel.setInit();
                setState(() {});
                initData();
              } else {
                Get.snackbar('error'.tr, 'Please check your connection'.tr);
              }
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          },
        );
      }
    } else {
      return InternetNotFound(
        onTap: () async {
          connectivityViewModel.startMonitoring();

          if (connectivityViewModel.isOnline != null) {
            if (connectivityViewModel.isOnline!) {
              AnalyticsService.sendAppCurrentScreen('Pos Screen');

              _tabController = TabController(length: 3, vsync: this);
              posTransactionCountViewModel.setInit();
              setState(() {});
              initData();
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection'.tr);
          }
        },
      );
    }
  }

  Container bottomGridview() {
    return Container(
      color: ColorsUtils.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customMediumLargeBoldText(
                color: ColorsUtils.black, title: 'Services'.tr),
            height20(),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              childAspectRatio: 158 / 139,
              crossAxisCount: 2,
              crossAxisSpacing: 11,
              mainAxisSpacing: 12,
              children:
                  List.generate(StaticData().posServiceList.length, (index) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: ColorsUtils.createInvoiceContainer,
                      border: Border.all(color: ColorsUtils.line),
                      borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () {
                      filterClear();
                      Get.to(() => index == 0
                          ? const TerminalScreen()
                          : index == 1
                              ? const BatchSummaryScreen()
                              :
                              // index == 2
                              //             ? const DeviceListScreen()
                              //             :
                              index == 2
                                  ? PosTransactionListScreen()
                                  : const PosReportScreen());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${StaticData().posServiceList[index]['name']}"
                                    .tr,
                                maxLines: index == 2 ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeUtils.blackBold
                                    .copyWith(fontSize: FontUtils.medium),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        if (index != 1)
                          Text(
                            "${index == 0 ? posCounterRes!.terminals : index == 1 ? posCounterRes!.devices : index == 2 ? posCounterRes!.transactions : ""} ",
                            style: ThemeUtils.blackRegular.copyWith(
                                fontSize: FontUtils.verySmall,
                                color: ColorsUtils.grey),
                          ),
                        const Spacer(),
                        Row(
                          children: [
                            Image.asset(
                              StaticData().posServiceList[index]['icon'],
                              width: 24,
                              height: 24,
                              color: StaticData().posServiceList[index]
                                  ['color'],
                            ),
                            const Spacer(),
                            Container(
                              decoration: const BoxDecoration(
                                  color: ColorsUtils.white,
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                    color: StaticData().posServiceList[index]
                                        ['color'],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  void filterClear() {
    ///pos terminal
    Utility.terminalFilterPaymentMethod = '';
    Utility.terminalFilterTransModes = '';
    Utility.terminalFilterTransStatus = '';
    Utility.terminalFilterStartActivationDate = '';
    Utility.terminalFilterEndActivationDate = '';
    Utility.terminalFilterDeviceStatus = '';
    Utility.terminalCountFilterPaymentMethod = '';
    Utility.terminalCountFilterTransModes = '';
    Utility.terminalCountFilterTransStatus = '';
    Utility.holdTransactionFilterTransactionModes = '';
    Utility.holdTransactionFilterPaymentMethod = '';
    Utility.holdDeviceFilterDeviceStatus = '';
    Utility.holdDeviceFilterDeviceType = '';
    Utility.holdTerminalActivationStartDate = '';
    Utility.holdTerminalActivationEndDate = '';
    Utility.holdTransactionFilterStatus = '';
    Utility.holdDeviceFilterStatus = '';
    Utility.holdDeviceFilterDeviceType = '';
    Utility.terminalCountFilterDeviceStatus = '';
    Utility.terminalCountFilterStartActivationDate = '';
    Utility.terminalCountFilterEndActivationDate = '';
    Utility.deviceFilterCountDeviceType = '';

    ///pos device
    Utility.deviceFilterDeviceStatus = '';
    Utility.deviceFilterDeviceType = '';
    Utility.deviceFilterCountDeviceType = '';
    Utility.deviceFilterCountDeviceStatus = '';
    Utility.holdDeviceFilterDeviceStatus = '';
    Utility.holdDeviceFilterDeviceType = '';

    ///pos transaction
    Utility.posDisputeTransactionStatusFilter = '';
    Utility.posDisputeTransactionTypeFilter = '';
    Utility.posPaymentTransactionStatusFilter = '';
    Utility.posPaymentCardEntryTypeFilter = '';
    Utility.posPaymentTransactionTypeFilter = '';
    Utility.posPaymentPaymentMethodFilter = '';
    Utility.posPaymentTransactionModesFilter = '';
    Utility.posRefundTransactionModesFilter = '';
    Utility.posRefundCardEntryTypeFilter = '';
    Utility.posRefundPaymentMethodFilter = '';
    Utility.posRefundTransactionStatusFilter = '';
    Utility.posRentalPaymentStatusFilter = '';
    Utility.holdPosDisputeTransactionTypeFilter = '';
    Utility.holdPosDisputeTransactionStatusFilter = '';
    Utility.holdPosPaymentTransactionStatusFilter = '';
    Utility.holdPosPaymentPaymentMethodFilter = '';
    Utility.holdPosPaymentTransactionModesFilter = '';
    Utility.holdPosPaymentTransactionTypeFilter = [];
    Utility.holdPosPaymentCardEntryTypeFilter = '';
    Utility.holdPosRefundTransactionStatusFilter = '';
    Utility.holdPosRefundPaymentMethodFilter = '';
    Utility.holdPosRefundTransactionModesFilter = '';
    Utility.holdPosRefundCardEntryTypeFilter = '';
    Utility.holdPosRentalPaymentStatusFilter = '';
    Utility.posPaymentTerminalSelectionFilter = [];
    Utility.posRentalPaymentTerminalSelectionFilter = [];
    Utility.holdPosPaymentTerminalSelectionFilter = [];
    Utility.holdPosRentalPaymentTerminalSelectionFilter = [];
    Utility.posPaymentTransactionTypeTerminalFilter = [];
    Utility.holdPosPaymentTransactionTypeTerminalFilter = [];
  }

  Container topView() {
    return Container(
      color: ColorsUtils.posYellowBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height50(),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Sadad POS'.tr,
                      style: ThemeUtils.blackSemiBold.copyWith(
                          color: ColorsUtils.white, fontSize: FontUtils.large),
                    ),
                  ),
                  height10(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: customSmallSemiText(
                        color: ColorsUtils.white,
                        title: 'Terminal, Devices, Transactions,…'),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Get.to(() => PosTerminalScreenRequest());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: ColorsUtils.accent),
                    child: Center(
                        child: Icon(
                      Icons.add,
                      size: 25,
                      color: ColorsUtils.white,
                    )),
                  ),
                ),
              ),
            ],
          ),
          // height30(),
          // Container(
          //   key: _key,
          //   margin: const EdgeInsets.symmetric(horizontal: 20),
          //   padding: const EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //       color: ColorsUtils.white,
          //       borderRadius: BorderRadius.circular(20)),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "POS Balance".tr,
          //         style: ThemeUtils.blackRegular.copyWith(
          //             fontSize: FontUtils.small,
          //             color: ColorsUtils.black.withOpacity(0.8)),
          //       ),
          //       height10(),
          //       Row(
          //         children: [
          //           currencyText(
          //               175918.88,
          //               ThemeUtils.maroonBold
          //                   .copyWith(fontSize: FontUtils.large),
          //               ThemeUtils.maroonRegular
          //                   .copyWith(fontSize: FontUtils.verySmall)),
          //           const Spacer(),
          //           InkWell(
          //             onTap: () {
          //               Get.to(() => const PosWithdrawalAmount());
          //             },
          //             child: Container(
          //               padding: const EdgeInsets.symmetric(
          //                   horizontal: 16, vertical: 8),
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(15),
          //                   gradient: const LinearGradient(
          //                       stops: [0.1, 0.4, 0.9],
          //                       begin: Alignment.centerLeft,
          //                       end: Alignment.centerRight,
          //                       colors: [
          //                         ColorsUtils.orange,
          //                         ColorsUtils.darkOrange,
          //                         ColorsUtils.darkMaroon
          //                       ])),
          //               child: Text(
          //                 'withdraw'.tr,
          //                 style: ThemeUtils.whiteSemiBold
          //                     .copyWith(fontSize: FontUtils.verySmall),
          //               ),
          //             ),
          //           )
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          height15(),
          InkWell(
            onTap: () async {
              await checkGps();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: ColorsUtils.white,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsUtils.tabUnselect,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(Images.pos, height: 30),
                    ),
                  ),
                  width20(),
                  Column(
                    key: _key,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          customMediumBoldText(
                              color: ColorsUtils.black,
                              title: 'Live Terminal'.tr),
                          width10(),
                          Image.asset(
                            Images.liveTerminal,
                            height: 20,
                            color: ColorsUtils.reds,
                          )
                        ],
                      ),
                      customVerySmallSemiText(
                          title: 'View your live terminal location'.tr),
                    ],
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: ColorsUtils.tabUnselect,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorsUtils.black,
                      size: 15,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: ColorsUtils.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8)),
            child: TabBar(
              onTap: (position) async {
                setState(() {
                  _tabController;
                  _tabController!.index == 0
                      ? selectedDate = 'week'
                      : _tabController!.index == 1
                          ? selectedDate = 'month'
                          : selectedDate = 'year';
                  print(selectedDate);
                  initData();
                });
              },
              padding: const EdgeInsets.all(0),
              controller: _tabController,
              indicator: const BoxDecoration(),
              labelStyle: ThemeUtils.maroonSemiBold,
              labelPadding: const EdgeInsets.all(0),
              tabs: [
                CustomTab(
                    selectedBackground: _tabController!.index == 0
                        ? Colors.white
                        : Colors.transparent,
                    selectedLabel: ColorsUtils.black,
                    title: "Week".tr),
                CustomTab(
                    selectedBackground: _tabController!.index == 1
                        ? ColorsUtils.white
                        : Colors.transparent,
                    selectedLabel: ColorsUtils.black,
                    title: "Month".tr),
                CustomTab(
                    selectedBackground: _tabController!.index == 2
                        ? Colors.white
                        : Colors.transparent,
                    selectedLabel: ColorsUtils.black,
                    title: "Year".tr),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: ColorsUtils.white),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customSmallSemiText(title: 'Success Rate'.tr),
                        customLargeBoldText(
                            color: ColorsUtils.accent,
                            title:
                                '${double.parse(posCounterRes!.successRate?.toString() ?? '0').round()} %')
                        // '${double.parse(posCounterRes!.successRate.toString()).toStringAsFixed(2)} %')
                      ],
                    ),
                    Spacer(),
                    Image.asset(
                      Images.successRate,
                      height: 40,
                      width: 40,
                    )
                  ],
                ),
              ),
            ),
          ),
          height20(),
          SizedBox(
            width: Get.width,
            height: Get.height * 0.125,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: StaticData().posTransactionAmountList.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding:
                        // index == 0
                        //     ? EdgeInsets.only(
                        //         left: Get.locale!.languageCode == 'en' ? 20 : 5,
                        //         right: Get.locale!.languageCode == 'en' ? 5 : 20)
                        //     : index == StaticData().createModuleList.length
                        //         ? EdgeInsets.only(
                        //             right:
                        //                 Get.locale!.languageCode == 'en' ? 20 : 5,
                        //             left: Get.locale!.languageCode == 'en' ? 5 : 20)
                        //         :
                        const EdgeInsets.symmetric(horizontal: 10),
                    // child: TransactionAmount(
                    //     StaticData().posTransactionAmountList[index]['title'],
                    //     StaticData().posTransactionAmountList[index]['icon'],
                    //     index == 0
                    //         ? double.parse(posTransactionCountRes!
                    //             .successTransaction
                    //             .toString())
                    //         : index == 1
                    //             ? double.parse(posTransactionCountRes!
                    //                 .amountReceived
                    //                 .toString())
                    //             : index == 2
                    //                 ? double.parse(posTransactionCountRes!
                    //                     .activeTerminals
                    //                     .toString())
                    //                 : double.parse(posTransactionCountRes!
                    //                     .inactiveTerminals
                    //                     .toString()),
                    //     StaticData().posTransactionAmountList[index]['Color'],
                    //     imgColor: StaticData().posTransactionAmountList[index]
                    //         ['Color']),
                    child: Container(
                        decoration: BoxDecoration(
                            color: ColorsUtils.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.275,
                                    child: Text(
                                      '${StaticData().posTransactionAmountList[index]['title']}'
                                          .tr,
                                      style: ThemeUtils.blackSemiBold
                                          .copyWith(fontSize: FontUtils.small),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    StaticData().posTransactionAmountList[index]
                                        ['icon'],
                                    color: StaticData()
                                            .posTransactionAmountList[index]
                                        ['Color'],
                                    width: 24,
                                    height: 24,
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customMediumSemiText(
                                      color: StaticData()
                                              .posTransactionAmountList[index]
                                          ['Color'],
                                      title:
                                          '${index == 0 ? double.parse(posCounterRes!.successTxnAmnt?.toString() ?? '0').round() : index == 1 ? double.parse(posCounterRes!.transactions?.toString() ?? '0').round() : index == 2 ? double.parse(posTransactionCountRes!.activeTerminals?.toString() ?? "0").round() : double.parse(posTransactionCountRes!.inactiveTerminals?.toString() ?? '0').round()}'),
                                  width10(),
                                  // index == 0 || index == 1
                                  //     ? customSmallSemiText(
                                  //         title: '',
                                  //         color: StaticData()
                                  //                 .posTransactionAmountList[
                                  //             index]['Color'])
                                  //     : SizedBox()
                                ],
                              )
                            ],
                          ),
                        )));
              },
            ),
          ),
          height30(),
        ],
      ),
    );
  }

  static String lat = '';
  static String long = '';
  bool serviceStatus = false;
  bool hasPermission = false;
  late LocationPermission permission;
  late Position position;

  checkGps() async {
    var location = await Permission.location.request();
    log("LOCATION PERMISSION $location");
    if (location.isPermanentlyDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      openAppSettings().then((value) async {
        log("STATUS vale ${value}");

        if (value == false) {
          var status = await Permission.location.request();
        }
      });
    } else if (location.isGranted) {
      serviceStatus = await Geolocator.isLocationServiceEnabled();
      if (serviceStatus) {
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            // showSnackBar(
            //     message: "Location permissions are denied",
            //     snackColor: ColorUtils.red);
          } else if (permission == LocationPermission.deniedForever) {
            // showSnackBar(
            //     message: "Location permissions are permanently denied",
            //     snackColor: ColorUtils.red);
          } else {
            hasPermission = true;
          }
        } else {
          hasPermission = true;
        }

        if (hasPermission) {
          getLocation();
        }
      } else {
        // showSnackBar(
        //     message: "GPS Service is not enabled, turn on GPS location",
        //     snackColor: ColorUtils.red);
      }
    }
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // debugPrint('location: ${position.latitude}');
    // debugPrint('longitude: ${position.longitude}');
    // List<Placemark> placeMarks =
    //     await placemarkFromCoordinates(position.latitude, position.longitude);

    lat = position.latitude.toString();
    long = position.longitude.toString();
    Get.to(CustomMapScreen(
      lat: lat,
      long: long,
    ));

    log("====lat=========${lat}");
    log("====long=========${long}");
  }

  void initData() async {
    ///ANIMATION
    scrollData();

    ///api call
    await posTransactionCountViewModel.posTransactionCount(selectedDate);
    await posTransactionCountViewModel.posCounter(selectedDate);

    await Future.delayed(const Duration(seconds: 1), () {
      getPosition();
    });
  }

  void scrollData() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.pixels >= (posWidgetPosition! - 30)) {
          if (!isPosVisible) {
            setState(() {
              isPosVisible = true;
              animationController!.forward();
            });
          }
        } else {
          if (isPosVisible) {
            setState(() {
              isPosVisible = false;
              animationController!.reverse();
            });
          }
        }
      });
  }

  void getPosition() {
    try {
      if (_key.currentContext == null) {
        return;
      }
      RenderBox? box = _key.currentContext!.findRenderObject() as RenderBox?;
      Offset position =
          box!.localToGlobal(Offset.zero); //this is global position
      double y = position.dy;
      print("key  y position: " + y.toString());
      posWidgetPosition = y;
      setState(() {});
    } on Exception catch (e) {
      print('error $e');
      // TODO
    }
  }
}
