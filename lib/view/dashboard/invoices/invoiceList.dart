// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/invoiceCountResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/dashboard/dashboardInvoiceBottomSheet.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/detailedInvoiceScreen.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/fastInvoiceScreen.dart';
import 'package:sadad_merchat_app/view/payment/reports/invoiceOnlineReportFilterScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/invoiceListViewModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../model/apimodels/responseModel/DashBoard/invoice/invoiceListAllResponseModel.dart';
import '../../../model/apis/api_response.dart';
import '../../../staticData/staticData.dart';
import 'filterScreen.dart';
import 'invoicedetail.dart';
import 'searchInvoice.dart';
import 'package:http/http.dart' as http;

class InvoiceList extends StatefulWidget {
  const InvoiceList({Key? key}) : super(key: key);

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList>
    with TickerProviderStateMixin {
  List<String> selectedTimeZone = ['All'];
  String filterDate = '';
  String _range = '';
  String endDate = '';
  String startDate = '';
  int differenceDays = 0;
  bool isLoading = false;
  ScrollController? _scrollController;
  double? tabWidgetPosition = 0.0;
  bool isTabVisible = false;
  InvoiceListViewModel invoiceListViewModel = Get.find();
  late TabController tabController;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  GlobalKey _key = GlobalKey();
  AnimationController? animationController;
  Animation<double>? animation;
  int selectedTab = 0;
  bool isPageFirst = true;
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  String searchingFilter = '';
  List selectedType = ['Transaction Id'];
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    Utility.holdFilterSorted = 4;
    AnalyticsService.sendAppCurrentScreen('Invoice List Screen');
    tabController = TabController(length: 5, vsync: this);
    invoiceListViewModel.setInit();
    Utility.filterSorted = '&filter[order]=created DESC';
    initData();
    super.initState();
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
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            floatingActionButton: flotingButton(),
            body: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  topView(),
                  Expanded(
                    child: GetBuilder<InvoiceListViewModel>(
                      builder: (controller) {
                        if (controller.invoiceCountApiResponse.status ==
                                Status.LOADING ||
                            controller.invoiceCountApiResponse.status ==
                                Status.INITIAL) {
                          return const Center(child: Loader());
                        }

                        if (controller.invoiceCountApiResponse.status ==
                            Status.ERROR) {
                          return const SessionExpire();
                          //return Center(child: const Text('Error'));
                        }
                        InvoiceCountResponseModel invoiceCountResponse =
                            invoiceListViewModel.invoiceCountApiResponse.data;

                        return Column(
                          children: [
                            if (isTabVisible)
                              AnimatedBuilder(
                                builder: (context, child) {
                                  return FadeTransition(
                                    opacity: animation!,
                                    child: Container(
                                        width: Get.width,
                                        decoration: const BoxDecoration(
                                          color: ColorsUtils.accent,
                                        ),
                                        child: tabBar()),
                                  );
                                },
                                animation: animationController!,
                              ),
                            Expanded(
                              child: ListView(
                                controller: _scrollController,
                                physics: tabWidgetPosition == 0.0
                                    ? NeverScrollableScrollPhysics()
                                    : ClampingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                children: [
                                  centerView(invoiceCountResponse),
                                  height25(),
                                  tabBarData(invoiceCountResponse),
                                ],
                              ),
                            ),
                            if (controller.isPaginationLoading && isPageFirst)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Loader(),
                              )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                Utility.holdFilterSorted = 0;
                AnalyticsService.sendAppCurrentScreen('Invoice List Screen');
                tabController = TabController(length: 5, vsync: this);
                invoiceListViewModel.setInit();
                Utility.filterSorted = '&filter[order]=created DESC';
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
              Utility.holdFilterSorted = 0;
              AnalyticsService.sendAppCurrentScreen('Invoice List Screen');
              tabController = TabController(length: 5, vsync: this);
              invoiceListViewModel.setInit();
              Utility.filterSorted = '&filter[order]=created DESC';
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

  scrollData(String filter) {
    ///ANIMATION
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.pixels >= (tabWidgetPosition! - 30) &&
            (tabWidgetPosition ?? 0.0) > 0.0) {
          if (!isTabVisible) {
            setState(() {
              isTabVisible = true;
              animationController!.forward();
            });
          }
        } else {
          if (isTabVisible) {
            setState(() {
              isTabVisible = false;
              animationController!.reverse();
            });
          }
        }

        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !invoiceListViewModel.isPaginationLoading) {
          if (selectedTimeZone.first == 'Custom') {
            if (startDate != '' && endDate != '') {
              filter = 'custom&filter[where][between]=';
            }
          } else {
            filter = '';
          }
          print('filter-----${filter}');

          String req = getFilterStr();
          invoiceListViewModel.listAllInvoice(
              req,
              filter +
                  filterDate +
                  Utility.activityReportGetSubUSer +
                  Utility.onlineInvoiceFilterStatus +
                  searchingFilter);
        }
      });
  }

  Widget tabBarData(InvoiceCountResponseModel invoiceCount) {
    return GetBuilder<InvoiceListViewModel>(
      builder: (controller) {
        if (controller.invoiceAllListApiResponse.status == Status.LOADING ||
            controller.invoiceAllListApiResponse.status == Status.INITIAL) {
          return const Center(child: Loader());
        }
        if (controller.invoiceAllListApiResponse.status == Status.ERROR) {
          return const SessionExpire();
        }
        List<InvoiceAllListResponseModel> invoiceAllListResponse =
            invoiceListViewModel.invoiceAllListApiResponse.data;
        return Column(
          children: [
            Container(
                key: _key,
                width: Get.width,
                decoration: const BoxDecoration(
                  color: ColorsUtils.accent,
                ),
                child: tabBar()),
            // height20(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Align(
            //       alignment: Alignment.centerRight,
            //       child: Text(selectedTab == 1
            //           ? invoiceCount.paid!.toString() + ' ' 'Invoices'.tr
            //           : selectedTab == 2
            //               ? ''
            //               // invoiceCount.unpaid!.toString() + ' ' 'Invoices'.tr
            //               : selectedTab == 3
            //                   ? ''
            //                   // '${(invoiceCount.overdue)}' +
            //                   //                 // ? '${(invoiceCount.totalCreatedInvoice) - (invoiceCount.draft + invoiceCount.paid + invoiceCount.unpaid)}' +
            //                   //                 ' '
            //                   //                         'Invoices'
            //                   //                     .tr
            //                   : selectedTab == 4
            //                       ? ''
            //                       // invoiceCount.draft!.toString() +
            //                       //                     ' ' 'Invoices'.tr
            //                       : '${invoiceCount.totalCreatedInvoice} ${'Invoices'.tr}')),
            // ),
            tab1(
              invoiceAllListResponse,
            ),
            height40(),
            if (invoiceListViewModel.isPaginationLoading && !isPageFirst)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Loader(),
              )
          ],
        );
      },
    );
  }

