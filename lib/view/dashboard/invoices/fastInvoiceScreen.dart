import 'dart:convert';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/createInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/invoice/editInvoiceRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/checkInternationalResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/DashBoard/invoice/countryCodeResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/checkInternationalViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/createInvoiceViewModel.dart';
import 'package:sadad_merchat_app/viewModel/dashboard/getInvoiceViewModel.dart';
import 'package:http/http.dart' as http;
import '../../../staticData/common_widgets.dart';
import 'invoicedetail.dart';

class FastInvoiceScreen extends StatefulWidget {
  String? transId;
  Map<String, dynamic>? invoiceDetail;

  FastInvoiceScreen({Key? key, this.transId, this.invoiceDetail}) : super(key: key);

  @override
  State<FastInvoiceScreen> createState() => _FastInvoiceScreenState();
}

class _FastInvoiceScreenState extends State<FastInvoiceScreen> {
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController invoiceAmount = TextEditingController();
  TextEditingController descriptions = TextEditingController();
  EditInvoiceRequestModel editInvoiceReq = EditInvoiceRequestModel();
  CreateInvoiceRequestModel createInvoiceReq = CreateInvoiceRequestModel();
  CreateInvoiceViewModel createInvoiceViewModel = Get.find();
  CheckInternationalViewModel checkInternationalViewModel = Get.find();
  GetInvoiceViewModel getInvoiceViewModel = Get.find();
  List<CountryCodeResponseModel>? codeResponseModel;
  ConnectivityViewModel connectivityViewModel = Get.find();
  EncryptedSharedPreferences encryptedSharedPreferences = EncryptedSharedPreferences();
  final _formKey = GlobalKey<FormState>();
  String invAmount = '0';
  String? countryCode;
  bool isInternational = false;

  bool isCode = true;

