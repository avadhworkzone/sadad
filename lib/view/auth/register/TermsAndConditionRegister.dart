import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermsAndConditionRegister extends StatefulWidget {
  const TermsAndConditionRegister({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionRegister> createState() => _TermsAndConditionRegisterState();
}

class _TermsAndConditionRegisterState extends State<TermsAndConditionRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Terms and conditions'.tr,
              style: TextStyle(fontSize: Get.textScaleFactor * 25, fontWeight: FontWeight.w600),
            ),
            leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back_ios,color: ColorsUtils.black))),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Flex(direction: Axis.vertical,
            children:[ Expanded(
                child: SfPdfViewer.asset(
              'assets/images/merchant.pdf',
              scrollDirection: PdfScrollDirection.vertical,
              canShowHyperlinkDialog: true,
            ))],
          ),
        ));
  }
}
