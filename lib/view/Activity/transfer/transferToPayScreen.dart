import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Activity/transferListResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/contact/device_contact_screen.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/qrscan/scanQrScreen.dart';
import 'package:sadad_merchat_app/view/Activity/transfer/transferAccountDetail.dart';
import 'package:sadad_merchat_app/viewModel/Activity/transferViewModel.dart';

class TransferToPayScreen extends StatefulWidget {
  const TransferToPayScreen({Key? key}) : super(key: key);

  @override
  State<TransferToPayScreen> createState() => _TransferToPayScreenState();
}

class _TransferToPayScreenState extends State<TransferToPayScreen> {
  String? countryCode;
  final _formKey = GlobalKey<FormState>();
  TransferViewModel transferViewModel = Get.find();
  List<ActivityTransferListResponse>? activityTransferListRes;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initData();
    });
    // TODO: implement initState
    super.initState();
  }

  static Future<PermissionStatus> contactsPermissions() async {
    print('contact permission====${Permission.contacts.status}');
    PermissionStatus permission = await Permission.contacts.request();
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ?? PermissionStatus.denied;
    } else {
      return permission;
    }
  }

  initData() async {
    transferViewModel.setTransactionInit();
    contactsPermissions();

    await transferViewModel.transferList(filter: '/recent-ten');
  }

  TextEditingController mobileNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height40(),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.to(() => ScanQrScreen());
                      },
                      child: Image.asset(
                        Images.qrCode,
                        width: 25,
                      ),
                    )
                  ],
                ),
                height40(),
                customMediumLargeBoldText(title: 'Transfer Account Details'),
                height30(),

                ///contact mobile no.
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: SizedBox(
                //         child: IntlPhoneField(
                //           key: UniqueKey(),
                //           inputFormatters: [
                //             FilteringTextInputFormatter.allow(
                //                 RegExp(TextValidation.digitsValidationPattern))
                //           ],
                //           controller: mobileNumber,
                //           decoration: InputDecoration(
                //             hintText: 'Mobile number'.tr,
                //             counterText: '',
                //             border: OutlineInputBorder(
                //               borderRadius: BorderRadius.circular(10),
                //               borderSide: BorderSide(),
                //             ),
                //           ),
                //           disableLengthCheck: false,
                //           initialCountryCode: Utility.countryCode,
                //           onCountryChanged: (country) {
                //             Utility.countryCode = '${country.code}';
                //             Utility.countryCodeNumber = '+${country.dialCode}';
                //             countryCode = country.dialCode;
                //             print('Select countrycode: ${country.code}');
                //             print('Select country: +${country.dialCode}');
                //             setState(() {});
                //             print(
                //                 'Country changed to: ${country.code}Country code ${country.dialCode}');
                //           },
                //         ),
                //       ),
                //     ),
                //     width10(),
                //     InkWell(
                //       onTap: () async {
                //         final number =
                //             await Get.to(() => DeviceContactScreen());
                //         print('9999999$number');
                //
                //         if (number != null || number != '') {
                //           if (number == null) {
                //             mobileNumber.text = '';
                //           } else {
                //             mobileNumber.text = number.toString();
                //           }
                //           print(number);
                //         }
                //       },
                //       child: Container(
                //         // height: Get.width * .15,
                //         // width: Get.width * 0.15,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(15),
                //             color: ColorsUtils.line),
                //         child: Padding(
                //           padding: const EdgeInsets.all(15),
                //           child: Center(
                //               child: Icon(
                //             Icons.person,
                //             size: 35,
                //           )),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      // Container(
                      //   height: Get.width * 0.13,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(
                      //           color: ColorsUtils.border, width: 1)),
                      //   child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 15),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         const Icon(
                      //           Icons.book,
                      //           color: ColorsUtils.maroon70122E,
                      //         ),
                      //         width10(),
                      //         customSmallSemiText(
                      //             title: Utility.countryCodeNumber),
                      //
                      //         // SizedBox(
                      //         //   child: CountryCodePicker(
                      //         //     showFlagDialog: true,
                      //         //     onChanged: (value) {
                      //         //       setState(() {
                      //         //         print(
                      //         //             'codeName is ${value.code} code${value} ');
                      //         //         Utility.countryCode = value.code.toString();
                      //         //         Utility.countryCodeNumber =
                      //         //             value.toString();
                      //         //       });
                      //         //     },
                      //         //     searchDecoration: InputDecoration(
                      //         //         border: OutlineInputBorder(
                      //         //             borderRadius: BorderRadius.circular(10),
                      //         //             borderSide: BorderSide(
                      //         //                 color: ColorsUtils.border,
                      //         //                 width: 1))),
                      //         //     initialSelection: Utility.countryCode,
                      //         //     favorite: [
                      //         //       Utility.countryCodeNumber,
                      //         //       Utility.countryCode
                      //         //     ],
                      //         //     showCountryOnly: false,
                      //         //     showFlag: false,
                      //         //     alignLeft: false,
                      //         //     textStyle: ThemeUtils.blackSemiBold,
                      //         //     padding: const EdgeInsets.only(right: 1),
                      //         //     showOnlyCountryWhenClosed: false,
                      //         //     showDropDownButton: true,
                      //         //   ),
                      //         // ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // width15(),
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          child: commonTextField(
                              prifixWidget: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.book,
                                      color: ColorsUtils.maroon70122E,
                                    ),
                                    width10(),
                                    customSmallSemiText(
                                        title: Utility.countryCodeNumber),
                                    width10(),
                                  ]),
                              contollerr: mobileNumber,
                              hint: 'Mobile Number'.tr,
                              validationType: '',
                              keyType: TextInputType.phone,
                              regularExpression:
                                  TextValidation.digitsValidationPattern,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Number cannot be empty".tr;
                                }
                                if (value.length > 4) {
                                  if (value.substring(0, 4) == '1234') {
                                    return "Mobile number is invalid".tr;
                                  }
                                }

                                if (value.length < 8) {
                                  return "Number should be 8 digit".tr;
                                }
                                return null;
                              },
                              inputLength: 8),
                        ),
                      ),
                      width20(),
                      InkWell(
                        onTap: () async {
                          final number =
                              await Get.to(() => DeviceContactScreen());
                          print('9999999$number');

                          if (number != null || number != '') {
                            if (number == null) {
                              mobileNumber.text = '';
                            } else {
                              mobileNumber.text = number.toString();
                            }
                            print(number);
                          }
                        },
                        child: Container(
                          // height: Get.width * .15,
                          // width: Get.width * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: ColorsUtils.line),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Center(
                                child: Icon(
                              Icons.person,
                              size: 35,
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                height40(),
                customMediumLargeBoldText(title: 'Send to Recent'),
                height30(),
                SizedBox(
                  height: Get.height * 0.18,
                  width: Get.width,
                  child: GetBuilder<TransferViewModel>(
                    builder: (controller) {
                      if (controller.transferListApiResponse.status ==
                              Status.INITIAL ||
                          controller.transferListApiResponse.status ==
                              Status.LOADING) {
                        return Loader();
                      } else if (controller.transferListApiResponse.status ==
                          Status.ERROR) {
                        return SessionExpire();
                        return Text('error');
                      }
                      activityTransferListRes =
                          controller.transferListApiResponse.data;
                      // return ListView.builder(
                      //   padding: EdgeInsets.zero,
                      //   itemCount: activityTransferListRes!.length > 10
                      //       ? 10
                      //       : activityTransferListRes!.length,
                      //   shrinkWrap: true,
                      //   scrollDirection: Axis.horizontal,
                      //   itemBuilder: (context, index) {
                      //     return Padding(
                      //       padding: const EdgeInsets.all(5),
                      //       child: InkWell(
                      //         onTap: () async {
                      //           showLoadingDialog(context: context);
                      //           String token = await encryptedSharedPreferences
                      //               .getString('token');
                      //           final url = Uri.parse(
                      //               '${Utility.baseUrl}users/user-info?cellnumber=${activityTransferListRes![index].cellnumber.toString()}');
                      //           Map<String, String> header = {
                      //             'Authorization': token,
                      //             'Content-Type': 'application/json'
                      //           };
                      //           var result = await http.get(
                      //             url,
                      //             headers: header,
                      //           );
                      //           print('user info res is ${result.body}');
                      //
                      //           if (result.statusCode == 200) {
                      //             Future.delayed(Duration(seconds: 1), () {
                      //               hideLoadingDialog(context: context);
                      //               Get.to(() => TransferAccountDetails(
                      //                     name:
                      //                         jsonDecode(result.body)['name'] ??
                      //                             "NA",
                      //                     number:
                      //                         activityTransferListRes![index]
                      //                             .cellnumber
                      //                             .toString(),
                      //                     accountId: jsonDecode(
                      //                             result.body)['SadadId'] ??
                      //                         "NA",
                      //                   ));
                      //               // Get.to(() => InvoiceList());
                      //             });
                      //           } else {
                      //             hideLoadingDialog(context: context);
                      //             Get.snackbar(
                      //               'error'.tr,
                      //               '${jsonDecode(result.body)['error']['message']}',
                      //             );
                      //           }
                      //
                      //           // Get.to(() => TransferAccountDetails(
                      //           //       name: activityTransferListRes![
                      //           //                   index]
                      //           //               .name ??
                      //           //           "NA",
                      //           //       number:
                      //           //           activityTransferListRes![
                      //           //                   index]
                      //           //               .cellnumber
                      //           //               .toString(),
                      //           //       accountId:
                      //           //           activityTransferListRes![
                      //           //                   index]
                      //           //               .roleId
                      //           //               .toString(),
                      //           //     ));
                      //         },
                      //         child: Column(
                      //           children: [
                      //             CircleAvatar(
                      //               radius: 35,
                      //               backgroundColor: ColorsUtils.lightYellow,
                      //               child: Icon(Icons.person,
                      //                   color: ColorsUtils.yellow, size: 32),
                      //             ),
                      //             height10(),
                      //             customVerySmallSemiText(
                      //                 title:
                      //                     '+974-${activityTransferListRes![index].cellnumber}')
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: activityTransferListRes!.length > 10
                            ? 10
                            : activityTransferListRes!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () async {
                                showLoadingDialog(context: context);
                                String token = await encryptedSharedPreferences
                                    .getString('token');
                                final url = Uri.parse(
                                    '${Utility.baseUrl}users/user-info?cellnumber=${activityTransferListRes![index].cellnumber.toString()}');
                                Map<String, String> header = {
                                  'Authorization': token,
                                  'Content-Type': 'application/json'
                                };
                                var result = await http.get(
                                  url,
                                  headers: header,
                                );
                                print('user info res is ${result.body}');

                                if (result.statusCode == 200) {
                                  Future.delayed(Duration(seconds: 1), () {
                                    hideLoadingDialog(context: context);
                                    Get.to(() => TransferAccountDetails(
                                          name:
                                              jsonDecode(result.body)['name'] ??
                                                  "NA",
                                          number:
                                              activityTransferListRes![index]
                                                  .cellnumber
                                                  .toString(),
                                          accountId: jsonDecode(
                                                  result.body)['SadadId'] ??
                                              "NA",
                                        ));
                                    // Get.to(() => InvoiceList());
                                  });
                                } else {
                                  hideLoadingDialog(context: context);
                                  Get.snackbar(
                                    'error'.tr,
                                    '${jsonDecode(result.body)['error']['message']}',
                                  );
                                }

                                // Get.to(() => TransferAccountDetails(
                                //       name: activityTransferListRes![
                                //                   index]
                                //               .name ??
                                //           "NA",
                                //       number:
                                //           activityTransferListRes![
                                //                   index]
                                //               .cellnumber
                                //               .toString(),
                                //       accountId:
                                //           activityTransferListRes![
                                //                   index]
                                //               .roleId
                                //               .toString(),
                                //     ));
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: ColorsUtils.lightYellow,
                                    child: Icon(Icons.person,
                                        color: ColorsUtils.yellow, size: 32),
                                  ),
                                  height10(),
                                  customVerySmallSemiText(
                                      title: activityTransferListRes![index]
                                                  .name ==
                                              null
                                          ? '+974-${activityTransferListRes![index].cellnumber}'
                                          : activityTransferListRes![index]
                                                  .name ??
                                              "NA")
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Padding bottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                if (Utility.userPhone != mobileNumber.text) {
                  showLoadingDialog(context: context);
                  String token =
                      await encryptedSharedPreferences.getString('token');
                  final url = Uri.parse(
                      '${Utility.baseUrl}users/user-info?cellnumber=${mobileNumber.text}');
                  Map<String, String> header = {
                    'Authorization': token,
                    'Content-Type': 'application/json'
                  };
                  var result = await http.get(
                    url,
                    headers: header,
                  );
                  print('user info res is ${result.body}');

                  if (result.statusCode == 200) {
                    Future.delayed(Duration(seconds: 1), () {
                      hideLoadingDialog(context: context);
                      Get.to(() => TransferAccountDetails(
                            name: jsonDecode(result.body)['name'] ?? "NA",
                            number: mobileNumber.text,
                            accountId:
                                jsonDecode(result.body)['SadadId'] ?? "NA",
                          ));
                      // Get.to(() => InvoiceList());
                    });
                  } else {
                    hideLoadingDialog(context: context);

                    Get.snackbar(
                      'error'.tr,
                      '${jsonDecode(result.body)['error']['message']}',
                    );
                  }
                } else {
                  Get.snackbar(
                      'error'.tr, 'you can not create invoice by your self');
                }
              }
              //
            },
            child: buildContainerWithoutImage(
                text: 'Next', color: ColorsUtils.accent),
          )
        ],
      ),
    );
  }
}
