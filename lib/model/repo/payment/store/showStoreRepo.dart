import 'package:sadad_merchat_app/model/apimodels/requestmodel/store/showStoreRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/store/showStoreResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class ShowStoreRepo extends BaseService {
  Future<ShowStoreResponseModel> showStoreRepo(
      String id, DisplayPanelProductRequestModel model) async {
    Map<String, dynamic> body = model.toJson();
    var response = await ApiService().getResponse(
      apiType: APIType.aPatch,
      url: productList + "/" + id,
      body: body,
    );
    print('Response e store Data :::$response');
    ShowStoreResponseModel showStoreResponseModel =
        ShowStoreResponseModel.fromJson(response as Map<String, dynamic>);
    return showStoreResponseModel;
  }
}
