import 'dart:convert';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/editInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/countryCodeResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/checkInternationalViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/createInvoiceViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/getInvoiceViewModel.dart';
import 'package:http/http.dart' as http;
import '../../../model/apimodels/responseModel/DashBoard/invoice/checkInternationalResponseModel.dart';
import '../../../staticData/common_widgets.dart';
import '../../../staticData/utility.dart';
import '../../../util/validations.dart';
import 'createDetailAddItemScreeen.dart';
import 'invoicedetail.dart';

class DetailedInvoiceScreen extends StatefulWidget {
  Map<String, dynamic>? invoiceDetail;
  String? transId;

  DetailedInvoiceScreen({Key? key, this.invoiceDetail, this.transId})
      : super(key: key);

  @override
  State<DetailedInvoiceScreen> createState() => _DetailedInvoiceScreenState();
}

class _DetailedInvoiceScreenState extends State<DetailedInvoiceScreen> {
  HomeController homeController = Get.find();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController description = TextEditingController();
  EncryptedSharedPreferences encryptedSharedPreferences =
  EncryptedSharedPreferences();
  bool isInvoiceViewed = false;
  bool isDescription = false;
  String? countryCode;
  bool isCode = true;
  int count = 1;
  bool isInternational = false;
  List<CountryCodeResponseModel>? codeResponseModel;
  CreateInvoiceRequestModel createInvoicesReq = CreateInvoiceRequestModel();
  EditInvoiceRequestModel editInvoiceReq = EditInvoiceRequestModel();
  CreateInvoiceViewModel createInvoiceViewModel = Get.find();
  GetInvoiceViewModel getInvoiceViewModel = Get.find();
  CheckInternationalViewModel checkInternationalViewModel = Get.find();
  String? invoiceAmount;
  final _formKey = GlobalKey<FormState>();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    Utility.countryCodeNumber = '+974';
    Utility.countryCode = 'QA';
    connectivityViewModel.startMonitoring();

    AnalyticsService.sendAppCurrentScreen('Invoice detail Screen');

    Utility.isFastInvoice = false;
    checkInterNational();

