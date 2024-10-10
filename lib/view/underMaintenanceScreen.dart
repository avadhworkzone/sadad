import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/splash.dart';

class UnderMaintenanceScreen extends StatefulWidget {
  const UnderMaintenanceScreen({Key? key}) : super(key: key);

  @override
  State<UnderMaintenanceScreen> createState() => _UnderMaintenanceScreenState();
}

class _UnderMaintenanceScreenState extends State<UnderMaintenanceScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Get.offAll(() => SplashScreen());
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsUtils.accent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.sadadLoginLogo,
                color: ColorsUtils.white, width: 100, height: 100),
            height100(),
            Center(
              child: Image.asset(
                Images.underMaintenance,
                color: ColorsUtils.white,
              ),
            ),
          ],
        ));
  }
}
