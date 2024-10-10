import 'dart:async';
import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';

import '../main.dart';
import '../staticData/utility.dart';
import 'package:http/http.dart' as http;

import '../view/splash.dart';

// class Utils {
//   static double height(double px) {
//     return px.h;
//   }
//
//   static double width(double px) {
//     return px.w;
//   }
//
//   static double fontSize(double px) {
//     return px.sp;
//   }
// }

class DateFormatter {
  static const String dd_MM_yyyy = "dd-MM-yyyy";
  static const String dd_MMM_yyyy = "dd MMM yyyy";
  static const String yyyy_MM_dd_T_HH_mm_ss_Z = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static const String hh_mm = "hh:mm";
  static const String hh_mm_a = "hh:mm a";
  static const String dd_MM_yyyy_HH_mm = "dd-MM-yyyy HH:mm";

  static String stringToString(
      String currentFormat, String requireFormat, String data) {
    DateTime dateTime = DateFormat(currentFormat).parse(data);
    return DateFormat(requireFormat).format(dateTime);
  }

  static String dateTimeToString(String requireFormat, DateTime dateTime) {
    return DateFormat(requireFormat).format(dateTime);
  }

  static DateTime stringToDateTime(String currentFormat, String date) {
    return DateFormat(currentFormat).parse(date);
  }

  static TimeOfDay stringToTimeOfDay(String currentFormat, String date) {
    DateTime dateTime = stringToDateTime(currentFormat, date);
    return TimeOfDay.fromDateTime(dateTime);
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class ColorsUtils {
  static const Color primary = Color(0xff8E1B3E);
  static const Color primaryTransparent = Color(0x778E1B3E);
  static const Color accent = Color(0xff8E1B3E);
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff121212);
  static const Color red = Color(0xffDD1726);
  static const Color darkOrange = Color(0xffD46A4A);
  static const Color orange = Color(0xffECAE4E);
  static const Color yellow = Color(0xffF6CF4F);
  static const Color darkYellow = Color(0xffE8B110);
  static const Color darkMaroon = Color(0xff8E1B5D);
  static const Color shadow = Color(0x00000014);
  static const Color tabUnselectLabel = Color(0xff011F45);
  static const Color tabUnselect = Color(0xffF2F3F3);
  static const Color line = Color(0xffE4E7EB);
  static const Color countBackground = Color(0xff2D4564);
  static const Color dividerCreateInvoice = Color(0xffDADCE0);
  static const Color createInvoiceContainer = Color(0xfff9f9f9);
  static const Color chartYellow = Color(0xffffc828);
  static const Color maroon70122E = Color(0xff70122e);
  static const Color maroonA24964 = Color(0xffa24964);
  static const Color green = Color(0xff3B9E4F);
  static const Color pink = Color(0xffCE0562);
  static const Color grey = Color(0xff6d6e70);
  static const Color border = Color(0xffDADCE0);
  static const Color hintColor = Color(0xff121212);
  static const Color invoiceAmount = Color(0xff8E1B3E);
  static const Color saveDraftButton = Color(0xff011F45);
  static const Color inactiveSwitch = Color(0xff7E8EA1);
  static const Color link = Color(0xff83D0F5);
  static const Color reds = Color(0xffDD1726);
  static const Color lightPink = Color(0xffF3E6EA);
  static const Color lightBg = Color(0xffeeeeee);
  static const Color tersBlue = Color(0xff43C0B9);
  static const Color blueBerryPie = Color(0xff324C6A);
  static const Color posYellowBg = Color(0xffFEC73E);
  static const Color lightYellow = Color(0xffFFF9E8);
  static const Color auth = Color(0xff393939);
  static const Color transferBg = Color(0xffF1FAFD);
  static const Color transferUnSelect = Color(0xffF9F9F9);
  static const Color lightGrey = Color(0xFFE8EAEC);
  static const Color greenText = Color(0xFF42951F);
}

class ThemeUtils {
  static TextStyle appbarTheme = const TextStyle(
      color: ColorsUtils.black, fontSize: 20, fontWeight: FontWeight.w700);

  static IconThemeData appbarActionsTheme =
      const IconThemeData(color: ColorsUtils.primary);

  static const TextStyle blackBold =
      TextStyle(color: ColorsUtils.black, fontWeight: FontWeight.w700);

