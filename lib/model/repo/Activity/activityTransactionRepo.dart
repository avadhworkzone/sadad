// // ignore_for_file: prefer_interpolation_to_compose_strings
//
// import 'dart:developer';
//
// import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/balanceListResponseModel.dart';
// import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/transactionListResModel.dart';
//
// import '../../apimodels/responseModel/DashBoard/availableBalanceResponseModel.dart';
// import '../../services/api_service.dart';
// import '../../services/base_service.dart';
//
// class ActivityTransactionListRepo extends BaseService {
//   Future<ActivityTransactionListResModel> activityTransactionListRepo(
//       {required int start, required int end, String? filter}) async {
//     var response = await ApiService().getResponse(
//       apiType: APIType.aGet,
//       url: activityTransactionList + '?filter[skip]=0&filter[limit]=10$filter',
//       body: {},
//     );
//     log("balanceList res :$response");
//     BalanceListResponseModel balanceListResponseModel =
//         BalanceListResponseModel.fromJson((response as Map<String, dynamic>));
//     return balanceListResponseModel;
//   }
// }
