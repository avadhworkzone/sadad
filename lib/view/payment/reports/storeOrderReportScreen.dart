import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/order/orderCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/order/orderListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/orderReportResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/order/filterOrderScreen.dart';
import 'package:sadad_merchat_app/view/payment/order/searchOrderScreen.dart';
import 'package:sadad_merchat_app/view/payment/products/orderDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/Payment/product/myproductViewModel.dart';
import 'package:http/http.dart' as http;

class StoreOrderDetailScreen extends StatefulWidget {
  final String? endDate;
  final String? startDate;
  final String? selectedType;
  const StoreOrderDetailScreen(
      {Key? key, this.endDate, this.startDate, this.selectedType})
      : super(key: key);

  @override
  State<StoreOrderDetailScreen> createState() => _StoreOrderDetailScreenState();
}

class _StoreOrderDetailScreenState extends State<StoreOrderDetailScreen> {
  int differenceDays = 0;
  bool isTabVisible = false;
  String _range = '';
  double? tabWidgetPosition = 0.0;
  ScrollController? _scrollController;
  // String startDate = '';
  String orderStatus = '';
  late TabController tabController;
  int isRadioSelected = 0;
  String email = '';
  bool sendEmail = false;
  String token = '';
  GlobalKey _key = GlobalKey();
  bool isPageFirst = false;
  MyProductListViewModel myProductListViewModel = Get.find();
  List<String> selectedTimeZone = ['All'];
  String filterDate = '';
  String filter = '';
  bool isSearch = false;
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  String searchingFilter = '';
  String countSearchingFilter = '';
  List selectedType = ['Order Number'];
  // AnimationController? animationController;
  Animation<double>? animation;
  int selectedTab = 0;
  List<OrdData>? orderListResponse;
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    Utility.orderDeliverStatus = '';
    connectivityViewModel.startMonitoring();
    myProductListViewModel.setOrderInit();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    // animationController?.dispose();
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
            topView(),
            Expanded(
              child: GetBuilder<MyProductListViewModel>(
                builder: (controller) {
                  if (controller.orderReportListApiResponse.status ==
                          Status.LOADING ||
                      controller.orderReportListApiResponse.status ==
                          Status.INITIAL) {
                    return const Center(child: Loader());
                  }

                  if (controller.orderReportListApiResponse.status ==
                          Status.ERROR ||
                      controller.orderCountApiResponse.status == Status.ERROR) {
                    return const SessionExpire();
                    // return const Text('Error');
                  }

                  orderListResponse =
                      myProductListViewModel.orderReportListApiResponse.data;

                  // setState(() {});
                  return Column(
                    children: [
                      bottomData(orderListResponse!, controller),
                    ],
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
                myProductListViewModel.setOrderInit();
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

  Expanded bottomData(
      List<OrdData> orderListResponse, MyProductListViewModel controller) {
    return Expanded(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          color: ColorsUtils.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height20(),
              orderListResponse.isEmpty && !controller.isPaginationLoading
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              '${myProductListViewModel.countOrderReport} ${'Orders'.tr}')),
                    ),
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
                        print(
                            "orderListResponse[index].orderStatusId ==== ${orderListResponse[index].orderStatusId}");
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => OrderDetailScreen(
                                        isFromReportScreen: true,
                                        id: orderListResponse[index]
                                            .Id
                                            .toString(),
                                      ));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: orderListResponse[index]
                                                        .productMediaName ==
                                                    null ||
                                                orderListResponse[index]
                                                    .productMediaName!
                                                    .isEmpty
                                            ? Container(
                                                height: Get.height * 0.13,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                        BorderRadius.circular(
                                                            10)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    '${Utility.baseUrl}containers/api-product/download/${orderListResponse[index].productMediaName!.first.name}',
                                                    headers: {
                                                      HttpHeaders
                                                              .authorizationHeader:
                                                          token
                                                    },
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
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
                                                    orderListResponse[index]
                                                            .productItemName ??
                                                        '',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: ThemeUtils.blackBold
                                                        .copyWith(
                                                            fontSize: FontUtils
                                                                .small),
                                                  ),
                                                ),
                                                orderListResponse[index]
                                                            .orderStatusId ==
                                                        1
                                                    ? InkWell(
                                                        onTap: () {
                                                          markAsDelBottomSheet(
                                                              orderListResponse[
                                                                      index]
                                                                  .Id);
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
                                              'No. ${orderListResponse[index].transactionId ?? ""}',
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
                                                              .orderDateTime ==
                                                          null
                                                      ? ""
                                                      : '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(orderListResponse[index].orderDateTime))}',
                                                  style: ThemeUtils.blackRegular
                                                      .copyWith(
                                                          color:
                                                              ColorsUtils.grey,
                                                          fontSize:
                                                              FontUtils.small),
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
                                                              FontUtils.small),
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
                                                                .orderStatusId ==
                                                            1
                                                        ? ColorsUtils.yellow
                                                        : ColorsUtils.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 2,
                                                        horizontal: 10),
                                                    child: Text(
                                                      '${orderListResponse[index].orderStatus ?? ""}',
                                                      style: ThemeUtils
                                                          .blackRegular
                                                          .copyWith(
                                                              fontSize: FontUtils
                                                                  .verySmall,
                                                              color: ColorsUtils
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
                                                  '${double.parse(orderListResponse[index].orderAmount.toString()).toStringAsFixed(2) ?? ""} QAR',
                                                  //'0 QAR',
                                                  style: ThemeUtils.blackBold
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
      ),
    );
  }

