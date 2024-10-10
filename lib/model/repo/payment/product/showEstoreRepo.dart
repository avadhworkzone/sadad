import 'package:sadad_merchat_app/model/apimodels/requestmodel/store/showStoreRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/showStoreResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

import '../../../apimodels/requestmodel/store/showEstoreRequestModel.dart';
import '../../../apimodels/responseModel/productScreen/product/showInEstoreResponseModel.dart';

class ShowEStoreRepo extends BaseService {
  Future<ShowStoreResponseModel> showEStoreRepo(
      String id, ShowStoreRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPatch,
      url: productList + "/" + id,
      body: body,
    );
    print('Response e store Data :::$response');
    ShowStoreResponseModel showEStoreResponseModel =
        ShowStoreResponseModel.fromJson(response as Map<String, dynamic>);
    return showEStoreResponseModel;
  }
}
