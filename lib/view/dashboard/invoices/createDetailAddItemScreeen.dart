import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'createDetailAddProductScreen.dart';

class CreateDetailedInvoiceAddItem extends StatefulWidget {
  Map<String, dynamic>? data;

  CreateDetailedInvoiceAddItem({this.data});
  // const CreateDetailedInvoiceAddItem({Key? key,this.data}) : super(key: key);
  @override
  State<CreateDetailedInvoiceAddItem> createState() =>
      _CreateDetailedInvoiceAddItemState();
}

class _CreateDetailedInvoiceAddItemState
    extends State<CreateDetailedInvoiceAddItem> {
  TextEditingController itemName = TextEditingController();
  TextEditingController itemPrice = TextEditingController();
  TextEditingController quantity = TextEditingController();

  // CreateProductRequestModel createProductReq = CreateProductRequestModel();
  // CreateProductViewModel createProductViewModel = Get.find();
  var result = '0';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print('data ${widget.data}');
    if (widget.data != null) {
      itemName.text = widget.data!['title'];

      itemPrice.text = widget.data!['amount'].toString();

      quantity.text = widget.data!['quantity'].toString().split('.').first;
    }
    result = '0';
    if (itemPrice.text.isNotEmpty && quantity.text.isNotEmpty) {
      result = (double.parse(itemPrice.text) * double.parse(quantity.text))
          .toString();
      print("RESULT $result");
    }
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomBar(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          itemPrice.clear();
                          itemName.clear();
                          quantity.clear();
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          final status =
                              await Get.to(() => CreateDetailAddProduct());
                          print('status i $status');
                          Get.back(result: status);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              color: ColorsUtils.accent,
                            ),
                            width10(),
                            Text(
                              'Add Product'.tr,
                              style: ThemeUtils.blackBold.copyWith(
                                  fontSize: FontUtils.mediumSmall,
                                  color: ColorsUtils.accent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  height25(),
                  Text(
                    'New Item'.tr,
                    style: ThemeUtils.blackBold.copyWith(
                      fontSize: FontUtils.large,
                    ),
                  ),
                  height20(),
                  commonTextField(
                      hint: 'Item Name'.tr,
                      contollerr: itemName,
                      inputLength: 40,
                      regularExpression:
                          TextValidation.alphabetSpaceValidationPattern,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Item Name cannot be empty".tr;
                        }
                        return null;
                      }),
                  height20(),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: commonTextField(
                            suffix: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'QAR',
                                style: ThemeUtils.blackSemiBold
                                    .copyWith(fontSize: 16),
                              ),
                            ),
                            contollerr: itemPrice,
                            onChange: (str) {
                              result = '0';
                              if (str.isNotEmpty && quantity.text.isNotEmpty) {
                                result = (double.parse(str) *
                                        double.parse(quantity.text))
                                    .toString();
                                print("RESULT $result");
                              }
                              setState(() {});
                            },
                            hint: 'Item Price'.tr,
                            keyType:
                                TextInputType.numberWithOptions(decimal: true),
                            regularExpression:
                                TextValidation.doubleDigitsValidationPattern,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Price cannot be empty".tr;
                              }
                              if (value == '0') {
                                return "Amount cannot be 0";
                              }
                              if (double.parse(value) < 1) {
                                return "Amount should be \nmore than 1";
                              }
                              // if (double.parse(value) > 50000) {
                              //   return "maximum amount should be QAR 50,000.00";
                              // }
                              return null;
                            },
                            inputLength: 20),
                      ),
                      width10(),
                      Expanded(
                        flex: 3,
                        child: commonTextField(
                            hint: 'Quantity'.tr,
                            onChange: (str) {
                              result = '0';
                              if (str.isNotEmpty && itemPrice.text.isNotEmpty) {
                                result = (double.parse(itemPrice.text) *
                                        double.parse(str))
                                    .toString();
                                print("RESULT $result");
                              }
                              setState(() {});
                            },
                            contollerr: quantity,
                            inputLength: 40,
                            keyType: TextInputType.number,
                            regularExpression:
                                TextValidation.digitsValidationPattern,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Quantity cannot be empty".tr;
                              }
                              if (value == '0') {
                                return "Quantity cannot be 0";
                              }
                              return null;
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  Padding bottomBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsUtils.border.withOpacity(0.3),
                border: Border.all(color: ColorsUtils.border, width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                Text(
                  'Invoice Amount'.tr,
                  style: ThemeUtils.blackBold,
                ),
                const Spacer(),
                // Text("${quantity.text}")
                Text(
                  '$result QAR',
                  style: ThemeUtils.blackBold.copyWith(
                      color: ColorsUtils.invoiceAmount,
                      fontSize: FontUtils.mediumSmall),
                ),
              ]),
            ),
          ),
          height20(),
          InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                if (widget.data != null) {
                  Get.back(
                    result: {
                      "title": itemName.text,
                      "amount": double.parse(itemPrice.text),
                      "quantity": double.parse(quantity.text),
                    },
                  );
                } else {
                  setState(() {
                    Utility.selectedProductData.add({
                      "title": itemName.text,
                      "icon": null,
                      "value": '',
                      "amount": double.parse(itemPrice.text),
                      "quantity": double.parse(quantity.text),
                    });
                    print('add data ${Utility.selectedProductData}');

                    // int index = 1;
                    // Utility.mapCount.addAll({index: 1});

                    Get.back(result: true);
                  });
                }
              }
            },
            child: buildContainerWithoutImage(
                text: widget.data != null ? 'Update'.tr : 'Add'.tr,
                color: ColorsUtils.invoiceAmount),
          )
        ],
      ),
    );
  }
}
