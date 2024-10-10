import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/store/showStoreRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/product/myproductListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/productCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/products/myProductScreen.dart';
import 'package:sadad_merchat_app/view/payment/products/productDetail.dart';
import 'package:sadad_merchat_app/viewModel/Payment/product/myproductViewModel.dart';
import 'package:share_plus/share_plus.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({Key? key}) : super(key: key);

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  String? searchKey;
  bool isSelect = false;

  bool isPageFirst = false;
  bool isAllSelect = false;
  List<int> selectedList = [];
  int isRadioSelected = 0;
  List<String> shareUrlList = [];
  String token = '';
  String email = '';
  bool sendEmail = false;
  bool isShowEStore = false;

  // late dio.Response response;
  MyProductListViewModel myProductListViewModel = Get.find();
  ProductCountResponseModel? productCountRes;
  ShowStoreRequestModel showEStoreReq = ShowStoreRequestModel();
  ScrollController? _scrollController;
  List<MyProductListResponseModel>? myProductListResponse;
  TextEditingController search = TextEditingController();
  int getSearchCount = 0;

  @override
  void initState() {
    // initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<MyProductListViewModel>(
      builder: (controller) {
        if (controller.myProductListApiResponse.status == Status.LOADING ||
            controller.productCountApiResponse.status == Status.LOADING ||
            controller.myProductListApiResponse.status == Status.INITIAL) {
          return const Center(child: Loader());
        }

        if (controller.myProductListApiResponse.status == Status.ERROR ||
            controller.productCountApiResponse.status == Status.ERROR) {
          return const SessionExpire();
          //return Center(child: const Text('Error'));
        }
        productCountRes = myProductListViewModel.productCountApiResponse.data;
        myProductListResponse = controller.response;

        getProductCount(myProductListResponse!);
        print('get count ::${getProductCount(myProductListResponse!)}');

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              height60(),
              Row(
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
                          initData('&filter[name]=$searchKey');
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
                            hintText: 'ex. product name...'.tr,
                            hintStyle: ThemeUtils.blackRegular.copyWith(
                                color: ColorsUtils.grey,
                                fontSize: FontUtils.small)),
                      ),
                    ),
                  ),
                ],
              ),
              height20(),
              search.text.isEmpty
                  ? const SizedBox()
                  : Expanded(
                      child: Column(
                        children: [
                          isSelect == true
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            isAllSelect = !isAllSelect;
                                            if (isAllSelect) {
                                              ///delete
                                              final list =
                                                  myProductListResponse!
                                                      .map((e) => e.id as int)
                                                      .toList();
                                              selectedList = list;
                                              print('list is $selectedList');

                                              ///share url
                                              final shareList =
                                                  myProductListResponse!
                                                      .map((e) =>
                                                          'https://d.sadad.qa/${e.shareUrl}')
                                                      .toList();
                                              shareUrlList = shareList;
                                            } else {
                                              shareUrlList.clear();
                                              selectedList.clear();
                                            }
                                            print(
                                                'SELECTED LIST ID :$selectedList');
                                            print(
                                                'SELECTED URL :$shareUrlList');
                                            setState(() {});
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorsUtils.black,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: isAllSelect == true
                                                ? Center(
                                                    child: Image.asset(
                                                        Images.check,
                                                        height: 10,
                                                        width: 10))
                                                : SizedBox(),
                                          ),
                                        ),
                                        width20(),
                                        Text(
                                          'Select all'.tr,
                                          style: ThemeUtils.blackBold.copyWith(
                                              fontSize: FontUtils.small),
                                        ),
                                        Spacer(),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              isSelect = false;
                                              isAllSelect = false;
                                              selectedList.clear();
                                              setState(() {});
                                            },
                                            child: Text(
                                              'Cancel'.tr,
                                              style: ThemeUtils.blackBold
                                                  .copyWith(
                                                      fontSize: FontUtils.small,
                                                      color: ColorsUtils.red),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    height10(),
                                    Text(
                                      '${selectedList.length} / ${myProductListResponse!.length} ${'Products'.tr}',
                                      style: ThemeUtils.blackSemiBold.copyWith(
                                          fontSize: FontUtils.verySmall),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Search Result',
                                          style: ThemeUtils.blackBold.copyWith(
                                              fontSize: FontUtils.medium),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            isSelect = true;
                                            setState(() {});
                                          },
                                          child: Text(
                                            'Select'.tr,
                                            style: ThemeUtils.blackBold
                                                .copyWith(
                                                    fontSize: FontUtils.small),
                                          ),
                                        ),
                                        width20(),
                                        InkWell(
                                            onTap: () {
                                              bottomSheet();
                                            },
                                            child: const Icon(Icons.more_vert)),
                                      ],
                                    ),
                                    height10(),
                                    Text(
                                      '${getProductCount(myProductListResponse) ?? '0'} ${'Result found'}',
                                      style: ThemeUtils.blackSemiBold.copyWith(
                                          fontSize: FontUtils.verySmall),
                                    ),
                                  ],
                                ),
                          Expanded(
                              child: bottomGridView(myProductListResponse!)),
                        ],
                      ),
                    ),
              if (controller.isPaginationLoading && isPageFirst)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(child: Loader()),
                )
            ],
          ),
        );
      },
    ));
  }

  getProductCount(List<MyProductListResponseModel>? myProductListResponse) {
    int count = 0;

    if (searchKey != null) {
      for (var element in myProductListResponse!) {
        if (element.name == null) {
          count == 0;
        } else {
          if ((element.name as String)
              .toLowerCase()
              .contains(searchKey!.toLowerCase())) {
            count++;
          }
        }
      }
    }

    return count;
  }

  Future<dynamic> bottomSheet() {
    return Get.bottomSheet(
        Column(
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  exportBottomSheet();
                },
                child: Row(
                  children: [
                    Image.asset(
                      Images.export,
                      height: 20,
                      width: 20,
                    ),
                    width20(),
                    Text(
                      'Export'.tr,
                      style: ThemeUtils.blackBold
                          .copyWith(fontSize: FontUtils.small),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        backgroundColor: ColorsUtils.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))));
  }

  Column bottomContentWhileSelect({String? title, String? img}) {
    return Column(
      children: [
        Image.asset(
          img!,
          width: 20,
          color: ColorsUtils.black,
          height: 20,
        ),
        height5(),
        Text(
          title!.tr,
          style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small),
        )
      ],
    );
  }

  //while select bottom bar open
  RenderObjectWidget bottomNavigationBar() {
    return selectedList.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: ColorsUtils.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await deleteOnclick();
                        },
                        child: bottomContentWhileSelect(
                            img: Images.delete, title: 'Delete'),
                      ),
                      InkWell(
                        onTap: () {
                          print('$shareUrlList');
                          print('data is ${shareUrlList.join("\n")}');
                          Share.share(shareUrlList.join("\n"));
                        },
                        child: bottomContentWhileSelect(
                            img: Images.productShare, title: 'Share'),
                      ),
                      InkWell(
                        onTap: () {
                          bottomSheetDetail();
                        },
                        child: Column(
                          children: [
                            const Icon(Icons.more_horiz_outlined, size: 30),
                            height5(),
                            Text(
                              'More'.tr,
                              style: ThemeUtils.blackSemiBold
                                  .copyWith(fontSize: FontUtils.small),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        : SizedBox();
  }

  //while click on menu button open this bottom sheet
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
              InkWell(
                  onTap: () async {
                    await addStoreClickEvent();
                    Get.back();
                  },
                  child: bottomSheetText(
                      title: isShowEStore == true
                          ? 'Remove From Store'
                          : 'Add to store',
                      image: Images.addStore)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: dividerData(),
              ),
              bottomSheetText(
                  title: 'Add to new invoice', image: Images.addInvoice),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: dividerData(),
              ),
              InkWell(
                  onTap: () {
                    // print('data is ${shareUrlList.join(",")}');
                    Share.share(shareUrlList.join(","));
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
                  await deleteOnclick();
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

  Future<void> addStoreClickEvent() async {
    isShowEStore = !isShowEStore;
    // int show = 0;

    bool show = isShowEStore == true
        ? true
        : isShowEStore == false
            ? false
            : false;
    // show = isShowEStore == true
    //     ? 1
    //     : isShowEStore == false
    //         ? 0
    //         : 0;
    setState(() {});
    int i = 0;
    showEStoreReq.showproduct = show;

    for (i = 0; i < selectedList.length; i++) {
      print(selectedList[i]);
      showLoadingDialog(context: context);
      await myProductListViewModel.showEStore(
          selectedList[i].toString(), showEStoreReq);
      Get.back();
    }
  }

  //after click on export open bottom sheet
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
                      List temp = [];

                      if (selectedList.isNotEmpty) {
                        int i;
                        for (i = 0; i <= selectedList.length - 1; i++) {
                          print('&filter[where][id][inq][$i]');
                          temp.add(
                              '&filter[where][id][inq][$i]=${selectedList[i]}');
                        }
                        // selectedList.asMap().forEach((i, e) {
                        //   temp.add('&filter[where][id][inq][$i]=$e');
                        // });

                        print(
                            'temp  is ${temp.join(',').toString().replaceAll(',', '')}');
                      }

                      if (isRadioSelected == 0) {
                        Get.snackbar('error', 'Please select Format!'.tr);
                      } else {
                        if (sendEmail == true) {
                          String token = await encryptedSharedPreferences
                              .getString('token');
                          final url = Uri.parse(selectedList.isNotEmpty
                              ? isRadioSelected == 1
                                  ? '${Utility.baseUrl}products/pdfexport?filter[include]=productmedia&filter[where][price][lte]=20000&filter[where][price][gte]=0${temp.join(',').toString().replaceAll(',', '')}&isEmail=true'
                                  : '${Utility.baseUrl}products/xlsxexport?filter[include]=productmedia&filter[where][price][lte]=20000&filter[where][price][gte]=0${temp.join(',').toString().replaceAll(',', '')}&isEmail=true'
                              : '${Utility.baseUrl}products/${isRadioSelected == 1 ? 'pdf' : isRadioSelected == 3 ? 'xlsx' : 'xlsx'}export?${isRadioSelected == 3 ? 'filter[include]=productmedia' : 'filter={}'}&isEmail=true');
                          final request = http.Request("GET", url);
                          request.headers.addAll(<String, String>{
                            'Authorization': token,
                            'Content-Type': 'application/json'
                          });
                          request.body = '';
                          final res = await request.send();
                          if (res.statusCode == 200) {
                            Get.snackbar('Success'.tr, 'send successFully'.tr);
                          } else {
                            print('error ::${res.request}');
                            Get.snackbar('error', '${res.request}');
                          }
                        } else {
                          if (selectedList.isEmpty) {
                            await downloadFile(
                              isEmail: sendEmail,
                              isRadioSelected: isRadioSelected,
                              url:
                                  '${Utility.baseUrl}products/${isRadioSelected == 1 ? 'pdf' : isRadioSelected == 3 ? 'xlsx' : 'xlsx'}export?${isRadioSelected == 3 ? 'filter[include]=productmedia' : 'filter={}'}',
                              context: context,
                            );
                          } else {
                            if (selectedList.isNotEmpty) {
                              // pdfexport
                              String url = isRadioSelected == 1
                                  ? '${Utility.baseUrl}products/pdfexport?filter[include]=productmedia&filter[where][price][lte]=20000&filter[where][price][gte]=0${temp.join(',').toString().replaceAll(',', '')}'
                                  : '${Utility.baseUrl}products/xlsxexport?filter[include]=productmedia&filter[where][price][lte]=20000&filter[where][price][gte]=0${temp.join(',').toString().replaceAll(',', '')}';
                              await downloadFile(
                                isEmail: sendEmail,
                                isRadioSelected: isRadioSelected,
                                url: url,
                                context: context,
                              );
                            }
                          }
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

  //while click on menu button content
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

  Future<void> deleteOnclick() async {
    print('del$selectedList');
    int i = 0;
    showLoadingDialog(context: context);

    for (i = 0; i < selectedList.length; i++) {
      print(selectedList[i]);
      await deleteApiCall(id: selectedList[i].toString());
    }
    hideLoadingDialog(context: context);
    Get.snackbar('Success'.tr, 'delete successFully'.tr);
    Future.delayed(const Duration(seconds: 1), () {
      return Get.to(() => MyProductScreen());
    });
  }

  //delete api call
  Future<void> deleteApiCall({required String id}) async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}products/$id');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.delete(
      url,
      headers: header,
    );
    print(
        'token is:$token \n req is : ${result.request}  \n response is :${result.body} ');
    if (result.statusCode == 200) {
      myProductListViewModel.deleteProductItem(id);
    } else {
      const SessionExpire();
      // Get.snackbar('error', 'something Wrong');
    }
  }

  initData(String searchFilter) async {
    Utility.filterSorted = '&filter[order]=created DESC';
    String id = await encryptedSharedPreferences.getString('id');
    email = await encryptedSharedPreferences.getString('email');
    token = await encryptedSharedPreferences.getString('token');
    myProductListViewModel.clearResponseLost();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !myProductListViewModel.isPaginationLoading) {
          myProductListViewModel
              .myProductList(id + searchFilter + Utility.filterSorted);

          print('is page first $isPageFirst');
        }
      });
    // await myProductListViewModel.productCount(id, '');
    myProductListViewModel.myProductList(
        id + searchFilter + Utility.filterSorted,
        isLoading: false);
    if (isPageFirst == false) {
      isPageFirst = true;
    }
    print('is page first $isPageFirst');
  }

  Widget bottomGridView(List<MyProductListResponseModel> res) {
    if (res.isEmpty && !myProductListViewModel.isPaginationLoading) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Text('No data found'.tr),
      ));
    }
    final resList = searchKey != null && searchKey != ""
        ? res
            .where((element) => element.name
                .toString()
                .toLowerCase()
                .contains(searchKey!.toLowerCase()))
            .toList()
        : [];
    return res.isEmpty && !myProductListViewModel.isPaginationLoading
        ? Center(
            child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text('No data found'.tr),
          ))
        : GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: resList.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20),
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              if (searchKey != null && searchKey != "") {
                if (resList[index]
                    .name
                    .toString()
                    .toLowerCase()
                    .contains(searchKey!.toLowerCase())) {
                  return InkWell(
                    onTap: () async {
                      await Get.to(() => ProductDetailScreen(
                            productId: resList[index].id.toString(),
                          ));
                      // initData();
                    },
                    child: Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: ColorsUtils.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: resList[index].productmedia!.isEmpty
                                      ? SizedBox(
                                          width: Get.width,
                                          height: Get.height * 0.14,
                                          child: Stack(
                                            children: [
                                              Center(
                                                  child: Image.asset(
                                                Images.noImage,
                                                height: 50,
                                                width: 50,
                                              )),
                                              isSelect == true
                                                  ? InkWell(
                                                      onTap: () {
                                                        int id =
                                                            resList[index].id;
                                                        String shareUrl =
                                                            'https://d.sadad.qa/${resList[index].shareUrl}';
                                                        setState(() {
                                                          if (selectedList
                                                              .contains(id)) {
                                                            selectedList
                                                                .remove(id);
                                                          } else {
                                                            selectedList
                                                                .add(id);
                                                            print(
                                                                'selected list is $selectedList');
                                                          }
                                                          if (shareUrlList
                                                              .contains(
                                                                  shareUrl)) {
                                                            shareUrlList.remove(
                                                                shareUrl);
                                                          } else {
                                                            shareUrlList
                                                                .add(shareUrl);
                                                          }
                                                        });

                                                        // resList[index].productmedia
                                                        // setState(() {
                                                        //   if(selectedList.contains())
                                                        // });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            height: Get.height *
                                                                0.14,
                                                            width: Get.width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.3),
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      ColorsUtils
                                                                          .white,
                                                                  border: Border.all(
                                                                      color: ColorsUtils
                                                                          .black,
                                                                      width: 1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: selectedList
                                                                      .contains(
                                                                          resList[index]
                                                                              .id)
                                                                  ? Center(
                                                                      child: Image.asset(
                                                                          Images
                                                                              .check,
                                                                          height:
                                                                              10,
                                                                          width:
                                                                              10))
                                                                  : SizedBox(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          width: Get.width,
                                          height: Get.height * 0.14,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10)),
                                                child: Image.network(
                                                  '${Utility.baseUrl}containers/api-product/download/${resList[index].productmedia!.first.name}',
                                                  headers: {
                                                    HttpHeaders
                                                            .authorizationHeader:
                                                        token
                                                  },
                                                  fit: BoxFit.cover,
                                                  width: Get.width,
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
                                              isSelect == true
                                                  ? InkWell(
                                                      onTap: () {
                                                        int id =
                                                            resList[index].id;
                                                        String shareUrl =
                                                            'https://d.sadad.qa/${resList[index].shareUrl}';
                                                        setState(() {
                                                          if (selectedList
                                                              .contains(id)) {
                                                            selectedList
                                                                .remove(id);
                                                          } else {
                                                            selectedList
                                                                .add(id);

                                                            print(
                                                                'selected list is $selectedList');
                                                          }
                                                          if (shareUrlList
                                                              .contains(
                                                                  shareUrl)) {
                                                            shareUrlList.remove(
                                                                shareUrl);
                                                          } else {
                                                            shareUrlList
                                                                .add(shareUrl);
                                                          }
                                                        });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                              height:
                                                                  Get.height *
                                                                      0.14,
                                                              width: Get.width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.3),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10)),
                                                              )),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      ColorsUtils
                                                                          .white,
                                                                  border: Border.all(
                                                                      color: ColorsUtils
                                                                          .black,
                                                                      width: 1),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              child: selectedList
                                                                      .contains(
                                                                          resList[index]
                                                                              .id)
                                                                  ? Center(
                                                                      child: Image.asset(
                                                                          Images
                                                                              .check,
                                                                          height:
                                                                              10,
                                                                          width:
                                                                              10))
                                                                  : SizedBox(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: Text(
                                          resList[index].name ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: ThemeUtils.blackBold.copyWith(
                                              fontSize: FontUtils.verySmall),
                                        ),
                                      ),
                                      height10(),
                                      Text(
                                        '${double.parse(resList[index].price.toString()).toStringAsFixed(2)} QAR',
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.mediumSmall,
                                            color: ColorsUtils.accent),
                                      ),
                                      height10(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            Images.basket,
                                            height: 20,
                                            width: 20,
                                          ),
                                          Text(
                                            '${resList[index].totalavailablequantity}',
                                            style:
                                                ThemeUtils.blackBold.copyWith(
                                              fontSize: FontUtils.small,
                                            ),
                                          ),
                                          Image.asset(
                                            Images.storesMenu,
                                            height: 20,
                                            width: 20,
                                          ),
                                          width20()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  color: ColorsUtils.lightPink),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                    child: Image.asset(
                                  Images.productShare,
                                  width: 20,
                                  height: 20,
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }
              return SizedBox();
              // return InkWell(
              //   onTap: () async {
              //     await Get.to(() => ProductDetailScreen(
              //           productId: resList[index].id.toString(),
              //         ));
              //     // initData();
              //   },
              //   child: Container(
              //     width: Get.width,
              //     decoration: BoxDecoration(
              //       color: ColorsUtils.white,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Stack(
              //       children: [
              //         Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Padding(
              //                 padding: const EdgeInsets.all(3),
              //                 child: resList[index].productmedia!.isEmpty
              //                     ? SizedBox(
              //                         width: Get.width,
              //                         height: Get.height * 0.14,
              //                         child: Stack(
              //                           children: [
              //                             Center(
              //                                 child: Image.asset(
              //                               Images.noImage,
              //                               height: 50,
              //                               width: 50,
              //                             )),
              //                             isSelect == true
              //                                 ? InkWell(
              //                                     onTap: () {
              //                                       int id = resList[index].id;
              //                                       String shareUrl =
              //                                           'https://d.sadad.qa/${resList[index].shareUrl}';
              //                                       setState(() {
              //                                         if (selectedList
              //                                             .contains(id)) {
              //                                           selectedList.remove(id);
              //                                         } else {
              //                                           selectedList.add(id);
              //                                           print(
              //                                               'selected list is $selectedList');
              //                                         }
              //                                         if (shareUrlList
              //                                             .contains(shareUrl)) {
              //                                           shareUrlList
              //                                               .remove(shareUrl);
              //                                         } else {
              //                                           shareUrlList
              //                                               .add(shareUrl);
              //                                         }
              //                                       });
              //
              //                                       // resList[index].productmedia
              //                                       // setState(() {
              //                                       //   if(selectedList.contains())
              //                                       // });
              //                                     },
              //                                     child: Stack(
              //                                       children: [
              //                                         Container(
              //                                           height:
              //                                               Get.height * 0.14,
              //                                           width: Get.width,
              //                                           decoration:
              //                                               BoxDecoration(
              //                                             color: Colors.black
              //                                                 .withOpacity(0.3),
              //                                             borderRadius:
              //                                                 BorderRadius.only(
              //                                                     topLeft: Radius
              //                                                         .circular(
              //                                                             10),
              //                                                     topRight: Radius
              //                                                         .circular(
              //                                                             10)),
              //                                           ),
              //                                         ),
              //                                         Padding(
              //                                           padding:
              //                                               const EdgeInsets
              //                                                   .all(10),
              //                                           child: Container(
              //                                             width: 20,
              //                                             height: 20,
              //                                             decoration: BoxDecoration(
              //                                                 color: ColorsUtils
              //                                                     .white,
              //                                                 border: Border.all(
              //                                                     color:
              //                                                         ColorsUtils
              //                                                             .black,
              //                                                     width: 1),
              //                                                 borderRadius:
              //                                                     BorderRadius
              //                                                         .circular(
              //                                                             5)),
              //                                             child: selectedList
              //                                                     .contains(
              //                                                         resList[index]
              //                                                             .id)
              //                                                 ? Center(
              //                                                     child: Image.asset(
              //                                                         Images
              //                                                             .check,
              //                                                         height:
              //                                                             10,
              //                                                         width:
              //                                                             10))
              //                                                 : SizedBox(),
              //                                           ),
              //                                         ),
              //                                       ],
              //                                     ),
              //                                   )
              //                                 : SizedBox(),
              //                           ],
              //                         ),
              //                       )
              //                     : Container(
              //                         width: Get.width,
              //                         height: Get.height * 0.14,
              //                         decoration: BoxDecoration(
              //                             borderRadius:
              //                                 BorderRadius.circular(10)),
              //                         child: Stack(
              //                           children: [
              //                             ClipRRect(
              //                               borderRadius: BorderRadius.only(
              //                                   topLeft: Radius.circular(10),
              //                                   topRight: Radius.circular(10)),
              //                               child: Image.network(
              //                                 'http://176.58.99.102:3001/api-v1/containers/api-product/download/${resList[index].productmedia!.first.name}',
              //                                 headers: {
              //                                   HttpHeaders.authorizationHeader:
              //                                       token
              //                                 },
              //                                 fit: BoxFit.cover,
              //                                 width: Get.width,
              //                                 loadingBuilder:
              //                                     (BuildContext context,
              //                                         Widget child,
              //                                         ImageChunkEvent?
              //                                             loadingProgress) {
              //                                   if (loadingProgress == null)
              //                                     return child;
              //                                   return Center(
              //                                     child:
              //                                         CircularProgressIndicator(
              //                                       value: loadingProgress
              //                                                   .expectedTotalBytes !=
              //                                               null
              //                                           ? loadingProgress
              //                                                   .cumulativeBytesLoaded /
              //                                               loadingProgress
              //                                                   .expectedTotalBytes!
              //                                           : null,
              //                                     ),
              //                                   );
              //                                 },
              //                               ),
              //                             ),
              //                             isSelect == true
              //                                 ? InkWell(
              //                                     onTap: () {
              //                                       int id = resList[index].id;
              //                                       String shareUrl =
              //                                           'https://d.sadad.qa/${resList[index].shareUrl}';
              //                                       setState(() {
              //                                         if (selectedList
              //                                             .contains(id)) {
              //                                           selectedList.remove(id);
              //                                         } else {
              //                                           selectedList.add(id);
              //
              //                                           print(
              //                                               'selected list is $selectedList');
              //                                         }
              //                                         if (shareUrlList
              //                                             .contains(shareUrl)) {
              //                                           shareUrlList
              //                                               .remove(shareUrl);
              //                                         } else {
              //                                           shareUrlList
              //                                               .add(shareUrl);
              //                                         }
              //                                       });
              //                                     },
              //                                     child: Stack(
              //                                       children: [
              //                                         Container(
              //                                             height:
              //                                                 Get.height * 0.14,
              //                                             width: Get.width,
              //                                             decoration:
              //                                                 BoxDecoration(
              //                                               color: Colors.black
              //                                                   .withOpacity(
              //                                                       0.3),
              //                                               borderRadius: BorderRadius.only(
              //                                                   topLeft: Radius
              //                                                       .circular(
              //                                                           10),
              //                                                   topRight: Radius
              //                                                       .circular(
              //                                                           10)),
              //                                             )),
              //                                         Padding(
              //                                           padding:
              //                                               const EdgeInsets
              //                                                   .all(10),
              //                                           child: Container(
              //                                             width: 20,
              //                                             height: 20,
              //                                             decoration: BoxDecoration(
              //                                                 color: ColorsUtils
              //                                                     .white,
              //                                                 border: Border.all(
              //                                                     color:
              //                                                         ColorsUtils
              //                                                             .black,
              //                                                     width: 1),
              //                                                 borderRadius:
              //                                                     BorderRadius
              //                                                         .circular(
              //                                                             5)),
              //                                             child: selectedList
              //                                                     .contains(
              //                                                         resList[index]
              //                                                             .id)
              //                                                 ? Center(
              //                                                     child: Image.asset(
              //                                                         Images
              //                                                             .check,
              //                                                         height:
              //                                                             10,
              //                                                         width:
              //                                                             10))
              //                                                 : SizedBox(),
              //                                           ),
              //                                         ),
              //                                       ],
              //                                     ),
              //                                   )
              //                                 : SizedBox(),
              //                           ],
              //                         ),
              //                       ),
              //               ),
              //               Spacer(),
              //               Padding(
              //                 padding: const EdgeInsets.all(10),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 30,
              //                       child: Text(
              //                         resList[index].name ?? "",
              //                         overflow: TextOverflow.ellipsis,
              //                         maxLines: 2,
              //                         style: ThemeUtils.blackBold.copyWith(
              //                             fontSize: FontUtils.verySmall),
              //                       ),
              //                     ),
              //                     height10(),
              //                     Text(
              //                       '${double.parse(resList[index].price.toString()).toStringAsFixed(2)} QAR',
              //                       style: ThemeUtils.blackBold.copyWith(
              //                           fontSize: FontUtils.mediumSmall,
              //                           color: ColorsUtils.accent),
              //                     ),
              //                     height10(),
              //                     Row(
              //                       mainAxisAlignment:
              //                           MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Image.asset(
              //                           Images.basket,
              //                           height: 20,
              //                           width: 20,
              //                         ),
              //                         Text(
              //                           '${resList[index].totalavailablequantity}',
              //                           style: ThemeUtils.blackBold.copyWith(
              //                             fontSize: FontUtils.small,
              //                           ),
              //                         ),
              //                         Image.asset(
              //                           Images.storesMenu,
              //                           height: 20,
              //                           width: 20,
              //                         ),
              //                         width20()
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ]),
              //         Positioned(
              //           bottom: 0,
              //           right: 0,
              //           child: Container(
              //             decoration: const BoxDecoration(
              //                 borderRadius: BorderRadius.only(
              //                     bottomRight: Radius.circular(10),
              //                     topLeft: Radius.circular(10)),
              //                 color: ColorsUtils.lightPink),
              //             child: Padding(
              //               padding: const EdgeInsets.all(8),
              //               child: Center(
              //                   child: Image.asset(
              //                 Images.productShare,
              //                 width: 20,
              //                 height: 20,
              //               )),
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // );
            });
  }
}
