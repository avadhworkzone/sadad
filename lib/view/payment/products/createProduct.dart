// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/dashboard/product/createProductRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/product/productDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import '../../../model/apimodels/requestmodel/dashboard/product/editProductRequestModel.dart';
import '../../../model/apis/api_response.dart';
import '../../../util/validations.dart';
import '../../../viewModel/Payment/product/myproductViewModel.dart';
import '../../../viewModel/uploadImageViewModel.dart';
import 'package:http/http.dart' as http;

class CreateProductScreen extends StatefulWidget {
  String? productId;

  CreateProductScreen({Key? key, this.productId}) : super(key: key);

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  bool addWaterMark = false;
  bool addProductList = false;
  bool unlimitedProduct = false;
  bool allowPurchase = false;
  bool showStore = false;
  bool isTypePdf = false;
  bool expDateEmpty = false;
  File? _image;
  AppState? state;
  bool isLoading = false;
  int expectedDays = 0;
  String expectedDaysValue = '';
  String token = '';
  bool isFormValidate = true;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  TextEditingController pName = TextEditingController();
  TextEditingController uPrice = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController description = TextEditingController();
  UploadImageViewModel uploadImageViewModel = Get.find();
  MyProductListViewModel myProductListViewModel = Get.find();
  CreateProductRequestModel createProductReq = CreateProductRequestModel();
  EditProductRequestModel editProductReq = EditProductRequestModel();
  final _formKey = GlobalKey<FormState>();
  ProductDetailResponseModel productDetailResponse =
      ProductDetailResponseModel();
  ConnectivityViewModel connectivityViewModel = Get.find();
  String img = '';
  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    initData();
    Utility.isCreateImageUploadEmpty = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(body: GetBuilder<MyProductListViewModel>(
          builder: (controller) {
            if (controller.productDetailApiResponse.status == Status.ERROR) {
              return const SessionExpire();
              // return Center(child: Text('Error'));
            }
            if (controller.productDetailApiResponse.status == Status.COMPLETE) {
              productDetailResponse =
                  myProductListViewModel.productDetailApiResponse.data;
              return body(context);
            }

            return body(context);
          },
        ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                Utility.isCreateImageUploadEmpty = true;

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
              Utility.isCreateImageUploadEmpty = true;

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

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height40(),

            ///topRow
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
                Text(
                  widget.productId != null
                      ? 'Edit Product'.tr
                      : 'Create Product'.tr,
                  style:
                      ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
                ),
                const Spacer(),
                const SizedBox(
                  width: 20,
                )
              ],
            ),
            height30(),

