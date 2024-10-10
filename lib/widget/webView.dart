import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    // if (Platform.isAndroid) WebView.platform = WebView() as WebViewPlatform?;
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      onWebViewCreated: (WebViewController webViewController) async {
        String token = await encryptedSharedPreferences.getString('token');
        var uRL =
            '${Utility.baseUrl}containers/api-business/download/${Get.arguments}';
        print("uRL  =>>>>>>>>>>> $uRL");
        Map<String, String> headers = {
          "Authorization": token,
          'Content-Type': 'application/json'
        };
        webViewController.loadUrl(uRL, headers: headers);
        print(uRL);
      },
    );
  }
}
