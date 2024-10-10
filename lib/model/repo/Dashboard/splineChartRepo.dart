// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';

import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/PoSplineChartResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/chart/splineChartResponseModel.dart';

import '../../services/api_service.dart';
import '../../services/base_service.dart';

class SplineChartRepo extends BaseService {
  Future<SplineChartResponseModel> splineChartRepo(String time) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: splineChart + '?filter[date]=$time',
      body: {},
    );
    log("splineChart res :$response");
    SplineChartResponseModel splineChartResponseModel =
        SplineChartResponseModel.fromJson(response as Map<String, dynamic>);
    return splineChartResponseModel;
  }

  Future<PosSplineChartResponseModel> posSplineChartRepo(String time) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: splineChart + '?filter[date]=$time&isPosTransaction=true',
      body: {},
    );
    log("splineChart res :$response");
    PosSplineChartResponseModel splineChartResponseModel =
        PosSplineChartResponseModel.fromJson(response as Map<String, dynamic>);
    return splineChartResponseModel;
  }
}
