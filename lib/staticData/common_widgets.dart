import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';

import '../controller/validation_controller.dart';
import '../view/splash.dart';

ValidationController validationController = Get.find();

class ProgressBar extends StatelessWidget {
  final double max;
  final double current;
  final Color color;

  const ProgressBar({Key? key, required this.max, required this.current, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debug.trace("Percentage ${current/100}");
    return Container(
      margin: const EdgeInsets.only(top: 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          minHeight: 8,
          value: current / 100, // percent filled
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: ColorsUtils.tabUnselect,
        ),
      ),
    );
  }
}

Text smallSemiBoldText({String? text}) {
  return Text(text!, style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.verySmall));
}

Text smallBoldText({String? text}) {
  return Text(text!, style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.verySmall));
}

class SessionExpire extends StatelessWidget {
  const SessionExpire({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: ColorsUtils.accent,
          content: Text(
            'Session Expire'.tr,
            style: TextStyle(
              color: ColorsUtils.white,
            ),
          )));
      Future.delayed(const Duration(seconds: 0), () {
        moveToSplashWithRemoveFingerAndFaceDetails();
      });
    });
    return Center(
      child: Text('Something Wrong'.tr),
    );
  }
}

Future<void> moveToSplashWithRemoveFingerAndFaceDetails() async {
  await encryptedSharedPreferences.setString('bioDetectionFinger', 'false');
  await encryptedSharedPreferences.setString('bioDetectionFace', 'false');
  Get.offAll(() => SplashScreen());

  await encryptedSharedPreferences.setString('bioDetectionFinger', 'false');
  await encryptedSharedPreferences.setString('bioDetectionFace', 'false');
  Get.offAll(() => SplashScreen());
}

void funcSessionExpire() {
  print("Session expire called");
  Get.showSnackbar(GetSnackBar(
    message: 'Session Expire'.tr,
    duration: Duration(seconds: 1),
  ));

  // encryptedSharedPreferences.clear();
  Future.delayed(Duration(seconds: 0), () {
    Get.offAll(() => SplashScreen());
  });
}

class Loader extends StatelessWidget {
  const Loader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return CircularProgressIndicator();
    return Center(child: Lottie.asset(Images.slogo, width: 60, height: 60));
  }
}

typedef OnTap = void Function();

class InternetNotFound extends StatelessWidget {
  final OnTap onTap;

  const InternetNotFound({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: ColorsUtils.lightPink),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Images.sadadLoginLogo, width: Get.width * 0.5, height: Get.width * 0.5),
              height30(),
              Center(child: customMediumBoldText(title: 'sorry, We can’t connect you.'.tr)),
              height20(),
              Center(
                child: customSmallSemiText(title: 'Looks like we can’t connect to one of our services right now,Please check your internet Connectivity Please try again later'.tr),
              ),
              height40(),
              InkWell(
                onTap: onTap,
                child: buildContainerWithoutImage(text: 'Try Later'.tr, color: ColorsUtils.accent),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Container commonButtonBox({String? img, String? text, Color? color}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            img!,
            width: 24,
            height: 24,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text!,
            style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.small),
          )
        ],
      ),
    ),
  );
}

Container buildContainerWithoutImage({String? text, bool? plusIcon, Color? color, BorderRadiusGeometry? borderRadius, double? width,TextStyle? style}) {
  return Container(
    width: width ?? Get.width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            plusIcon ?? false ? SvgPicture.asset(Images.plusicon) : SizedBox(),
            plusIcon ?? false ? width8() : SizedBox(),
            Text(
              text ?? "",
              style: style ?? ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall),
            ),
          ],
        ),
      ),
    ),
  );
}

//radio button
class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    required this.label,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final int groupValue;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Row(
        children: <Widget>[
          Radio<int>(
            groupValue: groupValue,
            value: value,
            activeColor: ColorsUtils.accent,
            onChanged: (int? newValue) {
              onChanged(newValue!);
            },
          ),
          Text(label),
        ],
      ),
    );
  }
}

