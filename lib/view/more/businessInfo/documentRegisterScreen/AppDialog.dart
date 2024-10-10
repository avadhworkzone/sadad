import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class AppDialog {
  static showGifLoader({required BuildContext context,required double time}) {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: GetBuilder(
            init: DialogController(),
            builder: (DialogController controller) {
              controller.time = time;
              return CircularPercentIndicator(
                radius: 80.0,
                lineWidth: 13.0,
                animation: true,
                percent: controller.percentage,
                addAutomaticKeepAlive: true,
                animateFromLastPercent: true,
                center: new Text(
                  "${(controller.percentage * 100).toInt()}% \n" + "Validating...".tr,
                  textAlign: TextAlign.center,
                  style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0, color: ColorsUtils.white),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: ColorsUtils.primary,
                backgroundColor: ColorsUtils.white,
                footer: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "We are validating your document. \nThis may take couple of more seconds".tr,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: controller.messageShow ? ColorsUtils.white : Colors.transparent),
                  ),
                ),
              );
              // return Container(
              //   child:
              //       Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
              //     Image.asset("assets/gif/verify_transparent.gif", width: Get.width * 0.8),
              //     SizedBox(height: 10),
              //     Container(
              //       width: Get.width * 0.8,
              //       child: Row(
              //         children: [
              //           LinearPercentIndicator(
              //             alignment: MainAxisAlignment.center,
              //             width: Get.width * 0.67,
              //             barRadius: Radius.circular(10),
              //             lineHeight: 11.0,
              //             padding: EdgeInsets.zero,
              //             percent: controller.percentage,
              //             backgroundColor: Colors.white,
              //             progressColor: ColorsUtils.primary,
              //           ),
              //           Spacer(),
              //           Text(
              //             "${(controller.percentage*100).toInt()} %",
              //             style: TextStyle(
              //                 color: ColorsUtils.white,
              //                 fontSize: 15,
              //                 fontWeight: FontWeight.w600,
              //                 decoration: TextDecoration.none),
              //           )
              //         ],
              //       ),
              //     )
              //   ]),
              // );
            },
          ),
        );
      },
    );
  }

}

class DialogController extends GetxController {
  double percentage = 0.0;
  bool messageShow = true;
  double time = 0.04;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    startTimer();
    startmessageTimer();
  }

  startTimer() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      percentage = time + percentage;
      if(percentage>=1){
        percentage = 1;
      }
      update();
    });
  }

  startmessageTimer() {
    Timer.periodic(Duration(seconds: 9), (timer) {
      messageShow = false;
      update();
    });
  }
}
