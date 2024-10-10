import 'dart:convert';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/detailedInvoiceScreen.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/fastInvoiceScreen.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/invoiceListViewModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../model/apimodels/responseModel/DashBoard/invoice/invoiceListAllResponseModel.dart';
import '../../../model/apis/api_response.dart';
import '../../../staticData/staticData.dart';
import '../../../staticData/utility.dart';
import 'filterScreen.dart';
import 'invoicedetail.dart';
import 'package:http/http.dart' as http;

class SearchInvoiceScreen extends StatefulWidget {
  const SearchInvoiceScreen({Key? key}) : super(key: key);

  @override
  State<SearchInvoiceScreen> createState() => _SearchInvoiceScreenState();
}

class _SearchInvoiceScreenState extends State<SearchInvoiceScreen>
    with TickerProviderStateMixin {
  TextEditingController search = TextEditingController();
  List<String> selectedTimeZone = ['All'];
  String filterDate = '';
  String? searchKey;
  String _range = '';
  int differenceDays = 0;
  int selectedTab = 0;
  String endDate = '';
  late TabController tabController;
  String startDate = '';
  ScrollController? _scrollController;
  InvoiceListViewModel invoiceListViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();

  @override
  void initState() {
    // initData();
    // invoiceListViewModel.setInit();
    tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
                      // invoiceListViewModel.setInit();
                      updateApiCall();
                      // initData('&filter[where][description]=$searchKey');
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
                            ? SizedBox()
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
                            borderSide: BorderSide(
                                color: ColorsUtils.border, width: 1)),
                        hintText: 'ex. invoice description'.tr,
                        hintStyle: ThemeUtils.blackRegular.copyWith(
                            color: ColorsUtils.grey,
                            fontSize: FontUtils.small)),
                  ),
                ),
              ),
              width10(),
              InkWell(
                  onTap: () async {
                    await Get.to(() => const FilterScreen());
                    setState(() {});
                    invoiceListViewModel.clearResponseLost();
                    initData('&filter[where][description]=$searchKey');
                  },
                  child: Image.asset(
                    Images.filter,
                    height: 20,
                    width: 20,
                  )),
            ],
          ),
        ),
        search.text.isEmpty
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: timeZone(),
              ),
        search.text.isEmpty
            ? const SizedBox()
            : GetBuilder<InvoiceListViewModel>(
                builder: (controller) {
                  print('refresh');
                  if (controller.invoiceAllListApiResponse.status ==
                          Status.LOADING ||
                      controller.invoiceAllListApiResponse.status ==
                          Status.INITIAL) {
                    return const Center(child: Loader());
                  }

                  if (controller.invoiceAllListApiResponse.status ==
                      Status.ERROR) {
                    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text('Session Expire'.tr)));
                    //   Future.delayed(Duration(seconds: 4), () {
                    //     Get.offAll(() => SplashScreen());
                    //     print('error${ApiResponse.error()}');
                    //   });
                    // });

                    return Center(
                      child: Text('Something Wrong'.tr),
                    );
                  }
                  List<InvoiceAllListResponseModel> invoiceAllListResponse =
                      invoiceListViewModel.invoiceAllListApiResponse.data;
                  // InvoiceCountResponseModel invoiceCountResponse =
                  //     invoiceListViewModel.invoiceCountApiResponse.data;
                  return Expanded(
                    child: tabBarData(
                      invoiceAllListResponse,
                    ),
                  );
                },
              ),
      ],
    ));
  }

  String getFilterStr() {
    String? req;
    String id = Utility.userId;
    int value = selectedTab;
    if (Utility.startRange == 0 && Utility.endRange == 0) {
      req = value == 0
          ? '$id&filter[where][description]=$searchKey'
          : value == 1
              ? '$id &filter[where][description]=$searchKey${Utility.filterSorted}&filter[where][invoicestatusId]=3'
              : value == 2
                  ? '$id&filter[where][description]=$searchKey${Utility.filterSorted}&filter[where][invoicestatusId]=2'
                  : value == 3
                      ? '$id&filter[where][description]=$searchKey${Utility.filterSorted}&filter[where][invoicestatusId]=5'
                      : '$id&filter[where][description]=$searchKey${Utility.filterSorted}&filter[where][invoicestatusId]=1';
    } else {
      req = value == 0
          ? id + '&filter[where][description]=$searchKey' + filterDate
          : value == 1
              ? '$id&filter[where][description]=$searchKey${Utility.filterSorted}&filter[where][invoicestatusId]=3&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}$filterDate'
              : value == 2
                  ? '$id${Utility.filterSorted}&filter[where][invoicestatusId]=2&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}$filterDate'
                  : value == 3
                      ? '$id${Utility.filterSorted}&filter[where][invoicestatusId]=5&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}$filterDate'
                      : '$id${Utility.filterSorted}&filter[where][invoicestatusId]=1&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}$filterDate';
    }
    return req;
  }

  Widget tabBarData(List<InvoiceAllListResponseModel> invoiceAllListResponse) {
    return Column(
      children: [
        Container(
            // key: _key,
            width: Get.width,
            decoration: const BoxDecoration(
              color: ColorsUtils.accent,
            ),
            child: tabBar()),
        height20(),
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
        Expanded(
          child: tab1(
            invoiceAllListResponse,
          ),
        ),
        height40(),
        // if (invoiceListViewModel.isPaginationLoading)
        //   const Padding(
        //     padding: EdgeInsets.symmetric(vertical: 10),
        //     child: Loader(),
        //   )
      ],
    );
  }

  Widget tab1(
    List<InvoiceAllListResponseModel> res,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          controller: _scrollController,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${res[index].clientname}',
                                              style: ThemeUtils.blackBold
                                                  .copyWith(
                                                      fontSize: FontUtils
                                                          .mediumSmall),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                bottomSheet(
                                                    context, res, index);
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
                                        style: ThemeUtils.blackSemiBold
                                            .copyWith(
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
                                                            BorderRadius
                                                                .circular(15)),
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
                                                                color:
                                                                    ColorsUtils
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
                                              color: res[index].readdatetime !=
                                                      null
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
                                                        color:
                                                            ColorsUtils.accent,
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
        ),
      );

  // Widget tabBar() {
  //   return TabBar(
  //     controller: tabController,
  //     indicatorColor: ColorsUtils.white,
  //     onTap: (value) async {
  //       selectedTab = value;
  //       // String id = await encryptedSharedPreferences.getString('id');
  //       String req = getFilterStr();
  //       invoiceListViewModel.clearResponseLost();
  //       invoiceListViewModel.invoiceAllListApiResponse =
  //           ApiResponse.loading('Loading');
  //       // showLoadingDialog(context: context);
  //       await invoiceListViewModel.listAllInvoice(req, filterDate);
  //       // hideLoadingDialog(context: context);
  //     },
  //     labelStyle: ThemeUtils.blackSemiBold.copyWith(color: ColorsUtils.white),
  //     unselectedLabelColor: ColorsUtils.white,
  //     labelColor: ColorsUtils.white,
  //     labelPadding: const EdgeInsets.all(3),
  //     tabs: [
  //       Tab(text: "All".tr),
  //       Tab(text: "Paid".tr),
  //       Tab(text: "Unpaid".tr),
  //       Tab(text: "Rejected".tr),
  //       Tab(text: "Draft".tr),
  //     ],
  //   );
  // }

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

  Padding invoiceData(List<InvoiceAllListResponseModel> res, int index) {
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
              border: Border.all(color: ColorsUtils.border, width: 1)),
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
                            .copyWith(fontSize: FontUtils.mediumSmall),
                      ),
                    ),
                    // Spacer(),
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
                  style: ThemeUtils.blackRegular
                      .copyWith(fontSize: FontUtils.mediumSmall),
                ),
                height10(),
                Text(
                  '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(res[index].created.toString()))}',
                  style: ThemeUtils.blackSemiBold.copyWith(
                      fontSize: FontUtils.small, color: ColorsUtils.grey),
                ),
                height10(),
                Row(
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
                            color: res[index].invoicestatusId == 1
                                ? ColorsUtils.countBackground
                                : res[index].invoicestatusId == 2
                                    ? ColorsUtils.yellow
                                    : res[index].invoicestatusId == 3
                                        ? ColorsUtils.green
                                        : res[index].invoicestatusId == 4
                                            ? ColorsUtils.reds
                                            : ColorsUtils.red,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 3),
                          child: Text(
                            res[index].invoicestatusId == 1
                                ? 'Draft'.tr
                                : res[index].invoicestatusId == 2
                                    ? 'Unpaid'.tr
                                    : res[index].invoicestatusId == 3
                                        ? 'Paid'.tr
                                        : res[index].invoicestatusId == 4
                                            ? 'Overdue'.tr
                                            : 'Rejected'.tr,
                            style: ThemeUtils.blackSemiBold
                                .copyWith(color: ColorsUtils.white),
                          ),
                        )),
                    Spacer(),
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        Images.accentEye,
                        height: 15,
                        color: res[index].readreceipt == true
                            ? ColorsUtils.accent
                            : ColorsUtils.border,
                      ),
                    ),
                    Text(
                      '${res[index].grossamount} QAR',
                      style: ThemeUtils.blackSemiBold.copyWith(
                          color: ColorsUtils.accent,
                          fontSize: FontUtils.medium),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                                    'type':
                                        response[index].invoicestatusId ?? "",
                                    'mobNo': response[index].cellno ?? "",
                                    'description':
                                        response[index].remarks ?? "",
                                  };
                                  Get.to(() => FastInvoiceScreen(
                                        invoiceDetail: invoiceDetail,
                                        transId: response[index].id.toString(),
                                      ));
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
                  response[index].invoicestatusId == 1
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
                            response[index].invoicestatusId == 3 ||
                                    response[index].invoicestatusId == 4
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
                            if (response[index].invoicestatusId != 3) {
                              String token = await encryptedSharedPreferences
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

  Future<void> updateApiCall() async {
    String countFilter = '';
    String filter = '';

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
    await invoiceListViewModel.invoiceCount(req + countFilter + filterDate);
    await invoiceListViewModel.listAllInvoice(req, filter + filterDate);
    setState(() {});
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
                endDate = '';
                startDate = '';
                invoiceListViewModel.clearResponseLost();
                if (selectedTimeZone.contains('Custom')) {
                  // _selectDate(context);
                  await datePicker(context);
                  setState(() {});
                  print('dates $startDate$endDate');

                  if (startDate != '' && endDate != '') {
                    filterDate = '["$startDate", "$endDate"]';
                    initData('&filter[where][description]=$searchKey');
                  }
                } else {
                  print('time is $selectedTimeZone');

                  filterDate = selectedTimeZone.first == 'All'
                      ? ""
                      : selectedTimeZone.first.toLowerCase();
                  initData('&filter[where][description]=$searchKey');
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
                    StaticData().timeZone[index].tr,
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

  Future<void> datePicker(BuildContext context) async {
    await showDialog(
        context: context,
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

  int getSearchCount(List<InvoiceAllListResponseModel> result) {
    int count = 0;
    result.forEach((e) {
      if ((e.clientname as String)
          .toLowerCase()
          .contains(searchKey!.toLowerCase())) {
        count++;
      } else if (e.invoiceno != null) {
        if ((e.invoiceno as String)
            .toLowerCase()
            .contains(searchKey!.toLowerCase())) {
          count++;
        }
      } else if (e.cellno != null) {
        if ((e.cellno as String)
            .toLowerCase()
            .contains(searchKey!.toLowerCase())) {
          count++;
        }
      }
    });
    // count = res
    //     .map((e) =>
    //         (e.clientname as String).toLowerCase() == searchKey!.toLowerCase())
    //     .toList()
    //     .length;
    // print('count is $count');
    return count;
  }

  void initData(String? searchFilter) async {
    String filter = '';

    if (startDate != '' && endDate != '') {
      filter = 'custom&filter[where][between]=';
    } else {
      filter = '';
    }
    String id = await encryptedSharedPreferences.getString('id');
    if (Utility.startRange == 0 && Utility.endRange == 0) {
      print('print${filter + filterDate}');
      await invoiceListViewModel.listAllInvoice(
          id + searchFilter! + Utility.filterSorted, filter + filterDate);
    } else {
      String idUrl = id +
          Utility.filterSorted +
          searchFilter! +
          '&filter[where][grossamount][between][0]=${Utility.startRange.toInt()}&filter[where][grossamount][between][1]=${Utility.endRange.toInt()}';
      String dateUrl = filter + filterDate;
      // ignore: prefer_interpolation_to_compose_strings
      await invoiceListViewModel.listAllInvoice(idUrl, dateUrl);
    }

    _scrollController = ScrollController()
      ..addListener(() {
        print(
            'MAX POS :${_scrollController!.position.maxScrollExtent} CURRENT POS :${_scrollController!.offset}');
        print('ISLOADING STATUS :${invoiceListViewModel.isPaginationLoading}');
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !invoiceListViewModel.isPaginationLoading) {
          invoiceListViewModel.listAllInvoice(
              id + searchFilter + Utility.filterSorted, filter + filterDate);
        }
      });
  }
}
