// // import 'package:flutter/material.dart';
// // import 'package:pin_input_text_field/pin_input_text_field.dart';
// // import 'package:sms_autofill/sms_autofill.dart';
// //
// // class HomePage extends StatefulWidget {
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }
// //
// // class _HomePageState extends State<HomePage> {
// //   String _code = "";
// //   String signature = "{{ app signature }}";
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //   }
// //
// //   @override
// //   void dispose() {
// //     SmsAutoFill().unregisterListener();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       theme: ThemeData.light(),
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Plugin example app'),
// //         ),
// //         body: Padding(
// //           padding: const EdgeInsets.all(8.0),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.max,
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: <Widget>[
// //               PhoneFieldHint(),
// //               Spacer(),
// //               PinFieldAutoFill(
// //                 decoration: UnderlineDecoration(
// //                   textStyle: TextStyle(fontSize: 20, color: Colors.black),
// //                   colorBuilder:
// //                       FixedColorBuilder(Colors.black.withOpacity(0.3)),
// //                 ),
// //                 currentCode: _code,
// //                 onCodeSubmitted: (code) {},
// //                 onCodeChanged: (code) {
// //                   if (code!.length == 6) {
// //                     FocusScope.of(context).requestFocus(FocusNode());
// //                   }
// //                 },
// //               ),
// //               Spacer(),
// //               TextFieldPinAutoFill(
// //                 currentCode: _code,
// //               ),
// //               Spacer(),
// //               ElevatedButton(
// //                 child: Text('Listen for sms code'),
// //                 onPressed: () async {
// //                   await SmsAutoFill().listenForCode;
// //                 },
// //               ),
// //               ElevatedButton(
// //                 child: Text('Set code to 123456'),
// //                 onPressed: () async {
// //                   setState(() {
// //                     _code = '123456';
// //                   });
// //                 },
// //               ),
// //               SizedBox(height: 8.0),
// //               Divider(height: 1.0),
// //               SizedBox(height: 4.0),
// //               Text("App Signature : $signature"),
// //               SizedBox(height: 4.0),
// //               ElevatedButton(
// //                 child: Text('Get app signature'),
// //                 onPressed: () async {
// //                   signature = await SmsAutoFill().getAppSignature;
// //                   print(signature);
// //                   setState(() {});
// //                 },
// //               ),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   Navigator.of(context).push(MaterialPageRoute(
// //                       builder: (_) => CodeAutoFillTestPage()));
// //                 },
// //                 child: Text("Test CodeAutoFill mixin"),
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class CodeAutoFillTestPage extends StatefulWidget {
// //   @override
// //   _CodeAutoFillTestPageState createState() => _CodeAutoFillTestPageState();
// // }
// //
// // class _CodeAutoFillTestPageState extends State<CodeAutoFillTestPage>
// //     with CodeAutoFill {
// //   String? appSignature;
// //   String? otpCode;
// //
// //   @override
// //   void codeUpdated() {
// //     setState(() {
// //       otpCode = code!;
// //     });
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     listenForCode();
// //
// //     SmsAutoFill().getAppSignature.then((signature) {
// //       print('SIGN :=>$signature');
// //       setState(() {
// //         appSignature = signature;
// //         // print('print$code');
// //       });
// //     });
// //   }
// //
// //   @override
// //   void dispose() {
// //     super.dispose();
// //     cancel();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final textStyle = TextStyle(fontSize: 18);
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Listening for code"),
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: <Widget>[
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(32, 32, 32, 0),
// //             child: Text(
// //               "This is the current app signature: $appSignature",
// //             ),
// //           ),
// //           const Spacer(),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 32),
// //             child: Builder(
// //               builder: (_) {
// //                 if (otpCode == null) {
// //                   return Text("Listening for code...", style: textStyle);
// //                 }
// //                 return Text("Code Received: $otpCode", style: textStyle);
// //               },
// //             ),
// //           ),
// //           const Spacer(),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // // Copyright (c) 2019-present,  SurfStudio LLC
// // //
// // // Licensed under the Apache License, Version 2.0 (the "License");
// // // you may not use this file except in compliance with the License.
// // // You may obtain a copy of the License at
// // //
// // //     http://www.apache.org/licenses/LICENSE-2.0
// // //
// // // Unless required by applicable law or agreed to in writing, software
// // // distributed under the License is distributed on an "AS IS" BASIS,
// // // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// // // See the License for the specific language governing permissions and
// // // limitations under the License.
// // //
// // // import 'dart:async';
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:otp_autofill/otp_autofill.dart';
// // //
// // // class DemoData extends StatefulWidget {
// // //   const DemoData({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   _DemoDataState createState() => _DemoDataState();
// // // }
// // //
// // // class _DemoDataState extends State<DemoData> {
// // //   final scaffoldKey = GlobalKey();
// // //   late OTPTextEditController controller;
// // //   late OTPInteractor _otpInteractor;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     _otpInteractor = OTPInteractor();
// // //     _otpInteractor
// // //         .getAppSignature()
// // //         //ignore: avoid_print
// // //         .then((value) => print('signature - $value'));
// // //
// // //     controller = OTPTextEditController(
// // //       codeLength: 5,
// // //       //ignore: avoid_print
// // //       onCodeReceive: (code) => print('Your Application receive code - $code'),
// // //       otpInteractor: _otpInteractor,
// // //     )..startListenUserConsent(
// // //         (code) {
// // //           final exp = RegExp(r'(\d{5})');
// // //           return exp.stringMatch(code ?? '') ?? '';
// // //         },
// // //         strategies: [
// // //         // listenForCode();
// // //           SampleStrategy(),
// // //         ],
// // //       );
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       home: Scaffold(
// // //         key: scaffoldKey,
// // //         appBar: AppBar(
// // //           title: const Text('Plugin example app'),
// // //         ),
// // //         body: Center(
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(40.0),
// // //             child: TextField(
// // //               textAlign: TextAlign.center,
// // //               keyboardType: TextInputType.number,
// // //               controller: controller,
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   @override
// // //   Future<void> dispose() async {
// // //     await controller.stopListen();
// // //     super.dispose();
// // //   }
// // // }
// // //
// // // class SampleStrategy extends OTPStrategy {
// // //   @override
// // //   Future<String> listenForCode() {
// // //     return Future.delayed(
// // //       const Duration(seconds: 4),
// // //       () => 'Your code is 54321',
// // //     );
// // //   }
// // //
// // // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sms_autofill/sms_autofill.dart';
//
// class SendOtpScreen extends StatelessWidget {
//   const SendOtpScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SEND OTP'),
//       ),
//       body: Center(
//         child: InkWell(
//           child: Text('OTP Screen'),
//           onTap: () async {
//             final getAppSignature = await SmsAutoFill().getAppSignature;
//             Get.to(OTPScreen(
//               getAppSignature: getAppSignature,
//             ));
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class OTPScreen extends StatefulWidget {
//   final String getAppSignature;
//
//   const OTPScreen({super.key, required this.getAppSignature});
//
//   @override
//   State<OTPScreen> createState() => _OTPScreenState();
// }
//
// class _OTPScreenState extends State<OTPScreen> with CodeAutoFill {
//   String _code = "";
//
//   @override
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   Future<void> init() async {
//     // await SmsAutoFill().unregisterListener();
//     await SmsAutoFill().listenForCode;
//     print('OTP LISTING....');
//   }
//
//   @override
//   void dispose() {
//     SmsAutoFill().unregisterListener();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP SCREEN'),
//       ),
//       body: Column(
//         children: [
//           Text('SIGNATURE : ${widget.getAppSignature}'),
//           PinFieldAutoFill(
//             decoration: BoxLooseDecoration(
//               radius: Radius.circular(10),
//               hintText: '------',
//
//               // textStyle: TextStyle(fontSize: 20, color: Colors.black),
//               strokeColorBuilder:
//                   FixedColorBuilder(Colors.black.withOpacity(0.3)),
//             ),
//             currentCode: _code,
//             codeLength: 6,
//             onCodeSubmitted: (code) {},
//             onCodeChanged: (code) {
//               if (code!.length == 6) {
//                 setState(() {
//                   _code = code;
//                 });
//                 print('_CODE :=>$_code');
//                 FocusScope.of(context).requestFocus(FocusNode());
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void codeUpdated() {
//     print('UPDATE CODE :=>$_code');
//     setState(() {
//       print('CODE');
//     });
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/view/Activity/transfer/transferAccountDetail.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  Codec<String, String> stringToBase64 = utf8.fuse(base64);
  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  initData() async {
    // await controller?.resumeCamera();
    // print('calllll');
    // Future.delayed(Duration(seconds: 1), () {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildQrView(context),
          // if (result != null)
          //   Text(
          //       'Barcode Type: ${describeEnum(result!.format)}   Data: ${CryptLib.instance.decryptCipherTextWithRandomIV(
          //         stringToBase64.decode(result!.code!),
          //         "XDRvx?#Py^5V@3jC",
          //       )}',
          //       style: TextStyle(color: Colors.deepOrange)),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                await controller?.toggleFlash();
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    color: ColorsUtils.lightPink, shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return Icon(
                        snapshot.data == true
                            ? Icons.flash_off
                            : Icons.flash_on,
                        color: ColorsUtils.accent,
                        size: 30,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Positioned(
          //   top: 10,
          //   child: Column(
          //     children: <Widget>[
          //       if (result != null)
          //         Text(
          //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${CryptLib.instance.decryptCipherTextWithRandomIV(
          //           stringToBase64.decode(result!.code!),
          //           "XDRvx?#Py^5V@3jC",
          //         )}')
          //       //        stringToBase64.decode(encoded);
          //
          //       else
          //         const Text('Scan a code'),
          //       // Row(
          //       //   mainAxisAlignment: MainAxisAlignment.center,
          //       //   crossAxisAlignment: CrossAxisAlignment.center,
          //       //   children: <Widget>[
          //       //     // Container(
          //       //     //   margin: const EdgeInsets.all(8),
          //       //     //   child: ElevatedButton(
          //       //     //       onPressed: () async {
          //       //     //         await controller?.toggleFlash();
          //       //     //         setState(() {});
          //       //     //       },
          //       //     //       child: FutureBuilder(
          //       //     //         future: controller?.getFlashStatus(),
          //       //     //         builder: (context, snapshot) {
          //       //     //           return Text('Flash: ${snapshot.data}');
          //       //     //         },
          //       //     //       )),
          //       //     // ),
          //       //     // Container(
          //       //     //   margin: const EdgeInsets.all(8),
          //       //     //   child: ElevatedButton(
          //       //     //       onPressed: () async {
          //       //     //         await controller?.flipCamera();
          //       //     //         setState(() {});
          //       //     //       },
          //       //     //       child: FutureBuilder(
          //       //     //         future: controller?.getCameraInfo(),
          //       //     //         builder: (context, snapshot) {
          //       //     //           if (snapshot.data != null) {
          //       //     //             return Text(
          //       //     //                 'Camera facing ${describeEnum(snapshot.data!)}');
          //       //     //           } else {
          //       //     //             return const Text('loading');
          //       //     //           }
          //       //     //         },
          //       //     //       )),
          //       //     // )
          //       //   ],
          //       // ),
          //       // Row(
          //       //   mainAxisAlignment: MainAxisAlignment.center,
          //       //   crossAxisAlignment: CrossAxisAlignment.center,
          //       //   children: <Widget>[
          //       //     Container(
          //       //       margin: const EdgeInsets.all(8),
          //       //       child: ElevatedButton(
          //       //         onPressed: () async {
          //       //           await controller?.pauseCamera();
          //       //         },
          //       //         child: const Text('pause',
          //       //             style: TextStyle(fontSize: 20)),
          //       //       ),
          //       //     ),
          //       //     // Container(
          //       //     //   margin: const EdgeInsets.all(8),
          //       //     //   child: ElevatedButton(
          //       //     //     onPressed: () async {
          //       //     //       await controller?.resumeCamera();
          //       //     //     },
          //       //     //     child: const Text('resume',
          //       //     //         style: TextStyle(fontSize: 20)),
          //       //     //   ),
          //       //     // )
          //       //   ],
          //       // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  // encryption(String result) async {
  //   // final plainText = 'sadadId:${Get.arguments}';
  //   // print('value ${plainText}');
  //   Codec<String, String> stringToBase64 = utf8.fuse(base64);
  //   String decode = CryptLib.instance.decryptCipherTextWithRandomIV(
  //     result,
  //     "XDRvx?#Py^5V@3jC",
  //   );
  //
  //   print('code is $decode');
  //   // final encryptText = CryptLib.instance.encryptPlainTextWithRandomIV(
  //   //   plainText,
  //   //   "XDRvx?#Py^5V@3jC",
  //   // );
  // }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.resumeCamera();
    controller.scannedDataStream.listen((scanData) async {
      if (scanData != null) {
        setState(() {
          result = scanData;
        });
        String output = CryptLib.instance.decryptCipherTextWithRandomIV(
          stringToBase64.decode(result!.code!),
          "XDRvx?#Py^5V@3jC",
        );

        /// NAVIGATOR
        if (output.contains('sadadId:')) {
          // print('result is${CryptLib.instance.decryptCipherTextWithRandomIV(
          //   stringToBase64.decode(result!.code!),
          //   "XDRvx?#Py^5V@3jC",
          // )}');
          print('final id::::${output.substring(output.indexOf(':') + 1)}');

          showLoadingDialog(context: context);
          String token = await encryptedSharedPreferences.getString('token');
          final url = Uri.parse(
              '${Utility.baseUrl}users/user-info?SadadId=${output.substring(output.indexOf(':') + 1)}');
          Map<String, String> header = {
            'Authorization': token,
            'Content-Type': 'application/json'
          };
          var resultData = await http.get(
            url,
            headers: header,
          );
          print('url:::: ${url}');
          print('user info res is ${resultData.body}');

          if (resultData.statusCode == 200) {
            Future.delayed(Duration(seconds: 1), () {
              hideLoadingDialog(context: context);
              Get.to(() => TransferAccountDetails(
                    name: jsonDecode(resultData.body)['name'] ?? "NA",
                    number: jsonDecode(resultData.body)['cellnumber'] ?? "NA",
                    accountId: jsonDecode(resultData.body)['SadadId'] ?? "NA",
                  ));
              // Get.to(() => InvoiceList());
            });
          } else {
            hideLoadingDialog(context: context);

            Get.snackbar(
              'error'.tr,
              '${jsonDecode(resultData.body)['error']['message']}',
            );
          }
        } else {
          print('result is${CryptLib.instance.decryptCipherTextWithRandomIV(
            stringToBase64.decode(result!.code!),
            "XDRvx?#Py^5V@3jC",
          )}');
          Get.snackbar('error', 'code is invalid for transfer');
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
