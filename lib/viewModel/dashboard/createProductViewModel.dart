import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/addProductResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/addProductRepo.dart';

class AddProductViewModel extends GetxController {
  ApiResponse addProductApiResponse = ApiResponse.initial('Initial');
  void setInit() {
    addProductApiResponse = ApiResponse.initial('Initial');
  }

  ///add product view model
  Future<void> addProduct(String id, String key, String name) async {
    addProductApiResponse = ApiResponse.loading('Loading');
    try {
      List<AddProductsResponseModel> response =
          await AddProductRepo().addProductRepo(id, key, name);
      addProductApiResponse = ApiResponse.complete(response);
      print("addProductApiResponse RES:$response");
    } catch (e) {
      print('addProductApiResponse.....$e');
      addProductApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
