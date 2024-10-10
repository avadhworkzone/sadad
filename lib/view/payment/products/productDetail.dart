import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/store/showStoreRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/product/productDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/view/payment/products/createProduct.dart';
import 'package:sadad_merchat_app/view/payment/products/myProductScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:share_plus/share_plus.dart';
import '../../../viewModel/Payment/product/myproductViewModel.dart';
import 'productOrderListScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  String? productId;
  ProductDetailScreen({Key? key, this.productId}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isShowEStore = false;
  bool sendEmail = false;
  MyProductListViewModel myProductListViewModel = Get.find();
  ShowStoreRequestModel showEStoreReq = ShowStoreRequestModel();
  int isRadioSelected = 0;
  String token = '';
  String email = '';
  ShowStoreRequestModel showStoreReq = ShowStoreRequestModel();
  DisplayPanelProductRequestModel displayPanelProduct =
      DisplayPanelProductRequestModel();
  ConnectivityViewModel connectivityViewModel = Get.find();

  ProductDetailResponseModel? productDetailResponse;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    myProductListViewModel.productDetailApiResponse.status = Status.INITIAL;

    initData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            floatingActionButton: flotingButton(),
            body: GetBuilder<MyProductListViewModel>(
              builder: (controller) {
                if (controller.productDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.productDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }

                if (controller.productDetailApiResponse.status ==
                    Status.ERROR) {
                  return const SessionExpire();
                  // return Center(child: const Text('Error'));
                }
                productDetailResponse =
                    myProductListViewModel.productDetailApiResponse.data;

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topImageContainer(),
                      bottomView(),
                    ],
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
                myProductListViewModel.productDetailApiResponse.status =
                    Status.INITIAL;

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
              myProductListViewModel.productDetailApiResponse.status =
                  Status.INITIAL;

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

  Widget flotingButton() {
    return InkWell(
      onTap: () {
        Share.share(
            'https://d.sadad.qa/${productDetailResponse!.shareUrl ?? ""}');
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: ColorsUtils.accent.withOpacity(0.5),
            offset: const Offset(0, 5),
            blurRadius: 10,
          )
        ], shape: BoxShape.circle, color: ColorsUtils.accent),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Center(
              child: Image.asset(
            Images.productShare,
            color: ColorsUtils.white,
            height: 20,
            width: 20,
          )),
        ),
      ),
    );
  }

  Padding bottomView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height20(),

          ///title of product
          Text(
            productDetailResponse!.name,
            style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
          ),
          height10(),

          ///price
          Text(
            '${double.parse(productDetailResponse!.price.toString()).toStringAsFixed(2)} QAR',
            style: ThemeUtils.blackBold.copyWith(
                fontSize: FontUtils.medium, color: ColorsUtils.accent),
          ),
          height10(),

          ///available and time
          Row(
            children: [
              Image.asset(
                Images.basket,
                height: 20,
                width: 20,
              ),
              width10(),
              Text(
                productDetailResponse!.isUnlimited == true
                    ? '∞'
                    : productDetailResponse!.totalavailablequantity == 0
                        ? '∞'
                        : '${productDetailResponse!.totalavailablequantity}',
                style: ThemeUtils.blackBold.copyWith(
                    fontSize: FontUtils.small,
                    color: productDetailResponse!.totalavailablequantity == 0
                        ? ColorsUtils.accent
                        : ColorsUtils.black),
              ),
              width20(),
              const SizedBox(
                height: 25,
                child: VerticalDivider(
                  color: ColorsUtils.border,
                  width: 1,
                  thickness: 1,
                ),
              ),
              width20(),
              Text(
                textDirection: TextDirection.ltr,
                intl.DateFormat('dd MMM yyyy, HH:mm:ss')
                    .format(DateTime.parse(productDetailResponse!.created)),
                style: ThemeUtils.blackSemiBold.copyWith(
                  fontSize: FontUtils.small,
                ),
              ),
            ],
          ),
          height20(),

          ///view and sold row
          Row(
            children: [
              Image.asset(
                Images.accentEye,
                color: ColorsUtils.black,
                height: 20,
                width: 20,
              ),
              width10(),
              Text(
                '${productDetailResponse!.viewcount}',
                style: ThemeUtils.blackBold.copyWith(
                  fontSize: FontUtils.small,
                ),
              ),
              width50(),
              Image.asset(
                Images.cart,
                height: 20,
                width: 20,
              ),
              width20(),
              Text(
                '${productDetailResponse!.salescount}',
                style: ThemeUtils.blackBold.copyWith(
                  fontSize: FontUtils.small,
                ),
              ),
              width10(),
              Text(
                'Sold'.tr,
                style: ThemeUtils.blackSemiBold.copyWith(
                  fontSize: FontUtils.small,
                ),
              ),
            ],
          ),
          height10(),
          dividerData(),

          ///show e-store
          Row(
            children: [
              Image.asset(
                Images.storesMenu,
                height: 20,
                width: 20,
              ),
              width10(),
              Text(
                'Show in E-store'.tr,
                style: ThemeUtils.blackBold.copyWith(
                  fontSize: FontUtils.mediumSmall,
                ),
              ),
              const Spacer(),
              Switch(
                value: myProductListViewModel.isShowEStore,
                activeColor: ColorsUtils.accent,
                onChanged: (value) async {
                  myProductListViewModel.isShowEStore =
                      !myProductListViewModel.isShowEStore;
                  bool show = false;
                  show = myProductListViewModel.isShowEStore == true
                      ? true
                      : myProductListViewModel.isShowEStore == false
                          ? false
                          : false;
                  print(show);
                  displayPanelProduct.isdisplayinpanel = show == true ? 1 : 0;
                  await myProductListViewModel.showStore(
                      productDetailResponse!.id!.toString(),
                      displayPanelProduct);
                  if (myProductListViewModel.showStoreApiResponse.status ==
                      Status.COMPLETE) {
                    Get.snackbar(
                        'Success'.tr,
                        '${'Product has been ${myProductListViewModel.isShowEStore == true ? 'added to'.tr : myProductListViewModel.isShowEStore == false ? 'removed from'.tr : false} E store'} ');
                  } else if (myProductListViewModel
                          .showStoreApiResponse.status ==
                      Status.ERROR) {
                    SessionExpire();
                  }
                  setState(() {});
                },
              )
            ],
          ),
          dividerData(),
          height10(),

          ///description
          Text(
            'Descriptions'.tr,
            style: ThemeUtils.blackBold.copyWith(
              fontSize: FontUtils.mediumSmall,
            ),
          ),
          height10(),
          Text(
            '${productDetailResponse!.description ?? "-"}',
            textAlign: TextAlign.justify,
            style: ThemeUtils.blackSemiBold.copyWith(
              fontSize: FontUtils.mediumSmall,
            ),
          ),
          height20(),

          ///delivery
          Text(
            'Expected delivery'.tr,
            textAlign: TextAlign.justify,
            style: ThemeUtils.blackRegular.copyWith(
              fontSize: FontUtils.small,
            ),
          ),
          height5(),
          Text(
            productDetailResponse!.expecteddays == 1 ||
                    productDetailResponse!.expecteddays == 0
                ? 'Immediate'.tr
                : productDetailResponse!.expecteddays == 2
                    ? '1 to 2 Days'.tr
                    : productDetailResponse!.expecteddays == 5
                        ? '3 to 5 Days'.tr
                        : productDetailResponse!.expecteddays == 7
                            ? '1 Week'.tr
                            : productDetailResponse!.expecteddays == 14
                                ? '2-4 Weeks'.tr
                                : productDetailResponse!.expecteddays == 30
                                    ? '1 Month'.tr
                                    : productDetailResponse!.expecteddays == 60
                                        ? '2 Month'.tr
                                        : '${productDetailResponse!.expecteddays} ${'day after'.tr}',
            style: ThemeUtils.blackBold.copyWith(
              fontSize: FontUtils.mediumSmall,
            ),
          ),
          dividerData(),

          ///orders
          InkWell(
            onTap: () async {
              if (productDetailResponse!.salescount == 0) {
                print('nothing');
              } else {
                await Get.to(() => ProductOrderListScreen(
                      productId: widget.productId,
                      name: productDetailResponse!.name,
                      orderCount: productDetailResponse!.salescount.toString(),
                    ));
                myProductListViewModel.productDetailApiResponse.status =
                    Status.INITIAL;

                initData();
              }
            },
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orders'.tr,
                      style: ThemeUtils.blackBold.copyWith(
                        fontSize: FontUtils.mediumSmall,
                      ),
                    ),
                    Text(
                      '${productDetailResponse!.salescount} ${'Orders'.tr}',
                      textAlign: TextAlign.justify,
                      style: ThemeUtils.blackRegular.copyWith(
                        fontSize: FontUtils.small,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                productDetailResponse!.salescount == 0
                    ? SizedBox()
                    : const CircleAvatar(
                        radius: 10,
                        backgroundColor: ColorsUtils.border,
                        child: Center(
                          child: Icon(Icons.arrow_forward_ios_outlined,
                              size: 10, color: ColorsUtils.black),
                        ),
                      )
              ],
            ),
          ),
          // dividerData(),

          ///invoices
          // Row(
          //   children: [
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Invoices'.tr,
          //           style: ThemeUtils.blackBold.copyWith(
          //             fontSize: FontUtils.small,
          //           ),
          //         ),
          //         Text(
          //           '3 ${'Orders'.tr}',
          //           textAlign: TextAlign.justify,
          //           style: ThemeUtils.blackRegular.copyWith(
          //             fontSize: FontUtils.verySmall,
          //           ),
          //         ),
          //       ],
          //     ),
          //     const Spacer(),
          //     const CircleAvatar(
          //       radius: 10,
          //       backgroundColor: ColorsUtils.border,
          //       child: Center(
          //         child: Icon(Icons.arrow_forward_ios_outlined,
          //             size: 10, color: ColorsUtils.black),
          //       ),
          //     )
          //   ],
          // ),
          // dividerData(),
          height30()
        ],
      ),
    );
  }

  Widget topImageContainer() {
    return Stack(
      children: [
        productDetailResponse!.productmedia!.isEmpty
            ? SizedBox(
                height: Get.height / 2,
                width: Get.width,
                child: Center(
                    child: Image.asset(
                  Images.noImage,
                  height: 50,
                  width: 50,
                )),
              )
            : Container(
                height: Get.height / 2,
                width: Get.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  child: Image.network(
                    '${Utility.baseUrl}containers/api-product/download/${productDetailResponse!.productmedia!.last.name}',
                    headers: {HttpHeaders.authorizationHeader: token},
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(child: Image.asset(Images.noImage));
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: ColorsUtils.accent,
                child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 20,
                      color: ColorsUtils.white,
                      // color: productDetailResponse!.productmedia!.isEmpty
                      //     ? ColorsUtils.black
                      //     : ColorsUtils.white,
                    )),
              ),
              const Spacer(),
              CircleAvatar(
                radius: 15,
                backgroundColor: ColorsUtils.accent,
                child: InkWell(
                  onTap: () async {
                    await Get.to(() => CreateProductScreen(
                          productId: widget.productId,
                        ));
                    myProductListViewModel.productDetailApiResponse.status =
                        Status.INITIAL;

                    initData();
                  },
                  child: Image.asset(
                    Images.edit,
                    height: 20,
                    width: 20,
                    color: ColorsUtils.white,
                    // color: productDetailResponse!.productmedia!.isEmpty
                    //     ? ColorsUtils.black
                    //     : ColorsUtils.white,
                  ),
                ),
              ),
              width10(),
              CircleAvatar(
                radius: 15,
                backgroundColor: ColorsUtils.accent,
                child: InkWell(
                    onTap: () async {
                      await bottomSheetDetail();
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: ColorsUtils.white,
                      // color: productDetailResponse!.productmedia!.isEmpty
                      //     ? ColorsUtils.black
                      //     : ColorsUtils.white,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> bottomSheetDetail() async {
    Get.bottomSheet(
        Padding(
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
              // InkWell(
              //     onTap: () async {
              //       isShowEStore = !isShowEStore;
              //       int show = 0;
              //
              //       show = isShowEStore == true
              //           ? 1
              //           : isShowEStore == false
              //               ? 0
              //               : 0;
              //       setState(() {});
              //       showEStoreReq.isdisplayinpanel = show;
              //       await myProductListViewModel.showEStore(
              //           widget.productId!, showEStoreReq);
              //       Get.back();
              //     },
              //     child: bottomSheetText(
              //         title: isShowEStore == true
              //             ? 'Remove From Store'
              //             : 'Add to store',
              //         image: Images.addStore)),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5),
              //   child: dividerData(),
              // ),
              // InkWell(
              //   onTap: () {
              //
              //   },
              //   child: bottomSheetText(
              //       title: 'Add to new invoice', image: Images.addInvoice),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 5),
              //   child: dividerData(),
              // ),
              InkWell(
                  onTap: () {
                    Share.share(
                        'https://d.sadad.qa/${productDetailResponse!.shareUrl ?? ""}');
                  },
                  child: bottomSheetText(title: 'Share', image: Images.share)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: dividerData(),
              ),
              InkWell(
                  onTap: () {
                    Get.back();
                    exportBottomSheet();
                  },
                  child:
                      bottomSheetText(title: 'Export', image: Images.export)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: dividerData(),
              ),
              InkWell(
                onTap: () async {
                  Get.back();
                  await deleteApiCall();
                },
                child: bottomSheetText(title: 'Delete', image: Images.delete),
              ),
              height20(),
            ],
          ),
        ),
        backgroundColor: ColorsUtils.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))));
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
                                isRadioSelected == 1
                                    ? '${Utility.baseUrl}products/pdfexport?filter[where][id]=${widget.productId}&filter[where][price][lte]=20000&filter[where][price][gte]=0&filter[include]=productmedia&filter[order]=created%20DESC&isEmail=true'
                                    : '${Utility.baseUrl}products/xlsxexport?filter[where][id]=${widget.productId}&filter[where][price][lte]=20000&filter[where][price][gte]=0&filter[include]=productmedia&filter[order]=created DESC&isEmail=true',
                              );
                              final request = http.Request("GET", url);
                              request.headers.addAll(<String, String>{
                                'Authorization': token,
                                'Content-Type': 'application/json'
                              });
                              request.body = '';
                              final res = await request.send();
                              if (res.statusCode == 200) {
                                Get.back();
                                print(res.request);
                                Get.snackbar(
                                    'Success'.tr, 'send successFully'.tr);
                              } else {
                                print('error ::${res.request}');
                                Get.back();
                                Get.snackbar('error', '${res.request}');
                              }
                            } else {
                              await downloadFile(
                                      url:
                                          // 'http://176.58.99.102:3001/api-v1/products/${isRadioSelected == 1 ? 'pdf' : isRadioSelected == 3 ? 'xlsx' : 'xlsx'}export?${isRadioSelected == 3 ? 'filter[include]=productmedia' : 'filter={}'}',
                                          isRadioSelected == 1
                                              ? '${Utility.baseUrl}products/pdfexport?filter[where][id]=${widget.productId}&filter[where][price][lte]=20000&filter[where][price][gte]=0&filter[include]=productmedia&filter[order]=created%20DESC'
                                              : '${Utility.baseUrl}products/xlsxexport?filter[where][id]=${widget.productId}&filter[where][price][lte]=20000&filter[where][price][gte]=0&filter[include]=productmedia&filter[order]=created DESC',
                                      isRadioSelected: isRadioSelected,
                                      context: context,
                                      isEmail: sendEmail)
                                  .then((value) => Navigator.pop(context));
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

  Future<void> deleteApiCall() async {
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        showLoadingDialog(context: context);
        String token = await encryptedSharedPreferences.getString('token');
        final url =
            Uri.parse('${Utility.baseUrl}products/${widget.productId!}');
        final request = http.Request("DELETE", url);
        request.headers.addAll(<String, String>{
          'Authorization': token,
          'Content-Type': 'application/json'
        });
        request.body = '';
        final res = await request.send();
        if (res.statusCode == 200) {
          hideLoadingDialog(context: context);
          Get.snackbar('Success'.tr, 'delete successFully'.tr);
          Future.delayed(const Duration(seconds: 1), () {
            // Get.back();

            return Get.off(() => MyProductScreen());
          });
        } else {
          hideLoadingDialog(context: context);
          const SessionExpire();
          // Get.snackbar('error', 'Something Wrong');
        }
      } else {
        Get.snackbar('error', 'Please check your connection');
      }
    } else {
      Get.snackbar('error', 'Please check your connection');
    }
  }

  Row bottomSheetText({String? image, String? title}) {
    return Row(
      children: [
        Image.asset(
          image!,
          height: 20,
          width: 20,
          color: ColorsUtils.black,
        ),
        width20(),
        Text(
          title!.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.small),
        )
      ],
    );
  }

  void initData() async {
    email = await encryptedSharedPreferences.getString('email');
    token = await encryptedSharedPreferences.getString('token');
    await myProductListViewModel.productDetail(widget.productId!);
  }
}
