import 'dart:io';
import 'package:dio/dio.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:open_file/open_file.dart' as open_file;
//import 'package:open_file_safe/open_file_safe.dart' as open_file;

import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:share_plus/share_plus.dart';

import 'get_storage_permission.dart';

Future<void> downloadFile(
    {String? url,
    String? name,
    int? isRadioSelected,
    bool? isEmail,
    BuildContext? context}) async {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  showLoadingDialog(context: context);
  String downloadUrl = url!;
  if (downloadUrl == '' || downloadUrl == null) {
    return;
  }
  print('DOWNLOAD LINK : => $downloadUrl');
  final storagePermissionStatus = await getStoragePermission();
  if (!storagePermissionStatus) {
    print('permisiion not ');
    hideLoadingDialog(context: context);
    return;
  }
  Dio dio = Dio();
  String savePath = (await getDownloadPath()) ?? '';
  if (savePath == "") {
    return;
  }
  print('PATH :=>$savePath');
  savePath = savePath +
      '/' +
      (name != null ? name : DateTime.now().microsecondsSinceEpoch.toString()) +
      (isRadioSelected == 2
          ? '.csv'
          : isRadioSelected == 3
              ? '.xlsx'
              : '.pdf');
  // final url = Uri.parse(
  //     'http://176.58.99.102:3001/api-v1/products/pdfexport?filter={}');
  String token = await encryptedSharedPreferences.getString('token');

  Map<String, String> header = {
    'Authorization': token,
  };
  print('AFTER FILE NAME ADD PATH :=>$savePath');
  try {
    final response = await dio.download(downloadUrl, savePath,
        options: Options(headers: header));

    if (response.statusCode == 200) {
      ///Hardik
      // final files = <XFile>[];
      // files.add(XFile(savePath, name: "testing"));
      // if (Platform.isIOS) {
      //   await Share.shareXFiles(files);
      // } else {
      //   Get.snackbar(
      //       'success'.tr, 'Successfully download to your download folder.');
      //   print('successfully download');
      //   String email = await encryptedSharedPreferences.getString('email');
      //   print('email is $email');
      // }
      ///Hardik
      ///
      /// AK
      Get.snackbar('success'.tr, 'successfully download');
      print('successfully download');
      String email = await encryptedSharedPreferences.getString('email');
      print('email is $email');
      // isEmail == true
      //     ? sendToMail(path: savePath, emailId: email)
      //     :
      openFile(savePath);
      // isEmail == true
      //     ? sendToMail(path: savePath, emailId: email)
      //     :
      //openFile(savePath);
      // Map<String, String> header = {
      //   'Authorization': token,
      //   'Content-Type': 'application/json'
      // };
      // new MaterialApp(
      //   routes: {
      //     "/": (_) =>
      //     new WebviewScaffold(
      //           headers: header,
      //           url: url,
      //           appBar: new AppBar(
      //             title: new Text("Widget webview"),
      //           ),
      //         );
      //   },
      // );
    } else {
      print('failed');
    }
    hideLoadingDialog(context: context);
  } on Exception catch (e) {
    hideLoadingDialog(context: context);

    // TODO
  }
}

Future<void> downloadMultipleFiles(
    {required List<String?> urlList,
    int? isRadioSelected,
    bool? isEmail,
    BuildContext? context}) async {
  final files = <XFile>[];
  showLoadingDialog(context: context);

  urlList.forEach((url) async {
    EncryptedSharedPreferences encryptedSharedPreferences =
        EncryptedSharedPreferences();
    String downloadUrl = url!;
    if (downloadUrl == '' || downloadUrl == null) {
      return;
    }
    print('DOWNLOAD LINK : => $downloadUrl');
    final storagePermissionStatus = await getStoragePermission();
    if (!storagePermissionStatus) {
      print('permisiion not ');
      hideLoadingDialog(context: context);
      return;
    }
    Dio dio = Dio();
    String savePath = (await getDownloadPath()) ?? '';
    if (savePath == "") {
      return;
    }
    print('PATH :=>$savePath');
    savePath = savePath +
        '/' +
        DateTime.now().microsecondsSinceEpoch.toString() +
        (isRadioSelected == 2
            ? '.csv'
            : isRadioSelected == 3
                ? '.xlsx'
                : '.pdf');
    // final url = Uri.parse(
    //     'http://176.58.99.102:3001/api-v1/products/pdfexport?filter={}');
    String token = await encryptedSharedPreferences.getString('token');

    Map<String, String> header = {
      'Authorization': token,
    };
    print('AFTER FILE NAME ADD PATH :=>$savePath');
    final response = await dio.download(downloadUrl, savePath,
        options: Options(headers: header));

    if (response.statusCode == 200) {
      files.add(XFile(savePath, name: "testing"));
      if (files.length == urlList.length) {
        hideLoadingDialog(context: context);
        if (Platform.isIOS) {
          await Share.shareXFiles(files);
        } else {
          Get.snackbar(
              'success'.tr, 'Successfully download to your download folder.');
          print('successfully download');
          String email = await encryptedSharedPreferences.getString('email');
          print('email is $email');
        }
      }
      // isEmail == true
      //     ? sendToMail(path: savePath, emailId: email)
      //     :
      //openFile(savePath);
      // Map<String, String> header = {
      //   'Authorization': token,
      //   'Content-Type': 'application/json'
      // };
      // new MaterialApp(
      //   routes: {
      //     "/": (_) =>
      //     new WebviewScaffold(
      //           headers: header,
      //           url: url,
      //           appBar: new AppBar(
      //             title: new Text("Widget webview"),
      //           ),
      //         );
      //   },
      // );
    } else {
      print('failed');
    }
  });
}

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      final existsPathStatus = await directory.exists();
      // print('EXIS PATH :=>$existsPathStatus');
      if (!existsPathStatus) directory = await getExternalStorageDirectory();
    }
  } catch (err, stack) {
    print("Cannot get download folder path");
  }
  return directory?.path;
}

Future<void> openFile(String path) async {
  //await open_file.OpenFile.open(path);
  await OpenFilex.open(path);
}

// Future<void> sendToMail({String? path, String? emailId}) async {
//   final Email email = Email(
//     body: 'Invoice',
//     subject: 'Sales Invoice',
//     recipients: ['adkatrdodiya11@gmail.com'],
//     attachmentPaths: [path!],
//     isHTML: false,
//   );
//
//   await FlutterEmailSender.send(email);
// }

// Future<bool> checkFileExists(String savePath) async {
//   final existsStatus = await Directory(savePath).exists();
//   return existsStatus;
//}
