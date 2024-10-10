import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/util/utils.dart';

void showLoadingDialog({
  @required BuildContext? context,
  Color? barrierColor,
}) {
  Future.delayed(Duration(seconds: 0), () {
    showDialog(
        context: context!,
// barrierColor: barrierColor ?? AppColors.textColorWhite.withOpacity(0.50),
        barrierDismissible: false,
        builder: (context) {
          return Center(child: Lottie.asset(Images.slogo, width: 60, height: 60)
              // child: SizedBox(
              //     width: 30,
              //     height: 30,
              //     child: CircularProgressIndicator(
              //       strokeWidth: 3,
              //       valueColor: AlwaysStoppedAnimation<Color>(ColorsUtils.accent),
              //     )),
              );
        });
  });
}

void hideLoadingDialog({BuildContext? context}) {
  Navigator.pop(context!, false);
}