            ///bottomData
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///add productImage
                    widget.productId != null
                        ? Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    getImageFile();
                                    print('image is $_image');
                                    setState(() {});
                                    // imgFromGallery();
                                  },
                                  child: Container(
                                    height: Get.height * 0.125,
                                    width: Get.width * 0.25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: ColorsUtils.border)),
                                    child: Stack(
                                      children: [
                                        _image != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  _image!,
                                                  fit: BoxFit.cover,
                                                  height: Get.height * 0.125,
                                                  width: Get.width * 0.25,
                                                ))
                                            : productDetailResponse
                                                    .productmedia!.isEmpty
                                                ? SizedBox(
                                                    height: Get.height * 0.125,
                                                    width: Get.width * 0.25,
                                                    child: Center(
                                                        child: Image.asset(
                                                      Images.noImage,
                                                      height: 50,
                                                      width: 50,
                                                    )),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      '${Constants.productContainer + productDetailResponse.productmedia!.last.name}',
                                                      headers: {
                                                        HttpHeaders
                                                                .authorizationHeader:
                                                            token
                                                      },
                                                      fit: BoxFit.cover,
                                                      height:
                                                          Get.height * 0.125,
                                                      width: Get.width * 0.25,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Center(
                                                            child: Image.asset(
                                                                Images
                                                                    .noImage));
                                                      },
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
                                        const Positioned(
                                          bottom: 10,
                                          right: 10,
                                          child: CircleAvatar(
                                            backgroundColor: ColorsUtils.accent,
                                            radius: 10,
                                            child: Center(
                                                child: Icon(
                                              Icons.edit,
                                              color: ColorsUtils.white,
                                              size: 10,
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                height10(),
                                Text(
                                  'Max Image dimension 500px X 500px, MAX 1MB'.tr,
                                  style: ThemeUtils.blackSemiBold
                                      .copyWith(fontSize: FontUtils.verySmall),
                                ),
                              ],
                            ),
                          )
                        : Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  getImageFile();
                                },
                                child: Container(
                                  height: Get.height * 0.125,
                                  width: Get.width * 0.25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: ColorsUtils.border)),
                                  child: Stack(
                                    children: [
                                      _image == null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Center(
                                                child: Image.asset(
                                                  Images.noImage,
                                                  fit: BoxFit.cover,
                                                  height: 25,
                                                  width: 25,
                                                ),
                                              ))
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                _image!,
                                                fit: BoxFit.cover,
                                                height: Get.height * 0.125,
                                                width: Get.width * 0.25,
                                              )),
                                      const Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: CircleAvatar(
                                          backgroundColor: ColorsUtils.accent,
                                          radius: 10,
                                          child: Center(
                                              child: Icon(
                                            Icons.add,
                                            color: ColorsUtils.white,
                                            size: 15,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              width20(),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add Product image'.tr,
                                    style: ThemeUtils.blackBold
                                        .copyWith(fontSize: FontUtils.small),
                                  ),
                                  height10(),
                                  Text(
                                    'Max Image dimension 500px X 500px, MAX 1MB'.tr
                                        .tr,
                                    style: ThemeUtils.blackSemiBold.copyWith(
                                        fontSize: FontUtils.verySmall),
                                  ),
                                ],
                              ))
                            ],
                          ),

                    height20(),

                    ///waterMarkImage switch
                    Row(
                      children: [
                        Text(
                          'Add Water mark to the Image'.tr,
                          style: ThemeUtils.blackSemiBold
                              .copyWith(fontSize: FontUtils.small),
                        ),
                        const Spacer(),
                        Switch(
                          value: addWaterMark,
                          activeColor: ColorsUtils.accent,
                          onChanged: (value) {
                            addWaterMark = !addWaterMark;
                            setState(() {});
                          },
                        )
                      ],
                    ),
                    height20(),

                    ///pName
                    SizedBox(
                      child: commonTextField(
                        contollerr: pName,
                        hint: 'Product Name'.tr,
                        validationType:
                            TextValidation.alphabetSpaceValidationPattern,
                        onChange: (str) {},
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
                    ),
                    height20(),

                    ///uPrice
                    SizedBox(
                      child: commonTextField(
                        contollerr: uPrice,
                        hint: 'Unit Priced'.tr,
                        keyType: TextInputType.numberWithOptions(decimal: true),
                        regularExpression:
                            TextValidation.doubleDigitsValidationPattern,
                        suffix: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'QAR',
                            style:
                                ThemeUtils.blackSemiBold.copyWith(fontSize: 16),
                          ),
                        ),
                        onChange: (str) {
                          if (isFormValidate == false) {
                            _formKey.currentState!.validate();
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "price cannot be empty".tr;
                          } else if (value == '0') {
                            return "Price cannot be 0";
                          } else if (double.parse(value) <= 5) {
                            return "Price must be Greater than 5";
                          } else if (double.parse(value) >= 20000) {
                            return "Price must be less than 20000";
                          } else if (double.parse(value) <= 1) {
                            return "Price must be greater than 1";
                          }
                          return null;
                        },
                      ),
                    ),
                    unlimitedProduct == true ? SizedBox() : height20(),

                    ///quantity
                    unlimitedProduct == true
                        ? SizedBox()
                        : SizedBox(
                            child: commonTextField(
                              contollerr: quantity,
                              hint: 'Available Quantity'.tr,
                              keyType: TextInputType.number,
                              inputLength: 3,
                              onChange: (str) {},
                              regularExpression:
                                  TextValidation.digitsValidationPattern,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "quantity cannot be empty".tr;
                                } else if (value == '0') {
                                  return "quantity cannot be 0";
                                }
                                return null;
                              },
                            ),
                          ),

                    ///product detail
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height20(),
                        InkWell(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            // Future.delayed(Duration(microseconds: 500),
                            //     () async {
                            await expectedDeliverDaysDialog(context);
                            setState(() {});
                            // });
                          },
                          child: Container(
                            width: Get.width,
                            height: Get.height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: expDateEmpty == true
                                        ? ColorsUtils.red
                                        : ColorsUtils.grey.withOpacity(0.5),
                                    width: 1)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Text(
                                    expectedDaysValue == ''
                                        ? 'Expected Delivery Days'.tr
                                        : expectedDaysValue,
                                    style: ThemeUtils.blackSemiBold.copyWith(
                                        fontSize: FontUtils.mediumSmall,
                                        color: expectedDaysValue == ''
                                            ? ColorsUtils.hintColor
                                                .withOpacity(0.5)
                                            : ColorsUtils.black),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: ColorsUtils.grey,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        expDateEmpty == false
                            ? SizedBox()
                            : Column(
                                children: [
                                  height5(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      'Delivery date is required!!'.tr,
                                      style: TextStyle(
                                          color: ColorsUtils.red,
                                          fontSize: FontUtils.verySmall),
                                    ),
                                  ),
                                ],
                              ),
                        height20(),

                        ///description
                        SizedBox(
                          child: commonTextField(
                            contollerr: description,
                            maxLines: 4,
                            hint: 'Item & Description'.tr,
                            keyType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            onChange: (str) {
                              if (isFormValidate == false) {
                                _formKey.currentState!.validate();
                              }
                            },
                            validator: (value) {
                              print('validator');
                              if (value!.isEmpty) {
                                return "description cannot be empty".tr;
                              } else if (value.length < 5) {
                                return "description Should Be A Minimum Of 5 Characters!";
                              } else if (value.length >= 5000) {
                                return 'max characters allowed are 5000';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    height20(),

                    ///add productList
                    // Row(
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         addProductList = !addProductList;
                    //         print(addProductList);
                    //         addProductList == false
                    //             ? expectedDaysValue = ''
                    //             : '';
                    //         print('value is $expectedDaysValue');
                    //         setState(() {});
                    //       },
                    //       child: Container(
                    //         width: 20,
                    //         height: 20,
                    //         decoration: BoxDecoration(
                    //             border: Border.all(
                    //                 color: ColorsUtils.black, width: 1),
                    //             borderRadius: BorderRadius.circular(5)),
                    //         child: addProductList == true
                    //             ? Center(
                    //                 child: Image.asset(Images.check,
                    //                     height: 10, width: 10))
                    //             : const SizedBox(),
                    //       ),
                    //     ),
                    //     width20(),
                    //     Text(
                    //       'Add to Product list'.tr,
                    //       style: ThemeUtils.blackBold
                    //           .copyWith(fontSize: FontUtils.small),
                    //     ),
                    //   ],
                    // ),

                    // height20(),

                    ///unlimited product quantity
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            unlimitedProduct = !unlimitedProduct;
                            print(unlimitedProduct);
                            setState(() {});
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorsUtils.black, width: 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: unlimitedProduct == true
                                ? Center(
                                    child: Image.asset(Images.check,
                                        height: 10, width: 10))
                                : const SizedBox(),
                          ),
                        ),
                        width20(),
                        Text(
                          'Unlimited Product Quantity'.tr,
                          style: ThemeUtils.blackBold
                              .copyWith(fontSize: FontUtils.small),
                        ),
                      ],
                    ),

                    height20(),

                    ///allow only purchase
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            allowPurchase = !allowPurchase;
                            setState(() {});
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorsUtils.black, width: 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: allowPurchase == true
                                ? Center(
                                    child: Image.asset(Images.check,
                                        height: 10, width: 10))
                                : const SizedBox(),
                          ),
                        ),
                        width20(),
                        Expanded(
                          child: Text(
                            'Allow only once purchase per cell Number'.tr,
                            style: ThemeUtils.blackBold
                                .copyWith(fontSize: FontUtils.small),
                          ),
                        ),
                      ],
                    ),
                    height20(),

                    ///show productStore
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            showStore = !showStore;
                            setState(() {});
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorsUtils.black, width: 1),
                                borderRadius: BorderRadius.circular(5)),
                            child: showStore == true
                                ? Center(
                                    child: Image.asset(Images.check,
                                        height: 10, width: 10))
                                : const SizedBox(),
                          ),
                        ),
                        width20(),
                        Expanded(
                          child: Text(
                            'Activate product link'.tr,
                            style: ThemeUtils.blackBold
                                .copyWith(fontSize: FontUtils.small),
                          ),
                        ),
                      ],
                    ),

                    ///create Product
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (expectedDaysValue != '') {
                              expDateEmpty = false;
                              setState(() {});
                              if (widget.productId != null) {
                                if (_image == null) {
                                  showLoadingDialog(context: context);
                                  editProductApiCall(img, context);
                                } else {
                                  try {
                                    showLoadingDialog(context: context);
                                    final resposne = await ApiService()
                                        .uploadImage(
                                            file: _image!,
                                            url:
                                                'containers/api-product/upload');
                                    // var data = jsonEncode(resposne);

                                    print('res is ${(resposne)}');
                                    print(
                                        'res=>${jsonDecode(resposne.toString())['result']['files']['file'][0]['name']}');
                                    img = jsonDecode(resposne.toString())[
                                        'result']['files']['file'][0]['name'];
                                    setState(() {});
                                    editProductApiCall(img, context);
                                  } on Exception catch (e) {
                                    hideLoadingDialog(context: context);
                                    print('error is here$e');
                                    Get.snackbar('error', 'Something wrong');
                                    // TODO
                                  }
                                  // await uploadImageViewModel.uploadImage(_image!);
                                  // if (uploadImageViewModel
                                  //             .uploadImageApiResponse.status ==
                                  //         Status.LOADING ||
                                  //     uploadImageViewModel
                                  //             .uploadImageApiResponse.status ==
                                  //         Status.INITIAL) {
                                  //   const Center(child: Loader());
                                  // }
                                  // if (uploadImageViewModel
                                  //         .uploadImageApiResponse.status ==
                                  //     Status.COMPLETE) {
                                  //   UploadImageResponseModel uploadImageRes =
                                  //       uploadImageViewModel
                                  //           .uploadImageApiResponse.data;
                                  //   img = uploadImageRes
                                  //       .result!.files!.file![0].name!;
                                  //   editProductApiCall(img, context);
                                  //   FocusScope.of(context).unfocus();
                                  // } else {
                                  //   Get.snackbar(
                                  //       'please check Image File'.tr,
                                  //       'file should be in png, jpg,pdf format'
                                  //           .tr);
                                  //   FocusScope.of(context).unfocus();
                                  // }
                                }
                              } else {
                                if (_image == null) {
                                  showLoadingDialog(context: context);
                                  createProductApiCall(img, context);
                                } else {
                                  try {
                                    showLoadingDialog(context: context);
                                    final resposne = await ApiService()
                                        .uploadImage(
                                            file: _image!,
                                            url:
                                                'containers/api-product/upload');
                                    // var data = jsonEncode(resposne);

                                    print('res is ${(resposne)}');
                                    print(
                                        'res=>${jsonDecode(resposne.toString())['result']['files']['file'][0]['name']}');
                                    img = jsonDecode(resposne.toString())[
                                        'result']['files']['file'][0]['name'];
                                    setState(() {});
                                    createProductApiCall(img, context);
                                  } on Exception catch (e) {
                                    hideLoadingDialog(context: context);
                                    print('error is here$e');
                                    Get.snackbar('error',
                                        'Session expire please login again');
                                    // TODO
                                  }
                                  // await uploadImageViewModel.uploadImage(_image!);
                                  // if (uploadImageViewModel
                                  //             .uploadImageApiResponse.status ==
                                  //         Status.LOADING ||
                                  //     uploadImageViewModel
                                  //             .uploadImageApiResponse.status ==
                                  //         Status.INITIAL) {
                                  //   const Center(child: Loader());
                                  // }
                                  // if (uploadImageViewModel
                                  //         .uploadImageApiResponse.status ==
                                  //     Status.COMPLETE) {
                                  //   print('upload successfully');
                                  //   UploadImageResponseModel uploadImageRes =
                                  //       uploadImageViewModel
                                  //           .uploadImageApiResponse.data;
                                  //   img = uploadImageRes
                                  //       .result!.files!.file![0].name!;
                                  //   createProductApiCall(img, context);
                                  //   FocusScope.of(context).unfocus();
                                  // } else {
                                  //   Get.snackbar(
                                  //       'please check Image File'.tr,
                                  //       'file should be in png, jpg,pdf format'
                                  //           .tr);
                                  //   FocusScope.of(context).unfocus();
                                  // }
                                }
                              }
                            } else {
                              expDateEmpty = true;
                              setState(() {});
                              // Get.snackbar(
                              //     'error', 'Delivery date is required');
                            }
                          } else {
                            isFormValidate = false;
                            if (expectedDaysValue != '') {
                              expDateEmpty = false;
                            } else {
                              expDateEmpty = true;
                              setState(() {});
                            }
                            setState(() {});
                          }
                        },
                        child: buildContainerWithoutImage(
                            color: ColorsUtils.accent,
                            text: widget.productId != null
                                ? 'Save'.tr
                                : "Create Product".tr),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> expectedDeliverDaysDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Please select Days'.tr,
                            style: ThemeUtils.blackSemiBold.copyWith(
                                fontSize: FontUtils.mediumSmall,
                                color: ColorsUtils.grey),
                          ),
                        ),
                        expectedDaysCommonRowSelection(setDialogState,
                            title: 'Immediate', select: 1),
                        expectedDaysCommonRowSelection(setDialogState,
                            title: '1 to 2 Days', select: 2),
                        expectedDaysCommonRowSelection(setDialogState,
                            title: '3 to 5 Days', select: 3),
                        expectedDaysCommonRowSelection(setDialogState,
                            title: '1 Week', select: 4),
                        expectedDaysCommonRowSelection(setDialogState,
                            title: '2-4 Weeks', select: 5),
                        expectedDaysCommonRowSelection(setDialogState,
                            title: '1 Month', select: 6),
                        expectedDaysCommonRowSelection(setDialogState,
                            title: '2 Month', select: 7),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: SizedBox(
                                width: Get.width / 2,
                                child: buildContainerWithoutImage(
                                    color: ColorsUtils.accent,
                                    text: 'Select'.tr)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  LabeledRadio expectedDaysCommonRowSelection(StateSetter setDialogState,
      {String? title, int? select}) {
    return LabeledRadio(
      label: title!.tr,
      value: select!,
      groupValue: expectedDays,
      onChanged: (newValue) {
        setDialogState(() {
          expectedDaysValue = title;
          date.text = select == 1
              ? '1'
              : select == 2
                  ? '2'
                  : select == 3
                      ? '5'
                      : select == 4
                          ? '7'
                          : select == 5
                              ? '14'
                              : select == 6
                                  ? '30'
                                  : select == 7
                                      ? '60'
                                      : '';

          expectedDays = newValue;
          expDateEmpty = false;
          setState(() {});
          print('days $expectedDaysValue');
          print('value ${date.text}');
        });
      },
    );
  }

  void createProductApiCall(String img, BuildContext context) async {
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        List<Map<String, dynamic>> proMedList = [];
        CreateProductProductmedia createProductProductmedia =
            CreateProductProductmedia();
        // showLoadingDialog(context: context);

        String id = await encryptedSharedPreferences.getString('id');

        createProductReq.name = pName.text;
        createProductReq.price = uPrice.text;
        createProductReq.expecteddays = date.text;
        createProductReq.description = description.text;
        createProductReq.totalavailablequantity =
            unlimitedProduct == true ? 0 : int.parse(quantity.text);
        createProductReq.enablewatermark = addWaterMark;
        createProductReq.isdisplayinpanel = showStore == true ? 1 : 0;
        createProductReq.merchantId = id;
        createProductReq.showproduct = true;
        createProductReq.isUnlimited = unlimitedProduct;
        if (img != '') {
          Utility.isCreateImageUploadEmpty = false;
          createProductProductmedia.name = img;
          proMedList.add(createProductProductmedia.toJson());
          createProductReq.createProductProductmedia = proMedList
              .map((e) => CreateProductProductmedia.fromJson(e))
              .toList();
        }

        createProductReq.allowoncepersadadaccount = allowPurchase;
        log('${createProductReq.toJson()}');
        // showLoadingDialog(context: context);
        String token = await encryptedSharedPreferences.getString('token');
        final url = Uri.parse(
          '${Utility.baseUrl}products',
        );
        Map<String, String> header = {
          'Authorization': token,
          'Content-Type': 'application/json'
        };
        // Map<String, dynamic>? body = {
        //   "userId": int.parse(id),
        //   "message": "Withdraw request",
        //   "userbankId": userBankId,
        //   "amount": double.parse(withdrawAmount.text),
        //   "createdby": int.parse(id)
        // };

        var result = await http.post(
          url,
          headers: header,
          body: jsonEncode(createProductReq),
        );

        print(
            'token is:$token \n req is : ${jsonEncode(createProductReq)}  \n response is :${result.body} ');
        if (result.statusCode == 401) {
          SessionExpire();
        }

        if (result.statusCode == 200) {
          AnalyticsService.sendEvent('Create Product success', {
            'Id': Utility.userId,
          });

          hideLoadingDialog(context: context);
          Get.snackbar('Success'.tr, 'Product Created SuccessFully'.tr);
          hideLoadingDialog(context: context);
          FocusScope.of(context).unfocus();
          Future.delayed(const Duration(seconds: 1), () {
            return Get.back();
            // return Get.off(() => const MyProductScreen());
          });
        } else if (result.statusCode == 499) {
          hideLoadingDialog(context: context);

          Get.off(() => UnderMaintenanceScreen());
        } else {
          AnalyticsService.sendEvent('Create Product failure', {
            'Id': Utility.userId,
          });
          hideLoadingDialog(context: context);
          Get.snackbar(
              'error'.tr, '${jsonDecode(result.body)['error']['message']}');
        }

        // await myProductListViewModel.createProduct(createProductReq);
        // if (myProductListViewModel.createProductApiResponse.status ==
        //     Status.ERROR) {
        //   AnalyticsService.sendEvent('Create Product failure', {
        //     'Id': Utility.userId,
        //   });
        //   Get.snackbar('error'.tr, 'product name already exist'.tr);
        //   hideLoadingDialog(context: context);
        //   FocusScope.of(context).unfocus();
        // }
        //
        // if (myProductListViewModel.createProductApiResponse.status ==
        //     Status.COMPLETE) {
        //   AnalyticsService.sendEvent('Create Product success', {
        //     'Id': Utility.userId,
        //   });
        //   Get.snackbar('Success'.tr, 'Product Created SuccessFully'.tr);
        //   hideLoadingDialog(context: context);
        //
        //   Future.delayed(const Duration(seconds: 1), () {
        //     return Get.off(() => const MyProductScreen());
        //   });
        //   FocusScope.of(context).unfocus();
        // }
      } else {
        Get.snackbar('error', 'Please check your connection');
      }
    } else {
      Get.snackbar('error', 'Please check your connection');
    }
  }

  void editProductApiCall(String img, BuildContext context) async {
    connectivityViewModel.startMonitoring();

    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        List<Map<String, dynamic>> proMedList = [];
        EditProductProductmedia editProductProductmedia =
            EditProductProductmedia();
        String id = await encryptedSharedPreferences.getString('id');
        editProductReq.name = pName.text;
        editProductReq.price = uPrice.text;
        editProductReq.expecteddays = date.text;
        editProductReq.description = description.text;
        editProductReq.totalavailablequantity = int.parse(quantity.text);
        editProductReq.enablewatermark = addWaterMark;
        editProductReq.isdisplayinpanel = showStore == true ? 1 : 0;
        editProductReq.showproduct = true;
        editProductReq.merchantId = id;
        editProductReq.isUnlimited = unlimitedProduct;
        if (img != '') {
          Utility.isCreateImageUploadEmpty = false;
          editProductProductmedia.name = img;
          proMedList.add(editProductProductmedia.toJson());
          editProductReq.editProductProductmedia = proMedList
              .map((e) => EditProductProductmedia.fromJson(e))
              .toList();
        }

        editProductReq.allowoncepersadadaccount = allowPurchase;
        log('req issssss${jsonEncode(editProductReq)}');
        // hideLoadingDialog(context: context);
        print('is it edit');
        String token = await encryptedSharedPreferences.getString('token');
        final url = Uri.parse(
          '${Utility.baseUrl}products/${widget.productId!}',
        );
        Map<String, String> header = {
          'Authorization': token,
          'Content-Type': 'application/json'
        };
        // Map<String, dynamic>? body = {
        //   "userId": int.parse(id),
        //   "message": "Withdraw request",
        //   "userbankId": userBankId,
        //   "amount": double.parse(withdrawAmount.text),
        //   "createdby": int.parse(id)
        // };

        var result = await http.patch(
          url,
          headers: header,
          body: jsonEncode(editProductReq),
        );

        print(
            'token is:$token\n url $url \n req is : ${jsonEncode(editProductReq)}  \n response is :${result.body} ');
        if (result.statusCode == 401) {
          SessionExpire();
        }

        if (result.statusCode == 200) {
          AnalyticsService.sendEvent('edit Product success', {
            'Id': Utility.userId,
          });

          hideLoadingDialog(context: context);
          Get.snackbar('Success'.tr, 'Product detail are updated'.tr);
          hideLoadingDialog(context: context);
          FocusScope.of(context).unfocus();
          Future.delayed(const Duration(seconds: 1), () {
            return Get.back();
            // return Get.off(() => const MyProductScreen());
          });
        } else if (result.statusCode == 499) {
          hideLoadingDialog(context: context);

          Get.off(() => UnderMaintenanceScreen());
        } else {
          AnalyticsService.sendEvent('edit Product failure', {
            'Id': Utility.userId,
          });
          FocusScope.of(context).unfocus();
          hideLoadingDialog(context: context);
          Get.snackbar(
              'error'.tr, '${jsonDecode(result.body)['error']['message']}');
        }

        // showLoadingDialog(context: context);
        //
        // await myProductListViewModel.editProduct(
        //     '/${widget.productId!}', editProductReq);
        // if (myProductListViewModel.editProductApiResponse.status ==
        //     Status.ERROR) {
        //   AnalyticsService.sendEvent('Create Product failure', {
        //     'Id': Utility.userId,
        //   });
        //   Get.snackbar('error'.tr, 'product name already exist');
        //   hideLoadingDialog(context: context);
        //   FocusScope.of(context).unfocus();
        // }
        //
        // if (myProductListViewModel.editProductApiResponse.status ==
        //     Status.COMPLETE) {
        //   AnalyticsService.sendEvent('Create Product success', {
        //     'Id': Utility.userId,
        //   });
        //   Get.snackbar('Success'.tr, 'Product detail are updated'.tr);
        //   hideLoadingDialog(context: context);
        //   print('hhhh');
        //   Navigator.pop(context);
        //   // await Future.delayed(const Duration(seconds: 1), () {
        //   //   Get.back();
        //   //   //   // return Get.off(() => const MyProductScreen());
        //   // });
        //
        //   FocusScope.of(context).unfocus();
        // }
      } else {
        Get.snackbar('error', 'Please check your connection');
      }
    } else {
      Get.snackbar('error', 'Please check your connection');
    }
  }

  getImageFile() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //     type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      File? file = File(result.path);
      log('DOC=>${file}');
      String str = file.path;
      String extension = str.substring(str.lastIndexOf('.') + 1);
      log('extension:::$extension');
      if (extension == 'jpeg' ||
          extension == 'png' ||
          extension == 'jpg' ||
          extension == 'JPEG' ||
          extension == 'PNG' ||
          extension == 'JPG') {
        final cropImage = await _cropImage(file);
        _image = File(cropImage.path);

        log('image is $_image');
        setState(() {});
      }
    } else {
      // User canceled the picker
    }
  }

  Future<CroppedFile> _cropImage(
    File? pickFile,
  ) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio3x2,
                // CropAspectRatioPreset.original,
                // CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio16x9
              ]
            : [
                // CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                // CropAspectRatioPreset.ratio3x2,
                // CropAspectRatioPreset.ratio4x3,
                // CropAspectRatioPreset.ratio5x3,
                // CropAspectRatioPreset.ratio5x4,
                // CropAspectRatioPreset.ratio7x5,
                // CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'crop image',
              toolbarColor: ColorsUtils.accent,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'crop image',
          )
        ]);
    // if (croppedFile != null) {
    //   pickFile = croppedFile ;
    //   setState(() {
    //     state = AppState.cropped;
    //   });
    //   log("PATH $pickFile");
    // }
    return croppedFile!;
  }

  void initData() async {
    if (widget.productId != null) {
      token = await encryptedSharedPreferences.getString('token');
      showLoadingDialog(context: context);
      await myProductListViewModel.productDetail(widget.productId!);

      ProductDetailResponseModel productDetailResponse =
          myProductListViewModel.productDetailApiResponse.data;
      if (myProductListViewModel.productDetailApiResponse.status ==
              Status.LOADING ||
          myProductListViewModel.productDetailApiResponse.status ==
              Status.INITIAL) {
        print('hi');
        const Loader();
      }
      if (myProductListViewModel.productDetailApiResponse.status ==
          Status.COMPLETE) {
        hideLoadingDialog(context: context);
        addWaterMark = productDetailResponse.enablewatermark;
        pName.text = productDetailResponse.name;
        uPrice.text = productDetailResponse.price.toString();
        quantity.text = productDetailResponse.totalavailablequantity.toString();
        description.text = productDetailResponse.description.toString();
        allowPurchase = productDetailResponse.allowoncepersadadaccount;
        showStore = productDetailResponse.isdisplayinpanel == 0 ? false : true;
        unlimitedProduct = productDetailResponse.isUnlimited;
        expectedDaysValue = productDetailResponse.expecteddays == 1 ||
                productDetailResponse.expecteddays == 0
            ? 'Immediate'
            : productDetailResponse.expecteddays == 2
                ? '1 to 2 Days'
                : productDetailResponse.expecteddays == 5
                    ? '3 to 5 Days'
                    : productDetailResponse.expecteddays == 7
                        ? '1 Week'
                        : productDetailResponse.expecteddays == 14
                            ? '2-4 Weeks'
                            : productDetailResponse.expecteddays == 30
                                ? '1 Month'
                                : productDetailResponse.expecteddays == 60
                                    ? '2 Month'
                                    : '${productDetailResponse.expecteddays} day after';

        if (productDetailResponse.description != null ||
            productDetailResponse.description != '') {
          addProductList = true;
        }
      }
      setState(() {});
    }
  }
}
