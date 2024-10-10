import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';

import '../../main.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  bool enLng = false;

  Future<void> changeLanguage(String code, bool val) async {
    print("called");
    enLng = val;
    await encryptedSharedPreferences.setString('currnetLanguage', code);
    Get.updateLocale(Locale(code));

    setState(() {});
  }

  setPrimaryLanguage() {
    print(Get.locale);
    if (Get.locale.toString() == "en") {
      enLng = false;
    } else if (Get.locale.toString() == "ar") {
      enLng = true;
    }
  }

  @override
  void initState() {
    setPrimaryLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsUtils.white,
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height24(),
              Text('Select Language'.tr,
                  style: ThemeUtils.blackSemiBold
                      .copyWith(fontSize: FontUtils.medLarge)),
              height24(),
              InkWell(
                onTap: () => changeLanguage("ar", true),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Image.asset(Images.arbic, height: 24, width: 32),
                      width9(),
                      Text('Arabic'.tr,
                          style: ThemeUtils.blackRegular
                              .copyWith(fontSize: FontUtils.small)),
                      Spacer(),
                      Image.asset(
                        Images.check,
                        height: 14.31,
                        width: 16,
                        color: enLng ? ColorsUtils.primary : Colors.transparent,
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => changeLanguage("en", false),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Image.asset(Images.english, height: 24, width: 32),
                      width9(),
                      Text('English'.tr,
                          style: ThemeUtils.blackRegular
                              .copyWith(fontSize: FontUtils.small)),
                      Spacer(),
                      Image.asset(
                        Images.check,
                        height: 14.31,
                        width: 16,
                        color:
                            !enLng ? ColorsUtils.primary : Colors.transparent,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
