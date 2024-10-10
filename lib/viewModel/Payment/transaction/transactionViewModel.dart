import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/reports/onlineTransactionReportResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/disputesCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/productScreen/transaction/transactionCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/disputeTransactionResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/refundTransactionResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/transactionDetailModel.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/transactionListResponseModel.dart';
import '../../../model/repo/payment/transaction/refundTransactionRepo.dart';
import '../../../model/repo/payment/transaction/transactionDetailRepo.dart';
import '../../../model/repo/payment/transaction/transactionListRepo.dart';

class TransactionViewModel extends GetxController {
  ApiResponse transactionListApiResponse = ApiResponse.initial('Initial');
  ApiResponse transactionDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse transactionCountApiResponse = ApiResponse.initial('Initial');
  ApiResponse disputesCountApiResponse = ApiResponse.initial('Initial');
  ApiResponse transactionReportApiResponse = ApiResponse.initial('Initial');
  ApiResponse transactionRefundDetailApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse disputeTransactionListApiResponse =
      ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;

  int dstartPosition = 0;
  int dendPosition = 10;
  String countOfTransaction = '';
  bool isPaginationLoading = false;
  List<TransactionListResponseModel> response = [];
  List<DisputeTransactionResponseModel> dResponse = [];
  List<OnlineTransReportData> reportTransactionResponse = [];
  void setTransactionInit() {
    transactionListApiResponse = ApiResponse.initial('Initial');
    disputeTransactionListApiResponse = ApiResponse.initial('Initial');
    transactionDetailApiResponse = ApiResponse.initial('initial');
    transactionRefundDetailApiResponse = ApiResponse.initial('initial');
    transactionCountApiResponse = ApiResponse.initial('initial');
    disputesCountApiResponse = ApiResponse.initial('initial');
    transactionReportApiResponse = ApiResponse.initial('initial');
    startPosition = 0;
    endPosition = 10;
    dstartPosition = 0;
    dendPosition = 10;
    isPaginationLoading = false;
    response.clear();
    dResponse.clear();
    reportTransactionResponse.clear();
  }

  void clearResponseList() {
    response.clear();
    dResponse.clear();
    reportTransactionResponse.clear();
    startPosition = 0;
    endPosition = 10;
    dstartPosition = 0;
    dendPosition = 10;
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  /// transaction All List...

  Future<void> transactionList(
      {String? id,
      String? filter,
      String? transactionStatus,
      String? include}) async {
    if (transactionListApiResponse.status != Status.COMPLETE) {
      transactionListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<TransactionListResponseModel> res = await TransactionListRepo()
          .transactionListRepo(
              start: startPosition,
              end: endPosition,
              id: id,
              filter: filter,
              include: include,
              transactionStatus: transactionStatus);
      print('res pos ${response.length}');
      response.addAll(res);
      transactionListApiResponse = ApiResponse.complete(response);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("transactionListApiResponse RES:$response");
    } catch (e) {
      setIsPaginationLoading(false);
      print('transactionListApiResponse.....$e');
      transactionListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///transaction report
  Future<void> transactionReportList({
    bool? fromSearch = false,
    String? filter,
  }) async {
    if (transactionReportApiResponse.status != Status.COMPLETE) {
      transactionReportApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      OnlineTransactionReportResponse res =
          await TransactionReportListRepo().transactionReportListRepo(
        start: startPosition,
        end: endPosition,
        filter: filter,
      );
      print('res pos ${response.length}');
      countOfTransaction = res.count.toString();
      if (fromSearch == true) {
        reportTransactionResponse.clear();
        startPosition = 0;
      }
      reportTransactionResponse.addAll(res.data!);
      transactionReportApiResponse =
          ApiResponse.complete(reportTransactionResponse);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("transactionReportApiResponse RES:$reportTransactionResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('transactionReportApiResponse.....$e');
      transactionReportApiResponse = ApiResponse.error('error');
    }
    update();
  }

  Future<void> disputeTransactionList(
      {String? id,
      String? filter,
      String? transactionStatus,
      String? include}) async {
    if (disputeTransactionListApiResponse.status != Status.COMPLETE) {
      disputeTransactionListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);
    try {
      List<DisputeTransactionResponseModel> dRes =
          await DisputeTransactionListRepo().disputeTransactionListRepo(
              start: dstartPosition,
              end: dendPosition,
              id: id,
              filter: filter,
              include: include,
              transactionStatus: transactionStatus);
      print('res pos ${dResponse.length}');
      dResponse.addAll(dRes);
      disputeTransactionListApiResponse = ApiResponse.complete(dResponse);
      dstartPosition += 10;
      dendPosition += 10;
      setIsPaginationLoading(false);
      print("disputeTransactionListApiResponse RES:$dResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('disputeTransactionListApiResponse.....$e');
      disputeTransactionListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///payment transaction detail

  Future<void> transactionDetail(String id) async {
    transactionDetailApiResponse = ApiResponse.loading('Loading');
    try {
      TransactionDetailResponseModel transactionDetailRes =
          await TransactionDetailRepo().transactionDetailRepo(id);
      transactionDetailApiResponse = ApiResponse.complete(transactionDetailRes);
      print("transactionDetailApiResponse RES:$transactionDetailRes");
    } catch (e) {
      print('transactionDetailApiResponse.....$e');
      transactionDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///activity transaction detail

  Future<void> activityTransactionDetail(String id, String invoice) async {
    transactionDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      List<TransactionDetailResponseModel> transactionDetailRes =
          await ActivityTransactionDetailRepo()
              .activityTransactionDetailRepo(id, invoice);
      transactionDetailApiResponse = ApiResponse.complete(transactionDetailRes);
      print("transactionDetailApiResponse RES:$transactionDetailRes");
    } catch (e) {
      print('transactionDetailApiResponse.....$e');
      transactionDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///refund Transaction detail
  Future<void> refundTransactionDetail(String id) async {
    transactionRefundDetailApiResponse = ApiResponse.loading('Loading');
    try {
      TransactionRefundDetailResponseModel transactionRefundDetailRes =
          await RefundTransactionDetailRepo().refundTransactionDetailRepo(id);
      transactionRefundDetailApiResponse =
          ApiResponse.complete(transactionRefundDetailRes);
      print(
          "transactionRefundDetailApiResponse RES:$transactionRefundDetailRes");
    } catch (e) {
      print('transactionRefundDetailApiResponse.....$e');
      transactionRefundDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///transaction count
  Future<void> transactionCount({String? id, String? transactionStatus}) async {
    transactionCountApiResponse = ApiResponse.loading('Loading');
    try {
      TransactionCountResponseModel countResponse = await TransactionCountRepo()
          .transactionCountRepo(id: id, transactionStatus: transactionStatus);
      transactionCountApiResponse = ApiResponse.complete(countResponse);
      print("transactionCountApiResponse RES:$countResponse");
    } catch (e) {
      print('transactionCountApiResponse.....$e');
      transactionCountApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///disputes count
  Future<void> disputesCount({String? id, String? transactionStatus}) async {
    disputesCountApiResponse = ApiResponse.loading('Loading');
    try {
      DisputesCountResponseModel dcountResponse = await DisputesCountRepo()
          .disputesCountRepo(id: id, transactionStatus: transactionStatus);
      disputesCountApiResponse = ApiResponse.complete(dcountResponse);
      print("disputesCountApiResponse RES:$dcountResponse");
    } catch (e) {
      print('disputesCountApiResponse.....$e');
      disputesCountApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