  static const TextStyle blackSemiBold =
      TextStyle(color: ColorsUtils.black, fontWeight: FontWeight.w600);

  static const TextStyle blackRegular =
      TextStyle(color: ColorsUtils.black, fontWeight: FontWeight.normal);

  static const TextStyle whiteRegular = TextStyle(color: ColorsUtils.white);

  static const TextStyle whiteBold =
      TextStyle(color: ColorsUtils.white, fontWeight: FontWeight.w700);

  static const TextStyle whiteSemiBold =
      TextStyle(color: ColorsUtils.white, fontWeight: FontWeight.w500);

  static const TextStyle maroonSemiBold =
      TextStyle(color: ColorsUtils.primary, fontWeight: FontWeight.w500);

  static const TextStyle maroonBold =
      TextStyle(color: ColorsUtils.primary, fontWeight: FontWeight.w700);

  static const TextStyle maroonRegular = TextStyle(color: ColorsUtils.primary);
}

class FontUtils {
  static const double large = 24;
  static const double medLarge = 20;
  static const double medium = 18;
  static const double mediumSmall = 16;
  static const double small = 14;
  static const double smaller = 13;
  static const double verySmall = 12;
}

final oCcy = NumberFormat("#,##0.00", "en_US");

Widget currencyText(double amount, TextStyle amountStyle, TextStyle qarStyle) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Flexible(
        child: Text(
          oCcy.format(amount),
          //overflow: TextOverflow.ellipsis,
          style: amountStyle.copyWith(height: 0.9),
        ),
      ),
      width5(),
      Container(
        // margin: const EdgeInsets.only(left: 4),
        child: Text(
          "QAR",
          style: qarStyle.copyWith(height: 0.9),
        ),
      ),
    ],
  );
}

singleCallForVPNCheck() async {
  await encryptedSharedPreferences.setString('ipaddress', '');
  Future.delayed(Duration(seconds: 1), () async {
    final ipv4 = await Ipify.ipv4();
    print(ipv4);
    var oldIP = await encryptedSharedPreferences.getString('ipaddress');
    if (oldIP == ipv4) {
    } else {
      vpnProxyCheck(ipv4.toString());
    }
  });
}

repeatedCallForVPNCheck() async {
  await encryptedSharedPreferences.setString('ipaddress', '');
  Future.delayed(Duration(seconds: 1), () async {
    final ipv4 = await Ipify.ipv4();
    print(ipv4);
    var oldIP = await encryptedSharedPreferences.getString('ipaddress');
    if (oldIP == ipv4) {
    } else {
      vpnProxyCheck(ipv4.toString());
    }
  });
  Timer.periodic(Duration(minutes: 2), (Timer t) async {
    final ipv4 = await Ipify.ipv4();
    print(ipv4);
    var oldIP = await encryptedSharedPreferences.getString('ipaddress');

    if (oldIP == ipv4) {
    } else {
      vpnProxyCheck(ipv4.toString());
    }
  });
}

vpnProxyCheck(String ipAddress) async {
  var token = await encryptedSharedPreferences.getString('token');
  final url =
      Uri.parse('${Utility.baseUrl}odooips/proxyCheck?ipaddress=${ipAddress}');
  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization': token,
  };

  print('url is ' + url.toString());
  // print('body is$body');
  var result = await http.get(
    url,
    headers: header,
  );

  if (result.statusCode >= 200 && result.statusCode <= 299) {
    print('result is ' + result.body);
    print('req is ' + url.toString());
    var response = result.body;
    var test = jsonDecode(response);
    if (test['status'] == 'ok') {
      if (test[ipAddress]['proxy'] == "no" && test[ipAddress]['vpn'] == "no") {
        print('no');
        await encryptedSharedPreferences.setString('ipaddress', ipAddress);
      } else {
        //Get.snackbar('', test['message'].toString());
        Get.offAll(
          () => SplashScreen(
              isFromVPNProxy: true, VPNMessage: test['message'].toString()),
        );
      }
    } else {
      //Get.snackbar('', test['message'].toString());
      Get.offAll(
        () => SplashScreen(
            isFromVPNProxy: true, VPNMessage: test['message'].toString()),
      );
    }
  } else if (result.statusCode == 499) {
  } else {
    if (result.statusCode == 401) {
      SessionExpire();
    } else {}
  }
}

class Functions {
  static String appVersion = "";
  static String buildNumber = "";

  static getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
}
