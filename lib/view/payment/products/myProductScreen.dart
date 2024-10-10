// ignore_for_file: iterable_contains_unrelated_type, prefer_const_constructors

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/store/showStoreRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/product/myproductListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/productCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/products/filterProductScreen.dart';
import 'package:sadad_merchat_app/view/payment/products/searchProductScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/Payment/product/myproductViewModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../util/downloadFile.dart';
import 'createProduct.dart';
import 'package:intl/intl.dart' as intl;
import 'productDetail.dart';
import 'package:http/http.dart' as http;

class MyProductScreen extends StatefulWidget {
  const MyProductScreen({Key? key}) : super(key: key);

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  bool isSelect = false;
  bool isPageFirst = false;
  int differenceDays = 0;
  bool isAllSelect = false;
  List<int> selectedList = [];
  int isRadioSelected = 0;
  List<String> shareUrlList = [];
  String token = '';
  String email = '';
  bool sendEmail = false;
  TextEditingController search = TextEditingController();
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  bool isShowEStore = false;
  String searchingFilter = '';
  List<String> selectedTimeZone = ['All'];
  String startDate = '';
  String endDate = '';
  String _range = '';
  String filterDate = '';
  String filter = '';
  // Dio dio = Dio();
  ///
  // late dio.Response response;
  MyProductListViewModel myProductListViewModel = Get.find();
  ProductCountResponseModel? productCountRes;

  ShowStoreRequestModel showEStoreReq = ShowStoreRequestModel();
  DisplayPanelProductRequestModel displayProduct =
      DisplayPanelProductRequestModel();

  ScrollController? _scrollController;
  ConnectivityViewModel connectivityViewModel = Get.find();

