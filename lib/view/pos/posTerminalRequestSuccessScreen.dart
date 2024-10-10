// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/home.dart';

class PosTerminalRequestSuccessScreen extends StatefulWidget {
  final String id;
  const PosTerminalRequestSuccessScreen({Key? key, required this.id})
      : super(key: key);

  @override
  State<PosTerminalRequestSuccessScreen> createState() =>
      _PosTerminalRequestSuccessScreenState();
}

class _PosTerminalRequestSuccessScreenState
    extends State<PosTerminalRequestSuccessScreen> {
  HomeController homeController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height60(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_outlined,
              color: ColorsUtils.black,
              size: 25,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(Images.successPosTerminalRequest,
                    height: Get.height / 4),
                height100(),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                  child: Text('Your request sent successfully'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: FontUtils.medLarge,
                          fontWeight: FontWeight.bold)),
                ),
                customMediumNorText(title: 'We will contact with you soon'.tr),
                //
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Your Request ID :',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: FontUtils.medLarge,
                              fontWeight: FontWeight.normal)),
                      Text(' ${widget.id}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: FontUtils.medLarge,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Get.off(() => HomeScreen());

                    // homeController.bottomIndex.value = 2;
                    Get.off(() => HomeScreen(
                          pageRoutValue: 2,
                        ));
                  },
                  child: buildContainerWithoutImage(
                      color: ColorsUtils.accent,
                      width: Get.width / 4,
                      text: 'Ok'),
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
