import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/onlineTransactionReportResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/disputeTransactionResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/disputesCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/transactionCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/transactionListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/reports/transactionReportDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/reports/transactionReportFilterScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/filterTransaction.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/refundTransactionScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/searchTransaction.dart';
import 'package:sadad_merchat_app/view/payment/transaction/transactionDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/Payment/transaction/transactionViewModel.dart';
import 'package:http/http.dart' as http;

class TransactionReportScreen extends StatefulWidget {
  final String? endDate;
  final String? startDate;
  final String? selectedType;
  const TransactionReportScreen(
      {Key? key, this.endDate, this.startDate, this.selectedType})
      : super(key: key);

  @override
  State<TransactionReportScreen> createState() =>
      _TransactionReportScreenState();
}

class _TransactionReportScreenState extends State<TransactionReportScreen>
    with TickerProviderStateMixin {
  int differenceDays = 0;
  bool isTabVisible = false;
  String searchKey = '';
  bool sendEmail = false;
  String email = '';
  int isRadioSelected = 0;
  double? tabWidgetPosition = 0.0;
  String startDate = '';
  String orderStatus = '';
  late TabController tabController;
  String endDate = '';
  String token = '';
  bool isPageFirst = true;
  List<String> selectedTimeZone = ['All'];
  String filterDate = '';
  String filterData = '';
  TransactionViewModel transactionViewModel = Get.find();
  ScrollController? _scrollController;
  List<OnlineTransReportData>? transactionListResponse;
  TextEditingController searchController = TextEditingController();
  ConnectivityViewModel connectivityViewModel = Get.find();
  bool isSearch = false;
  List selectedType = ['Transaction ID'];

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    transactionViewModel.setTransactionInit();
    tabController = TabController(length: 3, vsync: this);
    Utility.isDisputeDetailTransaction = false;
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
        return Scaffold(
            body: Column(
          children: [
            topView(),
            Expanded(
              child: GetBuilder<TransactionViewModel>(
                builder: (controller) {
                  if (controller.transactionReportApiResponse.status ==
                          Status.LOADING ||
                      controller.transactionReportApiResponse.status ==
                          Status.INITIAL) {
                    return const Center(child: Loader());
                  }
                  if (controller.transactionReportApiResponse.status ==
                          Status.ERROR ||
                      controller.disputeTransactionListApiResponse.status ==
                          Status.ERROR) {
                    return const SessionExpire();
                    // return const Text('Error');
                  }

                  transactionListResponse =
                      transactionViewModel.transactionReportApiResponse.data;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            customSmallBoldText(
                                title: transactionViewModel.countOfTransaction),
                            customSmallNorText(title: ' Transactions'),
                          ],
                        ),
                      ),
                      if (transactionViewModel.isPaginationLoading &&
                          isPageFirst)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: Loader()),
                        ),
                      (transactionListResponse == null ||
                                  transactionListResponse!.isEmpty) &&
                              !transactionViewModel.isPaginationLoading
                          ? noDataFound()
                          : tabListData(),
                      if (transactionViewModel.isPaginationLoading &&
                          !isPageFirst)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: Loader()),
                        ),
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
                transactionViewModel.setTransactionInit();
                tabController = TabController(length: 3, vsync: this);
                Utility.isDisputeDetailTransaction = false;
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
              transactionViewModel.setTransactionInit();
              tabController = TabController(length: 3, vsync: this);
              Utility.isDisputeDetailTransaction = false;
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
                      searchController.clear();
                      transactionViewModel.setTransactionInit();

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
                          Text('Transactions Details'.tr,
                              style: ThemeUtils.blackBold.copyWith(
                                fontSize: FontUtils.medLarge,
                              )),
                          const Spacer(),
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
                          width30(),
                        ],
                      ),
                    )
                  : Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          onChanged: (value) async {
                            transactionViewModel.setTransactionInit();

                            searchKey = value;
                            setState(() {});
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
                                        setState(() {});

                                        transactionViewModel
                                            .setTransactionInit();

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
                              hintText: 'ex. ${selectedType.first}...',
                              hintStyle: ThemeUtils.blackRegular.copyWith(
                                  color: ColorsUtils.grey,
                                  fontSize: FontUtils.small)),
                        ),
                      ),
                    ),
              isSearch == false ? const SizedBox() : width10(),
              InkWell(
                  onTap: () async {
                    await Get.to(() => TransactionReportFilterScreen());
                    transactionViewModel.setTransactionInit();
                    initData();
                  },
                  child: Image.asset(
                    Images.filter,
                    color: Utility.transactionFilterStatus == '' &&
                            Utility.transactionFilterTransactionType == '' &&
                            Utility.transactionFilterPaymentMethod == '' &&
                            Utility.transactionFilterTransactionModes == '' &&
                            Utility.transactionFilterTransactionSources == '' &&
                            Utility.transactionFilterIntegrationType == ''
                        ? ColorsUtils.black
                        : ColorsUtils.accent,
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
                  // padding: EdgeInsets.all,
                  // decoration: BoxDecoration(
                  //     border: Border.all(
                  //         color: ColorsUtils.grey.withOpacity(0.3),
                  //         width: 1),
                  //     borderRadius: BorderRadius.circular(10)),
                  width: Get.width,
                  child: Row(
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
                              StaticData().paymentTrnxReportType.length,
                              (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: InkWell(
                                      onTap: () async {
                                        selectedType.clear();
                                        searchKey = '';
                                        searchController.clear();
                                        selectedType.add(StaticData()
                                            .paymentTrnxReportType[index]);
                                        transactionViewModel
                                            .setTransactionInit();

                                        initData();
                                        // cardEntryType == index.toString();
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
                                                            .paymentTrnxReportType[
                                                        index])
                                                ? ColorsUtils.primary
                                                : ColorsUtils.white),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            StaticData()
                                                .paymentTrnxReportType[index]
                                                .tr,
                                            style: ThemeUtils.blackBold.copyWith(
                                                fontSize: FontUtils.verySmall,
                                                color: selectedType.contains(
                                                        StaticData()
                                                                .paymentTrnxReportType[
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
                    transactionListResponse!.isEmpty
                        ? Get.showSnackbar(GetSnackBar(
                            message: 'No Data Found'.tr,
                          ))
                        : exportBottomSheet();
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
                                '${Utility.baseUrl}reporthistories/transactionDetailsReport?filter[order]=created DESC$filterData&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true',
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
                                name:
                                    'Transaction report ${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse('${widget.startDate}'))} to ${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse('${widget.endDate}'))} ${DateTime.now().microsecondsSinceEpoch}',
                                url:
                                    '${Utility.baseUrl}reporthistories/transactionDetailsReport?filter[order]=created DESC$filterData&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
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

  Center noDataFound() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Text('No data found'.tr),
    ));
  }

  Expanded tabListData() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: transactionListResponse!.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: InkWell(
                  onTap: () {
                    OnlineTransReportData abc = transactionListResponse![index];
                    print("Detail Response === ${abc.id}");
                    Utility.isDisputeDetailTransaction = false;
                    Get.to(() => TransactionReportDetailScreen(
                          isFromReport: true,
                          transactionDetailResponse:
                              transactionListResponse![index],
                          id: transactionListResponse![index].id != null
                              ? transactionListResponse![index].id.toString()
                              : '',
                        ));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              color: ColorsUtils.lightBg,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            // child: Image.asset(
                            //   Images.transactionMenu,
                            //   width: 25,
                            //   height: 25,
                            // ),
                            child: Image.asset(
                              transactionListResponse![index].paymentMethods ==
                                      'VISA'
                                  ? Images.visaCard
                                  : transactionListResponse![index]
                                              .paymentMethods ==
                                          'SADAD PAY'
                                      ? Images.sadadWalletPay
                                      : transactionListResponse![index]
                                                  .paymentMethods ==
                                              'MASTERCARD'
                                          ? Images.masterCard
                                          : transactionListResponse![index]
                                                      .paymentMethods ==
                                                  'GOOGLE PAY'
                                              ? Images.googlePay
                                              : transactionListResponse![index]
                                                          .paymentMethods ==
                                                      'APPLE PAY'
                                                  ? Images.applePay
                                                  : transactionListResponse![
                                                                  index]
                                                              .paymentMethods ==
                                                          'JCB'
                                                      ? Images.jcb
                                                      : transactionListResponse![
                                                                      index]
                                                                  .paymentMethods ==
                                                              'AMERICAN EXPRESS'
                                                          ? Images.amex
                                                          : transactionListResponse![
                                                                          index]
                                                                      .paymentMethods ==
                                                                  'UPI'
                                                              ? Images.upi
                                                              : transactionListResponse![
                                                                              index]
                                                                          .paymentMethods ==
                                                                      'SADAD'
                                                                  ? Images
                                                                      .sadadWalletPay
                                                                  : Images
                                                                      .transactionMenu,
                              height: 40,
                            ),
                          )),
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
                                      'ID: ${transactionListResponse![index].transactionId}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: ThemeUtils.blackBold
                                          .copyWith(fontSize: FontUtils.small),
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     bottomSheetforDownloadAndRefund(
                                  //         context, index);
                                  //   },
                                  //   child: const Icon(
                                  //     Icons.more_vert,
                                  //   ),
                                  // )
                                ],
                              ),
                              height10(),
                              Text(
                                '${transactionListResponse![index].paymentMethods == 'GOOGLE PAY' || transactionListResponse![index].paymentMethods == 'APPLE PAY' || transactionListResponse![index].paymentMethods == 'SADAD PAY' ? 'WALLET' : transactionListResponse![index].paymentMethods ?? "NA"}',
                                style: ThemeUtils.blackRegular
                                    .copyWith(fontSize: FontUtils.small),
                              ),
                              height10(),
                              Text(
                                textDirection: TextDirection.ltr,
                                '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(transactionListResponse![index].transactionDateTime))}',
                                style: ThemeUtils.blackRegular.copyWith(
                                    fontSize: FontUtils.small,
                                    color: ColorsUtils.grey),
                              ),
                              height10(),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      // color: transactionListResponse![index]
                                      //             .transactionstatusId
                                      //             .toString() ==
                                      //         '1'
                                      //     ? ColorsUtils.yellow
                                      //     : transactionListResponse![index]
                                      //                 .transactionstatusId
                                      //                 .toString() ==
                                      //             '2'
                                      //         ? ColorsUtils.reds
                                      //         : transactionListResponse![index]
                                      //                     .transactionstatusId
                                      //                     .toString() ==
                                      //                 '3'
                                      //             ? ColorsUtils.green
                                      //             : transactionListResponse![
                                      //                             index]
                                      //                         .transactionstatusId
                                      //                         .toString() ==
                                      //                     '4'
                                      //                 ? ColorsUtils.green
                                      //                 : transactionListResponse![
                                      //                                 index]
                                      //                             .transactionstatusId
                                      //                             .toString() ==
                                      //                         '5'
                                      //                     ? ColorsUtils.yellow
                                      //                     : transactionListResponse![
                                      //                                     index]
                                      //                                 .transactionstatusId
                                      //                                 .toString() ==
                                      //                             '6'
                                      //                         ? ColorsUtils
                                      //                             .blueBerryPie
                                      //                         : ColorsUtils
                                      //                             .accent,
                                      color: transactionListResponse![index]
                                                  .transactionStatus ==
                                              'SUCCESS'
                                          ? ColorsUtils.green
                                          : ColorsUtils.accent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      child: Text(
                                        '${transactionListResponse![index].transactionStatus ?? ""}',
                                        // transactionListResponse[index]
                                        //             .transactionstatusId
                                        //             .toString() ==
                                        //         '1'
                                        //     ? 'Inprogress'
                                        //     : transactionListResponse[index]
                                        //                 .transactionstatusId
                                        //                 .toString() ==
                                        //             '2'
                                        //         ? 'Failed'
                                        //         : transactionListResponse[index]
                                        //                     .transactionstatusId
                                        //                     .toString() ==
                                        //                 '3'
                                        //             ? 'Success'
                                        //             : transactionListResponse[
                                        //                             index]
                                        //                         .transactionstatusId
                                        //                         .toString() ==
                                        //                     '4'
                                        //                 ? 'Refund'
                                        //                 : transactionListResponse[
                                        //                                 index]
                                        //                             .transactionstatusId
                                        //                             .toString() ==
                                        //                         '5'
                                        //                     ? 'Pending'
                                        //                     : transactionListResponse[
                                        //                                     index]
                                        //                                 .transactionstatusId
                                        //                                 .toString() ==
                                        //                             '6'
                                        //                         ? 'Onhold'
                                        //                         : 'Rejected',
                                        style: ThemeUtils.blackRegular.copyWith(
                                            fontSize: FontUtils.verySmall,
                                            color: ColorsUtils.white),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${double.parse(transactionListResponse![index].transactionAmount.toString()).toStringAsFixed(2)} QAR',
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
        },
      ),
    );
  }

  // Expanded disputeTabListData() {
  //   return Expanded(
  //     child: ListView.builder(
  //       padding: EdgeInsets.zero,
  //       shrinkWrap: true,
  //       controller: _scrollController,
  //       itemCount: disputeTransactionResponse!.length,
  //       scrollDirection: Axis.vertical,
  //       itemBuilder: (context, index) {
  //         return Column(
  //           children: [
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
  //               child: InkWell(
  //                 onTap: () {
  //                   Utility.isDisputeDetailTransaction = true;
  //                   Get.to(() => TransactionDetailScreen(
  //                         id: disputeTransactionResponse![index]
  //                             .transactionId
  //                             .toString(),
  //                       ));
  //                 },
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                         decoration: BoxDecoration(
  //                             color: ColorsUtils.lightBg,
  //                             borderRadius: BorderRadius.circular(15)),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 10, vertical: 10),
  //                           child: Image.asset(
  //                             Images.transactionMenu,
  //                             width: 25,
  //                             height: 25,
  //                           ),
  //                         )),
  //                     width10(),
  //                     Expanded(
  //                         flex: 4,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: Text(
  //                                     'ID: ${disputeTransactionResponse![index].transaction!.invoicenumber}',
  //                                     maxLines: 2,
  //                                     overflow: TextOverflow.ellipsis,
  //                                     style: ThemeUtils.blackBold
  //                                         .copyWith(fontSize: FontUtils.small),
  //                                   ),
  //                                 ),
  //                                 // InkWell(
  //                                 //   onTap: () {
  //                                 //     bottomSheetforDownloadAndRefund(
  //                                 //         context, index);
  //                                 //   },
  //                                 //   child: const Icon(
  //                                 //     Icons.more_vert,
  //                                 //   ),
  //                                 // )
  //                               ],
  //                             ),
  //                             height10(),
  //                             disputeTransactionResponse![index].transaction ==
  //                                     null
  //                                 ? SizedBox()
  //                                 : Text(
  //                                     disputeTransactionResponse![index]
  //                                                 .transaction!
  //                                                 .transactionmodeId ==
  //                                             1
  //                                         ? 'Credit Card'
  //                                         : disputeTransactionResponse![index]
  //                                                     .transaction!
  //                                                     .transactionmodeId ==
  //                                                 2
  //                                             ? 'Debit Card'
  //                                             : 'Sadad',
  //                                     style: ThemeUtils.blackRegular
  //                                         .copyWith(fontSize: FontUtils.small),
  //                                   ),
  //                             height10(),
  //                             Text(
  //                               textDirection: TextDirection.ltr,
  //                               '${intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(disputeTransactionResponse![index].transaction!.created.toString()))}',
  //                               style: ThemeUtils.blackRegular.copyWith(
  //                                   fontSize: FontUtils.small,
  //                                   color: ColorsUtils.grey),
  //                             ),
  //                             height10(),
  //                             Row(
  //                               children: [
  //                                 Container(
  //                                   decoration: BoxDecoration(
  //                                     color: disputeTransactionResponse![index]
  //                                                 .disputestatus!
  //                                                 .id ==
  //                                             1
  //                                         ? ColorsUtils.green
  //                                         : disputeTransactionResponse![index]
  //                                                     .disputestatus!
  //                                                     .id ==
  //                                                 2
  //                                             ? ColorsUtils.yellow
  //                                             : disputeTransactionResponse![
  //                                                             index]
  //                                                         .disputestatus!
  //                                                         .id ==
  //                                                     3
  //                                                 ? ColorsUtils.accent
  //                                                 : ColorsUtils.accent,
  //                                     borderRadius: BorderRadius.circular(15),
  //                                   ),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.symmetric(
  //                                         vertical: 2, horizontal: 10),
  //                                     child: Text(
  //                                       disputeTransactionResponse![index]
  //                                           .disputestatus!
  //                                           .name,
  //                                       style: ThemeUtils.blackRegular.copyWith(
  //                                           fontSize: FontUtils.verySmall,
  //                                           color: ColorsUtils.white),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 const Spacer(),
  //                                 Text(
  //                                   '${disputeTransactionResponse![index].amount} QAR',
  //                                   style: ThemeUtils.blackBold.copyWith(
  //                                       fontSize: FontUtils.mediumSmall,
  //                                       color: ColorsUtils.accent),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ))
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             const Divider()
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  // void bottomSheetforDownloadAndRefund(BuildContext context, int index) {
  //   showModalBottomSheet<void>(
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(15), topRight: Radius.circular(15))),
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setBottomState) {
  //           return Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 20),
  //                   child: Align(
  //                     alignment: Alignment.center,
  //                     child: SizedBox(
  //                       width: 70,
  //                       height: 5,
  //                       child: Divider(color: ColorsUtils.border, thickness: 4),
  //                     ),
  //                   ),
  //                 ),
  //                 height20(),
  //                 InkWell(
  //                   onTap: () {
  //                     downloadFile(
  //                       context: context,
  //                       isRadioSelected: 1,
  //                       isEmail: false,
  //                       url: '',
  //                     );
  //                     // url:
  //                     //     '${Utility.baseUrl}transactions/downloadReceipt?transactionId=${selectedTab == 2 ? disputeTransactionResponse![index].transaction!.invoicenumber : transactionListResponse![index].transactionId}&isPOS=false');
  //                   },
  //                   child: Row(
  //                     children: [
  //                       Image.asset(
  //                         Images.download,
  //                         width: 25,
  //                         height: 25,
  //                         color: ColorsUtils.black,
  //                       ),
  //                       width20(),
  //                       Text(
  //                         'Download Receipt'.tr,
  //                         style: ThemeUtils.blackSemiBold
  //                             .copyWith(fontSize: FontUtils.mediumSmall),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 // transactionListResponse![index]
  //                 //                 .transactionstatusId
  //                 //                 .toString() ==
  //                 //             '3' &&
  //                 //         selectedTab == 0 &&
  //                 //         transactionListResponse![index].isRefund == false
  //                 //     ? const Padding(
  //                 //         padding: EdgeInsets.symmetric(vertical: 5),
  //                 //         child: Divider(),
  //                 //       )
  //                 //     : SizedBox(),
  //                 // transactionListResponse![index]
  //                 //                 .transactionstatusId
  //                 //                 .toString() ==
  //                 //             '3' &&
  //                 //         selectedTab == 0 &&
  //                 //         transactionListResponse![index].isRefund == false
  //                 //     ? InkWell(
  //                 //         onTap: () {
  //                 //           Map<String, dynamic> transactionDetail = {
  //                 //             'id':
  //                 //                 transactionListResponse![index].invoicenumber,
  //                 //             'type': transactionListResponse![index].cardtype,
  //                 //             'amount': transactionListResponse![index].amount,
  //                 //             'isCredit': transactionListResponse![index]
  //                 //                 .transactionmode!
  //                 //                 .id,
  //                 //             'PriorAmount': transactionListResponse![index]
  //                 //                 .priorRefundRequestedAmount
  //                 //           };
  //                 //           print('id is ${transactionDetail['id']}');
  //                 //           Get.to(() => RefundTransactionScreen(
  //                 //                 transactionDetail: transactionDetail,
  //                 //               ));
  //                 //         },
  //                 //         child: Row(
  //                 //           children: [
  //                 //             Image.asset(
  //                 //               Images.refund,
  //                 //               width: 25,
  //                 //               height: 25,
  //                 //               color: ColorsUtils.black,
  //                 //             ),
  //                 //             width20(),
  //                 //             Text(
  //                 //               'Refund'.tr,
  //                 //               style: ThemeUtils.blackSemiBold
  //                 //                   .copyWith(fontSize: FontUtils.mediumSmall),
  //                 //             )
  //                 //           ],
  //                 //         ),
  //                 //       )
  //                 //     : SizedBox(),
  //                 // height40()
  //               ],
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  initData({bool? fromSearch = false}) async {
    email = await encryptedSharedPreferences.getString('email');

    filterDate =
        '&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse('${widget.startDate}'))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse('${widget.endDate}'))}';
    setState(() {
      filterData = filterDate +
          Utility.transactionFilterStatus +
          (Utility.transactionFilterStatus == ''
              ? Utility.transactionFilterTransactionType
              : '') +
          Utility.transactionFilterTransactionModes +
          Utility.transactionFilterPaymentMethod +
          Utility.transactionFilterTransactionSources +
          Utility.transactionFilterIntegrationType +
          ('${searchKey != '' ? selectedType.contains('Transaction ID') ? '&filter[where][invoicenumber][like]=%25$searchKey%' : selectedType.contains('RRN') ? '&filter[where][rrn]=$searchKey' : selectedType.contains('Auth Number') ? '&filter[where][authNumber]=$searchKey' : '' : ''}');
    });
    scrollData();

    transactionViewModel.clearResponseList();

    ///api calling.......
    await apiCalling(fromSearch: fromSearch);

    if (isPageFirst == true) {
      isPageFirst = false;
    }
  }

  Future<void> apiCalling({bool? fromSearch}) async {
    await transactionViewModel.transactionReportList(
        filter: filterData, fromSearch: fromSearch);
  }

  void scrollData() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !transactionViewModel.isPaginationLoading) {
          transactionViewModel.transactionReportList(
              filter: filterData, fromSearch: false);
        }
      });
  }
}
