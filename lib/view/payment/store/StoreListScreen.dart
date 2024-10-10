import 'dart:io';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/store/showStoreRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/order/orderCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/product/myproductListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/productCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/userMetaProfileResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/products/productDetail.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/Payment/product/myproductViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:share_plus/share_plus.dart';

class StoreListScreen extends StatefulWidget {
  const StoreListScreen({Key? key}) : super(key: key);

  @override
  State<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  MyProductListViewModel myProductListViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  // bool enLng = false;
  ShowStoreRequestModel showStoreReq = ShowStoreRequestModel();
  DisplayPanelProductRequestModel displayPanelProduct =
      DisplayPanelProductRequestModel();
  ScrollController? _scrollController;
  String token = '';
  bool isPageFirst = false;
  List<MyProductListResponseModel>? myProductListResponse;
  List<UserMetaProfileResponse>? userMetaProfileRes;
  ProductCountResponseModel? productCountRes;
  OrderCountResponseModel? orderCountRes;
  bool isSwitch = false;
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  ConnectivityViewModel connectivityViewModel = Get.find();
  bool tempHolder = false;
  @override
  void initState() {
    myProductListViewModel.switchClear();
    // myProductListViewModel.switchList.clear();
    connectivityViewModel.startMonitoring();

    myProductListViewModel.storeProduct.value = 'All';
    myProductListViewModel.setProductInit();
    initData(isLoading: true);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<MyProductListViewModel>(
              builder: (controller) {
                if (controller.myProductListApiResponse.status ==
                        Status.LOADING ||
                    controller.userMetaProfileApiResponse.status ==
                        Status.LOADING ||
                    controller.orderCountApiResponse.status == Status.LOADING ||
                    controller.productCountApiResponse.status ==
                        Status.LOADING ||
                    controller.userMetaProfileApiResponse.status ==
                        Status.INITIAL ||
                    controller.orderCountApiResponse.status == Status.INITIAL ||
                    controller.productCountApiResponse.status ==
                        Status.INITIAL ||
                    controller.myProductListApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }

                if (controller.myProductListApiResponse.status ==
                        Status.ERROR ||
                    controller.productCountApiResponse.status == Status.ERROR ||
                    controller.orderCountApiResponse.status == Status.ERROR ||
                    controller.userMetaProfileApiResponse.status ==
                        Status.ERROR) {
                  return const SessionExpire();
                  // return Center(child: const Text('Error'));
                }

                myProductListResponse =
                    myProductListViewModel.myProductListApiResponse.data;
                userMetaProfileRes =
                    myProductListViewModel.userMetaProfileApiResponse.data;
                productCountRes =
                    myProductListViewModel.productCountApiResponse.data;
                orderCountRes =
                    myProductListViewModel.orderCountApiResponse.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height60(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(Icons.arrow_back_ios)),
                          customMediumBoldText(
                              color: ColorsUtils.black, title: 'Store'.tr),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                    height40(),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          children: [
                            topView(),
                            bottomView(controller),
                          ],
                        ),
                      ),
                    ),
                    if (myProductListViewModel.isPaginationLoading &&
                        isPageFirst)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
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
                myProductListViewModel.storeProduct.value = 'All';
                myProductListViewModel.setProductInit();
                setState(() {});
                initData(isLoading: true);
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
              myProductListViewModel.storeProduct.value = 'All';
              myProductListViewModel.setProductInit();
              setState(() {});
              initData(isLoading: true);
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

