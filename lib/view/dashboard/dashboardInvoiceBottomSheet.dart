import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'invoices/detailedInvoiceScreen.dart';
import 'invoices/fastInvoiceScreen.dart';

void showCreateInvoiceDialog(BuildContext context) {
  showModalBottomSheet(
      context: context,
      backgroundColor: ColorsUtils.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 65,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: ColorsUtils.dividerCreateInvoice,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "create Invoice".tr,
              style:
                  ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
            ),
            Container(
              margin: const EdgeInsets.only(top: 32, left: 27, right: 27),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ColorsUtils.line)),
              child: InkWell(
                onTap: () {
                  Utility.countryCode = 'QA';
                  Utility.countryCodeNumber = '+974';
                  Get.back();
                  Get.to(() => FastInvoiceScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            color: ColorsUtils.createInvoiceContainer,
                            borderRadius: BorderRadius.circular(12)),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(Images.invoice),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Image.asset(
                                Images.pinYellow,
                                height: 18,
                                width: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quick Invoice".tr,
                              style: ThemeUtils.blackBold.copyWith(
                                fontSize: FontUtils.mediumSmall,
                              ),
                              maxLines: 2,
                            ),
                            Text(
                              "Create fast invoice with full amount only".tr,
                              style: ThemeUtils.blackRegular
                                  .copyWith(fontSize: FontUtils.verySmall),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Image.asset(
                        Images.addRoundMaroon,
                        width: 20,
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 15, left: 27, right: 27, bottom: 60),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ColorsUtils.line)),
              child: InkWell(
                onTap: () {
                  Utility.mobNo = '';
                  Utility.custNo = '';
                  Utility.description = '';
                  Utility.countryCode = 'QA';
                  Utility.countryCodeNumber = '+974';
                  Utility.isNotify = false;
                  Utility.selectedProductData = [];
                  Utility.isDescription = false;

                  Get.back();

                  Get.to(() => DetailedInvoiceScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            color: ColorsUtils.createInvoiceContainer,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(Images.invoice),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Detailed Invoice".tr,
                              style: ThemeUtils.blackBold
                                  .copyWith(fontSize: FontUtils.mediumSmall),
                              maxLines: 2,
                            ),
                            Text(
                              "Create detailed Invoice with product & services"
                                  .tr,
                              style: ThemeUtils.blackRegular
                                  .copyWith(fontSize: FontUtils.verySmall),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Image.asset(
                        Images.addRoundMaroon,
                        width: 20,
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      });
}
