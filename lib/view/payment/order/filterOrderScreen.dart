import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';

import '../../../staticData/utility.dart';

class FilterOrderScreen extends StatefulWidget {
  const FilterOrderScreen({Key? key}) : super(key: key);

  @override
  State<FilterOrderScreen> createState() => _FilterOrderScreenState();
}

class _FilterOrderScreenState extends State<FilterOrderScreen> {
  bool? groupValue;

  int isRadioSelected = 0;
  // bool isFiltered = false;

  @override
  void initState() {
    Utility.orderDeliverStatus == ''
        ? isRadioSelected = 0
        : isRadioSelected = int.parse(Utility.orderDeliverStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topView(),
          centerView(),
          const Spacer(),
          dividerData(),
          height20(),
          InkWell(
              onTap: () {
                if (isRadioSelected != 0) {
                  Utility.orderDeliverStatus = isRadioSelected.toString();
                } else {
                  Utility.orderDeliverStatus = '';
                }
                Utility.filterSorted = '&filter[order]=created DESC';
                // isRadioSelected == 1
                //     ? Utility.filterSorted = '&filter[order]=created DESC'
                //     : isRadioSelected == 3
                //         ? Utility.filterSorted = '&filter[order]=invoiceno DESC'
                //         : isRadioSelected == 4
                //             ? Utility.filterSorted =
                //                 '&filter[order]=grossamount DESC'
                //             : Utility.filterSorted =
                //                 '&filter[order]=created DESC';
                Get.back();
              },
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Filter'.tr)),
          height20()
        ],
      ),
    ));
  }

  Column centerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height40(),
        Text(
          'Sort by'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabeledRadio(
              label: 'Pending'.tr,
              value: 1,
              groupValue: isRadioSelected,
              onChanged: (newValue) {
                setState(() {
                  isRadioSelected = newValue;
                });
              },
            ),
            LabeledRadio(
              label: 'Delivered'.tr,
              value: 2,
              groupValue: isRadioSelected,
              onChanged: (newValue) {
                setState(() {
                  isRadioSelected = newValue;
                });
              },
            ),
          ],
        ),
      ],
    );
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
                Utility.startRange = 0;
                Utility.endRange = 0;
                Utility.filterSorted = '&filter[order]=created DESC';
                isRadioSelected = 0;
                Utility.orderDeliverStatus = '';
                setState(() {});
                //Get.back();
              },
              child: Text(
                'Clear Filter'.tr,
                style: ThemeUtils.blackSemiBold.copyWith(
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
      ],
    );
  }
}