    ///when edit screen
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [topView(), spaceContainer(), bottomView()],
                    ),
                  )),
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                Utility.isFastInvoice = false;
                setState(() {});
                checkInterNational();

                ///when edit screen
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
              Utility.isFastInvoice = false;
              setState(() {});
              checkInterNational();

              ///when edit screen
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

  void initData() async {
    ///when edit screen
    if (widget.invoiceDetail != null) {
      invoiceAmount = widget.invoiceDetail!['grossAmount'].toString();
      print('invoice amount$invoiceAmount');

      ///data
      Utility.custNo = widget.invoiceDetail!['custName'];
      Utility.description = widget.invoiceDetail!['description'];
      Utility.isNotify = widget.invoiceDetail!['read'];
      Utility.isDescription =
      widget.invoiceDetail!['description'] == '' ? false : true;
      countryCode = Utility.countryCodeNumber;
      String mob = widget.invoiceDetail!['mobNo'];
      String cc = mob.substring(0, mob.indexOf('-')).replaceAll('+', '');
      String mn = mob.substring(mob.indexOf('-') + 1);
      Utility.countryCodeNumber = cc;
      Utility.mobNo = mn;
      print('mob is $mn');
      print('Utility.countryCode 0 ${Utility.countryCode}');

      await countryCodeGetApiCall(cc);
      print('Utility.countryCode  3 ${Utility.countryCode}');

      ///item
      widget.invoiceDetail!['itemList'].forEach((element) {
        String? productId;
        String? img;
        element.productId == null
            ? ''
            : element.product.productmedia.forEach((productMedia) {
          productId = productMedia.productId.toString();
          img = productMedia.name;
        });

        Map<String, dynamic> data = {
          "title": element.productId == null
              ? element.description
              : element.product.name,
          "icon": element.productId == null || img == null
              ? null
              : '${Constants.productContainer}$img',
          "value": element.productId == null
              ? ''
              : element.product.totalavailablequantity,
          "amount": element.productId == null
              ? element.quantity == 0
              ? 0
              : (element.amount / element.quantity).toInt()
              : element.product.price,
          'deletedAt': null,
          'prId': element.id,
          "quantity": element.quantity,
          'id': element.productId == null ? '' : productId
        };
        Utility.selectedProductData.add(data);
      });
    }
    mobileNumber.text = Utility.mobNo;
    customerName.text = Utility.custNo;
    description.text = Utility.description;
    isInvoiceViewed = Utility.isNotify;
    isDescription = Utility.isDescription;
    countryCode = Utility.countryCodeNumber;

    print('list ${Utility.selectedProductData}');
  }

  Padding bottomView() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///invoice items row
          Row(
            children: [
              Text(
                'Invoice Items'.tr,
                style: ThemeUtils.blackBold
                    .copyWith(fontSize: FontUtils.mediumSmall),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  print('hhiiiiii1');
                  final result =
                  await Get.to(() => CreateDetailedInvoiceAddItem());
                  print('DATA:+  ??>$result');
                  if (result == true) {
                    setState(() {});
                  }

                  print('result is $result');
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: ColorsUtils.accent,
                    ),
                    width10(),
                    Text(
                      'Add Items'.tr,
                      style: ThemeUtils.blackBold.copyWith(
                          fontSize: FontUtils.mediumSmall,
                          color: ColorsUtils.accent),
                    ),
                  ],
                ),
              ),
            ],
          ),

          ///items count
          Utility.selectedProductData.fold(
              0,
                  (p, e) =>
              (p as int) + (e['deletedAt'] == null ? 1 : 0)) ==
              0
              ? SizedBox()
              : Text(
            '${Utility.selectedProductData.fold(0, (p, e) => (p as int) + (e['deletedAt'] == null ? 1 : 0))} ${'Items'.tr}',
            style: ThemeUtils.blackBold
                .copyWith(fontSize: FontUtils.verySmall),
          ),
          height20(),

          ///selected  items
          Utility.selectedProductData.isEmpty
              ? Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset(
                  Images.noItemAdd,
                  width: 120,
                  height: 100,
                ),
                Text(
                  "You don't have any item added yet".tr,
                  style: ThemeUtils.blackRegular
                      .copyWith(fontSize: FontUtils.verySmall),
                )
              ],
            ),
          )
              : SizedBox(
            width: Get.width,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: Utility.selectedProductData.length,
              itemBuilder: (context, index) {
                return Utility.selectedProductData[index]['deletedAt'] ==
                    null
                    ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: ColorsUtils.border, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Utility.selectedProductData[index]
                              ['icon'] ==
                                  null
                                  ? Expanded(
                                flex: 1,
                                child: Container(
                                    width: 40,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                Images
                                                    .noImage)))),
                              )
                                  : Expanded(
                                flex: 1,
                                child: Container(
                                  width: 40,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius
                                          .circular(10)),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(
                                        10),
                                    child: Image.network(
                                      Utility.selectedProductData[
                                      index]['icon'],
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (BuildContext
                                      context,
                                          Widget child,
                                          ImageChunkEvent?
                                          loadingProgress) {
                                        if (loadingProgress ==
                                            null)
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
                              ),
                              width10(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${Utility.selectedProductData[index]['title']}',
                                      style: ThemeUtils.blackBold
                                          .copyWith(
                                          fontSize:
                                          FontUtils.small),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${double.parse(Utility.selectedProductData[index]['amount'].toString()).toStringAsFixed(2)} QAR',
                                          style: ThemeUtils
                                              .blackBold
                                              .copyWith(
                                              fontSize:
                                              FontUtils
                                                  .small),
                                        ),
                                        width20(),
                                        Utility.selectedProductData[
                                        index]
                                        ['value'] ==
                                            ''
                                            ? const SizedBox()
                                            : Image.asset(
                                          Images.basket,
                                          height: 20,
                                          width: 20,
                                        ),
                                        width10(),
                                        Utility.selectedProductData[
                                        index]
                                        ['value'] ==
                                            ''
                                            ? const SizedBox()
                                            : Text(
                                          "${Utility.selectedProductData[index]['value'] == 0 ? "∞" : Utility.selectedProductData[index]['value']}",
                                          style: ThemeUtils
                                              .blackBold
                                              .copyWith(
                                              fontSize:
                                              FontUtils
                                                  .small),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (widget.invoiceDetail !=
                                            null) {
                                          // Utility
                                          //     .selectedProductData
                                          //     .removeAt(index);
                                          Utility.selectedProductData[
                                          index][
                                          'deletedAt'] = DateFormat(
                                              'yyyy-MM-dd HH:mm:ss')
                                              .format(
                                              DateTime.now())
                                              .toString();
                                          print(
                                              '.....after delete list${Utility.selectedProductData}');
                                        } else {
                                          // Utility
                                          //     .selectedProductData
                                          //     .removeAt(index);
                                          Utility.selectedProductData[
                                          index][
                                          'deletedAt'] = DateFormat(
                                              'yyyy-MM-dd HH:mm:ss')
                                              .format(
                                              DateTime.now())
                                              .toString();
                                          print(
                                              'after delete list${Utility.selectedProductData}');
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      Images.delete,
                                      width: 25,
                                      height: 25,
                                    ),
                                  )),
                            ],
                          ),
                          height20(),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (Utility.selectedProductData[
                                    index]['quantity'] >
                                        1) {
                                      Utility.selectedProductData[
                                      index]['quantity'] -= 1;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                          ColorsUtils.border),
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  child: const Center(
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                child: Container(
                                  height: 25,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: ColorsUtils.border
                                          .withOpacity(0.5),
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      '${(Utility.selectedProductData[index]['quantity']).toInt()}',
                                      style:
                                      ThemeUtils.blackSemiBold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    // count++;
                                    if (Utility.selectedProductData[
                                    index]['value'] ==
                                        Utility.selectedProductData[
                                        index]['quantity']) {
                                      Get.snackbar('error',
                                          'you can not add more item');
                                    } else {
                                      Utility.selectedProductData[
                                      index]['quantity'] += 1;
                                    }
                                    print(
                                        'count${Utility.selectedProductData}');
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                          ColorsUtils.border),
                                      borderRadius:
                                      BorderRadius.circular(5)),
                                  child: const Center(
                                    child: Icon(Icons.add),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${(double.parse((Utility.selectedProductData[index]['quantity'] * Utility.selectedProductData[index]['amount']).toString()).toStringAsFixed(2))} QAR',
                                style: ThemeUtils.blackBold
                                    .copyWith(
                                    color: ColorsUtils.accent),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () async {
                  //     final data = await Get.to(
                  //         () => CreateDetailedInvoiceAddItem(
                  //               data: {
                  //                 "title":
                  //                     "${Utility.selectedProductData[index]['title']}",
                  //                 "amount":
                  //                     "${Utility.selectedProductData[index]['amount']}",
                  //                 "quantity":
                  //                     '${Utility.selectedProductData[index]['quantity']}',
                  //               },
                  //             ));
                  //     print('DATA:+>$data');
                  //     if (data != null) {
                  //       if (data is bool) {
                  //         setState(() {});
                  //       } else {
                  //         setState(() {
                  //           Utility.selectedProductData[index]
                  //               ['title'] = data['title'];
                  //           Utility.selectedProductData[index]
                  //               ['amount'] = data['amount'];
                  //           Utility.selectedProductData[index]
                  //               ['quantity'] = data['quantity'];
                  //         });
                  //       }
                  //     }
                  //   },
                  //   child: Container(
                  //     width: Get.width,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(12),
                  //         border: Border.all(
                  //             color: ColorsUtils.border, width: 1)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(20.0),
                  //       child: Column(
                  //         crossAxisAlignment:
                  //             CrossAxisAlignment.start,
                  //         mainAxisAlignment:
                  //             MainAxisAlignment.start,
                  //         children: [
                  //           Row(
                  //             crossAxisAlignment:
                  //                 CrossAxisAlignment.start,
                  //             children: [
                  //               Utility.selectedProductData[index]
                  //                           ['icon'] ==
                  //                       null
                  //                   ? const SizedBox()
                  //                   : Expanded(
                  //                       flex: 1,
                  //                       child: Container(
                  //                         width: 40,
                  //                         height: 50,
                  //                         decoration: BoxDecoration(
                  //                             borderRadius:
                  //                                 BorderRadius
                  //                                     .circular(
                  //                                         10)),
                  //                         child: ClipRRect(
                  //                           borderRadius:
                  //                               BorderRadius
                  //                                   .circular(10),
                  //                           child: Image.network(
                  //                             Utility.selectedProductData[
                  //                                 index]['icon'],
                  //                             fit: BoxFit.cover,
                  //                             loadingBuilder:
                  //                                 (BuildContext
                  //                                         context,
                  //                                     Widget child,
                  //                                     ImageChunkEvent?
                  //                                         loadingProgress) {
                  //                               if (loadingProgress ==
                  //                                   null)
                  //                                 return child;
                  //                               return Center(
                  //                                 child:
                  //                                     CircularProgressIndicator(
                  //                                   value: loadingProgress
                  //                                               .expectedTotalBytes !=
                  //                                           null
                  //                                       ? loadingProgress
                  //                                               .cumulativeBytesLoaded /
                  //                                           loadingProgress
                  //                                               .expectedTotalBytes!
                  //                                       : null,
                  //                                 ),
                  //                               );
                  //                             },
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //               width10(),
                  //               Expanded(
                  //                 flex: 5,
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.center,
                  //                   children: [
                  //                     Text(
                  //                       '${Utility.selectedProductData[index]['title']}',
                  //                       style: ThemeUtils.blackBold
                  //                           .copyWith(
                  //                               fontSize: FontUtils
                  //                                   .small),
                  //                     ),
                  //                     const SizedBox(
                  //                       height: 5,
                  //                     ),
                  //                     Row(
                  //                       children: [
                  //                         Text(
                  //                           '${double.parse(Utility.selectedProductData[index]['amount'].toString()).toStringAsFixed(2)} QAR',
                  //                           style: ThemeUtils
                  //                               .blackBold
                  //                               .copyWith(
                  //                                   fontSize:
                  //                                       FontUtils
                  //                                           .small),
                  //                         ),
                  //                         width20(),
                  //                         Utility.selectedProductData[
                  //                                         index]
                  //                                     ['value'] ==
                  //                                 ''
                  //                             ? const SizedBox()
                  //                             : Image.asset(
                  //                                 Images.basket,
                  //                                 height: 20,
                  //                                 width: 20,
                  //                               ),
                  //                         width10(),
                  //                         Utility.selectedProductData[
                  //                                         index]
                  //                                     ['value'] ==
                  //                                 ''
                  //                             ? const SizedBox()
                  //                             : Text(
                  //                                 "${Utility.selectedProductData[index]['value'] == 0 ? "∞" : Utility.selectedProductData[index]['value']}",
                  //                                 style: ThemeUtils
                  //                                     .blackBold
                  //                                     .copyWith(
                  //                                         fontSize:
                  //                                             FontUtils
                  //                                                 .small),
                  //                               ),
                  //                       ],
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               Expanded(
                  //                   flex: 1,
                  //                   child: Center(
                  //                       child: InkWell(
                  //                     onTap: () {
                  //                       setState(() {
                  //                         if (widget
                  //                                 .invoiceDetail !=
                  //                             null) {
                  //                           // Utility
                  //                           //     .selectedProductData
                  //                           //     .removeAt(index);
                  //                           Utility.selectedProductData[
                  //                                       index]
                  //                                   ['deletedAt'] =
                  //                               DateFormat(
                  //                                       'yyyy-MM-dd HH:mm:ss')
                  //                                   .format(DateTime
                  //                                       .now())
                  //                                   .toString();
                  //                           print(
                  //                               '.....after delete list${Utility.selectedProductData}');
                  //                         } else {
                  //                           // Utility
                  //                           //     .selectedProductData
                  //                           //     .removeAt(index);
                  //                           Utility.selectedProductData[
                  //                                       index]
                  //                                   ['deletedAt'] =
                  //                               DateFormat(
                  //                                       'yyyy-MM-dd HH:mm:ss')
                  //                                   .format(DateTime
                  //                                       .now())
                  //                                   .toString();
                  //                           print(
                  //                               'after delete list${Utility.selectedProductData}');
                  //                         }
                  //                       });
                  //                     },
                  //                     child: Image.asset(
                  //                       Images.delete,
                  //                       width: 25,
                  //                       height: 25,
                  //                     ),
                  //                   ))),
                  //             ],
                  //           ),
                  //           height20(),
                  //           Row(
                  //             children: [
                  //               InkWell(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     if (Utility.selectedProductData[
                  //                             index]['quantity'] >
                  //                         1) {
                  //                       Utility.selectedProductData[
                  //                           index]['quantity'] -= 1;
                  //                     }
                  //                   });
                  //                 },
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                       border: Border.all(
                  //                           color:
                  //                               ColorsUtils.border),
                  //                       borderRadius:
                  //                           BorderRadius.circular(
                  //                               5)),
                  //                   child: const Center(
                  //                     child: Icon(Icons.remove),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Padding(
                  //                 padding:
                  //                     const EdgeInsets.symmetric(
                  //                         horizontal: 5),
                  //                 child: Container(
                  //                   height: 25,
                  //                   width: 50,
                  //                   decoration: BoxDecoration(
                  //                       color: ColorsUtils.border
                  //                           .withOpacity(0.5),
                  //                       borderRadius:
                  //                           BorderRadius.circular(
                  //                               5)),
                  //                   child: Center(
                  //                     child: Text(
                  //                       '${(Utility.selectedProductData[index]['quantity']).toInt()}',
                  //                       style: ThemeUtils
                  //                           .blackSemiBold,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               InkWell(
                  //                 onTap: () {
                  //                   setState(() {
                  //                     // count++;
                  //                     if (Utility.selectedProductData[
                  //                             index]['value'] ==
                  //                         Utility.selectedProductData[
                  //                             index]['quantity']) {
                  //                       Get.snackbar('error',
                  //                           'you can not add more item');
                  //                     } else {
                  //                       Utility.selectedProductData[
                  //                           index]['quantity'] += 1;
                  //                     }
                  //                     print(
                  //                         'count${Utility.selectedProductData}');
                  //                   });
                  //                 },
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                       border: Border.all(
                  //                           color:
                  //                               ColorsUtils.border),
                  //                       borderRadius:
                  //                           BorderRadius.circular(
                  //                               5)),
                  //                   child: const Center(
                  //                     child: Icon(Icons.add),
                  //                   ),
                  //                 ),
                  //               ),
                  //               const Spacer(),
                  //               Text(
                  //                 '${Utility.selectedProductData[index]['quantity'] * Utility.selectedProductData[index]['amount']} QAR',
                  //                 style: ThemeUtils.blackBold
                  //                     .copyWith(
                  //                         color:
                  //                             ColorsUtils.accent),
                  //               ),
                  //             ],
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                )
                    : SizedBox();
              },
            ),
          ),
          height40(),

          ///bottom container
          Container(
            decoration: BoxDecoration(
              color: ColorsUtils.border.withOpacity(0.3),
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
                  //       '${Utility.selectedProductData.isEmpty ? '0' : Utility.selectedProductData.fold(0, (p, e) => (p as int) + (e['amount'] * e['quantity']))} QAR',
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
                  //           fontSize: FontUtils.small,
                  //           color: ColorsUtils.accent),
                  //     ),
                  //   ],
                  // ),
                  // dividerData(),
                  Row(
                    children: [
                      Text(
                        'Invoice Amount'.tr,
                        style: ThemeUtils.blackBold,
                      ),
                      const Spacer(),
                      Text(
                        '${Utility.selectedProductData.isEmpty ? invoiceAmount != null ? invoiceAmount! : '0' : double.parse(Utility.selectedProductData.fold(0, (p, e) => (double.parse('$p')) + (e['deletedAt'] == null ? (e['amount'] * e['quantity']) : 0)).toString()).toStringAsFixed(2)} QAR',
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.small,
                            color: ColorsUtils.accent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          height20(),

          ///send data or save draft
          Row(
            children: [
              ///save draft
              widget.invoiceDetail == null
                  ? InkWell(
                onTap: () async {
                  print('save draft click');
                  await saveDraftApiCall();
                },
                child: commonButtonBox(
                    img: Images.saveDraft,
                    text: 'Save Draft'.tr,
                    color: ColorsUtils.saveDraftButton),
              )
                  : widget.invoiceDetail!['type'] == 2
                  ? SizedBox()
                  : InkWell(
                onTap: () async {
                  print('save draft click');
                  await editInvoiceApiCall('1');
                },
                child: commonButtonBox(
                    img: Images.saveDraft,
                    text: 'Save Draft'.tr,
                    color: ColorsUtils.saveDraftButton),
              ),
              widget.invoiceDetail == null
                  ? width20()
                  : widget.invoiceDetail!['type'] == 2
                  ? SizedBox()
                  : width20(),

              ///send invoice
              Expanded(
                  child: InkWell(
                    onTap: () async {
                      ///edit invoice api call
                      if (widget.invoiceDetail != null) {
                        await editInvoiceApiCall('2');
                      } else {
                        ///create invoice api call
                        await createInvoiceApiCall();
                      }
                    },
                    child: commonButtonBox(
                        img: Images.send,
                        text: widget.invoiceDetail == null
                            ? 'Send Invoice'.tr
                            : widget.invoiceDetail!['type'] == 2
                            ? 'Save Invoice'.tr
                            : 'Send Invoice'.tr,
                        color: ColorsUtils.invoiceAmount),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Future<void> editInvoiceApiCall(String status) async {
    print('edit api');
    if (_formKey.currentState!.validate()) {
      if (Utility.userPhone != mobileNumber.text) {
        connectivityViewModel.startMonitoring();

        if (connectivityViewModel.isOnline != null) {
          if (connectivityViewModel.isOnline!) {
            ///Api call
            if (widget.invoiceDetail != null) {
              if (Utility.selectedProductData.isNotEmpty &&
                  double.parse(double.parse(Utility.selectedProductData
                      .fold(
                      0,
                          (p, e) =>
                      (double.parse('$p')) +
                          (e['deletedAt'] == null
                              ? (e['amount'] * e['quantity'])
                              : 0))
                      .toString())
                      .toStringAsFixed(2)) !=
                      0) {
                showLoadingDialog(context: context);
                Utility.invoiceStatusId = status;

                List<EditInvoicedetails> invoiceDetailsList = [];

                Utility.selectedProductData.forEach((element) {
                  EditInvoicedetails data = EditInvoicedetails();
                  data.quantity = element['quantity'].toString();
                  data.description = element['title'];
                  data.invoiceId = int.parse(widget.transId!);
                  data.amount =
                  '${double.parse((element['quantity'] * element['amount']).toString()).toStringAsFixed(2)}';
                  data.deletedAt = element['deletedAt'];
                  data.id = element['prId'];
                  element['id'] == '' ? '' : data.productId = element['id'];
                  invoiceDetailsList.add(data);
                });
                String id = await encryptedSharedPreferences.getString('id');
                editInvoiceReq.clientname = customerName.text;
                editInvoiceReq.paymentduedate = DateTime.now().toString();
                editInvoiceReq.createdby = id;
                editInvoiceReq.grossamount = Utility.selectedProductData.isEmpty
                    ? invoiceAmount != null
                    ? invoiceAmount!
                    : '0'
                    : '${double.parse((Utility.selectedProductData.fold(0, (p, e) => (double.parse('$p')) + (e['deletedAt'] == null ? (e['amount'] * e['quantity']) : 0))).toString()).toStringAsFixed(2)}';
                // editInvoiceReq.grossamount = (Utility.selectedProductData.fold(
                //         0,
                //         (p, e) =>
                //             (double.parse('$p')) + (e['amount'] * e['quantity'])))
                //     .toString();
                editInvoiceReq.invoicedetails = invoiceDetailsList;
                editInvoiceReq.cellno =
                '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';
                // '${(Utility.countryCodeNumber).contains('+') ? Utility.countryCodeNumber : '+${Utility.countryCodeNumber}'}-${mobileNumber.text}';
                editInvoiceReq.invoicestatusId =
                    int.parse(Utility.invoiceStatusId);
                editInvoiceReq.remarks = description.text;
                editInvoiceReq.remarksenabled = isInvoiceViewed;
                editInvoiceReq.invoicesenderId = id;
                editInvoiceReq.readreceipt = Utility.isNotify;
                print("REQUEST ${jsonEncode(editInvoiceReq)}");
                final url = Uri.parse(
                    '${Utility.baseUrl}invoices/${widget.transId}?filter[include][invoicedetails][product]=productmedia');
                String token =
                await encryptedSharedPreferences.getString('token');
                Map<String, String> header = {
                  'Content-Type': 'application/json',
                  'Authorization': token,
                };
                print('urllllllll$url');
                // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
                var result = await http.patch(
                  url,
                  headers: header,
                  body: jsonEncode(editInvoiceReq),
                );
                if (result.statusCode == 200) {
                  Utility.isFastInvoice = true;
                  print('statusid::${Utility.invoiceStatusId}');

                  // print('invoice id${response.id}');

                  Get.snackbar(
                      'Success'.tr,
                      status == '1'
                          ? 'Edit Invoice successFully'.tr
                          : widget.invoiceDetail!['type'] == 2
                          ? 'Invoice Save SuccessFully'
                          : 'Invoice Send SuccessFully');
                  hideLoadingDialog(context: context);
                  AnalyticsService.sendEvent(
                      'Quick Invoice success', jsonDecode(result.body));
                  print('invoice id${jsonDecode(result.body)['id']}');

                  Future.delayed(const Duration(seconds: 1), () {
                    Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
                  });
                } else if (result.statusCode == 499) {
                  hideLoadingDialog(context: context);

                  Get.off(() => UnderMaintenanceScreen());
                } else {
                  hideLoadingDialog(context: context);
                  print('error${jsonDecode(result.body)['error']['message']}');

                  Get.snackbar(
                    'error'.tr,
                    '${jsonDecode(result.body)['error']['message']}',
                  );
                  AnalyticsService.sendEvent('Quick Invoice failure', {
                    'Id': Utility.userId,
                  });
                  // Get.snackbar('error'.tr, 'Something wrong');
                }
              } else {
                Get.snackbar('error'.tr, "You don't have any item added yet".tr);
              }
            } else {
              if (Utility.selectedProductData.isNotEmpty &&
                  double.parse(double.parse(Utility.selectedProductData
                      .fold(
                      0,
                          (p, e) =>
                      (double.parse('$p')) +
                          (e['deletedAt'] == null
                              ? (e['amount'] * e['quantity'])
                              : 0))
                      .toString())
                      .toStringAsFixed(2)) !=
                      0) {
                showLoadingDialog(context: context);

                List<EditInvoicedetails> invoiceDetailsList = [];
                Utility.invoiceStatusId = '2';

                Utility.selectedProductData.forEach((element) {
                  EditInvoicedetails data = EditInvoicedetails();
                  data.quantity = element['quantity'].toString();
                  data.description = element['title'];
                  data.invoiceId = int.parse(widget.transId!);
                  data.deletedAt = element['deletedAt'];
                  data.amount =
                  '${double.parse((element['quantity'] * element['amount']).toString()).toStringAsFixed(2)}';
                  data.id = element['prId'];
                  element['id'] == '' ? '' : data.productId = element['id'];
                  invoiceDetailsList.add(data);
                });
                String id = await encryptedSharedPreferences.getString('id');
                editInvoiceReq.clientname = customerName.text;
                editInvoiceReq.paymentduedate = DateTime.now().toString();
                editInvoiceReq.createdby = id;

                // editInvoiceReq.grossamount = (Utility.selectedProductData.fold(
                //         0,
                //         (p, e) =>
                //             (double.parse('$p')) + (e['amount'] * e['quantity'])))
                //     .toString();
                editInvoiceReq.grossamount = Utility.selectedProductData.isEmpty
                    ? invoiceAmount != null
                    ? invoiceAmount!
                    : '0'
                    : '${double.parse((Utility.selectedProductData.fold(0, (p, e) => (double.parse('$p')) + (e['deletedAt'] == null ? (e['amount'] * e['quantity']) : 0))).toString()).toStringAsFixed(2)}';
                editInvoiceReq.invoicedetails = invoiceDetailsList;
                editInvoiceReq.cellno =
                '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';

                // '${(Utility.countryCodeNumber).contains('+') ? Utility.countryCodeNumber : '+${Utility.countryCodeNumber}'}-${mobileNumber.text}';
                editInvoiceReq.invoicestatusId = Utility.invoiceStatusId;
                editInvoiceReq.remarks = description.text;
                editInvoiceReq.invoicesenderId = id;
                editInvoiceReq.remarksenabled = isInvoiceViewed;
                editInvoiceReq.readreceipt = Utility.isNotify;
                print("REQUEST ${jsonEncode(editInvoiceReq)}");
                final url = Uri.parse(
                    '${Utility.baseUrl}invoices/${widget.transId}?filter[include][invoicedetails][product]=productmedia');
                String token =
                await encryptedSharedPreferences.getString('token');
                Map<String, String> header = {
                  'Content-Type': 'application/json',
                  'Authorization': token,
                };
                print('urllllllll$url');
                // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
                var result = await http.patch(
                  url,
                  headers: header,
                  body: jsonEncode(editInvoiceReq),
                );
                if (result.statusCode == 200) {
                  Utility.selectedProductData.clear();
                  invoiceDetailsList.clear();
                  //
                  ///local storage values
                  Utility.mobNo = '';
                  Utility.custNo = '';
                  Utility.description = '';
                  Utility.countryCode = 'QA';
                  Utility.countryCodeNumber = '+974';
                  Utility.isDescription = false;
                  Utility.isNotify = false;
                  Utility.isFastInvoice == false;
                  // print('invoice id${response.id}');
                  hideLoadingDialog(context: context);

                  Get.snackbar(
                      'Success'.tr,
                      status == '1'
                          ? 'Edit Invoice successFully'.tr
                          : widget.invoiceDetail!['type'] == 2
                          ? 'Invoice Save SuccessFully'
                          : 'Invoice Send SuccessFully');
                  AnalyticsService.sendEvent(
                      'detail Invoice success', jsonDecode(result.body));
                  print('invoice id${jsonDecode(result.body)['id']}');

                  Future.delayed(const Duration(seconds: 1), () {
                    Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
                  });
                } else if (result.statusCode == 499) {
                  hideLoadingDialog(context: context);

                  Get.off(() => UnderMaintenanceScreen());
                } else {
                  hideLoadingDialog(context: context);
                  print('error${jsonDecode(result.body)['error']['message']}');

                  Get.snackbar(
                    'error'.tr,
                    '${jsonDecode(result.body)['error']['message']}',
                  );
                  AnalyticsService.sendEvent('Quick Invoice failure', {
                    'Id': Utility.userId,
                  });
                  // Get.snackbar('error'.tr, 'Something wrong');
                }
                // await getInvoiceViewModel.editInvoice(
                //     widget.transId!, editInvoiceReq);
                //
                // if (getInvoiceViewModel.editInvoiceApiResponse.status ==
                //     Status.COMPLETE) {
                //   Utility.selectedProductData.clear();
                //   invoiceDetailsList.clear();
                //   //
                //   ///local storage values
                //   Utility.mobNo = '';
                //   Utility.custNo = '';
                //   Utility.description = '';
                //   Utility.countryCode = 'QA';
                //   Utility.countryCodeNumber = '+974';
                //   Utility.isDescription = false;
                //   Utility.isNotify = false;
                //   //
                //   GetInvoiceResponseModel response =
                //       getInvoiceViewModel.editInvoiceApiResponse.data;
                //   print('invoice id${response.id}');
                //   // Utility.isFastInvoice == false;
                //   Get.snackbar('Success'.tr, 'Invoice save successFully'.tr);
                //   hideLoadingDialog(context: context);
                //
                //   Future.delayed(Duration(seconds: 1), () {
                //     print('done');
                //     Get.off(() => InvoiceDetailScreen(
                //           invoiceId: response.id.toString(),
                //         ));
                //   });
                // } else {
                //   hideLoadingDialog(context: context);
                //
                //   Get.snackbar('error'.tr, 'Something wrong'.tr);
                //   const SessionExpire();
                // }
              } else {
                Get.snackbar('error'.tr, "You don't have any item added yet".tr);
              }
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection'.tr);
          }
        } else {
          Get.snackbar('error'.tr, 'Please check your connection'.tr);
        }
      } else {
        Get.snackbar('error'.tr, 'you can not create invoice by your self');
      }
    }
  }

  Future<void> saveDraftApiCall() async {
    if (_formKey.currentState!.validate()) {
      print('validate');
      print(Utility.selectedProductData);
      connectivityViewModel.startMonitoring();

      if (connectivityViewModel.isOnline != null) {
        if (connectivityViewModel.isOnline!) {
          ///Api call
          if (Utility.userPhone != mobileNumber.text) {
            if (widget.invoiceDetail != null) {
              if (Utility.selectedProductData.isNotEmpty &&
                  (double.parse(double.parse(Utility.selectedProductData
                      .fold(
                      0,
                          (p, e) =>
                      (double.parse('$p')) +
                          (e['deletedAt'] == null
                              ? (e['amount'] * e['quantity'])
                              : 0))
                      .toString())
                      .toStringAsFixed(2)) !=
                      0)) {
                showLoadingDialog(context: context);

                Utility.invoiceStatusId = '1';
                List<CreateInvoicedetails> invoiceDetailsList = [];
                Utility.selectedProductData.forEach((element) {
                  if (element['deletedAt'] == null) {
                    CreateInvoicedetails data = CreateInvoicedetails();
                    data.quantity = element['quantity'].toString();
                    data.amount =
                    '${double.parse((element['quantity'] * element['amount']).toString()).toStringAsFixed(2)}';
                    data.description = element['title'];
                    element['id'] == '' ? '' : data.productId = element['id'];
                    invoiceDetailsList.add(data);
                  }
                });
                String id = await encryptedSharedPreferences.getString('id');
                createInvoicesReq.clientname = customerName.text;
                createInvoicesReq.paymentduedate = DateTime.now().toString();
                createInvoicesReq.createdby = id;
                createInvoicesReq.remarksenabled = isInvoiceViewed;
                // createInvoicesReq.grossamount = (Utility.selectedProductData.fold(
                //     0, (p, e) => (double.parse('$p')) + (e['amount']))).toString();
                createInvoicesReq.grossamount = Utility
                    .selectedProductData.isEmpty
                    ? invoiceAmount != null
                    ? invoiceAmount!
                    : '0'
                    : '${double.parse((Utility.selectedProductData.fold(0, (p, e) => (double.parse('$p')) + (e['deletedAt'] == null ? (e['amount'] * e['quantity']) : 0))).toString()).toStringAsFixed(2)}';
                createInvoicesReq.invoicedetails = invoiceDetailsList;
                createInvoicesReq.cellno =
                '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';

                // '${(Utility.countryCodeNumber).contains('+') ? Utility.countryCodeNumber : '+${Utility.countryCodeNumber}'}-${mobileNumber.text}';
                createInvoicesReq.invoicestatusId = Utility.invoiceStatusId;
                createInvoicesReq.remarks = description.text;
                createInvoicesReq.invoicesenderId = id;
                createInvoicesReq.readreceipt = Utility.isNotify;
                print("REQUEST ${jsonEncode(createInvoicesReq)}");
                final url = Uri.parse('${Utility.baseUrl}invoices');
                String token =
                await encryptedSharedPreferences.getString('token');
                Map<String, String> header = {
                  'Content-Type': 'application/json',
                  'Authorization': token,
                };
                // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
                var result = await http.post(
                  url,
                  headers: header,
                  body: jsonEncode(createInvoicesReq),
                );
                if (result.statusCode == 200) {
                  Utility.selectedProductData.clear();

                  invoiceDetailsList.clear();
                  //
                  ///local storage values
                  Utility.mobNo = '';
                  Utility.custNo = '';
                  Utility.description = '';
                  Utility.countryCode = 'QA';
                  Utility.countryCodeNumber = '+974';
                  Utility.isDescription = false;
                  Utility.isNotify = false;
                  Get.snackbar('Success'.tr, 'Invoice has been drafted '.tr);
                  Utility.isFastInvoice == false;
                  print('is this fast invoice::::::::${Utility.isFastInvoice}');
                  hideLoadingDialog(context: context);

                  Future.delayed(Duration(seconds: 1), () {
                    print('done');
                    Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
                  });
                } else if (result.statusCode == 499) {
                  hideLoadingDialog(context: context);

                  Get.off(() => UnderMaintenanceScreen());
                } else {
                  hideLoadingDialog(context: context);
                  Get.snackbar(
                    'error'.tr,
                    '${jsonDecode(result.body)['error']['message']}',
                  );
                  AnalyticsService.sendEvent('Detail Invoice failure', {
                    'Id': Utility.userId,
                  });
                  // Get.snackbar('error'.tr, 'Something wrong');
                }
                // await createInvoiceViewModel.createInvoice(createInvoicesReq);
                //
                // if (createInvoiceViewModel.createInvoiceApiResponse.status ==
                //     Status.COMPLETE) {
                //   Utility.selectedProductData.clear();
                //   invoiceDetailsList.clear();
                //   //
                //   ///local storage values
                //   Utility.mobNo = '';
                //   Utility.custNo = '';
                //   Utility.description = '';
                //   Utility.countryCode = 'QA';
                //   Utility.countryCodeNumber = '+974';
                //   Utility.isDescription = false;
                //   Utility.isNotify = false;
                //   //
                //   CreateInvoiceResponseModel response =
                //       createInvoiceViewModel.createInvoiceApiResponse.data;
                //   print('invoice id${response.id}');
                //
                //   Get.snackbar('Success'.tr, 'Invoice has been drafted '.tr);
                //   Utility.isFastInvoice == false;
                //   print('is this fast invoice::::::::${Utility.isFastInvoice}');
                //   hideLoadingDialog(context: context);
                //
                //   Future.delayed(Duration(seconds: 1), () {
                //     print('done');
                //     Get.off(() => InvoiceDetailScreen(
                //           invoiceId: response.id.toString(),
                //         ));
                //   });
                // } else {
                //   hideLoadingDialog(context: context);
                //
                //   Get.snackbar('error'.tr, 'Something wrong'.tr);
                //   const SessionExpire();
                // }
              } else {
                Get.snackbar('error'.tr, "You don't have any item added yet".tr);
              }

              // }
            } else {
              print(
                  'draft comming:::::invoiceAmount------${invoiceAmount}-------value=====${double.parse(Utility.selectedProductData.fold(0, (p, e) => (double.parse('$p')) + (e['deletedAt'] == null ? (e['amount'] * e['quantity']) : 0)).toString()).toStringAsFixed(2)}');
              if (Utility.selectedProductData.isNotEmpty &&
                  (double.parse(double.parse(Utility.selectedProductData
                      .fold(
                      0,
                          (p, e) =>
                      (double.parse('$p')) +
                          (e['deletedAt'] == null
                              ? (e['amount'] * e['quantity'])
                              : 0))
                      .toString())
                      .toStringAsFixed(2)) !=
                      0)) {
                showLoadingDialog(context: context);

                Utility.invoiceStatusId = '1';
                List<CreateInvoicedetails> invoiceDetailsList = [];
                Utility.selectedProductData.forEach((element) {
                  if (element['deletedAt'] == null) {
                    CreateInvoicedetails data = CreateInvoicedetails();
                    data.quantity = element['quantity'].toString();
                    data.amount =
                    '${double.parse((element['quantity'] * element['amount']).toString()).toStringAsFixed(2)}';
                    data.description = element['title'];
                    element['id'] == '' ? '' : data.productId = element['id'];
                    invoiceDetailsList.add(data);
                  }
                });
                String id = await encryptedSharedPreferences.getString('id');
                createInvoicesReq.clientname = customerName.text;
                createInvoicesReq.paymentduedate = DateTime.now().toString();
                createInvoicesReq.createdby = id;
                createInvoicesReq.grossamount = Utility
                    .selectedProductData.isEmpty
                    ? invoiceAmount != null
                    ? invoiceAmount!
                    : '0'
                    : '${double.parse((Utility.selectedProductData.fold(0, (p, e) => (double.parse('$p')) + (e['deletedAt'] == null ? (e['amount'] * e['quantity']) : 0))).toString()).toStringAsFixed(2)}';
                createInvoicesReq.invoicedetails = invoiceDetailsList;
                createInvoicesReq.cellno =
                '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';

                // '${(Utility.countryCodeNumber).contains('+') ? Utility.countryCodeNumber : '+${Utility.countryCodeNumber}'}-${mobileNumber.text}';
                createInvoicesReq.invoicestatusId = Utility.invoiceStatusId;
                createInvoicesReq.remarks = description.text;
                createInvoicesReq.invoicesenderId = id;
                createInvoicesReq.remarksenabled = isInvoiceViewed;
                createInvoicesReq.readreceipt = Utility.isNotify;
                print("REQUEST ${jsonEncode(createInvoicesReq)}");
                final url = Uri.parse('${Utility.baseUrl}invoices');
                String token =
                await encryptedSharedPreferences.getString('token');
                Map<String, String> header = {
                  'Content-Type': 'application/json',
                  'Authorization': token,
                };
                // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
                var result = await http.post(
                  url,
                  headers: header,
                  body: jsonEncode(createInvoicesReq),
                );
                if (result.statusCode == 200) {
                  Utility.selectedProductData.clear();

                  invoiceDetailsList.clear();
                  //
                  ///local storage values
                  Utility.mobNo = '';
                  Utility.custNo = '';
                  Utility.description = '';
                  Utility.countryCode = 'QA';
                  Utility.countryCodeNumber = '+974';
                  Utility.isDescription = false;
                  Utility.isNotify = false;
                  Get.snackbar('Success'.tr, 'Invoice has been drafted '.tr);
                  Utility.isFastInvoice == false;
                  print('is this fast invoice::::::::${Utility.isFastInvoice}');
                  hideLoadingDialog(context: context);

                  Future.delayed(Duration(seconds: 1), () {
                    print('done');
                    Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
                  });
                } else if (result.statusCode == 499) {
                  hideLoadingDialog(context: context);

                  Get.off(() => UnderMaintenanceScreen());
                } else {
                  hideLoadingDialog(context: context);
                  Get.snackbar(
                    'error'.tr,
                    '${jsonDecode(result.body)['error']['message']}',
                  );
                  AnalyticsService.sendEvent('Detail Invoice failure', {
                    'Id': Utility.userId,
                  });
                  // Get.snackbar('error'.tr, 'Something wrong');
                }
                // await createInvoiceViewModel.createInvoice(createInvoicesReq);
                //
                // if (createInvoiceViewModel.createInvoiceApiResponse.status ==
                //     Status.COMPLETE) {
                //   Utility.selectedProductData.clear();
                //   invoiceDetailsList.clear();
                //   //
                //   ///local storage values
                //   Utility.mobNo = '';
                //   Utility.custNo = '';
                //   Utility.description = '';
                //   Utility.countryCode = 'QA';
                //   Utility.countryCodeNumber = '+974';
                //   Utility.isDescription = false;
                //   Utility.isNotify = false;
                //   //
                //   CreateInvoiceResponseModel response =
                //       createInvoiceViewModel.createInvoiceApiResponse.data;
                //   print('invoice id${response.id}');
                //
                //   Get.snackbar('Success'.tr, 'Invoice has been drafted');
                //   Utility.isFastInvoice == false;
                //   print('is this fast invoice::::::::${Utility.isFastInvoice}');
                //   hideLoadingDialog(context: context);
                //
                //   Future.delayed(Duration(seconds: 1), () {
                //     print('done');
                //     Get.off(() => InvoiceDetailScreen(
                //           invoiceId: response.id.toString(),
                //         ));
                //   });
                // } else {
                //   hideLoadingDialog(context: context);
                //
                //   Get.snackbar('error'.tr, 'Something wrong'.tr);
                //   const SessionExpire();
                // }
                // }
              } else {
                Get.snackbar('error'.tr, "You don't have any item added yet".tr);
              }
            }
          } else {
            Get.snackbar('error'.tr, "Invoice cannot be created for self");
          }
        } else {
          Get.snackbar('error'.tr, 'Please check your connection'.tr);
        }
      } else {
        Get.snackbar('error'.tr, 'Please check your connection'.tr);
      }
    } else {
      Get.snackbar('error'.tr, 'please fill data'.tr);
    }
  }

  Future<void> createInvoiceApiCall() async {
    if (_formKey.currentState!.validate()) {
      if (Utility.userPhone != mobileNumber.text) {
        ///Api call
        connectivityViewModel.startMonitoring();

        if (connectivityViewModel.isOnline != null) {
          if (connectivityViewModel.isOnline!) {
            if (widget.invoiceDetail != null) {
              if (Utility.selectedProductData.isNotEmpty &&
                  (double.parse(double.parse(Utility.selectedProductData
                      .fold(
                      0,
                          (p, e) =>
                      (double.parse('$p')) +
                          (e['deletedAt'] == null
                              ? (e['amount'] * e['quantity'])
                              : 0))
                      .toString())
                      .toStringAsFixed(2)) !=
                      0)) {
                showLoadingDialog(context: context);
                List<CreateInvoicedetails> invoiceDetailsList = [];
                Utility.invoiceStatusId = '2';
                Utility.selectedProductData.forEach((element) {
                  if (element['deletedAt'] == null) {
                    CreateInvoicedetails data = CreateInvoicedetails();
                    data.quantity = element['quantity'].toString();
                    data.amount =
                    '${double.parse((element['quantity'] * element['amount']).toString()).toStringAsFixed(2)}';
                    data.description = element['title'];
                    element['id'] == '' ? '' : data.productId = element['id'];
                    invoiceDetailsList.add(data);
                  }
                });
                String id = await encryptedSharedPreferences.getString('id');
                createInvoicesReq.clientname = customerName.text;
                createInvoicesReq.paymentduedate = DateTime.now().toString();
                createInvoicesReq.createdby = id;
                createInvoicesReq.grossamount = Utility
                    .selectedProductData.isEmpty
                    ? invoiceAmount != null
                    ? invoiceAmount!
                    : '0'
                    : '${double.parse((Utility.selectedProductData.fold(0, (p, e) => (double.parse('$p')) + (e['deletedAt'] == null ? (e['amount'] * e['quantity']) : 0))).toString()).toStringAsFixed(2)}';
                createInvoicesReq.invoicedetails = invoiceDetailsList;
                createInvoicesReq.cellno =
                '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';
                createInvoicesReq.invoicestatusId = Utility.invoiceStatusId;
                createInvoicesReq.remarks = description.text;
                createInvoicesReq.invoicesenderId = id;
                createInvoicesReq.remarksenabled = isInvoiceViewed;

                createInvoicesReq.readreceipt = Utility.isNotify;
                print("REQUEST ${jsonEncode(createInvoicesReq)}");
                final url = Uri.parse('${Utility.baseUrl}invoices');
                String token =
                await encryptedSharedPreferences.getString('token');
                Map<String, String> header = {
                  'Content-Type': 'application/json',
                  'Authorization': token,
                };
                // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
                var result = await http.post(
                  url,
                  headers: header,
                  body: jsonEncode(createInvoicesReq),
                );
                if (result.statusCode == 200) {
                  Utility.selectedProductData.clear();

                  invoiceDetailsList.clear();
                  //
                  ///local storage values
                  Utility.mobNo = '';
                  Utility.custNo = '';
                  Utility.description = '';
                  Utility.countryCode = 'QA';
                  Utility.countryCodeNumber = '+974';
                  Utility.isDescription = false;
                  Utility.isNotify = false;
                  Get.snackbar('Success'.tr, 'Invoice Send SuccessFully'.tr);
                  Utility.isFastInvoice == false;
                  print('is this fast invoice::::::::${Utility.isFastInvoice}');
                  hideLoadingDialog(context: context);

                  Future.delayed(Duration(seconds: 1), () {
                    print('done');
                    Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
                  });
                } else if (result.statusCode == 499) {
                  hideLoadingDialog(context: context);

                  Get.off(() => UnderMaintenanceScreen());
                } else {
                  hideLoadingDialog(context: context);
                  Get.snackbar(
                    'error'.tr,
                    '${jsonDecode(result.body)['error']['message']}',
                  );
                  AnalyticsService.sendEvent('Detail Invoice failure', {
                    'Id': Utility.userId,
                  });
                  // Get.snackbar('error'.tr, 'Something wrong');
                }
                // await createInvoiceViewModel.createInvoice(createInvoicesReq);
                //
                // if (createInvoiceViewModel.createInvoiceApiResponse.status ==
                //     Status.COMPLETE) {
                //   Utility.selectedProductData.clear();
                //
                //   invoiceDetailsList.clear();
                //   //
                //   ///local storage values
                //   Utility.mobNo = '';
                //   Utility.custNo = '';
                //   Utility.description = '';
                //   Utility.countryCode = 'QA';
                //   Utility.countryCodeNumber = '+974';
                //   Utility.isDescription = false;
                //   Utility.isNotify = false;
                //   //
                //   CreateInvoiceResponseModel response =
                //       createInvoiceViewModel.createInvoiceApiResponse.data;
                //   print('invoice id${response.id}');
                //
                //   Get.snackbar('Success'.tr, 'Invoice Send SuccessFully'.tr);
                //   Utility.isFastInvoice == false;
                //   print('is this fast invoice::::::::${Utility.isFastInvoice}');
                //   hideLoadingDialog(context: context);
                //
                //   Future.delayed(Duration(seconds: 1), () {
                //     print('done');
                //     Get.off(() => InvoiceDetailScreen(
                //           invoiceId: response.id.toString(),
                //         ));
                //   });
                // } else {
                //   hideLoadingDialog(context: context);
                //
                //   Get.snackbar('error'.tr, 'Something wrong'.tr);
                //   const SessionExpire();
                // }
              } else {
                Get.snackbar('error'.tr, "You don't have any item added yet".tr);
              }
            } else {
              if (Utility.selectedProductData.isNotEmpty &&
                  (double.parse(double.parse(Utility.selectedProductData
                      .fold(
                      0,
                          (p, e) =>
                      (double.parse('$p')) +
                          (e['deletedAt'] == null
                              ? (e['amount'] * e['quantity'])
                              : 0))
                      .toString())
                      .toStringAsFixed(2)) !=
                      0)) {
                showLoadingDialog(context: context);

                List<CreateInvoicedetails> invoiceDetailsList = [];
                Utility.invoiceStatusId = '2';
                Utility.selectedProductData.forEach((element) {
                  if (element['deletedAt'] == null) {
                    CreateInvoicedetails data = CreateInvoicedetails();
                    data.quantity = element['quantity'].toString();
                    data.amount =
                    '${double.parse((element['quantity'] * element['amount']).toString()).toStringAsFixed(2)}';
                    data.description = element['title'];
                    element['id'] == '' ? '' : data.productId = element['id'];
                    invoiceDetailsList.add(data);
                  }
                });
                String id = await encryptedSharedPreferences.getString('id');
                createInvoicesReq.clientname = customerName.text;
                createInvoicesReq.paymentduedate = DateTime.now().toString();
                createInvoicesReq.createdby = id;
                createInvoicesReq.grossamount = Utility
                    .selectedProductData.isEmpty
                    ? invoiceAmount != null
                    ? invoiceAmount!
                    : '0'
                    : '${double.parse((Utility.selectedProductData.fold(0, (p, e) => (double.parse('$p')) + (e['deletedAt'] == null ? (e['amount'] * e['quantity']) : 0))).toString()).toStringAsFixed(2)}';
                createInvoicesReq.invoicedetails = invoiceDetailsList;
                createInvoicesReq.cellno =
                // '${(Utility.countryCodeNumber).contains('+') ? Utility.countryCodeNumber : '+${Utility.countryCodeNumber}'}-${mobileNumber.text}';
                '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';
                createInvoicesReq.invoicestatusId = Utility.invoiceStatusId;
                createInvoicesReq.remarks = description.text;
                createInvoicesReq.invoicesenderId = id;
                createInvoicesReq.remarksenabled = isInvoiceViewed;
                createInvoicesReq.readreceipt = Utility.isNotify;
                print("REQUEST ${jsonEncode(createInvoicesReq)}");
                final url = Uri.parse('${Utility.baseUrl}invoices');
                String token =
                await encryptedSharedPreferences.getString('token');
                Map<String, String> header = {
                  'Content-Type': 'application/json',
                  'Authorization': token,
                };
                // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
                var result = await http.post(
                  url,
                  headers: header,
                  body: jsonEncode(createInvoicesReq),
                );
                if (result.statusCode == 200) {
                  Utility.selectedProductData.clear();

                  invoiceDetailsList.clear();
                  //
                  ///local storage values
                  Utility.mobNo = '';
                  Utility.custNo = '';
                  Utility.description = '';
                  Utility.countryCode = 'QA';
                  Utility.countryCodeNumber = '+974';
                  Utility.isDescription = false;
                  Utility.isNotify = false;
                  Get.snackbar('Success'.tr, 'Invoice Send SuccessFully'.tr);
                  Utility.isFastInvoice == false;
                  print('is this fast invoice::::::::${Utility.isFastInvoice}');
                  hideLoadingDialog(context: context);

                  Future.delayed(Duration(seconds: 1), () {
                    print('done');
                    Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
                  });
                } else if (result.statusCode == 499) {
                  hideLoadingDialog(context: context);

                  Get.off(() => UnderMaintenanceScreen());
                } else {
                  hideLoadingDialog(context: context);
                  Get.snackbar(
                    'error'.tr,
                    '${jsonDecode(result.body)['error']['message']}',
                  );
                  AnalyticsService.sendEvent('Detail Invoice failure', {
                    'Id': Utility.userId,
                  });
                  // Get.snackbar('error'.tr, 'Something wrong');
                }
                // await createInvoiceViewModel.createInvoice(createInvoicesReq);
                //
                // if (createInvoiceViewModel.createInvoiceApiResponse.status ==
                //     Status.COMPLETE) {
                //   Utility.selectedProductData.clear();
                //   invoiceDetailsList.clear();
                //   //
                //   ///local storage values
                //   Utility.mobNo = '';
                //   Utility.custNo = '';
                //   Utility.description = '';
                //   Utility.countryCode = 'QA';
                //   Utility.countryCodeNumber = '+974';
                //   Utility.isDescription = false;
                //   Utility.isNotify = false;
                //   //
                //   CreateInvoiceResponseModel response =
                //       createInvoiceViewModel.createInvoiceApiResponse.data;
                //   print('invoice id${response.id}');
                //
                //   Get.snackbar('Success'.tr, 'Invoice Send SuccessFully'.tr);
                //   Utility.isFastInvoice == false;
                //   print('is this fast invoice::::::::${Utility.isFastInvoice}');
                //   hideLoadingDialog(context: context);
                //
                //   Future.delayed(Duration(seconds: 1), () {
                //     print('done');
                //     Get.off(() => InvoiceDetailScreen(
                //           invoiceId: response.id.toString(),
                //         ));
                //   });
                // } else {
                //   Get.snackbar('error'.tr, 'Something wrong'.tr);
                //   hideLoadingDialog(context: context);
                //
                //   const SessionExpire();
                // }
              } else {
                Get.snackbar('error'.tr, "You don't have any item added yet".tr);
              }
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection'.tr);
          }
        } else {
          Get.snackbar('error'.tr, 'Please check your connection'.tr);
        }
      } else {
        Get.snackbar('error'.tr, 'Invoice cannot be created for self');
      }
    } else {
      Get.snackbar('error'.tr, 'please fill data'.tr);
    }
  }

  Widget dividerData() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Divider(
        color: ColorsUtils.line,
        thickness: 2,
      ),
    );
  }

  Padding topView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 30,
            ),
          ),
          height10(),

          ///create detail invoice
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              widget.invoiceDetail != null
                  ? 'Edit Invoice'
                  : 'Create Detailed Invoice'.tr,
              style:
              ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
            ),
          ),

          ///mob no and country code
          IgnorePointer(
            ignoring: widget.invoiceDetail == null
                ? false
                : widget.invoiceDetail!['type'] == 2
                ? true
                : false,
            child: isInternational == false ? InkWell(
              onTap: () {
              },
              child: Row(
                children: [
                  Container(
                    height: Get.width * 0.13,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),

                        border:
                        Border.all(color: ColorsUtils.border, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.book,
                            color: ColorsUtils.maroon70122E,
                          ),
                          width10(),
                          customSmallSemiText(
                              title: Utility.countryCodeNumber),
                        ],
                      ),
                    ),
                  ),
                  width15(),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      child: commonTextField(
                          contollerr: mobileNumber,
                          hint: 'Mobile Number'.tr,
                          validationType: '',
                          keyType: TextInputType.phone,
                          regularExpression:
                          TextValidation.digitsValidationPattern,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Number cannot be empty".tr;
                            }

                            if (value.substring(0, 4) == '1234') {
                              return "Mobile number is invalid".tr;
                            }

                            if (value.length < 8) {
                              return "Number should be 8 digit".tr;
                            }
                            return null;
                          },
                          inputLength: 8),
                    ),
                  ),
                ],
              ),
            ) : IntlPhoneField(invalidNumberMessage: 'Invalid mobile number'.tr,
              key: UniqueKey(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(TextValidation.digitsValidationPattern))
              ],
              controller: mobileNumber,
              decoration: InputDecoration(
                hintText: 'Mobile number'.tr,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(),
                ),
              ),
              disableLengthCheck: false,
              initialCountryCode: Utility.countryCode,
              onChanged: (phone) async {
                String token =
                await encryptedSharedPreferences.getString('token');
                final url = Uri.parse(
                  '${Utility.baseUrl}invoices?filter[where][invoicesenderId]=${Utility.userId}&filter[where][cellno]=${phone.countryCode.replaceAll('+', '')}-${phone.number}&filter[skip]=0&filter[limit]=1&filter[fields][clientname]=true',
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
                    'token is:$token } \n url $url  \n response is :${result.body} ');
                if (result.statusCode == 200) {
                  if (result.body != '[]') {
                    customerName.text =
                        jsonDecode(result.body)[0]['clientname'].toString();
                    setState(() {});
                  }
                } else if (result.statusCode == 499) {
                  hideLoadingDialog(context: context);

                  Get.off(() => UnderMaintenanceScreen());
                } else {
                  print(jsonDecode(result.body)['error']['message']);
                  // Get.snackbar('error'.tr,
                  //     '${jsonDecode(result.body)['error']['message']}');
                }
                print(phone.completeNumber);
              },
              onCountryChanged: (country) {
                Utility.countryCode = '${country.code}';
                Utility.countryCodeNumber = '+${country.dialCode}';
                countryCode = country.dialCode;
                print('Select countrycode: ${country.code}');
                print('Select country: +${country.dialCode}');
                setState(() {});
                print(
                    'Country changed to: ${country.code}Country code ${country.dialCode}');
              },
            ),
          ),

          height20(),
          //
          // Row(
          //   children: [
          //     IgnorePointer(
          //       ignoring: isInternational,
          //       child: InkWell(
          //         onTap: () {
          //           showCountryPicker(
          //             context: context,
          //             showPhoneCode:
          //                 true, // optional. Shows phone code before the country name.
          //             onSelect: (Country country) {
          //               // codeName is QA code+974
          //               Utility.countryCode = '${country.countryCode}';
          //               Utility.countryCodeNumber = '+${country.phoneCode}';
          //               countryCode = country.phoneCode;
          //               print('Select countrycode: ${country.countryCode}');
          //               print('Select country: +${country.phoneCode}');
          //               setState(() {});
          //             },
          //           );
          //         },
          //         child: Container(
          //           height: Get.width * 0.13,
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(10),
          //               border:
          //                   Border.all(color: ColorsUtils.border, width: 1)),
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 15),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 const Icon(
          //                   Icons.book,
          //                   color: ColorsUtils.maroon70122E,
          //                 ),
          //                 width10(),
          //                 // SizedBox(
          //                 //   child: CountryCodePicker(
          //                 //     searchDecoration: InputDecoration(
          //                 //         border: OutlineInputBorder(
          //                 //             borderRadius: BorderRadius.circular(10),
          //                 //             borderSide: BorderSide(
          //                 //                 color: ColorsUtils.border, width: 1))),
          //                 //     showFlagDialog: true,
          //                 //     onChanged: (value) {
          //                 //       setState(() {
          //                 //         print('code is ${value.code}');
          //                 //         Utility.countryCode = value.code.toString();
          //                 //         countryCode = value.toString();
          //                 //         Utility.countryCodeNumber =
          //                 //             countryCode.toString();
          //                 //       });
          //                 //     },
          //                 //     initialSelection: Utility.countryCode,
          //                 //     favorite: [
          //                 //       Utility.countryCodeNumber,
          //                 //       Utility.countryCode
          //                 //     ],
          //                 //     showCountryOnly: false,
          //                 //     showFlag: false,
          //                 //     alignLeft: false,
          //                 //     textStyle: ThemeUtils.blackSemiBold,
          //                 //     padding: const EdgeInsets.only(right: 1),
          //                 //     showOnlyCountryWhenClosed: false,
          //                 //     showDropDownButton: true,
          //                 //   ),
          //                 // ),
          //                 customSmallSemiText(title: Utility.countryCodeNumber),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     width10(),
          //     Expanded(
          //       flex: 5,
          //       child: commonTextField(
          //           contollerr: mobileNumber,
          //           hint: 'Mobile Number'.tr,
          //           onChange: (str) {
          //             setState(() {
          //               Utility.mobNo = str;
          //             });
          //           },
          //           keyType: TextInputType.phone,
          //           regularExpression: TextValidation.digitsValidationPattern,
          //           validator: (value) {
          //             if (value!.isEmpty) {
          //               return "Number cannot be empty".tr;
          //             }
          //             // else if (value.length < 10) {
          //             //   return "Number should be 10 digit".tr;
          //             // }
          //             return null;
          //           },
          //           inputLength: 10),
          //     ),
          //   ],
          // ),
          // height20(),

          ///cust name
          commonTextField(
            contollerr: customerName,
            hint: 'Customer Name'.tr,
            onChange: (str) {
              setState(() {
                Utility.custNo = str;
              });
            },
            regularExpression: TextValidation.alphabetSpaceValidationPattern,
            validator: (value) {
              if (value!.isEmpty) {
                return "Name cannot be empty".tr;
              }
              if (value.length >= 512) {
                return "max characters allowed are 512";
              }
              return null;
            },
          ),

          height25(),

          ///selection
          Row(
            children: [
              Text(
                'Notify Once the Invoice is Viewed'.tr,
                style: ThemeUtils.blackSemiBold,
              ),
              const Spacer(),
              Switch(
                  inactiveTrackColor: ColorsUtils.inactiveSwitch,
                  activeColor: ColorsUtils.invoiceAmount,
                  value: isInvoiceViewed,
                  onChanged: (bool) {
                    setState(() {
                      isInvoiceViewed = !isInvoiceViewed;
                      Utility.isNotify = !Utility.isNotify;
                    });
                  })
            ],
          ),
          Row(
            children: [
              Text(
                'Add Description'.tr,
                style: ThemeUtils.blackSemiBold,
              ),
              const Spacer(),
              Switch(
                  inactiveTrackColor: ColorsUtils.inactiveSwitch,
                  activeColor: ColorsUtils.invoiceAmount,
                  value: isDescription,
                  onChanged: (bool) {
                    setState(() {
                      isDescription = !isDescription;
                      Utility.isDescription = !Utility.isDescription;
                    });
                  })
            ],
          ),
          height10(),
          isDescription == true
              ? commonTextField(
              contollerr: description,
              hint: 'Descriptions'.tr,
              keyType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: 5,
              onChange: (str) {
                setState(() {
                  _formKey.currentState!.validate();

                  Utility.description = str;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Description is required!";
                }
                if (value.length < 5) {
                  return "Text Need To Be Atleast 5 Character";
                }
                if (value.length >= 5000) {
                  return "Description is too long. Maximum 5000 characters allowed.";
                }
                return null;
              }
            // regularExpression:
            //     TextValidation.alphabetSpaceValidationPattern,
          )
              : SizedBox(),
        ],
      ),
    );
  }

  Container spaceContainer() {
    return Container(
      height: 8,
      color: ColorsUtils.tabUnselect,
    );
  }

  checkInterNational() async {
    String id = await encryptedSharedPreferences.getString('id');
    await checkInternationalViewModel.checkInternational(id);
    List<CheckInternationalResponseModel> response =
        checkInternationalViewModel.checkInternationalApiResponse.data;
    print(' res is ${response[0].isInternational}');
    setState(() {
      isInternational = response[0].isInternational;
      print(' isInternational is $isInternational');
    });
  }

  countryCodeGetApiCall(String cc) async {
    print('in country code');
    await createInvoiceViewModel.countryCode(cc);
    if (createInvoiceViewModel.countryCodeApiResponse.status ==
        Status.LOADING) {
      Center(child: Loader());
    }
    print('status is ${createInvoiceViewModel.countryCodeApiResponse.status}');
    if (createInvoiceViewModel.countryCodeApiResponse.status ==
        Status.COMPLETE) {
      codeResponseModel = createInvoiceViewModel.countryCodeApiResponse.data;
      print('Utility.countryCode  1 ${Utility.countryCode}');
      Utility.countryCode = codeResponseModel![0].countryIsoCode;
      print('Utility.countryCode  2 ${Utility.countryCode}');

      print(
          'Country iso code is ${Utility.countryCode}   res ${codeResponseModel![0].countryIsoCode}');
    }
  }
}
