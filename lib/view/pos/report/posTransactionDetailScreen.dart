// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/posPaymentReportTransactionResModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/pospaymentResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/report/posTransactionReortFilter.dart';
import 'package:sadad_merchat_app/view/pos/report/posTransactionSearchReport.dart';
import 'package:sadad_merchat_app/view/pos/transaction/dispute/filterPosDisputesTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/dispute/posDisputeTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/filterPosPaymentTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/posTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/filterPosRefundTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/posRefundTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/rental/filterPosRentalTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/rental/posRentalTransactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';

class PosReportTransactionDetailScreen extends StatefulWidget {
  String? startDate;
  String? endDate;
  String? selectedType;
  PosReportTransactionDetailScreen(
      {Key? key, this.endDate, this.selectedType, this.startDate})
      : super(key: key);

  @override
  State<PosReportTransactionDetailScreen> createState() =>
      _PosReportTransactionDetailScreen();
}

class _PosReportTransactionDetailScreen
    extends State<PosReportTransactionDetailScreen>
    with TickerProviderStateMixin {
  bool isPageFirst = false;
  late TabController tabController;
  ScrollController? _scrollController;
  int selectedTab = 0;
  bool isSearchClick = false;
  String? id = '';
  String? searchKey;
  String? name = '';
  String? date = '';
  String? payment = '';
  String? amount = '';
  String? img = '';
  String filterDate = '';
  String customDate = '';
  String rentalFilterDate = '';
  String? tranStatusId = '';
  int isRadioSelected = 3;
  bool sendEmail = false;

  String email = '';
  List transactionTypeFilter = [];
  List terminalFilter = [];
  List selectedType = ['Transaction ID'];
  PosTransactionViewModel posTransactionViewModel = Get.find();
  //List<PosPaymentResponseModel>? posPaymentRes;
  List<PosPaymentReportResponseModel>? posPaymentReportRes;
  List<PosDisputesResponseModel>? posDisputesRes;
  PosRentalResponseModel? posRentalRes;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  String? transactionEntityId;
  String? transactionStatus;
  String? include;
  String rentalFilter = '';
  ConnectivityViewModel connectivityViewModel = Get.find();
  TextEditingController search = TextEditingController();
  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    initData();
    // tabController = TabController(length: 4, vsync: this);
    // TODO: implement initState
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
            height60(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        if (isSearchClick == true) {
                          isSearchClick = false;
                          initData();
                          search.clear();
                          searchKey = '';
                          setState(() {});
                        } else {
                          Get.back();
                        }
                      },
                      child: const Icon(Icons.arrow_back_ios)),
                  isSearchClick ? SizedBox() : Spacer(),
                  isSearchClick == true
                      ? Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              onChanged: (value) async {
                                searchKey = value;
                                setState(() {});
                                initData(fromSearch: true);
                              },
                              controller: search,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  isDense: true,
                                  prefixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSearchClick = !isSearchClick;
                                      });
                                    },
                                    child: Image.asset(
                                      Images.search,
                                      scale: 3,
                                    ),
                                  ),
                                  suffixIcon: search.text.isEmpty
                                      ? const SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            searchKey = '';
                                            search.clear();
                                            setState(() {});
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
                        )
                      : Text('POS Transactions',
                          style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.medLarge,
                          )),
                  isSearchClick == true ? SizedBox() : const Spacer(),
                  isSearchClick == true
                      ? SizedBox()
                      : InkWell(
                          onTap: () {
                            // Get.to(() => PosTransactionSearchReport(
                            //       selectedType: widget.selectedType,
                            //       startDate: widget.startDate,
                            //       endDate: widget.endDate,
                            //     ));
                            setState(() {
                              isSearchClick = !isSearchClick;
                            });
                          },
                          child: Image.asset(
                            Images.search,
                            height: 20,
                            width: 20,
                          ),
                        ),
                  width20(),
                  InkWell(
                    onTap: () async {
                      // selectedTab == 0
                      //     ?
                      await Get.to(() => FilterPosTransactionReportScreen());
                      // : selectedTab == 1
                      //     ? await Get.to(
                      //         () => const FilterPosRefundScreen())
                      //     : selectedTab == 2
                      //         ? await Get.to(
                      //             () => const FilterPosDisputesScreen())
                      //         : await Get.to(() =>
                      //             const FilterRentalPosTransaction());
                      // widget.terminalFilter = '';
                      setState(() {});
                      initData();
                    },
                    child: Image.asset(Images.filter,
                        height: 20,
                        color:
                            Utility.posPaymentTransactionStatusFilter != '' ||
                                    Utility.posPaymentCardEntryTypeFilter !=
                                        '' ||
                                    Utility.posPaymentTransactionTypeFilter !=
                                        '' ||
                                    Utility.posPaymentPaymentMethodFilter !=
                                        '' ||
                                    Utility.posPaymentTransactionModesFilter !=
                                        '' ||
                                    Utility.posPaymentTerminalSelectionFilter
                                        .isNotEmpty ||
                                    Utility
                                        .posPaymentTransactionTypeTerminalFilter
                                        .isNotEmpty ||
                                    Utility.posDisputeTransactionStatusFilter !=
                                        '' ||
                                    Utility.deviceFilterDeviceStatus != '' ||
                                    Utility.deviceFilterDeviceType != '' ||
                                    Utility.posRefundTransactionStatusFilter !=
                                        ''
                                ? ColorsUtils.accent
                                : ColorsUtils.black),
                  ),
                ],
              ),
            ),
            isSearchClick == true ? SizedBox() : height20(),
            isSearchClick == false
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
                                  StaticData().posTrnxReportType.length,
                                  (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: InkWell(
                                          onTap: () async {
                                            selectedType.clear();
                                            searchKey = '';
                                            search.clear();
                                            selectedType.add(StaticData()
                                                .posTrnxReportType[index]);
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
                                                                .posTrnxReportType[
                                                            index])
                                                    ? ColorsUtils.primary
                                                    : ColorsUtils.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                StaticData()
                                                    .posTrnxReportType[index]
                                                    .tr,
                                                style: ThemeUtils.blackBold.copyWith(
                                                    fontSize:
                                                        FontUtils.verySmall,
                                                    color: selectedType.contains(
                                                            StaticData()
                                                                    .posTrnxReportType[
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
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: customSmallSemiText(
                              title:
                                  '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.startDate!))}'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customSmallBoldText(title: 'To'.tr),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: customSmallSemiText(
                              title:
                                  '${intl.DateFormat('dd MMM yy').format(DateTime.parse(widget.endDate!))}'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        selectedTab == 2
                            ? posDisputesRes!.isEmpty
                            : posPaymentReportRes!.isEmpty
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
            height20(),
            Expanded(
              child: GetBuilder<PosTransactionViewModel>(
                builder: (controller) {
                  if (controller.posPaymentReportListApiResponse.status ==
                          Status.LOADING ||
                      controller.posPaymentReportListApiResponse.status ==
                          Status.INITIAL ||
                      controller.posDisputesListApiResponse.status ==
                          Status.LOADING ||
                      controller.posDisputeCountApiResponse.status ==
                          Status.LOADING ||
                      controller.posRentalListApiResponse.status ==
                          Status.LOADING) {
                    return const Center(
                      child: Loader(),
                    );
                  }
                  if (controller.posPaymentReportListApiResponse.status ==
                          Status.ERROR ||
                      controller.posDisputesListApiResponse.status ==
                          Status.ERROR ||
                      controller.posPaymentCountApiResponse.status ==
                          Status.ERROR ||
                      controller.posDisputeCountApiResponse.status ==
                          Status.ERROR ||
                      controller.posRentalListApiResponse.status ==
                          Status.ERROR) {
                    // return const Center(
                    //   child: Text('Error'),
                    // );
                    return SessionExpire();
                  }
                  posPaymentReportRes = posTransactionViewModel
                      .posPaymentReportListApiResponse.data;
                  posDisputesRes =
                      posTransactionViewModel.posDisputesListApiResponse.data;
                  posRentalRes =
                      posTransactionViewModel.posRentalListApiResponse.data;

                  return Column(
                    children: [bottomListView()],
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
              tabController = TabController(length: 3, vsync: this);
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

  Widget bottomListView() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedTab == 0)
            posPaymentReportRes!.isEmpty ? noDataFound() : ListofData(),
          if (posTransactionViewModel.isPaginationLoading && isPageFirst)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Center(child: Loader()),
            ),
          if (posTransactionViewModel.isPaginationLoading && !isPageFirst)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 0),
              child: Center(child: Loader()),
            ),
        ],
      ),
    );
  }

  Center noDataFound() => const Center(child: Text('No data found'));

  Expanded ListofData() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: posPaymentReportRes!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          allListValue(index);
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Get.to(() => PosTransactionDetailScreen(
                      id: posPaymentReportRes![index].id == null
                          ? ''
                          : posPaymentReportRes![index].id.toString()));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: Get.height * 0.07,
                        width: Get.width * 0.15,
                        decoration: BoxDecoration(
                          color: ColorsUtils.createInvoiceContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Image.asset(img!, height: 30, width: 30)),
                      ),
                      width10(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                customSmallMedBoldText(
                                    color: ColorsUtils.black, title: 'ID: $id'),
                                const Spacer(),
                              ],
                            ),
                            height5(),
                            customSmallSemiText(
                                title: '$name', color: ColorsUtils.black),
                            height10(),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: customSmallSemiText(
                                  title: '$date', color: ColorsUtils.grey),
                            ),
                            height10(),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: payment == 'SUCCESS'
                                        ? ColorsUtils.green
                                        : ColorsUtils.accent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    child: customVerySmallSemiText(
                                        color: ColorsUtils.white,
                                        title: '$payment'),
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    customSmallMedBoldText(
                                        title: '$amount QAR',
                                        color: ColorsUtils.accent),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Divider(),
              )
            ],
          );
        },
      ),
    );
  }

  void allListValue(int index) {
    id = '${posPaymentReportRes![index].transactionId ?? 'NA'}';
    var cardType = posPaymentReportRes![index].cardType ?? " ";
    if (cardType.toString().length > 0) {
      cardType = cardType.toString().capitalize;
    }
    cardType == '' || cardType == ' '
        ? name =
            '${posPaymentReportRes![index].cardEnteredType.replaceRange(0, 1, posPaymentReportRes![index].cardEnteredType[0].toUpperCase() ?? "")}'
        : name =
            '$cardType Card - ${posPaymentReportRes![index].cardEnteredType.replaceRange(0, 1, posPaymentReportRes![index].cardEnteredType[0].toUpperCase() ?? "")}';
    //- ${posPaymentReportRes![index].cardType ?? "" }
    date = intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.parse(
        posPaymentReportRes![index].transactionDateTime.toString()));
    payment = '${posPaymentReportRes![index].transactionStatus ?? 'NA'}';
    tranStatusId = '${posPaymentReportRes![index].transactionStatus ?? "NA"}';
    amount = '${posPaymentReportRes![index].transactionAmount ?? "0"}';
    img = selectedTab == 0
        ? posPaymentReportRes![index].paymentMethods == 'MASTERCARD'
            ? Images.masterCard
            : posPaymentReportRes![index].paymentMethods == 'VISA'
                ? Images.visaCard
                : posPaymentReportRes![index].paymentMethods == 'GOOGLE PAY'
                    ? Images.googlePay
                    : posPaymentReportRes![index].paymentMethods == 'APPLE PAY'
                        ? Images.applePay
                        : posPaymentReportRes![index].paymentMethods ==
                                'APPLE PAY'
                            ? Images.applePay
                            : posPaymentReportRes![index].paymentMethods ==
                                    'AMERICAN EXPRESS'
                                ? Images.amex
                                : posPaymentReportRes![index].paymentMethods ==
                                        'UPI'
                                    ? Images.upi
                                    : posPaymentReportRes![index]
                                                .paymentMethods ==
                                            'JCB'
                                        ? Images.jcb
                                        : posPaymentReportRes![index]
                                                    .paymentMethods ==
                                                'SADAD PAY'
                                            ? Images.sadadWalletPay
                                            : posPaymentReportRes![index]
                                                        .paymentMethods ==
                                                    'NAPS'
                                                ? Images.napsImage
                                                : Images.mobilePay

        //icon == 'MASTERCARD'
        //                 ? Images.masterCard
        //                 : icon == 'VISA'
        //                     ? Images.visaCard
        //                     : icon == 'GOOGLE PAY'
        //                         ? Images.googlePay
        //                         : icon == 'APPLE PAY'
        //                             ? Images.applePay
        //                             : icon == 'AMERICAN EXPRESS'
        //                                 ? Images.amex
        //                                 : icon == 'UPI'
        //                                     ? Images.upi
        //                                     : icon == 'JCB'
        //                                         ? Images.jcb
        //                                         : Images.sadadWalletPay,
        : selectedTab == 1
            ? Images.refundBack
            : selectedTab == 2
                ? Images.dispute
                : Images.posAccent;
  }

  void initData({bool fromSearch = false}) async {
    email = await encryptedSharedPreferences.getString('email');
    String userId = await encryptedSharedPreferences.getString('id');
    filterOfApi();
    posTransactionViewModel.clearResponseList();
    scrollData(userId);
    await apiCalling(userId, fromSearch);
  }

  Future<void> apiCalling(String userId, bool fromSearch) async {
    terminalFilter = [];
    transactionTypeFilter = [];
    if (Utility.posPaymentTerminalSelectionFilter.length > 0 ||
        Utility.posPaymentTerminalSelectionFilter.isNotEmpty) {
      if (Utility.posPaymentTerminalSelectionFilter.length > 1) {
        terminalFilter = [];
        Utility.posPaymentTerminalSelectionFilter.forEach((element) {
          terminalFilter.add(
              '&filter[where][tid][inq][${terminalFilter.length}]=$element');
          print("Element === ${element}check");
        });
      } else {
        terminalFilter = [];
        terminalFilter.add(
            '&filter[where][tid][inq][like]=${Utility.posPaymentTerminalSelectionFilter.first}');
      }
    }
    if (Utility.posPaymentTransactionTypeTerminalFilter.length > 0 ||
        Utility.posPaymentTransactionTypeTerminalFilter.isNotEmpty) {
      if (Utility.posPaymentTransactionTypeTerminalFilter.length > 1) {
        transactionTypeFilter = [];
        Utility.posPaymentTransactionTypeTerminalFilter.forEach((element) {
          transactionTypeFilter.add(
              '&filter[where][transaction_type][${transactionTypeFilter.length}]=$element');
          print("Element === $element");
        });
      } else {
        transactionTypeFilter = [];
        transactionTypeFilter.add(
            '&filter[where][transaction_type][like]=${Utility.posPaymentTransactionTypeTerminalFilter.first}');
      }
    }
    print("transactionTypeFilter=== ${transactionTypeFilter}");
    await posTransactionViewModel.paymentListReport(
        fromSearch: fromSearch,
        id: userId,
        isLoading: true,
        transactionStatus: transactionStatus,
        include: include,
        transactionType: (Utility
                        .posPaymentTransactionTypeTerminalFilter.length >
                    0 ||
                Utility.posPaymentTransactionTypeTerminalFilter.isNotEmpty)
            ? '${(transactionTypeFilter.toString().substring(1, transactionTypeFilter.toString().length - 1)).replaceAll(',', '').removeAllWhitespace}'
            : "",
        terminalFilter: (Utility.posPaymentTerminalSelectionFilter.length > 0 ||
                Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
            // ? ',{"terminalId":"${'${Utility.posPaymentTerminalSelectionFilter}'.replaceAll('[', '').replaceAll(']', '')}"}'
            ? '${(terminalFilter.toString().substring(1, terminalFilter.toString().length - 1)).replaceAll(',', '').removeAllWhitespace}'
            : "",
        transactionEntityId: transactionEntityId);
  }

  void filterOfApi() {
    print('tttrttt==sss>${Utility.posPaymentTransactionTypeTerminalFilter}');

    print('filterdate======>>>>${filterDate}');
    include =
        '[{"relation":"senderId"},{"relation":"receiverId"},{"relation":"guestuser"},{"relation":"transactionentity"},{"relation":"transactionmode"},{"relation":"transactionstatus"},{"relation":"dispute"},{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}]';
    transactionEntityId = '{"transactionentityId": { "eq": [17] }},';

    // transactionStatus = (Utility.posPaymentTransactionStatusFilter == ''
    //         ? '{"transactionstatusId":{"inq":[1,2,3,6]}}'
    //         : Utility.posPaymentTransactionStatusFilter) +
    //     Utility.posPaymentCardEntryTypeFilter +
    //     Utility.posPaymentTransactionModesFilter +
    //     Utility.posPaymentPaymentMethodFilter +
    //     ('filter[where][created][between][0]=2022-09-01 00:00:00&filter[where][created][between][1]=2022-10-01 23:59:59') +
    //     (Utility.posPaymentTransactionTypeTerminalFilter == [] ||
    //             Utility.posPaymentTransactionTypeTerminalFilter.isEmpty
    //         ? ''
    //         : ',{"transaction_type":"${Utility.posPaymentTransactionTypeTerminalFilter}"}'
    //             .replaceAll('[', '')
    //             .replaceAll(']', '')) +
    //     filterDate;
    print("WIDGIT.SatrtDate == ${widget.startDate}");
    print("WIDGIT.EndDate == ${widget.endDate}");
    transactionStatus = Utility.posPaymentTransactionStatusFilter +
        Utility.posPaymentCardEntryTypeFilter +
        Utility.posPaymentTransactionModesFilter +
        Utility.deviceFilterDeviceType +
        Utility.posRefundTransactionStatusFilter +
        Utility.deviceFilterDeviceStatus +
        Utility.posDisputeTransactionStatusFilter +
        Utility.posPaymentPaymentMethodFilter +
        ((searchKey != null && searchKey != '')
            ? selectedType.contains('Transaction ID')
                ? '&filter[where][invoicenumber][like]=%25$searchKey%'
                : selectedType.contains('Terminal Location')
                    ? '&filter[where][terminalLocation]=$searchKey'
                    : '&filter[where][rrn][like]=%25$searchKey%'
            : '') +
        ('&filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse(widget.endDate!))}') +
        // (Utility.posPaymentTransactionTypeTerminalFilter == [] ||
        //         Utility.posPaymentTransactionTypeTerminalFilter.isEmpty
        //     ? ''
        //     : '${(transactionTypeFilter.toString().substring(1, transactionTypeFilter.toString().length - 1)).replaceAll(',', '')}') +
        filterDate;
    //{"created":{"between":["2022-06-01 00:00:00","2022-06-17 23:59:59"]}}
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
                      //   String token = await encryptedSharedPreferences.getString('token');
                      //     final url = Uri.parse('http://176.58.99.102:3001/api-v1/products/$id');
                      //     Map<String, String> header = {
                      //       'Authorization': token,
                      //       'Content-Type': 'application/json'
                      //     };
                      //     var result = await http.delete(
                      //       url,
                      //       headers: header,
                      //     );
                      //     print(
                      //         'token is:$token \n req is : ${result.request}  \n response is :${result.body} ');
                      //     if (result.statusCode == 200) {
                      //       myProductListViewModel.deleteProductItem(id);
                      //     } else {
                      //       const SessionExpire();
                      //       // Get.snackbar('error', 'something Wrong');
                      //     }
                      connectivityViewModel.startMonitoring();
                      if (connectivityViewModel.isOnline != null) {
                        if (connectivityViewModel.isOnline!) {
                          if (sendEmail == true) {
                            String token = await encryptedSharedPreferences
                                .getString('token');
                            final url = Uri.parse(
                                '${Utility.baseUrl}reporthistories/${widget.selectedType}?filter[order]=created%20DESC${transactionStatus}&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true');
                            final request = http.Request("GET", url);
                            request.headers.addAll(<String, String>{
                              'Authorization': token,
                              'Content-Type': 'application/json'
                            });
                            print("url == $url");
                            request.body = '';
                            final res = await request.send();
                            if (res.statusCode == 200) {
                              print('res is ${res.statusCode}');
                              Get.snackbar(
                                  'Success'.tr, 'send successFully'.tr);
                            } else {
                              print('error ::${res.request}');
                              Get.snackbar('error', '${res.request}');
                            }
                          } else {
                            await downloadFile(
                              isEmail: sendEmail,
                              isRadioSelected: isRadioSelected,
                              name:
                                  'Transaction Report ${widget.startDate} to ${widget.endDate}',
                              url:
                                  '${Utility.baseUrl}reporthistories/${widget.selectedType}?filter[order]=created%20DESC${transactionStatus}&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
                              context: context,
                            );
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
                        text: 'DownLoad'.tr,
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

  void scrollData(id) async {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !posTransactionViewModel.isPaginationLoading) {
          posTransactionViewModel.paymentListReport(
              fromSearch: false,
              id: id,
              isLoading: false,
              transactionStatus: transactionStatus,
              include: include,
              transactionType: (Utility
                              .posPaymentTransactionTypeTerminalFilter.length >
                          0 ||
                      Utility
                          .posPaymentTransactionTypeTerminalFilter.isNotEmpty)
                  ? '${(transactionTypeFilter.toString().substring(1, transactionTypeFilter.toString().length - 1)).replaceAll(',', '').removeAllWhitespace}'
                  : "",
              terminalFilter: (Utility
                              .posPaymentTerminalSelectionFilter.length >
                          0 ||
                      Utility.posPaymentTerminalSelectionFilter.isNotEmpty)
                  ? '${(terminalFilter.toString().substring(1, terminalFilter.toString().length - 1)).replaceAll(',', '').removeAllWhitespace}'
                  : "",
              transactionEntityId: transactionEntityId);
        }
      });
  }
}
