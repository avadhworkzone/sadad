import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndConditionPage extends StatefulWidget {
  const TermsAndConditionPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Get.height * 0.05),
          InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios)),
          SizedBox(height: Get.height * 0.02),
          Text(
            'Terms and conditions'.tr,
            style: TextStyle(
                fontSize: Get.textScaleFactor * 25,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(height: Get.height * 0.01),
          englishTerm(
              text:
                  "Fill out this application to be guided by the required quantity for point-of-sale devices only.".tr),
          SizedBox(
            height: Get.height * 0.01,
          ),
          englishTerm(
              text:
                  "This request does not require Sadad to submit the entire number of devices requested.".tr),
          SizedBox(
            height: Get.height * 0.01,
          ),
          englishTerm(
              text:
                  "Distribution mechanism (Sadad merchants - members of entrepreneurs - registration priority).".tr),
          SizedBox(height: Get.height * 0.01),
          englishTerm(
              text:
                  "Applications submitted will be subject to the laws and regulations of the Central Bank and Qatar National Bank.".tr),
          SizedBox(height: Get.height * 0.05),
          // Divider(
          //   thickness: 2,
          //   height: 2,
          // ),
          // SizedBox(height: Get.height * 0.01),
          // arabicTerm(text: " تعبئة هذا الطلب للإسترشاد بالكمية المطلوبة لأجهزة نقاط البيع فقط"),
          // SizedBox(height: Get.height * 0.01),
          // arabicTerm(text: " هذا الطلب لا يُلزم سداد بتسليم عدد الأجهزة المطلوبة بالكامل"),
          // SizedBox(height: Get.height * 0.01),
          // arabicTerm(text: "آلية التوزيع ( عملاء سداد - اعضاء رواد الاعمال -اولوية التسجيل )."),
          // SizedBox(height: Get.height * 0.01),
          // arabicTerm(text: "تخضع الطلبات المقدمة لقوانين وأنظمة المصرف المركزي وبنك قطر الوطني"),
        ],
      ),
    ));
  }

  Widget englishTerm({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "\u2022 \n",
          maxLines: 10,
          style: TextStyle(fontSize: Get.textScaleFactor * 15),
        ),
        SizedBox(width: 1),
        Expanded(
          child: Text(
            text,
            maxLines: 10,
            style: TextStyle(fontSize: Get.textScaleFactor * 15),
          ),
        ),
      ],
    );
  }

  Widget arabicTerm({required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: Get.textScaleFactor * 15),
          ),
        ),
        SizedBox(width: 2),
        Text(
          "\u2022 \n",
          maxLines: 2,
          style: TextStyle(fontSize: Get.textScaleFactor * 15),
        ),
      ],
    );
  }
}
// Expanded(
// child: SfPdfViewer.asset(
// 'assets/images/merchant.pdf',
// scrollDirection: PdfScrollDirection.vertical,
// canShowHyperlinkDialog: true,
// )),
