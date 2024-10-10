import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/pos/devices/deviceCountRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/devices/deviceDetailRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/devices/deviceListRepo.dart';

class DeviceViewModel extends GetxController {
  ApiResponse deviceListApiResponse = ApiResponse.initial('Initial');
  ApiResponse deviceDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse deviceCountApiResponse = ApiResponse.initial('Initial');
  int startPosition = 0;
  int endPosition = 10;
  bool isPaginationLoading = false;
  List<DeviceListResponseModel> deviceListRes = [];

  void setDeviceInit() {
    deviceListApiResponse = ApiResponse.initial('Initial');
    deviceDetailApiResponse = ApiResponse.initial('Initial');
    deviceCountApiResponse = ApiResponse.initial('Initial');
    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    deviceListRes.clear();
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  void clearResponseList() {
    deviceListRes.clear();
    startPosition = 0;
    endPosition = 10;
  }

  ///deviceList
  Future<void> deviceList({String? filter, bool isLoading = false}) async {
    if (deviceListApiResponse.status != Status.COMPLETE || isLoading == true) {
      deviceListApiResponse = ApiResponse.loading('Loading');
    }
    // setIsPaginationLoading(true);

    try {
      List<DeviceListResponseModel> deviceListResModel = await DeviceListRepo()
          .deviceListRepo(
              start: startPosition, end: endPosition, filter: filter);
      deviceListRes.addAll(deviceListResModel);
      deviceListApiResponse = ApiResponse.complete(deviceListRes);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("deviceListApiResponse RES:$deviceListRes");
    } catch (e) {
      setIsPaginationLoading(false);
      print('deviceListApiResponse.....$e');
      deviceListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///deviceDetail

  Future<void> deviceDetail({String? id}) async {
    deviceDetailApiResponse = ApiResponse.loading('Loading');
    try {
      List<DeviceDetailResponseModel> res =
          await DeviceDetailRepo().deviceDetailRepo(id: id);
      deviceDetailApiResponse = ApiResponse.complete(res);
      print("deviceDetailApiResponse RES:$res");
    } catch (e) {
      print('deviceDetailApiResponse.....$e');
      deviceDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///device count

  Future<void> deviceCount({String? filter}) async {
    deviceCountApiResponse = ApiResponse.loading('Loading');
    try {
      DeviceCountResponseModel countRes =
          await DeviceCountRepo().deviceCountRepo(filter!);
      deviceCountApiResponse = ApiResponse.complete(countRes);
      print("deviceCountApiResponse RES:$countRes");
    } catch (e) {
      print('deviceCountApiResponse.....$e');
      deviceCountApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
