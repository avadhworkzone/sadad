// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sadad_merchat_app/controller/controller.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/demo.dart';
import 'package:sadad_merchat_app/language/language%20transaction.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/auth/register/setYourPassword.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/businessDetailsInsertScreen.dart';
import 'package:sadad_merchat_app/view/auth/register/signatureScreen.dart';
import 'package:sadad_merchat_app/view/pos/posTerminalRequestScreen.dart';
import 'package:sadad_merchat_app/view/splash.dart';
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityReport.dart';
import 'package:sadad_merchat_app/viewModel/Activity/activityViewModel.dart';
import 'package:sadad_merchat_app/viewModel/Activity/transferViewModel.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/Auth/loginViewModel.dart';
import 'package:sadad_merchat_app/viewModel/Payment/onlineTransactionViewModel.dart';
import 'package:sadad_merchat_app/viewModel/Payment/reports/reportsDetailViewModel.dart';
import 'package:sadad_merchat_app/viewModel/Payment/transaction/transactionViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/checkInternationalViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/createProductViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/dashBoardViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/invoiceListViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/notificationListViewModel.dart';
import 'package:sadad_merchat_app/viewModel/pos/batch%20Summary/batchSummeryViewModel.dart';
import 'package:sadad_merchat_app/viewModel/pos/posTransactionCountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';
import 'package:sadad_merchat_app/viewModel/settlement/settlementViewModel.dart';
import 'package:sadad_merchat_app/viewModel/uploadImageViewModel.dart';

import 'controller/validation_controller.dart';
import 'util/analytics_service.dart';
import 'viewModel/Payment/product/myproductViewModel.dart';
import 'viewModel/dashboard/createInvoiceViewModel.dart';
import 'viewModel/dashboard/getInvoiceViewModel.dart';
import 'viewModel/more/bank/bankAccountViewModel.dart';
import 'viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'viewModel/more/setting/notificationViewModel.dart';
import 'viewModel/pos/device/deviceViewModel.dart';
import 'viewModel/pos/report/posReportListViewModel.dart';

EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Functions.getAppVersion();
  repeatedCallForVPNCheck();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Intl.defaultLocale = 'en_US';
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("fcc8b82a-48a7-43f7-a26d-6c42f4f212c4");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        locale: const Locale('en'),
        translations: LanguageTranslation(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Color(0xff8E1B3E)),
            titleTextStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: ColorsUtils.white),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: const ColorScheme.light(
              primary: Color(0xff8E1B3E),
              brightness: Brightness.light,
              secondary: Color(0xff8E1B3E)),
          fontFamily: 'OpenSans',
        ),
        navigatorObservers: <NavigatorObserver>[
          AnalyticsService.analyticsObserver
        ],
        home: SplashScreen(),
        // home: SetYourPasswordScreen(),
      ),
    );
  }

  DashboardController dashboardController = Get.put(DashboardController());
  ValidationController validationController = Get.put(ValidationController());
  DashBoardViewModel dashBoardViewModel = Get.put(DashBoardViewModel());
  TransferViewModel transferViewModel = Get.put(TransferViewModel());
  HomeController homeController = Get.put(HomeController());
  AddProductViewModel addProductViewModel = Get.put(AddProductViewModel());
  GetInvoiceViewModel getInvoiceViewModel = Get.put(GetInvoiceViewModel());
  CheckInternationalViewModel checkInternationalViewModel =
      Get.put(CheckInternationalViewModel());
  CreateInvoiceViewModel createInvoiceViewModel =
      Get.put(CreateInvoiceViewModel());
  LoginViewModel loginViewModel = Get.put(LoginViewModel());
  InvoiceListViewModel invoiceListViewModel = Get.put(InvoiceListViewModel());
  UploadImageViewModel uploadImageViewModel = Get.put(UploadImageViewModel());
  OnlineTransactionViewModel onlineTransactionViewModel =
      Get.put(OnlineTransactionViewModel());
  MyProductListViewModel myProductListViewModel =
      Get.put(MyProductListViewModel());
  TransactionViewModel transactionViewModel = Get.put(TransactionViewModel());
  TerminalViewModel terminalViewModel = Get.put(TerminalViewModel());
  DeviceViewModel deviceViewModel = Get.put(DeviceViewModel());
  ActivityViewModel activityViewModel = Get.put(ActivityViewModel());
  PosTransactionViewModel posTransactionViewModel =
      Get.put(PosTransactionViewModel());
  ReportDetailViewModel reportDetailViewModel =
      Get.put(ReportDetailViewModel());
  PosReportDetailViewModel posReportDetailViewModel =
      Get.put(PosReportDetailViewModel());
  PosTransactionCountViewModel posTransactionCountViewModel =
      Get.put(PosTransactionCountViewModel());
  SettlementWithdrawalListViewModel settlementWithdrawalListViewModel =
      Get.put(SettlementWithdrawalListViewModel());
  BankAccountViewModel bankAccountViewModel = Get.put(BankAccountViewModel());
  BusinessInfoViewModel businessInfoViewModel =
      Get.put(BusinessInfoViewModel());
  NotificationViewModel notificationViewModel =
      Get.put(NotificationViewModel());
  NotificationListViewModel notificationListViewModel =
      Get.put(NotificationListViewModel());
  ConnectivityViewModel connectivityViewModel =
      Get.put(ConnectivityViewModel());
  ActivityReportViewModel activityReportViewModel =
      Get.put(ActivityReportViewModel());
  BatchSummeryViewModel batchSummeryViewModel =
      Get.put(BatchSummeryViewModel());
}
