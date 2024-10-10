import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/Auth/sendOtpRequestModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/home.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../model/apimodels/requestmodel/Auth/verifyOtpRequestModel.dart';
import '../../model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import '../../model/apis/api_response.dart';
import '../../viewModel/Auth/loginViewModel.dart';
import 'package:http/http.dart' as http;

class DocUpdateOtpScreen extends StatefulWidget {
  final Map<String, Map<String, dynamic>> docData;
  bool? isDelete;
  bool? isEdit;
  bool? isOld;

  DocUpdateOtpScreen({
    Key? key,
    this.isDelete,
    this.isEdit,
    this.isOld,
    required this.docData,
  }) : super(key: key);

  @override
  State<DocUpdateOtpScreen> createState() => _MoreOtpScreenState();
}

class _MoreOtpScreenState extends State<DocUpdateOtpScreen> {
  String currentText = "";
  int counter = 59;
  Timer? timer;
  String _code = "";

  VerifyOtpRequestModel verifyOtpReq = VerifyOtpRequestModel();
  SendOtpRequestModel sendOtpReq = SendOtpRequestModel();
  LoginViewModel loginViewModel = Get.find();
  final cnt = Get.find<BusinessInfoViewModel>();
  String id = "";
  BankAccountResponseModel bankAccountResponseModel =
      BankAccountResponseModel();