///No Data Found
Center noDataFound() {
  return Center(
      child: Padding(
    padding: const EdgeInsets.only(top: 50),
    child: Text('No data found'.tr),
  ));
}

Widget commonTextField(
    {String? hint,
    Validator? validator,
    String? errorText,
    OnChange? onChange,
    TextInputType? keyType,
    TextEditingController? contollerr,
    int? inputLength,
    String? regularExpression,
    Widget? suffix,
    final double? width,
    int? maxLines,
    int? maxLength,
    TextInputAction? textInputAction,
    bool isRead = false,
    String? validationType,
    final Function()? onTap,
    AutovalidateMode? autoValidateMode,
    TextCapitalization? textCapitalization,
    List<TextInputFormatter>? inputFormatters,
    Icon? prifix,
    Widget? prifixWidget}) {
  return SizedBox(
    // height: Get.width * 0.12,
    width: width,
    child: TextFormField(
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        keyboardType: keyType,
        textInputAction: textInputAction,
        controller: contollerr,
        inputFormatters: inputFormatters != null
            ? inputFormatters
            : regularExpression != null
                ? [LengthLimitingTextInputFormatter(inputLength), FilteringTextInputFormatter.allow(RegExp(regularExpression))]
                : [
                    LengthLimitingTextInputFormatter(inputLength),
                  ],
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        autovalidateMode: autoValidateMode ?? null,
        readOnly: isRead,
        // enabled: !isRead,
        onTap: onTap,
        decoration: InputDecoration(
          errorText: errorText,
          isDense: true,
          label: Text(hint!),
          suffixIcon: suffix,
          border: OutlineInputBorder(borderSide: BorderSide(color: ColorsUtils.border.withOpacity(0.3), width: 1), borderRadius: BorderRadius.circular(10)),
          hintStyle: ThemeUtils.blackSemiBold.copyWith(color: ColorsUtils.hintColor.withOpacity(0.5)),
          prefixIcon: prifix,
          prefix: prifixWidget,
        ),
        validator: validator,
        obscureText: validationType == 'password' ? validationController.obscureText!.value : false,
        style: TextStyle(decoration: TextDecoration.none),
        onChanged: onChange),
  );
}

Text smallGreyText({String? title}) {
  return Text(
    title!,
    textDirection: TextDirection.ltr,
    style: ThemeUtils.blackSemiBold.copyWith(color: ColorsUtils.grey, fontSize: FontUtils.verySmall),
  );
}

Text boldText({String? title}) {
  return Text(
    title!,
    style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
  );
}

Text smallText({String? title}) {
  return Text(
    title!,
    style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small),
  );
}

Text customSmallSemiText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small, color: color),
  );
}

Text customSmallBoldText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.small, color: color),
  );
}

Text customSmallNorText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small, color: color),
  );
}

Text customVerySmallNorText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall, color: color),
  );
}

Text customVerySmallSemiText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.verySmall, color: color),
  );
}

Text customVerySmallBoldText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.verySmall, color: color),
  );
}

Text customMediumBoldText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium, color: color),
  );
}

Text customMediumSemiText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medium, color: color),
  );
}

Text customMediumLargeSemiText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medLarge, color: color),
  );
}

Text customMediumNorText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.medium, color: color),
  );
}

Text customSmallMedBoldText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall, color: color),
  );
}

Text customMediumLargeBoldText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge, color: color),
  );
}

Text customSmallMedSemiText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.mediumSmall, color: color),
  );
}

Text customSmallMedNorText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.mediumSmall, color: color),
  );
}

Text customLargeBoldText({
  String? title,
  Color? color,
}) {
  return Text(
    title!,
    style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.large, color: color),
  );
}

Container commonTextBox({String? title, Color? color}) {
  return Container(
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: customVerySmallSemiText(color: ColorsUtils.white, title: title),
    ),
  );
}

