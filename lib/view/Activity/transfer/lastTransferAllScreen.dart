import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/lastTransferListResponse.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/Activity/activityTransactionDetailScreen.dart';
import 'package:sadad_merchat_app/viewModel/Activity/transferViewModel.dart';

class LastTransferScreen extends StatefulWidget {
  const LastTransferScreen({Key? key}) : super(key: key);

  @override
  State<LastTransferScreen> createState() => _LastTransferScreenState();
}

class _LastTransferScreenState extends State<LastTransferScreen> {
  bool isPageFirst = true;

  TransferViewModel transferViewModel = Get.find();
  List<LastTransferListResponse>? lastRes;
  ScrollController? _scrollController;
  String userId = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      transferViewModel.setTransactionInit();
      initData();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  initData() async {
    userId = await encryptedSharedPreferences.getString('id');
    await transferViewModel.transferLastList();
    scrollApiData();
    if (isPageFirst == true) {
      isPageFirst = false;
      setState(() {});
    }
  }

  scrollApiData() {
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController!.position.maxScrollExtent ==
                _scrollController!.offset &&
            !transferViewModel.isPaginationLoading) {
          print('hiiii');
          transferViewModel.transferLastList();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          height40(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios_sharp)),
                customLargeBoldText(title: 'Last Transfer List'),
                width20()
              ],
            ),
          ),
          height10(),
          Expanded(
            child: GetBuilder<TransferViewModel>(
              builder: (controller) {
                if (controller.lastTransferListApiResponse.status ==
                        Status.LOADING ||
                    controller.lastTransferListApiResponse.status ==
                        Status.INITIAL) {
                  return Loader();
                }
                if (controller.lastTransferListApiResponse.status ==
                    Status.ERROR) {
                  //return Text('Error');
                  return SessionExpire();
                }
                lastRes = controller.lastTransferListApiResponse.data;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        itemCount: lastRes!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // dataShow(index);
                          return InkWell(
                            onTap: () async {
                              if (lastRes![index].invoicenumber != null) {
                                await Get.to(
                                    () => ActivityTransactionDetailScreen(
                                          id: lastRes![index]
                                              .invoicenumber
                                              .toString(),
                                        ));
                                transferViewModel.setTransactionInit();
                                initData();
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 35,
                                        backgroundColor:
                                            ColorsUtils.lightYellow,
                                        child: Icon(Icons.person,
                                            color: ColorsUtils.yellow,
                                            size: 32),
                                      ),
                                      width20(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: customSmallMedBoldText(
                                                      title:
                                                          // '+${lastRes![index].receiverId != null ? lastRes![index].receiverId!.id.toString() == userId ? lastRes![index].senderId!.cellnumber ?? "NA" : lastRes![index].receiverId!.cellnumber ?? "NA" : lastRes![index].senderId!.cellnumber ?? "NA"}'),
                                                          '${lastRes![index].receiverId != null ? lastRes![index].receiverId!.id.toString() == userId ? lastRes![index].senderId!.name == null ? '+${lastRes![index].senderId!.cellnumber ?? "NA"}' : lastRes![index].senderId!.name : lastRes![index].receiverId!.name == null ? '+${lastRes![index].receiverId!.cellnumber ?? "NA"}' : lastRes![index].receiverId!.name ?? "NA" : lastRes![index].senderId!.name == null ? '+${lastRes![index].senderId!.cellnumber ?? "NA"}' : lastRes![index].senderId!.name}'),
                                                ),
                                                customSmallMedSemiText(
                                                    color: lastRes![index]
                                                                .receiverId ==
                                                            null
                                                        ? ColorsUtils.green
                                                        : lastRes![index]
                                                                    .receiverId!
                                                                    .id
                                                                    .toString() ==
                                                                userId
                                                            ? ColorsUtils.green
                                                            : ColorsUtils.red,
                                                    title: lastRes![index]
                                                                .receiverId ==
                                                            null
                                                        ? '+ ${lastRes![index].amount ?? 0} QAR'
                                                        : '${(lastRes![index].receiverId!.id.toString() == userId ? '+ ' : '- ') + '${lastRes![index].amount ?? 0}'} QAR')
                                              ],
                                            ),
                                            height10(),
                                            customSmallNorText(
                                                title:
                                                    // '26 Mar 2022, 11:19:39',
                                                    lastRes![index]
                                                                .receiverId ==
                                                            null
                                                        ? '${DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(lastRes![index].senderId!.created.toString()))}'
                                                        : '${lastRes![index].receiverId!.id.toString() == userId ? DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(lastRes![index].senderId!.created.toString())) ?? "NA" : DateFormat('dd MMM yy, HH:mm:ss').format(DateTime.parse(lastRes![index].receiverId!.created.toString())) ?? "NA"}',
                                                color: ColorsUtils.grey)
                                          ],
                                        ),
                                      ),
                                      // Spacer(),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: ColorsUtils.border,
                                  thickness: 1.5,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (transferViewModel.isPaginationLoading && !isPageFirst)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: Loader()),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
