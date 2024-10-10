import 'dart:convert';
import 'dart:io';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/transaction/transactionDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import '../../../model/apimodels/responseModel/productScreen/order/orderDetailResponseModel.dart';
import '../../../model/apis/api_response.dart';
import '../../../viewModel/Payment/product/myproductViewModel.dart';
import 'package:http/http.dart' as http;

class OrderDetailScreen extends StatefulWidget {
  bool? isFromReportScreen = false;
  String? id;
  OrderDetailScreen({Key? key, this.id, this.isFromReportScreen})
      : super(key: key);
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String token = '';
  MyProductListViewModel myProductListViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    initData();
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
                if (controller.orderDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.orderDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }

                if (controller.orderDetailApiResponse.status == Status.ERROR) {
                  return const SessionExpire();
                  // return Center(child: const Text('Error'));
                }
                OrderDetailResponseModel orderRes =
                    myProductListViewModel.orderDetailApiResponse.data;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height40(),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorsUtils.black,
                                )),
                            const Spacer(),
                            orderRes.orderstatus!.id == 1
                                ? widget.isFromReportScreen == false
                                    ? InkWell(
                                        onTap: () {
                                          markAsDelBottomSheet(orderRes.id);
                                        },
                                        child: Icon(
                                          Icons.more_vert,
                                        ),
                                      )
                                    : SizedBox()
                                : SizedBox()
                          ],
                        ),
                        height30(),
                        Text(
                          'Order Details'.tr,
                          style: ThemeUtils.blackBold
                              .copyWith(fontSize: FontUtils.medLarge),
                        ),
                        height20(),

                        ///order
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: ColorsUtils.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: ColorsUtils.border)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                orderRes.product!.productmedia!.isEmpty
                                    ? Container(
                                        width: Get.width * 0.175,
                                        height: Get.height * 0.12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              Images.noImage,
                                              fit: BoxFit.cover,
                                            )),
                                      )
                                    : Container(
                                        width: Get.width * 0.175,
                                        height: Get.height * 0.12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            '${Constants.productContainer + orderRes.product!.productmedia!.first.name}',
                                            headers: {
                                              HttpHeaders.authorizationHeader:
                                                  token
                                            },
                                            fit: BoxFit.cover,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderRes.product!.name ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: ThemeUtils.blackBold
                                          .copyWith(fontSize: FontUtils.small),
                                    ),
                                    height10(),
                                    Text(
                                      '${double.parse(orderRes.product!.price.toString()).toStringAsFixed(2)} QAR',
                                      style: ThemeUtils.blackBold.copyWith(
                                          fontSize: FontUtils.mediumSmall,
                                          color: ColorsUtils.accent),
                                    ),
                                    height10(),
                                    Row(
                                      children: [
                                        Image.asset(
                                          Images.basket,
                                          height: 20,
                                          width: 20,
                                        ),
                                        width10(),
                                        Text(
                                          '${orderRes.product!.totalavailablequantity ?? ""}',
                                          style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.mediumSmall,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                        height10(),

                        ///order no.
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: ColorsUtils.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: ColorsUtils.border)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                smallText(title: 'Order No.'.tr),
                                height10(),
                                Row(
                                  children: [
                                    Expanded(
                                        child: boldText(
                                            title: '${orderRes.orderno}')),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: orderRes.transaction!
                                                    .transactionstatusId ==
                                                1
                                            ? ColorsUtils.countBackground
                                            : orderRes.transaction!
                                                        .transactionstatusId ==
                                                    2
                                                ? ColorsUtils.yellow
                                                : orderRes.transaction!
                                                            .transactionstatusId ==
                                                        3
                                                    ? ColorsUtils.green
                                                    : orderRes.transaction!
                                                                .transactionstatusId ==
                                                            4
                                                        ? ColorsUtils.reds
                                                        : ColorsUtils.red,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        child: Text(
                                            orderRes.transaction!
                                                        .transactionstatusId ==
                                                    1
                                                ? 'Draft'.tr
                                                : orderRes.transaction!
                                                            .transactionstatusId ==
                                                        2
                                                    ? 'Unpaid'.tr
                                                    : orderRes.transaction!
                                                                .transactionstatusId ==
                                                            3
                                                        ? 'Paid'.tr
                                                        : orderRes.transaction!
                                                                    .transactionstatusId ==
                                                                4
                                                            ? 'Overdue'.tr
                                                            : 'Rejected'.tr,
                                            style: ThemeUtils.blackRegular
                                                .copyWith(
                                                    fontSize:
                                                        FontUtils.verySmall,
                                                    color: ColorsUtils.white)),
                                      ),
                                    )
                                  ],
                                ),
                                // height10(),
                                smallGreyText(
                                    title: intl.DateFormat(
                                            'dd MMM yyyy, HH:mm:ss')
                                        .format(
                                            orderRes.transaction!.created!)),
                                height30(),
                                smallText(title: 'Transaction ID'.tr),
                                height10(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: boldText(
                                          title:
                                              '${orderRes.transaction?.invoicenumber.toString() ?? "-"}'),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        orderRes.transaction == null
                                            ? SizedBox()
                                            : Get.to(() =>
                                                TransactionDetailScreen(
                                                  isFromReport:
                                                      widget.isFromReportScreen,
                                                  id: orderRes.transaction!.id
                                                      .toString(),
                                                ));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Details'.tr,
                                            style: ThemeUtils.blackBold
                                                .copyWith(
                                                    fontSize:
                                                        FontUtils.verySmall,
                                                    color: ColorsUtils.accent),
                                          ),
                                          width10(),
                                          const CircleAvatar(
                                              backgroundColor:
                                                  ColorsUtils.accent,
                                              radius: 10,
                                              child: Center(
                                                child: Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  color: ColorsUtils.white,
                                                  size: 10,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        height20(),

                        ///DELIVERY STATUS
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              color: ColorsUtils.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: ColorsUtils.border)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    smallText(title: 'Delivery Status'.tr),
                                    Spacer(),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: orderRes.orderstatus!.id == 1
                                              ? ColorsUtils.yellow
                                              : ColorsUtils.green),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        child: Text(
                                            '${orderRes.orderstatus!.name ?? ""}',
                                            style: ThemeUtils.blackRegular
                                                .copyWith(
                                                    fontSize:
                                                        FontUtils.verySmall,
                                                    color: ColorsUtils.white)),
                                      ),
                                    )
                                  ],
                                ),
                                smallGreyText(
                                    title: orderRes.deliverydate == null
                                        ? ''
                                        : '${intl.DateFormat('dd MMM yyyy, HH:ss:mm').format(DateTime.parse(orderRes.deliverydate!.toString()))}'),
                              ],
                            ),
                          ),
                        ),
                        height10(),

                        ///cus detail
                        orderRes.customerId == null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: ColorsUtils.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: ColorsUtils.border)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // smallText(title: 'Customer name'.tr),
                                        // height10(),
                                        // boldText(
                                        //     title:
                                        //     '${orderRes..name ?? "NA"}'),
                                        // height20(),
                                        smallText(
                                            title: 'Customer Mobile no.'.tr),
                                        height10(),
                                        boldText(
                                            title:
                                                '+974 - ${orderRes.cellnumber ?? ''}'),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: ColorsUtils.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: ColorsUtils.border)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        smallText(title: 'Customer name'.tr),
                                        height10(),
                                        boldText(
                                            title:
                                                '${orderRes.customerId!.name ?? "NA"}'),
                                        height20(),
                                        smallText(
                                            title: 'Customer Mobile no.'.tr),
                                        height10(),
                                        boldText(
                                            title:
                                                '+974 - ${orderRes.customerId!.cellnumber}'),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        height20()
                      ],
                    ),
                  ),
                );
              },
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
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

  void initData() async {
    token = await encryptedSharedPreferences.getString('token');
    await myProductListViewModel.orderDetail(widget.id!);
  }
}
