// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/balanceListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityPosRendtalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/activityTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/activityWithdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/view/Activity/filterTransactionScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityViewModel.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';

class ActivityTransactionList extends StatefulWidget {
  const ActivityTransactionList({Key? key}) : super(key: key);

  @override
  State<ActivityTransactionList> createState() =>
      _ActivityTransactionListState();
}

class _ActivityTransactionListState extends State<ActivityTransactionList> {
  final now = DateTime.now();
  bool isPageFirst = true;
  ConnectivityViewModel connectivityViewModel = Get.find();
  bool sendEmail = false;
  String token = '';
  String email = '';
  ActivityViewModel activityViewModel = Get.find();
  BalanceListResponseModel balanceListRes = BalanceListResponseModel();
  ScrollController? _scrollController;
  DateTime selectedDate = DateTime.now();
  DateTime fromSelectDate = DateTime.now();

  String fromSelectedDate = '';
  String toSelectedDate = '';
  bool isAll = false;
  String filterDate = '';
  int isRadioSelected = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
    emailToken();
    scrollData();

    // TODO: implement initState
    super.initState();
  }

  emailToken() async {
    token = await encryptedSharedPreferences.getString('token');
    email = await encryptedSharedPreferences.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          height40(),

          ///upperbar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_ios)),
                width20(),
                const Spacer(),
                Text('Balance Statement',
                    style: ThemeUtils.blackBold.copyWith(
                      fontSize: FontUtils.medLarge,
                    )),
                const Spacer(),
                width20(),
                InkWell(
                    onTap: () async {
                      await Get.to(() => TransactionFilterActivityScreen());
                      initData();
                    },
                    child: Image.asset(Images.filter,
                        height: 20,
                        width: 20,
                        color: Utility.activityTransactionSources != '' ||
                                Utility.activityPaymentType != ''
                            ? ColorsUtils.accent
                            : ColorsUtils.black)),
              ],
            ),
          ),
          height20(),
          Container(height: 1, width: Get.width, color: ColorsUtils.border),

          ///from to selection
          SizedBox(
            height: Get.height * 0.08,
            width: Get.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                width20(),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      if (toSelectedDate != '' && fromSelectedDate != '') {
                        selectedDate = DateTime.parse(toSelectedDate);
                        fromSelectDate = DateTime.parse(fromSelectedDate);
                      } else {
                        selectedDate = DateTime.now();
                        fromSelectDate = DateTime.now();
                      }
                      await dateSelection(
                        context,
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        smallBoldText(text: 'From'.tr),
                        height10(),
                        smallSemiBoldText(
                          text: fromSelectedDate == ''
                              ? DateFormat('dd MMM yy').format(DateTime(
                                  now.year - 1, now.month, now.day, 23, 59, 59))
                              : DateFormat('dd MMM yy')
                                  .format(DateTime.parse(fromSelectedDate))
                                  .toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      await dateSelection(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        smallBoldText(text: 'To'.tr),
                        height10(),
                        smallSemiBoldText(
                          text: toSelectedDate == ''
                              ? '${DateFormat('dd MMM yy').format(DateTime(now.year, now.month, now.day, 23, 59, 59))}'
                              : DateFormat('dd MMM yy')
                                  .format(DateTime.parse(toSelectedDate))
                                  .toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                width50(),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      activityViewModel.response.isEmpty
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

          ///list transaction
          Expanded(
            child: GetBuilder<ActivityViewModel>(
              builder: (controller) {
                if (controller.balanceListApiResponse.status ==
                        Status.LOADING ||
                    controller.balanceListApiResponse.status ==
                        Status.INITIAL) {
                  return Loader();
                }
                if (controller.balanceListApiResponse.status == Status.ERROR) {
                  //return Center(child: Text('Error'));
                  return SessionExpire();
                }

                balanceListRes.data = controller.response;
                if (balanceListRes.data == null ||
                    balanceListRes.data == [] ||
                    balanceListRes.data!.isEmpty) {
                  return Center(child: Text('No data found'));
                }
                // print(
                //     '${DateFormat('dd mm yy').format(DateTime.parse('Oct 10, 2022 13:28:51'))}');
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount: balanceListRes.data!.length,
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  color: ColorsUtils.tabUnselect,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: customVerySmallSemiText(
                                      title:
                                          '${balanceListRes.data![index].date}'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: InkWell(
                                  onTap: () {
                                    print(
                                        '===>${balanceListRes.data![index].txnSource}');
                                    if (balanceListRes.data![index].txnSource ==
                                            'Settlement Withdrawal' ||
                                        balanceListRes.data![index].txnSource ==
                                            'Withdrawal') {
                                      Get.to(
                                          () => ActivityWithdrawalDetailScreen(
                                                id: balanceListRes
                                                    .data![index].transactionId
                                                    .toString(),
                                              ));
                                    } else if (balanceListRes
                                            .data![index].txnSource ==
                                        'POS Rental') {
                                      Get.to(() =>
                                          ActivityPosRentalTransactionScreen(
                                            id: balanceListRes
                                                .data![index].transactionId
                                                .toString(),
                                          ));
                                    } else if (balanceListRes
                                            .data![index].txnSource ==
                                        'SADAD Paid Services') {
                                      print('no route');
                                    } else if (balanceListRes
                                            .data![index].txnSource ==
                                        'Merchant Rewards') {
                                      print('no route');
                                    } else {
                                      Get.to(
                                          () => ActivityTransactionDetailScreen(
                                                id: balanceListRes
                                                    .data![index].transactionId
                                                    .toString(),
                                              ));
                                    }
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorsUtils.tabUnselect
                                              .withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(Images.invoice,
                                              width: Get.width * 0.06),
                                        ),
                                      ),
                                      width10(),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              customSmallBoldText(
                                                  title:
                                                      '${balanceListRes.data![index].txnSource ?? "NA"}'),
                                              Spacer(),
                                              customSmallBoldText(
                                                  color: ColorsUtils.accent,
                                                  title:
                                                      '${balanceListRes.data![index].txnAmount} QAR')
                                            ],
                                          ),
                                          height5(),
                                          customVerySmallNorText(
                                              title:
                                                  '${balanceListRes.data![index].txnType ?? 'NA'}'),
                                          height5(),
                                          Row(
                                            children: [
                                              customVerySmallNorText(
                                                  title:
                                                      'ID: ${balanceListRes.data![index].transactionId ?? "NA"}',
                                                  color: ColorsUtils.grey),
                                              Spacer(),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: (balanceListRes
                                                                    .data![
                                                                        index]
                                                                    .paymentIn ==
                                                                null ||
                                                            balanceListRes
                                                                    .data![
                                                                        index]
                                                                    .paymentIn ==
                                                                '0.00')
                                                        ? ColorsUtils.reds
                                                        : ColorsUtils.green,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor: (balanceListRes
                                                                      .data![
                                                                          index]
                                                                      .paymentIn ==
                                                                  null ||
                                                              balanceListRes
                                                                      .data![
                                                                          index]
                                                                      .paymentIn ==
                                                                  '0.00')
                                                          ? ColorsUtils.reds
                                                          : ColorsUtils.green,
                                                      radius: 10,
                                                      child: Icon(
                                                          (balanceListRes
                                                                          .data![
                                                                              index]
                                                                          .paymentIn ==
                                                                      null ||
                                                                  balanceListRes
                                                                          .data![
                                                                              index]
                                                                          .paymentIn ==
                                                                      '0.00')
                                                              ? Icons
                                                                  .arrow_back_outlined
                                                              : Icons
                                                                  .arrow_forward_outlined,
                                                          size: 15,
                                                          color: ColorsUtils
                                                              .white),
                                                    ),
                                                    width10(),
                                                    customVerySmallNorText(
                                                        color: (balanceListRes
                                                                        .data![
                                                                            index]
                                                                        .paymentIn ==
                                                                    null ||
                                                                balanceListRes
                                                                        .data![
                                                                            index]
                                                                        .paymentIn ==
                                                                    '0.00')
                                                            ? ColorsUtils.reds
                                                            : ColorsUtils.green,
                                                        title: (balanceListRes
                                                                        .data![
                                                                            index]
                                                                        .paymentIn ==
                                                                    null ||
                                                                balanceListRes
                                                                        .data![
                                                                            index]
                                                                        .paymentIn ==
                                                                    '0.00')
                                                            ? 'Payment Out'
                                                            : 'Payment In'),
                                                    width10(),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                    if (activityViewModel.isPaginationLoading && !isPageFirst)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        child: Center(child: Loader()),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  dateSelection(BuildContext context) {
    String to = '';
    String from = '';
    if (toSelectedDate != '' && fromSelectedDate != '') {
      to = DateTime.parse(toSelectedDate).toString();
      from = DateTime.parse(fromSelectedDate).toString();
    }

    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 70,
                      height: 5,
                      child: Divider(color: ColorsUtils.border, thickness: 4),
                    ),
                  ),
                  height20(),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            print('picked$fromSelectedDate');
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: fromSelectDate,
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime.now());
                            if (picked != null && picked != fromSelectDate) {
                              dialogSetState(() {
                                fromSelectDate = picked;
                                from = fromSelectDate.toString();
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ColorsUtils.border),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  customSmallSemiText(
                                      title: from == ''
                                          ? 'From'
                                          : DateFormat('dd MMM yy')
                                              .format(DateTime.parse(from))
                                              .toString(),
                                      color: ColorsUtils.grey),
                                  Spacer(),
                                  Icon(Icons.calendar_today_outlined)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      width20(),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            print('picked$fromSelectedDate');
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: fromSelectDate,
                                lastDate: DateTime.now());
                            if (picked != null && picked != selectedDate) {
                              dialogSetState(() {
                                selectedDate = picked;
                                to = selectedDate.toString();
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ColorsUtils.border),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  customSmallSemiText(
                                      title: to == ''
                                          ? 'To'
                                          : DateFormat('dd MMM yy')
                                              .format(DateTime.parse(to))
                                              .toString(),
                                      color: ColorsUtils.grey),
                                  Spacer(),
                                  Icon(Icons.calendar_today_outlined)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  height20(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          dialogSetState(() {
                            isAll = !isAll;
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: ColorsUtils.black)),
                          child: isAll
                              ? Center(
                                  child: Image.asset(
                                    Images.check,
                                    width: 10,
                                  ),
                                )
                              : SizedBox(),
                        ),
                      ),
                      width20(),
                      customSmallNorText(title: 'All time')
                    ],
                  ),
                  height20(),
                  InkWell(
                    onTap: () {
                      print(from != '' && to != '');
                      if (isAll) {
                        initData();
                        setState(() {
                          toSelectedDate = '';
                          fromSelectedDate = '';
                          filterDate = '';
                        });
                        Get.back();
                      } else if (from != '' && to != '') {
                        fromSelectedDate = fromSelectDate.toString();
                        toSelectedDate = selectedDate.toString();
                        filterDate =
                            '&filter[date]=custom&filter[between]=["${DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.parse(fromSelectedDate))}", "${DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.parse(toSelectedDate))}"]';
                        setState(() {});
                        initData();

                        Get.back();
                      } else {
                        Get.snackbar('error', 'Please select Dates');
                      }
                    },
                    child: buildContainerWithoutImage(
                        text: 'Done', color: ColorsUtils.accent),
                  ),
                  height20(),
                ],
              ),
            );
          },
        );
      },
    );
    setState(() {});
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
                            print('--->$filterDate');
                            if (sendEmail == true) {
                              String token = await encryptedSharedPreferences
                                  .getString('token');
                              final url = Uri.parse(
                                isRadioSelected == 1
                                    ? '${Utility.baseUrl}statements/balanceStatement?filter[isPdf]=true${filterDate == '' ? '&filter[date]=year' : filterDate}&isEmail=true'
                                    : isRadioSelected == 3
                                        ? '${Utility.baseUrl}statements/balanceStatement?filter[isExcel]=true${filterDate == '' ? '&filter[date]=year' : filterDate}&isEmail=true'
                                        : '${Utility.baseUrl}statements/balanceStatement?filter[isCsv]=true&${filterDate == '' ? '&filter[date]=year' : filterDate}&isEmail=true',
                              );
                              final request = http.Request("GET", url);
                              request.headers.addAll(<String, String>{
                                'Authorization': token,
                                'Content-Type': 'application/json'
                              });
                              showLoadingDialog(context: context);
                              request.body = '';
                              final res = await request.send();
                              if (res.statusCode == 200) {
                                hideLoadingDialog(context: context);
                                Get.back();
                                print(res.request);
                                Get.snackbar(
                                    'Success'.tr, 'send successFully'.tr);
                              } else {
                                hideLoadingDialog(context: context);

                                print('error ::${res.request}');
                                Get.back();
                                Get.snackbar('error', '${res.request}');
                              }
                            } else {
                              await downloadFile(
                                      url:
                                          // 'http://176.58.99.102:3001/api-v1/products/${isRadioSelected == 1 ? 'pdf' : isRadioSelected == 3 ? 'xlsx' : 'xlsx'}export?${isRadioSelected == 3 ? 'filter[include]=productmedia' : 'filter={}'}',
                                          isRadioSelected == 1
                                              ? '${Utility.baseUrl}statements/balanceStatement?filter[isPdf]=true${filterDate == '' ? '&filter[date]=year' : filterDate}'
                                              : isRadioSelected == 3
                                                  ? '${Utility.baseUrl}statements/balanceStatement?filter[isExcel]=true${filterDate == '' ? '&filter[date]=year' : filterDate}'
                                                  : '${Utility.baseUrl}statements/balanceStatement?filter[isCsv]=true&${filterDate == '' ? '&filter[date]=year' : filterDate}',
                                      isRadioSelected: isRadioSelected,
                                      context: context,
                                      isEmail: sendEmail)
                                  .then((value) => Navigator.pop(context));
                            }
                          }
                        } else {
                          Get.snackbar('error'.tr, 'Please check your connection'.tr);
                        }
                      } else {
                        Get.snackbar('error'.tr, 'Please check your connection'.tr);
                      }
                    },
                    child: commonButtonBox(
                        color: ColorsUtils.accent,
                        text: sendEmail == true ? 'send' : 'DownLoad'.tr,
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

  Text smallSemiBoldText({String? text}) {
    return Text(text!,
        style:
            ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.verySmall));
  }

  Text smallBoldText({String? text}) {
    return Text(text!,
        style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.verySmall));
  }

  void scrollData() async {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !activityViewModel.isPaginationLoading) {
          activityViewModel.balanceList(
              filter: filterDate == ''
                  ? '&filter[date]=year' +
                      '${Utility.activityTransactionSources}${Utility.activityPaymentType}'
                  : '$filterDate${Utility.activityTransactionSources}${Utility.activityPaymentType}');
        }
      });
  }

  initData() async {
    activityViewModel.setTransactionInit();

    await activityViewModel.balanceList(
        //&filter[where][transactionId]
        filter: filterDate == ''
            ? '&filter[date]=year' +
                '${Utility.activityTransactionSources}${Utility.activityPaymentType}'
            : '$filterDate${Utility.activityTransactionSources}${Utility.activityPaymentType}');
    setState(() {
      isPageFirst = false;
    });
  }
}
