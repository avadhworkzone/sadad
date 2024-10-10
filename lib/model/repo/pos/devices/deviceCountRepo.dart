import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/device/deviceCountResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class DeviceCountRepo extends BaseService {
  Future<DeviceCountResponseModel> deviceCountRepo(String filter) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posDevices + '/count$filter',
      body: {},
    );
    print("DeviceCountRes res :$response");
    DeviceCountResponseModel deviceCountResponseModel =
        DeviceCountResponseModel.fromJson(response as Map<String, dynamic>);
    return deviceCountResponseModel;
  }
}
