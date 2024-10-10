import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/viewModel/more/setting/notificationViewModel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool addProductList = false;
  String expectedDaysValue = '';
  final cnt = Get.put(NotificationCnt());
  final notificationCnt = Get.find<NotificationViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationCnt.getNotificationSettings(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: InkWell(
                onTap: () async {
                  // print('req model is ${jsonEncode(notificationCnt)}');
                  await notificationCnt.notificationRepo
                      .updateNotificationSetting(notificationCnt);
                  await notificationCnt.getNotificationSettings(context);
                },
                child: buildContainerWithoutImage(
                    color: ColorsUtils.accent, text: "Update Setting".tr)),
          ),
        ],
      ),
      appBar: AppBar(
        leading: TextButton(
            onPressed: () => Get.back(),
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                  (states) => ColorsUtils.lightBg),
            ),
            child:
                Icon(Icons.arrow_back_ios_rounded, color: ColorsUtils.black)),
        centerTitle: true,
        title: Text(
          'Notifications'.tr,
          style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medium),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height24(),
              CustomContainer(text: 'Received payment'.tr),
              NCheckBox(
                title: cnt.notificationData[0],
                checkValue: notificationCnt.receivedPaymentPush,
                onTap: () {
                  print(
                      "notificationCnt.notificationModel.value.receivedPaymentPush ${notificationCnt.receivedPaymentPush}");
                  notificationCnt.receivedPaymentPush.value =
                      !notificationCnt.receivedPaymentPush.value;
                },
              ),
              NCheckBox(
                onTap: () {
                  notificationCnt.receivedPaymentEmail.value =
                      !notificationCnt.receivedPaymentEmail.value;
                },
                title: cnt.notificationData[1],
                checkValue: notificationCnt.receivedPaymentEmail,
              ),
              NCheckBox(
                onTap: () {
                  notificationCnt.receivedPaymentSms.value =
                      !notificationCnt.receivedPaymentSms.value;
                },
                title: cnt.notificationData[2],
                checkValue: notificationCnt.receivedPaymentSms,
              ),
              CustomContainer(text: 'Transfer'.tr),
              NCheckBox(
                onTap: () {
                  notificationCnt.transferPush.value =
                      !notificationCnt.transferPush.value;
                },
                title: cnt.notificationData[0],
                checkValue: notificationCnt.transferPush,
              ),
              NCheckBox(
                onTap: () {
                  notificationCnt.transferEmail.value =
                      !notificationCnt.transferEmail.value;
                },
                title: cnt.notificationData[1],
                checkValue: notificationCnt.transferEmail,
              ),
              NCheckBox(
                onTap: () {
                  notificationCnt.transferSms.value =
                      !notificationCnt.transferSms.value;
                },
                title: cnt.notificationData[2],
                checkValue: notificationCnt.transferSms,
              ),
              CustomContainer(text: 'Receive order'.tr),
              NCheckBox(
                onTap: () {
                  notificationCnt.receivedOrdersPush.value =
                      !notificationCnt.receivedOrdersPush.value;
                },
                title: cnt.notificationData[0],
                checkValue: notificationCnt.receivedOrdersPush,
              ),
              NCheckBox(
                onTap: () {
                  notificationCnt.receivedOrderEmail.value =
                      !notificationCnt.receivedOrderEmail.value;
                },
                title: cnt.notificationData[1],
                checkValue: notificationCnt.receivedOrderEmail,
              ),
              NCheckBox(
                onTap: () {
                  notificationCnt.receivedOrderSms.value =
                      !notificationCnt.receivedOrderSms.value;
                },
                title: cnt.notificationData[2],
                checkValue: notificationCnt.receivedOrderSms,
              ),
              dividerData(),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 24, bottom: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        height24(),
                        Text('Play Sound'.tr,
                            style: ThemeUtils.blackSemiBold
                                .copyWith(fontSize: FontUtils.mediumSmall)),
                        Spacer(),
                        Obx(
                          () => Switch(
                            value: notificationCnt.isPlayaSound.value,
                            activeColor: ColorsUtils.accent,
                            onChanged: (value) {
                              notificationCnt.isPlayaSound.value =
                                  !notificationCnt.isPlayaSound.value;
                            },
                          ),
                        )
                      ],
                    ),
                    Text('When I get notification'.tr,
                        style: ThemeUtils.blackRegular
                            .copyWith(fontSize: FontUtils.verySmall)),
                  ],
                ),
              ),
              dividerData(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        height24(),
                        Text('Receive in Arabic Language'.tr,
                            style: ThemeUtils.blackSemiBold
                                .copyWith(fontSize: FontUtils.mediumSmall)),
                        Spacer(),
                        Obx(
                          () => Switch(
                            value: notificationCnt.receiveArabic.value,
                            activeColor: ColorsUtils.accent,
                            onChanged: (value) {
                              notificationCnt.receiveArabic.value = value;
                              print(
                                  'value${notificationCnt.receiveArabic.value}');
                            },
                          ),
                        )
                      ],
                    ),
                    Text('When i receive alert message'.tr,
                        style: ThemeUtils.blackRegular
                            .copyWith(fontSize: FontUtils.verySmall)),
                  ],
                ),
              ),
              height100()
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final String text;

  CustomContainer({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      width: double.infinity,
      color: ColorsUtils.createInvoiceContainer,
      child: Text(
        text,
        style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medium),
      ),
    );
  }
}

class NCheckBox extends StatelessWidget {
  NCheckBox(
      {Key? key,
      required this.title,
      required this.checkValue,
      required this.onTap})
      : super(key: key);

  String title;
  RxBool checkValue = false.obs;
  Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Text(
            title,
            style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small),
          ),
          Spacer(),
          InkWell(
            onTap: () => onTap(),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  border: Border.all(color: ColorsUtils.black, width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child: Obx(() => checkValue.value
                  ? Center(
                      child: Image.asset(Images.check, height: 10, width: 10))
                  : const SizedBox()),
            ),
          )
        ],
      ),
    );
  }
}

class NotificationCnt extends GetxController {
  RxBool switchChange = false.obs;
  RxBool switchChange1 = false.obs;

  RxBool addProduct = false.obs;
  RxBool addProduct1 = false.obs;
  RxBool addProduct2 = false.obs;
  RxList notificationData = [
    'Push notification'.tr,
    'Email'.tr,
    'SMS'.tr,
  ].obs;
}
