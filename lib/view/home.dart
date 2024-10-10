import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/controller/notification_methods.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityScreen.dart';
import 'package:sadad_merchat_app/view/more/moreScreen.dart';
import 'package:sadad_merchat_app/view/payment/payment.dart';
import 'package:sadad_merchat_app/view/settlement/settlementScreen.dart';
import '../staticData/utility.dart';
import 'dashboard/dashboardScreen.dart';
import 'pos/posScreen.dart';

class HomeScreen extends StatefulWidget {
  final int pageRoutValue;

  const HomeScreen({Key? key, this.pageRoutValue = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();
  NotificationMethods _notification = NotificationMethods();

  @override
  void initState() {
    AnalyticsService.sendAppCurrentScreen('Home Screen');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // controllerInit();
    });

    notificationInti();
    super.initState();
    singleCallForVPNCheck();
  }

  void notificationInti() {
    _notification.notificationPermission();
    _notification.inItNotification(context);
    _notification.onNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
        builder: (homeController) {
          return homeController.bottomIndex == 0
              ? const DashBoardScreen()
              : homeController.bottomIndex == 1
                  ? const PaymentScreen()
                  : homeController.bottomIndex == 2
                      ? const PosScreen()
                      : homeController.bottomIndex == 3
                           ? const SettlementScreen()
                          //? const ActivityScreen()
                          : homeController.bottomIndex == 4
                              ? const MoreScreen()
                              : const SizedBox();
        },
      ),
      bottomNavigationBar: bottomViewData(),
    );
  }

  GetBuilder<GetxController> bottomViewData() {
    return GetBuilder<HomeController>(builder: (homeController) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: ColorsUtils.border)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///dashboard screen
                  GestureDetector(
                    onTap: () {
                      homeController.bottomIndex = 0;
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.dashboard,
                              height: 25,
                              width: 25,
                              color: homeController.bottomIndex == 0
                                  ? ColorsUtils.accent
                                  : Colors.black),
                          Text('dashboard'.tr,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: homeController.bottomIndex == 0
                                      ? ColorsUtils.accent
                                      : Colors.black)),
                        ],
                      ),
                    ),
                  ),

                  ///wallet screen
                  GestureDetector(
                    onTap: () {
                      homeController.bottomIndex = 1;
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.onlinePayment,
                              height: 25,
                              width: 25,
                              color: homeController.bottomIndex == 1
                                  ? ColorsUtils.accent
                                  : Colors.black),
                          Text(
                            'E-Payment'.tr,
                            style: TextStyle(
                                fontSize: 12,
                                color: homeController.bottomIndex == 1
                                    ? ColorsUtils.accent
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///POS screen...
                  GestureDetector(
                    onTap: () {
                      homeController.bottomIndex = 2;
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.pos,
                              height: 25,
                              width: 25,
                              color: homeController.bottomIndex == 2
                                  ? ColorsUtils.accent
                                  : Colors.black),
                          Text(
                            'pos'.tr,
                            style: TextStyle(
                                fontSize: 12,
                                color: homeController.bottomIndex == 2
                                    ? ColorsUtils.accent
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///Index screen
                  GestureDetector(
                    onTap: () {
                      homeController.bottomIndex = 3;
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.wallet,
                              height: 25,
                              width: 25,
                              color: homeController.bottomIndex == 3
                                  ? ColorsUtils.accent
                                  : Colors.black),
                          Text(
                            //'Activity'.tr,
                            'Settlement'.tr,
                            style: TextStyle(
                                fontSize: 12,
                                color: homeController.bottomIndex == 3
                                    ? ColorsUtils.accent
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///more screen
                  GestureDetector(
                    onTap: () {
                      homeController.bottomIndex = 4;
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Images.more,
                              width: 25,
                              height: 25,
                              color: homeController.bottomIndex == 4
                                  ? ColorsUtils.accent
                                  : Colors.black),
                          Text(
                            'more'.tr,
                            style: TextStyle(
                                fontSize: 12,
                                color: homeController.bottomIndex == 4
                                    ? ColorsUtils.accent
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  controllerInit() {
    homeController.initBottomIndex = widget.pageRoutValue;
    // print('value is ${homeController.bottomIndex.value}');
  }
}
