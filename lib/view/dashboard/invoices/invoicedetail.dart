import 'dart:io';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/getInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/getInvoiceViewModel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../../home.dart';
import 'detailedInvoiceScreen.dart';
import 'fastInvoiceScreen.dart';
import 'invoiceList.dart';

class InvoiceDetailScreen extends StatefulWidget {
  String? invoiceId;
  // String? invoiceStatusId;
  bool? isReport;
  InvoiceDetailScreen({Key? key, this.invoiceId, this.isReport = false})
      : super(key: key);
  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  GetInvoiceViewModel getInvoiceViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  ConnectivityViewModel connectivityViewModel = Get.find();

  String token = '';
  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    getInvoiceViewModel.setInit();
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<GetInvoiceViewModel>(
              builder: (controller) {
                if (controller.getInvoiceApiResponse.status == Status.LOADING ||
                    controller.getInvoiceApiResponse.status == Status.INITIAL) {
                  return const Center(child: Loader());
                }
                if (controller.getInvoiceApiResponse.status == Status.ERROR) {
                  return const SessionExpire();
                }
                GetInvoiceResponseModel response =
                    getInvoiceViewModel.getInvoiceApiResponse.data;
                return SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      topView(response, context),
                      bottomView(response),
                    ],
                  ),
                ));
              },
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                getInvoiceViewModel.setInit();
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
              getInvoiceViewModel.setInit();
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

  Expanded bottomView(GetInvoiceResponseModel response) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Invoice Details'.tr,
                style:
                    ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
              ),
            ),

            ///invoice detail container
            invoiceDetail(response),
            height10(),

            ///transaction id container
            transactionID(response),
            height10(),

            ///customer detail screen
            customerName(response),
            height10(),

            ///description container
            description(response),
            height20(),

            ///Invoice items
            invoiceItems(response),
            height25(),

            ///net amount container
            netAmount(response),
            height20(),

            ///send invoice button
            // response.invoicestatusId == 2 || response.invoicestatusId == 1
            //     ? InkWell(
            //         onTap: () {
            //           Utility.isFastInvoice = false;
            //
            //           // Get.to(() => const InvoiceList());
            //         },
            //         child: commonButtonBox(
            //             color: ColorsUtils.accent,
            //             text: 'Send Invoice',
            //             img: Images.send),
            //       )
            //     : SizedBox(),
            height20(),
          ],
        ),
      ),
    );
  }

  Padding topView(GetInvoiceResponseModel response, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios)),
          const Spacer(),
          response.invoicestatusId == 3 ||
                  response.invoicestatusId == 5 ||
                  response.invoicestatusId == 4 ||
                  response.invoicestatusId == 0 ||
                  widget.isReport == true
              ? SizedBox()
              : InkWell(
                  onTap: () {
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
                    if (response.invoicedetails!.isEmpty ||
                        response.invoicedetails == null) {
                      Map<String, dynamic> invoiceDetail = {
                        'grossAmount': response.grossamount.toString(),
                        'custName': response.clientname ?? "",
                        'mobNo': response.cellno ?? "",
                        'type': response.invoicestatusId ?? "",
                        'description': response.remarks ?? "",
                      };
                      Get.off(() => FastInvoiceScreen(
                            invoiceDetail: invoiceDetail,
                            transId: response.id.toString(),
                          ));
                    } else {
                      Map<String, dynamic> invoiceDetail = {
                        'grossAmount': response.grossamount ?? "",
                        'custName': response.clientname ?? "",
                        'mobNo': response.cellno ?? "",
                        'description': response.remarks ?? "",
                        'itemList': response.invoicedetails ?? "",
                        'read': response.readreceipt ?? "",
                        'type': response.invoicestatusId ?? ""
                      };
                      // }
                      Utility.selectedProductData.clear();
                      Get.off(() => DetailedInvoiceScreen(
                            invoiceDetail: invoiceDetail,
                            transId: response.id.toString(),
                          ));
                    }
                  },
                  child: Image.asset(
                    Images.edit,
                    height: 25,
                    width: 25,
                  ),
                ),
          width10(),
          widget.isReport == true
              ? SizedBox()
              : InkWell(
                  onTap: () {
                    bottomSheet(context, response);
                  },
                  child: Icon(Icons.more_vert)),
        ],
      ),
    );
  }

  Widget invoiceItems(GetInvoiceResponseModel response) {
    return response.invoicedetails!.length == 0
        ? SizedBox()
        : Column(
            children: [
              Row(
                children: [
                  Text(
                    'Invoice Items'.tr,
                    style: ThemeUtils.blackBold
                        .copyWith(fontSize: FontUtils.medium),
                  ),
                  Spacer(),
                  Text(
                    '${response.invoicedetails!.length} ${'Items'.tr}',
                    style: ThemeUtils.blackSemiBold
                        .copyWith(fontSize: FontUtils.small),
                  ),
                ],
              ),
              height20(),
              SizedBox(
                width: Get.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: response.invoicedetails!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return response.invoicedetails![index].product == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorsUtils.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: ColorsUtils.border, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              response.invoicedetails![index]
                                                              .productId ==
                                                          null ||
                                                      response
                                                              .invoicedetails![
                                                                  index]
                                                              .productId ==
                                                          0
                                                  ? '${response.invoicedetails![index].description ?? "NA"}'
                                                  : '${response.invoicedetails![index].product!.name ?? "NA"}',
                                              style: ThemeUtils.blackBold
                                                  .copyWith(
                                                      fontSize:
                                                          FontUtils.small),
                                            ),
                                            height10(),
                                            Row(
                                              children: [
                                                Text(
                                                  response
                                                                  .invoicedetails![
                                                                      index]
                                                                  .productId ==
                                                              null ||
                                                          response
                                                                  .invoicedetails![
                                                                      index]
                                                                  .productId ==
                                                              0
                                                      ? response
                                                                  .invoicedetails![
                                                                      index]
                                                                  .quantity ==
                                                              0
                                                          ? "∞"
                                                          : '${((response.invoicedetails![index].amount ?? "") / (response.invoicedetails![index].quantity)).toInt()} QAR'
                                                      : '${response.invoicedetails![index].product!.price ?? ""} QAR',
                                                  style: ThemeUtils.blackBold
                                                      .copyWith(
                                                          fontSize:
                                                              FontUtils.small),
                                                ),
                                                width20(),
                                                response.invoicedetails![index]
                                                                .productId ==
                                                            null ||
                                                        response
                                                                .invoicedetails![
                                                                    index]
                                                                .productId ==
                                                            0
                                                    ? SizedBox()
                                                    : Image.asset(
                                                        Images.basket,
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                width10(),
                                                Text(
                                                  response
                                                                  .invoicedetails![
                                                                      index]
                                                                  .productId ==
                                                              null ||
                                                          response
                                                                  .invoicedetails![
                                                                      index]
                                                                  .productId ==
                                                              0
                                                      // ? '∞'
                                                      ? ''
                                                      : '${response.invoicedetails![index].product!.totalavailablequantity == 0 ? '∞' : response.invoicedetails![index].product!.totalavailablequantity ?? ""}',
                                                  style: ThemeUtils.blackBold
                                                      .copyWith(
                                                          fontSize:
                                                              FontUtils.small),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height25(),
                                  Row(
                                    children: [
                                      Text(
                                        '${response.invoicedetails![index].quantity ?? ""}X',
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.small),
                                      ),
                                      Spacer(),
                                      Text(
                                        // '${(response.invoicedetails![index].quantity * response.invoicedetails![index].product!.price)} QAR',
                                        '${double.parse(response.invoicedetails![index].amount.toString()).toStringAsFixed(2) ?? ""} QAR',
                                        style: ThemeUtils.blackBold.copyWith(
                                            color: ColorsUtils.invoiceAmount,
                                            fontSize: FontUtils.mediumSmall),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorsUtils.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: ColorsUtils.border, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      response.invoicedetails![index]
                                                  .productId ==
                                              null
                                          ? Image.asset(
                                              Images.noImage,
                                              scale: 3,
                                            )
                                          : response.invoicedetails![index]
                                                      .product ==
                                                  null
                                              ? SizedBox()
                                              : Container(
                                                  width: 40,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      '${Utility.baseUrl}containers/api-product/download/${response.invoicedetails![index].product!.productmedia![0].name}',
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
                                      width10(),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              response.invoicedetails![index]
                                                          .productId ==
                                                      null
                                                  ? '${response.invoicedetails![index].description ?? "NA"}'
                                                  : '${response.invoicedetails![index].product!.name ?? "NA"}',
                                              style: ThemeUtils.blackBold
                                                  .copyWith(
                                                      fontSize:
                                                          FontUtils.small),
                                            ),
                                            height10(),
                                            Row(
                                              children: [
                                                Text(
                                                  response
                                                              .invoicedetails![
                                                                  index]
                                                              .productId ==
                                                          null
                                                      ? response
                                                                  .invoicedetails![
                                                                      index]
                                                                  .quantity ==
                                                              0
                                                          ? "∞"
                                                          : '${((response.invoicedetails![index].amount ?? "") / (response.invoicedetails![index].quantity)).toInt()} QAR'
                                                      : '${response.invoicedetails![index].product!.price ?? ""} QAR',
                                                  style: ThemeUtils.blackBold
                                                      .copyWith(
                                                          fontSize:
                                                              FontUtils.small),
                                                ),
                                                width20(),
                                                response.invoicedetails![index]
                                                            .productId ==
                                                        null
                                                    ? SizedBox()
                                                    : Image.asset(
                                                        Images.basket,
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                width10(),
                                                Text(
                                                  response
                                                              .invoicedetails![
                                                                  index]
                                                              .productId ==
                                                          null
                                                      // ? '∞'
                                                      ? ''
                                                      : '${response.invoicedetails![index].product!.totalavailablequantity == 0 ? '∞' : response.invoicedetails![index].product!.totalavailablequantity ?? ""}',
                                                  style: ThemeUtils.blackBold
                                                      .copyWith(
                                                          fontSize:
                                                              FontUtils.small),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  height25(),
                                  Row(
                                    children: [
                                      Text(
                                        '${response.invoicedetails![index].quantity ?? ""}X',
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.small),
                                      ),
                                      Spacer(),
                                      Text(
                                        // '${(response.invoicedetails![index].quantity * response.invoicedetails![index].product!.price)} QAR',
                                        '${double.parse(response.invoicedetails![index].amount.toString()).toStringAsFixed(2) ?? ""} QAR',
                                        style: ThemeUtils.blackBold.copyWith(
                                            color: ColorsUtils.invoiceAmount,
                                            fontSize: FontUtils.mediumSmall),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          );
                  },
                ),
              )
            ],
          );
  }

  Future<void> bottomSheet(
      BuildContext context, GetInvoiceResponseModel response) {
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
                  response.invoicestatusId == 3 ||
                          response.invoicestatusId == 5 ||
                          response.invoicestatusId == 4
                      ? SizedBox()
                      : ((response.invoicedetails!.isNotEmpty &&
                                  response.invoicedetails != null) ||
                              response.invoicestatusId != 2)
                          ? Column(
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
                                    if (response.invoicedetails!.isEmpty ||
                                        response.invoicedetails == null) {
                                      Map<String, dynamic> invoiceDetail = {
                                        'grossAmount':
                                            response.grossamount.toString(),
                                        'custName': response.clientname ?? "",
                                        'mobNo': response.cellno ?? "",
                                        'type': response.invoicestatusId ?? "",
                                        'description': response.remarks ?? "",
                                      };
                                      Get.off(() => FastInvoiceScreen(
                                            invoiceDetail: invoiceDetail,
                                            transId: response.id.toString(),
                                          ));
                                    } else {
                                      Map<String, dynamic> invoiceDetail = {
                                        'grossAmount':
                                            response.grossamount ?? "",
                                        'custName': response.clientname ?? "",
                                        'mobNo': response.cellno ?? "",
                                        'description': response.remarks ?? "",
                                        'itemList':
                                            response.invoicedetails ?? "",
                                        'read': response.readreceipt ?? "",
                                        'type': response.invoicestatusId ?? ""
                                      };
                                      // }
                                      Utility.selectedProductData.clear();
                                      Get.off(() => DetailedInvoiceScreen(
                                            invoiceDetail: invoiceDetail,
                                            transId: response.id.toString(),
                                          ));
                                    }
                                  },
                                  child: commonRowDataBottomSheet(
                                      img: Images.edit, title: 'Edit'.tr),
                                ),
                                dividerData(),
                              ],
                            )
                          : SizedBox(),

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
                  response.invoicestatusId == 1 ||
                          response.invoicestatusId == 3 ||
                          response.invoicestatusId == 5
                      ? SizedBox()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();

                                Clipboard.setData(ClipboardData(
                                    text:
                                        'https://d.sadad.qa/${response.shareUrl ?? ""}'));
                                Get.snackbar(
                                    '', 'Link is Copied to clipboard!');
                              },
                              child: commonRowDataBottomSheet(
                                  img: Images.link, title: 'Copy link'.tr),
                            ),
                            dividerData(),
                          ],
                        ),

                  ///download
                  response.invoicestatusId != 3
                      ? SizedBox()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await downloadFile(
                                  isEmail: false,
                                  isRadioSelected: 1,
                                  url:
                                      '${Utility.baseUrl}invoices/singleInvoicePdfExport?filter[where][language]=en&&filter[where][isDownloadZip]=false&filter[where][invoiceno]=${response.invoiceno}',
                                  context: context,
                                ).then((value) => Navigator.pop(context));
                              },
                              child: commonRowDataBottomSheet(
                                  img: Images.download,
                                  title: 'Download Invoice'.tr),
                            ),
                            response.invoicestatusId != 3
                                ? SizedBox()
                                : dividerData(),
                          ],
                        ),

                  ///share
                  response.invoicestatusId == 5 || response.invoicestatusId == 2
                      ? Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();

                                  Share.share(
                                      'https://d.sadad.qa/${response.shareUrl ?? ""}');
                                },
                                child: commonRowDataBottomSheet(
                                    img: Images.share, title: 'Share'.tr)),
                            dividerData(),
                          ],
                        )
                      : SizedBox(),

                  ///send notification
                  // response.invoicestatusId == 1
                  //     ? Column(
                  //         children: [
                  //           commonRowDataBottomSheet(
                  //               img: Images.notification,
                  //               title: 'Send notification'.tr),
                  //           dividerData(),
                  //         ],
                  //       )
                  //     : SizedBox(),

                  ///delete
                  response.invoicestatusId == 5 ||
                          response.invoicestatusId == 1 ||
                          response.invoicestatusId == 2
                      ? InkWell(
                          onTap: () async {
                            Get.back();
                            if (response.invoicestatusId != 3) {
                              String token = await encryptedSharedPreferences
                                  .getString('token');
                              final url = Uri.parse(
                                  '${Utility.baseUrl}invoices/${response.id}');
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
                                Future.delayed(const Duration(seconds: 1), () {
                                  // Get.to(() => InvoiceList());
                                  Get.back();
                                  // return Get.to(() => HomeScreen());
                                });
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

  Container netAmount(GetInvoiceResponseModel response) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsUtils.white,
        border: Border.all(color: ColorsUtils.border),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Row(
            //   children: [
            //     Text(
            //       'Sub amount'.tr,
            //       style: ThemeUtils.blackSemiBold,
            //     ),
            //     const Spacer(),
            //     Text(
            //       '${double.parse(response.grossamount.toString()).toStringAsFixed(2) ?? ""} QAR',
            //       style: ThemeUtils.blackSemiBold,
            //     ),
            //   ],
            // ),
            // dividerData(),
            // Row(
            //   children: [
            //     Text(
            //       'Discount'.tr,
            //       style: ThemeUtils.blackSemiBold,
            //     ),
            //     const Spacer(),
            //     const Icon(
            //       Icons.add,
            //       color: ColorsUtils.accent,
            //     ),
            //     width10(),
            //     Text(
            //       'Add Discount'.tr,
            //       style: ThemeUtils.blackSemiBold.copyWith(
            //           fontSize: FontUtils.small, color: ColorsUtils.accent),
            //     ),
            //   ],
            // ),
            // dividerData(),
            Row(
              children: [
                Text(
                  'Invoice amount'.tr,
                  style: ThemeUtils.blackBold,
                ),
                const Spacer(),
                Text(
                  '${double.parse(response.grossamount.toString()).toStringAsFixed(2)} QAR',
                  style: ThemeUtils.blackBold.copyWith(
                      fontSize: FontUtils.small, color: ColorsUtils.accent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container description(GetInvoiceResponseModel response) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          commonValueText(value: 'Description'.tr),
          height10(),
          commonTitleText(
              title:
                  '${response.remarks == '' ? 'NA' : response.remarks ?? "NA"}')
        ]),
      ),
    );
  }

  Container customerName(GetInvoiceResponseModel response) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonTitleText(title: 'Customer name'.tr),
            height10(),
            commonValueText(value: '${response.clientname ?? "NA"}'),
            height15(),
            commonTitleText(title: 'Customer Mobile no.'.tr),
            height10(),
            commonValueText(value: '${response.cellno ?? "NA"}'),
            height15(),
            commonTitleText(title: 'Username'.tr),
            height10(),
            commonValueText(
                value:
                    '${response.user == null ? "NA" : response.user!.name ?? "NA"}'),
            height15(),
            commonTitleText(title: 'Customer email'.tr),
            height10(),
            response.emailaddress != null
                ? commonValueText(value: '${response.emailaddress ?? "NA"}')
                : customSmallSemiText(title: 'NA')
          ],
        ),
      ),
    );
  }

  Container transactionID(GetInvoiceResponseModel response) {
    return Container(
      decoration: BoxDecoration(
          color: ColorsUtils.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                commonTitleText(title: 'Transaction ID'.tr),
                Spacer(),
                Image.asset(
                  Images.accentEye,
                  width: 20,
                  height: 20,
                  color: response.readdatetime != null
                      ? ColorsUtils.accent
                      : ColorsUtils.border,
                ),
                width20(),
                Container(
                  decoration: BoxDecoration(
                      color: response.invoicestatusId == 1
                          ? ColorsUtils.countBackground
                          : response.invoicestatusId == 2
                              ? ColorsUtils.yellow
                              : response.invoicestatusId == 3
                                  ? ColorsUtils.green
                                  : response.invoicestatusId == 4
                                      ? ColorsUtils.reds
                                      : ColorsUtils.red,
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: Center(
                      child: Text(
                        response.invoicestatusId == 1
                            ? 'Draft'.tr
                            : response.invoicestatusId == 2
                                ? 'Unpaid'.tr
                                : response.invoicestatusId == 3
                                    ? 'Paid'.tr
                                    : response.invoicestatusId == 4
                                        ? 'Overdue'.tr
                                        : 'Rejected'.tr,
                        style: ThemeUtils.blackRegular
                            .copyWith(fontSize: 12, color: ColorsUtils.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
            height10(),
            // commonValueText(value: '${response.id ?? ""}'),
            commonValueText(
                value: response.transaction?.invoicenumber.toString() ?? "NA"),
            height10(),
            response.invoice_payment_date == null ||
                    response.invoice_payment_date == ""
                ? SizedBox()
                : Text(
                    textDirection: TextDirection.ltr,
                    response.invoice_payment_date == "" ||
                            response.invoice_payment_date == null
                        ? ""
                        : intl.DateFormat('dd MMM yyyy, HH:mm:ss').format(
                            DateTime.parse(response.invoice_payment_date)),
                    style: ThemeUtils.blackRegular
                        .copyWith(fontSize: 12, color: ColorsUtils.grey),
                  ),
          ],
        ),
      ),
    );
  }

  Container invoiceDetail(GetInvoiceResponseModel response) {
    return Container(
      decoration: BoxDecoration(
          color: ColorsUtils.white,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      commonTitleText(title: 'Invoice no'.tr),
                      height10(),
                      commonValueText(value: '${response.invoiceno ?? "NA"}'),
                    ],
                  ),
                ),
                response.invoicestatusId == 2 &&
                        response.invoicestatusId != 1 &&
                        response.invoicestatusId != 3 &&
                        response.invoicestatusId != 5
                    ? InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(
                              text:
                                  'https://d.sadad.qa/${response.shareUrl ?? "NA"}'));
                          // GetSnackBar(
                          //   message: 'Link is Copied to clipboard!',
                          // );
                          Get.snackbar('', 'Link is Copied to clipboard!');
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsUtils.link),
                              child: Center(
                                  child: Image.asset(Images.link,
                                      height: 25, width: 25)),
                            ),
                            width5(),
                            Text(
                              'Copy link'.tr,
                              style: ThemeUtils.blackRegular
                                  .copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      )
                    : SizedBox()
              ],
            ),
            height20(),
            commonTitleText(title: 'Total Invoice amount'.tr),
            height10(),
            Text(
              '${response.grossamount ?? ""} QAR',
              style: ThemeUtils.blackBold.copyWith(
                  color: ColorsUtils.invoiceAmount,
                  fontSize: FontUtils.mediumSmall),
            ),
            height10(),
            Text(
              textDirection: TextDirection.ltr,
              intl.DateFormat('dd MMM yyyy, HH:mm:ss')
                  .format(DateTime.parse(response.created)),
              style: ThemeUtils.blackRegular
                  .copyWith(fontSize: 12, color: ColorsUtils.grey),
            ),
          ],
        ),
      ),
    );
  }

  Text commonValueText({String? value}) {
    return Text(
      value!,
      style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
    );
  }

  Text commonTitleText({String? title}) {
    return Text(
      title!,
      style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall),
    );
  }

  initData() async {
    String? id = widget.invoiceId;
    await getInvoiceViewModel.getInvoice(id!);
    if (getInvoiceViewModel.getInvoiceApiResponse.status == Status.ERROR) {
      const SessionExpire();
    }
    token = await encryptedSharedPreferences.getString('token');
  }
}
