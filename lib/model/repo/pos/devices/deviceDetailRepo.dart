import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class DeviceDetailRepo extends BaseService {
  Future<List<DeviceDetailResponseModel>> deviceDetailRepo({String? id}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posDevices +
          '?filter[skip]=0&filter[limit]=1&filter[where][deviceId]=$id&filter[order]=created DESC&filter[include][terminal]=rentalPlan',
      body: {},
    );
    print("deviceDetail res :$response");
    final deviceDetailResponseModel = (response as List<dynamic>)
        .map((e) => DeviceDetailResponseModel.fromJson(e))
        .toList();
    return deviceDetailResponseModel;
  }
}
