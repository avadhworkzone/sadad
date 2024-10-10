import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/pospaymentResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/transaction/dispute/filterPosDisputesTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/dispute/posDisputeTransactionScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/filterPosPaymentTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/posTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/filterPosRefundTransaction.dart';
import 'package:sadad_merchat_app/view/pos/transaction/refund/posRefundTransactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';
import 'package:http/http.dart' as http;

class PosTransactionSearchReport extends StatefulWidget {
  String? startDate;
  String? endDate;
  String? selectedType;
  PosTransactionSearchReport(
      {Key? key, this.endDate, this.selectedType, this.startDate})
      : super(key: key);

  @override
  State<PosTransactionSearchReport> createState() =>
      _PosTransactionSearchReportState();
}

class _PosTransactionSearchReportState extends State<PosTransactionSearchReport>
    with TickerProviderStateMixin {
  bool isPageFirst = false;
  late TabController tabController;
  ScrollController? _scrollController;
  int selectedTab = 0;
  String? id = '';
  String? name = '';
  String? date = '';
  String? payment = '';
  String? amount = '';
  String? img = '';
  String? filterDate = '';
  String? tranStatusId = '';
  int isRadioSelected = 0;
  bool sendEmail = false;
  String? searchKey;
  TextEditingController search = TextEditingController();

  String email = '';
  PosTransactionViewModel posTransactionViewModel = Get.find();
  List<PosPaymentResponseModel>? posPaymentRes;
  List<PosDisputesResponseModel>? posDisputesRes;
  PosRentalResponseModel? posRentalRes;
  PosPaymentCountResponseModel? posPaymentCountRes;
  PosDisputesCountResponseModel? posDisputeCountRes;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  String? transactionEntityId;
  String? transactionStatus;
  String? include;
  String rentalFilter = '';
  @override
  void initState() {
    initData();
    tabController = TabController(length: 3, vsync: this);
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
    return Scaffold(body: GetBuilder<PosTransactionViewModel>(
      builder: (controller) {
        if (controller.posPaymentListApiResponse.status == Status.LOADING ||
            controller.posPaymentListApiResponse.status == Status.INITIAL ||
            controller.posDisputesListApiResponse.status == Status.LOADING ||
            controller.posDisputeCountApiResponse.status == Status.LOADING ||
            controller.posRentalListApiResponse.status == Status.LOADING) {
          return const Center(
            child: Loader(),
          );
        }
        if (controller.posPaymentListApiResponse.status == Status.ERROR ||
            controller.posDisputesListApiResponse.status == Status.ERROR ||
            controller.posPaymentCountApiResponse.status == Status.ERROR ||
            controller.posDisputeCountApiResponse.status == Status.ERROR ||
            controller.posRentalListApiResponse.status == Status.ERROR) {
          // return const Center(
          //   child: Text('Error'),
          // );
          return SessionExpire();
        }
        posPaymentRes = posTransactionViewModel.posPaymentListApiResponse.data;
        posDisputesRes =
            posTransactionViewModel.posDisputesListApiResponse.data;
        posPaymentCountRes =
            posTransactionViewModel.posPaymentCountApiResponse.data;
        posDisputeCountRes =
            posTransactionViewModel.posDisputeCountApiResponse.data;

        return Column(
          children: [
            height60(),
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
                            hintText:
                                'ex. customer name,phone,invoice no,amount,id......'
                                    .tr,
                            hintStyle: ThemeUtils.blackRegular.copyWith(
                                color: ColorsUtils.grey,
                                fontSize: FontUtils.small)),
                      ),
                    ),
                  ),
                  search.text.isEmpty ? const SizedBox() : width10(),
                  search.text.isEmpty
                      ? const SizedBox()
                      : InkWell(
                          onTap: () async {
                            selectedTab == 0
                                ? await Get.to(() => FilterPosPaymentScreen())
                                : selectedTab == 1
                                    ? await Get.to(
                                        () => const FilterPosRefundScreen())
                                    : await Get.to(
                                        () => const FilterPosDisputesScreen());
                            initData();
                          },
                          child: Image.asset(Images.filter,
                              height: 20,
                              color: selectedTab == 2
                                  ?

                                  ///pos transaction
                                  Utility.posDisputeTransactionStatusFilter
                                              .isNotEmpty ||
                                          Utility
                                              .posDisputeTransactionTypeFilter
                                              .isNotEmpty
                                      ? ColorsUtils.accent
                                      : ColorsUtils.black
                                  : selectedTab == 3
                                      ? Utility.posRentalPaymentStatusFilter
                                              .isNotEmpty
                                          ? ColorsUtils.accent
                                          : ColorsUtils.black
                                      : selectedTab == 0
                                          ? Utility.posPaymentTransactionStatusFilter.isNotEmpty ||
                                                  Utility
                                                      .posPaymentCardEntryTypeFilter
                                                      .isNotEmpty ||
                                                  Utility
                                                      .posPaymentTransactionTypeFilter
                                                      .isNotEmpty ||
                                                  Utility
                                                      .posPaymentPaymentMethodFilter
                                                      .isNotEmpty ||
                                                  Utility
                                                      .posPaymentTransactionModesFilter
                                                      .isNotEmpty
                                              ? ColorsUtils.accent
                                              : ColorsUtils.black
                                          : selectedTab == 1
                                              ? Utility.posRefundTransactionModesFilter.isNotEmpty ||
                                                      Utility
                                                          .posRefundCardEntryTypeFilter
                                                          .isNotEmpty ||
                                                      Utility
                                                          .posRefundPaymentMethodFilter
                                                          .isNotEmpty ||
                                                      Utility
                                                          .posRefundTransactionStatusFilter
                                                          .isNotEmpty
                                                  ? ColorsUtils.accent
                                                  : ColorsUtils.black
                                              : ColorsUtils.black),
                        ),
                ],
              ),
            ),
            search.text.isEmpty
                ? Expanded(child: Center(child: Text('No data found'.tr)))
                : Expanded(
                    child: Column(
                      children: [
                        height20(),
                        Container(
                            height: 1,
                            width: Get.width,
                            color: ColorsUtils.border),
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
                                        : posPaymentRes!.isEmpty
                                            ? Get.showSnackbar(GetSnackBar(
                                                message: 'No Data Found'.tr,
                                              ))
                                            : exportBottomSheet();
                                  },
                                  child: Container(
                                    color: ColorsUtils.accent,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            Images.download,
                                            height: 20,
                                          ),
                                          Text(
                                            'Download'.tr,
                                            style: ThemeUtils.blackSemiBold
                                                .copyWith(
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
                        Container(
                            height: 1,
                            width: Get.width,
                            color: ColorsUtils.border),
                        tabBar(),
                        bottomListView(),
                      ],
                    ),
                  )
          ],
        );
      },
    ));
  }

  Widget bottomListView() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: customSmallSemiText(
                title:
                    '${selectedTab == 2 ? posDisputeCountRes!.count ?? '0' : selectedTab == 3 ? posRentalRes!.totalinvoices ?? "0" : posPaymentCountRes == null ? '0' : posPaymentCountRes!.count ?? "0"} ${'Payments'.tr}',
                color: ColorsUtils.black),
          ),
          if (selectedTab == 0)
            posPaymentRes!.isEmpty ? noDataFound() : ListofData(),
          if (selectedTab == 1)
            posPaymentRes!.isEmpty ? noDataFound() : ListofData(),
          if (selectedTab == 2)
            posDisputesRes!.isEmpty ? noDataFound() : ListofData(),
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
            setState(() {});
          },
          labelStyle:
              ThemeUtils.blackSemiBold.copyWith(color: ColorsUtils.white),
          unselectedLabelColor: ColorsUtils.white,
          labelColor: ColorsUtils.white,
          labelPadding: const EdgeInsets.all(3),
          tabs: [
            Tab(text: "Payments".tr),
            Tab(text: "Refunds".tr),
            Tab(text: "Disputes".tr),
          ],
        ));
  }

  Center noDataFound() => const Center(child: Text('No data found'));

  Expanded ListofData() {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: selectedTab == 2
            ? posDisputesRes!.length
            : selectedTab == 3
                ? posTransactionViewModel.rentalResponse.length
                : posPaymentRes!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          allListValue(index);

          if (searchKey != null && searchKey != "") {
            if (id!.toLowerCase().contains(searchKey!.toLowerCase())) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      selectedTab == 0
                          ? Get.to(() => PosTransactionDetailScreen(
                              id: posPaymentRes![index].id.toString()))
                          : selectedTab == 1
                              ? Get.to(() => PosRefundTransactionScreen(
                                    id: posPaymentRes![index].id.toString(),
                                  ))
                              : Get.to(() => PosDisputeTransactionScreen(
                                    id: posDisputesRes![index].id.toString(),
                                  ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
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
                                child:
                                    Image.asset(img!, height: 30, width: 30)),
                          ),
                          width10(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    customSmallMedBoldText(
                                        color: ColorsUtils.black,
                                        title: 'ID: $id'),
                                    const Spacer(),
                                    const Icon(Icons.more_vert),
                                  ],
                                ),
                                height5(),
                                customSmallSemiText(
                                    title: '$name', color: ColorsUtils.black),
                                height10(),
                                customSmallSemiText(
                                    title: '$date', color: ColorsUtils.grey),
                                height10(),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: selectedTab == 2
                                            ? tranStatusId == '1'
                                                ? ColorsUtils.green
                                                : tranStatusId == '2'
                                                    ? ColorsUtils.yellow
                                                    : ColorsUtils.accent
                                            : tranStatusId == '1'
                                                ? ColorsUtils.yellow
                                                : tranStatusId == '2'
                                                    ? ColorsUtils.reds
                                                    : tranStatusId == '3'
                                                        ? ColorsUtils.green
                                                        : tranStatusId == '4'
                                                            ? ColorsUtils.green
                                                            : tranStatusId ==
                                                                    '5'
                                                                ? ColorsUtils
                                                                    .yellow
                                                                : tranStatusId ==
                                                                        '6'
                                                                    ? ColorsUtils
                                                                        .blueBerryPie
                                                                    : ColorsUtils
                                                                        .accent,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        child: customVerySmallSemiText(
                                            color: ColorsUtils.white,
                                            title: selectedTab == 1
                                                ? payment == 'PENDING'
                                                    ? 'REQUESTED'
                                                    : payment
                                                : '$payment'),
                                      ),
                                    ),
                                    selectedTab == 0
                                        ? Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: SizedBox(
                                                    width: 1,
                                                    height: 25,
                                                    child: VerticalDivider()),
                                              ),
                                              customVerySmallSemiText(
                                                  title: 'Rental'.tr,
                                                  color: ColorsUtils.black),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: SizedBox(
                                                    width: 1,
                                                    height: 25,
                                                    child: VerticalDivider()),
                                              ),
                                            ],
                                          )
                                        : SizedBox(),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        selectedTab == 1
                                            ? customVerySmallSemiText(
                                                color: ColorsUtils.black,
                                                title: 'Refund Amount'.tr)
                                            : const SizedBox(),
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
            } else {
              return SizedBox();
            }
          }

          return SizedBox();
        },
      ),
    );
  }

  void allListValue(int index) {
    if (selectedTab == 2) {
      id = '${posDisputesRes![index].disputeId ?? 'NA'}';
      name = '${posDisputesRes![index].disputetype!.name ?? "NA"}';
      date = '${posDisputesRes![index].created ?? "NA"}';

      //${DateFormat('dd MM yyyy, HH:mm:ss').format(DateTime.parse(posDisputesRes![index].created.toString()))}
      payment = '${posDisputesRes![index].disputestatus!.name ?? 'NA'}';
      tranStatusId = '${posDisputesRes![index].disputestatus!.id}';
      amount = '${posDisputesRes![index].amount ?? "0"}';
      img = Images.dispute;
    } else if (selectedTab == 3) {
      id = '${posTransactionViewModel.rentalResponse[index].invoiceno ?? "NA"}';

      name =
          '${posTransactionViewModel.rentalResponse[index].transaction!.transactionentity!.name ?? 'NA'}';
      date = intl.DateFormat('dd MMM yyyy, HH:ss:mm').format(DateTime.parse(
          posTransactionViewModel.rentalResponse[index].created.toString()));
      payment =
          '${posTransactionViewModel.rentalResponse[index].transaction!.transactionstatus!.name ?? "NA"}';
      tranStatusId =
          '${posTransactionViewModel.rentalResponse[index].transaction!.transactionstatus!.id}';

      amount =
          '${posTransactionViewModel.rentalResponse[index].grossamount ?? "0"}';
      img = Images.posAccent;
    } else {
      id = '${posPaymentRes![index].invoicenumber ?? 'NA'}';
      name =
          '${posPaymentRes![index].postransaction!.cardPaymentType ?? ""} ${posPaymentRes![index].postransaction!.paymentMethod ?? ""} - ${posPaymentRes![index].postransaction!.cardType ?? ""} ';
      date = intl.DateFormat('dd MM yyyy, HH:mm:ss')
          .format(DateTime.parse(posPaymentRes![index].created.toString()));
      payment = '${posPaymentRes![index].transactionstatus!.name ?? 'NA'}';
      tranStatusId = '${posPaymentRes![index].transactionstatus!.id}';
      amount = '${posPaymentRes![index].amount ?? "0"}';
      img = selectedTab == 0
          ? posPaymentRes![index].cardtype == 'MASTERCARD'
              ? Images.masterCard
              : posPaymentRes![index].cardtype == 'VISA'
                  ? Images.visaCard
                  : posPaymentRes![index].cardtype == 'GOOGLE PAY'
                      ? Images.googlePay
                      : posPaymentRes![index].cardtype == 'APPLE PAY'
                          ? Images.applePay
                          : Images.sadadWalletPay
          : selectedTab == 1
              ? Images.refundBack
              : selectedTab == 2
                  ? Images.dispute
                  : Images.posAccent;
    }
    // 'MASTERCARD'
    //     ? Images.masterCard
    //     : icon == 'VISA'
    //     ? Images.visaCard
    //     : icon == 'GOOGLE PAY'
    //     ? Images.googlePay
    //     : icon == 'APPLE PAY'
    //     ? Images.applePay
    //     : Images.sadadWalletPay
  }

  void initData() async {
    email = await encryptedSharedPreferences.getString('email');

    String userId = await encryptedSharedPreferences.getString('id');
    filterOfApi();
    posTransactionViewModel.clearResponseList();
    scrollData(userId);
    await apiCalling(userId);
  }

  Future<void> apiCalling(String userId) async {
    if (selectedTab == 2) {
      await posTransactionViewModel.disputesList(
          id: userId,
          isLoading: true,
          transactionStatus: transactionStatus,
          include: include,
          transactionEntityId: transactionEntityId);
      await posTransactionViewModel.disputeCount(
          id: userId,
          transactionStatus: transactionStatus,
          transactionEntityId: transactionEntityId);
    } else if (selectedTab == 3) {
      await posTransactionViewModel.rentalList(
          isLoading: true, filter: rentalFilter);
    } else {
      await posTransactionViewModel.paymentList(
          id: userId,
          isLoading: true,
          transactionStatus: transactionStatus,
          include: include,
          transactionEntityId: transactionEntityId);
      await posTransactionViewModel.paymentCount(
          id: userId,
          transactionStatus: transactionStatus,
          transactionEntityId: transactionEntityId);
    }
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
                      if (isRadioSelected == 0) {
                        Get.snackbar('error', 'Please select Format!'.tr);
                      } else {
                        if (sendEmail == true) {
                          String token = await encryptedSharedPreferences
                              .getString('token');
                          final url = Uri.parse(
                              '${Utility.baseUrl}reporthistories/${widget.selectedType}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true&isEmail=true');
                          final request = http.Request("GET", url);
                          request.headers.addAll(<String, String>{
                            'Authorization': token,
                            'Content-Type': 'application/json'
                          });
                          request.body = '';
                          final res = await request.send();
                          if (res.statusCode == 200) {
                            print('res is ${res.statusCode}');
                            Get.snackbar('Success'.tr, 'send successFully'.tr);
                          } else {
                            print('error ::${res.request}');
                            Get.snackbar('error', '${res.request}');
                          }
                        } else {
                          await downloadFile(
                            isEmail: sendEmail,
                            isRadioSelected: isRadioSelected,
                            url:
                                '${Utility.baseUrl}reporthistories/${widget.selectedType}?filter[where][created][between][0]=${intl.DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(widget.startDate!))}&filter[where][created][between][1]=${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))} 23:59:59&filter[order]=created%20DESC&${isRadioSelected == 1 ? 'isPdf' : isRadioSelected == 2 ? 'isCsv' : 'isExcel'}=true',
                            context: context,
                          );
                        }
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

  void filterOfApi() {
    filterDate =
        ',{"created":{"between":["${widget.startDate}","${intl.DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.endDate!))}, 23:59:59"]}}';
    if (selectedTab == 0) {
      include =
          '[{"relation":"senderId"},{"relation":"receiverId"},{"relation":"guestuser"},{"relation":"transactionentity"},{"relation":"transactionmode"},{"relation":"transactionstatus"},{"relation":"dispute"},{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}]';
      transactionEntityId = '{"transactionentityId": { "eq": [17] }},';
      transactionStatus = (Utility.posPaymentTransactionStatusFilter == ''
              ? '{"transactionstatusId":{"inq":[1,2,3,6]}}'
              : '') +
          Utility.posPaymentTransactionStatusFilter +
          Utility.posPaymentCardEntryTypeFilter +
          Utility.posPaymentTransactionModesFilter +
          Utility.posPaymentPaymentMethodFilter +
          Utility.posPaymentTransactionTypeFilter +
          filterDate!;
      //{"created":{"between":["2022-06-01 00:00:00","2022-06-17 23:59:59"]}}
    } else if (selectedTab == 1) {
      include =
          '[{"relation":"senderId"},{"relation":"receiverId"},{"relation":"guestuser"},{"relation":"transactionentity"},{"relation":"transactionmode"},{"relation":"transactionstatus"},{"relation":"dispute"},{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}]';
      transactionEntityId = '{"transactionentityId":  17 }, ';
      transactionStatus = '{"is_reversed":true}' +
          Utility.posRefundTransactionModesFilter +
          Utility.posRefundCardEntryTypeFilter +
          Utility.posRefundPaymentMethodFilter +
          Utility.posRefundTransactionStatusFilter +
          filterDate!;
    } else if (selectedTab == 2) {
      include =
          '["senderId","receiverId","transaction"],"include":[{"relation":"disputestatus","fields":["name"]},{"relation":"disputetype","fields":["name"]},{"relation":"senderId"},{"relation":"receiverId"},{"relation":"transaction","scope":{"include":{"relation":"postransaction","scope":{"include":{"relation":"terminal","scope":{"include":{"relation":"posdevice"}}}}}}}]';
      transactionEntityId = '';
      transactionStatus = '{"isPOS":true}' +
          Utility.posDisputeTransactionTypeFilter +
          Utility.posDisputeTransactionStatusFilter +
          filterDate!;
    }
  }

  void scrollData(id) async {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !posTransactionViewModel.isPaginationLoading) {
          if (selectedTab == 2) {
            posTransactionViewModel.disputesList(
                id: id,
                isLoading: false,
                transactionStatus: transactionStatus,
                include: include,
                transactionEntityId: transactionEntityId);
          } else if (selectedTab == 3) {
            posTransactionViewModel.rentalList(
                isLoading: false, filter: rentalFilter);
          } else {
            posTransactionViewModel.paymentList(
                id: id,
                isLoading: false,
                transactionStatus: transactionStatus,
                include: include,
                transactionEntityId: transactionEntityId);
          }
        }
      });
  }
}
