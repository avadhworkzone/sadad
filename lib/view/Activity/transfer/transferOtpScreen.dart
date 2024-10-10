import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/transferPaymentDoneScreen.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';

class TransferOtpScreen extends StatefulWidget {
  String? amount;
  String? mobile;
  TransferOtpScreen({Key? key, this.amount, this.mobile}) : super(key: key);

  @override
  State<TransferOtpScreen> createState() => _TransferOtpScreenState();
}

class _TransferOtpScreenState extends State<TransferOtpScreen> {
  int counter = 59;
  Timer? timer;
  String _code = "";
  String mobile = '';
  String mobileNo = '';
  TextEditingController otp = TextEditingController();
  smsOtpGet() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void initState() {
    smsOtpGet();
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  height40(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();

                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios)),
                  ),
                  height40(),
                  Text(
                    'Enter 6 digit OTP'.tr,
                    style: ThemeUtils.blackBold
                        .copyWith(fontSize: FontUtils.medLarge),
                  ),
                  height15(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${'We just sent the OTP to your mobile number'.tr} \n${Utility.countryCodeNumber} ${Utility.userPhone}',
                      textAlign: TextAlign.center,
                      style: ThemeUtils.blackSemiBold
                          .copyWith(fontSize: FontUtils.small),
                    ),
                  ),
                  height30(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PinFieldAutoFill(
                      controller: otp,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                      ],
                      keyboardType: TextInputType.phone,
                      decoration: BoxLooseDecoration(
                        textStyle: ThemeUtils.blackBold
                            .copyWith(fontSize: FontUtils.medium),
                        radius: Radius.circular(10),
                        hintText: '------',
                        // textStyle: TextStyle(fontSize: 20, color: Colors.black),
                        strokeColorBuilder:
                            FixedColorBuilder(Colors.black.withOpacity(0.3)),
                      ),
                      currentCode: _code,
                      codeLength: 6,
                      onCodeSubmitted: (code) async {},
                      onCodeChanged: (code) async {
                        // Get.to(() => TransferPaymentDoneScreen());

                        await aoicallForVerify(code, context);
                      },
                    ),
                  ),
                  // PinCodeTextField(
                  //   length: 6,
                  //   obscureText: false,
                  //   controller: otp,
                  //   hintCharacter: '_',
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                  //   ],
                  //   animationType: AnimationType.fade,
                  //   keyboardType: TextInputType.phone,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   pinTheme: PinTheme(
                  //     borderWidth: 1,
                  //     shape: PinCodeFieldShape.box,
                  //     activeColor: ColorsUtils.accent,
                  //     borderRadius: const BorderRadius.all(Radius.circular(10)),
                  //     fieldHeight: 50,
                  //     fieldWidth: 40,
                  //     fieldOuterPadding: const EdgeInsets.all(2),
                  //     selectedColor: ColorsUtils.border,
                  //     inactiveColor: ColorsUtils.border,
                  //   ),
                  //   animationDuration: Duration(milliseconds: 300),
                  //   onChanged: (value) async {
                  //     setState(() {});
                  //
                  //     if (otp.text.length == 6) {
                  //       print('hi');
                  //       showLoadingDialog(context: context);
                  //       String token =
                  //           await encryptedSharedPreferences.getString('token');
                  //       final url =
                  //           Uri.parse('${Utility.baseUrl}usermetaauths/verify');
                  //       Map<String, String> header = {
                  //         'Authorization': token,
                  //         'Content-Type': 'application/json'
                  //       };
                  //       Map<String, dynamic> body = {
                  //         "cellnumber": "${Utility.mobNo}",
                  //         "forgotpasswordotp": otp.text
                  //       };
                  //       var result = await http.post(url,
                  //           headers: header, body: jsonEncode(body));
                  //       print('otp verify res is ${result.body}');
                  //
                  //       if (result.statusCode == 200) {
                  //         hideLoadingDialog(context: context);
                  //
                  //         Future.delayed(Duration(seconds: 1), () {
                  //           hideLoadingDialog(context: context);
                  //           Get.off(() => TransferPaymentDoneScreen());
                  //
                  //           // Get.to(() => InvoiceList());
                  //         });
                  //       } else {
                  //         hideLoadingDialog(context: context);
                  //
                  //         Get.snackbar(
                  //           'error'.tr,
                  //           '${jsonDecode(result.body)['error']['message']}',
                  //         );
                  //       }
                  //     }
                  //   },
                  //   appContext: context,
                  // ),
                  height30(),
                  Text(
                    // 'Don\'t receive the OTP?'.tr,
                    counter == 0
                        ? 'Can’t receive the OTP?'.tr
                        : "${'OTP is valid upto'.tr} $counter ${'seconds'.tr}",
                    textAlign: TextAlign.center,
                    style: ThemeUtils.blackSemiBold.copyWith(
                        fontSize: FontUtils.small,
                        color: counter == 0
                            ? ColorsUtils.black
                            : ColorsUtils.grey),
                  ),
                  height10(),
                  counter != 0
                      ? SizedBox()
                      : InkWell(
                          onTap: () async {
                            showLoadingDialog(context: context);
                            String token = await encryptedSharedPreferences
                                .getString('token');
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
                              if (counter == 0) {
                                counter = 59;
                                initData();
                                otp.clear();
                              }
                              hideLoadingDialog(context: context);
                            } else {
                              hideLoadingDialog(context: context);

                              Get.snackbar(
                                'error'.tr,
                                '${jsonDecode(result.body)['error']['message']}',
                              );
                            }
                          },
                          child: Text(
                            '${'Resend'.tr}',
                            textAlign: TextAlign.center,
                            style: ThemeUtils.blackSemiBold.copyWith(
                                color: counter == 0
                                    ? ColorsUtils.black
                                    : ColorsUtils.border,
                                fontSize: FontUtils.small),
                          ),
                        ),
                  height30()
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorsUtils.accent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  customSmallSemiText(color: ColorsUtils.white, title: 'Send'),
                  Spacer(),
                  customSmallSemiText(
                      color: ColorsUtils.white, title: '${widget.amount} QAR')
                ],
              ),
            ),
          ),
          height40(),
        ],
      ),
    ));
  }

  Future<void> aoicallForVerify(String? code, BuildContext context) async {
    setState(() {
      _code = code!;
      // currentText = code;
    });
    print('_CODE :=>$_code');
    // if (_code.length == 6) {
    //   await apiCall(context);
    // }
    if (_code.length == 6) {
      print('hi');
      showLoadingDialog(context: context);
      String token = await encryptedSharedPreferences.getString('token');
      String id = await encryptedSharedPreferences.getString('id');
      final url = Uri.parse('${Utility.baseUrl}usermetaauths/verify');
      Map<String, String> header = {
        'Authorization': token,
        'Content-Type': 'application/json'
      };
      Map<String, dynamic> body = {"transferotp": otp.text, "userId": id};
      var result =
          await http.post(url, headers: header, body: jsonEncode(body));
      print('otp verify res is ${result.body}');

      if (result.statusCode == 200) {
        hideLoadingDialog(context: context);
        showLoadingDialog(context: context);
        String token = await encryptedSharedPreferences.getString('token');
        final url = Uri.parse('${Utility.baseUrl}transactions');
        Map<String, String> header = {
          'Authorization': token,
          'Content-Type': 'application/json'
        };
        Map<String, dynamic> body = {
          "cellno": mobile,
          "amount": double.parse(widget.amount!),
          "createdby": id,
          "senderId": id,
          "transactionmodeId": 3
        };
        var result =
            await http.post(url, headers: header, body: jsonEncode(body));
        print('body${jsonEncode(body)}');
        print('result ${result.body}');
        if (result.statusCode == 200) {
          Future.delayed(Duration(seconds: 1), () {
            hideLoadingDialog(context: context);
            Get.off(() => TransferPaymentDoneScreen());
          });
        } else {
          hideLoadingDialog(context: context);

          Get.snackbar(
            'error'.tr,
            '${jsonDecode(result.body)['error']['message']}',
          );
        }
      } else {
        hideLoadingDialog(context: context);

        Get.snackbar(
          'error'.tr,
          '${jsonDecode(result.body)['error']['message']}',
        );
      }
    }
  }

  initData() async {
    mobileNo = await encryptedSharedPreferences.getString('mobileNo');
    print("Mobile No == $mobileNo");
    mobile = widget.mobile!;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter--;
      if (counter == 0) {
        print('Cancel timer');
        timer.cancel();
      }
      setState(() {});
    });
    setState(() {});
  }
}
