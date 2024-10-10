// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sadad_merchat_app/base/constants.dart';
// import 'package:sadad_merchat_app/staticData/common_widgets.dart';
// import 'package:sadad_merchat_app/util/utils.dart';
//
// class ActivityTransactionDetailScreen extends StatefulWidget {
//   const ActivityTransactionDetailScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ActivityTransactionDetailScreen> createState() =>
//       _ActivityTransactionDetailScreenState();
// }
//
// class _ActivityTransactionDetailScreenState
//     extends State<ActivityTransactionDetailScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               commonButtonBox(
//                   color: ColorsUtils.accent,
//                   text: 'Download Receipt',
//                   img: Images.download)
//             ],
//           ),
//         ),
//         backgroundColor: ColorsUtils.lightBg,
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 height40(),
//                 InkWell(
//                     onTap: () {
//                       Get.back();
//                     },
//                     child: Icon(Icons.arrow_back_ios_rounded)),
//                 height40(),
//                 customMediumLargeBoldText(title: 'Transactions Details'),
//                 height20(),
//
//                 ///transaction Id status
//                 Container(
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: ColorsUtils.white,
//                       border: Border.all(color: ColorsUtils.border, width: 1)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             commonColumnField(
//                                 color: ColorsUtils.black,
//                                 title: 'Transaction ID.'.tr,
//                                 value: 'SD6451313132'),
//                             Spacer(),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 10),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                     color: ColorsUtils.green),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 2),
//                                   child: customVerySmallNorText(
//                                       color: ColorsUtils.white,
//                                       title: 'Success'.tr),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                         customVerySmallNorText(
//                             color: ColorsUtils.grey,
//                             title: '16 Mar 2022, 8:57:27')
//                       ],
//                     ),
//                   ),
//                 ),
//                 height10(),
//
//                 ///transaction amount type method
//                 Container(
//                   width: Get.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: ColorsUtils.white,
//                       border: Border.all(color: ColorsUtils.border, width: 1)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ///Transaction Amount
//                         customSmallNorText(title: 'Transaction Amount'),
//                         height10(),
//                         customMediumSemiText(
//                             title: '6000 QAR', color: ColorsUtils.accent),
//                         height20(),
//
//                         ///Transaction type
//                         customSmallNorText(title: 'Transaction Type'),
//                         height10(),
//                         customMediumSemiText(
//                             title: 'Transfer', color: ColorsUtils.accent),
//                         height20(),
//
//                         ///payment method
//                         customSmallNorText(title: 'Payment Method'),
//                         height10(),
//                         customMediumSemiText(
//                             title: 'Out', color: ColorsUtils.accent),
//                       ],
//                     ),
//                   ),
//                 ),
//                 height10(),
//
//                 ///receiver name id contact
//                 Container(
//                   width: Get.width,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: ColorsUtils.white,
//                       border: Border.all(color: ColorsUtils.border, width: 1)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(15),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ///Receiver name
//                         customSmallNorText(title: 'Receiver name'),
//                         height10(),
//                         customMediumSemiText(
//                             title: 'Mohmad Ismail', color: ColorsUtils.black),
//                         height20(),
//
//                         ///Receiver Id
//                         customSmallNorText(title: 'Receiver ID'),
//                         height10(),
//                         customMediumSemiText(
//                             title: '12345', color: ColorsUtils.black),
//                         height20(),
//
//                         ///payment method
//                         customSmallNorText(title: 'Contact'),
//                         height10(),
//                         customMediumSemiText(
//                             title: '+974- 33366555', color: ColorsUtils.black),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
