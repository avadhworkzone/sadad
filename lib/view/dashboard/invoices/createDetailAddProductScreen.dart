import 'dart:developer';
import 'dart:io';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/addProductResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/createProductViewModel.dart';
import '../../../staticData/utility.dart';

class CreateDetailAddProduct extends StatefulWidget {
  const CreateDetailAddProduct({Key? key}) : super(key: key);

  @override
  State<CreateDetailAddProduct> createState() => _CreateDetailAddProductState();
}

class _CreateDetailAddProductState extends State<CreateDetailAddProduct> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  TextEditingController search = TextEditingController();
  String? searchKey;
  // StaticData staticData = StaticData();
  AddProductViewModel addProductViewModel = Get.find();

  ///selected data list
  List<Map<String, dynamic>> selectData = [];
  ConnectivityViewModel connectivityViewModel = Get.find();

  String token = '';

  ///list  of product
  List product = [];

  @override
  void initState() {
    connectivityViewModel.startMonitoring();

    selectData.clear();
    addProductViewModel.setInit();
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            bottomNavigationBar: bottomBar(),
            body: GetBuilder<AddProductViewModel>(
              builder: (controller) {
                if (controller.addProductApiResponse.status == Status.LOADING ||
                    controller.addProductApiResponse.status == Status.INITIAL) {
                  return const Center(child: Loader());
                }
                if (controller.addProductApiResponse.status == Status.ERROR) {
                  return const SessionExpire();
                }
                List<AddProductsResponseModel> response =
                    addProductViewModel.addProductApiResponse.data;
                return SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      backButton(),
                      height25(),
                      searchBox(),
                      height40(),
                      items(response),
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
                selectData.clear();
                addProductViewModel.setInit();
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
              selectData.clear();
              addProductViewModel.setInit();
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

  InkWell backButton() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: const Icon(
        Icons.arrow_back_ios,
        size: 30,
      ),
    );
  }

  Expanded items(List<AddProductsResponseModel> response) {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Products'.tr,
              style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.large),
            ),
            height20(),
            SizedBox(
              width: Get.width,
              child: ListView.builder(
                itemCount: response.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (searchKey != null && searchKey != "") {
                    if (!response[index]
                        .name!
                        .toLowerCase()
                        .contains(searchKey!.toLowerCase())) {
                      return SizedBox();
                    }
                  }
                  return Container(
                    decoration: BoxDecoration(
                        color: product.contains(index)
                            ? ColorsUtils.accent.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            ///selection of product
                            product.contains(index)
                                ? product.remove(index)
                                : product.add(index);

                            ///data add and remove while selection
                            Map<String, dynamic> data = {
                              "title": response[index].name,
                              "icon": response[index].productmedia!.isEmpty
                                  ? null
                                  : '${Constants.productContainer}${response[index].productmedia!.first.name}',
                              "value": response[index].totalavailablequantity,
                              "amount": response[index].price,
                              "quantity": 1,
                              "deletedAt": null,
                              'id': response[index].id.toString()
                            };
                            if (product.contains(index)) {
                              selectData.add(data);
                              log('selected list $selectData');
                            } else {
                              int i = selectData.indexWhere(
                                  (element) => element['id'] == data['id']);
                              selectData.removeAt(i);
                              print('AFTER SELECT DATA :$selectData');
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: ColorsUtils.black)),
                              child: product.contains(index)
                                  ? Center(
                                      child: Icon(
                                      Icons.check,
                                      size: 18,
                                    ))
                                  : SizedBox(),
                            ),
                            width20(),
                            Expanded(
                                child: SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  response[index].productmedia!.isEmpty
                                      ? SizedBox()
                                      : Container(
                                          width: 60,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              '${Constants.productContainer}${response[index].productmedia!.first.name}',
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
                                  width20(),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        response[index].name ?? "",
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.small),
                                      ),
                                      Text(
                                        '${response[index].price} QAR',
                                        style: ThemeUtils.blackBold.copyWith(
                                            color: ColorsUtils.accent),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.shopping_basket),
                                          width10(),
                                          Text(
                                            response[index].isUnlimited == true
                                                ? 'Infinite'
                                                : "${response[index].totalavailablequantity}",
                                            style: ThemeUtils.blackBold,
                                          ),
                                        ],
                                      )
                                    ],
                                  ))
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container searchBox() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsUtils.border, width: 1)),
      child: TextFormField(
        controller: search,
        onChanged: (value) {
          setState(() {
            searchKey = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Search'.tr,
          suffixIcon: const Icon(Icons.cancel_sharp,
              color: ColorsUtils.border, size: 25),
          border: InputBorder.none,
          hintStyle: ThemeUtils.blackSemiBold
              .copyWith(color: ColorsUtils.hintColor.withOpacity(0.5)),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  Padding bottomBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
      child: SizedBox(
        height: 50,
        width: Get.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectData.length} ${'Items Selected'.tr}',
              style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.small),
            ),
            SizedBox(
                width: 120,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (selectData.isEmpty) {
                        Get.snackbar(
                            'Something Wrong'.tr, 'Please Select Items'.tr);
                      } else {
                        Utility.selectedProductData.addAll(selectData);
                        print('selected data is '
                            "${Utility.selectedProductData}");
                        Get.back(result: true);
                      }
                    });
                  },
                  child: buildContainerWithoutImage(
                      color: ColorsUtils.accent, text: 'Add'.tr),
                ))
          ],
        ),
      ),
    );
  }

  void initData() async {
    String id = await encryptedSharedPreferences.getString('id');
    String? key = 'productmedia';
    String? name = '';
    await addProductViewModel.addProduct(id, key, name);
    token = await encryptedSharedPreferences.getString('token');
  }
}