  Widget bottomView(MyProductListViewModel controller) {
    return Container(
      width: Get.width,
      color: ColorsUtils.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customMediumLargeBoldText(
                    color: ColorsUtils.black, title: 'Store Products'.tr),
                Container(
                  decoration: BoxDecoration(
                      color: ColorsUtils.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorsUtils.border, width: 1)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        bottomSheetforStoreProduct(context);
                      },
                      child: Row(
                        children: [
                          Obx(
                            () => customSmallSemiText(
                                title: myProductListViewModel
                                    .storeProduct.value.tr,
                                color: ColorsUtils.black),
                          ),
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
            // customVerySmallSemiText(
            //     color: ColorsUtils.black,
            //     title:
            //         '${myProductListViewModel.switchList.where((element) => element == true).length} / ${productCountRes!.count ?? "0"} in store'),
            // height20(),
            myProductListResponse!.isEmpty &&
                    !myProductListViewModel.isPaginationLoading
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text('No data found'.tr),
                  ))
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: myProductListResponse!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: InkWell(
                          onTap: () async {
                            await Get.to(() => ProductDetailScreen(
                                  productId: myProductListResponse![index]
                                      .id
                                      .toString(),
                                ));
                            // initData(isLoading: true);
                          },
                          child: SizedBox(
                            width: Get.width,
                            // height: 80,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                myProductListResponse![index]
                                        .productmedia!
                                        .isEmpty
                                    ? SizedBox(
                                        height: 80,
                                        width: 50,
                                        child: Center(
                                            child: Image.asset(
                                          Images.noImage,
                                          height: 50,
                                          width: 50,
                                        )),
                                      )
                                    : Container(
                                        height: 80,
                                        width: 55,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Image.network(
                                            '${Constants.productContainer + myProductListResponse![index].productmedia!.first.name}',
                                            headers: {
                                              HttpHeaders.authorizationHeader:
                                                  token
                                            },
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                  child: Image.asset(
                                                      Images.noImage));
                                            },
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
                                      ),
                                width10(),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      customSmallBoldText(
                                          title:
                                              '${myProductListResponse![index].name ?? 'NA'}',
                                          color: ColorsUtils.black),
                                      customSmallSemiText(
                                          color: ColorsUtils.accent,
                                          title:
                                              '${myProductListResponse![index].price ?? '0'} QAR'),
                                      Row(
                                        children: [
                                          Image.asset(
                                            Images.basket,
                                            width: 20,
                                            height: 20,
                                          ),
                                          width10(),
                                          customSmallBoldText(
                                              title:
                                                  '${myProductListResponse![index].totalavailablequantity == 0 ? '∞' : myProductListResponse![index].totalavailablequantity ?? '0'}',
                                              color: ColorsUtils.black),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                width10(),
                                Switch(
                                  value: controller.switchList[index],
                                  activeColor: ColorsUtils.accent,
                                  onChanged: (value) async {
                                    connectivityViewModel.startMonitoring();
                                    if (connectivityViewModel.isOnline !=
                                        null) {
                                      if (connectivityViewModel.isOnline!) {
                                        controller.switchList[index] =
                                            !controller.switchList[index];

                                        bool show = false;
                                        show = controller.switchList[index] ==
                                                true
                                            ? true
                                            : controller.switchList[index] ==
                                                    false
                                                ? false
                                                : false;
                                        print(show);
                                        showStoreReq.showproduct = show;
                                        await myProductListViewModel.showEStore(
                                            myProductListResponse![index]
                                                .id
                                                .toString(),
                                            showStoreReq);

                                        if (myProductListViewModel
                                                .showEStoreApiResponse.status ==
                                            Status.COMPLETE) {
                                          print('successsssss');
                                          print(
                                              'list is ${controller.switchList}');
                                          Get.snackbar(
                                              'Success'.tr,
                                              '${'Product Link has been'.tr} ${controller.switchList[index] == true ? 'enabled'.tr : controller.switchList[index] == false ? 'disabled'.tr : false}');
                                        } else if (myProductListViewModel
                                                .showEStoreApiResponse.status ==
                                            Status.ERROR) {
                                          SessionExpire();
                                        }
                                        setState(() {});
                                      } else {
                                        Get.snackbar('error',
                                            'Please check your connection');
                                      }
                                    } else {
                                      Get.snackbar('error',
                                          'Please check your connection');
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }

  Column topView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                height: Get.width * 0.2,
                width: Get.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: businessDetailCnt.businessInfoModel.value.logo == "" ||
                          businessDetailCnt.businessInfoModel.value.logo == null
                      ? Image.network(
                          "https://sadad.qa/wp-content/uploads/2022/02/Color-Logo.png",
                          fit: BoxFit.scaleDown,
                        )
                      : Image.network(
                          Constants.businessLogoContainer +
                              businessDetailCnt.businessInfoModel.value.logo
                                  .toString(),
                          headers: {
                            'Authorization': token,
                          },
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              width20(),
              customMediumLargeBoldText(
                  color: ColorsUtils.black, title: Utility.name),
              // const Spacer(),
              // InkWell(
              //   onTap: () {
              //     Get.to(() => const EditStoreDetailScreen());
              //   },
              //   child: Image.asset(
              //     Images.edit,
              //     width: 20,
              //     height: 20,
              //   ),
              // ),
            ],
          ),
        ),
        height20(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorsUtils.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: customSmallSemiText(
                        color: ColorsUtils.black,
                        title:
                            'http://e.sadad.qa/${userMetaProfileRes!.first.shorturl}'),
                  ),
                ),
              ),
              width15(),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text:
                          'http://e.sadad.qa/${userMetaProfileRes!.first.shorturl}'));
                  Get.snackbar('', 'Link is Copied to clipboard!');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsUtils.link,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(Images.link, height: 25, width: 25),
                  ),
                ),
              ),
              width15(),
              InkWell(
                onTap: () {
                  Share.share(
                      'http://e.sadad.qa/${userMetaProfileRes!.first.shorturl}');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsUtils.tabUnselectLabel,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(Images.productShare,
                        color: ColorsUtils.white, height: 25, width: 25),
                  ),
                ),
              ),
            ],
          ),
        ),
        height20(),
        SizedBox(
          width: Get.width,
          height: Get.height * 0.09,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: StaticData().storeCountList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: index == 0
                    ? EdgeInsets.only(
                        left: Get.locale!.languageCode == 'en' ? 20 : 5,
                        right: Get.locale!.languageCode == 'en' ? 5 : 20)
                    : index == StaticData().storeCountList.length
                        ? EdgeInsets.only(
                            right: Get.locale!.languageCode == 'en' ? 20 : 5,
                            left: Get.locale!.languageCode == 'en' ? 5 : 20)
                        : const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorsUtils.white,
                      border: Border.all(color: ColorsUtils.border, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customSmallSemiText(
                            color: ColorsUtils.black,
                            title:
                                '${StaticData().storeCountList[index]['title']}'
                                    .tr),
                        height5(),
                        index == 2
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: currencyText(
                                    double.parse(orderCountRes!
                                        .totalOrders!.amount
                                        .toString()),
                                    ThemeUtils.blackBold.copyWith(
                                        fontSize: FontUtils.mediumSmall,
                                        color: ColorsUtils.green),
                                    ThemeUtils.whiteRegular.copyWith(
                                        fontSize: FontUtils.verySmall,
                                        color: ColorsUtils.green)),
                              )
                            : Row(
                                children: [
                                  customSmallMedBoldText(
                                      title: index == 0
                                          ? '${productCountRes!.count ?? '0'}'
                                          : index == 1
                                              ? '${orderCountRes!.totalOrders!.count ?? '0'}'
                                              : '${StaticData().storeCountList[index]['value']}',
                                      color: StaticData().storeCountList[index]
                                          ['color']),
                                  width10(),
                                  customVerySmallSemiText(
                                      color: StaticData().storeCountList[index]
                                          ['color'],
                                      title:
                                          '${StaticData().storeCountList[index]['subTitle']}'
                                              .tr),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        height30(),
      ],
    );
  }

  void bottomSheetforStoreProduct(BuildContext context) {
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
                        Get.back();
                        //myProductListViewModel.switchClear();
                        tempHolder = true;
                        myProductListViewModel.storeProduct.value = 'All';
                        initData(isLoading: false);
                      },
                      child: customSmallMedBoldText(title: 'All'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        Get.back();
                        //myProductListViewModel.switchClear();
                        tempHolder = true;
                        myProductListViewModel.storeProduct.value = 'Active';
                        initData(isLoading: false);
                      },
                      child:
                          customSmallMedBoldText(title: 'Active Products'.tr)),
                  height20(),
                  InkWell(
                      onTap: () {
                        //myProductListViewModel.switchClear();
                        tempHolder = true;
                        myProductListViewModel.storeProduct.value = 'Deactive';
                        initData(isLoading: false);
                        Get.back();
                      },
                      child: customSmallMedBoldText(
                          title: 'Deactivated Products'.tr)),
                  height40(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  initData({bool isLoading = false}) async {
    token = await encryptedSharedPreferences.getString('token');
    Utility.filterSorted = '&filter[order]=created DESC';
    String id = await encryptedSharedPreferences.getString('id');
    String storeCountFilter =
        myProductListViewModel.storeProduct.value == 'Deactive'
            ? ',{"showproduct":"false"}'
            : myProductListViewModel.storeProduct.value == 'Active'
                ? ',{"showproduct":"true"}'
                : '';
    String storeListFilter =
        myProductListViewModel.storeProduct.value == 'Deactive'
            ? '&filter[where][showproduct]=false'
            : myProductListViewModel.storeProduct.value == 'Active'
                ? '&filter[where][showproduct]=true'
                : '';
    myProductListViewModel.clearResponseLost();
    scrollData(id, storeListFilter);
    if (tempHolder) {
      apiCallTemp(id, storeListFilter, isLoading, storeCountFilter);
    } else {
      apiCall(id, storeListFilter, isLoading, storeCountFilter);
    }
  }

  Future<void> apiCallTemp(String id, String storeListFilter, bool isLoading,
      String storeCountFilter) async {
    await myProductListViewModel.myProductList(
        id + Utility.filterSorted + storeListFilter,
        isLoading: isLoading,
        filter: '&filter[where][isdisplayinpanel]=1');
    await myProductListViewModel.productCount(
        id, ',{"isdisplayinpanel":"1"}$storeCountFilter', '');
    tempHolder = false;
  }

  Future<void> apiCall(String id, String storeListFilter, bool isLoading,
      String storeCountFilter) async {
    await businessDetailCnt.getBusinessInfo(context);
    await myProductListViewModel.myProductList(
        id + Utility.filterSorted + storeListFilter,
        isLoading: isLoading,
        filter: '&filter[where][isdisplayinpanel]=1');
    await myProductListViewModel.productCount(
        id, ',{"isdisplayinpanel":"1"}$storeCountFilter', '');
    await myProductListViewModel.orderCount(id, '');

    await myProductListViewModel.userMetaProfile(id);
    if (isPageFirst == false) {
      isPageFirst = true;
    }
  }

  void scrollData(String id, String storeListFilter) {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !myProductListViewModel.isPaginationLoading) {
          myProductListViewModel.myProductList(
              id + Utility.filterSorted + storeListFilter,
              filter: '&filter[where][isdisplayinpanel]=1');
        }
      });
  }
}