  TextEditingController otp = TextEditingController();
  ConnectivityViewModel connectivityViewModel = Get.find();

  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    deviceTokenNativeiOSAndoid();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
          appBar: commonAppBar(),
          // bottomNavigationBar: bottomButton(context),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  height30(),
                  Text(
                    'Enter the OTP'.tr,
                    style: ThemeUtils.blackBold
                        .copyWith(fontSize: FontUtils.medLarge),
                  ),
                  height15(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${'We have sent the OTP to the number'.tr} \n${Utility.countryCodeNumber} ${cnt.businessInfoModel.value.user?.cellnumber ?? ""}',
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
                      textInputAction: TextInputAction.go,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[0-9]")),
                      ],
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
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
                        setState(() {
                          _code = code!;
                          // currentText = code;
                        });
                        print('_CODE :=>$_code');
                        if (_code.length == 6) {
                          cnt.businessDataModel.value.otp = otp.text;
                          if (otp.text.isNotEmpty) {
                            if (widget.isDelete == true) {
                              deleteDocApiCall();

                              return;
                            } else if (widget.isEdit == true) {
                              editDocApiCall();
                              return;
                            }
                            if(widget.isOld == true) {
                              await addDocApiCallOld();
                            } else {
                              await addDocApiCall();
                            }
                          }
                          // cnt.updateBusinessDetails(
                          //   context: context,
                          //   type: widget.type,
                          //   businessDataModel: widget.businessDataModel,
                          //   businessMedia: widget.businessMedia,
                          // );
                        }
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
                  //     setState(() {
                  //       currentText = value;
                  //     });
                  //     if (otp.text.length == 6) {
                  //       cnt.businessDataModel.value.otp = otp.text;
                  //       if (otp.text.isNotEmpty) {
                  //         cnt.updateBusinessDetails(
                  //           context: context,
                  //           type: widget.type,
                  //           businessDataModel: widget.businessDataModel,
                  //           businessMedia: widget.businessMedia,
                  //         );
                  //       }
                  //     }
                  //   },
                  //   appContext: context,
                  // ),
                  height30(),
                  Text(
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
                            if (counter == 0) {
                              counter = 59;
                              otp.clear();

                              sendOtpReq.newCellnumber = Utility.userPhone;
                              print("newcell number ${Utility.userPhone}");
                              String userBusinessId =
                              await encryptedSharedPreferences.getString('userbusinessId');
                              print('userBusinessId===$userBusinessId');

                              //await loginViewModel.sendOtp(sendOtpReq, context: context);
                              timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                                counter--;
                                if (counter == 0) {
                                  print('Cancel timer');
                                  timer.cancel();
                                }
                                setState(() {});
                              });
                              await loginViewModel.sendOtp(sendOtpReq, context: context);
                              //await loginViewModel.resendOtp();
                              if (loginViewModel.sendOtpApiResponse.status ==
                                  Status.COMPLETE) {
                                Get.snackbar(
                                    'success'.tr, 'OTP Send SuccessFully'.tr);
                              } else {
                                Get.snackbar('error'.tr, 'Something Wrong'.tr);
                              }
                            }
                          },
                          child: Text(
                            '${'Resend'.tr}',
                            textAlign: TextAlign.center,
                            style: ThemeUtils.blackSemiBold.copyWith(
                              color: counter == 0
                                  ? ColorsUtils.black
                                  : ColorsUtils.border,
                              fontSize: FontUtils.small,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                setState(() {});
                deviceTokenNativeiOSAndoid();
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
              setState(() {});
              deviceTokenNativeiOSAndoid();
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

  Future<void> editDocApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    // String id = await encryptedSharedPreferences.getString('id');
    String userBusinessId =
        await encryptedSharedPreferences.getString('userbusinessId');
    print('id=====${userBusinessId}');
    final url =
        Uri.parse(Utility.baseUrl + 'userbusinesses/' + "$userBusinessId");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    // String userBusinessId =
    // await encryptedSharedPreferences.getString('userbusinessId');
    // List list = [];
    //{
    //            “id”: 688                                                 // to update existing doc
    //             "userbusinessId": 301,
    //             "name":"1658684848541_SadadBusiness_type1.pdf",
    //             "businessmediatypeId": 1
    //          }
    var body = {
      "businessmedia": [
        {
          "id": widget.docData.values.first['id'],
          "userbusinessId": int.parse(userBusinessId),
          "name": widget.docData.values.first['url'],
          "businessmediatypeId":
              int.parse(widget.docData.values.first['typeId']),
        }
      ],
      "otp": otp.text,
      "userbusinessstatusId": 4
    };
    print("body =======>>>  ${jsonEncode(body)}");

    var result =
        await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data ========>>>>>>$data");

      Get.offAll(HomeScreen(
        pageRoutValue: 4,
      ));
      // if (type == "Document") {
      //   Get.back(result: true);
      // }
      Get.showSnackbar(GetSnackBar(
        message: 'Update Successfully',
        duration: Duration(seconds: 1),
      ));
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }

  Future<void> addDocApiCallOld() async {
    String token = await encryptedSharedPreferences.getString('token');
    // String id = await encryptedSharedPreferences.getString('id');
    String userBusinessId =
    await encryptedSharedPreferences.getString('userbusinessId');
    final url =
    Uri.parse(Utility.baseUrl + 'userbusinesses/' + "$userBusinessId");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    // String userBusinessId =
    // await encryptedSharedPreferences.getString('userbusinessId');
    List list = [];
    widget.docData.keys.forEach((element) {
      if (widget.docData[element]!.containsKey("deleteId")) {
        list.add({
          "id": widget.docData[element]!['deleteId'],
          "deletedAt": widget.docData[element]!['date'],
        });
      } else if (widget.docData[element]!.containsKey("id")) {
        list.add({
          "id": widget.docData[element]!['id'],
          "userbusinessId": userBusinessId,
          "name": widget.docData[element]!['url'],
          "businessmediatypeId": int.parse(element),
          "doc_expiry": widget.docData[element]!['date']
        });
      } else {
        list.add({
          "userbusinessId": userBusinessId,
          "name": widget.docData[element]!['url'],
          "businessmediatypeId": int.parse(element),
          "doc_expiry": widget.docData[element]!['date']
        });
      }
    });
    var body = {
      "businessmedia": list,
      "otp": otp.text,
      "userbusinessstatusId": 4
    };
    print("body =======>>>  ${jsonEncode(body)}");

    var result =
    await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data ========>>>>>>$data");

      Get.off(HomeScreen());
      // if (type == "Document") {
      //   Get.back(result: true);
      // }
      Get.showSnackbar(GetSnackBar(
        message: 'Update Successfully',
        duration: Duration(seconds: 1),
      ));
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }

  Future<void> addDocApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    // String id = await encryptedSharedPreferences.getString('id');
    String userBusinessId =
        await encryptedSharedPreferences.getString('userbusinessId');
    final url =
        Uri.parse(Utility.baseUrl + 'userbusinesses/' + "$userBusinessId");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    // String userBusinessId =
    // await encryptedSharedPreferences.getString('userbusinessId');
    List list = [];
    widget.docData.keys.forEach((element) {
      if (widget.docData[element]!.containsKey("deleteId")) {
        for(int i=0;i<widget.docData[element]!['deleteId'].length;i++) {
          list.add({
            "id": widget.docData[element]!['deleteId'][i],
            "deletedAt": widget.docData[element]!['date'],
            "businessmediastatusId": int.parse(widget.docData[element]!['mediaStatus']),
            "unique_id": widget.docData[element]!['unique_id'],
            "userbusinessId": userBusinessId,
          });
        }
      }
      else if (widget.docData[element]!.containsKey("id")) {
        for(int i=0;i<widget.docData[element]!['url'].length;i++){
          print(widget.docData[element]!['url'][i]);

          // if (widget.docData[element]!['id'].length-1 < i) {
          if (widget.docData[element]!['status'][i] == 'delete') {
            list.add({
              "id": widget.docData[element]!['id'][i],
              "deletedAt": DateTime.now().toString(),
              "businessmediastatusId" : int.parse(widget.docData[element]!['mediaStatus']),
              "unique_id": widget.docData[element]!['unique_id'],
              "userbusinessId": userBusinessId,
            });
          } else {
            String tempElement = element;
            if(int.parse(element) > 9) {
              tempElement = "4";
            }
            if(tempElement == '6') {
              list.add({
                "userbusinessId": userBusinessId,
                "name": widget.docData[element]!['url'][i],
                "metadata": widget.docData[element]!['metadata'][i],
                "unique_id": widget.docData[element]!['unique_id'],
                "businessmediastatusId": 4,
              });
            } else {
              list.add({
                "userbusinessId": userBusinessId,
                "name": widget.docData[element]!['url'][i],
                "businessmediatypeId": int.parse(tempElement),
                "doc_expiry": widget.docData[element]!['date'],
                "metadata": widget.docData[element]!['metadata'][i],
                "unique_id": widget.docData[element]!['unique_id'],
                "businessmediastatusId": int.parse(widget.docData[element]!['mediaStatus']),
              });
            }
          }
      //     {
      //       "buildingnumber": "158",
      // "businessmedia": [
      // {
      // "metadata": "{\"confidence_data\":{\"detectionConfidence\":0.8590312600135803,\"calculatedCondidence\":85.90312600135803},\"full_data\":{\"Serial No\":\"4353B11213342486\",\"ID. No\":\"28563402509\",\"ügiell\":\"14306 Elü - 71 ääbis\",\"Date of expiry\":\"18/07/2032\",\"null\":\"D.O.B 18/11/1985\",\":Judinsi) păd)\":\"ääbis ügiell\",\"Name\":\"ABDULLA MOHAMED A A ALYAFEI\"},\"scanned_text\":[\"دولة قطر\",\"بطاقة إثبات شخصية\",\"Qatar\",\"State\",\"of\",\"الرقم:\",\"تاريخ الميلاد:18/11/1985 D.O.B\",\"الجنسية:\",\"قطری / QATAR\",\"الصلاحية: 18/07/2032\",\"ID. No: 28563402509\",\"State of Qatar\",\"ID. Card\",\"الإسم: عبدالله محمد عبدالله اليزيدي اليافعي\",\"Name: ABDULLA MOHAMED A A ALYAFEI\",\"العنوان: منطقة 71 - شارع 306 - مبنی 14\",\"الرقم المسلسل:\",\"4353B11213342486\",\"توقيع حامل البطاقة\",\"Holder's signature\",\"Nationality:\",\"Date of expiry:\",\"Serial No:\",\"مدير إدارة الجنسية و وثائق السفر\",\"Authority's signature\",\"\"],\"main_data\":{\"ID. No\":\"28563402509\",\"Date of expiry\":\"18/07/2032\",\"Name\":\"ABDULLA MOHAMED A A ALYAFEI\"},\"identity_data\":{\"fraud_signals_is_identity_document\":\"PASS\",\"fraud_signals_suspicious_words\":\"PASS\",\"fraud_signals_image_manipulation\":\"POSSIBLE_IMAGE_MANIPULATION\",\"fraud_signals_online_duplicate\":\"PASS\"}}",
      // "name": "1672737327795_abd_qatar_id.jpg",
      // "userbusinessId": 349
      // }
      // ],
      // "businessname": "hardik Vyas",
      // "merchantregisterationnumber": "151548698",
      // "modified": 1672737615634,
      // "modifiedby": 3281,
      // "otp": "995802",
      // "streetnumber": "12",
      // "userbusinessstatusId": 6,
      // "zonenumber": "12"
      // }
          // } else {
          //   list.add({
          //     "id": widget.docData[element]!['id'][i],
          //     "userbusinessId": userBusinessId,
          //     "name": widget.docData[element]!['url'],
          //     "businessmediatypeId": int.parse(element),
          //     "doc_expiry": widget.docData[element]!['date'],
          //     "metadata": jsonEncode(widget.docData[element]!['metadata'][i]),
          //     "unique_id": widget.docData[element]!['unique_id'],
          //   });
          // }
        }
      } else {
        for(int i=0;i<widget.docData[element]!['url'].length;i++){
          print(widget.docData[element]!['url'][i]);
        list.add({
          "userbusinessId": userBusinessId,
          "name": widget.docData[element]!['url'][i],
          "businessmediatypeId": int.parse(element),
          "doc_expiry":widget.docData[element]!['date'],
          "metadata":widget.docData[element]!['metadata'][i],
          "unique_id":widget.docData[element]!['unique_id'],
          "businessmediastatusId" : int.parse(widget.docData[element]!['mediaStatus']),
        });
        }
      }
    });
    int userbusinessstatusId = 4;
    list.forEach((element) {
      if(element['businessmediastatusId'] == 6) {
        userbusinessstatusId = 6;
      }
    });
      var body = {
      "businessmedia": list,
      "otp": otp.text,
      "userbusinessstatusId": userbusinessstatusId
    };
    print("body =======>>>  ${jsonEncode(body)}");

    var result = await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data ========>>>>>>$data");

      Get.off(HomeScreen());
      // if (type == "Document") {
      //   Get.back(result: true);
      // }
      Get.showSnackbar(GetSnackBar(
        message: 'Update Successfully',
        duration: Duration(seconds: 1),
      ));
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }

  Future<void> deleteDocApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    // String id = await encryptedSharedPreferences.getString('id');
    String userBusinessId =
        await encryptedSharedPreferences.getString('userbusinessId');
    final url =
        Uri.parse(Utility.baseUrl + 'userbusinesses/' + "$userBusinessId");
    log("URl i :- $url");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    // String userBusinessId =
    // await encryptedSharedPreferences.getString('userbusinessId');
    var body = {
      "businessmedia": [
        {
          "id": widget.docData.keys.toList().first,
          "deletedAt": widget.docData.values.first['date']
        }
      ],
      "otp": otp.text,
      "userbusinessstatusId": 4
    };
    print("body =======>>>  ${jsonEncode(body)}");

    var result =
        await http.patch(url, headers: header, body: json.encode(body));
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      var data = json.decode(result.body);
      print("data ========>>>>>>$data");

      Get.off(HomeScreen());
      // if (type == "Document") {
      //   Get.back(result: true);
      // }
      Get.showSnackbar(GetSnackBar(
        message: 'Update Successfully',
        duration: Duration(seconds: 1),
      ));
    } else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }

  // Widget bottomButton(BuildContext context) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
  //         child: InkWell(
  //             onTap: () async {
  //               log(Utility.userPhone);
  //               cnt.businessDataModel.value.otp = otp.text;
  //               if (otp.text.isNotEmpty) {
  //                 cnt.updateBusinessDetails(
  //                   context: context,
  //                   type: widget.type,
  //                   businessDataModel: widget.businessDataModel,
  //                   businessMedia: widget.businessMedia,
  //                 );
  //               }
  //             },
  //             child: buildContainerWithoutImage(
  //                 color: ColorsUtils.accent, text: 'Next'.tr)),
  //       ),
  //     ],
  //   );
  // }

  initData() async {
    sendOtpReq.newCellnumber = Utility.userPhone;
    print("newcell number ${Utility.userPhone}");
    String userBusinessId =
        await encryptedSharedPreferences.getString('userbusinessId');
    print('userBusinessId===$userBusinessId');

    await loginViewModel.sendOtp(sendOtpReq, context: context);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter--;
      if (counter == 0) {
        print('Cancel timer');
        timer.cancel();
      }
      setState(() {});
    });
  }

  Future<String?> deviceTokenNativeiOSAndoid() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      log('id is ${iosDeviceInfo.identifierForVendor}');
      Utility.deviceId = iosDeviceInfo.identifierForVendor!;
      return iosDeviceInfo.identifierForVendor;
      // unique ID on iOS
    } else if (Platform.isAndroid) {
      // var androidDeviceInfo = await deviceInfo.androidInfo;
      // Utility.deviceId = androidDeviceInfo.id!;
      // return androidDeviceInfo.id; // unique ID on Android
      const _androidIdPlugin = AndroidId();
      Utility.deviceId = await _androidIdPlugin.getId() ?? "";
      return _androidIdPlugin.getId();
    }
  }
}
