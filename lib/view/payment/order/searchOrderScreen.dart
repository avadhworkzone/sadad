import 'dart:io';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/view/payment/order/filterOrderScreen.dart';
import 'package:sadad_merchat_app/viewModel/Payment/product/myproductViewModel.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../base/constants.dart';
import '../../../model/apimodels/responseModel/productScreen/order/orderListResponseModel.dart';
import '../../../model/apis/api_response.dart';
import '../../../staticData/common_widgets.dart';
import '../../../staticData/staticData.dart';
import '../../../staticData/utility.dart';
import '../../../util/utils.dart';
import '../products/orderDetailScreen.dart';

class SearchOrderScreen extends StatefulWidget {
  const SearchOrderScreen({Key? key}) : super(key: key);

  @override
  State<SearchOrderScreen> createState() => _SearchOrderScreenState();
}

class _SearchOrderScreenState extends State<SearchOrderScreen>
    with TickerProviderStateMixin {
  int differenceDays = 0;
  bool isTabVisible = false;
  String _range = '';
  double? tabWidgetPosition = 0.0;
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
  AnimationController? animationController;
  Animation<double>? animation;
  int selectedTab = 0;
  String? searchKey;
  TextEditingController search = TextEditingController();
  List<OrderListResponseModel>? orderListResponse;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUtils.lightBg,
        body: GetBuilder<MyProductListViewModel>(
          builder: (controller) {
            if (controller.orderListApiResponse.status == Status.LOADING ||
                controller.orderListApiResponse.status == Status.INITIAL) {
              return const Center(child: Loader());
            }

            if (controller.orderListApiResponse.status == Status.ERROR) {
              return const SessionExpire();
              // return const Text('Error');
            }

            orderListResponse =
                myProductListViewModel.orderListApiResponse.data;

            return Column(
              children: [
                height40(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            onChanged: (value) async {
                              searchKey = value;
                              setState(() {});
                            },
                            controller: search,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(0.0),
                                isDense: true,
                                prefixIcon: Image.asset(
                                  Images.search,
                                  scale: 3,
                                ),
                                suffixIcon: search.text.isEmpty
                                    ? const SizedBox()
                                    : InkWell(
                                        onTap: () {
                                          search.clear();
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
                                hintText: 'ex. order name...',
                                hintStyle: ThemeUtils.blackRegular.copyWith(
                                    color: ColorsUtils.grey,
                                    fontSize: FontUtils.small)),
                          ),
                        ),
                      ),
                      width10(),
                      InkWell(
                          onTap: () async {
                            await Get.to(() => const FilterOrderScreen());
                            setState(() {});
                            initData();
                          },
                          child: Image.asset(
                            Images.filter,
                            height: 20,
                            width: 20,
                          )),
                    ],
                  ),
                ),
                height20(),
                search.text.isEmpty
                    ? const SizedBox()
                    : Expanded(
                        child: Column(
                          children: [
                            timeZone(),
                            height20(),
                            tabBar(),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  color: ColorsUtils.white,
                                  child: Column(
                                    key: _key,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      height20(),

                                      ///bottomList
                                      orderListResponse!.isEmpty
                                          ? Center(
                                              child: Text('No data found'.tr))
                                          : ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount:
                                                  orderListResponse!.length,
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                if (searchKey != null &&
                                                    searchKey != "") {
                                                  if (orderListResponse![index]
                                                              .transaction !=
                                                          null ||
                                                      orderListResponse![index]
                                                              .product !=
                                                          null) {
                                                    if (orderListResponse![
                                                                index]
                                                            .transaction!
                                                            .invoicenumber
                                                            .toLowerCase()
                                                            .contains(searchKey!
                                                                .toLowerCase()) ||
                                                        orderListResponse![
                                                                index]
                                                            .product!
                                                            .name
                                                            .toLowerCase()
                                                            .contains(searchKey!
                                                                .toLowerCase())) {
                                                      return orderData(
                                                          orderListResponse!,
                                                          index);
                                                    }
                                                  }
                                                }
                                                return const SizedBox();
                                              },
                                            ),
                                      if (controller.isPaginationLoading &&
                                          !isPageFirst)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Center(child: Loader()),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            );
          },
        ));
  }

  Column orderData(List<OrderListResponseModel> orderListResponse, int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: InkWell(
            onTap: () {
              Get.to(() => OrderDetailScreen(
                    id: orderListResponse[index].id.toString(),
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
                            .product!
                            .productmedia!
                            .isEmpty
                        ? Container(
                            height: Get.height * 0.13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  Images.noImage,
                                  height: 50,
                                  width: 50,
                                )),
                          )
                        : Container(
                            height: Get.height * 0.13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '${Constants.productContainer + orderListResponse[index].product!.productmedia!.first.name}',
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
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${orderListResponse[index].product!.name}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeUtils.blackBold
                                    .copyWith(fontSize: FontUtils.small),
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
                              .copyWith(fontSize: FontUtils.small),
                        ),
                        height10(),
                        Row(
                          children: [
                            Text(
                              textDirection: TextDirection.ltr,
                              orderListResponse[index].deliverydate == null
                                  ? ""
                                  : '${intl.DateFormat('dd MMM yyyy HH:mm:ss').format(DateTime.parse(orderListResponse[index].deliverydate))}',
                              style: ThemeUtils.blackRegular
                                  .copyWith(fontSize: FontUtils.small),
                            ),
                            const Spacer(),
                            Image.asset(
                              Images.basket,
                              height: 20,
                              width: 20,
                            ),
                            width10(),
                            Text(
                              '${orderListResponse[index].quantity ?? ""}',
                              style: ThemeUtils.blackSemiBold
                                  .copyWith(fontSize: FontUtils.small),
                            ),
                          ],
                        ),
                        height10(),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    orderListResponse[index].orderstatus!.id ==
                                            1
                                        ? ColorsUtils.yellow
                                        : ColorsUtils.green,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: Text(
                                  '${orderListResponse[index].orderstatus!.name ?? ""}',
                                  style: ThemeUtils.blackRegular.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color: ColorsUtils.white),
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
                              '${double.parse(orderListResponse[index].product!.price.toString()).toStringAsFixed(2)} QAR',
                              style: ThemeUtils.blackBold.copyWith(
                                  fontSize: FontUtils.mediumSmall,
                                  color: ColorsUtils.accent),
                            ),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
        const Divider()
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
            selectedTab = value;
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

  Container timeZone() {
    return Container(
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
                startDate = '';
                endDate = '';
                selectedTimeZone.clear();
                selectedTimeZone.add(StaticData().timeZone[index]);
                myProductListViewModel.clearResponseLost();
                if (selectedTimeZone.contains('Custom')) {
                  selectedTimeZone.clear();
                  await datePicker(context);
                  setState(() {});
                  print('dates $startDate$endDate');
                  if (startDate != '' && endDate != '') {
                    filterDate = '';
                    selectedTimeZone.add('Custom');
                    initData();
                  }
                } else {
                  print('time is $selectedTimeZone');

                  filterDate = selectedTimeZone.first == 'All'
                      ? ""
                      : '${selectedTimeZone.first.toLowerCase()}';
                  initData();
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

  void initData() async {
    String filter = '';
    orderStatus = selectedTab == 0
        ? ''
        : '&filter[where][orderstatusId]=${selectedTab == 1 ? '2' : '1'}';
    if (startDate != '' && endDate != '') {
      filter =
          '&filter[where][dateFilter]=custom&filter[where][between]=["$startDate", "$endDate"]';
    } else {
      filter =
          selectedTimeZone.first == 'All' ? '' : '&filter[where][dateFilter]=';
    }
    String id = await encryptedSharedPreferences.getString('id');
    token = await encryptedSharedPreferences.getString('token');
    // myProductListViewModel.clearResponseLost();

    setState(() {});

    await myProductListViewModel.orderList(
        id + orderStatus + Utility.filterSorted, filter + filterDate);

    if (isPageFirst == false) {
      isPageFirst = true;
    }
    if (myProductListViewModel.orderCountApiResponse.status == Status.ERROR) {
      const SessionExpire();
      // Center(child: const Text('error'));
    }
  }
}

// else if (orderListResponse![
//                                                               index]
//                                                           .transaction !=
//                                                       null) {
//                                                     if (orderListResponse![
//                                                             index]
//                                                         .transaction!
//                                                         .invoicenumber
//                                                         .toLowerCase()
//                                                         .contains(searchKey!
//                                                             .toLowerCase())) {
//                                                       return orderData(
//                                                           orderListResponse!,
//                                                           index);
//                                                     }
//                                                   }
//
// else if (orderListResponse![
// index]
// .cellnumber !=
// null) {
// if (orderListResponse![
// index]
//     .cellnumber
//     .toLowerCase()
//     .contains(searchKey!
//     .toLowerCase())) {
// return orderData(
// orderListResponse!,
// index);
// }
// }
