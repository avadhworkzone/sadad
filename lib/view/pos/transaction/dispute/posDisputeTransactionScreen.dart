import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/posModule/transaction/dispute/posDisputesDetailResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/pos/transaction/payment/posTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/pos/transaction/posTransactionViewModel.dart';

class PosDisputeTransactionScreen extends StatefulWidget {
  String? id;
  PosDisputeTransactionScreen({Key? key, this.id}) : super(key: key);

  @override
  State<PosDisputeTransactionScreen> createState() =>
      _PosDisputeTransactionScreenState();
}

class _PosDisputeTransactionScreenState
    extends State<PosDisputeTransactionScreen> {
  PosTransactionViewModel posTransactionViewModel = Get.find();
  List<PosDisputesDetailResponseModel>? disputesDetailRes;
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  ConnectivityViewModel connectivityViewModel = Get.find();
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            backgroundColor: ColorsUtils.lightBg,
            body: GetBuilder<PosTransactionViewModel>(
              builder: (controller) {
                if (controller.posDisputeDetailApiResponse.status ==
                        Status.LOADING ||
                    controller.posDisputeDetailApiResponse.status ==
                        Status.INITIAL) {
                  return const Center(child: Loader());
                }
                if (controller.posDisputeDetailApiResponse.status ==
                    Status.ERROR) {
                  // return const Center(child: Text('error'));
                  return SessionExpire();
                }
                disputesDetailRes =
                    posTransactionViewModel.posDisputeDetailApiResponse.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height60(),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_ios)),
                      height40(),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customMediumLargeBoldText(
                                color: ColorsUtils.black,
                                title: 'Dispute Details'.tr),
                            height20(),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          commonColumnField(
                                              color: ColorsUtils.black,
                                              title: 'Dispute ID.'.tr,
                                              value:
                                                  '${disputesDetailRes!.first.disputeId ?? 'NA'}'),
                                          const Spacer(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: commonTextBox(
                                                title:
                                                    '${disputesDetailRes!.first.disputestatus!.name ?? "NA"}',
                                                color: disputesDetailRes!.first
                                                            .disputestatus!.id
                                                            .toString() ==
                                                        '1'
                                                    ? ColorsUtils.green
                                                    : disputesDetailRes!
                                                                .first
                                                                .disputestatus!
                                                                .id
                                                                .toString() ==
                                                            '2'
                                                        ? ColorsUtils.yellow
                                                        : ColorsUtils.accent),
                                          )
                                        ],
                                      ),
                                      height10(),
                                      customSmallSemiText(
                                          color: ColorsUtils.grey,
                                          title: disputesDetailRes!
                                                  .first.created ??
                                              "NA")
                                    ]),
                              ),
                            ),
                            height10(),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Dispute Type'.tr,
                                          value:
                                              '${disputesDetailRes!.first.disputetype!.name}'),
                                      commonColumnField(
                                          color: ColorsUtils.accent,
                                          title: 'Dispute amount'.tr,
                                          value:
                                              '${disputesDetailRes!.first.amount ?? "0"} QAR'),
                                    ]),
                              ),
                            ),
                            height10(),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              disputesDetailRes!
                                                          .first
                                                          .transaction!
                                                          .invoicenumber ==
                                                      null
                                                  ? SizedBox()
                                                  : Get.to(() =>
                                                      PosTransactionDetailScreen(
                                                        id: disputesDetailRes!
                                                            .first
                                                            .transaction!
                                                            .id
                                                            .toString(),
                                                      ));
                                            },
                                            child: commonColumnField(
                                                color: ColorsUtils.black,
                                                title: 'Transaction ID.'.tr,
                                                value:
                                                    '${disputesDetailRes!.first.transaction!.invoicenumber ?? 'NA'}'),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: ColorsUtils.black,
                                                      width: 1)),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                child: Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 12),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Transaction amount'.tr,
                                          value:
                                              '${disputesDetailRes!.first.transaction!.amount ?? "0"} QAR'),
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Transaction Type'.tr,
                                          value: 'Dispute'.tr),
                                    ]),
                              ),
                            ),
                            height10(),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Customer name'.tr,
                                          value:
                                              '${disputesDetailRes!.first.receiverId!.name ?? "NA"}'),
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Customer Mobile no.'.tr,
                                          value:
                                              '+974-${disputesDetailRes!.first.receiverId!.cellnumber ?? "NA"}'),
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Customer Email ID'.tr,
                                          value:
                                              '${disputesDetailRes!.first.receiverId!.email ?? 'NA'}'),
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Comment'.tr,
                                          value:
                                              '${disputesDetailRes!.first.comment ?? "NA"}'),
                                    ]),
                              ),
                            ),
                            height10(),
                            Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1)),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      commonColumnField(
                                          color: ColorsUtils.black,
                                          title: 'Card holder name'.tr,
                                          value:
                                              '${disputesDetailRes!.first.transaction!.postransaction!.terminal!.name ?? "NA"}'),
                                    ]),
                              ),
                            ),
                            height30()
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              },
            ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                setState(() {});
                initData();
              } else {
                Get.snackbar('error'.tr, 'Please check your connection'.tr);
              }
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          },
        );
      }
    } else {
      return InternetNotFound(
        onTap: () async {
          connectivityViewModel.startMonitoring();

          if (connectivityViewModel.isOnline != null) {
            if (connectivityViewModel.isOnline!) {
              setState(() {});
              initData();
            } else {
              Get.snackbar('error'.tr, 'Please check your connection'.tr);
            }
          } else {
            Get.snackbar('error'.tr, 'Please check your connection'.tr);
          }
        },
      );
    }
  }

  void initData() async {
    String userId = await encryptedSharedPreferences.getString('id');

    posTransactionViewModel.disputeDetail(id: widget.id, userId: userId);
  }
}
