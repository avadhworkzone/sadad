import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/editInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/createInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/getInvoiceResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/createInvoiceRepo.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/editInvoiceRepo.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/invoice/getInvoiceRepo.dart';

class GetInvoiceViewModel extends GetxController {
  ApiResponse getInvoiceApiResponse = ApiResponse.initial('Initial');
  ApiResponse editInvoiceApiResponse = ApiResponse.initial('Initial');
  void setInit() {
    getInvoiceApiResponse = ApiResponse.initial('Initial');
    editInvoiceApiResponse = ApiResponse.initial('Initial');
  }

  /// GetInvoice...
  Future<void> getInvoice(String id) async {
    getInvoiceApiResponse = ApiResponse.loading('Loading');
    try {
      GetInvoiceResponseModel response =
          await GetInvoiceRepo().getInvoiceRepo(id);
      getInvoiceApiResponse = ApiResponse.complete(response);
      print("getInvoiceApiResponse RES:$response");
    } catch (e) {
      print('getInvoiceApiResponse.....$e');
      getInvoiceApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///EditInvoice
  Future<void> editInvoice(String id, EditInvoiceRequestModel model) async {
    editInvoiceApiResponse = ApiResponse.loading('Loading');
    try {
      GetInvoiceResponseModel response =
          await EditInvoiceRepo().editInvoiceRepo(id, model);
      editInvoiceApiResponse = ApiResponse.complete(response);
      print("editInvoiceApiResponse RES:$response");
    } catch (e) {
      print('editInvoiceApiResponse.....$e');
      editInvoiceApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
