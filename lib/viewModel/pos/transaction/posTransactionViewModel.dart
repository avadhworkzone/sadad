import 'dart:developer';

import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/report/posPaymentReportTransactionResModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentCountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/posPaymentDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/payment/pospaymentResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/refund/posRefundDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/rental/posRentalResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/model/repo/pos/report/posTransactionReportRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/PosRefundDetailRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/paymentDetailRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/paymentRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/posDisputeCountRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/posDisputeRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/posDisputeTransactionRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/posPaymentCountRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/posRentalDetailRepo.dart';
import 'package:sadad_merchat_app/model/repo/pos/transaction/paymentRepo/posRentalTransactionRepo.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/disputeTransactionResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/refundTransactionResponseModel.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/transactionDetailModel.dart';
import '../../../model/apimodels/responseModel/productScreen/transaction/transactionListResponseModel.dart';
import '../../../model/repo/payment/transaction/refundTransactionRepo.dart';
import '../../../model/repo/payment/transaction/transactionDetailRepo.dart';
import '../../../model/repo/payment/transaction/transactionListRepo.dart';

class PosTransactionViewModel extends GetxController {
  ApiResponse posPaymentListApiResponse = ApiResponse.initial('Initial');
  ApiResponse posPaymentReportListApiResponse = ApiResponse.initial('Initial');
  ApiResponse posPaymentDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse posDisputesListApiResponse = ApiResponse.initial('Initial');
  ApiResponse posRentalListApiResponse = ApiResponse.initial('Initial');
  ApiResponse posRefundDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse posDisputeDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse posRentalDetailApiResponse = ApiResponse.initial('Initial');
  ApiResponse activityPosRentalDetailApiResponse =
      ApiResponse.initial('Initial');
  ApiResponse posPaymentCountApiResponse = ApiResponse.initial('Initial');
  ApiResponse posDisputeCountApiResponse = ApiResponse.initial('Initial');

  int startPosition = 0;
  int endPosition = 10;
  bool isPaginationLoading = false;
  List<PosPaymentResponseModel> paymentResponse = [];
  List<PosPaymentReportResponseModel> paymentReportResponse = [];
  List<PosDisputesResponseModel> disputesResponse = [];
  List<PosInvoice> rentalResponse = [];

  void setTransactionInit() {
    posPaymentListApiResponse = ApiResponse.initial('Initial');
    posPaymentReportListApiResponse = ApiResponse.initial('Initial');
    posDisputeDetailApiResponse = ApiResponse.initial('Initial');
    posPaymentDetailApiResponse = ApiResponse.initial('Initial');
    posDisputesListApiResponse = ApiResponse.initial('Initial');
    posRentalListApiResponse = ApiResponse.initial('Initial');
    posRefundDetailApiResponse = ApiResponse.initial('Initial');
    posRentalDetailApiResponse = ApiResponse.initial('Initial');
    posPaymentCountApiResponse = ApiResponse.initial('Initial');
    posDisputeCountApiResponse = ApiResponse.initial('Initial');
    activityPosRentalDetailApiResponse = ApiResponse.initial('Initial');

    startPosition = 0;
    endPosition = 10;
    isPaginationLoading = false;
    paymentResponse.clear();
    paymentReportResponse.clear();
    disputesResponse.clear();
    rentalResponse.clear();
  }

  void clearResponseList() {
    paymentResponse.clear();
    paymentReportResponse.clear();
    disputesResponse.clear();
    rentalResponse.clear();
    startPosition = 0;
    endPosition = 10;
  }

  void setIsPaginationLoading(bool status) {
    isPaginationLoading = status;
    update();
  }

  /// payment List...

