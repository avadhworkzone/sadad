import 'package:flutter/material.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class FingerAndFaceScreen extends StatefulWidget {
  final String text;
  const FingerAndFaceScreen({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  _FingerAndFaceScreenState createState() => _FingerAndFaceScreenState();
}

class _FingerAndFaceScreenState extends State<FingerAndFaceScreen> {
  bool switchchange = false;
  String? cellNo;
  String? pass;
  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                height24(),
                Text(widget.text,
                    style: ThemeUtils.blackSemiBold
                        .copyWith(fontSize: FontUtils.medLarge)),
                Spacer(),
                Switch(
                  value: switchchange,
                  activeColor: ColorsUtils.accent,
                  onChanged: (value) async {
                    switchchange = !switchchange;
                    if (widget.text == 'Face detection') {
                      print('Face detection');
                      if (switchchange == true) {
                        await encryptedSharedPreferences.setString(
                            'bioDetectionFace', 'true');
                        print(await encryptedSharedPreferences
                            .getString('bioDetectionFace'));
                      } else {
                        await encryptedSharedPreferences.setString(
                            'bioDetectionFace', 'false');
                        print(await encryptedSharedPreferences
                            .getString('bioDetectionFace'));
                      }
                    } else if (widget.text == 'Fingerprint') {
                      print('finger');
                      if (switchchange == true) {
                        await encryptedSharedPreferences.setString(
                            'bioDetectionFinger', 'true');
                        print(await encryptedSharedPreferences
                            .getString('bioDetectionFinger'));
                      } else {
                        await encryptedSharedPreferences.setString(
                            'bioDetectionFinger', 'false');
                        print(await encryptedSharedPreferences
                            .getString('bioDetectionFinger'));
                      }
                    }
                    setState(() {});
                  },
                )
              ],
            ),
            Text(switchchange ? "Active" : "InActive",
                style: ThemeUtils.blackRegular
                    .copyWith(fontSize: FontUtils.verySmall)),
          ],
        ),
      ),
    );
  }

  initData() async {
    if (widget.text == 'Face detection') {
      if (await encryptedSharedPreferences.getString('bioDetectionFace') ==
          'true') {
        switchchange = true;
        setState(() {});
      } else {
        switchchange = false;
        setState(() {});
      }
    } else if (widget.text == 'Fingerprint') {
      if (await encryptedSharedPreferences.getString('bioDetectionFinger') ==
          'true') {
        switchchange = true;
        setState(() {});
      } else {
        switchchange = false;
        setState(() {});
      }
    }
  }
}
