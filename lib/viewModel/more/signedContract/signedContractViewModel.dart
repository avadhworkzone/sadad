import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/more/signedContract/singedContractRepo.dart';
import '../../../model/apimodels/responseModel/more/singedContractListModel.dart';
import '../../../model/apimodels/responseModel/productScreen/order/orderListResponseModel.dart';
import '../../../model/repo/payment/order/orderListRepo.dart';


class SignedContractListViewModel extends GetxController {

  ApiResponse signerContractApiResponse = ApiResponse.initial('Initial');

  RxString storeProduct = 'All'.obs;

  List<SignedContractListModel> oLResponse = [];

  /// orderList...
  Future<void> signerContractList(String id) async {
    if (signerContractApiResponse.status != Status.COMPLETE) {
      signerContractApiResponse = ApiResponse.loading('Loading');
    }
    try {
      List<SignedContractListModel> oLRes = await SignedContractListRepo().signedContractListRepo(id);
      print('res pos ${oLResponse.length}');
      oLResponse.addAll(oLRes);
      signerContractApiResponse = ApiResponse.complete(oLResponse);

      print("orderListApiResponse RES:$oLResponse");
    } catch (e) {
      print('orderListApiResponse.....$e');
      signerContractApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
