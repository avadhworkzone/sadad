import 'dart:convert';
import 'dart:developer';
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

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  String? userId;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String output = '';
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
    userId = await encryptedSharedPreferences.getString('id');
    setState(() {});
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
        this.controller!.pauseCamera();
        try {
          output = CryptLib.instance.decryptCipherTextWithRandomIV(
            stringToBase64.decode(result!.code!),
            "XDRvx?#Py^5V@3jC",
          );
        } catch (e) {
          print('=======>>>$e');
          // TODO
        }

        /// NAVIGATOR
        await apiCall();
      }
    });
  }

  Future<void> apiCall() async {
    if (output.contains('sadadId:')) {
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
          if (jsonDecode(resultData.body)['SadadId'].toString() == userId) {
            Get.snackbar('error', 'you can not create invoice by your self');
          } else {
            Get.off(() => TransferAccountDetails(
                  name: jsonDecode(resultData.body)['name'] ?? "NA",
                  number: jsonDecode(resultData.body)['cellnumber'] ?? "NA",
                  accountId: jsonDecode(resultData.body)['SadadId'] ?? "NA",
                ));
          }

          // Get.to(() => InvoiceList());
        });
      } else {
        hideLoadingDialog(context: context);
        controller?.resumeCamera();

        Get.snackbar(
          'error'.tr,
          '${jsonDecode(resultData.body)['error']['message']}',
          backgroundColor: ColorsUtils.white,
        );
      }
    } else {
      // Get.snackbar(
      //   'error',
      //   'code is invalid for transfer',
      // );
      Get.snackbar(
        'error'.tr,
        'code is invalid for transfer',
        backgroundColor: ColorsUtils.white,
      );
      // print('result is${CryptLib.instance.decryptCipherTextWithRandomIV(
      //   stringToBase64.decode(result!.code!),
      //   "XDRvx?#Py^5V@3jC",
      // )}');
      controller?.resumeCamera();
    }
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
