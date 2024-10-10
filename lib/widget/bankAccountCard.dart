import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/addBankAccountModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccountinfo.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/businessDetailsScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';
import '../model/repo/more/bank/bankAccountRepo.dart';
import '../viewModel/more/bank/bankAccountViewModel.dart';
import '../viewModel/more/businessInfo/businessInfoViewModel.dart';

class BankAccountCard extends StatelessWidget {
  BankAccountCard({
    Key? key,
    required this.bankAccountResponseModel,
    this.onUpdate,
    this.token,
  }) : super(key: key);

  BankAccountResponseModel bankAccountResponseModel =
      BankAccountResponseModel();

  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  final cnt = Get.find<BankAccountViewModel>();

  AddSetAsDefaultViewModel setAsDefault = AddSetAsDefaultViewModel();
  final String? token;

  final void Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 169,
      // width: 327,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: bankAccountResponseModel.primary ?? false
                  ? ColorsUtils.primary
                  : ColorsUtils.line,
              width: 1)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 52.0,
              width: 52.0,
              decoration: BoxDecoration(
                color: ColorsUtils.line.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: ColorsUtils.line,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  "${Constants.bankContainer}${bankAccountResponseModel.bank?.logo}",
                  headers: {HttpHeaders.authorizationHeader: token ?? ""},
                  height: 52.0,
                  width: 52.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            width12(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bankAccountResponseModel.bank?.name ?? "",
                        style: ThemeUtils.blackSemiBold.copyWith(
                          fontSize: FontUtils.mediumSmall,
                        ),
                      ),
                      // InkWell(
                      //   onTap: onDelete,
                      //   child: SvgIcon(Images.menuIcon),
                      // ),
                      Container(
                          height: 21.0,
                          width: 24.0,
                          child: InkWell(
                            onTap: onUpdate!,
                            child: Icon(
                              // onPressed: ()=>showExportDialog(),
                              Icons.more_vert,
                            ),
                          )
                          // PopupMenuButton<bool>(
                          //   key: _key,
                          //   color: Colors.white,
                          //   onSelected: (value) {
                          //     setAsDefault.bankAccountRepo
                          //         .updateSetAsDefault(
                          //         id: bankAccountResponseModel.id
                          //             .toString(), setAsDefault);
                          //     value = setAsDefault.primary.value;
                          //     log("message.........>${value}");
                          //   },
                          //   itemBuilder: (context) {
                          //     return <PopupMenuEntry<bool>>[
                          //       PopupMenuItem(
                          //         child: Text('Set Default Account'),
                          //         enabled: true,
                          //         value: false,
                          //       ),
                          //     ];
                          //   },
                          // ),
                          ),
                    ],
                  ),
                  height10(),
                  Text(
                      businessDetailCnt.businessInfoModel.value.user == null
                          ? 'NA'
                          : businessDetailCnt
                                  .businessInfoModel.value.user?.name ??
                              "Null",
                      style: ThemeUtils.blackRegular
                          .copyWith(fontSize: FontUtils.small)),
                  height8(),
                  Text(
                      "IBAN: \n${bankAccountResponseModel.ibannumber ?? 'NA'}"
                          .tr,
                      style: ThemeUtils.blackRegular
                          .copyWith(fontSize: FontUtils.verySmall)),
                  height16(),
                  Row(
                    children: [
                      bankAccountResponseModel.primary ?? false
                          ? Text('Default Account'.tr,
                              style: ThemeUtils.maroonSemiBold
                                  .copyWith(fontSize: FontUtils.verySmall))
                          : SizedBox(),
                      Spacer(),
                      SvgIcon(getAccountStatus(
                          "${bankAccountResponseModel.userbankstatus!.id ?? ""}")),
                      width8(),
                      Text(
                          bankAccountResponseModel.userbankstatus!.name
                              .toString(),
                          style: ThemeUtils.blackRegular
                              .copyWith(fontSize: FontUtils.verySmall)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
