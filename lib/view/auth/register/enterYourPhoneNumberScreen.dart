import 'dart:convert';
import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/auth/otpscreen.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sms_autofill/sms_autofill.dart';

class EnterYourPhoneScreen extends StatefulWidget {
  String? email;
  bool? isForgotPass;
  String? name;
  String? phone;
  String? partnerId;
  EnterYourPhoneScreen({this.email, this.name, this.isForgotPass, this.phone,this.partnerId});

  @override
  State<EnterYourPhoneScreen> createState() => _EnterYourPhoneScreenState();
}

class _EnterYourPhoneScreenState extends State<EnterYourPhoneScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController mobileNumber = TextEditingController();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // bottomNavigationBar: bottomButton(),
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height40(),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                    ),
                    height30(),
                    customMediumLargeBoldText(
                        title: 'Enter your phone number'.tr),
                    height30(),
                    // IntlPhoneField(
                    //   controller: mobileNumber,
                    //   decoration: InputDecoration(
                    //     hintText: 'Mobile number'.tr,
                    //     counterText: '',
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide(),
                    //     ),
                    //   ),
                    //   disableLengthCheck: false,
                    //   initialCountryCode: Utility.countryCode,
                    //   onChanged: (phone) {
                    //     print(phone.completeNumber);
                    //   },
                    //   onCountryChanged: (country) {
                    //     Utility.countryCode = country.code;
                    //     Utility.countryCodeNumber = '+${country.dialCode}';
                    //     print(
                    //         'Country changed to: ${country.code}Country code ${country.dialCode}');
                    //   },
                    // ),
                    Row(
                      children: [
                        Container(
                          height: Get.width * 0.13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorsUtils.border, width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.book,
                                  color: ColorsUtils.maroon70122E,
                                ),
                                customSmallSemiText(
                                    title: Utility.countryCodeNumber),

                                // SizedBox(
                                //   child: CountryCodePicker(
                                //     showFlagDialog: true,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         print(
                                //             'codeName is ${value.code} code${value} ');
                                //         Utility.countryCode = value.code.toString();
                                //         Utility.countryCodeNumber =
                                //             value.toString();
                                //       });
                                //     },
                                //     searchDecoration: InputDecoration(
                                //         border: OutlineInputBorder(
                                //             borderRadius: BorderRadius.circular(10),
                                //             borderSide: BorderSide(
                                //                 color: ColorsUtils.border,
                                //                 width: 1))),
                                //     initialSelection: Utility.countryCode,
                                //     favorite: [
                                //       Utility.countryCodeNumber,
                                //       Utility.countryCode
                                //     ],
                                //     showCountryOnly: false,
                                //     showFlag: false,
                                //     alignLeft: false,
                                //     textStyle: ThemeUtils.blackSemiBold,
                                //     padding: const EdgeInsets.only(right: 1),
                                //     showOnlyCountryWhenClosed: false,
                                //     showDropDownButton: true,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        width10(),
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
                                    return 'Number should be 8 digit'.tr;
                                  }
                                  if (value.startsWith('1') || value.startsWith('2') || value.startsWith('8') || value.startsWith('9') || value.startsWith('0')) {
                                    return 'Invalid mobile number'.tr;
                                  }
                                  // else if (value.length < 10) {
                                  //   return "Number should be 10 digit".tr;
                                  // }
                                  return null;
                                },
                                inputLength: 8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomButton(),
        ],
      ),
    ));
  }

  Column bottomButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                connectivityViewModel.startMonitoring();

                if (connectivityViewModel.isOnline != null) {
                  if (connectivityViewModel.isOnline!) {
                    showLoadingDialog(context: context);
                    String token =
                        await encryptedSharedPreferences.getString('token');
                    if (_formKey.currentState!.validate()) {
                      // await checkMobileApiCall(token);
                      widget.isForgotPass == true
                          ? forgotPassApiCall(token)
                          : await checkMobileApiCall(token);
                    }
                  } else {
                    Get.snackbar('error', 'please check internet connectivity');
                  }
                } else {
                  Get.snackbar('error', 'please check internet connectivity');
                }
              }
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Next'.tr),
          ),
        )
      ],
    );
  }

  Future<void> checkMobileApiCall(String token) async {
    final url = Uri.parse(
        '${Utility.baseUrl}users/count?where[cellnumber]=${mobileNumber.text}&where[agreement]=true');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var result = await http.get(
      url,
      headers: header,
    );
    if (result.statusCode == 200) {
      if (jsonDecode(result.body)['count'] >= 1) {
        hideLoadingDialog(context: context);

        Get.snackbar('error', 'number already exist');
      } else {
        await addUserApiCall(token);
      }
    }
  }

  Future<void> sendOtpApiCall(String token) async {
    final url = Uri.parse('${Utility.baseUrl}userbusinesses/sendotp');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> body = {'newCellnumber': "${mobileNumber.text}"};
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      Utility.mobNo = mobileNumber.text;
      Utility.userPhone = mobileNumber.text;
      print(result.body);
      Get.snackbar('Success'.tr, 'OTP Send Successfully'.tr);
      hideLoadingDialog(context: context);
      final getAppSignature = await SmsAutoFill().getAppSignature;
      Future.delayed(Duration(seconds: 1), () {
        Get.to(() => OtpScreen(
              isRegistration: true,
              signature: getAppSignature,
            ));
      });
    } else {
      hideLoadingDialog(context: context);
      Utility.userPhone = mobileNumber.text;

      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }

    print(' req is  :${jsonEncode(body)}');
  }

  // void convertIDtoBase64byAESMethod(String? data) {
  //   final plainText = data!;
  //   print(data);
  //   final keys = enc.Key.fromUtf8('XDRvx?#Py^5V@3jC');
  //   final iv = IV.fromLength(16);
  //   final encrypter = Encrypter(AES(keys));
  //   final encrypted = encrypter.encrypt(plainText, iv: iv);
  //   print(encrypted.base64);
  //   // setState(() {
  //   //   text.value = encrypted.base64;
  //   // });
  // }

  addUserApiCall(String token) async {
    String lat =
    await encryptedSharedPreferences.getString('currentLat');
    String long =
    await encryptedSharedPreferences.getString('currentLong');
    final url = Uri.parse('${Utility.baseUrl}users');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    final getAppSignature = await SmsAutoFill().getAppSignature;
    Map<String, dynamic> body = {
      "name": "${widget.name}",
      "cellnumber": "${mobileNumber.text}",
      "email": "${widget.email}",
      "roleId": 1,
      "appSignature": getAppSignature.toString(),
      "latitude": lat,
      "longitude": long
    };
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      Utility.mobNo = mobileNumber.text;
      Utility.userPhone = mobileNumber.text;
      print(result.body);
      // hideLoadingDialog(context: context);
      Utility.userId = jsonDecode(result.body)['id'].toString();
      await encryptedSharedPreferences.setString(
          'token', jsonDecode(result.body)['apitoken']);
      Get.snackbar('Success'.tr, 'OTP Send Successfully'.tr);
      hideLoadingDialog(context: context);
      final getAppSignature = await SmsAutoFill().getAppSignature;
      Future.delayed(Duration(seconds: 1), () {
        Get.to(() => OtpScreen(
              isRegistration: true,
              signature: getAppSignature,
          partnerID: widget.partnerId,
            ));
      });
      // await sendOtpApiCall(token);
    } else {
      hideLoadingDialog(context: context);
      Utility.userPhone = mobileNumber.text;
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }

    print(' req is  :${result.body}');
  }

  Future<void> forgotPassApiCall(String token) async {
    final url = Uri.parse(
        '${Utility.baseUrl}users/findOne?filter[where][cellnumber]=${mobileNumber.text}&[secured]=true');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print('token is $token');

    var result = await http.get(
      url,
      headers: header,
    );
    if (result.statusCode == 200) {
      print(result.body);
      print(result.body);

      final str2 = utf8.decode(base64.decode(jsonDecode(result.body)['data']));

      final text = CryptLib.instance
          .decryptCipherTextWithRandomIV(str2, "XDRvx?#Py^5V@3jC");
      hideLoadingDialog(context: context);
      await encryptedSharedPreferences.setString(
          'posActivatedDate', jsonDecode(text)['posactivated'] ?? "");
      forgotPassSendOtpApiCall();

      ///decrypt data
      ///
      // final plainText = '${jsonDecode(result.body)['data']}';
      // convertIDtoBase64byAESMethod(jsonDecode(result.body)['data']);
    } else {
      hideLoadingDialog(context: context);
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  forgotPassSendOtpApiCall() async {
    final url = Uri.parse('${Utility.baseUrl}users/reset');
    Map<String, String> header = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {
      "cellnumber": "${mobileNumber.text}",
    };
    Utility.mobNo = mobileNumber.text;
    print('url is ' + url.toString());
    print('bodu is$body');
    print('body is${jsonEncode(body)}');
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode >= 200 && result.statusCode <= 299) {
      print('result is ' + result.body);
      print('req is ' + url.toString());
      final getAppSignature = await SmsAutoFill().getAppSignature;
      Get.to(() => OtpScreen(
            isForgotPass: true,
            signature: getAppSignature,
          ));
    } else {
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  initData() {
    if (widget.phone == null) {
      mobileNumber.text = '';
    } else {
      mobileNumber.text = widget.phone! ?? "";
    }
  }
}