  Widget tabBar() {
    return TabBar(
      controller: tabController,
      indicatorColor: ColorsUtils.white,
      onTap: (value) async {
        selectedTab = value;

        await updateApiCall();
      },
      labelStyle: ThemeUtils.blackSemiBold.copyWith(color: ColorsUtils.white),
      unselectedLabelColor: ColorsUtils.white,
      labelColor: ColorsUtils.white,
      labelPadding: const EdgeInsets.all(3),
      tabs: [
        Tab(text: "All".tr),
        Tab(text: "Paid".tr),
        Tab(text: "Unpaid".tr),
        Tab(text: "Rejected".tr),
        Tab(text: "Draft".tr),
      ],
    );
  }

  Future<void> updateApiCall() async {
    print('clicking---------');
    String countFilter = '';
    String filter = '';
    isPageFirst = false;
    if (startDate != '' && endDate != '') {
      filter = 'custom&filter[where][between]=';
      countFilter = '&[where][datefilter]=custom&[where][between]=';
    } else {
      filter = '';
      countFilter =
          selectedTimeZone.first == 'All' ? '' : '&[where][datefilter]=';
    }
    String req = getFilterStr();

    invoiceListViewModel.clearResponseLost();
    // invoiceListViewModel.invoiceAllListApiResponse =
    //     ApiResponse.loading('Loading');
    print('filter is $filter');
    isTabVisible = false;
    await invoiceListViewModel.listAllInvoice(
        req,
        filter +
            filterDate +
            Utility.activityReportGetSubUSer +
            Utility.onlineInvoiceFilterStatus +
            searchingFilter);
    // await invoiceListViewModel.invoiceCount(req +
    //     countFilter +
    //     filterDate +
    //     Utility.activityReportGetSubUSer +
    //     Utility.onlineInvoiceFilterStatus +
    //     searchingFilter);

    setState(() {});
  }

  String getFilterStr() {
    String? req;
    String id = Utility.userId;
    int value = selectedTab;
    if (Utility.startRange == 0 && Utility.endRange == 0) {
      req = selectedTab == 0
          ? id + Utility.filterSorted
          : selectedTab == 1
              ? '$id${Utility.filterSorted}&filter[where][invoicestatusId]=3'
              : selectedTab == 2
                  ? '$id${Utility.filterSorted}&filter[where][invoicestatusId]=2'
                  : selectedTab == 3
                      ? '$id${Utility.filterSorted}&filter[where][invoicestatusId]=5'
                      : '$id${Utility.filterSorted}&filter[where][invoicestatusId]=1';
    } else {
      req = selectedTab == 0
          ? id + Utility.filterSorted
          // + filterDate
          : selectedTab == 1
              ? '$id${Utility.filterSorted}&filter[where][invoicestatusId]=3&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}$filterDate'
              : selectedTab == 2
                  ? '$id${Utility.filterSorted}&filter[where][invoicestatusId]=2&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}$filterDate'
                  : selectedTab == 3
                      ? '$id${Utility.filterSorted}&filter[where][invoicestatusId]=5&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}$filterDate'
                      : '$id${Utility.filterSorted}&filter[where][invoicestatusId]=1&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}$filterDate';
    }
    return req;
  }