  Future<void> paymentList(
      {String? id,
      bool? fromSearch = false,
      String? transactionEntityId,
      String? transactionStatus,
      String terminalFilter = '',
      String? include,
      bool isLoading = false}) async {
    if (posPaymentListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      posPaymentListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<PosPaymentResponseModel> pRes =
          await PosTransactionListRepo().posPaymentListRepo(
        start: startPosition,
        end: endPosition,
        include: include,
        transactionEntityId: transactionEntityId,
        terminalFilter: terminalFilter,
        transactionStatus: transactionStatus,
        id: id,
      );
      print('res pos ${paymentResponse.length}');
      if (fromSearch == true) {
        paymentResponse.clear();
        startPosition = 0;
      }
      paymentResponse.addAll(pRes);
      posPaymentListApiResponse = ApiResponse.complete(paymentResponse);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("posPaymentListApiResponse RES:$paymentResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('posPaymentListApiResponse.....$e');
      posPaymentListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///Payment List Report

  Future<void> paymentListReport(
      {String? id,
      bool? fromSearch = false,
      String? transactionEntityId,
      String? transactionStatus,
      String terminalFilter = '',
      String transactionType = '',
      String? include,
      bool isLoading = false}) async {
    if (posPaymentReportListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      posPaymentReportListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      PosPaymentReportTransactionResModel pRes =
          await PosTransactionReportRepo().posPaymentReportListRepo(
        start: startPosition,
        include: include,
        transactionEntityId: transactionEntityId,
        terminalFilter: terminalFilter,
        transactionStatus: transactionStatus,
        transactionType: transactionType,
        id: id,
      );
      print('res pos ${paymentReportResponse.length}');
      if (fromSearch == true) {
        paymentReportResponse.clear();
        startPosition = 0;
      }
      paymentReportResponse.addAll(pRes.data!);
      posPaymentReportListApiResponse =
          ApiResponse.complete(paymentReportResponse);
      startPosition += 10;

      setIsPaginationLoading(false);
      print("posPaymentReportListApiResponse RES:$paymentReportResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('posPaymentReportListApiResponse.....$e');
      posPaymentReportListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///disputes list

  Future<void> disputesList(
      {String? id,
      bool? fromSearch = false,
      String? transactionEntityId,
      String? transactionStatus,
      String terminalFilter = '',
      String? include,
      bool isLoading = false}) async {
    if (posDisputesListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      posDisputesListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      List<PosDisputesResponseModel> dRes =
          await PosDisputesRepo().posDisputesListRepo(
        start: startPosition,
        end: endPosition,
        include: include,
        terminalFilter: terminalFilter,
        transactionEntityId: transactionEntityId,
        transactionStatus: transactionStatus,
        id: id,
      );
      print('res pos ${disputesResponse.length}');
      if (fromSearch == true) {
        disputesResponse.clear();
        startPosition = 0;
      }
      disputesResponse.addAll(dRes);
      posDisputesListApiResponse = ApiResponse.complete(disputesResponse);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("posDisputesListApiResponse RES:$disputesResponse");
    } catch (e) {
      setIsPaginationLoading(false);
      print('posDisputesListApiResponse.....$e');
      posDisputesListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///pos rental

  Future<void> rentalList(
      {bool isLoading = false,
      String? filter,
      bool? fromSearch = false}) async {
    if (posRentalListApiResponse.status != Status.COMPLETE ||
        isLoading == true) {
      posRentalListApiResponse = ApiResponse.loading('Loading');
    }
    setIsPaginationLoading(true);

    try {
      PosRentalResponseModel rRes = await PosRentalRepo().posRentalListRepo(
          start: startPosition, end: endPosition, filter: filter);
      print('res pos ${rentalResponse.length}');
      if (fromSearch == true) {
        rentalResponse.clear();
        startPosition = 0;
      }
      rentalResponse.addAll(rRes.invoices!);
      posRentalListApiResponse = ApiResponse.complete(rRes);
      startPosition += 10;
      endPosition += 10;
      setIsPaginationLoading(false);
      print("posRentalListApiResponse RES:$rRes");
    } catch (e) {
      setIsPaginationLoading(false);
      print('posRentalListApiResponse.....$e');
      posRentalListApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///pos payment detail

  Future<void> paymentDetail({
    String? id,
    String? userId,
  }) async {
    posPaymentDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      PosPaymentDetailResponseModel paymentDetailRes =
          await PosPaymentDetailRepo().posPaymentDetailRepo(
        start: 0,
        end: 1,
        userId: userId,
        id: id,
      );
      posPaymentDetailApiResponse = ApiResponse.complete(paymentDetailRes);
      print("posPaymentDetailApiResponse RES:$paymentDetailRes");
    } catch (e) {
      print('posPaymentDetailApiResponse.....$e');
      posPaymentDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///pos refund detail

  Future<void> refundDetail({
    String? id,
    String? userId,
  }) async {
    posRefundDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      PosRefundDetailResponseModel refundDetailRes =
          await PosRefundDetailRepo().posRefundDetailRepo(
        start: 0,
        end: 1,
        userId: userId,
        id: id,
      );
      posRefundDetailApiResponse = ApiResponse.complete(refundDetailRes);
      log("posRefundDetailApiResponse RES:$refundDetailRes");
    } catch (e) {
      log('posRefundDetailApiResponse.....$e');
      posRefundDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///pos dispute detail

  Future<void> disputeDetail({
    String? id,
    String? userId,
  }) async {
    posDisputeDetailApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      List<PosDisputesDetailResponseModel> disputeDetailRes =
          await PosDisputesDetailRepo().posDisputesDetailRepo(
        start: 0,
        end: 1,
        userId: userId,
        id: id,
      );
      posDisputeDetailApiResponse = ApiResponse.complete(disputeDetailRes);
      print("posDisputeDetailApiResponse RES:$disputeDetailRes");
    } catch (e) {
      print('posDisputeDetailApiResponse.....$e');
      posDisputeDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///pos rental detail

  Future<void> rentalDetail({
    String? id,
  }) async {
    posRentalDetailApiResponse = ApiResponse.loading('Loading');
    Future.delayed(
      Duration.zero,
      () {
        update();
      },
    );

    try {
      PosRentalDetailResponseModel rentalDetailRes =
          await PosRentalDetailRepo().posRentalDetailRepo(
        start: 0,
        end: 1,
        id: id,
      );
      posRentalDetailApiResponse = ApiResponse.complete(rentalDetailRes);
      print("posRentalDetailApiResponse RES:$rentalDetailRes");
    } catch (e) {
      print('posRentalDetailApiResponse.....$e');
      posRentalDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///activity pos rental detail

  Future<void> activityRentalDetail({
    String? id,
  }) async {
    activityPosRentalDetailApiResponse = ApiResponse.loading('Loading');
    update();

    try {
      PosRentalDetailResponseModel rentalDetailRes =
          await ActivityPosRentalDetailRepo().activityPosRentalDetailRepo(
        start: 0,
        end: 1,
        id: id,
      );
      activityPosRentalDetailApiResponse =
          ApiResponse.complete(rentalDetailRes);
      print("activityPosRentalDetailApiResponse RES:$rentalDetailRes");
    } catch (e) {
      print('activityPosRentalDetailApiResponse.....$e');
      activityPosRentalDetailApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///pos payment count

  Future<void> paymentCount(
      {String? id,
      String terminalFilter = '',
      String? transactionStatus,
      String? transactionEntityId}) async {
    posPaymentCountApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      PosPaymentCountResponseModel paymentCountRes = await PosPaymentCountRepo()
          .posPaymentCountRepo(
              id: id,
              terminalFilter: terminalFilter,
              transactionStatus: transactionStatus,
              transactionEntityId: transactionEntityId);
      posPaymentCountApiResponse = ApiResponse.complete(paymentCountRes);
      print("posPaymentCountApiResponse RES:$paymentCountRes");
    } catch (e) {
      print('posPaymentCountApiResponse.....$e');
      posPaymentCountApiResponse = ApiResponse.error('error');
    }
    update();
  }

  ///pos dispute count

  Future<void> disputeCount(
      {String? id,
      String terminalFilter = '',
      String? transactionStatus,
      String? transactionEntityId}) async {
    posDisputeCountApiResponse = ApiResponse.loading('Loading');
    update();
    try {
      PosDisputesCountResponseModel disputeCountRes =
          await PosDisputeCountRepo().posDisputeCountRepo(
              id: id,
              terminalFilter: terminalFilter,
              transactionStatus: transactionStatus,
              transactionEntityId: transactionEntityId);
      posDisputeCountApiResponse = ApiResponse.complete(disputeCountRes);
      print("posDisputeCountApiResponse RES:$disputeCountRes");
    } catch (e) {
      print('posDisputeCountApiResponse.....$e');
      posDisputeCountApiResponse = ApiResponse.error('error');
    }
    update();
  }
}
