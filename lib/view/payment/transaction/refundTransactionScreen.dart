// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';

class RefundTransactionScreen extends StatefulWidget {
  Map<String, dynamic>? transactionDetail;

  RefundTransactionScreen({Key? key, this.transactionDetail}) : super(key: key);

  @override
  State<RefundTransactionScreen> createState() =>
      _RefundTransactionScreenState();
}

class _RefundTransactionScreenState extends State<RefundTransactionScreen> {
  int isRadioSelected = 0;
  bool isFull = false;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();
  int expectedDays = 0;
  String expectedDaysValue = '';
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    print('type ${widget.transactionDetail!['type']}');
    amount.text = '${widget.transactionDetail!['amount']}';
    isFull = true;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ColorsUtils.lightBg,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height40(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      height30(),
                      customMediumLargeBoldText(title: 'Refund Details'.tr),
                      height10(),
                      Row(
                        children: [
                          customSmallSemiText(title: 'Transaction ID.'.tr),
                          Spacer(),
                          customSmallMedBoldText(
                              title:
                                  '${widget.transactionDetail!['id'] ?? "NA"}')
                        ],
                      ),
                      height10(),
                      Row(
                        children: [
                          customSmallSemiText(title: 'Transaction Amount'.tr),
                          Spacer(),
                          customSmallMedBoldText(
                              title:
                                  '${widget.transactionDetail!['amount'] ?? "0"} QAR')
                        ],
                      ),
                      height10(),
                      Row(
                        children: [
                          customSmallSemiText(title: 'Prior Refund Amount'.tr),
                          Spacer(),
                          customSmallMedBoldText(
                              title:
                                  '${widget.transactionDetail!['PriorAmount'] ?? "0"} QAR')
                        ],
                      ),
                      height10(),
                    ],
                  ),
                ),
              ),
              Container(
                width: Get.width,
                color: ColorsUtils.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height30(),
                      customSmallMedBoldText(
                          title: 'Enter the refund Full Amount'.tr),
                      height10(),
                      Column(
                        children: [
                          LabeledRadio(
                            label: 'Full amount refund'.tr,
                            value: 0,
                            groupValue: isRadioSelected,
                            onChanged: (newValue) {
                              setState(() {
                                isFull = !isFull;
                                isFull == true
                                    ? amount.text =
                                        '${widget.transactionDetail!['amount']}'
                                    : '0';
                                isRadioSelected = newValue;
                              });
                            },
                          ),
                          ((widget.transactionDetail!['isCredit'] == 3) ||
                                  (widget.transactionDetail!['isCredit'] ==
                                      2) ||
                                  (widget.transactionDetail!['isCredit'] == 1))
                              ? LabeledRadio(
                                  label: 'Partial refund'.tr,
                                  value: 1,
                                  groupValue: isRadioSelected,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isFull = false;
                                      isFull == false ? amount.text = "0" : '';
                                      isRadioSelected = newValue;
                                    });
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                      height10(),
                      ((widget.transactionDetail!['isCredit'] == 3) ||
                              (widget.transactionDetail!['isCredit'] == 2) ||
                              (widget.transactionDetail!['isCredit'] == 1))
                          ? IgnorePointer(
                              ignoring: isFull,
                              child: commonTextField(
                                contollerr: amount,
                                isRead: isFull,
                                hint: 'Amount'.tr,
                                regularExpression: TextValidation
                                    .doubleDigitsValidationPattern,
                                keyType: TextInputType.numberWithOptions(
                                    decimal: true),
                              ),
                            )
                          : SizedBox(),
                      height20(),
                      commonTextField(
                          contollerr: description,
                          hint: 'Reason'.tr,
                          validator: (str) {
                            // if (str!.isEmpty) {
                            //   return "Description is required!".tr;
                            // }
                            // if (str!.length < 5) {
                            //   return "Text Need To Be Atleast 5 Character".tr;
                            // }
                            // if (str.length >= 5000) {
                            //   return "Description is too long. Maximum 5000 characters allowed."
                            //       .tr;
                            // }
                          },
                          maxLines: 4)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column bottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () async {
              connectivityViewModel.startMonitoring();

              if (connectivityViewModel.isOnline != null) {
                if (connectivityViewModel.isOnline!) {
                  if (_formKey.currentState!.validate()) {
                    showLoadingDialog(context: context);
                    String token =
                        await encryptedSharedPreferences.getString('token');
                    final url = Uri.parse(
                      '${Utility.baseUrl}transactions/${widget.transactionDetail!['type'] == 'SADAD PAY' ? 'sadadRefund' : 'debitCreditRefundRequest'}',
                    );
                    Map<String, String> header = {
                      'Authorization': token,
                      'Content-Type': 'application/json'
                    };
                    Map<String, dynamic>? body = {
                      "transactionnumber": "${widget.transactionDetail!['id']}",
                      "transaction_note":
                          description.text.isEmpty ? "" : description.text,
                      if (isFull == false) "isPartialRefund": !isFull,
                      if (isFull == false) "amount": double.parse(amount.text)
                    };

                    var result = await http.post(
                      url,
                      headers: header,
                      body: jsonEncode(body),
                    );
                    print('req is $body');
                    print(
                        'token is:$token \n req is : ${jsonEncode(body)}  \n response is :${result.body} ');

                    if (result.statusCode == 200) {
                      Get.back();

                      Get.snackbar('Success'.tr, 'refund successfully');

                      hideLoadingDialog(context: context);
                    } else if (result.statusCode == 499) {
                      hideLoadingDialog(context: context);

                      Get.off(() => UnderMaintenanceScreen());
                    } else {
                      if (result.statusCode == 401) {
                        SessionExpire();
                      }

                      hideLoadingDialog(context: context);

                      Get.snackbar('error'.tr,
                          '${jsonDecode(result.body)['error']['message']}');
                    }
                  }
                } else {
                  Get.snackbar('error'.tr, 'Please check your connection'.tr);
                }
              } else {
                Get.snackbar('error'.tr, 'Please check your connection'.tr);
              }
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Refund'.tr),
          ),
        ),
      ],
    );
  }
}
