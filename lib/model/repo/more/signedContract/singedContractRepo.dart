import '../../../apimodels/responseModel/more/singedContractListModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';


class SignedContractListRepo extends BaseService {
  Future<List<SignedContractListModel>> signedContractListRepo(String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: marchantAgreements +
          '?filter[where][userId]=$id&filter[order]=type asc',
      body: {},
    );
    print("signed contract res :$response");
    final signedContractListModel = (response as List<dynamic>)
        .map((e) => SignedContractListModel.fromJson(e))
        .toList();
    return signedContractListModel;
  }
}
