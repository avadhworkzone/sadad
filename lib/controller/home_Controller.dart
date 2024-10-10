import 'package:get/get.dart';

class HomeController extends GetxController {
  // RxInt bottomIndex = 0.obs;

  int _bottomIndex = 0;

  int get bottomIndex => _bottomIndex;

  set bottomIndex(int value) {
    _bottomIndex = value;
    update();
  }

  set initBottomIndex(int value) {
    _bottomIndex = value;
  }
}
