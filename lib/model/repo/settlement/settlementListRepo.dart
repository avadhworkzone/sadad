import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementPayoutDetailResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlementWithdrawalListResponse.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/settlement/settlemetPayoutListResponseModel.dart';
import 'package:sadad_merchat_app/model/services/api_service.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';

class SettlementWithdrawalListRepo extends BaseService {
  Future<List<SettlementWithdrawalListResponseModel>>
      settlementWithdrawalListRepo({
    String? id,
    String? filter,
    required int start,
  }) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: settlementWithdrawalList +
          '?filter[include][0][userbank]=bank&filter[include][1][payout]=payoutstatus&filter[include][2]=withdrawalrequeststatus&filter[include][3]=user&filter[include][4]=createdby&filter[where][userId]=$id&filter[order]=created DESC&filter[skip]=$start&filter[limit]=10$filter',
      body: {},
    );
    print("settlementWithdrawalList res :$response");
    final settlementWithdrawalListResponseModel = (response as List<dynamic>)
        .map((e) => SettlementWithdrawalListResponseModel.fromJson(e))
        .toList();
    return settlementWithdrawalListResponseModel;
  }
}

class SettlementPayoutListRepo extends BaseService {
  ///settlement Payout
  Future<List<SettlementPayoutListResponseModel>> settlementPayoutListRepo(
      {String? id,
      String? filter,
      required int start,
      required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: settlementPayoutList +
          '?filter[where][userId]=$id&filter[include][0][withdrawalrequest][userbank]=bank&filter[include][1]=payoutstatus&filter[order]=created DESC&filter[skip]=$start&filter[limit]=$end$filter',
      body: {},
    );
    print("settlementPayoutList res :$response");
    final settlementPayoutListResponseModel = (response as List<dynamic>)
        .map((e) => SettlementPayoutListResponseModel.fromJson(e))
        .toList();
    return settlementPayoutListResponseModel;
  }
}

///settlement withdrawal detail
class SettlementWithdrawalDetailRepo extends BaseService {
  Future<SettlementWithdrawalDetailResponseModel>
      settlementWithdrawalDetailRepo({String? id}) async {
    String uId = await encryptedSharedPreferences.getString('id');

    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: settlementWithdrawalList +
          '/$id?filter[include][0][userbank]=bank&filter[include][1][payout]=payoutstatus&filter[include][2]=withdrawalrequeststatus&filter[include][3]=user&filter[include][4]=createdby&filter[where][userId]=$uId&filter[order]=created DESC&filter[skip]=0&filter[limit]=1',
      body: {},
    );
    print("settlementWithdrawalDetail res :$response");
    final settlementWithdrawalDetailResponseModel =
        SettlementWithdrawalDetailResponseModel.fromJson(
            response as Map<String, dynamic>);
    return settlementWithdrawalDetailResponseModel;
  }
}

///activity withdrawal detail
class ActivityWithdrawalDetailRepo extends BaseService {
  Future<SettlementWithdrawalDetailResponseModel> activityWithdrawalDetailRepo(
      {String? id}) async {
    String uId = await encryptedSharedPreferences.getString('id');

    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: settlementWithdrawalList +
          '?filter[where][userId]=${uId}&filter[include][0]=withdrawalrequeststatus&filter[include][1][userbank]=bank&filter[include][2][payout]=payoutstatus&filter[skip]=0&filter[limit]=10&filter[order]=created DESC&filter[include][3]=createdby&filter[where][withdrawnumber]=$id',
      body: {},
    );
    print("settlementWithdrawalDetail res :$response");
    final settlementWithdrawalDetailResponseModel =
        SettlementWithdrawalDetailResponseModel.fromJson(response[0]);
    return settlementWithdrawalDetailResponseModel;
  }
}

///settlement payout detail
class SettlementPayoutDetailRepo extends BaseService {
  Future<SettlementPayoutDetailResponseModel> settlementPayoutDetailRepo(
      {String? id}) async {
    String uIsd = await encryptedSharedPreferences.getString('id');

    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: settlementPayoutList +
          '/$id?filter[where][userId]=$uIsd&filter[where][payoutstatusId][inq][0]=3&filter[where][payoutstatusId][inq][1]=4&filter[include][0][withdrawalrequest][userbank]=bank&filter[include][1]=payoutstatus&filter[order]=created DESC&filter[skip]=0&filter[limit]=1',
      body: {},
    );
    print("settlementPayoutDetail res :$response");
    final settlementPayoutDetailResponseModel =
        SettlementPayoutDetailResponseModel.fromJson(
            response as Map<String, dynamic>);
    return settlementPayoutDetailResponseModel;
  }
}
