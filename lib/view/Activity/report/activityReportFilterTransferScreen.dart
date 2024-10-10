import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class ActivityReportTransferFilterScreen extends StatefulWidget {
  const ActivityReportTransferFilterScreen({Key? key}) : super(key: key);

  @override
  State<ActivityReportTransferFilterScreen> createState() =>
      _ActivityReportTransferFilterScreenState();
}

class _ActivityReportTransferFilterScreenState
    extends State<ActivityReportTransferFilterScreen> {
  List transferTypeFilter = [];

  @override
  void initState() {
    if (Utility.holdActivityTransferReportTransferTypeFilter != '') {
      transferTypeFilter
          .add(Utility.holdActivityTransferReportTransferTypeFilter);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            dividerData(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: InkWell(
                  onTap: () {
                    if (transferTypeFilter.isNotEmpty) {
                      Utility.activityTransferReportTransferTypeFilter =
                          '&filter[where][transferType]=${transferTypeFilter.first.toString().toLowerCase()}';
                      Utility.holdActivityTransferReportTransferTypeFilter =
                          transferTypeFilter.first;
                      setState(() {});
                    }
                    Get.back();
                  },
                  child: buildContainerWithoutImage(
                      color: ColorsUtils.accent, text: 'Filter'.tr)),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              topView(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///transaction type
                      commonWrapList(
                          listName: StaticData().activityTransferType,
                          key: 'Transfer Types'.tr,
                          filterName: transferTypeFilter),
                      dividerData(),
                      height20()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Column topView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height30(),
        Row(
          children: [
            InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios)),
            Spacer(),
            InkWell(
              onTap: () {
                transferTypeFilter = [];
                Utility.activityTransferReportTransferTypeFilter = '';
                Utility.holdActivityTransferReportTransferTypeFilter = '';
                setState(() {});
                Get.snackbar('success', 'Filter Cleared!');

                // Get.back();
              },
              child: Text(
                'Clear Filter'.tr,
                style: ThemeUtils.blackBold.copyWith(
                    color: ColorsUtils.accent, fontSize: FontUtils.mediumSmall),
              ),
            ),
          ],
        ),
        height30(),
        Text(
          'Filter'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
        ),
        height20(),
      ],
    );
  }

  Column commonWrapList({String? key, var listName, dynamic filterName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height20(),
        Text(
          key!,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: Get.width,
              child: Wrap(
                runSpacing: 10,
                direction: Axis.horizontal,
                children: List.generate(
                    listName.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () async {
                              filterName.clear();
                              filterName.add(listName[index]);

                              print('list value===>$filterName');
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: ColorsUtils.border, width: 1),
                                  color: filterName.contains(listName[index])
                                      ? ColorsUtils.primary
                                      : ColorsUtils.white),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  listName[index],
                                  style: ThemeUtils.blackBold.copyWith(
                                      fontSize: FontUtils.verySmall,
                                      color:
                                          filterName.contains(listName[index])
                                              ? ColorsUtils.white
                                              : ColorsUtils.tabUnselectLabel),
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            )),
      ],
    );
  }
}
