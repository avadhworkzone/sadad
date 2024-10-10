// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class PosRentalRepo extends BaseService {
  Future<PosRentalResponseModel> posRentalListRepo(
      {String? filter, required int start, required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: posRental +
          '?filter[skip]=$start&filter[limit]=10&filter[order]=created DESC$filter',
      body: {},
    );
    print("rental list res :$response");
    // final posRentalResponseModel = (response as List<dynamic>)
    //     .map((e) => PosRentalResponseModel.fromJson(e))
    //     .toList();
    final posRentalResponseModel =
        PosRentalResponseModel.fromJson(response as Map<String, dynamic>);
    return posRentalResponseModel;
  }
}
