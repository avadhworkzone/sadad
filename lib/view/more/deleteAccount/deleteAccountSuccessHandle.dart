
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/splash.dart';
import '../../../base/constants.dart';

class deleteAccountSuccessHandle extends StatefulWidget {
  const deleteAccountSuccessHandle({Key? key}) : super(key: key);

  @override
  State<deleteAccountSuccessHandle> createState() => _deleteAccountSuccessHandleState();
}

class _deleteAccountSuccessHandleState extends State<deleteAccountSuccessHandle> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
      return Future.value(false);
    },
    child:Scaffold(
      body: Center(
        child: Container(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(Get.width * .03),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 30,height: 30,child: Image.asset(Images.successDeleteAcc),),
                height25(),
                Text(
                  "Successfully deleted".tr,
                  style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium),
                ),
                height25(),
                Text("Your Delete account request is submitted.".tr,
                    style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.mediumSmall, color: ColorsUtils.grey), textAlign: TextAlign.center),
                height12(),
                Text("You can exit the app.".tr,
                    style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.mediumSmall, color: ColorsUtils.grey), textAlign: TextAlign.center),
                height60(),
                InkWell(
                    onTap: () {
                      if (Platform.isAndroid) {
                        exit(0);
                      } else if (Platform.isIOS) {
                        Get.offAll(() => SplashScreen());
                      }
                    },
                    child:
                    buildContainerWithoutImage(width: Get.width * 0.5, style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.accent, text: 'Okay'.tr)),
              ],
            ),
          ),
        ),),
    )
    );
  }
}
