import 'package:flutter/material.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class BusinessDetailsWidget extends StatelessWidget {
  final String? name;
  final String? subName;
  final int notification;
  final Function()? onTap;
  final TextStyle? nameStyle;
  final bool? hideArrow;

  const BusinessDetailsWidget(
      {Key? key,
      this.name,
      this.subName,
      required this.notification,this.nameStyle,
      this.onTap,
      this.hideArrow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("notification ==== $notification");
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(name ?? '',
                    style: nameStyle ?? ThemeUtils.blackSemiBold
                        .copyWith(fontSize: FontUtils.small)),
                Spacer(),
                notification > 0
                    ? Container(
                        height: 19,
                        width: 22,
                        margin: EdgeInsets.symmetric(horizontal: 24),
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
                hideArrow ?? false
                    ? height24()
                    : Icon(Icons.keyboard_arrow_right)
              ],
            ),
            height8(),
            subName == ""
                ? SizedBox()
                : Text(subName ?? '',
                    style: ThemeUtils.blackRegular
                        .copyWith(fontSize: FontUtils.small)),
          ],
        ),
      ),
    );
  }
}
