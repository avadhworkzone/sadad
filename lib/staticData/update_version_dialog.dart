import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_store/open_store.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> checkAppVersion(BuildContext context) async {
  UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
  final snapShot = await FirebaseFirestore.instance
      .collection('AppVersion')
      .doc('version')
      .get();
  if (snapShot.exists) {
    final doc = snapShot.data();

    String versionName = "";
    String buildVersion = "";
    int newVersion = 0;
    int currentVersion = int.parse(Functions.appVersion.replaceAll('.', ''));
    if (Platform.isAndroid) {
      if (doc!.containsKey('android')) {
        versionName = doc['android'].toString().replaceAll('.', '');
        // buildVersion = doc['android']['build_version'];
        newVersion = int.parse(versionName);
      }
    } else {
      if (doc!.containsKey('ios')) {
        versionName = doc['ios'].toString().replaceAll('.', '');
        // buildVersion = doc['ios']['build_version'];
        newVersion = int.parse(versionName);
      }
    }
    print('NEW VERSION : $newVersion CURRENT VERSION :$currentVersion');
    if (newVersion > currentVersion) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return WillPopScope(
              onWillPop: () => Future.value(true),
              child: AlertDialog(
                title: Text('Notice'.tr),
                content: Text(
                    'A new version is available. Update the app to continue.'
                        .tr),
                actions: [
                  TextButton(
                      onPressed: () {
                        OpenStore.instance.open(
                            appStoreId: '1644071216', // AppStore id of your app
                            androidAppBundleId:
                                'com.sadadqa.business' // Android app bundle package name
                            );
                      },
                      child: Text('UPDATE'.tr)),
                ],
              ),
            );
          });
    }
  } else {
    FirebaseFirestore.instance.collection('AppVersion').doc('version').set(
        Platform.isAndroid
            ? {
                'android': Functions.appVersion,
              }
            : {'ios': Functions.appVersion},
        SetOptions(merge: true));
  }
}
