import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver analyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  /// FIREBASE LOG EVENTS.................................................................
  static Future<void> sendAppEnterEvent() async {
    await analytics.logAppOpen();
  }

  static Future<void> sendAppCurrentScreen(String screenName) async {
    final screen = screenName;
    await analytics.setCurrentScreen(screenName: screen);
  }

  static Future<void> sendLoginEvent(String id) async {
    await analytics.logLogin(loginMethod: 'Login Id : $id');
  }

  static Future<void> sendUserProperty(String id) async {
    await analytics.setUserProperty(name: 'login_id', value: id);
  }

  static Future<void> sendEvent(
      String name, Map<String, dynamic> params) async {
    final eventName = name;
    debugPrint("EventName : $eventName");
    await analytics
        .logEvent(
          name: eventName,
          parameters: params,
        )
        .then((value) => () {
              debugPrint("$eventName success");
            })
        .catchError((onError) {
      debugPrint("EventName catchError ${onError} ");
    });
    print('EVENT  succeeded');
  }
}
