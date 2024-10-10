import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/eCommerceCounterResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/view/payment/order/ordersScreen.dart';
import 'package:sadad_merchat_app/view/payment/products/createProduct.dart';
import 'package:sadad_merchat_app/view/payment/reports/reportsScreen.dart';
import 'package:sadad_merchat_app/view/payment/store/StoreListScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/transactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import '../../base/constants.dart';
import '../../model/apis/api_response.dart';
import '../../staticData/utility.dart';
import '../../util/utils.dart';
import '../../viewModel/Payment/onlineTransactionViewModel.dart';
import '../../viewModel/Payment/product/myproductViewModel.dart';
import '../dashboard/invoices/detailedInvoiceScreen.dart';
import '../dashboard/invoices/fastInvoiceScreen.dart';
import '../dashboard/invoices/invoiceList.dart';
import 'products/myProductScreen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;
  double? chartWidgetPosition = 0.0;
  GlobalKey pkey = GlobalKey();
  String selectedDate = 'week';
  bool isAppBar = false;
  OnlineTransactionViewModel onlineTransactionViewModel = Get.find();
  MyProductListViewModel myProductListViewModel = Get.find();
  AnimationController? animationController;

  Animation<double>? animation;
  bool enLng = false;
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    AnalyticsService.sendAppCurrentScreen('Payment Screen');

    onlineTransactionViewModel.setInit();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _tabController?.dispose();
    animationController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            appBar: isAppBar == true
                ? appBarData()
                : const PreferredSize(
                    child: SizedBox(), preferredSize: Size(0, 0)),
            // backgroundColor: ColorsUtils.maroon70122E,
            body: GetBuilder<OnlineTransactionViewModel>(
              builder: (controller) {
                if (controller.onlineTransactionApiResponse.status ==
                        Status.LOADING ||
                    controller.eCommerceCounterApiResponse.status ==
                        Status.LOADING ||
                    controller.onlineTransactionApiResponse.status ==
                        Status.INITIAL ||
                    controller.eCommerceCounterApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }

                if (controller.onlineTransactionApiResponse.status ==
                        Status.ERROR ||
                    controller.eCommerceCounterApiResponse.status ==
                        Status.ERROR) {
                  return const SessionExpire();
                  // return Center(child: const Text('Error'));
                }
                ECommerceCounterResponseModel eCommerceCounterRes =
                    onlineTransactionViewModel.eCommerceCounterApiResponse.data;
                // OnlineTransactionResponseModel onlineTransactionResponse =
                //     onlineTransactionViewModel.onlineTransactionApiResponse.data;
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: chartWidgetPosition == 0.0
                      ? NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  ColorsUtils.maroon70122E,
                                  ColorsUtils.maroonA24964,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [0.1, 0.9])),
                        child: Column(
                          children: [
                            ///Online Payment, plus button
                            Container(
                              padding: const EdgeInsets.only(top: 50),
                              // margin:
                              //     const EdgeInsets.symmetric(vertical: 50),
                              child: Column(
                                key: pkey,
                                children: [
                                  // dividerData(),
                                  // Divider(color: ColorsUtils.border),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 9,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Online Payment".tr,
                                                style: ThemeUtils.whiteBold
                                                    .copyWith(
                                                        fontSize:
                                                            FontUtils.large),
                                              ),
                                              height10(),
                                              Text(
                                                "Invoices, Products, Subscriptions , Transaction, Order, "
                                                    .tr,
                                                overflow: TextOverflow.ellipsis,
                                                style: ThemeUtils.whiteRegular
                                                    .copyWith(
                                                        fontSize:
                                                            FontUtils.small,
                                                        color: ColorsUtils.white
                                                            .withOpacity(0.8)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: FloatingActionButton(
                                            onPressed: () {
                                              onlinePaymentBottomSheet(context);
                                            },
                                            backgroundColor:
                                                ColorsUtils.chartYellow,
                                            child: const Icon(
                                              Icons.add,
                                              color: ColorsUtils.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///Payment view, withdraw and button
                            // Container(
                            //   margin: const EdgeInsets.only(left: 24, right: 24),
                            //   padding: const EdgeInsets.all(20),
                            //   decoration: BoxDecoration(
                            //       color: ColorsUtils.white,
                            //       borderRadius: BorderRadius.circular(20)),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         "Online Payment".tr,
                            //         style: ThemeUtils.blackRegular.copyWith(
                            //             fontSize: FontUtils.small,
                            //             color:
                            //                 ColorsUtils.black.withOpacity(0.8)),
                            //       ),
                            //       const SizedBox(
                            //         height: 10,
                            //       ),
                            //       Row(
                            //         children: [
                            //           currencyText(
                            //               175918.88,
                            //               ThemeUtils.maroonBold.copyWith(
                            //                   fontSize: FontUtils.large),
                            //               ThemeUtils.maroonRegular.copyWith(
                            //                   fontSize: FontUtils.verySmall)),
                            //           const Spacer(),
                            //           InkWell(
                            //             onTap: () {
                            //               Get.to(() =>
                            //                   const WithdrawalAmountScreen());
                            //             },
                            //             child: Container(
                            //               padding: const EdgeInsets.symmetric(
                            //                   horizontal: 16, vertical: 8),
                            //               decoration: BoxDecoration(
                            //                   borderRadius:
                            //                       BorderRadius.circular(12),
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
                            //                     .copyWith(
                            //                         fontSize:
                            //                             FontUtils.verySmall),
                            //               ),
                            //             ),
                            //           )
                            //         ],
                            //       )
                            //     ],
                            //   ),
                            // ),
                            height20(),

                            ///Tab view for week, monthly and year
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                // vertical: 30
                              ),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: ColorsUtils.maroonA24964,
                                  borderRadius: BorderRadius.circular(8)),
                              child: TabBar(
                                onTap: (position) async {
                                  setState(() {
                                    _tabController!.index == 0
                                        ? selectedDate = 'week'
                                        : _tabController!.index == 1
                                            ? selectedDate = 'month'
                                            : selectedDate = 'year';
                                    print(selectedDate);
                                  });
                                  await onlineTransactionViewModel
                                      .onlineTransaction(selectedDate);
                                  await onlineTransactionViewModel
                                      .ecommerceCounter(selectedDate);
                                },
                                padding: const EdgeInsets.all(0),
                                controller: _tabController,
                                indicator: const BoxDecoration(),
                                labelStyle: ThemeUtils.maroonSemiBold,
                                labelPadding: const EdgeInsets.all(0),
                                tabs: [
                                  CustomTab(
                                      selectedBackground:
                                          _tabController!.index == 0
                                              ? ColorsUtils.white
                                              : ColorsUtils.maroonA24964,
                                      selectedLabel: _tabController!.index == 0
                                          ? ColorsUtils.tabUnselectLabel
                                          : ColorsUtils.white,
                                      title: "Week"),
                                  CustomTab(
                                      selectedBackground:
                                          _tabController!.index == 1
                                              ? ColorsUtils.white
                                              : ColorsUtils.maroonA24964,
                                      selectedLabel: _tabController!.index == 1
                                          ? ColorsUtils.tabUnselectLabel
                                          : ColorsUtils.white,
                                      title: "Month"),
                                  CustomTab(
                                      selectedBackground:
                                          _tabController!.index == 2
                                              ? ColorsUtils.white
                                              : ColorsUtils.maroonA24964,
                                      selectedLabel: _tabController!.index == 2
                                          ? ColorsUtils.tabUnselectLabel
                                          : ColorsUtils.white,
                                      title: "Year"),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: ColorsUtils.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customSmallMedSemiText(
                                              title: 'Success Rate'.tr),
                                          customLargeBoldText(
                                              color: ColorsUtils.accent,
                                              title:
                                                  '${double.parse(eCommerceCounterRes.successRate.toString()).round()} %')
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

                            ///Horizontal amount view
                            Container(
                              width: Get.width,
                              height: Get.height * 0.125,
                              child: ListView.builder(
                                // padding: EdgeInsets.only(top: 20),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: StaticData()
                                    .paymentTransactionAmountList
                                    .length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: index == 0
                                        ? EdgeInsets.only(
                                            left:
                                                Get.locale!.languageCode == 'en'
                                                    ? 20
                                                    : 5,
                                            right:
                                                Get.locale!.languageCode == 'en'
                                                    ? 5
                                                    : 20)
                                        : index ==
                                                StaticData()
                                                    .createModuleList
                                                    .length
                                            ? EdgeInsets.only(
                                                right:
                                                    Get.locale!.languageCode ==
                                                            'en'
                                                        ? 20
                                                        : 5,
                                                left:
                                                    Get.locale!.languageCode ==
                                                            'en'
                                                        ? 5
                                                        : 20)
                                            : const EdgeInsets.symmetric(
                                                horizontal: 5),
                                    child: TransactionAmount(
                                        StaticData().paymentTransactionAmountList[index]
                                            ['title'],
                                        StaticData()
                                                .paymentTransactionAmountList[index]
                                            ['icon'],
                                        index == 0
                                            ? double.parse(eCommerceCounterRes
                                                .transactions
                                                .toString())
                                            : index == 1
                                                ? double.parse(eCommerceCounterRes
                                                    .successTxnAmnt
                                                    .toString())
                                                : index == 2
                                                    ? double.parse(
                                                        eCommerceCounterRes
                                                            .refundAccepted
                                                            .toString())
                                                    : index == 3
                                                        ? double.parse(
                                                            eCommerceCounterRes
                                                                .invoiceAmount
                                                                .toString())
                                                        : index == 4
                                                            ? eCommerceCounterRes
                                                                        .payoutReceived ==
                                                                    null
                                                                ? 0.0
                                                                : double.parse(eCommerceCounterRes.payoutReceived.toString())
                                                            : index == 5
                                                                ? double.parse(eCommerceCounterRes.subscriptionAmnt.toString())
                                                                : double.parse(eCommerceCounterRes.soldProductAmnt.toString()),
                                        StaticData().paymentTransactionAmountList[index]['Color'],
                                        imgColor: StaticData().paymentTransactionAmountList[index]['Color']),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        width: Get.width,
                        child: Container(
                          width: Get.width,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  // enLng = !enLng;
                                  // Get.updateLocale(Locale(enLng ? 'ar' : 'en'));
                                  // setState(() {});
                                },
                                child: Text(
                                  "Services".tr,
                                  style: ThemeUtils.blackSemiBold
                                      .copyWith(fontSize: FontUtils.medLarge),
                                ),
                              ),
                              height20(),
                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                childAspectRatio: 158 / 139,
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                children: List.generate(
                                    StaticData().paymentServiceList.length,
                                    (index) {
                                  // String title = StaticData()
                                  //     .paymentServiceList[index]['name'];
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        color:
                                            ColorsUtils.createInvoiceContainer,
                                        border:
                                            Border.all(color: ColorsUtils.line),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: InkWell(
                                      onTap: () {
                                        Utility.startRange = 0;
                                        Utility.endRange = 0;
                                        Utility.filterSorted = '';
                                        Utility.sortBy = '';
                                        Utility.viewBy = '';
                                        Utility.productPrice = '';
                                        Utility.holdViewBy = 4;
                                        Utility.holdSortBy = 6;
                                        Utility.countViewBy = '';
                                        Utility.countSortBy = '';
                                        Utility.countProductPrice = '';
                                        Utility.holdFilterSorted = 4;
                                        Utility.holdStartRange = 0;
                                        Utility.holdEndRange = 20000;
                                        if (index == 3) {
                                          Utility.refundedFilterStatus = '';
                                          Utility.transactionFilterStatus = '';
                                          Utility.transactionFilterPaymentMethod =
                                              '';
                                          Utility.transactionFilterTransactionModes =
                                              '';
                                          Utility.transactionFilterTransactionSources =
                                              '';

                                          Utility.refundedFilterPaymentMethod =
                                              '';
                                          Utility.refundedFilterTransactionModes =
                                              '';
                                          Utility.disputeStatusFilter = '';
                                          Utility.disputeTypeFilter = '';

                                          Utility.holdRefundedFilterStatus = '';
                                          Utility.holdTransactionFilterStatus =
                                              '';
                                          Utility.holdTransactionFilterPaymentMethod =
                                              '';
                                          Utility.holdTransactionFilterTransactionModes =
                                              '';
                                          Utility.holdTransactionFilterTransactionSources =
                                              '';
                                          Utility.holdRefundedFilterPaymentMethod =
                                              '';
                                          Utility.holdRefundedFilterTransactionModes =
                                              '';
                                          Utility.holdDisputeStatusFilter = '';
                                          Utility.holdDisputeTypeFilter = '';
                                          Utility.activityReportGetSubUSer = '';

                                          Utility.activityReportHoldGetSubUSerId =
                                              '';
                                          Utility.holdOnlineInvoiceFilterStatus =
                                              '';
                                          Utility.onlineInvoiceFilterStatus =
                                              '';
                                          Utility.activityReportHoldGetSubUSer =
                                              '';
                                          Utility.activityReportHoldGetSubUSerId =
                                              '';
                                          Utility.activityReportHoldGetSubUSer =
                                              '';
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
                                        }
                                        index == 0
                                            ? Get.to(() => const InvoiceList())
                                            : index == 1
                                                ? Get.to(() =>
                                                    const MyProductScreen())
                                                : index == 4
                                                    ? Get.to(() =>
                                                        const OrderScreen())
                                                    : index == 3
                                                        ? Get.to(() =>
                                                            const TransactionScreen())
                                                        : index == 5
                                                            ? Get.to(() =>
                                                                const ReportScreen())
                                                            : index == 2
                                                                ? Get.to(() =>
                                                                    StoreListScreen())
                                                                : const SizedBox();
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${StaticData().paymentServiceList[index]['name']}"
                                                    .tr,
                                                style: ThemeUtils.blackBold
                                                    .copyWith(
                                                        fontSize:
                                                            FontUtils.medium),
                                              ),
                                              // StaticData().paymentServiceList[
                                              //                 index]
                                              //             ['notificationCount'] >
                                              //         0
                                              //     ? Container(
                                              //         padding: const EdgeInsets
                                              //                 .symmetric(
                                              //             horizontal: 5),
                                              //         decoration: BoxDecoration(
                                              //           color: ColorsUtils.red,
                                              //           borderRadius:
                                              //               BorderRadius.circular(
                                              //                   10),
                                              //         ),
                                              //         constraints:
                                              //             const BoxConstraints(
                                              //           minWidth: 16,
                                              //           minHeight: 16,
                                              //         ),
                                              //         child: Center(
                                              //           child: Text(
                                              //             StaticData()
                                              //                 .paymentServiceList[
                                              //                     index][
                                              //                     'notificationCount']
                                              //                 .toString(),
                                              //             style: const TextStyle(
                                              //                 color: Colors.white,
                                              //                 fontSize: 10,
                                              //                 fontWeight:
                                              //                     FontWeight
                                              //                         .w500),
                                              //           ),
                                              //         ),
                                              //       )
                                              //     : const SizedBox()
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "${index == 0 ? eCommerceCounterRes.invoiceCount : index == 1 ? eCommerceCounterRes.productCounts : index == 2 ? eCommerceCounterRes.storeProdCounts : index == 3 ? eCommerceCounterRes!.transactions : index == 4 ? eCommerceCounterRes!.orderCount : ''} ${index == 5 ? '' : "${index == 2 ? 'Products' : StaticData().paymentServiceList[index]['name']}".tr}",
                                            style: ThemeUtils.blackRegular
                                                .copyWith(
                                                    fontSize:
                                                        FontUtils.verySmall,
                                                    color: ColorsUtils.grey),
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Image.asset(
                                                StaticData().paymentServiceList[
                                                    index]['icon'],
                                                width: 40,
                                                height: 40,
                                              ),
                                              const Spacer(),
                                              Container(
                                                decoration: const BoxDecoration(
                                                    color: ColorsUtils.white,
                                                    shape: BoxShape.circle),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 15,
                                                      color: StaticData()
                                                              .paymentServiceList[
                                                          index]['color'],
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
                AnalyticsService.sendAppCurrentScreen('Payment Screen');

                onlineTransactionViewModel.setInit();

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
              AnalyticsService.sendAppCurrentScreen('Payment Screen');

              onlineTransactionViewModel.setInit();

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

  void onlinePaymentBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: ColorsUtils.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        builder: (context) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                height40(),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: ColorsUtils.tabUnselect,
                          child: Center(
                              child: Image.asset(
                            Images.cancel,
                            height: 12,
                            width: 12,
                          )),
                        ),
                      )),
                ),
                SizedBox(
                    height: Get.height * 0.35,
                    width: Get.width,
                    child: Image.asset(Images.onlineP)),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Choose one of our online payment services'.tr,
                    textAlign: TextAlign.center,
                    style: ThemeUtils.blackBold
                        .copyWith(fontSize: FontUtils.medLarge),
                  ),
                ),

                ///fastInvoice
                Container(
                  margin: const EdgeInsets.only(top: 32, left: 27, right: 27),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorsUtils.line)),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Utility.countryCodeNumber = '+974';
                      Utility.countryCode = 'QA';

                      Get.to(() => FastInvoiceScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: ColorsUtils.createInvoiceContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(Images.invoice),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.asset(
                                    Images.pinYellow,
                                    height: 18,
                                    width: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Quick Invoice".tr,
                                  style: ThemeUtils.blackSemiBold.copyWith(
                                      fontSize: FontUtils.mediumSmall),
                                  maxLines: 2,
                                ),
                                Text(
                                  "Create fast invoice with full amount only"
                                      .tr,
                                  style: ThemeUtils.blackRegular
                                      .copyWith(fontSize: FontUtils.verySmall),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Image.asset(
                            Images.addRoundMaroon,
                            width: 20,
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                ///detailedInvoice
                Container(
                  margin: const EdgeInsets.only(
                    top: 15,
                    left: 27,
                    right: 27,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorsUtils.line)),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      // Utility.mobNo = '';
                      Utility.custNo = '';
                      Utility.description = '';
                      Utility.countryCode = 'QA';
                      Utility.countryCodeNumber = '+974';
                      Utility.isNotify = false;
                      Utility.selectedProductData = [];
                      Utility.isDescription = false;
                      Get.to(() => DetailedInvoiceScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: ColorsUtils.createInvoiceContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(Images.invoice),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Detailed Invoice".tr,
                                  style: ThemeUtils.blackSemiBold.copyWith(
                                      fontSize: FontUtils.mediumSmall),
                                  maxLines: 2,
                                ),
                                Text(
                                  "Create detailed Invoice white product & services"
                                      .tr,
                                  style: ThemeUtils.blackRegular
                                      .copyWith(fontSize: FontUtils.verySmall),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Image.asset(
                            Images.addRoundMaroon,
                            width: 20,
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                ///product
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 27, right: 27),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorsUtils.line)),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                      Get.to(() => CreateProductScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                                color: ColorsUtils.createInvoiceContainer,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child:
                                  Image.asset(Images.productsMenu, height: 20),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product'.tr,
                                  style: ThemeUtils.blackSemiBold.copyWith(
                                      fontSize: FontUtils.mediumSmall),
                                  maxLines: 2,
                                ),
                                Text(
                                  "Create Product with unlimited featured".tr,
                                  style: ThemeUtils.blackRegular
                                      .copyWith(fontSize: FontUtils.verySmall),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const CircleAvatar(
                            radius: 10,
                            backgroundColor: ColorsUtils.green,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              size: 15,
                              color: ColorsUtils.white,
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                ///subscription
                // Container(
                //   margin: const EdgeInsets.only(top: 15, left: 27, right: 27),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(16),
                //       border: Border.all(color: ColorsUtils.line)),
                //   child: InkWell(
                //     onTap: () {},
                //     child: Padding(
                //       padding: const EdgeInsets.all(14),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Container(
                //             width: 38,
                //             height: 38,
                //             decoration: BoxDecoration(
                //                 color: ColorsUtils.createInvoiceContainer,
                //                 borderRadius: BorderRadius.circular(12)),
                //             child: Center(
                //               child: Image.asset(Images.subscriptionMenu,
                //                   height: 20),
                //             ),
                //           ),
                //           const SizedBox(
                //             width: 16,
                //           ),
                //           Expanded(
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text(
                //                   'Subscription',
                //                   style: ThemeUtils.blackSemiBold.copyWith(
                //                       fontSize: FontUtils.mediumSmall),
                //                   maxLines: 2,
                //                 ),
                //                 Text(
                //                   "Create Subscription with multi period",
                //                   style: ThemeUtils.blackRegular
                //                       .copyWith(fontSize: FontUtils.verySmall),
                //                   maxLines: 2,
                //                 ),
                //               ],
                //             ),
                //           ),
                //           const SizedBox(
                //             width: 16,
                //           ),
                //           const CircleAvatar(
                //             radius: 10,
                //             backgroundColor: ColorsUtils.yellow,
                //             child: Center(
                //                 child: Icon(
                //               Icons.add,
                //               size: 15,
                //               color: ColorsUtils.white,
                //             )),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                height30(),
              ],
            ),
          );
        });
  }

  PreferredSize appBarData() {
    return PreferredSize(
      preferredSize: Size(Get.width, 60),
      child: Container(
        color: ColorsUtils.maroon70122E,
        child: Padding(
            padding:
                const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
            child: AnimatedBuilder(
              builder: (context, child) {
                return FadeTransition(
                  opacity: animation!,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Online Payment".tr,
                          style: ThemeUtils.whiteSemiBold
                              .copyWith(fontSize: FontUtils.medium),
                        ),
                        InkWell(
                          onTap: () {
                            onlinePaymentBottomSheet(context);
                          },
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: ColorsUtils.white,
                          ),
                        )
                      ]),
                );
              },
              animation: animationController!,
            )),
      ),
    );
  }

  void getPosition() {
    try {
      if (pkey.currentContext == null) {
        return;
      }
      RenderBox? box = pkey.currentContext!.findRenderObject() as RenderBox?;
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

  void initData() async {
    scrollData();

    await onlineTransactionViewModel.onlineTransaction(selectedDate);
    await onlineTransactionViewModel.ecommerceCounter(selectedDate);

    ///ANIMATION
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(seconds: 1), () {
        getPosition();
      });
    });
    _tabController = TabController(length: 3, vsync: this);
  }

  void scrollData() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.pixels >= (chartWidgetPosition!)) {
          if (!isAppBar) {
            setState(() {
              isAppBar = true;
              animationController!.forward();
            });
          }
        } else {
          if (isAppBar) {
            setState(() {
              isAppBar = false;
              animationController!.reverse();
            });
          }
        }
      });
  }
}

// class TransactionAmount extends StatelessWidget {
//   final String title;
//   final String img;
//   final double amount;
//   final Color color;
//   final Color? imgColor;
//
//   const TransactionAmount(this.title, this.img, this.amount, this.color,
//       {Key? key, this.imgColor})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             color: ColorsUtils.white, borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   SizedBox(
//                     width: Get.width * 0.25,
//                     child: Text(
//                       title.tr,
//                       style: ThemeUtils.blackSemiBold
//                           .copyWith(fontSize: FontUtils.small),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   Image.asset(
//                     img,
//                     color: imgColor,
//                     width: 24,
//                     height: 24,
//                   ),
//                 ],
//               ),
//               currencyText(
//                   amount,
//                   ThemeUtils.blackSemiBold
//                       .copyWith(fontSize: FontUtils.mediumSmall, color: color),
//                   ThemeUtils.blackRegular
//                       .copyWith(fontSize: FontUtils.verySmall, color: color))
//             ],
//           ),
//         ));
//   }
// }