Widget commonColumnField({String? title, String? value, Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        smallText(title: title),
        height5(),
        Text(
          value!,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall, color: color),
        ),
      ],
    ),
  );
}

Widget commonColumnFieldLtr({String? title, String? value, Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        smallText(title: title),
        height5(),
        Text(
          value!,
          textDirection: TextDirection.ltr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall, color: color),
        ),
      ],
    ),
  );
}

class CustomTab extends StatelessWidget {
  final Color selectedBackground;
  final Color selectedLabel;
  final String title;

  const CustomTab({Key? key, required this.selectedBackground, required this.selectedLabel, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 40,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        // margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: selectedBackground),
        child: Text(
          title.tr,
          style: ThemeUtils.maroonBold.copyWith(fontSize: FontUtils.verySmall, color: selectedLabel),
        ),
      ),
    );
  }
}

class TransactionAmount extends StatelessWidget {
  final String title;
  final String img;
  final dynamic amount;
  final Color color;
  final Color? imgColor;

  const TransactionAmount(this.title, this.img, this.amount, this.color, {Key? key, this.imgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: ColorsUtils.white, borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.275,
                    child: Text(
                      title.tr,
                      style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.small),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    img,
                    color: imgColor,
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
              this.title == "Transactions Count"
                  ? customMediumSemiText(color: color, title: amount.round().toString())
                  : currencyText(
                      amount, ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.mediumSmall, color: color), ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall, color: color))
            ],
          ),
        ));
  }
}

SizedBox height25() {
  return SizedBox(
    height: 25,
  );
}

SizedBox height30() {
  return SizedBox(
    height: 30,
  );
}

SizedBox width20() {
  return SizedBox(
    width: 20,
  );
}

SizedBox width22() {
  return SizedBox(
    width: 22,
  );
}

SizedBox width30() {
  return SizedBox(
    width: 30,
  );
}

SizedBox width40() {
  return SizedBox(
    width: 40,
  );
}

SizedBox width25() {
  return SizedBox(
    width: 25,
  );
}

SizedBox width15() {
  return SizedBox(
    width: 15,
  );
}

SizedBox width16() {
  return SizedBox(
    width: 16,
  );
}

SizedBox width13() {
  return SizedBox(
    width: 13,
  );
}

SizedBox width9() {
  return SizedBox(
    width: 9,
  );
}

SizedBox width10() {
  return SizedBox(
    width: 10,
  );
}

SizedBox width8() {
  return SizedBox(
    width: 8,
  );
}

SizedBox width50() {
  return SizedBox(
    width: 50,
  );
}

SizedBox width3() {
  return SizedBox(
    width: 3,
  );
}

SizedBox width5() {
  return SizedBox(
    width: 5,
  );
}

SizedBox width2() {
  return SizedBox(
    width: 2,
  );
}

SizedBox width12() {
  return SizedBox(
    width: 12,
  );
}

SizedBox width132() {
  return SizedBox(
    width: 132,
  );
}

SizedBox height229() {
  return SizedBox(
    height: 229,
  );
}

SizedBox height20() {
  return SizedBox(
    height: 20,
  );
}

SizedBox height60() {
  return SizedBox(
    height: 60,
  );
}

SizedBox height80() {
  return SizedBox(
    height: 80,
  );
}

SizedBox height40() {
  return SizedBox(
    height: 40,
  );
}

SizedBox height50() {
  return SizedBox(
    height: 50,
  );
}

SizedBox height48() {
  return SizedBox(
    height: 48,
  );
}

SizedBox height4() {
  return SizedBox(
    height: 4,
  );
}

SizedBox height100() {
  return SizedBox(
    height: 100,
  );
}

SizedBox height5() {
  return SizedBox(
    height: 5,
  );
}

SizedBox height12() {
  return SizedBox(
    height: 12,
  );
}

SizedBox height8() {
  return SizedBox(
    height: 8,
  );
}

SizedBox height9() {
  return SizedBox(
    height: 9,
  );
}

