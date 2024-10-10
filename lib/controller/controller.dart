import 'package:get/get.dart';

class DashboardController extends GetxController {
  String _accountAmount = 'amount';

  String get accountAmount => _accountAmount;

  set accountAmount(String value) {
    _accountAmount = value;
    update();
  }

  double _totalAmtSales = 0.0;

  double get totalAmtSales => _totalAmtSales;

  set totalAmtSales(double value) {
    _totalAmtSales = value;
    update();
  }

  double _totalAmtRefunds = 0.0;

  double get totalAmtPreAuth => _totalAmtPreAuth;

  set totalAmtPreAuth(double value) {
    _totalAmtPreAuth = value;
    update();
  }

  double _totalAmtPreAuth = 0.0;

  double get totalAmtRefunds => _totalAmtRefunds;

  set totalAmtRefunds(double value) {
    _totalAmtRefunds = value;
    update();
  }

  int _totalCntSales = 0;

  int get totalCntSales => _totalCntSales;

  set totalCntSales(int value) {
    _totalCntSales = value;
    update();
  }

  int _totalCntRefunds = 0;

  int get totalCntRefunds => _totalCntRefunds;

  set totalCntRefunds(int value) {
    _totalCntRefunds = value;
    update();
  }

  int _totalCntPreAuth = 0;

  int get totalCntPreAuth => _totalCntPreAuth;

  set totalCntPreAuth(int value) {
    _totalCntPreAuth = value;
    update();
  }
}
