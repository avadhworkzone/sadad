// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:developer';
import 'dart:math';

import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/onlineTransactionReportResponseModel.dart';

import '../../../../staticData/utility.dart';
import '../../../apimodels/responseModel/DashBoard/invoice/invoiceListAllResponseModel.dart';
import '../../../apimodels/responseModel/productScreen/order/orderListResponseModel.dart';
import '../../../apimodels/responseModel/productScreen/transaction/disputeTransactionResponseModel.dart';
import '../../../apimodels/responseModel/productScreen/transaction/disputesCountResponseModel.dart';
import '../../../apimodels/responseModel/productScreen/transaction/transactionCountResponseModel.dart';
import '../../../apimodels/responseModel/productScreen/transaction/transactionListResponseModel.dart';
import '../../../services/api_service.dart';
import '../../../services/base_service.dart';

class TransactionListRepo extends BaseService {
  Future<List<TransactionListResponseModel>> transactionListRepo(
      {String? id,
      String? transactionStatus,
      String? filter,
      String? include,
      required int start,
      required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: transactionList +
          '?filter={"where":{"and":[{"or":[{"senderId":$id},{"receiverId":$id}]}$transactionStatus"skip":"$start","limit":"10","order":"$filter","include": $include',
      body: {},
    );
    print("transactionsList res :$response");
    final transactionListResponseModel = (response as List<dynamic>)
        .map((e) => TransactionListResponseModel.fromJson(e))
        .toList();
    return transactionListResponseModel;
  }
}

class TransactionReportListRepo extends BaseService {
  Future<OnlineTransactionReportResponse> transactionReportListRepo(
      {String? filter, required int start, required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: transactionOnlineReportList +
          '?filter[skip]=$start&filter[limit]=10&filter[order]=created DESC$filter',
      // '?filter={"where":{"and":[{"or":[{"senderId":$id},{"receiverId":$id}]}$transactionStatus"skip":"$start","limit":"10","order":"$filter","include": $include',
      body: {},
    );
    print("transactionOnlineReportList res :$response");
    OnlineTransactionReportResponse transactionReportResponse =
        OnlineTransactionReportResponse.fromJson(response);
    return transactionReportResponse;
  }
}

class DisputeTransactionListRepo extends BaseService {
  Future<List<DisputeTransactionResponseModel>> disputeTransactionListRepo(
      {String? id,
      String? transactionStatus,
      String? filter,
      String? include,
      required int start,
      required int end}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: disputes +
          '?filter={"where":{"and":[{"or":[{"senderId":$id},{"receiverId":$id}]}$transactionStatus"skip":"$start","limit":"$end","order":"$filter","include": $include',
      body: {},
    );
    print("DisputeTransactionsList res :$response");
    final disputeTransactionResponseModel = (response as List<dynamic>)
        .map((e) => DisputeTransactionResponseModel.fromJson(e))
        .toList();
    return disputeTransactionResponseModel;
  }
}

class TransactionCountRepo extends BaseService {
  Future<TransactionCountResponseModel> transactionCountRepo(
      {String? id, String? transactionStatus}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: transactionCount +
          '?where={ "and": [{"or":[{"senderId":$id},{ "receiverId":$id}]}$transactionStatus',
      body: {},
    );
    print("transactionCount res :$response");
    TransactionCountResponseModel transactionCountResponseModel =
        TransactionCountResponseModel.fromJson(response);
    return transactionCountResponseModel;
  }
}

class DisputesCountRepo extends BaseService {
  Future<DisputesCountResponseModel> disputesCountRepo(
      {String? id, String? transactionStatus}) async {
    var response = await ApiService().getResponse(
      apiType: APIType.aGet,
      url: '$disputes/count' +
          '?where={ "and": [{"or":[{"senderId":$id},{ "receiverId":$id}]}$transactionStatus',
      body: {},
    );
    print("disputesCount res :$response");
    DisputesCountResponseModel disputesCountResponseModel =
        DisputesCountResponseModel.fromJson(response);
    return disputesCountResponseModel;
  }
}
