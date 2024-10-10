import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:encrypt/encrypt.dart' as keyEnc;
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/myQrCode/export_pdf.dart';
import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';

class QrPaymentAmountScreen extends StatefulWidget {
  final String? amount;
  final String? code;
  const QrPaymentAmountScreen({super.key, this.amount, this.code});

  @override
  State<QrPaymentAmountScreen> createState() => _QrPaymentAmountScreenState();
}

class _QrPaymentAmountScreenState extends State<QrPaymentAmountScreen> {
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  String sadadId = '';

  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  initData() async {
    await businessDetailCnt.getBusinessInfo(context);
    sadadId =
        businessDetailCnt.businessInfoModel.value.user!.sadadId.toString();
    setState(() {});

    if (sadadId != '') {
      // convertIDtoBase64byAESMethod();
      encryption();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios_rounded)),
              ),
              height40(),
              customSmallMedSemiText(title: 'QR Payment Amount'),
              height20(),
              customMediumLargeBoldText(
                  title: '${widget.amount!} QAR', color: ColorsUtils.accent),
              height100(),
              customSmallNorText(title: 'Scan QRCODE to pay'),
              height50(),
              sadadId == ''
                  ? Loader()
                  : SizedBox(
                      height: 300,
                      width: 300,
                      child: Barcode(
                        key: barcodeKey,
                        codeValue: text.value,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  RxString text = "".obs;

  void convertIDtoBase64byAESMethod() {
    print('amount is${widget.amount}');
    Map<String, dynamic> data = {
      "sadadId": sadadId,
      "amount": widget.amount,
      "roleId": 1,
      'id': widget.code
    };
    print('string is ${jsonEncode(data).toString()}');
    final key = keyEnc.Key.fromUtf8('XDRvx?#Py^5V@3jC');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(jsonEncode(data).toString(), iv: iv);
    print('barcode ${encrypted.base64}');
    setState(() {
      text.value = encrypted.base64;
    });
  }

  encryption() async {
    print('amount is${widget.amount}');
    Map<String, dynamic> data = {
      "sadadId": sadadId,
      "amount": widget.amount,
      "roleId": 1,
      'id': widget.code
    };

    print('string is ${jsonEncode(data)}');

    // final encryptText = CryptLib.instance.encryptPlainTextWithRandomIV(
    //   jsonEncode(data).toString(),
    //   "XDRvx?#Py^5V@3jC",
    // );

    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded =
        stringToBase64.encode(CryptLib.instance.encryptPlainTextWithRandomIV(
      jsonEncode(data).toString(),
      "XDRvx?#Py^5V@3jC",
    ));
    setState(() {
      text.value = encoded;
      print(encoded);
    });
  }
}