SizedBox height10() {
  return SizedBox(
    height: 10,
  );
}

SizedBox height15() {
  return SizedBox(
    height: 15,
  );
}

SizedBox height95() {
  return SizedBox(
    height: 95,
  );
}

SizedBox height64() {
  return SizedBox(
    height: 64,
  );
}

SizedBox height39() {
  return SizedBox(
    height: 39,
  );
}

SizedBox height16() {
  return SizedBox(
    height: 16,
  );
}

SizedBox height126() {
  return SizedBox(
    height: 126,
  );
}

SizedBox height24() {
  return SizedBox(
    height: 24,
  );
}

SizedBox height19() {
  return SizedBox(
    height: 19,
  );
}

SizedBox height28() {
  return SizedBox(
    height: 28,
  );
}

SizedBox height32() {
  return SizedBox(
    height: 32,
  );
}

SizedBox height47() {
  return SizedBox(
    height: 47,
  );
}

SizedBox height36() {
  return SizedBox(
    height: 36,
  );
}

Widget dividerData() {
  return Divider(
    color: ColorsUtils.line,
    thickness: 2,
  );
}

Widget dividerWidth1() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 5),
    child: Divider(
      color: ColorsUtils.line,
      thickness: 1,
    ),
  );
}

typedef Validator = String? Function(String? str);
typedef OnChange = Function(String str);

AppBar commonAppBar({bool? menu, Color? backgroundColor, Function()? onTap, Function()? onBack}) {
  return AppBar(
    backgroundColor: backgroundColor,
    leading: ButtonTheme(
      minWidth: 60,
      child: TextButton(
        onPressed: onBack == null ? () => Get.back() : onBack,
        style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith((states) => ColorsUtils.lightBg),
        ),
        child: Icon(Icons.arrow_back_ios_rounded, color: ColorsUtils.black),
      ),
    ),
    actions: [
      menu ?? false
          ? ButtonTheme(
              minWidth: 60,
              child: TextButton(
                onPressed: onTap,
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) => ColorsUtils.lightBg),
                ),
                child: SvgIcon(Images.menuIcon),
              ),
            )
          : SizedBox()
    ],
  );
}

String getAccountStatus(String id) {
  switch (id) {
    case "1":
      return Images.checkStatus;
    case "2":
      return Images.question;
    case "3":
      return Images.needAction;
    case "4":
      return Images.pending;
    case "5":
      return Images.pending;
    case "6":
      return Images.pending;
    default:
      return "";
  }
}

Text getAccountStatusName(String id) {
  switch (id) {
    case "1":
      return Text("Verified".tr, style: TextStyle(color: ColorsUtils.green));

    case "2":
      return Text("Pending".tr, style: TextStyle(color: ColorsUtils.yellow));

    case "3":
      return Text("Need Action".tr, style: TextStyle(color: ColorsUtils.red));

    case "4":
      return Text("Under Review".tr, style: TextStyle(color: ColorsUtils.yellow));

    case "5":
      return Text("Rejected".tr, style: TextStyle(color: ColorsUtils.red));
    case "6":
      return Text("Reverification".tr, style: TextStyle(color: ColorsUtils.yellow));
    default:
      return Text("");
  }
}

String getAccountStatusNameString(String id) {
  switch (id) {
    case "1":
      return "Verified".tr;

    case "2":
      return "Pending".tr;

    case "3":
      return "Need Action".tr;

    case "4":
      return "Under Review".tr;

    case "5":
      return "Rejected".tr;
    case "6":
      return "Reverification".tr;
    default:
      return "";
  }
}

Color getAccountStatusColor(String id) {
  switch (id) {
    case "1":
      return ColorsUtils.green;

    case "2":
      return ColorsUtils.grey;

    case "3":
      return ColorsUtils.accent;

    case "4":
      return ColorsUtils.yellow;

    case "5":
      return ColorsUtils.yellow;
    case "6":
      return ColorsUtils.yellow;
    default:
      return ColorsUtils.white;
  }
}