  @override
  void initState() {
    Utility.countryCodeNumber = '+974';
    Utility.countryCode = 'QA';
    connectivityViewModel.startMonitoring();
    checkInterNational();
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///back  button
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                        ),
                      ),
                      height10(),

                      ///create fast invoice text
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          widget.invoiceDetail == null ? 'Create Quick Invoice'.tr : 'Edit Quick Invoice',
                          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
                        ),
                      ),

                      IgnorePointer(
                        ignoring: widget.invoiceDetail == null
                            ? false
                            : widget.invoiceDetail!['type'] == 2
                                ? true
                                : false,
                        child: isInternational == false
                            ? InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Container(
                                      height: Get.width * 0.13,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: ColorsUtils.border, width: 1)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.book,
                                              color: ColorsUtils.maroon70122E,
                                            ),
                                            width10(),
                                            customSmallSemiText(title: Utility.countryCodeNumber),
                                          ],
                                        ),
                                      ),
                                    ),
                                    width15(),
                                    Expanded(
                                      flex: 5,
                                      child: SizedBox(
                                        child: commonTextField(
                                            contollerr: mobileNumber,
                                            hint: 'Mobile Number'.tr,
                                            validationType: '',
                                            keyType: TextInputType.phone,
                                            regularExpression: TextValidation.digitsValidationPattern,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Number cannot be empty".tr;
                                              }

                                              if (value.substring(0, 4) == '1234') {
                                                return "Mobile number is invalid".tr;
                                              }

                                              if (value.length < 8) {
                                                return "Number should be 8 digit".tr;
                                              }
                                              return null;
                                            },
                                            inputLength: 8),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : IntlPhoneField(invalidNumberMessage: 'Invalid mobile number'.tr,
                                key: UniqueKey(),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(TextValidation.digitsValidationPattern))
                                ],
                                controller: mobileNumber,
                                decoration: InputDecoration(
                                  hintText: 'Mobile number'.tr,
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                disableLengthCheck: false,
                                initialCountryCode: Utility.countryCode,
                                onChanged: (phone) async {
                                  String token = await encryptedSharedPreferences.getString('token');
                                  final url = Uri.parse(
                                    '${Utility.baseUrl}invoices?filter[where][invoicesenderId]=${Utility.userId}&filter[where][cellno]=${phone.countryCode.replaceAll('+', '')}-${phone.number}&filter[skip]=0&filter[limit]=1&filter[fields][clientname]=true',
                                  );
                                  Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
                                  var result = await http.get(
                                    url,
                                    headers: header,
                                  );

                                  print('token is:$token } \n url $url  \n response is :${result.body} ');
                                  if (result.statusCode == 200) {
                                    if (result.body != '[]') {
                                      customerName.text = jsonDecode(result.body)[0]['clientname'].toString();
                                      setState(() {});
                                    }
                                  } else {
                                    print(jsonDecode(result.body)['error']['message']);
                                    // Get.snackbar('error'.tr,
                                    //     '${jsonDecode(result.body)['error']['message']}');
                                  }
                                  print(phone.completeNumber);
                                },
                                onCountryChanged: (country) {
                                  Utility.countryCode = '${country.code}';
                                  Utility.countryCodeNumber = '+${country.dialCode}';
                                  countryCode = country.dialCode;
                                  print('Select countrycode: ${country.code}');
                                  print('Select country: +${country.dialCode}');
                                  setState(() {});
                                  print('Country changed to: ${country.code}Country code ${country.dialCode}');
                                },
                              ),
                      ),
                      height20(),

                      ///mobile number row
                      // Row(
                      //   children: [
                      //     IgnorePointer(
                      //       ignoring: isInternational,
                      //       child: InkWell(
                      //         onTap: () {
                      //           showCountryPicker(
                      //             context: context,
                      //             showPhoneCode:
                      //                 true, // optional. Shows phone code before the country name.
                      //             onSelect: (Country country) {
                      //               // codeName is QA code+974
                      //               Utility.countryCode = '${country.countryCode}';
                      //               Utility.countryCodeNumber =
                      //                   '+${country.phoneCode}';
                      //               countryCode = country.phoneCode;
                      //               print(
                      //                   'Select countrycode: ${country.countryCode}');
                      //               print('Select country: +${country.phoneCode}');
                      //               setState(() {});
                      //             },
                      //           );
                      //         },
                      //         child: Container(
                      //           height: Get.width * 0.13,
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10),
                      //               border: Border.all(
                      //                   color: isCode == false
                      //                       ? ColorsUtils.accent
                      //                       : ColorsUtils.border,
                      //                   width: 1)),
                      //           child: Padding(
                      //             padding:
                      //                 const EdgeInsets.symmetric(horizontal: 15),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               crossAxisAlignment: CrossAxisAlignment.center,
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 const Icon(
                      //                   Icons.book,
                      //                   color: ColorsUtils.maroon70122E,
                      //                 ),
                      //                 customSmallSemiText(
                      //                     title: Utility.countryCodeNumber),
                      //                 // SizedBox(
                      //                 //   child: CountryCodePicker(
                      //                 //     showFlagDialog: true,
                      //                 //     searchDecoration: InputDecoration(
                      //                 //         border: OutlineInputBorder(
                      //                 //             borderRadius:
                      //                 //                 BorderRadius.circular(10),
                      //                 //             borderSide: BorderSide(
                      //                 //                 color: ColorsUtils.border,
                      //                 //                 width: 1))),
                      //                 //     onChanged: (value) {
                      //                 //       setState(() {
                      //                 //         print('code is ${value.code}');
                      //                 //         Utility.countryCode =
                      //                 //             value.code.toString();
                      //                 //         countryCode = value.toString();
                      //                 //         Utility.countryCodeNumber =
                      //                 //             countryCode.toString();
                      //                 //       });
                      //                 //     },
                      //                 //     initialSelection: Utility.countryCode,
                      //                 //     favorite: [
                      //                 //       Utility.countryCodeNumber,
                      //                 //       Utility.countryCode
                      //                 //     ],
                      //                 //     showCountryOnly: false,
                      //                 //     showFlag: false,
                      //                 //     alignLeft: false,
                      //                 //     textStyle: ThemeUtils.blackSemiBold,
                      //                 //     padding: const EdgeInsets.only(right: 1),
                      //                 //     showOnlyCountryWhenClosed: false,
                      //                 //     showDropDownButton: true,
                      //                 //   ),
                      //                 // ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     width10(),
                      //     Expanded(
                      //       flex: 5,
                      //       child: commonTextField(
                      //           contollerr: mobileNumber,
                      //           hint: 'Mobile Number'.tr,
                      //           validationType: '',
                      //           keyType: TextInputType.phone,
                      //           regularExpression:
                      //               TextValidation.digitsValidationPattern,
                      //           validator: (value) {
                      //             if (value!.isEmpty) {
                      //               return "Number cannot be empty".tr;
                      //             }
                      //             // else if (value.length < 10) {
                      //             //   return "Number should be 10 digit".tr;
                      //             // }
                      //             return null;
                      //           },
                      //           inputLength: 10),
                      //     ),
                      //   ],
                      // ),

                      ///customer name
                      SizedBox(
                        child: commonTextField(
                          contollerr: customerName,
                          hint: 'Customer Name'.tr,
                          regularExpression: TextValidation.alphabetSpaceValidationPattern,
                          onChange: (str) {
                            print('lenght${str.length}');
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name cannot be empty".tr;
                            }
                            if (value.length >= 512) {
                              return "max characters allowed are 512";
                            }
                            return null;
                          },
                        ),
                      ),
                      height20(),

                      ///amount
                      SizedBox(
                        child: commonTextField(
                            suffix: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'QAR',
                                style: ThemeUtils.blackSemiBold.copyWith(fontSize: 16),
                              ),
                            ),
                            contollerr: invoiceAmount,
                            hint: 'Invoice Amount'.tr,
                            keyType: TextInputType.numberWithOptions(decimal: true),
                            // keyType: TextInputType.number,
                            onChange: (str) {
                              invAmount = str;
                              setState(() {});
                            },
                            regularExpression: TextValidation.doubleDigitsValidationPattern,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Amount cannot be empty".tr;
                              }
                              if (value == '0') {
                                return "Amount cannot be 0";
                              }
                              if (double.parse(value) < 1) {
                                return "Amount can not be less than QAR 1.00  ";
                              }
                              // if (double.parse(value) > 50000) {
                              //   return "maximum amount should be QAR 50,000.00";
                              // }

                              return null;
                            },
                            inputLength: 20),
                      ),
                      // if ((double.parse(invoiceAmount.text == ''
                      //             ? '0'
                      //             : invoiceAmount.text) <
                      //         1) ||
                      //     (double.parse(invoiceAmount.text == ''
                      //             ? '0'
                      //             : invoiceAmount.text) >
                      //         50000))
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 5),
                      //     child: customVerySmallSemiText(
                      //         title:
                      //             'Amount can not be less than QAR 1.00 and maximum amount should be QAR 50,000.00',
                      //         color: ColorsUtils.reds),
                      //   ),
                      height20(),

                      ///description
                      SizedBox(
                        child: commonTextField(
                          maxLines: 4,
                          contollerr: descriptions,
                          hint: 'Descriptions'.tr,
                          keyType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          onChange: (str) {
                            _formKey.currentState!.validate();
                          },
                          // regularExpression:
                          //     TextValidation.alphabetSpaceValidationPattern,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Description is required!";
                            }
                            if (value.length < 5) {
                              return "Text Need To Be Atleast 5 Character";
                            }
                            if (value.length >= 5000) {
                              return "Description is too long. Maximum 5000 characters allowed.";
                            }
                            // if (value.length < 5) {
                            //   return "description letter should be at list 5";
                            // }
                            return null;
                          },
                        ),
                      ),
                      height40(),

                      ///invoice amount
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorsUtils.border.withOpacity(0.3),
                            border: Border.all(color: ColorsUtils.border, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(children: [
                            Text(
                              'Invoice Amount'.tr,
                              style: ThemeUtils.blackBold,
                            ),
                            const Spacer(),
                            Text(
                              // widget.invoiceDetail != null
                              //     ? widget.invoiceDetail!['grossAmount']
                              //         .toString()
                              //     :
                              '$invAmount QAR',
                              style: ThemeUtils.blackBold
                                  .copyWith(color: ColorsUtils.invoiceAmount, fontSize: FontUtils.mediumSmall),
                            ),
                          ]),
                        ),
                      ),
                      height20(),

                      ///bottom Row
                      Row(
                        children: [
                          widget.invoiceDetail == null
                              ? InkWell(
                                  onTap: () async {
                                    await saveDraftApiCall();
                                  },
                                  child: commonButtonBox(
                                      img: Images.saveDraft, text: 'Save Draft'.tr, color: ColorsUtils.saveDraftButton),
                                )
                              : widget.invoiceDetail!['type'] == 2
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () async {
                                        editInvoiceApiCall('1');
                                      },
                                      child: commonButtonBox(
                                          img: Images.saveDraft, text: 'Save Draft'.tr, color: ColorsUtils.saveDraftButton),
                                    ),
                          widget.invoiceDetail == null
                              ? width20()
                              : widget.invoiceDetail!['type'] == 2
                                  ? SizedBox()
                                  : width20(),
                          Expanded(
                              child: InkWell(
                            onTap: () async {
                              if (widget.invoiceDetail != null) {
                                print('edit inside');
                                editInvoiceApiCall('2');
                              } else {
                                sendInvoiceApiCall();
                              }
                              // widget.invoiceDetail != null
                              //     ? editInvoiceApiCall('2')
                              //     : sendInvoiceApiCall();
                            },
                            child: commonButtonBox(
                                img: Images.send,
                                text: widget.invoiceDetail == null
                                    ? 'Send Invoice'.tr
                                    : widget.invoiceDetail!['type'] == 2
                                        ? 'Save Invoice'.tr
                                        : 'Send Invoice'.tr,
                                color: ColorsUtils.invoiceAmount),
                          )),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ));
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                setState(() {});
                checkInterNational();
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
              checkInterNational();
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

  Future<void> sendInvoiceApiCall() async {
    if (_formKey.currentState!.validate()) {
      connectivityViewModel.startMonitoring();

      if (connectivityViewModel.isOnline != null) {
        if (connectivityViewModel.isOnline!) {
          if (Utility.userPhone != mobileNumber.text) {
            showLoadingDialog(context: context);
            print('validate');
            Utility.invoiceStatusId = '2';
            String id = await encryptedSharedPreferences.getString('id');
            createInvoiceReq.clientname = customerName.text;
            createInvoiceReq.paymentduedate = DateTime.now().toString();
            createInvoiceReq.createdby = id;
            createInvoiceReq.cellno = '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';

            // '${(Utility.countryCodeNumber).contains('+') ? Utility.countryCodeNumber : '+${Utility.countryCodeNumber}'}-${mobileNumber.text}';
            createInvoiceReq.grossamount = invoiceAmount.text;
            createInvoiceReq.remarks = descriptions.text;
            createInvoiceReq.invoicestatusId = Utility.invoiceStatusId;
            createInvoiceReq.invoicesenderId = id;
            createInvoiceReq.remarksenabled = false;
            createInvoiceReq.readreceipt = true;
            final url = Uri.parse('${Utility.baseUrl}invoices');
            String token = await encryptedSharedPreferences.getString('token');
            Map<String, String> header = {
              'Content-Type': 'application/json',
              'Authorization': token,
            };
            // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
            var result = await http.post(
              url,
              headers: header,
              body: jsonEncode(createInvoiceReq),
            );

            print(jsonEncode(createInvoiceReq));
            print('${result.body}');
            if (result.statusCode == 200) {
              Utility.isFastInvoice = true;
              print('is this fast invoice::::::::${Utility.isFastInvoice}');
              print('statusid::${Utility.invoiceStatusId}');

              AnalyticsService.sendEvent('Quick Invoice success', jsonDecode(result.body));
              Get.snackbar('Success'.tr, 'Invoice Send SuccessFully'.tr);
              hideLoadingDialog(context: context);

              Future.delayed(const Duration(seconds: 1), () {
                print('done');
                Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
              });

              // print('invoice id${response.id}');
            } else if (result.statusCode == 499) {
              hideLoadingDialog(context: context);

              Get.off(() => UnderMaintenanceScreen());
            } else {
              hideLoadingDialog(context: context);
              Get.snackbar(
                'error'.tr,
                '${jsonDecode(result.body)['error']['message']}',
              );
              AnalyticsService.sendEvent('Quick Invoice failure', {
                'Id': Utility.userId,
              });
              // Get.snackbar('error'.tr, 'Something wrong');
            }
            // await createInvoiceViewModel.createInvoice(createInvoiceReq);
            // if (createInvoiceViewModel.createInvoiceApiResponse.status ==
            //     Status.COMPLETE) {
            //   Utility.isFastInvoice = true;
            //   print('is this fast invoice::::::::${Utility.isFastInvoice}');
            //   print('statusid::${Utility.invoiceStatusId}');
            //
            //   CreateInvoiceResponseModel response =
            //       createInvoiceViewModel.createInvoiceApiResponse.data;
            //   print('invoice id${response.id}');
            //   AnalyticsService.sendEvent(
            //       'Quick Invoice success', response.toJson());
            //   Get.snackbar('Success'.tr, 'Invoice Send SuccessFully'.tr);
            //   hideLoadingDialog(context: context);
            //
            //   Future.delayed(const Duration(seconds: 1), () {
            //     print('done');
            //     Get.off(() => InvoiceDetailScreen(
            //           invoiceId: response.id.toString(),
            //         ));
            //   });
            // } else {
            //   AnalyticsService.sendEvent('Quick Invoice failure', {
            //     'Id': Utility.userId,
            //   });
            //   hideLoadingDialog(context: context);
            //
            //   Get.snackbar('error'.tr, 'Something Wrong'.tr);
            // }
          } else {
            Get.snackbar('error'.tr, 'you can not create invoice by your self'.tr);
          }
        } else {
          Get.snackbar('error'.tr, 'Please check your connection'.tr);
        }
      } else {
        Get.snackbar('error'.tr, 'Please check your connection'.tr);
      }
    }
  }

  Future<void> editInvoiceApiCall(String status) async {
    print('edit draft calling');
    if (_formKey.currentState!.validate()) {
      connectivityViewModel.startMonitoring();

      if (connectivityViewModel.isOnline != null) {
        if (connectivityViewModel.isOnline!) {
          if (Utility.userPhone != mobileNumber.text) {
            showLoadingDialog(context: context);
            Utility.invoiceStatusId = status;
            print('edit validate$status');
            String id = await encryptedSharedPreferences.getString('id');
            editInvoiceReq.clientname = customerName.text;
            editInvoiceReq.paymentduedate = DateTime.now().toString();
            editInvoiceReq.createdby = id;

            editInvoiceReq.cellno = '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';

            // '${(Utility.countryCodeNumber).contains('+') ? Utility.countryCodeNumber : '+${Utility.countryCodeNumber}'}-${mobileNumber.text}';
            editInvoiceReq.grossamount = invoiceAmount.text;
            editInvoiceReq.remarks = descriptions.text;
            editInvoiceReq.invoicestatusId = int.parse(Utility.invoiceStatusId);
            editInvoiceReq.invoicesenderId = id;
            editInvoiceReq.remarksenabled = false;
            editInvoiceReq.readreceipt = Utility.isNotify;
            final url =
                Uri.parse('${Utility.baseUrl}invoices/${widget.transId}?filter[include][invoicedetails][product]=productmedia');
            String token = await encryptedSharedPreferences.getString('token');
            Map<String, String> header = {
              'Content-Type': 'application/json',
              'Authorization': token,
            };
            print('req is::${jsonEncode(editInvoiceReq)}');
            print('urllllllll$url');
            // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
            var result = await http.patch(
              url,
              headers: header,
              body: jsonEncode(editInvoiceReq),
            );
            if (result.statusCode == 200) {
              Utility.isFastInvoice = true;
              print('statusid::${Utility.invoiceStatusId}');

              // print('invoice id${response.id}');

              Get.snackbar(
                  'Success'.tr,
                  status == '1'
                      ? 'Edit Invoice successFully'.tr
                      : widget.invoiceDetail!['type'] == 2
                          ? 'Invoice Save SuccessFully'
                          : 'Invoice Send SuccessFully');
              hideLoadingDialog(context: context);
              AnalyticsService.sendEvent('Quick Invoice success', jsonDecode(result.body));
              print('invoice id${jsonDecode(result.body)['id']}');

              Future.delayed(const Duration(seconds: 1), () {
                Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
              });
            } else if (result.statusCode == 499) {
              hideLoadingDialog(context: context);

              Get.off(() => UnderMaintenanceScreen());
            } else {
              hideLoadingDialog(context: context);
              print('error${jsonDecode(result.body)['error']['message']}');

              Get.snackbar(
                'error'.tr,
                '${jsonDecode(result.body)['error']['message']}',
              );
              AnalyticsService.sendEvent('Quick Invoice failure', {
                'Id': Utility.userId,
              });
              // Get.snackbar('error'.tr, 'Something wrong');
            }
            // await getInvoiceViewModel.editInvoice(widget.transId!, editInvoiceReq);
            // if (getInvoiceViewModel.editInvoiceApiResponse.status ==
            //     Status.COMPLETE) {
            //   Utility.isFastInvoice = true;
            //   print('statusid::${Utility.invoiceStatusId}');
            //
            //   GetInvoiceResponseModel response =
            //       getInvoiceViewModel.editInvoiceApiResponse.data;
            //   print('invoice id${response.id}');
            //   AnalyticsService.sendEvent(
            //       'Quick Invoice success', response.toJson());
            //   Get.snackbar('Success'.tr, 'Invoice Send successFully'.tr);
            //   hideLoadingDialog(context: context);
            //
            //   Future.delayed(const Duration(seconds: 1), () {
            //     print('done');
            //     Get.off(() => InvoiceDetailScreen(
            //           invoiceId: response.id.toString(),
            //         ));
            //   });
            // } else {
            //   AnalyticsService.sendEvent('Quick Invoice failure', {
            //     'Id': Utility.userId,
            //   });
            //   hideLoadingDialog(context: context);
            //   Get.snackbar('error'.tr, 'Something wrong please check data'.tr);
            // }
          } else {
            Get.snackbar('error'.tr, 'you can not create invoice by your self');
          }
        } else {
          Get.snackbar('error'.tr, 'Please check your connection'.tr);
        }
      } else {
        Get.snackbar('error'.tr, 'Please check your connection'.tr);
      }
    }
  }

  Future<void> saveDraftApiCall() async {
    if (_formKey.currentState!.validate()) {
      print('old is ${Utility.userPhone} new ${mobileNumber.text}');
      connectivityViewModel.startMonitoring();

      if (connectivityViewModel.isOnline != null) {
        if (connectivityViewModel.isOnline!) {
          if (Utility.userPhone != mobileNumber.text) {
            showLoadingDialog(context: context);
            print('validate');
            Utility.invoiceStatusId = '1';
            String id = await encryptedSharedPreferences.getString('id');
            createInvoiceReq.clientname = customerName.text;
            createInvoiceReq.paymentduedate = DateTime.now().toString();
            createInvoiceReq.createdby = id;
            createInvoiceReq.cellno = '${Utility.countryCodeNumber.replaceAll('+', '')}-${mobileNumber.text}';

            // '${(Utility.countryCodeNumber).contains('+') ? Utility.countryCodeNumber : '+${Utility.countryCodeNumber}'}-${mobileNumber.text}';
            createInvoiceReq.grossamount = invoiceAmount.text;
            createInvoiceReq.remarks = descriptions.text;
            createInvoiceReq.invoicestatusId = Utility.invoiceStatusId;
            createInvoiceReq.invoicesenderId = id;
            createInvoiceReq.remarksenabled = false;
            createInvoiceReq.readreceipt = true;

            final url = Uri.parse('${Utility.baseUrl}invoices');
            String token = await encryptedSharedPreferences.getString('token');
            Map<String, String> header = {
              'Content-Type': 'application/json',
              'Authorization': token,
            };
            // Map<String, dynamic>? body = createInvoiceReq as Map<String, dynamic>;
            var result = await http.post(
              url,
              headers: header,
              body: jsonEncode(createInvoiceReq),
            );
            print('req is::$createInvoiceReq');
            if (result.statusCode == 200) {
              Utility.isFastInvoice = true;
              print('statusid::${Utility.invoiceStatusId}');

              // print('invoice id${response.id}');

              Get.snackbar('Success'.tr, 'Save draft successFully'.tr);
              hideLoadingDialog(context: context);
              AnalyticsService.sendEvent('Quick Invoice success', jsonDecode(result.body));
              print('invoice id${jsonDecode(result.body)['id']}');

              Future.delayed(const Duration(seconds: 1), () {
                Get.off(() => InvoiceDetailScreen(
                      invoiceId: jsonDecode(result.body)['id'].toString(),
                    ));
              });
            } else if (result.statusCode == 499) {
              hideLoadingDialog(context: context);

              Get.off(() => UnderMaintenanceScreen());
            } else {
              hideLoadingDialog(context: context);
              AnalyticsService.sendEvent('Quick Invoice failure', {
                'Id': Utility.userId,
              });
              Get.snackbar(
                'error'.tr,
                '${jsonDecode(result.body)['error']['message']}',
              );
              // Get.snackbar('error'.tr, 'Something wrong');
            }

            // await createInvoiceViewModel.createInvoice(createInvoiceReq);
            // if (createInvoiceViewModel.createInvoiceApiResponse.status ==
            //     Status.COMPLETE) {
            //   Utility.isFastInvoice = true;
            //   print('statusid::${Utility.invoiceStatusId}');
            //
            //   CreateInvoiceResponseModel response =
            //       createInvoiceViewModel.createInvoiceApiResponse.data;
            //   print('invoice id${response.id}');
            //
            //   Get.snackbar('Success'.tr, 'Save draft successFully'.tr);
            //   hideLoadingDialog(context: context);
            //   AnalyticsService.sendEvent(
            //       'Quick Invoice success', response.toJson());
            //   Future.delayed(const Duration(seconds: 1), () {
            //     print('done');
            //
            //     Get.off(() => InvoiceDetailScreen(
            //           invoiceId: response.id.toString(),
            //         ));
            //   });
            // } else {
            //   AnalyticsService.sendEvent('Quick Invoice failure', {
            //     'Id': Utility.userId,
            //   });
            //   Get.snackbar('error'.tr, 'Something wrong');
            //   hideLoadingDialog(context: context);
            //
            //   const SessionExpire();
            // }
          } else {
            Get.snackbar('error'.tr, 'you can not create invoice by your self');
          }
        } else {
          Get.snackbar('error'.tr, 'Please check your connection'.tr);
        }
      } else {
        Get.snackbar('error'.tr, 'Please check your connection'.tr);
      }
    }
  }

  initData() async {
    countryCode = Utility.countryCodeNumber;
    if (widget.invoiceDetail != null) {
      ///data
      customerName.text = widget.invoiceDetail!['custName'].toString();
      descriptions.text = widget.invoiceDetail!['description'].toString();
      countryCode = Utility.countryCodeNumber;
      String mob = widget.invoiceDetail!['mobNo'].toString();
      String cc = mob.substring(0, mob.indexOf('-')).replaceAll('+', '');
      String mn = mob.substring(mob.indexOf('-') + 1);
      Utility.countryCodeNumber = cc;
      mobileNumber.text = mn.toString();
      invoiceAmount.text = widget.invoiceDetail!['grossAmount'].toString();
      setState(() {
        invAmount = invoiceAmount.text;
      });
      await countryCodeGetApiCall(cc);
    }
  }

  countryCodeGetApiCall(String cc) async {
    print('in country code');
    await createInvoiceViewModel.countryCode(cc);
    if (createInvoiceViewModel.countryCodeApiResponse.status == Status.LOADING) {
      Center(child: Loader());
    }
    print('status is ${createInvoiceViewModel.countryCodeApiResponse.status}');
    if (createInvoiceViewModel.countryCodeApiResponse.status == Status.COMPLETE) {
      codeResponseModel = createInvoiceViewModel.countryCodeApiResponse.data;
      print('Utility.countryCode  1 ${Utility.countryCode}');
      Utility.countryCode = codeResponseModel![0].countryIsoCode;
      print('Utility.countryCode  2 ${Utility.countryCode}');

      print('Country iso code is ${Utility.countryCode}   res ${codeResponseModel![0].countryIsoCode}');
    }
  }

  checkInterNational() async {
    String id = await encryptedSharedPreferences.getString('id');
    await checkInternationalViewModel.checkInternational(id);
    List<CheckInternationalResponseModel> response = checkInternationalViewModel.checkInternationalApiResponse.data;
    print(' res is ${response[0].isInternational}');
    setState(() {
      isInternational = response[0].isInternational;
      print(' isInternational is $isInternational');
    });
  }
}
