import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/home.dart';

class TransferPaymentDoneScreen extends StatefulWidget {
  const TransferPaymentDoneScreen({Key? key}) : super(key: key);

  @override
  State<TransferPaymentDoneScreen> createState() =>
      _TransferPaymentDoneScreenState();
}

class _TransferPaymentDoneScreenState extends State<TransferPaymentDoneScreen> {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: ColorsUtils.green,
                child: Icon(Icons.check, color: ColorsUtils.white, size: 50),
              ),
            ),
            height40(),
            customMediumBoldText(title: 'Your payment done successful'),
          ],
        ));
  }

  Column bottomBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            // Navigator.pushAndRemoveUntil(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => HomeScreen(),
            //     ),
            //     (route) => false);
            Get.offAll(() => HomeScreen());
            // print('value before ${homeController.bottomIndex.value}');
            // print('value after ${homeController.bottomIndex.value}');
          },
          child: buildContainerWithoutImage(
              color: ColorsUtils.accent, width: Get.width / 3, text: 'Done'),
        ),
        height100(),
      ],
    );
  }
}
