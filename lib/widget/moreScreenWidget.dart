import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sadad_merchat_app/util/utils.dart';

Widget moreScreenCommonRow({
  required String image,
  required String title,
  required Function() onTap,
  required int notification,
  bool? blueColor,
}) {
  return Material(
    color: Colors.white,
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10,bottom: 10,left: 8,right: 8),
        // color: Colors.white,
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(right: 16,left: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: blueColor ?? false
                      ? ColorsUtils.tabUnselectLabel
                      : ColorsUtils.createInvoiceContainer),
              padding: EdgeInsets.all(8),
              child: SvgPicture.asset(image,
                  color: blueColor ?? false
                      ? ColorsUtils.white
                      : ColorsUtils.black),
            ),
            Text(
              title,
              style:
                  ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small),
            ),
            Spacer(),
            notification > 0
                ? Container(
                    height: 19,
                    width: 22,
                    decoration: BoxDecoration(
                        color: ColorsUtils.red,
                        borderRadius: BorderRadius.circular(11)),
                    child: Center(
                        child: Text(
                      notification.toString(),
                      style: ThemeUtils.whiteSemiBold,
                    )),
                  )
                : Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    ),
  );
}
