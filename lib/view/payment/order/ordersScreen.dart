import 'dart:convert';
import 'dart:io';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/order/searchOrderScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;
import '../../../model/apimodels/responseModel/productScreen/order/orderCountResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/order/orderListResponseModel.dart';
import '../../../model/apis/api_response.dart';
import '../../../staticData/staticData.dart';
import '../../../staticData/utility.dart';
import '../../../viewModel/Payment/product/myproductViewModel.dart';
import '../products/orderDetailScreen.dart';
import 'filterOrderScreen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  int differenceDays = 0;
  bool isTabVisible = false;
  String _range = '';
  double? tabWidgetPosition = 0.0;
  ScrollController? _scrollController;
  String startDate = '';
  String orderStatus = '';
  late TabController tabController;
  String endDate = '';
  String token = '';
  GlobalKey _key = GlobalKey();
  bool isPageFirst = false;
  MyProductListViewModel myProductListViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  List<String> selectedTimeZone = ['All'];
  String filterDate = '';
  String filter = '';
  AnimationController? animationController;
  Animation<double>? animation;
  int selectedTab = 0;
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  String searchingFilter = '';
  String countSearchingFilter = '';
  List selectedType = ['Order Number'];
  ConnectivityViewModel connectivityViewModel = Get.find();
  OrderCountResponseModel? orderCountResponse;
  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    myProductListViewModel.setOrderInit();
    tabController = TabController(length: 3, vsync: this);
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
            body: Column(
          children: [
            ///top view
            Container(
              color: ColorsUtils.lightBg,
              child: topView(),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: tabWidgetPosition == 0.0
                    ? NeverScrollableScrollPhysics()
                    : ClampingScrollPhysics(),
                child: GetBuilder<MyProductListViewModel>(
                  builder: (controller) {
                    if (controller.orderCountApiResponse.status ==
                            Status.LOADING ||
                        controller.orderCountApiResponse.status ==
                            Status
                                .INITIAL) if (controller
                            .orderCountApiResponse.status ==
                        Status.ERROR) {
                      return const SessionExpire();
                      // return const Text('Error');
                    }
                    if (controller.orderCountApiResponse.status ==
                        Status.COMPLETE) {
                      orderCountResponse =
                          myProductListViewModel.orderCountApiResponse.data;
                    }
                    return orderCountResponse == null
                        ? SizedBox()
                        : Column(
                            children: [
                              dividerData(),
                              height10(),
                              SizedBox(
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    commonOrderCount(
                                        color: ColorsUtils.accent,
                                        amount:
                                            '${orderCountResponse!.totalOrders!.count ?? ""}',
                                        title: 'Total Orders Received'.tr),
                                    commonOrderCount(
                                        color: ColorsUtils.green,
                                        amount:
                                            '${orderCountResponse!.deliveredOrders!.count ?? ""}',
                                        title: 'Orders Delivered'.tr),
                                    commonOrderCount(
                                        color: ColorsUtils.yellow,
                                        amount:
                                            '${orderCountResponse!.pendingOrders!.count ?? ""}',
                                        title: 'Pending to Deliver'.tr)
                                  ],
                                ),
                              ),
                              height25(),
                              GetBuilder<MyProductListViewModel>(
                                builder: (controller) {
                                  if (controller.orderListApiResponse.status ==
                                          Status.LOADING ||
                                      controller.orderListApiResponse.status ==
                                          Status.INITIAL) {
                                    return const Center(child: Loader());
                                  }

                                  if (controller.orderListApiResponse.status ==
                                      Status.ERROR) {
                                    return const SessionExpire();
                                    // return const Text('Error');
                                  }

                                  List<OrderListResponseModel>
                                      orderListResponse = myProductListViewModel
                                          .orderListApiResponse.data;

                                  return Column(
                                    children: [
                                      bodyView(orderListResponse, controller),
                                      if (controller.isPaginationLoading &&
                                          !isPageFirst)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Center(child: Loader()),
                                        ),
                                      // if (controller.isPaginationLoading && isPageFirst)
                                      //   const Padding(
                                      //     padding: EdgeInsets.symmetric(vertical: 20),
                                      //     child: Center(child: Loader()),
                                      //   ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                  },
                ),
              ),
            ),
          ],
        ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                myProductListViewModel.setOrderInit();

                tabController = TabController(length: 3, vsync: this);
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
              myProductListViewModel.setOrderInit();

              tabController = TabController(length: 3, vsync: this);
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

  Widget bodyView(List<OrderListResponseModel> orderListResponse,
      MyProductListViewModel controller) {
    return Column(
      children: [
        tabBar(),
        Column(
          children: [
            ///tab data
            Container(
              color: ColorsUtils.white,
              child: Column(
                key: _key,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // height20(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Align(
                  //       alignment: Alignment.centerRight,
                  //       child: Text(
                  //           '${selectedTab == 0 ? orderCountResponse.totalOrders!.count : selectedTab == 1 ? orderCountResponse.deliveredOrders!.count : orderCountResponse.pendingOrders!.count} ${'Orders'.tr}')),
                  // ),
                  height20(),

                  ///bottomList
                  orderListResponse.isEmpty && !controller.isPaginationLoading
                      ? Center(child: Text('No data found'.tr))
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: orderListResponse.length,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => OrderDetailScreen(
                                            id: orderListResponse[index]
                                                .id
                                                .toString(),
                                          ));
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: orderListResponse[index]
                                                    .product!
                                                    .productmedia!
                                                    .isEmpty
                                                ? Container(
                                                    height: Get.height * 0.13,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Image.asset(
                                                          Images.noImage,
                                                          height: 50,
                                                          width: 50,
                                                        )),
                                                  )
                                                : Container(
                                                    height: Get.height * 0.13,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.network(
                                                        '${Constants.productContainer + orderListResponse[index].product!.productmedia!.first.name}',
                                                        headers: {
                                                          HttpHeaders
                                                                  .authorizationHeader:
                                                              token
                                                        },
                                                        fit: BoxFit.cover,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
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
                                                  ),
                                          ),
                                        ),
                                        width10(),
                                        Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${orderListResponse[index].product!.name}',
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: ThemeUtils
                                                            .blackBold
                                                            .copyWith(
                                                                fontSize:
                                                                    FontUtils
                                                                        .small),
                                                      ),
                                                    ),
                                                    orderListResponse[index]
                                                                .orderstatus!
                                                                .id ==
                                                            1
                                                        ? InkWell(
                                                            onTap: () {
                                                              markAsDelBottomSheet(
                                                                  orderListResponse[
                                                                          index]
                                                                      .id);
                                                            },
                                                            child: Icon(
                                                              Icons.more_vert,
                                                            ),
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ),
                                                height10(),
                                                Text(
                                                  'ID. ${orderListResponse[index].orderno ?? ""}',
                                                  style: ThemeUtils.blackRegular
                                                      .copyWith(
                                                          fontSize:
                                                              FontUtils.small),
                                                ),
                                                height10(),
                                                Row(
                                                  children: [
                                                    Text(
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      orderListResponse[index]
                                                                  .created ==
                                                              null
                                                          ? ''
                                                          : '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(orderListResponse[index].created))}',
                                                      // orderListResponse[
                                                      //                 index]
                                                      //             .created ==
                                                      //         null
                                                      //     ? ""
                                                      //     // ignore: prefer_interpolation_to_compose_strings
                                                      //     : (orderListResponse[index].orderstatus!.name ==
                                                      //                 'DELIVERED'
                                                      //             ? 'Delivered '
                                                      //             : 'Ordered ') +
                                                      //         // ignore: unnecessary_string_interpolations
                                                      //         '${orderListResponse[index].orderstatus!.name == 'DELIVERED' ? intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(orderListResponse[index].deliverydate)) : intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(orderListResponse[index].created))}',
                                                      style: ThemeUtils
                                                          .blackRegular
                                                          .copyWith(
                                                              color: ColorsUtils
                                                                  .grey,
                                                              fontSize:
                                                                  FontUtils
                                                                      .small),
                                                    ),
                                                    Spacer(),
                                                    Image.asset(
                                                      Images.basket,
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    width10(),
                                                    Text(
                                                      '${orderListResponse[index].quantity ?? ""}',
                                                      style: ThemeUtils
                                                          .blackSemiBold
                                                          .copyWith(
                                                              fontSize:
                                                                  FontUtils
                                                                      .small),
                                                    ),
                                                  ],
                                                ),
                                                height10(),
                                                Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: orderListResponse[
                                                                        index]
                                                                    .orderstatus!
                                                                    .id ==
                                                                1
                                                            ? ColorsUtils.yellow
                                                            : ColorsUtils.green,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 2,
                                                                horizontal: 10),
                                                        child: Text(
                                                          '${orderListResponse[index].orderstatus!.name ?? ""}',
                                                          style: ThemeUtils
                                                              .blackRegular
                                                              .copyWith(
                                                                  fontSize:
                                                                      FontUtils
                                                                          .verySmall,
                                                                  color:
                                                                      ColorsUtils
                                                                          .white),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Image.asset(
                                                        Images.invoice,
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${double.parse(orderListResponse[index].product!.price.toString()).toStringAsFixed(2) ?? ""} QAR',
                                                      style: ThemeUtils
                                                          .blackBold
                                                          .copyWith(
                                                              fontSize: FontUtils
                                                                  .mediumSmall,
                                                              color: ColorsUtils
                                                                  .accent),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Divider()
                              ],
                            );
                          },
                        ),
                ],
              ),
            ),
            if (controller.isPaginationLoading && isPageFirst)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Loader()),
              ),
          ],
        ),
      ],
    );
  }

  Column topView() {
    return Column(
      children: [
        height40(),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Row(
        //     children: [
        //       InkWell(
        //           onTap: () {
        //             Get.back();
        //           },
        //           child: const Icon(Icons.arrow_back_ios)),
        //       width20(),
        //       const Spacer(),
        //       Text('Orders'.tr,
        //           style: ThemeUtils.blackBold.copyWith(
        //             fontSize: FontUtils.medLarge,
        //           )),
        //       const Spacer(),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 20),
        //         child: InkWell(
        //             onTap: () {
        //               Get.to(() => SearchOrderScreen());
        //               setState(() {});
        //             },
        //             child: Image.asset(
        //               Images.search,
        //               height: 20,
        //               width: 20,
        //             )),
        //       ),
        //       InkWell(
        //           onTap: () async {
        //             await Get.to(() => FilterOrderScreen());
        //             initData();
        //           },
        //           child: Image.asset(
        //             Images.filter,
        //             height: 20,
        //             width: 20,
        //           )),
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    if (isSearch == true) {
                      searchController.clear();
                      searchKey = '';
                      searchingFilter = '';
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
                              child: Text('Orders'.tr,
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
                          //width10(),
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
                                      .contains('Order Number')
                                  ? '&filter[where][orderno][like]=%25$searchKey%'
                                  : selectedType.contains('Transaction Id')
                                      ? '&filter[where][transactionNumber]=$searchKey'
                                      : selectedType.contains('Product Name')
                                          ? '&filter[where][productname]=$searchKey'
                                          : selectedType.contains('Buyer Name')
                                              ? '&filter[where][buyerName]=$searchKey'
                                              : '';

                              countSearchingFilter = selectedType
                                      .contains('Order Number')
                                  ? '&where[orderno][like]=%25$searchKey%'
                                  : selectedType.contains('Transaction Id')
                                      ? '&where[transactionNumber]=$searchKey'
                                      : selectedType.contains('Product Name')
                                          ? '&where[productname]=$searchKey'
                                          : selectedType.contains('Buyer Name')
                                              ? '&where[buyerName]=$searchKey'
                                              : '';
                            } else {
                              searchingFilter = '';
                              countSearchingFilter = '';
                            }

                            setState(() {});
                            // invoiceListViewModel.setInit();
                            // invoiceListViewModel.clearResponseLost();
                            //
                            initData(isFromSearch: true);
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
                                        countSearchingFilter = '';
                                        setState(() {});
                                        // invoiceListViewModel.setInit();
                                        // invoiceListViewModel
                                        //     .clearResponseLost();
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
              //isSearch == false ? const SizedBox() : width10(),
              // InkWell(
              //     onTap: () async {
              //       await Get.to(() => FilterOrderScreen());
              //      initData();
              //     },
              //     child: Image.asset(
              //       Images.filter,
              //       color: (Utility.startRange != 0 || Utility.endRange != 0) ||
              //           Utility.onlineInvoiceFilterStatus != '' ||
              //           Utility.activityReportGetSubUSer != ''
              //           ? ColorsUtils.accent
              //           : ColorsUtils.black,
              //       height: 20,
              //       width: 20,
              //     )),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: customVerySmallBoldText(
                          title: 'Search for :'.tr,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          runSpacing: 10,
                          direction: Axis.horizontal,
                          children: List.generate(
                              StaticData().orderSearchFilter.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: InkWell(
                                      onTap: () async {
                                        selectedType.clear();
                                        searchKey = '';
                                        searchController.clear();
                                        searchingFilter = '';
                                        countSearchingFilter = '';
                                        selectedType.add(StaticData()
                                            .orderSearchFilter[index]);
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
                                                            .orderSearchFilter[
                                                        index])
                                                ? ColorsUtils.primary
                                                : ColorsUtils.white),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            StaticData()
                                                .orderSearchFilter[index]
                                                .tr,
                                            style: ThemeUtils.blackBold.copyWith(
                                                fontSize: FontUtils.verySmall,
                                                color: selectedType.contains(
                                                        StaticData()
                                                                .orderSearchFilter[
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
        height20(),
        timeZone(),
        height10(),
        if (isTabVisible)
          AnimatedBuilder(
            builder: (context, child) {
              return FadeTransition(
                opacity: animation!,
                child: tabBar(),
              );
            },
            animation: animationController!,
          ),
      ],
    );
  }

  Container tabBar() {
    return Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: ColorsUtils.accent,
        ),
        child: TabBar(
          controller: tabController,
          indicatorColor: ColorsUtils.white,
          onTap: (value) async {
            setState(() {
              selectedTab = value;
              isPageFirst = true;
              _scrollController!.animateTo(0.0,
                  duration: Duration(microseconds: 200), curve: Curves.ease);
              tabWidgetPosition = 0.0;
              // tabWidgetPosition = _scrollController!.offset;
              isTabVisible = false;
            });
            initData();
          },
          isScrollable: false,
          labelStyle:
              ThemeUtils.blackSemiBold.copyWith(color: ColorsUtils.white),
          unselectedLabelColor: ColorsUtils.white,
          labelColor: ColorsUtils.white,
          labelPadding: const EdgeInsets.all(3),
          tabs: [
            Tab(text: "All".tr),
            Tab(text: "Delivered".tr),
            Tab(text: "Pending".tr),
          ],
        ));
  }

  Container commonOrderCount({String? amount, Color? color, String? title}) {
    return Container(
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: Get.width * 0.3,
          width: Get.width * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                amount!,
                style: ThemeUtils.blackBold
                    .copyWith(fontSize: FontUtils.medLarge, color: color),
              ),
              height10(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  title!.tr,
                  textAlign: TextAlign.center,
                  style: ThemeUtils.blackRegular.copyWith(
                    fontSize: FontUtils.small,
                  ),
                ),
              ),
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
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: StaticData().timeZone.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: index == 0 && Get.locale!.languageCode == 'en'
                ? EdgeInsets.only(left: 20, right: 5)
                : index == StaticData().timeZone.length - 1 &&
                        Get.locale!.languageCode == 'en'
                    ? EdgeInsets.only(right: 20, left: 5)
                    : const EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              onTap: () async {
                selectedTimeZone.clear();
                startDate = '';
                endDate = '';
                selectedTimeZone.add(StaticData().timeZone[index]);
                if (selectedTimeZone.contains('Custom')) {
                  selectedTimeZone.clear();
                  await datePicker(context);
                  setState(() {});
                  print('dates $startDate$endDate');
                  if (startDate != '' && endDate != '') {
                    filterDate = '';
                    selectedTimeZone.add('Custom');
                    myProductListViewModel.setOrderInit();
                    initData();
                    setState(() {});
                  }
                } else {
                  print('time is $selectedTimeZone');

                  filterDate = selectedTimeZone.first == 'All'
                      ? ""
                      : '${selectedTimeZone.first.toLowerCase()}';
                  myProductListViewModel.setOrderInit();
                  initData();
                  setState(() {});
                }
                print('time is $selectedTimeZone');

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
                    StaticData().timeZone[index].tr,
                    style: ThemeUtils.maroonSemiBold.copyWith(
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

  Future<void> datePicker(BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _range = '';
          startDate = '';
          endDate = '';
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
                                  if (dateRangePickerSelectionChangedArgs.value
                                      is PickerDateRange) {
                                    _range =
                                        '${intl.DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.startDate)} -'
                                        ' ${intl.DateFormat('dd/MM/yyyy').format(dateRangePickerSelectionChangedArgs.value.endDate ?? dateRangePickerSelectionChangedArgs.value.startDate)}';
                                  }
                                  if (dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          null ||
                                      dateRangePickerSelectionChangedArgs
                                              .value.endDate ==
                                          '') {
                                    '';
                                  } else {
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
                                                'yyyy-MM-dd HH:mm:ss')
                                            .format(DateTime.parse(
                                                '${dateRangePickerSelectionChangedArgs.value.endDate}'));
                                  }

                                  setDialogState(() {});
                                },
                                selectionMode:
                                    DateRangePickerSelectionMode.range,
                                maxDate: DateTime.now(),
                                initialSelectedRange: PickerDateRange(
                                    DateTime.now()
                                        .subtract(const Duration(days: 7)),
                                    DateTime.now()),
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
                                        'SelectedDates: '.tr,
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
                                        startDate = '';
                                        endDate = '';
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

  ClipRRect placeHolderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.asset(
        Images.noImage,
        height: 30,
        width: 30,
        fit: BoxFit.cover,
      ),
    );
  }

  markAsDelBottomSheet(int? id) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                    onTap: () async {
                      connectivityViewModel.startMonitoring();

                      if (connectivityViewModel.isOnline != null) {
                        if (connectivityViewModel.isOnline!) {
                          showLoadingDialog(context: context);
                          String token = await encryptedSharedPreferences
                              .getString('token');
                          final url = Uri.parse('${Utility.baseUrl}orders/$id');
                          Map<String, String> header = {
                            'Authorization': token,
                            'Content-Type': 'application/json'
                          };
                          Map<String, dynamic>? body = {'orderstatusId': '2'};

                          var result = await http.patch(
                            url,
                            headers: header,
                            body: jsonEncode(body),
                          );
                          print(
                              'token is:$token \n req is : ${jsonEncode(body)}  \n response is :${result.body} ');
                          if (result.statusCode == 200) {
                            isTabVisible = false;

                            Get.back();

                            Get.snackbar('Success'.tr, 'delivered successfull');

                            hideLoadingDialog(context: context);
                            initData();
                          } else {
                            jsonDecode(result.body)['error']['message'] ==
                                    'Your session has expired! Please relogin.'
                                ? const SessionExpire()
                                : SizedBox();
                            hideLoadingDialog(context: context);

                            Get.snackbar('error'.tr,
                                '${jsonDecode(result.body)['error']['message']}');
                          }
                        } else {
                          Get.snackbar('error', 'Please check your connection');
                        }
                      } else {
                        Get.snackbar('error', 'Please check your connection');
                      }
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          Images.markAsDelivery,
                          height: 25,
                          width: 25,
                        ),
                        width20(),
                        customSmallMedBoldText(title: 'Mark as Delivered'),
                      ],
                    ),
                  ),
                  height30()
                ],
              ),
            );
          });
        },
        backgroundColor: ColorsUtils.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))));
  }

  void initData({bool? isFromSearch = false}) async {
    String countFilter = '';
    orderStatus = selectedTab == 0
        ? ''
        : '&filter[where][orderstatusId]=${selectedTab == 1 ? '2' : '1'}';
    if (startDate != '' && endDate != '') {
      filter =
          '&filter[where][dateFilter]=custom&filter[where][between]=["$startDate", "$endDate"]';
      countFilter =
          '&where[dateFilter]=custom&where[between]=["$startDate", "$endDate"]';
    } else {
      //orders/counts?where[vendorId]=466&where[dateFilter]=custom&where[between]=["2022-05-14 00:00:00", "2022-05-28 23:59:59"]
      filter =
          selectedTimeZone.first == 'All' ? '' : '&filter[where][dateFilter]=';
      countFilter =
          selectedTimeZone.first == 'All' ? '' : '&where[dateFilter]=';
    }
    print('filter is $filter');
    print('Utility.filterSorted is ${Utility.filterSorted}');
    Utility.filterSorted = (Utility.filterSorted == '' ||
            Utility.filterSorted == '&filter[order]=created DESC'
        ? "&filter[order]=created DESC"
        : Utility.filterSorted);
    String id = await encryptedSharedPreferences.getString('id');
    token = await encryptedSharedPreferences.getString('token');
    myProductListViewModel.clearResponseLost();
    myProductListViewModel.orderCount(
        id, countFilter + filterDate + countSearchingFilter);
    await myProductListViewModel.orderList(
      id,
      filter +
          filterDate +
          searchingFilter +
          orderStatus +
          Utility.filterSorted,
      isFromSearch: isFromSearch!,
    );
    scrollData();

    if (isPageFirst == false) {
      isPageFirst = true;
    }

    // if (myProductListViewModel.orderCountApiResponse.status == Status.ERROR) {
    //   const SessionExpire();
    //   // Center(child: const Text('error'));
    // }

    Future.delayed(Duration(seconds: 1), () {
      getPosition();
    });
  }

  void scrollData() async {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);
    orderStatus = selectedTab == 0
        ? ''
        : '&filter[where][orderstatusId]=${selectedTab == 1 ? '2' : '1'}';
    if (startDate != '' && endDate != '') {
      filter =
          '&filter[where][dateFilter]=custom&filter[where][between]=["$startDate", "$endDate"]';
    } else {
      //orders/counts?where[vendorId]=466&where[dateFilter]=custom&where[between]=["2022-05-14 00:00:00", "2022-05-28 23:59:59"]
      filter =
          selectedTimeZone.first == 'All' ? '' : '&filter[where][dateFilter]=';
    }
    print('filter after scroll $filter');
    String id = await encryptedSharedPreferences.getString('id');
    token = await encryptedSharedPreferences.getString('token');
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
                _scrollController!.offset
            // &&
            // !myProductListViewModel.isPaginationLoading
            ) {
          print("HELOOOOO1111");
          // myProductListViewModel.orderList(
          //     id , orderStatus + Utility.filterSorted+ filter + filterDate);
          myProductListViewModel.orderList(
            id,
            filter +
                filterDate +
                searchingFilter +
                orderStatus +
                Utility.filterSorted,
            isFromSearch: false,
          );
        }
      });
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
      tabWidgetPosition = y;
      setState(() {});
    } on Exception catch (e) {
      print('error $e');
      // TODO
    }
  }
}
