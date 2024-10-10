import 'dart:convert';

import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:encrypt/encrypt.dart' as keyEnc;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
//import 'package:open_file_safe/open_file_safe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/myQrCode/export_pdf.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui' as dart_ui;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:open_file/open_file.dart';

class MyQrCode extends StatefulWidget {
  @override
  State<MyQrCode> createState() => _MyQrCodeState();

  MyQrCode();
}

class _MyQrCodeState extends State<MyQrCode> {
  @override
  void initState() {
    // convertIDtoBase64byAESMethod();
    encryption();
    super.initState();
  }

  RxString text = "".obs;

  // void convertIDtoBase64byAESMethod() {
  //   final plainText = 'sadadId:${Get.arguments}';
  //   print('value ${plainText}');
  //   final key = keyEnc.Key.fromUtf8('XDRvx?#Py^5V@3jC');
  //   final iv = IV.fromLength(16);
  //   final encrypter = Encrypter(AES(key));
  //
  //   if (plainText != "") {
  //     print('PlainText:$plainText');
  //     final encrypted = encrypter.encrypt(plainText, iv: iv);
  //     print(encrypted.base64);
  //     setState(() {
  //       text.value = encrypted.base64;
  //     });
  //   } else {}
  // }

  encryption() async {
    print('id::::${Get.arguments}');
    final plainText =
        'sadadId:${(Get.arguments == null || Get.arguments == '') ? Utility.sadadIdMore : Get.arguments}';
    print('value ${plainText}');
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(
      CryptLib.instance.encryptPlainTextWithRandomIV(
        plainText,
        "XDRvx?#Py^5V@3jC",
      ),
    );
    // final encryptText = CryptLib.instance.encryptPlainTextWithRandomIV(
    //   plainText,
    //   "XDRvx?#Py^5V@3jC",
    // );
    setState(() {
      text.value = encoded;
      print(encoded);
    });
  }

  Future<void> _renderPdf() async {
    final PdfDocument document = PdfDocument();
    final PdfBitmap bitmap = PdfBitmap(await _readImageData());

    document.pageSettings.margins.all = 0;
    document.pageSettings.size =
        Size(bitmap.width.toDouble(), bitmap.height.toDouble());

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    PermissionStatus status = await Permission.storage.request();
    AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;

    if (status == PermissionStatus.granted || androidDeviceInfo.version.sdkInt >= 33) {
      page.graphics.drawImage(
          bitmap, Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));
      final List<int> bytes = await document.save();
      document.dispose();
      String? path = await getDownloadPath();
      File file = File('$path/myqrcode.pdf');
      await file.writeAsBytes(bytes, flush: true);
      OpenFilex.open('$path/myqrcode.pdf');
      Toast().showToast(
          context: context, message: "PDF file export successfully.");
    } else if (status == PermissionStatus.denied) {
      Toast().showToast(context: context, message: "Permission Denied");
    } else if (status == PermissionStatus.permanentlyDenied) {
      Toast().showToast(
          context: context,
          message: "Open app settings and allow permission manually.");
    }
  }

  /// Method to read the rendered barcode image and return the image data for processing.
  Future<List<int>> _readImageData() async {
    final dart_ui.Image data =
        await barcodeKey.currentState!.convertToImage(pixelRatio: 3.0);
    final ByteData? bytes =
        await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  void showExportDialog() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (_) {
          return Container(
            height: 133,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  height12(),
                  Container(
                    height: 4,
                    width: 65,
                    decoration: BoxDecoration(
                        color: ColorsUtils.border,
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  height16(),
                  InkWell(
                    onTap: () {
                      Get.back();
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          builder: (_) {
                            return Container(
                              height: 160,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    height12(),
                                    Center(
                                      child: Container(
                                        height: 4,
                                        width: 65,
                                        decoration: BoxDecoration(
                                            color: ColorsUtils.border,
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                      ),
                                    ),
                                    height32(),
                                    Text('Export'.tr,
                                        style: ThemeUtils.blackBold.copyWith(
                                            fontSize: FontUtils.medLarge)),
                                    height16(),
                                    InkWell(
                                      onTap: () async {
                                        Get.back();
                                        await _renderPdf();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        child: Row(
                                          children: [
                                            SvgIcon(Images.pdfSvg),
                                            width20(),
                                            Text(
                                              'PDF'.tr,
                                              style: ThemeUtils.blackSemiBold
                                                  .copyWith(
                                                      fontSize:
                                                          FontUtils.small),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          SvgIcon(
                            Images.exportSvg,
                          ),
                          width20(),
                          Text(
                            'Export'.tr,
                            style: ThemeUtils.blackSemiBold
                                .copyWith(fontSize: FontUtils.small),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        menu: true,
        onTap: () => showExportDialog(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 52),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                height24(),
                Text('My QRcode'.tr,
                    style: ThemeUtils.blackBold
                        .copyWith(fontSize: FontUtils.medLarge)),
                height12(),
                Text('Scan QRCODE or copy the below code'.tr,
                    style: ThemeUtils.blackRegular
                        .copyWith(fontSize: FontUtils.small)),
                height48(),
                Text('Sadad ID'.tr,
                    style: ThemeUtils.blackSemiBold
                        .copyWith(fontSize: FontUtils.mediumSmall)),
                height12(),
                Text(
                  Get.arguments,
                  style: ThemeUtils.blackRegular
                      .copyWith(fontSize: FontUtils.small),
                ),
                height48(),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Barcode(
                    key: barcodeKey,
                    codeValue: text.value,
                  ),
                ),
                height40(),
                // Text('Code'.tr,
                //     style: ThemeUtils.blackSemiBold
                //         .copyWith(fontSize: FontUtils.mediumSmall)),
                // height16(),
                // Text(
                //   text.value,
                //   style: ThemeUtils.blackRegular
                //       .copyWith(fontSize: FontUtils.small),
                //   textAlign: TextAlign.center,
                // ),
                // height48(),
                // InkWell(
                //     borderRadius: BorderRadius.circular(5),
                //     onTap: () {
                //       Clipboard.setData(ClipboardData(text: text.value));
                //
                //       Get.snackbar("Success", 'Copied to clipboard');
                //     },
                //     child: Column(
                //       children: [
                //         SvgIcon(Images.copy, height: 24, width: 24),
                //         height4(),
                //         Text(
                //           'Copy'.tr,
                //           style: ThemeUtils.blackRegular
                //               .copyWith(fontSize: FontUtils.small),
                //           textAlign: TextAlign.center,
                //         ),
                //       ],
                //     )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Toast {
  void showToast({BuildContext? context, String? message}) {
    ScaffoldMessenger.of(context!).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            5,
          ),
        ),
      ),
      duration: Duration(milliseconds: 1000),
      content: Text('$message'),
    ));
  }
}
