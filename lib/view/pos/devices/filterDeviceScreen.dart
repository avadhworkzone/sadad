import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/staticData.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class DeviceFilterScreen extends StatefulWidget {
  const DeviceFilterScreen({Key? key}) : super(key: key);

  @override
  State<DeviceFilterScreen> createState() => _DeviceFilterScreenState();
}

class _DeviceFilterScreenState extends State<DeviceFilterScreen> {
  List selectedDeviceStatus = [];
  List selectedDeviceType = [];
  @override
  void initState() {
    selectedDeviceStatus.add(Utility.holdDeviceFilterDeviceStatus);
    selectedDeviceType.add(Utility.holdDeviceFilterDeviceType);
    setState(() {});
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomSheet(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                height40(),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Utility.holdDeviceFilterDeviceStatus = '';
                        Utility.holdDeviceFilterDeviceType = '';
                        Utility.deviceFilterDeviceStatus = '';
                        Utility.deviceFilterDeviceType = '';
                        Utility.deviceFilterCountDeviceType = '';
                        Get.back();
                        // Get.showSnackbar(GetSnackBar(
                        //   message: 'Filter cleared'.tr,
                        // ));
                      },
                      child: customSmallMedBoldText(
                          color: ColorsUtils.accent, title: 'Clear Filter'.tr),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    deviceStatus(),
                    deviceType(),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Column deviceType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Type'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().deviceType.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedDeviceType.clear();

                    selectedDeviceType.add(StaticData().deviceType[index]);
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedDeviceType
                                .contains(StaticData().deviceType[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().deviceType[index],
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedDeviceType
                                    .contains(StaticData().deviceType[index])
                                ? ColorsUtils.white
                                : ColorsUtils.tabUnselectLabel),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () {
              filter();
              Get.back();
            },
            child: buildContainerWithoutImage(
                color: ColorsUtils.accent, text: 'Filter'.tr),
          ),
        ),
      ],
    );
  }

  void filter() {
    Utility.holdDeviceFilterDeviceType =
        selectedDeviceType.isEmpty ? '' : selectedDeviceType.first;
    Utility.holdDeviceFilterDeviceStatus =
        selectedDeviceStatus.isEmpty ? '' : selectedDeviceStatus.first;

    print(
        'values-----${Utility.holdDeviceFilterDeviceType}===${Utility.holdDeviceFilterDeviceStatus}');
    Utility.deviceFilterCountDeviceStatus = selectedDeviceStatus.isEmpty
        ? ''
        : selectedDeviceStatus.first == 'Active'
            ? '&where[is_active]=true'
            : selectedDeviceStatus.first == 'InActive'
                ? '&where[is_active]=false'
                : '';
    //&where[devicetype]=WPOS-QT&where[is_active]=true
    Utility.deviceFilterDeviceStatus = selectedDeviceStatus.isEmpty
        ? ''
        : selectedDeviceStatus.first == 'Active'
            ? '&filter[where][is_active]=true'
            : selectedDeviceStatus.first == 'InActive'
                ? '&filter[where][is_active]=false'
                : '';

    Utility.deviceFilterDeviceType = selectedDeviceType.isEmpty
        ? ''
        : selectedDeviceType.first == 'Wpos-QT'
            ? "&filter[where][devicetype][like]=%WPOS-QT%"
            : selectedDeviceType.first == 'Wpos-3'
                ? "&filter[where][devicetype][like]=%WPOS-3%"
                : '';
    Utility.deviceFilterCountDeviceType = selectedDeviceType.isEmpty
        ? ''
        : selectedDeviceType.first == 'Wpos-QT'
            ? "&where[devicetype]=WPOS-QT"
            : selectedDeviceType.first == 'Wpos-3'
                ? "&where[devicetype]=WPOS-3"
                : '';
  }

  Column deviceStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height30(),
        Text(
          'Device status'.tr,
          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
        ),
        height20(),
        SizedBox(
          height: 25,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: StaticData().deviceStatus.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InkWell(
                  onTap: () async {
                    selectedDeviceStatus.clear();
                    selectedDeviceStatus.add(StaticData().deviceStatus[index]);

                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ColorsUtils.border, width: 1),
                        color: selectedDeviceStatus
                                .contains(StaticData().deviceStatus[index])
                            ? ColorsUtils.primary
                            : ColorsUtils.white),
                    child: Center(
                      child: Text(
                        StaticData().deviceStatus[index],
                        style: ThemeUtils.blackBold.copyWith(
                            fontSize: FontUtils.verySmall,
                            color: selectedDeviceStatus
                                    .contains(StaticData().deviceStatus[index])
                                ? ColorsUtils.white
                                : ColorsUtils.tabUnselectLabel),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(),
        ),
      ],
    );
  }
}