  Widget tab1(
    List<InvoiceAllListResponseModel> res,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height20(),
            res.isEmpty && !invoiceListViewModel.isPaginationLoading
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text('No data found'.tr),
                  ))
                : SizedBox(
                    width: Get.width,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: res.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => InvoiceDetailScreen(
                                    invoiceId: res[index].id.toString(),
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${res[index].clientname}',
                                            style: ThemeUtils.blackBold
                                                .copyWith(
                                                    fontSize:
                                                        FontUtils.mediumSmall),
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              bottomSheet(context, res, index);
                                            },
                                            child: Icon(Icons.more_vert))
                                      ],
                                    ),
                                    height10(),
                                    Text(
                                      'No. ${res[index].invoiceno}',
                                      style: ThemeUtils.blackRegular.copyWith(
                                          fontSize: FontUtils.mediumSmall),
                                    ),
                                    height10(),
                                    Text(
                                      textDirection: TextDirection.ltr,
                                      '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(res[index].created.toString()))}',
                                      style: ThemeUtils.blackSemiBold.copyWith(
                                          fontSize: FontUtils.small,
                                          color: ColorsUtils.grey),
                                    ),
                                    height10(),
                                    Row(
                                      children: [
                                        Expanded(
                                          // flex: 1,
                                          child: Row(
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                      // color: StaticData()
                                                      //             .invoiceType[index] ==
                                                      //         'Rejected'
                                                      //     ? ColorsUtils.reds
                                                      //     : StaticData().invoiceType[index] ==
                                                      //             'Paid'
                                                      //         ? ColorsUtils.green
                                                      //         : ColorsUtils.yellow,
                                                      color: res[index]
                                                                  .invoicestatusId ==
                                                              1
                                                          ? ColorsUtils
                                                              .countBackground
                                                          : res[index].invoicestatusId ==
                                                                  2
                                                              ? ColorsUtils
                                                                  .yellow
                                                              : res[index].invoicestatusId ==
                                                                      3
                                                                  ? ColorsUtils
                                                                      .green
                                                                  : res[index].invoicestatusId ==
                                                                          4
                                                                      ? ColorsUtils
                                                                          .reds
                                                                      : ColorsUtils
                                                                          .red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15,
                                                        vertical: 3),
                                                    child: Text(
                                                      res[index].invoicestatusId ==
                                                              1
                                                          ? 'Draft'.tr
                                                          : res[index].invoicestatusId ==
                                                                  2
                                                              ? 'Unpaid'.tr
                                                              : res[index].invoicestatusId ==
                                                                      3
                                                                  ? 'Paid'.tr
                                                                  : res[index].invoicestatusId ==
                                                                          4
                                                                      ? 'Overdue'
                                                                          .tr
                                                                      : 'Rejected'
                                                                          .tr,
                                                      style: ThemeUtils
                                                          .blackSemiBold
                                                          .copyWith(
                                                              color: ColorsUtils
                                                                  .white),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Image.asset(
                                            Images.accentEye,
                                            height: 15,
                                            color:
                                                res[index].readdatetime != null
                                                    ? ColorsUtils.accent
                                                    : ColorsUtils.border,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              '${double.parse(res[index].grossamount.toString()).toStringAsFixed(2)} QAR',
                                              style: ThemeUtils.blackSemiBold
                                                  .copyWith(
                                                      color: ColorsUtils.accent,
                                                      fontSize:
                                                          FontUtils.medium),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      );

  Column centerView(InvoiceCountResponseModel invoiceCount) {
    return Column(
      children: [
        height10(),
        Text(
          textDirection: TextDirection.ltr,
          intl.DateFormat("dd MMM’yy").format(DateTime.now()),
          style: ThemeUtils.blackSemiBold
              .copyWith(fontSize: FontUtils.small, color: ColorsUtils.grey),
        ),
        height10(),
        Text(
          'Total Invoice amount'.tr,
          style: ThemeUtils.blackBold.copyWith(
            fontSize: FontUtils.mediumSmall,
          ),
        ),
        height10(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            currencyText(
              double.parse(((invoiceCount.overdueAmount)! +
                      (invoiceCount.unpaidAmount)! +
                      (invoiceCount.paidAmount)! +
                      (invoiceCount.draftAmount)!)
                  .toString()),
              ThemeUtils.blackBold.copyWith(
                  fontSize: FontUtils.large, color: ColorsUtils.accent),
              ThemeUtils.blackBold.copyWith(
                  fontSize: FontUtils.large, color: ColorsUtils.accent),
            ),
          ],
        ),
        // Text(
        //   '${double.parse(
        //     ((invoiceCount.overdueAmount)! +
        //             (invoiceCount.unpaidAmount)! +
        //             (invoiceCount.paidAmount)! +
        //             (invoiceCount.draftAmount)!)
        //         .toString(),
        //   ).toStringAsFixed(2)} QAR',
        //   style: ThemeUtils.blackBold
        //       .copyWith(fontSize: FontUtils.large, color: ColorsUtils.accent),
        // ),
        height10(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: ColorsUtils.border, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Images.paidInvoice, height: 25, width: 25),
                        height10(),
                        Text(
                          'Paid Invoices'.tr,
                          style: ThemeUtils.blackSemiBold,
                        ),
                        height10(),
                        currencyText(
                            double.parse(
                                double.parse(invoiceCount.paidAmount.toString())
                                    .toStringAsFixed(2)),
                            ThemeUtils.blackSemiBold.copyWith(
                                color: ColorsUtils.green,
                                fontSize: FontUtils.medium),
                            ThemeUtils.blackSemiBold.copyWith(
                                color: ColorsUtils.green,
                                fontSize: FontUtils.medium))
                        // Text(
                        //   '${double.parse(invoiceCount.paidAmount.toString()).toStringAsFixed(2)}',
                        //   style: ThemeUtils.blackSemiBold.copyWith(
                        //       color: ColorsUtils.green,
                        //       fontSize: FontUtils.medium),
                        // ),
                      ],
                    ),
                  ),
                ),
                width20(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: ColorsUtils.border, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Images.unpaidInvoice,
                            height: 25, width: 25),
                        height10(),
                        Text(
                          'Unpaid Invoices'.tr,
                          style: ThemeUtils.blackSemiBold,
                        ),
                        height10(),
                        currencyText(
                            double.parse(double.parse(
                                    invoiceCount.unpaidAmount.toString())
                                .toStringAsFixed(2)),
                            ThemeUtils.blackSemiBold.copyWith(
                                color: ColorsUtils.reds,
                                fontSize: FontUtils.medium),
                            ThemeUtils.blackSemiBold.copyWith(
                                color: ColorsUtils.reds,
                                fontSize: FontUtils.medium))
                        // Text(
                        //   '${double.parse(invoiceCount.unpaidAmount.toString()).toStringAsFixed(2)}',
                        //   style: ThemeUtils.blackSemiBold.copyWith(
                        //       color: ColorsUtils.reds,
                        //       fontSize: FontUtils.medium),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            invoicesType(
                title: 'Created Invoices'.tr,
                amount: '${invoiceCount.totalCreatedInvoice}',
                color: ColorsUtils.accent),
            invoicesType(
                title: 'Paid Invoices'.tr,
                amount: invoiceCount.paid.toString(),
                color: ColorsUtils.green),
            invoicesType(
                title: 'Unpaid Invoices'.tr,
                amount: invoiceCount.unpaid.toString(),
                color: ColorsUtils.reds),
          ],
        ),
      ],
    );
  }

  Widget flotingButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: InkWell(
        onTap: () {
          showCreateInvoiceDialog(context);
          // Get.to(() => CreateProductScreen());
        },
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorsUtils.accent.withOpacity(0.5),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                )
              ],
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                stops: [
                  // 0.1,
                  0.1,
                  0.9,
                  // 0.4,
                ],
                colors: [
                  // Color(0xffF6CF4F),
                  Color(0xffECAE4E),
                  ColorsUtils.accent,
                  // Color(0xff8E1B5D),
                ],
              )),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Center(
                child: Icon(
              Icons.add,
              size: 25,
              color: ColorsUtils.white,
            )),
          ),
        ),
      ),
    );
  }

  Column invoicesType({String? amount, String? title, Color? color}) {
    return Column(
      children: [
        Text(
          amount!,
          style: ThemeUtils.blackSemiBold
              .copyWith(color: color, fontSize: FontUtils.medium),
        ),
        Text(
          title!,
          style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small),
        ),
      ],
    );
  }

  Column topView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    searchingFilter = '';
                    searchKey = '';
                    searchController.clear();
                    if (isSearch == true) {
                      invoiceListViewModel.setInit();
                      invoiceListViewModel.clearResponseLost();

                      initData();
                    }
                    isSearch == true ? isSearch = false : Get.back();
                    setState(() {});
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              width10(),
              isSearch == false
                  ? Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text('Invoices'.tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                    fontSize: FontUtils.medLarge,
                                  )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              isSearch = !isSearch;
                              setState(() {});
                            },
                            child: Image.asset(
                              Images.search,
                              height: 20,
                              width: 20,
                            ),
                          ),
                          width10(),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (value) async {
                            searchKey = value;

                            if (searchKey != '') {
                              searchingFilter = selectedType
                                      .contains('Transaction Id')
                                  ? '&filter[where][transactionId]=$searchKey'
                                  : selectedType.contains('Invoice Number')
                                      ? '&filter[where][invoiceno][like]=%25$searchKey%'
                                      : selectedType.contains('Customer Name')
                                          ? '&filter[where][clientname]=%$searchKey%'
                                          : selectedType
                                                  .contains('Customer Email Id')
                                              ? '&filter[where][emailaddress][like]=%25$searchKey%'
                                              : selectedType.contains(
                                                      'Customer Mobile Number')
                                                  ? '&filter[where][cellno][like]=%25$searchKey%'
                                                  : '';
                            }
                            setState(() {});
                            invoiceListViewModel.setInit();
                            invoiceListViewModel.clearResponseLost();
                            initData();
                          },
                          controller: searchController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0.0),
                              isDense: true,
                              prefixIcon: Image.asset(
                                Images.search,
                                scale: 3,
                              ),
                              suffixIcon: searchController.text.isEmpty
                                  ? const SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        searchController.clear();
                                        searchKey = '';
                                        searchingFilter = '';

                                        setState(() {});

                                        invoiceListViewModel.setInit();
                                        invoiceListViewModel
                                            .clearResponseLost();

                                        initData();
                                      },
                                      child: const Icon(
                                        Icons.cancel_rounded,
                                        color: ColorsUtils.border,
                                        size: 25,
                                      ),
                                    ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: ColorsUtils.border, width: 1)),
                              hintText: 'ex. ${selectedType.first}',
                              hintStyle: ThemeUtils.blackRegular.copyWith(
                                  color: ColorsUtils.grey,
                                  fontSize: FontUtils.small)),
                        ),
                      ),
                    ),
              isSearch == false ? const SizedBox() : width10(),
              InkWell(
                  onTap: () async {
                    await Get.to(() => const FilterScreen());
                    //await Get.to(() => InvoiceReportFilterScreen());
                    setState(() {});
                    invoiceListViewModel.setInit();
                    invoiceListViewModel.clearResponseLost();
                    initData();
                  },
                  child: Image.asset(
                    Images.filter,
                    color: (Utility.startRange != 0 || Utility.endRange != 0) ||
                            Utility.onlineInvoiceFilterStatus != '' ||
                            Utility.activityReportGetSubUSer != ''
                        ? ColorsUtils.accent
                        : ColorsUtils.black,
                    height: 20,
                    width: 20,
                  )),
            ],
          ),
        ),
        //isSearch == true ? SizedBox() : height20(),
        isSearch == false
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: customVerySmallBoldText(
                          title: 'Search for :'.tr,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          runSpacing: 10,
                          direction: Axis.horizontal,
                          children: List.generate(
                              StaticData().invoiceSearchFilter.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: InkWell(
                                      onTap: () async {
                                        selectedType.clear();
                                        searchKey = '';
                                        searchController.clear();
                                        selectedType.add(StaticData()
                                            .invoiceSearchFilter[index]);
                                        invoiceListViewModel.setInit();
                                        invoiceListViewModel
                                            .clearResponseLost();

                                        initData();
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: ColorsUtils.border,
                                                width: 1),
                                            color: selectedType.contains(
                                                    StaticData()
                                                            .invoiceSearchFilter[
                                                        index])
                                                ? ColorsUtils.primary
                                                : ColorsUtils.white),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            StaticData()
                                                .invoiceSearchFilter[index]
                                                .tr,
                                            style: ThemeUtils.blackBold.copyWith(
                                                fontSize: FontUtils.verySmall,
                                                color: selectedType.contains(
                                                        StaticData()
                                                                .invoiceSearchFilter[
                                                            index])
                                                    ? ColorsUtils.white
                                                    : ColorsUtils
                                                        .tabUnselectLabel),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        height25(),
        timeZone(),
        height10(),
        Container(
          height: 1,
          width: Get.width,
          decoration: BoxDecoration(color: ColorsUtils.border),
        )
        // const Divider(),
      ],
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

  Widget timeZone() {
    return SizedBox(
      height: 25,
      width: Get.width,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().timeZone.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 && Get.locale!.languageCode == 'en'
                ? const EdgeInsets.only(left: 20, right: 5)
                : index == StaticData().timeZone.length - 1 &&
                        Get.locale!.languageCode == 'en'
                    ? const EdgeInsets.only(right: 20, left: 5)
                    : const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedTimeZone.clear();
                selectedTimeZone.add(StaticData().timeZone[index]);
                print('time is $selectedTimeZone');
                if (selectedTimeZone.contains('Custom')) {
                  // _selectDate(context);
                  await datePicker(context);
                  setState(() {});
                  print('dates $startDate$endDate');

                  if (startDate != '' && endDate != '') {
                    filterDate = '["$startDate", "$endDate"]';
                    updateApiCall();
                  }
                } else {
                  startDate = '';
                  endDate = '';
                  _range = '';
                  print('time is $selectedTimeZone');

                  filterDate = selectedTimeZone.first == 'All'
                      ? ""
                      : selectedTimeZone.first.toLowerCase();
                  updateApiCall();
                }
                print('$selectedTimeZone');
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        selectedTimeZone.contains(StaticData().timeZone[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.tabUnselect),
                child: Center(
                  child: Text(
                    index == 6
                        ? _range == ''
                            ? StaticData().timeZone[index].tr
                            : _range
                        : StaticData().timeZone[index].tr,
                    style: ThemeUtils.maroonBold.copyWith(
                        fontSize: FontUtils.verySmall,
                        color: selectedTimeZone
                                .contains(StaticData().timeZone[index])
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

  void getPosition() {
    try {
      RenderBox? box = _key.currentContext!.findRenderObject() as RenderBox?;
      Offset position =
          box!.localToGlobal(Offset.zero); //this is global position
      double y = position.dy;
      tabWidgetPosition = y;
      setState(() {});
    } on Exception catch (e) {
      print('error $e');
      // TODO
    }
  }

  initData() async {
    String filter = '';
    String countFilter = '';

    if (startDate != '' && endDate != '') {
      filter = 'custom&filter[where][between]=';
      countFilter = '&[where][datefilter]=custom&[where][between]=';
    } else {
      filter = '';
      countFilter =
          selectedTimeZone.first == 'All' ? '' : '&[where][datefilter]=';
    }
    String id = await encryptedSharedPreferences.getString('id');
    invoiceListViewModel.setInit();
    invoiceListViewModel.clearResponseLost();
    scrollData(filter);
    if (Utility.startRange == 0 && Utility.endRange == 0) {
      await invoiceListViewModel.invoiceCount(id +
          countFilter +
          filterDate +
          Utility.activityReportGetSubUSer +
          Utility.onlineInvoiceFilterStatus +
          searchingFilter);
      await invoiceListViewModel.listAllInvoice(
          id +
              Utility.filterSorted +
              Utility.activityReportGetSubUSer +
              Utility.onlineInvoiceFilterStatus +
              searchingFilter,
          filter + filterDate);
    } else {
      // ignore: prefer_interpolation_to_compose_strings
      await invoiceListViewModel.invoiceCount(id +
          countFilter +
          filterDate +
          Utility.activityReportGetSubUSer +
          Utility.onlineInvoiceFilterStatus +
          searchingFilter +
          '&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}');
      // ignore: prefer_interpolation_to_compose_strings
      await invoiceListViewModel.listAllInvoice(
          id +
              Utility.filterSorted +
              Utility.activityReportGetSubUSer +
              Utility.onlineInvoiceFilterStatus +
              searchingFilter +
              '&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}',
          filter + filterDate);
    }
    if (invoiceListViewModel.invoiceCountApiResponse.status == Status.ERROR) {
      const SessionExpire();
    }
    Future.delayed(Duration(seconds: 1), () {
      getPosition();
    });
  }

  Future<void> bottomSheet(BuildContext context,
      List<InvoiceAllListResponseModel> response, int index) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 70,
                      height: 5,
                      child: Divider(color: ColorsUtils.border, thickness: 4),
                    ),
                  ),
                  height20(),

                  ///edit
                  response[index].invoicestatusId == 3 ||
                          response[index].invoicestatusId == 5 ||
                          response[index].invoicestatusId == 4
                      ? SizedBox()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();

                                // if (Utility.isFastInvoice == true) {
                                //   print('edit screen');
                                //   Map<String, dynamic> invoiceDetail = {
                                //     'grossAmount': response.grossamount ?? "",
                                //     'custName': response.clientname ?? "",
                                //     'mobNo': response.cellno ?? "",
                                //     'description': response.remarks ?? "",
                                //     'type': response.invoicestatusId ?? ""
                                //   };
                                //   print('statusid::${Utility.invoiceStatusId}');
                                //
                                //   Get.to(() => FastInvoiceScreen(
                                //         invoiceDetail: invoiceDetail,
                                //         transId: response.id.toString(),
                                //       ));
                                // } else {
                                ///
                                if (response[index].invoiceDetails!.isEmpty ||
                                    response[index].invoiceDetails == null) {
                                  Map<String, dynamic> invoiceDetail = {
                                    'grossAmount':
                                        response[index].grossamount.toString(),
                                    'custName':
                                        response[index].clientname ?? "",
                                    'mobNo': response[index].cellno ?? "",
                                    'type':
                                        response[index].invoicestatusId ?? "",
                                    'description':
                                        response[index].remarks ?? "",
                                  };
                                  Get.to(() => FastInvoiceScreen(
                                        invoiceDetail: invoiceDetail,
                                        transId: response[index].id.toString(),
                                      ));

                                  // Map<String, dynamic> invoiceDetail = {
                                  //   'grossAmount':
                                  //       response[index].grossamount.toString(),
                                  //   'custName':
                                  //       response[index].clientname ?? "",
                                  //   'type':
                                  //       response[index].invoicestatusId ?? "",
                                  //   'mobNo': response[index].cellno ?? "",
                                  //   'description':
                                  //       response[index].remarks ?? "",
                                  // };
                                  // Get.to(() => FastInvoiceScreen(
                                  //       invoiceDetail: invoiceDetail,
                                  //       transId: response[index].id.toString(),
                                  //     ));
                                } else {
                                  Map<String, dynamic> invoiceDetail = {
                                    'grossAmount':
                                        response[index].grossamount ?? "",
                                    'custName':
                                        response[index].clientname ?? "",
                                    'mobNo': response[index].cellno ?? "",
                                    'description':
                                        response[index].remarks ?? "",
                                    'itemList':
                                        response[index].invoiceDetails ?? "",
                                    'read': response[index].readreceipt ?? "",
                                    'type':
                                        response[index].invoicestatusId ?? ""
                                  };
                                  // }
                                  Utility.selectedProductData.clear();
                                  Get.to(() => DetailedInvoiceScreen(
                                        invoiceDetail: invoiceDetail,
                                        transId: response[index].id.toString(),
                                      ));
                                }
                              },
                              child: commonRowDataBottomSheet(
                                  img: Images.edit, title: 'Edit'.tr),
                            ),
                            dividerData(),
                          ],
                        ),

                  // Column(
                  //         children: [
                  //           InkWell(
                  //             onTap: () {
                  //               // if (Utility.isFastInvoice == true) {
                  //               //   print('edit screen');
                  //               //   Map<String, dynamic> invoiceDetail = {
                  //               //     'grossAmount':
                  //               //         response.grossamount.toString(),
                  //               //     'custName': response.clientname ?? "",
                  //               //     'mobNo': response.cellno ?? "",
                  //               //     'description': response.remarks ?? "",
                  //               //   };
                  //               //   Get.to(() => FastInvoiceScreen(
                  //               //         invoiceDetail: invoiceDetail,
                  //               //         transId: response.id.toString(),
                  //               //       ));
                  //               // } else {
                  //               ///
                  //               // if (response.invoicedetails!.isEmpty ||
                  //               //     response.invoicedetails == null) {
                  //               //   Map<String, dynamic> invoiceDetail = {
                  //               //     'grossAmount':
                  //               //         response.grossamount.toString(),
                  //               //     'custName': response.clientname ?? "",
                  //               //     'mobNo': response.cellno ?? "",
                  //               //     'description': response.remarks ?? "",
                  //               //   };
                  //               //   Get.to(() => FastInvoiceScreen(
                  //               //         invoiceDetail: invoiceDetail,
                  //               //         transId: response.id.toString(),
                  //               //       ));
                  //               // } else {
                  //               Map<String, dynamic> invoiceDetail = {
                  //                 'grossAmount': response.grossamount,
                  //                 'custName': response.clientname,
                  //                 'mobNo': response.cellno,
                  //                 'description': response.remarks,
                  //                 'itemList': response.invoicedetails,
                  //                 'read': response.readreceipt,
                  //                 'type': response.invoicestatusId
                  //               };
                  //               print('statusid::${Utility.invoiceStatusId}');
                  //
                  //               Utility.selectedProductData.clear();
                  //
                  //               Get.to(() => DetailedInvoiceScreen(
                  //                     invoiceDetail: invoiceDetail,
                  //                     transId: response.id.toString(),
                  //                   ));
                  //             },
                  //
                  //             // }
                  //             // },
                  //             child: commonRowDataBottomSheet(
                  //                 img: Images.edit, title: 'Edit'.tr),
                  //           ),
                  //           dividerData(),
                  //         ],
                  //       ),

                  ///copylink
                  response[index].invoicestatusId == 1 ||
                          response[index].invoicestatusId == 3 ||
                          response[index].invoicestatusId == 5
                      ? SizedBox()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();

                                Clipboard.setData(ClipboardData(
                                    text:
                                        'https://d.sadad.qa/${response[index].shareUrl ?? ""}'));
                                Get.snackbar(
                                    '', 'Link is Copied to clipboard!');
                              },
                              child: commonRowDataBottomSheet(
                                  img: Images.link, title: 'Copy link'.tr),
                            ),
                            response[index].invoicestatusId == 4
                                ? SizedBox()
                                : dividerData(),
                          ],
                        ),

                  ///download
                  response[index].invoicestatusId != 3
                      ? SizedBox()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await downloadFile(
                                  isEmail: false,
                                  isRadioSelected: 1,
                                  url:
                                      '${Utility.baseUrl}invoices/singleInvoicePdfExport?filter[where][language]=en&&filter[where][isDownloadZip]=false&filter[where][invoiceno]=${response[index].invoiceno}',
                                  context: context,
                                ).then((value) => Navigator.pop(context));
                              },
                              child: commonRowDataBottomSheet(
                                  img: Images.download,
                                  title: 'Download Invoice'.tr),
                            ),
                            response[index].invoicestatusId != 3
                                ? SizedBox()
                                : dividerData(),
                          ],
                        ),

                  ///share
                  response[index].invoicestatusId == 5 ||
                          response[index].invoicestatusId == 2
                      ? Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();

                                  Share.share(
                                      'https://d.sadad.qa/${response[index].shareUrl ?? ""}');
                                },
                                child: commonRowDataBottomSheet(
                                    img: Images.share, title: 'Share'.tr)),
                            dividerData(),
                          ],
                        )
                      : SizedBox(),

                  ///send notification
                  response[index].invoicestatusId == 2
                      ? Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Confirm'),
                                        content: Text(
                                            'Are you sure you want to send reminder to ${response[index].cellno}?'
                                                .tr),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text('No'.tr),
                                            onPressed: () =>
                                                Navigator.pop(context, 'Ok'.tr),
                                          ),
                                          ElevatedButton(
                                              child: Text('Yes'.tr),
                                              onPressed: () async {
                                                String token =
                                                    await encryptedSharedPreferences
                                                        .getString('token');
                                                final url = Uri.parse(
                                                  '${Utility.baseUrl}invoices/${response[index].id}/remind',
                                                );
                                                Map<String, String> header = {
                                                  'Authorization': token,
                                                  'Content-Type':
                                                      'application/json'
                                                };
                                                var result = await http.get(
                                                  url,
                                                  headers: header,
                                                );

                                                print(
                                                    'token is:$token } \n url $url  \n response is :${result.body} ');
                                                if (result.statusCode == 200) {
                                                  Get.back();
                                                  Get.snackbar('success',
                                                      'reminder send successfully!!');
                                                } else {
                                                  Get.back();
                                                  Get.snackbar('error'.tr,
                                                      '${jsonDecode(result.body)['error']['message']}');
                                                }
                                              }),
                                        ],
                                      );
                                    });
                              },
                              child: commonRowDataBottomSheet(
                                  img: Images.notification,
                                  title: 'Send notification'.tr),
                            ),
                            dividerData(),
                          ],
                        )
                      : SizedBox(),

                  ///delete
                  response[index].invoicestatusId == 5 ||
                          response[index].invoicestatusId == 1 ||
                          response[index].invoicestatusId == 2
                      ? InkWell(
                          onTap: () async {
                            Get.back();
                            if (connectivityViewModel.isOnline != null) {
                              if (connectivityViewModel.isOnline!) {
                                if (response[index].invoicestatusId != 3) {
                                  String token =
                                      await encryptedSharedPreferences
                                          .getString('token');
                                  final url = Uri.parse(
                                      '${Utility.baseUrl}invoices/${response[index].id}');
                                  // 'http://176.58.99.102:3001/api-v1/invoices/70146');
                                  final request = http.Request("DELETE", url);
                                  request.headers.addAll(<String, String>{
                                    'Authorization': token,
                                    'Content-Type': 'application/json'
                                  });
                                  request.body = '';
                                  final res = await request.send();
                                  if (res.statusCode == 200) {
                                    Get.snackbar(
                                        'Success'.tr, 'delete successFully'.tr);
                                    print('is is ok?????????');
                                    await updateApiCall();
                                  } else {
                                    print('error ::${res.request}');
                                    Get.back();
                                    Get.snackbar('error', '${res.request}');
                                  }
                                }
                              } else {
                                Get.snackbar('error',
                                    'Please check internet connectivity');
                              }
                            } else {
                              Get.snackbar('error',
                                  'Please check internet connectivity');
                            }
                          },
                          child: commonRowDataBottomSheet(
                              img: Images.delete, title: 'Delete'.tr))
                      : SizedBox(),
                  height25()
                ],
              ),
            );
          },
        );
      },
    );
  }

  Row commonRowDataBottomSheet({String? img, String? title}) {
    return Row(
      children: [
        Image.asset(
          img!,
          height: 25,
          color: img == Images.link
              ? ColorsUtils.black
              : img == Images.delete
                  ? ColorsUtils.reds
                  : ColorsUtils.black,
          width: 25,
        ),
        width20(),
        Text(
          title!,
          style: ThemeUtils.blackBold.copyWith(
              fontSize: FontUtils.small,
              color:
                  title == 'Delete'.tr ? ColorsUtils.reds : ColorsUtils.black),
        ),
      ],
    );
  }
}
