import 'dart:developer';

import 'package:sadad_merchat_app/model/services/api_service.dart';

import '../../../apimodels/responseModel/productScreen/transaction/transactionDetailModel.dart';
import '../../../services/base_service.dart';

class TransactionDetailRepo extends BaseService {
  Future<TransactionDetailResponseModel> transactionDetailRepo(
      String id) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: transactionList +
          '/$id?filter={"include": ["senderId", "receiverId", "guestuser", "transactionentity", "transactionmode", "transactionstatus", "postransaction", "dispute"]}',
      body: {},
    );
    log("TransactionDetail res :$response");
    final transactionDetailResponseModel =
        TransactionDetailResponseModel.fromJson(
            response as Map<String, dynamic>);
    return transactionDetailResponseModel;
  }
}

class ActivityTransactionDetailRepo extends BaseService {
  Future<List<TransactionDetailResponseModel>> activityTransactionDetailRepo(
      String id, String invoice) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: transactionList +
          '?filter={"where":{"and":[{"or":[{"senderId":$id},{"receiverId":$id}]},{"invoicenumber":"$invoice"}]},"skip":0,"limit":10,"order":"created DESC","include":["senderId","receiverId","guestuser","transactionentity","transactionmode","transactionstatus","postransaction","dispute"]}',
      // '?filter={"where":{"and":[{"or":[{"senderId":{{$id}}},{"receiverId":{{$id}}}]},{"invoicenumber":"$invoice"}]},"skip":0,"limit":10,"order":"created DESC","include":["senderId","receiverId","guestuser","transactionentity","transactionmode","transactionstatus","postransaction","dispute"]}',
      body: {},
    );
    log("TransactionDetail res :$response");
    final transactionDetailResponseModel = (response as List<dynamic>)
        .map((e) => TransactionDetailResponseModel.fromJson(e))
        .toList();
    // final transactionDetailResponseModel =
    //     TransactionDetailResponseModel.fromJson(
    //         response[0] as Map<String, dynamic>);
    return transactionDetailResponseModel;
  }
}
