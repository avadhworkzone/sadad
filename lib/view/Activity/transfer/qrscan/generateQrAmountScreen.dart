import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/qrscan/qrPaymentAmountScreen.dart';
import 'package:http/http.dart' as http;

class GenerateQrAmountScreen extends StatefulWidget {
  const GenerateQrAmountScreen({Key? key}) : super(key: key);

  @override
  State<GenerateQrAmountScreen> createState() => _GenerateQrAmountScreenState();
}

class _GenerateQrAmountScreenState extends State<GenerateQrAmountScreen> {
  TextEditingController amount = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios_rounded)),
                    height40(),
                    customMediumLargeBoldText(
                        title: 'Generate QR payment code'),
                    height20(),
                    customVerySmallSemiText(
                        title:
                            'Create QR payment code with the amount you need and send it to any one to pay the amount you assigned.'),
                    height40(),
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
                              return "Amount cannot be empty".tr;
                            }
                            if (value == '0') {
                              return "Amount cannot be 0";
                            }
                            if (double.parse(value) < 1) {
                              return "Amount can not be less than QAR 1.00  ";
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
            ),
          ),
          InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              showLoadingDialog(context: context);
              String token =
                  await encryptedSharedPreferences.getString('token');
              final url = Uri.parse(
                '${Utility.baseUrl}qrcodes',
              );
              Map<String, String> header = {
                'Authorization': token,
                'Content-Type': 'application/json'
              };

              Map<String, dynamic> body = {"amount": double.parse(amount.text)};

              print(jsonEncode(body));

              var result =
                  await http.post(url, headers: header, body: jsonEncode(body));
              print('url $url');
              print(
                  'token is:$token } req is ${jsonEncode(body)} \n response is :${result.body} ');
              // if (result.statusCode == 401) {
              //   SessionExpire();
              // }

              if (result.statusCode == 200) {
                hideLoadingDialog(context: context);
                print('code is ${jsonDecode(result.body)['code']}');
                Get.to(() => QrPaymentAmountScreen(
                      amount: amount.text,
                      code: jsonDecode(result.body)['code'].toString(),
                    ));
                Get.snackbar('success', 'QR generate Successfully');
              } else {
                hideLoadingDialog(context: context);

                Get.snackbar('error'.tr,
                    '${jsonDecode(result.body)['error']['message']}');
              }
            },
            child: buildContainerWithoutImage(
                text: 'Generate Code', color: ColorsUtils.accent),
          ),
        ],
      ),
    ));
  }
}
