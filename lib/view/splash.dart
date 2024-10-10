import 'dart:async';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import '../../base/constants.dart';
import 'auth/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  bool? isFromVPNProxy;
  String? VPNMessage;

  SplashScreen({Key? key, this.isFromVPNProxy,this.VPNMessage}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  int splashDuration = 2000;
  // ConnectivityViewModel connectivityViewModel = Get.find();
  @override
  void initState() {
    // connectivityViewModel.startMonitoring();
    // super.initState();
    AnalyticsService.sendAppCurrentScreen('Splash Screen');
    navigateToHome();
  }

  void navigateToHome() async {
    return Future.delayed(Duration(milliseconds: splashDuration), () {
      Get.offAll(() => LoginScreen(isFromVPNProxy: widget.isFromVPNProxy,VPNMessage: widget.VPNMessage,));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // body: Center(
        //   child: Image.asset(
        //     Images.splashLogo,
        //     width: 200,
        //     height: 200,
        //   ),
        // ),

        body: Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                Images.splashScreen,
              ),
              fit: BoxFit.cover)),
    ));

    // return GetBuilder<ConnectivityViewModel>(
    //   builder: (controller) {
    //     if (controller.isOnline != null) {
    //       if (controller.isOnline!) {
    //         return Scaffold(
    //             // body: Center(
    //             //   child: Image.asset(
    //             //     Images.splashLogo,
    //             //     width: 200,
    //             //     height: 200,
    //             //   ),
    //             // ),
    //             body: Container(
    //           width: Get.width,
    //           height: Get.height,
    //           decoration: BoxDecoration(
    //               image: DecorationImage(
    //                   image: AssetImage(
    //                     Images.splashScreen,
    //                   ),
    //                   fit: BoxFit.cover)),
    //         ));
    //       } else {
    //         return InternetNotFound();
    //       }
    //     } else {
    //       return SizedBox();
    //     }
    //   },
    // );
  }

  // initData() async {
  //   final url = Uri.parse('http://176.58.99.102:3001/api-v1/users/login');
  //   Map<String, String> header = {'Content-Type': 'application/json'};
  //   Map<String, dynamic>? body = {
  //     "cellnumber": "987678653627",
  //     "password": 'U#2&SAy@W[_!pjD\$',
  //     "signinForSignup": true
  //   };
  //   var result = await http.post(
  //     url,
  //     headers: header,
  //     body: jsonEncode(body),
  //   );
  //   if (result.statusCode == 200) {
  //     await encryptedSharedPreferences.setString(
  //         'token', jsonDecode(result.body)['id']);
  //     print(
  //         'token is:${jsonDecode(result.body)['id']} \n req is : ${jsonEncode(body)}  \n response is :${result.body} ');
  //   }
  // }
}