  List<MyProductListResponseModel>? myProductListResponse;
  @override
  void initState() {
    Utility.activityReportGetSubUSer = '';
    Utility.activityReportHoldGetSubUSerId = '';
    Utility.activityReportHoldGetSubUSer = '';
    connectivityViewModel.startMonitoring();
    myProductListViewModel.setProductInit();
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
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            bottomNavigationBar: bottomNavigationBar(),
            floatingActionButton: flotingButton(),
            backgroundColor: ColorsUtils.lightBg,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      height60(),
                      isSelect == true
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  isSelect = false;
                                  isAllSelect = false;
                                  selectedList.clear();
                                  setState(() {});
                                },
                                child: Text(
                                  'Cancel'.tr,
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.small,
                                      color: ColorsUtils.red),
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      if (isSearch == true) {
                                        searchController.clear();
                                        searchKey = '';
                                        searchingFilter = '';
                                        myProductListViewModel.setProductInit();
                                        myProductListViewModel
                                            .clearResponseLost();
                                        initData();
                                      }
                                      isSearch == true
                                          ? isSearch = false
                                          : Get.back();
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.arrow_back_ios)),
                                width10(),
                                isSearch == false
                                    ? Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text('My Products'.tr,
                                                    style: ThemeUtils.blackBold
                                                        .copyWith(
                                                      fontSize:
                                                          FontUtils.medLarge,
                                                    )),
                                              ),
                                            ),
                                            //const Spacer(),
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
                                                searchingFilter = '$searchKey';
                                              }
                                              setState(() {});
                                              myProductListViewModel
                                                  .setProductInit();
                                              myProductListViewModel
                                                  .clearProductListResponse();
                                              myProductListViewModel
                                                  .startPosition = 0;
                                              print(
                                                  "myProductListViewModel.startPosition == ${myProductListViewModel.startPosition}");
                                              initData(isFromSearch: true);

                                              // Future.delayed(
                                              //     Duration(seconds: 2), () {
                                              //
                                              // });
                                            },
                                            controller: searchController,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.all(0.0),
                                                isDense: true,
                                                prefixIcon: Image.asset(
                                                  Images.search,
                                                  scale: 3,
                                                ),
                                                suffixIcon: searchController
                                                        .text.isEmpty
                                                    ? const SizedBox()
                                                    : InkWell(
                                                        onTap: () {
                                                          searchController
                                                              .clear();
                                                          searchKey = '';
                                                          searchingFilter = '';

                                                          setState(() {});

                                                          myProductListViewModel
                                                              .setProductInit();
                                                          myProductListViewModel
                                                              .clearResponseLost();
                                                          initData();
                                                        },
                                                        child: const Icon(
                                                          Icons.cancel_rounded,
                                                          color: ColorsUtils
                                                              .border,
                                                          size: 25,
                                                        ),
                                                      ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: ColorsUtils
                                                                .border,
                                                            width: 1)),
                                                hintText:
                                                    'ex. product name...'.tr,
                                                hintStyle: ThemeUtils
                                                    .blackRegular
                                                    .copyWith(
                                                        color: ColorsUtils.grey,
                                                        fontSize:
                                                            FontUtils.small)),
                                          ),
                                        ),
                                      ),
                                isSearch == false
                                    ? const SizedBox()
                                    : width10(),
                                InkWell(
                                    onTap: () async {
                                      await Get.to(() => FilterProductScreen());
                                      setState(() {});
                                      myProductListViewModel.setProductInit();
                                      print(
                                          "Utility.viewBy ===${Utility.viewBy}");
                                      print(
                                          "Utility.sortBy ===${Utility.sortBy}");
                                      print(
                                          "Utility.activityReportGetSubUSer ===${Utility.activityReportGetSubUSer}");
                                      print(
                                          "Utility.productPrice ===${Utility.productPrice}");
                                      initData();
                                    },
                                    child: Image.asset(
                                      Images.filter,
                                      height: 20,
                                      width: 20,
                                      color: Utility.viewBy != '' ||
                                              Utility.sortBy != '' ||
                                              Utility.activityReportGetSubUSer !=
                                                  '' ||
                                              Utility.productPrice != '' ||
                                              Utility.productViewBy != 0
                                          ? ColorsUtils.accent
                                          : ColorsUtils.black,
                                    )),
                              ],
                            ),
                    ],
                  ),
                ),
                height20(),
                timeZone(),
                Expanded(
                  child: GetBuilder<MyProductListViewModel>(
                    builder: (controller) {
                      if (controller.myProductListDataApiResponse.status ==
                              Status.LOADING ||
                          controller.productCountApiResponse.status ==
                              Status.LOADING ||
                          controller.myProductListDataApiResponse.status ==
                              Status.INITIAL) {
                        return const Center(child: Loader());
                      }

                      if (controller.myProductListDataApiResponse.status ==
                              Status.ERROR ||
                          controller.productCountApiResponse.status ==
                              Status.ERROR) {
                        return const SessionExpire();
                        //return Center(child: const Text('Error'));
                      }
                      productCountRes =
                          myProductListViewModel.productCountApiResponse.data;
                      myProductListResponse = controller.response;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///topRow
                            topView(myProductListResponse!),
                            height20(),
                            Expanded(
                                child: bottomGridView(myProductListResponse!)),
                            if (controller.isPaginationLoading && isPageFirst)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(child: Loader()),
                              )
                          ],
                        ),
                      );
                    },
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
                myProductListViewModel.setProductInit();
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
              myProductListViewModel.setProductInit();
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

  //floating button and create product screen
  Widget flotingButton() {
    return isSelect == true
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: InkWell(
              onTap: () async {
                await Get.to(() => CreateProductScreen());
                myProductListViewModel.setProductInit();
                setState(() {});
                initData();
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

  //grid view list of product
  Widget bottomGridView(List<MyProductListResponseModel> res) {
    return res.isEmpty && !myProductListViewModel.isPaginationLoading
        ? Center(
            child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text('No data found'.tr),
          ))
        : GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: res.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () async {
                  await Get.to(() => ProductDetailScreen(
                        productId: res[index].id.toString(),
                      ));
                  myProductListViewModel.setProductInit();
                  setState(() {});
                  initData();
                },
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: ColorsUtils.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: res[index].productmedia!.isEmpty
                                  ? SizedBox(
                                      width: Get.width,
                                      height: Get.height * 0.14,
                                      child: Stack(
                                        children: [
                                          Center(
                                              child: Image.asset(
                                            Images.noImage,
                                            height: 50,
                                            width: 50,
                                          )),
                                          isSelect == true
                                              ? InkWell(
                                                  onTap: () {
                                                    int id = res[index].id;
                                                    String shareUrl =
                                                        'https://d.sadad.qa/${res[index].shareUrl}';
                                                    setState(() {
                                                      if (selectedList
                                                          .contains(id)) {
                                                        selectedList.remove(id);
                                                      } else {
                                                        selectedList.add(id);
                                                        print(
                                                            'selected list is $selectedList');
                                                      }
                                                      if (shareUrlList
                                                          .contains(shareUrl)) {
                                                        shareUrlList
                                                            .remove(shareUrl);
                                                      } else {
                                                        shareUrlList
                                                            .add(shareUrl);
                                                      }
                                                    });

                                                    // res[index].productmedia
                                                    // setState(() {
                                                    //   if(selectedList.contains())
                                                    // });
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height:
                                                            Get.height * 0.14,
                                                        width: Get.width,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              color: ColorsUtils
                                                                  .white,
                                                              border: Border.all(
                                                                  color:
                                                                      ColorsUtils
                                                                          .black,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: selectedList
                                                                  .contains(
                                                                      res[index]
                                                                          .id)
                                                              ? Center(
                                                                  child: Image.asset(
                                                                      Images
                                                                          .check,
                                                                      height:
                                                                          10,
                                                                      width:
                                                                          10))
                                                              : SizedBox(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      width: Get.width,
                                      height: Get.height * 0.14,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                            child: Image.network(
                                              '${Constants.productContainer + res[index].productmedia!.last.name}',
                                              headers: {
                                                HttpHeaders.authorizationHeader:
                                                    token
                                              },
                                              fit: BoxFit.cover,
                                              width: Get.width,
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
                                          isSelect == true
                                              ? InkWell(
                                                  onTap: () {
                                                    int id = res[index].id;
                                                    String shareUrl =
                                                        'https://d.sadad.qa/${res[index].shareUrl}';
                                                    setState(() {
                                                      if (selectedList
                                                          .contains(id)) {
                                                        selectedList.remove(id);
                                                      } else {
                                                        selectedList.add(id);

                                                        print(
                                                            'selected list is $selectedList');
                                                      }
                                                      if (shareUrlList
                                                          .contains(shareUrl)) {
                                                        shareUrlList
                                                            .remove(shareUrl);
                                                      } else {
                                                        shareUrlList
                                                            .add(shareUrl);
                                                      }
                                                    });
                                                  },
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                          height:
                                                              Get.height * 0.14,
                                                          width: Get.width,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                          )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Container(
                                                          width: 20,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                              color: ColorsUtils
                                                                  .white,
                                                              border: Border.all(
                                                                  color:
                                                                      ColorsUtils
                                                                          .black,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: selectedList
                                                                  .contains(
                                                                      res[index]
                                                                          .id)
                                                              ? Center(
                                                                  child: Image.asset(
                                                                      Images
                                                                          .check,
                                                                      height:
                                                                          10,
                                                                      width:
                                                                          10))
                                                              : SizedBox(),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    child: Text(
                                      res[index].name ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: ThemeUtils.blackBold.copyWith(
                                          fontSize: FontUtils.verySmall),
                                    ),
                                  ),
                                  height10(),
                                  Text(
                                    '${double.parse(res[index].price.toString()).toStringAsFixed(2)} QAR',
                                    style: ThemeUtils.blackBold.copyWith(
                                        fontSize: FontUtils.mediumSmall,
                                        color: ColorsUtils.accent),
                                  ),
                                  height10(),
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        Images.basket,
                                        height: 20,
                                        width: 20,
                                      ),
                                      width10(),
                                      Text(
                                        '${res[index].totalavailablequantity == 0 ? '∞' : res[index].totalavailablequantity}',
                                        style: ThemeUtils.blackBold.copyWith(
                                          fontSize: FontUtils.small,
                                        ),
                                      ),
                                      Spacer(),
                                      Image.asset(
                                        Images.storesMenu,
                                        height: 20,
                                        width: 20,
                                      ),
                                      width30(),
                                      Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              color: ColorsUtils.lightPink),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                                child: Image.asset(
                              Images.productShare,
                              width: 20,
                              height: 20,
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
  }

  //top view  apart from grid view
  Column topView(List<MyProductListResponseModel> res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///if select option start search and filter option disable and cancel visible

        // Row(
        //         children: [
        //           InkWell(
        //               onTap: () {
        //                 Get.back();
        //               },
        //               child: const Icon(Icons.arrow_back_ios)),
        //           width20(),
        //           const Spacer(),
        //           Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 20),
        //             child: InkWell(
        //                 onTap: () {
        //                   Get.to(() => SearchProductScreen());
        //                 },
        //                 child: Image.asset(
        //                   Images.search,
        //                   height: 20,
        //                   width: 20,
        //                 )),
        //           ),
        //           InkWell(
        //               onTap: () async {
        //                 await Get.to(() => FilterProductScreen());
        //                 myProductListViewModel.setProductInit();
        //
        //                 initData();
        //               },
        //               child: Image.asset(
        //                 Images.filter,
        //                 height: 20,
        //                 width: 20,
        //                 color: Utility.viewBy != '' ||
        //                         Utility.sortBy != '' ||
        //                         Utility.productPrice != ''
        //                     ? ColorsUtils.accent
        //                     : ColorsUtils.black,
        //               )),
        //         ],
        //       ),
        height20(),

        ///Select row and how much product is selected my product while not selected
        isSelect == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          isAllSelect = !isAllSelect;
                          if (isAllSelect) {
                            ///delete
                            final list = res.map((e) => e.id as int).toList();
                            selectedList = list;
                            print('list is $selectedList');

                            ///share url
                            final shareList = res
                                .map((e) => 'https://d.sadad.qa/${e.shareUrl}')
                                .toList();
                            shareUrlList = shareList;
                          } else {
                            shareUrlList.clear();
                            selectedList.clear();
                          }
                          print('SELECTED LIST ID :$selectedList');
                          print('SELECTED URL :$shareUrlList');
                          setState(() {});
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorsUtils.black, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: isAllSelect == true
                              ? Center(
                                  child: Image.asset(Images.check,
                                      height: 10, width: 10))
                              : SizedBox(),
                        ),
                      ),
                      width20(),
                      Text(
                        'Select all'.tr,
                        style: ThemeUtils.blackBold
                            .copyWith(fontSize: FontUtils.small),
                      ),
                    ],
                  ),
                  height10(),
                  Text(
                    '${selectedList.length} / ${res.length} ${'Products'.tr}',
                    style: ThemeUtils.blackSemiBold
                        .copyWith(fontSize: FontUtils.verySmall),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      productCountRes != null
                          ? Text(
                              '${productCountRes!.count ?? '0'} ${'Products'.tr}',
                              style: ThemeUtils.blackSemiBold
                                  .copyWith(fontSize: FontUtils.verySmall),
                            )
                          : SizedBox(),
                      // Text(
                      //   'My Products'.tr,
                      //   style: ThemeUtils.blackBold
                      //       .copyWith(fontSize: FontUtils.medium),
                      // ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          isSelect = true;
                          setState(() {});
                        },
                        child: Text(
                          'Select'.tr,
                          style: ThemeUtils.blackBold
                              .copyWith(fontSize: FontUtils.small),
                        ),
                      ),
                      width20(),
                      InkWell(
                          onTap: () {
                            bottomSheet();
                          },
                          child: const Icon(Icons.more_vert)),
                    ],
                  ),
                  //height10(),
                ],
              ),
      ],
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

  //only export bottom sheet
  Future<dynamic> bottomSheet() {
    return Get.bottomSheet(
        Column(
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  exportBottomSheet();
                },
                child: Row(
                  children: [
                    Image.asset(
                      Images.export,
                      height: 20,
                      width: 20,
                    ),
                    width20(),
                    Text(
                      'Export'.tr,
                      style: ThemeUtils.blackBold
                          .copyWith(fontSize: FontUtils.small),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        backgroundColor: ColorsUtils.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))));
  }

  //init data
  initData({bool? isFromSearch = false}) async {
    String countFilter = '';
    if (startDate != '' && endDate != '') {
      filter =
          '&filter[date]=custom&filter[between]=["$startDate", "$endDate"]';
      countFilter =
          //'&where[dateFilter]=custom&where[between]=["$startDate", "$endDate"]';
          ',"date" : "custom","between":["$startDate","$endDate"]';
    } else {
      //orders/counts?where[vendorId]=466&where[dateFilter]=custom&where[between]=["2022-05-14 00:00:00", "2022-05-28 23:59:59"]
      filter = selectedTimeZone.first == 'All' ? '' : '&filter[date]=';
      countFilter = selectedTimeZone.first == 'All'
          ? ''
          : ',"date" : "${selectedTimeZone.first.toLowerCase()}"';
    }
    Utility.filterSorted = '&filter[order]=created DESC';
    String id = await encryptedSharedPreferences.getString('id');
    email = await encryptedSharedPreferences.getString('email');
    token = await encryptedSharedPreferences.getString('token');
    myProductListViewModel.clearResponseLost();
    if (Utility.sortBy != '') {
      Utility.filterSorted = Utility.sortBy;
    }
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !myProductListViewModel.isPaginationLoading) {
          myProductListViewModel.myProductListData(
              id +
                  Utility.filterSorted +
                  filter +
                  filterDate +
                  Utility.viewBy +
                  (searchKey == '' || searchKey.isEmpty
                      ? ''
                      : '&filter[where][name][like]=%25$searchKey%') +
                  Utility.productPrice +
                  (Utility.activityReportGetSubUSer == '' ||
                          Utility.activityReportGetSubUSer.isEmpty ||
                          Utility.activityReportGetSubUSer == null
                      ? ''
                      : '&filter[where][createdby]=${Utility.activityReportGetSubUSer}'),
              isFromSearch: false);

          print('is page first $isPageFirst');
        }
      });
    print("activityReportGetSubUSer == $searchingFilter");
    await myProductListViewModel.myProductListData(
      isFromSearch: isFromSearch,
      id,
      filter: (searchKey == '' || searchKey.isEmpty
              ? ''
              : '&filter[where][name][like]=%25$searchKey%') +
          Utility.filterSorted +
          filter +
          filterDate +
          Utility.viewBy +
          Utility.productPrice +
          (Utility.activityReportGetSubUSer == '' ||
                  Utility.activityReportGetSubUSer.isEmpty ||
                  Utility.activityReportGetSubUSer == null
              ? ''
              : '&filter[where][createdby]=${Utility.activityReportGetSubUSer}'),
      isLoading: true,
    );
    print(
        "searchKey == '' || searchKey.isEmpty${searchKey == '' || searchKey.isEmpty ? '' : ',{"name":"$searchKey"}'}");
    await myProductListViewModel.productCount(
        id,
        Utility.countViewBy +
            Utility.countProductPrice +
            (Utility.activityReportGetSubUSer == '' ||
                    Utility.activityReportGetSubUSer.isEmpty ||
                    Utility.activityReportGetSubUSer == null
                ? ''
                : ',{"createdby" : ${Utility.activityReportGetSubUSer}}') +
            (searchKey == '' || searchKey.isEmpty
                ? ''
                : ',{"name":"$searchKey"}'),
        countFilter);
    // ',{"createdby" : ${Utility.activityReportGetSubUSer}'

    if (isPageFirst == false) {
      isPageFirst = true;
    }
    print('is page first $isPageFirst');
  }

  //bottom sheet while select delete share and more content common
  Column bottomContentWhileSelect({String? title, String? img}) {
    return Column(
      children: [
        Image.asset(
          img!,
          width: 20,
          color: ColorsUtils.black,
          height: 20,
        ),
        height5(),
        Text(
          title!.tr,
          style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small),
        )
      ],
    );
  }

  //while select bottom bar open
  RenderObjectWidget bottomNavigationBar() {
    return selectedList.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: ColorsUtils.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await deleteOnclick();
                        },
                        child: bottomContentWhileSelect(
                            img: Images.delete, title: 'Delete'),
                      ),
                      InkWell(
                        onTap: () {
                          print('$shareUrlList');
                          print('data is ${shareUrlList.join("\n")}');
                          Share.share(shareUrlList.join("\n"));
                        },
                        child: bottomContentWhileSelect(
                            img: Images.productShare, title: 'Share'),
                      ),
                      InkWell(
                        onTap: () {
                          bottomSheetDetail();
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.more_horiz_outlined, size: 30),
                            height5(),
                            Text(
                              'More'.tr,
                              style: ThemeUtils.blackSemiBold
                                  .copyWith(fontSize: FontUtils.small),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        : SizedBox();
  }

  //while click on menu button open this bottom sheet
  Future<void> bottomSheetDetail() async {
    Get.bottomSheet(
        Padding(
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
                    await addStoreClickEvent();
                    Get.back();
                  },
                  child: bottomSheetText(
                      title: isShowEStore == true
                          ? 'Remove From Store'
                          : 'Add to store',
                      image: Images.addStore)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: dividerData(),
              ),
              // bottomSheetText(
              //     title: 'Add to new invoice', image: Images.addInvoice),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5),
              //   child: dividerData(),
              // ),
              InkWell(
                  onTap: () {
                    // print('data is ${shareUrlList.join(",")}');
                    Share.share(shareUrlList.join(","));
                  },
                  child: bottomSheetText(title: 'Share', image: Images.share)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: dividerData(),
              ),
              InkWell(
                  onTap: () {
                    Get.back();
                    exportBottomSheet();
                  },
                  child:
                      bottomSheetText(title: 'Export', image: Images.export)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: dividerData(),
              ),
              InkWell(
                onTap: () async {
                  await deleteOnclick();
                },
                child: bottomSheetText(title: 'Delete', image: Images.delete),
              ),
              height20(),
            ],
          ),
        ),
        backgroundColor: ColorsUtils.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))));
  }

  Future<void> addStoreClickEvent() async {
    isShowEStore = !isShowEStore;
    int show = 0;

    show = isShowEStore == true
        ? 1
        : isShowEStore == false
            ? 0
            : 0;
    setState(() {});
    int i = 0;
    displayProduct.isdisplayinpanel = show;

    for (i = 0; i < selectedList.length; i++) {
      print(selectedList[i]);
      await myProductListViewModel.showStore(
          selectedList[i].toString(), displayProduct);
      Future.delayed(Duration.zero, () {
        Get.snackbar(
            'Success',
            isShowEStore == true
                ? 'product has been added to store '
                : "product has been removed from store");
      });

      // Future.delayed(Duration(seconds: 1), () {
      //   Get.snackbar(
      //       'Success',
      //       isShowEStore == true
      //           ? 'product has been added to store '
      //           : "product has been removed from store");
      // });
    }
  }

  //after click on export open bottom sheet
  void exportBottomSheet() {
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
                  Text(
                    'Download Options'.tr,
                    style: ThemeUtils.blackBold.copyWith(
                      fontSize: FontUtils.medLarge,
                    ),
                  ),
                  height30(),
                  Text(
                    'Select Format'.tr,
                    style: ThemeUtils.blackSemiBold.copyWith(
                      fontSize: FontUtils.medium,
                    ),
                  ),
                  Column(
                    children: [
                      LabeledRadio(
                        label: 'PDF',
                        value: 1,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          setState(() {
                            isRadioSelected = newValue;
                          });
                        },
                      ),
                      LabeledRadio(
                        label: 'CSV',
                        value: 2,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          setState(() {
                            print('hi');
                            isRadioSelected = newValue;
                          });
                        },
                      ),
                      LabeledRadio(
                        label: 'XLS',
                        value: 3,
                        groupValue: isRadioSelected,
                        onChanged: (newValue) {
                          setState(() {
                            isRadioSelected = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                  height20(),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {
                  //         sendEmail = !sendEmail;
                  //         setState(() {});
                  //       },
                  //       child: Container(
                  //         width: 20,
                  //         height: 20,
                  //         decoration: BoxDecoration(
                  //             border: Border.all(
                  //                 color: ColorsUtils.black, width: 1),
                  //             borderRadius: BorderRadius.circular(5)),
                  //         child: sendEmail == true
                  //             ? Center(
                  //                 child: Image.asset(Images.check,
                  //                     height: 10, width: 10))
                  //             : SizedBox(),
                  //       ),
                  //     ),
                  //     width20(),
                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             'Send Email to'.tr,
                  //             style: ThemeUtils.blackBold.copyWith(
                  //               fontSize: FontUtils.verySmall,
                  //             ),
                  //           ),
                  //           Text(
                  //             email,
                  //             style: ThemeUtils.blackRegular.copyWith(
                  //               fontSize: FontUtils.verySmall,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // height30(),
                  InkWell(
                    onTap: () async {
                      List temp = [];
                      if (selectedList.isNotEmpty) {
                        int i;
                        for (i = 0; i <= selectedList.length - 1; i++) {
                          print('&filter[where][id][inq][$i]');
                          temp.add(
                              '&filter[where][id][inq][$i]=${selectedList[i]}');
                        }
                        // selectedList.asMap().forEach((i, e) {
                        //   temp.add('&filter[where][id][inq][$i]=$e');
                        // });

                        print(
                            'temp  is ${temp.join(',').toString().replaceAll(',', '')}');
                      }
                      if (isRadioSelected == 0) {
                        Get.snackbar('error', 'Please select Format!'.tr);
                      } else {
                        if (sendEmail == true) {
                          String token = await encryptedSharedPreferences
                              .getString('token');
                          final url = Uri.parse(selectedList.isNotEmpty
                              ? isRadioSelected == 1
                                  ? '${Utility.baseUrl}products/pdfexport?filter[include]=productmedia&filter[where][price][lte]=20000&filter[where][price][gte]=0${temp.join(',').toString().replaceAll(',', '')}&isEmail=true'
                                  : '${Utility.baseUrl}products/xlsxexport?filter[include]=productmedia&filter[where][price][lte]=20000&filter[where][price][gte]=0${temp.join(',').toString().replaceAll(',', '')}&isEmail=true'
                              : '${Utility.baseUrl}products/${isRadioSelected == 1 ? 'pdf' : isRadioSelected == 3 ? 'xlsx' : 'xlsx'}export?${isRadioSelected == 3 ? 'filter[include]=productmedia' : 'filter={}'}&isEmail=true');
                          final request = http.Request("GET", url);
                          request.headers.addAll(<String, String>{
                            'Authorization': token,
                            'Content-Type': 'application/json'
                          });
                          request.body = '';
                          final res = await request.send();
                          if (res.statusCode == 200) {
                            Get.back();
                            Get.snackbar('Success'.tr, 'send successFully'.tr);
                          } else {
                            print('error ::${res.request}');
                            Get.snackbar('error', '${res.request}');
                          }
                        } else {
                          if (selectedList.isEmpty) {
                            await downloadFile(
                              isEmail: sendEmail,
                              isRadioSelected: isRadioSelected,
                              url:
                                  '${Utility.baseUrl}products/${isRadioSelected == 1 ? 'pdf' : isRadioSelected == 3 ? 'xlsx' : 'xlsx'}export?${isRadioSelected == 3 ? 'filter[include]=productmedia' : 'filter={}'}',
                              context: context,
                            );
                          } else {
                            if (selectedList.isNotEmpty) {
                              // pdfexport
                              String url = isRadioSelected == 1
                                  ? '${Utility.baseUrl}products/pdfexport?filter[include]=productmedia&filter[where][price][lte]=20000&filter[where][price][gte]=0${temp.join(',').toString().replaceAll(',', '')}'
                                  : '${Utility.baseUrl}products/xlsxexport?filter[include]=productmedia&filter[where][price][lte]=20000&filter[where][price][gte]=0${temp.join(',').toString().replaceAll(',', '')}';
                              await downloadFile(
                                isEmail: sendEmail,
                                isRadioSelected: isRadioSelected,
                                url: url,
                                context: context,
                              );
                            }
                          }
                        }
                      }
                    },
                    child: commonButtonBox(
                        color: ColorsUtils.accent,
                        text: sendEmail == true ? 'Send' : 'DownLoad'.tr,
                        img: Images.download),
                  ),
                  height30(),
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

  //while click on menu button content
  Row bottomSheetText({String? image, String? title}) {
    return Row(
      children: [
        Image.asset(
          image!,
          height: 20,
          width: 20,
          color: ColorsUtils.black,
        ),
        width20(),
        Text(
          title!.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.small),
        )
      ],
    );
  }

  Future<void> deleteOnclick() async {
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        print('del$selectedList');
        int i = 0;
        showLoadingDialog(context: context);

        for (i = 0; i < selectedList.length; i++) {
          print(selectedList[i]);
          await deleteApiCall(id: selectedList[i].toString());
        }
        hideLoadingDialog(context: context);
        Get.snackbar('Success'.tr, 'delete successFully'.tr);
        Future.delayed(const Duration(seconds: 1), () {
          return Get.to(() => MyProductScreen());
        });
      } else {
        Get.snackbar('error', 'Please check your connection');
      }
    } else {
      Get.snackbar('error', 'Please check your connection');
    }
  }

  //delete api call
  Future<void> deleteApiCall({required String id}) async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}products/$id');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.delete(
      url,
      headers: header,
    );
    print(
        'token is:$token \n req is : ${result.request}  \n response is :${result.body} ');
    if (result.statusCode == 200) {
      myProductListViewModel.deleteProductItem(id);
    } else {
      const SessionExpire();
      // Get.snackbar('error', 'something Wrong');
    }
  }
}
