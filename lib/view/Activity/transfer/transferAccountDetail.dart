import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/transferOtpScreen.dart';
import 'package:http/http.dart' as http;

class TransferAccountDetails extends StatefulWidget {
  final String name;
  final String number;
  final String accountId;
  const TransferAccountDetails(
      {Key? key,
      required this.name,
      required this.number,
      required this.accountId})
      : super(key: key);

  @override
  State<TransferAccountDetails> createState() => _TransferAccountDetailsState();
}

class _TransferAccountDetailsState extends State<TransferAccountDetails> {
  TextEditingController amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///top data
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: ColorsUtils.transferBg,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height20(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                    ),
                    height40(),
                    customMediumLargeBoldText(
                        title: 'Transfer Account Details'),
                    height30(),
                    commonDataField(
                        title: 'Receiver name', subtitle: widget.name),
                    commonDataField(
                        title: 'Phone number',
                        subtitle: '+974-${widget.number}'),
                    commonDataField(
                        title: 'Account Id', subtitle: widget.accountId),
                  ],
                ),
              ),
            ),

            ///transfer detail
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height10(),
                    customMediumLargeBoldText(title: 'Transfer Details'),
                    height20(),
                    SizedBox(
                      child: commonTextField(
                          suffix: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'QAR',
                              style: ThemeUtils.blackSemiBold
                                  .copyWith(fontSize: 16),
                            ),
                          ),
                          contollerr: amount,
                          hint: 'Transfer Amount',
                          keyType:
                              TextInputType.numberWithOptions(decimal: true),
                          // keyType: TextInputType.number,
                          onChange: (str) {
                            setState(() {});
                          },
                          regularExpression:
                              TextValidation.doubleDigitsValidationPattern,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Amount cannot be empty";
                            }
                            if (value == '0') {
                              return "Amount cannot be 0";
                            }
                            if (double.parse(value) < 5) {
                              return "The Given Transfer Amount is less than 5.\nTry with valid amount";
                            }

                            // if (double.parse(value) > 50000) {
                            //   return "maximum amount should be QAR 50,000.00";
                            // }

                            return null;
                          },
                          inputLength: 5),
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

  Padding bottomBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: ColorsUtils.transferUnSelect,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ColorsUtils.border, width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  customSmallBoldText(
                    title: 'Amount',
                  ),
                  Spacer(),
                  customSmallBoldText(
                      title: '${amount.text == '' ? "0" : amount.text} QAR',
                      color: ColorsUtils.accent),
                ],
              ),
            ),
          ),
          height15(),
          InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  if (Utility.userPhone != widget.number) {
                    showLoadingDialog(context: context);
                    String token =
                        await encryptedSharedPreferences.getString('token');
                    final url = Uri.parse(
                        '${Utility.baseUrl}usermetaauths/resendotp?type=transferotp');
                    Map<String, String> header = {
                      'Authorization': token,
                      'Content-Type': 'application/json'
                    };

                    var result = await http.get(
                      url,
                      headers: header,
                    );
                    print('result###${result.body}');
                    if (result.statusCode == 200) {
                      Future.delayed(Duration(seconds: 1), () {
                        hideLoadingDialog(context: context);

                        Get.to(() => TransferOtpScreen(
                              amount: amount.text,
                              mobile: widget.number,
                            ));
                      });
                    } else {
                      hideLoadingDialog(context: context);

                      Get.snackbar(
                        'error'.tr,
                        '${jsonDecode(result.body)['error']['message']}',
                      );
                    }
                  } else {
                    Get.snackbar(
                        'error'.tr, 'you can not create invoice by your self');
                  }
                }
              },
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Next')),
          height10()
        ],
      ),
    );
  }

  Column commonDataField({String? title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customSmallNorText(title: title),
        height5(),
        customSmallMedBoldText(title: subtitle),
        height10(),
      ],
    );
  }
}
