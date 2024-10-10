// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/order/orderListResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import '../../../model/apis/api_response.dart';
import '../../../viewModel/Payment/product/myproductViewModel.dart';
import 'orderDetailScreen.dart';

class ProductOrderListScreen extends StatefulWidget {
  String? productId;
  String? orderCount;
  String? name;
  ProductOrderListScreen({Key? key, this.productId, this.orderCount, this.name})
      : super(key: key);

  @override
  State<ProductOrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<ProductOrderListScreen> {
  String token = '';
  bool isPageFirst = false;
  MyProductListViewModel myProductListViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  ScrollController? _scrollController;
  List<String> selectedTimeZone = ['All'];
  String filterDate = '';
  String _range = '';
  String endDate = '';
  String startDate = '';
  int differenceDays = 0;
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    myProductListViewModel.setOrderInit();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(body: GetBuilder<MyProductListViewModel>(
          builder: (controller) {
            if (controller.orderListApiResponse.status == Status.LOADING ||
                controller.orderListApiResponse.status == Status.INITIAL) {
              return const Center(child: Loader());
            }

            if (controller.orderListApiResponse.status == Status.ERROR) {
              return const SessionExpire();
              // return const Text('Error');
            }

            List<OrderListResponseModel> orderListResponse =
                myProductListViewModel.orderListApiResponse.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height40(),

                ///top title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: ColorsUtils.black,
                          )),
                      width10(),
                      orderListResponse.isEmpty
                          ? placeHolderImage()
                          : orderListResponse[0].product!.productmedia!.isEmpty
                              ? placeHolderImage()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    '${Constants.productContainer + orderListResponse[0].product!.productmedia!.first.name}',
                                    height: 30,
                                    width: 30,
                                    headers: {
                                      HttpHeaders.authorizationHeader: token
                                    },
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
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
                      width10(),
                      Text(
                        widget.name!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: ThemeUtils.blackBold
                            .copyWith(fontSize: FontUtils.small),
                      ),
                    ],
                  ),
                ),
                height30(),

                ///bottomData
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///order Row
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Orders'.tr,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: ThemeUtils.blackBold
                                        .copyWith(fontSize: FontUtils.medium),
                                  ),
                                  Text(
                                    '${orderListResponse.length} ${'Orders'.tr}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: ThemeUtils.blackBold.copyWith(
                                        fontSize: FontUtils.verySmall),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'All',
                                        style: ThemeUtils.blackSemiBold
                                            .copyWith(
                                                fontSize:
                                                    FontUtils.mediumSmall),
                                      ),
                                      width20(),
                                      const Icon(
                                          Icons.keyboard_arrow_down_sharp)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        height20(),

                        ///bottomList
                        ListView.builder(
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
                                                    const Icon(
                                                      Icons.more_vert,
                                                    )
                                                  ],
                                                ),
                                                height10(),
                                                Text(
                                                  'No. ${orderListResponse[index].transaction!.invoicenumber ?? ""}',
                                                  style: ThemeUtils.blackRegular
                                                      .copyWith(
                                                          fontSize:
                                                              FontUtils.small),
                                                ),
                                                height10(),
                                                Row(
                                                  children: [
                                                    Text(
                                                      orderListResponse[index]
                                                                  .deliverydate ==
                                                              null
                                                          ? ""
                                                          : '${DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.parse(orderListResponse[index].deliverydate))}',
                                                      style: ThemeUtils
                                                          .blackRegular
                                                          .copyWith(
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
                        if (controller.isPaginationLoading && !isPageFirst)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(child: Loader()),
                          )
                      ],
                    ),
                  ),
                ),
                if (controller.isPaginationLoading && isPageFirst)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Loader()),
                  )
              ],
            );
          },
        ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                myProductListViewModel.setOrderInit();
                setState(() {});
                initData();
              } else {
                Get.snackbar('error', 'Please check your connection');
              }
            } else {
              Get.snackbar('error', 'Please check your connection');
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
              setState(() {});
              initData();
            } else {
              Get.snackbar('error', 'Please check your connection');
            }
          } else {
            Get.snackbar('error', 'Please check your connection');
          }
        },
      );
    }
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

  void initData() async {
    String filter = '';

    if (startDate != '' && endDate != '') {
      filter = 'custom&filter[where][between]=';
    } else {
      filter = '';
    }
    String id = await encryptedSharedPreferences.getString('id');
    token = await encryptedSharedPreferences.getString('token');
    setState(() {});
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !myProductListViewModel.isPaginationLoading) {
          myProductListViewModel.orderList(
              id +
                  '&filter[where][productId]=${widget.productId}' +
                  Utility.filterSorted,
              filter + filterDate);
        }
      });
    await myProductListViewModel.orderList(
        id +
            '&filter[where][productId]=${widget.productId}' +
            Utility.filterSorted,
        filter + filterDate);
    if (isPageFirst == false) {
      isPageFirst = true;
    }
    if (myProductListViewModel.orderCountApiResponse.status == Status.ERROR) {
      const SessionExpire();
      // Center(child: const Text('error'));
    }
  }
}
