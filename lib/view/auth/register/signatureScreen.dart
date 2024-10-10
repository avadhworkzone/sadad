// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/auth/register/pdfOfTermsAndCondition.dart';
import 'package:sadad_merchat_app/view/home.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/uploadImageViewModel.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:http/http.dart' as http;

import 'TermsAndConditionRegister.dart';

class SignatureScreen extends StatefulWidget {
  String? partnerID;

  SignatureScreen({Key? key,this.partnerID})
      : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  UploadImageViewModel uploadImageViewModel = Get.find();
  bool isTermsCondition = false;
  bool isSignature = false;
  ConnectivityViewModel connectivityViewModel = Get.find();
  HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: InkWell(
                  onTap: () {
                    if (isTermsCondition == false) {
                      Get.snackbar(
                          'Error', 'Please Agree on Terms & Conditions');
                    } else {
                      connectivityViewModel.startMonitoring();

                      if (connectivityViewModel.isOnline != null) {
                        if (connectivityViewModel.isOnline!) {
                          _handleSaveButtonPressed();
                        } else {
                          Get.snackbar(
                              'error', 'please check internet connectivity');
                        }
                      } else {
                        Get.snackbar(
                            'error', 'please check internet connectivity');
                      }
                    }
                  },
                  child: buildContainerWithoutImage(
                      color: ColorsUtils.accent, text: 'Finish'.tr)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height40(),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios)),
                height40(),

                customMediumLargeBoldText(title: 'E-Signature'.tr),
                height10(),

                // Padding(
                //   padding: const EdgeInsets.only(top: 50),
                //   child: Row(
                //     children: [
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             isTermsCondition = !isTermsCondition;
                //           });
                //         },
                //         child: Container(
                //           width: 20,
                //           height: 20,
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(5),
                //               border: Border.all(color: ColorsUtils.black)),
                //           child: isTermsCondition
                //               ? Center(
                //                   child: Image.asset(
                //                     Images.check,
                //                     width: 10,
                //                   ),
                //                 )
                //               : SizedBox(),
                //         ),
                //       ),
                //       width20(),
                //       customSmallSemiText(title: 'I agree to the Sadad '),
                //       // width5(),
                //       Text('Terms and conditions',
                //           style: ThemeUtils.blackBold.copyWith(
                //               decoration: TextDecoration.underline,
                //               fontSize: FontUtils.small,
                //               color: ColorsUtils.accent)),
                //     ],
                //   ),
                // ),
                // height100(),

                customSmallMedSemiText(
                  title: 'Please, Provide your E-Signature in below box'.tr,
                ),

                height30(),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15)),
                  child: Stack(
                    children: [
                      SfSignaturePad(
                          key: signatureGlobalKey,
                          backgroundColor: Colors.white,
                          strokeColor: Colors.black,
                          onDraw: (offset, time) {
                            print(offset);
                            if (offset == 0) {
                              isSignature = false;
                              print(offset == 0);
                              print('sing $isSignature');
                            } else {
                              isSignature = true;
                              print(offset == 0);
                              print('sing $isSignature');
                            }
                          },
                          minimumStrokeWidth: 1.0,
                          maximumStrokeWidth: 4.0),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            isSignature = false;
                            print('sing $isSignature');

                            _handleClearButtonPressed();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.close,
                                size: 30,
                              ),
                              customMediumBoldText(title: 'Clear'.tr)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                height30(),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isTermsCondition = !isTermsCondition;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: ColorsUtils.black)),
                        child: isTermsCondition
                            ? Center(
                                child: Image.asset(
                                  Images.check,
                                  width: 10,
                                ),
                              )
                            : SizedBox(),
                      ),
                    ),
                    width20(),
                    customVerySmallSemiText(title: 'I agree to the Sadad'.tr),
                    // width5(),
                    InkWell(
                      onTap: () {
                        Get.to(() => TermsAndConditionRegister());
                      },
                      child: Text(' ${'Terms and conditions'.tr}',
                          style: ThemeUtils.blackBold.copyWith(
                              decoration: TextDecoration.underline,
                              fontSize: FontUtils.verySmall,
                              color: ColorsUtils.accent)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    if (isTermsCondition == true) {
      if (isSignature == true) {
        await convertToDataToFile();
      } else {
        Get.snackbar('error', 'Please do Signature');
      }
    } else {
      Get.snackbar('error', 'Please read Terms and conditions');
    }

    // await Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return Scaffold(
    //         body: Center(
    //           child: Container(
    //             height: 100,
    //             decoration:
    //                 BoxDecoration(border: Border.all(color: Colors.red)),
    //             // color: Colors.grey[300],
    //             // height: 30,
    //             child: Image.file(file),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

  Future<File> convertToDataToFile() async {
    showLoadingDialog(context: context);
    final data =
        await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ImageByteFormat.png);

    Uint8List imageInUnit8List =
        bytes!.buffer.asUint8List(); // store unit8List image here ;

    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/image.png').create();
    file.writeAsBytesSync(imageInUnit8List);
    print('$file');
    try {
      await signatureApiCall(file);
    } catch (e) {
      hideLoadingDialog(context: context);
      print('error is here$e');
      Get.snackbar('error', 'Session expire please login again');
    }
    return file;
  }

  Future<void> signatureApiCall(File file) async {
    final resposne = await ApiService()
        .uploadImage(file: file, url: 'containers/api-signature/upload');
    // var data = jsonEncode(resposne);

    print('res is ${(resposne)}');
    print(
        'res=>${jsonDecode(resposne.toString())['result']['files']['file'][0]['name']}');
    // print('res=>${resposne['result']['files']['file'][0]['name']}');
    hideLoadingDialog(context: context);

    userDataUpdateApiCall(
        jsonDecode(resposne.toString())['result']['files']['file'][0]['name']);
  }

  userDataUpdateApiCall(String img) async {
    String token = await encryptedSharedPreferences.getString('token');

    final url = Uri.parse('${Utility.baseUrl}users/${Utility.userId}');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    Map<String, dynamic> body = {"signature": img, "agreement": true, "sadadPartnerId":widget.partnerID};
    var result = await http.patch(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      await encryptedSharedPreferences.setString(
          'mobileNo.', jsonDecode(result.body)['cellnumber']);

      await encryptedSharedPreferences.setString(
          'id', '${jsonDecode(result.body)['id']}');
      await encryptedSharedPreferences.setString(
          'name', jsonDecode(result.body)['name']);
      Utility.name = jsonDecode(result.body)['name'];
      await encryptedSharedPreferences.setString(
          'email', jsonDecode(result.body)['email']);
      //await encryptedSharedPreferences.setString('userbusinessId', "${businessInfoResponseModel.id}");
      Utility.sadadIdMore = '${jsonDecode(result.body)['SadadId']}';
      print('=====>>>>>>${Utility.sadadIdMore}');
      Utility.countryCodeNumber = '+974';
      Utility.countryCode = 'QA';
      // Utility.mobNo = '';

      Get.snackbar('success', 'Signature has been uploaded successfully');
      print(' req is  :${result.body} ');

      userMetaPreferencesApiCall();
      // Future.delayed(Duration(seconds: 1), () {
      //   Get.offAll(() => HomeScreen());
      // });
    } else {
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
      // Get.snackbar('error', 'session expire login again');
    }
  }

  Future<void> userMetaPreferencesApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}usermetapreferences');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };

    Map<String, dynamic> body = {
      "receivedpaymentemail": false,
      "receivedordersms": false,
      "lastloginip": '',
      "receivedpaymentpush": true,
      "orderemail": false,
      "transfersms": false,
      "receivedorderspush": true,
      "receivedorderemail": false,
      "receivedrequestforpaymentpush": true,
      "transferpush": true,
      "userId": '${Utility.userId}',
      "lastlogindatetime": '${DateTime.now()}',
      "receivedpaymentsms": false,
      "createdby": 0,
      "transferemail": false,
      "ordersms": false,
      "modifiedby": 0,
      "receivedrequestforpaymentemail": false,
      "orderpush": true,
      "receivedrequestforpaymentsms": false
    };

    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      print('user meta result.${result.body}');

      loginApiCall();

      // Get.snackbar('success'.tr, 'Otp verified successfully'.tr);
      // print('otp reg res is ${result.body}');
      // // await encryptedSharedPreferences.setString(
      // //     'token', jsonDecode(result.body)['accessToken']);
      // Future.delayed(Duration(seconds: 1), () {
      //   hideLoadingDialog(context: context);
      //   Utility.countryCodeNumber = '+974';
      //   Utility.countryCode = 'QA';
      //   Utility.mobNo = '';
      //   Get.off(() => SetYourPasswordScreen());
      //   // Get.to(() => InvoiceList());
      // });
    } else {
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  Future<void> loginApiCall() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}users/login');
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> body = {
      "password": '${Utility.password}',
      "cellnumber": '${Utility.userPhone}',
      "signinForSignup": true
    };
    var result = await http.post(url, headers: header, body: jsonEncode(body));
    if (result.statusCode == 200) {
      await encryptedSharedPreferences.setString('bioPass', Utility.password);
      await encryptedSharedPreferences.setString(
          'bioNumber', Utility.userPhone);
      print('login result.${result.body}');
      await encryptedSharedPreferences.setString(
          'token', jsonDecode(result.body)['id'].toString());
      await encryptedSharedPreferences.setString(
          'id', jsonDecode(result.body)['userId'].toString());
      Utility.userId = '${jsonDecode(result.body)['userId']}';

      await encryptedSharedPreferences.setString('fromReg', 'true');
      //
      Future.delayed(Duration(seconds: 1), () {
        homeController.initBottomIndex = 0;

        Get.offAll(() => HomeScreen());
      });
      // Get.snackbar('success'.tr, 'Otp verified successfully'.tr);
      // print('otp reg res is ${result.body}');
      // // await encryptedSharedPreferences.setString(
      // //     'token', jsonDecode(result.body)['accessToken']);
      // Future.delayed(Duration(seconds: 1), () {
      //   hideLoadingDialog(context: context);
      //   Utility.countryCodeNumber = '+974';
      //   Utility.countryCode = 'QA';
      //   Utility.mobNo = '';
      //   Get.off(() => SetYourPasswordScreen());
      //   // Get.to(() => InvoiceList());
      // });
    } else {
      hideLoadingDialog(context: context);
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
  }

  ///
  // final SignatureController _controller = SignatureController(
  //   penStrokeWidth: 1,
  //   penColor: Colors.red,
  //   exportBackgroundColor: Colors.blue,
  //   exportPenColor: Colors.black,
  //   onDrawStart: () => print('onDrawStart called!'),
  //   onDrawEnd: () => print('onDrawEnd called!'),
  // );
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _controller.addListener(() => print('Value changed'));
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Builder(
  //       builder: (BuildContext context) => Scaffold(
  //           body: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             margin: EdgeInsets.all(20),
  //             decoration:
  //                 BoxDecoration(border: Border.all(color: Colors.black)),
  //             child: Signature(
  //               controller: _controller,
  //               height: 300,
  //               width: Get.width,
  //               backgroundColor: Colors.transparent,
  //             ),
  //           ),
  //           //OK AND CLEAR BUTTONS
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             mainAxisSize: MainAxisSize.max,
  //             children: <Widget>[
  //               //SHOW EXPORTED IMAGE IN NEW ROUTE
  //               IconButton(
  //                 icon: const Icon(Icons.check),
  //                 color: Colors.blue,
  //                 onPressed: () async {
  //                   if (_controller.isNotEmpty) {
  //                     final Uint8List? data = await _controller.toPngBytes();
  //                     if (data != null) {
  //                       await Navigator.of(context).push(
  //                         MaterialPageRoute<void>(
  //                           builder: (BuildContext context) {
  //                             return Scaffold(
  //                               appBar: AppBar(),
  //                               body: Center(
  //                                 child: Container(
  //                                   color: Colors.grey[300],
  //                                   child: Image.memory(data),
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       );
  //                     }
  //                   }
  //                 },
  //               ),
  //               // IconButton(
  //               //   icon: const Icon(Icons.undo),
  //               //   color: Colors.blue,
  //               //   onPressed: () {
  //               //     setState(() => _controller.undo());
  //               //   },
  //               // ),
  //               // IconButton(
  //               //   icon: const Icon(Icons.redo),
  //               //   color: Colors.blue,
  //               //   onPressed: () {
  //               //     setState(() => _controller.redo());
  //               //   },
  //               // ),
  //               //CLEAR CANVAS
  //               IconButton(
  //                 icon: const Icon(Icons.clear),
  //                 color: Colors.blue,
  //                 onPressed: () {
  //                   setState(() => _controller.clear());
  //                 },
  //               ),
  //             ],
  //           ),
  //         ],
  //       )),
  //     ),
  //   );
  // }
}
