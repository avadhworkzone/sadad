import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/home.dart';

class WithdrawalSuccessScreenScreen extends StatefulWidget {
  const WithdrawalSuccessScreenScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawalSuccessScreenScreen> createState() =>
      _WithdrawalSuccessScreenScreenState();
}

class _WithdrawalSuccessScreenScreenState
    extends State<WithdrawalSuccessScreenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: InkWell(
                onTap: () {
                  Get.offAll(() => HomeScreen());
                },
                child: buildContainerWithoutImage(
                    color: ColorsUtils.accent,
                    width: Get.width / 4,
                    text: 'Done'.tr),
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                backgroundColor: ColorsUtils.green,
                radius: 50,
                child: Center(
                  child: Icon(Icons.check, color: ColorsUtils.white, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Center(
                child: Text(
                    textAlign: TextAlign.center,
                    'Your withdraw request is sent successfully'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
              ),
            )
          ],
        ));
  }
}
