import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/invoiceCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/invoiceListAllResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/onlineInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/filterScreen.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/invoicedetail.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/searchInvoice.dart';
import 'package:sadad_merchat_app/view/payment/reports/invoiceOnlineReportFilterScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/invoiceListViewModel.dart';
import 'package:http/http.dart' as http;

class InvoiceReportScreen extends StatefulWidget {
  final String? endDate;
  final String? startDate;
  final String? selectedType;
  const InvoiceReportScreen(
      {Key? key, this.endDate, this.startDate, this.selectedType})
      : super(key: key);

  @override
  State<InvoiceReportScreen> createState() => _InvoiceReportScreenState();
}

class _InvoiceReportScreenState extends State<InvoiceReportScreen>
    with TickerProviderStateMixin {
  List<String> selectedTimeZone = ['All'];
  String filterDate = '';
  String filterData = '';
  List<InvoiceReportRes>? invoiceAllListResponse;
  String endDate = '';
  int isRadioSelected = 0;
  bool sendEmail = false;
  String startDate = '';
  String email = '';
  int differenceDays = 0;
  bool isSearch = false;
  bool isLoading = false;
  ScrollController? _scrollController;
  double? tabWidgetPosition = 0.0;
  bool isTabVisible = false;
  InvoiceListViewModel invoiceListViewModel = Get.find();
  late TabController tabController;
  GlobalKey _key = GlobalKey();
  AnimationController? animationController;
  Animation<double>? animation;
  int selectedTab = 0;
  ConnectivityViewModel connectivityViewModel = Get.find();
  TextEditingController searchController = TextEditingController();
  String searchKey = '';
  List selectedType = ['Transaction Id'];
  String searchingFilter = '';
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    tabController = TabController(length: 5, vsync: this);
    invoiceListViewModel.setInit();
    invoiceListViewModel.clearResponseLost();
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
            topView(),
            Expanded(
              child: GetBuilder<InvoiceListViewModel>(
                builder: (controller) {
                  if (controller.invoiceAllListReportApiResponse.status ==
                          Status.LOADING ||
                      controller.invoiceAllListReportApiResponse.status ==
                          Status.INITIAL) {
                    return const Center(child: Loader());
                  }

                  if (controller.invoiceAllListReportApiResponse.status ==
                      Status.ERROR) {
                    return const SessionExpire();
                  }

                  invoiceAllListResponse =
                      invoiceListViewModel.invoiceAllListReportApiResponse.data;

                  return Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        controller: _scrollController,
                        child: bottomView(invoiceAllListResponse!),
                      )),
                      if (controller.isPaginationLoading)
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
        ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
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

  Column topView() {
    return Column(
      children: [
        height50(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    if (isSearch == true) {
                      searchKey = '';
                      searchingFilter = '';
                      searchController.clear();
                      invoiceListViewModel.setInit();
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
                            child: Text('Invoice Payments Details'.tr,
                                style: ThemeUtils.blackBold.copyWith(
                                  fontSize: FontUtils.medLarge,
                                )),
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
                                          ? '&filter[where][clientname][like]=%25$searchKey%'
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
                    await Get.to(() => InvoiceReportFilterScreen());
                    invoiceListViewModel.setInit();
                    invoiceListViewModel.clearResponseLost();
                    initData();
                    setState(() {});
                  },
                  child: Image.asset(
                    Images.filter,
                    color: Utility.onlineInvoiceFilterStatus != '' ||
                            Utility.activityReportGetSubUSer != ''
                        ? ColorsUtils.accent
                        : ColorsUtils.black,
                    height: 20,
                    width: 20,
                  )),
            ],
          ),
        ),
        isSearch == true ? SizedBox() : height20(),
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
                                        searchingFilter = '';
                                        invoiceListViewModel.setInit();
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
                    Text(
                        intl.DateFormat('dd MMM yy')
                            .format(DateTime.parse(widget.startDate!))
                            .toString(),
                        textDirection: TextDirection.ltr,
                        style: ThemeUtils.blackSemiBold
                            .copyWith(fontSize: FontUtils.small))
                    // customSmallSemiText(
                    //     title:
                    //         '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.startDate!))}'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customSmallBoldText(title: 'To'.tr),
                    Text(
                        intl.DateFormat('dd MMM yy')
                            .format(DateTime.parse(widget.endDate!))
                            .toString(),
                        textDirection: TextDirection.ltr,
                        style: ThemeUtils.blackSemiBold
                            .copyWith(fontSize: FontUtils.small))
                    // customSmallSemiText(
                    //     title:
                    //         '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.endDate!))}'),
                  ],
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    invoiceAllListResponse!.isEmpty
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
                                '${Utility.baseUrl}/reporthistories/invoiceReports?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}$filterData&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true$filterData',
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
                                    '${Utility.baseUrl}reporthistories/invoiceReports?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}$filterData&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
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

  scrollData(String filter) {
    ///ANIMATION
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController!);
    _scrollController = ScrollController()
      ..addListener(() {
        print('pos ${_scrollController!.position.pixels}');
        if (_scrollController!.position.pixels >= (tabWidgetPosition! - 30)) {
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

        print(
            'MAX POS :${_scrollController!.position.maxScrollExtent} CURRENT POS :${_scrollController!.offset}');
        print('ISLOADING STATUS :${invoiceListViewModel.isPaginationLoading}');
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !invoiceListViewModel.isPaginationLoading) {
          invoiceListViewModel.invoiceReport(filter, fromSearch: false);
        }
      });
  }

  Widget tab1(
    List<InvoiceReportRes>? res,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height20(),
            res!.isEmpty && !invoiceListViewModel.isPaginationLoading
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
                                    invoiceId: res[index].invoiceId != null
                                        ? res[index].invoiceId.toString()
                                        : '',
                                    isReport: true,
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
                                            '${res[index].customerName}',
                                            style: ThemeUtils.blackBold
                                                .copyWith(
                                                    fontSize:
                                                        FontUtils.mediumSmall),
                                          ),
                                        ),
                                        // Icon(Icons.more_vert)
                                      ],
                                    ),
                                    height10(),
                                    Text(
                                      'No. ${res[index].invoiceNumber}',
                                      style: ThemeUtils.blackRegular.copyWith(
                                          fontSize: FontUtils.mediumSmall),
                                    ),
                                    height10(),
                                    Text(
                                      '${res[index].invoiceCreatedDate}',
                                      style: ThemeUtils.blackSemiBold.copyWith(
                                          fontSize: FontUtils.small,
                                          color: ColorsUtils.grey),
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
                                                color: res[index]
                                                            .invoiceStatus ==
                                                        'Unpaid'
                                                    ? ColorsUtils.yellow
                                                    : res[index].invoiceStatus ==
                                                            'Paid'
                                                        ? ColorsUtils.green
                                                        : res[index].invoiceStatus ==
                                                                'Rejected'
                                                            ? ColorsUtils.red
                                                            : ColorsUtils
                                                                .accent,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 3),
                                              child: Text(
                                                res[index].invoiceStatus,
                                                style: ThemeUtils.blackSemiBold
                                                    .copyWith(
                                                        color:
                                                            ColorsUtils.white),
                                              ),
                                            )),
                                        Spacer(),
                                        Text(
                                          '${double.parse(res[index].invoiceAmount.toString()).toStringAsFixed(2)} QAR',
                                          style: ThemeUtils.blackSemiBold
                                              .copyWith(
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
                      },
                    ),
                  )
          ],
        ),
      );

  initData({bool? fromSearch = false}) async {
    email = await encryptedSharedPreferences.getString('email');
    filterDate =
        '&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.endDate}'))}';
    setState(() {
      filterData = Utility.activityReportGetSubUSer +
          Utility.onlineInvoiceFilterStatus +
          searchingFilter;
    });
    scrollData(filterDate +
        Utility.activityReportGetSubUSer +
        Utility.onlineInvoiceFilterStatus +
        searchingFilter);
    await invoiceListViewModel.invoiceReport(
        filterDate +
            searchingFilter +
            Utility.activityReportGetSubUSer +
            Utility.onlineInvoiceFilterStatus,
        fromSearch: fromSearch!);
  }

  bottomView(List<InvoiceReportRes>? invoiceAllListResponse) {
    return Column(
      children: [
        height20(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  '${invoiceListViewModel.invoiceCountValue} ${'Invoice Payments'}')),
        ),
        tab1(
          invoiceAllListResponse,
        ),
        height40()
      ],
    );
  }
}
