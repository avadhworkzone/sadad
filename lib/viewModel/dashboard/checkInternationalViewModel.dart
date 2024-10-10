import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/Dashboard/checkInternationalRepo.dart';
import '../../model/apimodels/responseModel/DashBoard/invoice/checkInternationalResponseModel.dart';

class CheckInternationalViewModel extends GetxController {
  ApiResponse checkInternationalApiResponse = ApiResponse.initial('Initial');

  /// CheckInternational...
  Future<void> checkInternational(String id) async {
    checkInternationalApiResponse = ApiResponse.loading('Loading');
    // update();
    try {
      List<CheckInternationalResponseModel> response =
          await CheckInternationalRepo().checkInternationalRepo(id);
      checkInternationalApiResponse = ApiResponse.complete(response);
      print("checkInternationalApiResponse RES:$response");
    } catch (e) {
      print('checkInternationalApiResponse.....$e');
      checkInternationalApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
