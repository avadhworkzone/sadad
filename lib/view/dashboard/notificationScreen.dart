import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/notificationResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/dashboard/invoices/invoicedetail.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccount.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/businessDetailsScreen.dart';
import 'package:sadad_merchat_app/view/payment/products/orderDetailScreen.dart';
import 'package:sadad_merchat_app/view/payment/transaction/transactionDetailScreen.dart';
import 'package:sadad_merchat_app/view/settlement/withdrawalDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/notificationListViewModel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationListViewModel notificationListViewModel = Get.find();
  ConnectivityViewModel connectivityViewModel = Get.find();
  ScrollController? _scrollController;
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    Utility.isNotificationResEmpty = true;
    notificationListViewModel.setInit();
    initData();
    // TODO: implement initState
    super.initState();
  }

  List<NotificationListResponseModel>? response;

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(body: GetBuilder<NotificationListViewModel>(
          builder: (controller) {
            if (controller.notificationApiResponse.status == Status.LOADING ||
                controller.notificationApiResponse.status == Status.INITIAL) {
              return Center(
                child: Loader(),
              );
            }
            if (controller.notificationApiResponse.status == Status.ERROR) {
              return SessionExpire();
            }
            response = controller.notificationApiResponse.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height40(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      BackButton(),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            bottomSheet(context);
                          },
                          child: Icon(Icons.more_vert))
                    ],
                  ),
                ),
                height20(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: customLargeBoldText(title: 'Notification'.tr),
                ),
                height20(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        response == null || response!.isEmpty
                            ? SizedBox()
                            : Column(
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: response!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          if (response![index]
                                                      .notification!
                                                      .notificationentityId ==
                                                  2 ||
                                              response![index]
                                                      .notification!
                                                      .notificationentityId ==
                                                  8) {
                                            Get.to(
                                                () => TransactionDetailScreen(
                                                      id: response![index]
                                                          .notification!
                                                          .entityId
                                                          .toString(),
                                                    ));
                                          } else if (response![index]
                                                  .notification!
                                                  .notificationentityId ==
                                              1) {
                                            Get.to(() => InvoiceDetailScreen(
                                                  invoiceId: response![index]
                                                      .notification!
                                                      .entityId
                                                      .toString(),
                                                ));
                                          } else if (response![index]
                                                  .notification!
                                                  .notificationentityId ==
                                              7) {
                                            Get.to(() => OrderDetailScreen(
                                                  id: response![index]
                                                      .notification!
                                                      .entityId
                                                      .toString(),
                                                ));
                                          } else if (response![index]
                                                  .notification!
                                                  .notificationentityId ==
                                              6) {
                                            Get.to(() =>
                                                SettlementWithdrawalDetailScreen(
                                                  id: response![index]
                                                      .notification!
                                                      .entityId
                                                      .toString(),
                                                ));
                                          } else if (response![index]
                                                  .notification!
                                                  .notificationentityId ==
                                              4) {
                                            Get.to(() => BankAccount());
                                          } else if (response![index]
                                                  .notification!
                                                  .notificationentityId ==
                                              5) {
                                            Get.to(() => BusinessDetails());
                                          }

                                          if (!controller.isReadList[index]) {
                                            await notiReadApiCall(
                                                response![index].id.toString(),
                                                index);
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          color: controller.isReadList[index]
                                              ? Colors.transparent
                                              : ColorsUtils.tabUnselect,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              height20(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: customSmallBoldText(
                                                    title:
                                                        '${response![index].notification!.textmessage ?? 'NA'}'),
                                              ),
                                              height20(),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: customSmallMedBoldText(
                                                    title:
                                                        '${DateFormat('dd MMM yyyy, HH:ss:mm aa').format(DateTime.parse(response![index].created.toString()))}',
                                                    color: ColorsUtils.accent),
                                              ),
                                              height20(),
                                              Divider(
                                                height: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  if (notificationListViewModel
                                      .isPaginationLoading)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Center(child: Loader()),
                                    ),
                                  // Utility.isNotificationResEmpty == false
                                  //     ? SizedBox()
                                  //     : Padding(
                                  //         padding: const EdgeInsets.only(
                                  //             bottom: 20, top: 10),
                                  //         child: InkWell(
                                  //             onTap: () {
                                  //               if (!notificationListViewModel
                                  //                   .isPaginationLoading) {
                                  //                 if (connectivityViewModel
                                  //                         .isOnline !=
                                  //                     null) {
                                  //                   if (connectivityViewModel
                                  //                       .isOnline!) {
                                  //                     notificationListViewModel
                                  //                         .notificationList();
                                  //                   } else {
                                  //                     Get.snackbar('error',
                                  //                         'Please check internet connectivity');
                                  //                   }
                                  //                 } else {
                                  //                   Get.snackbar('error',
                                  //                       'Please check internet connectivity');
                                  //                 }
                                  //               }
                                  //             },
                                  //             child: customMediumBoldText(
                                  //                 title: 'Load More')),
                                  //       )
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
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
                Utility.isNotificationResEmpty = true;
                notificationListViewModel.setInit();
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
              Utility.isNotificationResEmpty = true;
              notificationListViewModel.setInit();
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

  Future<void> bottomSheet(
    BuildContext context,
  ) {
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
                  InkWell(
                      onTap: () async {
                        await notiAllReadApiCall();
                        setState(() {});
                      },
                      child:
                          customMediumBoldText(title: 'Mark All as read'.tr)),
                  height40(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> notiReadApiCall(String id, int index) async {
    // showLoadingDialog(context: context);
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(
      '${Utility.baseUrl}notificationreceivers/$id',
    );
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic>? body = {"isread": 1};
    var result = await http.patch(url, headers: header, body: jsonEncode(body));

    print(
        'token is:$token } req is ${jsonEncode(body)} \n response is :${result.body} ');
    if (result.statusCode == 401) {
      // hideLoadingDialog(context: context);
      SessionExpire();
    } else if (result.statusCode == 200) {
      // hideLoadingDialog(context: context);
      notificationListViewModel.isReadList[index] = true;
      print('success');
    } else {
      // hideLoadingDialog(context: context);
      Get.snackbar(
          'error'.tr, '${jsonDecode(result.body)['error']['message']}');
    }
  }

  Future<void> notiAllReadApiCall() async {
    showLoadingDialog(context: context);
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');
    final url = Uri.parse(
      '${Utility.baseUrl}notificationreceivers/update?where[notificationreceiverId]=$id&where[isread]=0',
    );
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic>? body = {"isread": 1};
    var result = await http.post(url, headers: header, body: jsonEncode(body));

    print(
        'token is:$token } req is ${jsonEncode(body)} \n response is :${result.body} ');
    if (result.statusCode == 401) {
      hideLoadingDialog(context: context);
      SessionExpire();
    } else if (result.statusCode == 200) {
      hideLoadingDialog(context: context);
      for (int i = 0; i < notificationListViewModel.isReadList.length; i++) {
        notificationListViewModel.isReadList[i] = true;
      }
      Get.back();

      print('success');
    } else {
      hideLoadingDialog(context: context);
      Get.back();

      Get.snackbar(
          'error'.tr, '${jsonDecode(result.body)['error']['message']}');
    }
  }

  initData() async {
    notificationListViewModel.clearResponseList();
    await notificationListViewModel.notificationList();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
            _scrollController!.offset) {
          notificationListViewModel.notificationList();
        }
      });
  }
}