  Column topView() {
    return Column(
      children: [
        height40(),
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
                      myProductListViewModel.setOrderInit();
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
                              child: Text('Store Order Details'.tr,
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
                            myProductListViewModel.oReportResponse.clear();
                            myProductListViewModel.clearResponseLost();
                            myProductListViewModel.setProductInit();
                            myProductListViewModel.setProductInit();
                            myProductListViewModel.setOrderInit();
                            setState(() {});

                            // invoiceListViewModel.setInit();
                            // invoiceListViewModel.clearResponseLost();
                            //
                            initData(fromSearch: true);
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
                                        myProductListViewModel.setOrderInit();
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
              width10(),
              //isSearch == false ? const SizedBox() : width10(),
              InkWell(
                  onTap: () async {
                    await Get.to(() => FilterOrderScreen());
                    setState(() {});
                    myProductListViewModel.setOrderInit();

                    initData();
                  },
                  child: Image.asset(
                    Images.filter,
                    color: Utility.orderDeliverStatus != ''
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
                                        myProductListViewModel.setOrderInit();
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
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: Row(
        //     children: [
        //       InkWell(
        //           onTap: () {
        //             Get.back();
        //           },
        //           child: const Icon(Icons.arrow_back_ios)),
        //       width10(),
        //       Text('Store Order Details',
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
        height20(),
        Container(height: 1, width: Get.width, color: ColorsUtils.border),
        SizedBox(
          height: Get.height * 0.08,
          width: Get.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              width20(),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customSmallBoldText(title: 'From'.tr),
                    customSmallSemiText(
                        title:
                            '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.startDate!))}'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customSmallBoldText(title: 'To'.tr),
                    customSmallSemiText(
                        title:
                            '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.endDate!))}'),
                  ],
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    orderListResponse!.isEmpty
                        ? Get.showSnackbar(GetSnackBar(
                            message: 'No Data Found'.tr,
                          ))
                        : exportBottomSheet();
                    // bottomSheetforDownloadAndRefund(context);
                  },
                  child: Container(
                    color: ColorsUtils.accent,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Images.download,
                            height: 20,
                          ),
                          Text(
                            'Download'.tr,
                            style: ThemeUtils.blackSemiBold.copyWith(
                                fontSize: FontUtils.small,
                                color: ColorsUtils.white),
                          )
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(height: 1, width: Get.width, color: ColorsUtils.border),
      ],
    );
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

  Container commonOrderCount({String? amount, Color? color, String? title}) {
    return Container(
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: Get.width * 0.25,
          child: Column(
            children: [
              Text(
                amount!,
                style: ThemeUtils.blackBold
                    .copyWith(fontSize: FontUtils.medLarge, color: color),
              ),
              height10(),
              Text(
                title!.tr,
                textAlign: TextAlign.center,
                style: ThemeUtils.blackRegular.copyWith(
                  fontSize: FontUtils.small,
                ),
              ),
            ],
          ),
        ),
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
                            Get.back();

                            Get.snackbar('Success'.tr, 'delivered successfull');

                            hideLoadingDialog(context: context);
                            myProductListViewModel.setOrderInit();
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          sendEmail = !sendEmail;
                          setState(() {});
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorsUtils.black, width: 1),
                              borderRadius: BorderRadius.circular(5)),
                          child: sendEmail == true
                              ? Center(
                                  child: Image.asset(Images.check,
                                      height: 10, width: 10))
                              : SizedBox(),
                        ),
                      ),
                      width20(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Send Email to'.tr,
                              style: ThemeUtils.blackBold.copyWith(
                                fontSize: FontUtils.verySmall,
                              ),
                            ),
                            Text(
                              email,
                              style: ThemeUtils.blackRegular.copyWith(
                                fontSize: FontUtils.verySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  height30(),
                  InkWell(
                    onTap: () async {
                      connectivityViewModel.startMonitoring();

                      if (connectivityViewModel.isOnline != null) {
                        if (connectivityViewModel.isOnline!) {
                          if (isRadioSelected == 0) {
                            Get.snackbar('error', 'Please select Format!'.tr);
                          } else {
                            if (sendEmail == true) {
                              String token = await encryptedSharedPreferences
                                  .getString('token');
                              final url = Uri.parse(
                                '${Utility.baseUrl}reporthistories/orderReports?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
                              );
                              Map<String, String> header = {
                                'Authorization': token,
                                'Content-Type': 'application/json'
                              };
                              var result = await http.get(
                                url,
                                headers: header,
                              );
                              print(
                                  'token is:$token \n req is : ${result.request}  \n response is :${result.body} ');
                              if (result.statusCode == 200) {
                                Get.snackbar(
                                    'Success'.tr, 'report send successFully');
                              } else {
                                // const SessionExpire();
                                Get.snackbar('error', 'something Wrong');
                              }
                            } else {
                              await downloadFile(
                                isEmail: sendEmail,
                                isRadioSelected: isRadioSelected,
                                url:
                                    '${Utility.baseUrl}reporthistories/orderReports?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
                                context: context,
                              );
                            }
                          }
                        } else {
                          Get.snackbar('error', 'Please check your connection');
                        }
                      } else {
                        Get.snackbar('error', 'Please check your connection');
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

  void initData({bool fromSearch = false}) async {
    email = await encryptedSharedPreferences.getString('email');

    String countFilter = '';

    filter =
        '&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}';
    // filter =
    //     '&filter[where][dateFilter]=custom&filter[where][between]=["${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}", "${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}"]';

    countFilter =
        '&where[dateFilter]=custom&where[between]=["${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}", "${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}"]';

    //orders/counts?where[vendorId]=466&where[dateFilter]=custom&where[between]=["2022-05-14 00:00:00", "2022-05-28 23:59:59"]

    print('filter is $filter');
    print('Order Status  $orderStatus');
    scrollData();

    String id = await encryptedSharedPreferences.getString('id');
    token = await encryptedSharedPreferences.getString('token');
    myProductListViewModel.clearResponseLost();
    // myProductListViewModel.orderCount(
    //     id,
    //     countFilter +
    //         filterDate +
    //         countSearchingFilter +
    //         orderStatus +
    //         (Utility.orderDeliverStatus == ''
    //             ? ""
    //             : '&where[orderstatusId]=${Utility.orderDeliverStatus}'));
    await myProductListViewModel.orderReportList(
        '',
        filter +
            filterDate +
            searchingFilter +
            (Utility.orderDeliverStatus == ''
                ? ""
                : '&filter[where][orderstatusId]=${Utility.orderDeliverStatus}'),
        fromSearch: fromSearch);

    if (isPageFirst == false) {
      isPageFirst = true;
    }
    Future.delayed(Duration(seconds: 1), () {
      getPosition();
    });
    // if (myProductListViewModel.orderCountApiResponse.status == Status.ERROR) {
    //   const SessionExpire();
    //   // Center(child: const Text('error'));
    // }
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

  void scrollData() async {
    orderStatus = '';

    filter =
        '&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}';

    //orders/counts?where[vendorId]=466&where[dateFilter]=custom&where[between]=["2022-05-14 00:00:00", "2022-05-28 23:59:59"]

    print('filter after scroll $filter');
    token = await encryptedSharedPreferences.getString('token');
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.pixels >= (tabWidgetPosition! - 30)) {
          if (!isTabVisible) {
            setState(() {
              isTabVisible = true;
              // animationController!.forward();
            });
          }
        } else {
          if (isTabVisible) {
            setState(() {
              isTabVisible = false;
              // animationController!.reverse();
            });
          }
        }
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !myProductListViewModel.isPaginationLoading) {
          myProductListViewModel.orderReportList(
              orderStatus + Utility.filterSorted,
              filter +
                  filterDate +
                  searchingFilter +
                  (Utility.orderDeliverStatus == ''
                      ? ""
                      : '&filter[where][orderstatusId]=${Utility.orderDeliverStatus}'),
              fromSearch: false);
        }
      });
  }
}
