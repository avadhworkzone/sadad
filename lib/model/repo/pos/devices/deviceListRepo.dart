import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceListResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/terminal/terminalListResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class DeviceListRepo extends BaseService {
  Future<List<DeviceListResponseModel>> deviceListRepo(
      {required int start, required int end, String? filter}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posDevices +
          '?filter[skip]=$start&filter[limit]=$end&filter[order]=created DESC&filter[include][terminal]=rentalPlan$filter',
      body: {},
    );
    print("deviceList res :$response");
    final deviceListRes = (response as List<dynamic>)
        .map((e) => DeviceListResponseModel.fromJson(e))
        .toList();
    return deviceListRes;
  }
}
