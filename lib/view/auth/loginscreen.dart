// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cryptlib_2_0/cryptlib_2_0.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/home_Controller.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/requestmodel/Auth/loginRequestModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Auth%20/loginResponseModel.dart';
import 'package:sadad_merchat_app/model/apis/api_response.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/update_version_dialog.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/auth/facedetection/biometricPinAuthService.dart';
import 'package:sadad_merchat_app/view/auth/passwordScreen.dart';
import 'package:sadad_merchat_app/view/auth/register/createBusinessAccount.dart';
import 'package:sadad_merchat_app/view/home.dart';
import 'package:sadad_merchat_app/view/splash.dart';
import 'package:sadad_merchat_app/view/underMaintenanceScreen.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/Auth/loginViewModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../staticData/utility.dart';
import '../../util/validations.dart';

class LoginScreen extends StatefulWidget {
  bool? isFromVPNProxy;
  String? VPNMessage;

  LoginScreen({Key? key, this.isFromVPNProxy, this.VPNMessage}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileNumber = TextEditingController();
  bool enLng = true;
  int isAuth = 0;
  final _formKey = GlobalKey<FormState>();
  bool? _hasBioSensor;
  final LocalAuthentication authentication = LocalAuthentication();
  LoginRequestModel loginReq = LoginRequestModel();
  LoginViewModel loginViewModel = Get.find();
  String finger = '';
  String face = '';
  ConnectivityViewModel connectivityViewModel = Get.find();
  HomeController homeController = Get.find();
  bool isBottomSheetShown = false;

  @override
  void initState() {
    getVersion();
    print('code ${Utility.countryCodeNumber}');
    connectivityViewModel.startMonitoring();
    Utility.countryCodeNumber = '+974';
    Utility.countryCode = 'QA';
    Utility.mobNo = '';
    print('num===${Utility.userPhone}');
    //mobileNumber.text = Utility.userPhone;
    deviceToken();
    setupLanguage();
    initData();


    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.isFromVPNProxy == true) {
        if (isBottomSheetShown == false) {
          isBottomSheetShown = true;
          showModelBottomSheet();
        }
      }
    });
    super.initState();
  }
  // Future<void> accountDeletedCheck() async {
  //   if(encryptedSharedPreferences.getString('account_deleted_success') != null) {
  //     String accountDeleted = await encryptedSharedPreferences.getString('account_deleted_success') ?? "";
  //     if(accountDeleted == "yes") {
  //       await encryptedSharedPreferences.setString('account_deleted_success', "no");
  //       accountDeletedDialog(context: context);
  //     }
  //   }
  // }
  showModelBottomSheet() {
    showModalBottomSheet<void>(
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 70,
                        height: 5,
                        child: Divider(color: ColorsUtils.border, thickness: 4),
                      ),
                    ),
                  ),
                  Image.asset(
                    Images.warningIcon,
                    height: 60,
                    width: 60,
                  ),
                  height20(),
                  customSmallMedBoldText(color: ColorsUtils.accent, title: widget.VPNMessage),
                  height30(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (Platform.isAndroid) {
                            exit(0);
                          } else if (Platform.isIOS) {
                            Get.back();
                          }
                        },
                        child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Okay'),
                      )
                    ],
                  ),
                  height30(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  showModelBottomSheetForSubUser() {
    showModalBottomSheet<void>(
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setBottomState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 70,
                        height: 5,
                        child: Divider(color: ColorsUtils.border, thickness: 4),
                      ),
                    ),
                  ),
                  Image.asset(
                    Images.warningIcon,
                    height: 60,
                    width: 60,
                  ),
                  height20(),
                  // customSmallMedBoldText(
                  //     color: ColorsUtils.accent,
                  //     title:"Your user account is not allowed to login from the app,\nYou can login from panel.sadad.qa".tr),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "Your user account is not allowed to login from the app, you can login from ".tr,
                          style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall, color: ColorsUtils.accent),
                          children: const <InlineSpan>[
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: LinkButton(urlLabel: "http://panel.sadad.qa/", url: "http://panel.sadad.qa/"),
                            ),
                          ])),
                  height20(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                          onTap: () async {
                            Get.back();
                          },
                          child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Okay'.tr),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  setupLanguage() async {
    var currentLang = await encryptedSharedPreferences.getString('currnetLanguage');
    Get.updateLocale(Locale(currentLang == '' || currentLang == null ? "en" : currentLang));
    if (currentLang == '' || currentLang == null || currentLang == "en") {
      enLng = true;
    } else {
      enLng = false;
    }
    setState(() {});
  }

  accountDeletedDialog({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, left: 15, right: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: ColorsUtils.black.withOpacity(0.3), blurRadius: 3, offset: Offset(0, 4), spreadRadius: 3)]),
                  padding: EdgeInsets.all(Get.width * .03),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      height20(),
                  Container(width: 35,height: 35,child: Image.asset(Images.delete_account_recovery)),
                      height20(),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          "Are you sure you want to reactivate the account?".tr,
                          textAlign: TextAlign.center,
                          style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small, color: ColorsUtils.black),
                        ),
                      ),
                      height20(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                Get.back();
                                Get.to(() => PasswordScreen(
                                  phoneNumber: mobileNumber.text,
                                ));
                              },
                              child: buildContainerWithoutImage(
                                  width: Get.width * 0.25, style: ThemeUtils.whiteSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.accent, text: 'YES'.tr)),
                          width20(),
                          InkWell(
                              onTap: () {
                                Get.back();
                                if (Platform.isAndroid) {
                                  exit(0);
                                } else if (Platform.isIOS) {
                                  Get.offAll(() => SplashScreen());
                                }
                              },
                              child: buildContainerWithoutImage(
                                  width: Get.width * 0.25, style: ThemeUtils.maroonSemiBold.copyWith(fontSize: FontUtils.mediumSmall), color: ColorsUtils.border, text: 'NO'.tr)),
                        ],
                      ),
                      height20(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getVersion() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var manufacturer = androidInfo.manufacturer;
      var model = androidInfo.model;
      var v = androidInfo.version;
      print('====>>$release');
      print('====>>$sdkInt');
      print('====>>$manufacturer');
      print('====>>$manufacturer');
      print('====>>$model');

      setState(() {
        Utility.androidVersion = sdkInt!.toInt();
      });
      if (widget.isFromVPNProxy != true) {
        checkAuth();
      }
    } else {
      if (widget.isFromVPNProxy != true) {
        checkAuth();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    connectivityViewModel.startMonitoring();

    return GetBuilder<ConnectivityViewModel>(
      builder: (controller) {
        if (controller.isOnline != null) {
          if (controller.isOnline!) {
            return Scaffold(
                body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      backgroundImage(),
                      bottomSheet(),
                      // Positioned(
                      //   top: 50,
                      //   right: 20,
                      //   child: InkWell(
                      //     onTap: () {
                      //       enLng = !enLng;
                      //       Get.updateLocale(Locale(enLng ? 'ar' : 'en'));
                      //       setState(() {});
                      //     },
                      //     child: Text(
                      //       enLng ? 'en' : 'ar',
                      //       style: ThemeUtils.blackBold.copyWith(
                      //           color: ColorsUtils.accent,
                      //           fontSize: FontUtils.medium),
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                          top: 50,
                          left: 20,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorsUtils.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      enLng = false;
                                      Get.updateLocale(Locale('ar'));
                                      encryptedSharedPreferences.setString('currnetLanguage', 'ar');
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: enLng ? ColorsUtils.white : ColorsUtils.accent,
                                      ),
                                      child: Center(
                                        child: customSmallNorText(
                                          title: ' ع',
                                          color: enLng ? ColorsUtils.accent : ColorsUtils.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      enLng = true;
                                      Get.updateLocale(Locale('en'));
                                      encryptedSharedPreferences.setString('currnetLanguage', 'en');
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: !enLng ? ColorsUtils.white : ColorsUtils.accent,
                                      ),
                                      child: Center(
                                        child: customSmallNorText(
                                          title: 'EN',
                                          color: enLng ? ColorsUtils.white : ColorsUtils.accent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ));
          } else {
            print('no data ');
            return InternetNotFound(
              onTap: () async {
                connectivityViewModel.startMonitoring();

                if (connectivityViewModel.isOnline != null) {
                  if (connectivityViewModel.isOnline!) {
                    setState(() {});
                    checkAuth();
                    deviceToken();
                    initData();
                  } else {
                    Get.snackbar('error'.tr, 'Please check your connection');
                  }
                }
              },
            );
          }
        } else {
          return SizedBox();
        }
      },
    );
  }

  Positioned bottomSheet() {
    return Positioned(
      bottom: 0,
      child: Container(
        width: Get.width,
        // height: Get.height * 0.45,
        decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)), color: ColorsUtils.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(children: [
              ///login text
              Text(
                'Login'.tr,
                style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medLarge),
              ),
              height30(),

              ///mob row
              InkWell(
                onTap: () {
                  // showCountryPicker(
                  //   context: context,
                  //   showPhoneCode:
                  //       true, // optional. Shows phone code before the country name.
                  //   onSelect: (Country country) {
                  //     // codeName is QA code+974
                  //     Utility.countryCode = '${country.countryCode}';
                  //     Utility.countryCodeNumber = '+${country.phoneCode}';
                  //     print('Select countrycode: ${country.countryCode}');
                  //     print('Select country: +${country.phoneCode}');
                  //     setState(() {});
                  //   },
                  // );
                },
                child: Row(
                  children: [
                    Container(
                      height: Get.width * 0.13,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: ColorsUtils.border, width: 1)),
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

                            // SizedBox(
                            //   child: CountryCodePicker(
                            //     showFlagDialog: true,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         print(
                            //             'codeName is ${value.code} code${value} ');
                            //         Utility.countryCode = value.code.toString();
                            //         Utility.countryCodeNumber =
                            //             value.toString();
                            //       });
                            //     },
                            //     searchDecoration: InputDecoration(
                            //         border: OutlineInputBorder(
                            //             borderRadius: BorderRadius.circular(10),
                            //             borderSide: BorderSide(
                            //                 color: ColorsUtils.border,
                            //                 width: 1))),
                            //     initialSelection: Utility.countryCode,
                            //     favorite: [
                            //       Utility.countryCodeNumber,
                            //       Utility.countryCode
                            //     ],
                            //     showCountryOnly: false,
                            //     showFlag: false,
                            //     alignLeft: false,
                            //     textStyle: ThemeUtils.blackSemiBold,
                            //     padding: const EdgeInsets.only(right: 1),
                            //     showOnlyCountryWhenClosed: false,
                            //     showDropDownButton: true,
                            //   ),
                            // ),
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
              ),
              // IntlPhoneField(
              //   controller: mobileNumber,
              //   decoration: InputDecoration(
              //     hintText: 'Mobile number'.tr,
              //     counterText: '',
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide: BorderSide(),
              //     ),
              //   ),
              //   disableLengthCheck: false,
              //   initialCountryCode: Utility.countryCode,
              //   onChanged: (phone) {
              //     print(phone.completeNumber);
              //   },
              //   onCountryChanged: (country) {
              //     Utility.countryCode = country.code;
              //     Utility.countryCodeNumber = '+${country.dialCode}';
              //     print(
              //         'Country changed to: ${country.code}Country code ${country.dialCode}');
              //   },
              // ),

              height30(),
              //
              // ///can't login
              // Align(
              //     alignment: Alignment.centerRight,
              //     child: Text(
              //       'Can\'t login?'.tr,
              //       style: ThemeUtils.blackSemiBold,
              //     )),

              ///login button
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    fetchProfileDetails();
                  }
                },
                child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Log in'.tr),
              ),
              height30(),

              ///login by isometric
              // face == '' && finger == ''
              //     ? SizedBox()
              //     : InkWell(
              //         onTap: () async {
              //           await bioDetection();
              //         },
              //         child: Text(
              //           'Login by isometric'.tr,
              //           style: ThemeUtils.blackBold
              //               .copyWith(fontSize: FontUtils.mediumSmall),
              //         ),
              //       ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  face == ''
                      ? SizedBox()
                      : InkWell(
                          onTap: () async {
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return StatefulBuilder(
                            //       builder: (context, setState) {
                            //         return Dialog(
                            //           elevation: 0,
                            //           backgroundColor: Colors.transparent,
                            //           insetPadding:
                            //               EdgeInsets.symmetric(horizontal: 20),
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(20.0)),
                            //           child: Column(
                            //             mainAxisSize: MainAxisSize.min,
                            //             children: [
                            //               Container(
                            //                 decoration: BoxDecoration(
                            //                   borderRadius:
                            //                       BorderRadius.circular(20),
                            //                   color: ColorsUtils.auth,
                            //                 ),
                            //                 width: Get.width,
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.all(30),
                            //                   child: Column(
                            //                     children: [
                            //                       Container(
                            //                         decoration: BoxDecoration(
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(15)),
                            //                         child: Padding(
                            //                           padding:
                            //                               const EdgeInsets.all(
                            //                                   5),
                            //                           child: Row(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.min,
                            //                             children: [
                            //                               InkWell(
                            //                                 onTap: () {
                            //                                   isAuth = 1;
                            //                                   setState(() {});
                            //                                 },
                            //                                 child: Container(
                            //                                   decoration: BoxDecoration(
                            //                                       color:
                            //                                           ColorsUtils
                            //                                               .white,
                            //                                       borderRadius:
                            //                                           BorderRadius
                            //                                               .circular(
                            //                                                   10)),
                            //                                   child: Padding(
                            //                                     padding:
                            //                                         const EdgeInsets
                            //                                                 .all(
                            //                                             8.0),
                            //                                     child: Center(
                            //                                         child: customSmallBoldText(
                            //                                             color: ColorsUtils
                            //                                                 .black,
                            //                                             title: "Face".tr +
                            //                                                 ' Authentication'.tr)),
                            //                                   ),
                            //                                 ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       height30(),
                            //                       customMediumBoldText(
                            //                           title:
                            //                               'Authentication required'
                            //                                   .tr,
                            //                           color: ColorsUtils.white),
                            //                       height10(),
                            //                       customSmallSemiText(
                            //                           color: ColorsUtils.white,
                            //                           title:
                            //                               'Verify identity'.tr),
                            //                       height20(),
                            //                       AnimatedTextKit(
                            //                         repeatForever: true,
                            //                         animatedTexts: [
                            //                           FadeAnimatedText(
                            //                               'Scan your Face to authenticate'
                            //                                   .tr,
                            //                               textStyle: ThemeUtils
                            //                                   .whiteBold
                            //                                   .copyWith(
                            //                                       fontSize:
                            //                                           FontUtils
                            //                                               .mediumSmall),
                            //                               duration: Duration(
                            //                                   seconds: 5)),
                            //                         ],
                            //                         onTap: () async {
                            //                           if (await encryptedSharedPreferences
                            //                                   .getString(
                            //                                       'bioDetectionFace') ==
                            //                               'true') {
                            //                             _checkBio();
                            //                           } else {
                            //                             Get.snackbar('error',
                            //                                 'Setup FaceDetection from setting');
                            //                           }
                            //                         },
                            //                       ),
                            //                       // InkWell(
                            //                       //   onTap: () async {
                            //                       //     if (await encryptedSharedPreferences
                            //                       //             .getString(
                            //                       //                 'bioDetectionFace') ==
                            //                       //         'true') {
                            //                       //       _checkBio();
                            //                       //     } else {
                            //                       //       Get.snackbar('error',
                            //                       //           'Setup FaceDetection from setting');
                            //                       //     }
                            //                       //   },
                            //                       //   child: customMediumSemiText(
                            //                       //       title:
                            //                       //           'Scan your Face to authenticate'
                            //                       //               .tr,
                            //                       //       color:
                            //                       //           ColorsUtils.white),
                            //                       // ),
                            //                       height30(),
                            //                       InkWell(
                            //                         onTap: () {
                            //                           Get.back();
                            //                         },
                            //                         child: customMediumBoldText(
                            //                             title: 'Cancel'.tr,
                            //                             color:
                            //                                 ColorsUtils.white),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         );
                            //       },
                            //     );
                            //   },
                            // );
                            isAuth = 1;
                            setState(() {});
                            if (await encryptedSharedPreferences.getString('bioDetectionFace') == 'true') {
                              _checkBio();
                            } else {
                              Get.snackbar('error', 'Setup FaceDetection from setting');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: ColorsUtils.accent, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Center(child: Image.asset(Images.faceImage, width: 30)),
                            ),
                          ),
                        ),
                  face == '' ? SizedBox() : width30(),
                  finger == ''
                      ? SizedBox()
                      : InkWell(
                          onTap: () async {
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return StatefulBuilder(
                            //       builder: (context, setState) {
                            //         return Dialog(
                            //           elevation: 0,
                            //           backgroundColor: Colors.transparent,
                            //           insetPadding: EdgeInsets.zero,
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(20.0)),
                            //           child: Column(
                            //             mainAxisSize: MainAxisSize.min,
                            //             children: [
                            //               Container(
                            //                 decoration: BoxDecoration(
                            //                   borderRadius:
                            //                       BorderRadius.circular(20),
                            //                   color: ColorsUtils.auth,
                            //                 ),
                            //                 width: Get.width,
                            //                 child: Padding(
                            //                   padding: const EdgeInsets.all(30),
                            //                   child: Column(
                            //                     children: [
                            //                       Container(
                            //                         decoration: BoxDecoration(
                            //                             // color:
                            //                             //     ColorsUtils.black,
                            //                             borderRadius:
                            //                                 BorderRadius
                            //                                     .circular(15)),
                            //                         child: Padding(
                            //                           padding:
                            //                               const EdgeInsets.all(
                            //                                   5),
                            //                           child: Row(
                            //                             mainAxisSize:
                            //                                 MainAxisSize.min,
                            //                             children: [
                            //                               InkWell(
                            //                                 onTap: () {
                            //                                   isAuth = 0;
                            //
                            //                                   setState(() {});
                            //                                 },
                            //                                 child: Container(
                            //                                   decoration: BoxDecoration(
                            //                                       color: isAuth ==
                            //                                               0
                            //                                           ? ColorsUtils
                            //                                               .white
                            //                                           : ColorsUtils
                            //                                               .black,
                            //                                       borderRadius:
                            //                                           BorderRadius
                            //                                               .circular(
                            //                                                   10)),
                            //                                   child: Padding(
                            //                                     padding:
                            //                                         const EdgeInsets
                            //                                                 .all(
                            //                                             8.0),
                            //                                     child: Center(
                            //                                         child: customSmallBoldText(
                            //                                             color: isAuth ==
                            //                                                     0
                            //                                                 ? ColorsUtils
                            //                                                     .black
                            //                                                 : ColorsUtils
                            //                                                     .white,
                            //                                             title: "Fingerprint"
                            //                                                 .tr)),
                            //                                   ),
                            //                                 ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       height30(),
                            //                       customMediumBoldText(
                            //                           title:
                            //                               'Authentication required'
                            //                                   .tr,
                            //                           color: ColorsUtils.white),
                            //                       height10(),
                            //                       customSmallSemiText(
                            //                           color: ColorsUtils.white,
                            //                           title:
                            //                               'Verify identity'.tr),
                            //                       height20(),
                            //                       InkWell(
                            //                         onTap: () async {
                            //                           if (isAuth == 1) {
                            //                             if (await encryptedSharedPreferences
                            //                                     .getString(
                            //                                         'bioDetectionFace') ==
                            //                                 'true') {
                            //                               _checkBio();
                            //                             } else {
                            //                               Get.snackbar('error',
                            //                                   'Setup FaceDetection from setting');
                            //                             }
                            //                           }
                            //                         },
                            //                         child: customMediumSemiText(
                            //                             title: isAuth == 1
                            //                                 ? 'Scan your Face to authenticate'
                            //                                     .tr
                            //                                 : 'Scan your fingerprint to authenticate'
                            //                                     .tr,
                            //                             color:
                            //                                 ColorsUtils.white),
                            //                       ),
                            //                       height30(),
                            //                       InkWell(
                            //                         onTap: () {
                            //                           Get.back();
                            //                         },
                            //                         child: customMediumBoldText(
                            //                             title: 'Cancel'.tr,
                            //                             color:
                            //                                 ColorsUtils.white),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //               height30(),
                            //               isAuth == 1
                            //                   ? SizedBox()
                            //                   : InkWell(
                            //                       onTap: () async {
                            //                         if (await encryptedSharedPreferences
                            //                                 .getString(
                            //                                     'bioDetectionFinger') ==
                            //                             'true') {
                            //                           _checkBio();
                            //                         } else {
                            //                           Get.snackbar('error',
                            //                               'setup fingerprint from setting');
                            //                         }
                            //                       },
                            //                       child: Container(
                            //                         width: Get.width * 0.2,
                            //                         height: Get.height * 0.07,
                            //                         child: Image.asset(
                            //                             Images.fingerAuth),
                            //                       ),
                            //                     )
                            //             ],
                            //           ),
                            //         );
                            //       },
                            //     );
                            //   },
                            // );
                            isAuth = 0;

                            setState(() {});
                            if (await encryptedSharedPreferences.getString('bioDetectionFinger') == 'true') {
                              _checkBio();
                            } else {
                              Get.snackbar('error', 'setup fingerprint from setting');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: ColorsUtils.accent, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Center(child: Image.asset(Images.fingerImage, width: 30)),
                            ),
                          ),
                        ),
                ],
              ),
              face == '' && finger == '' ? SizedBox() : height20(),

              ///register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?'.tr,
                    style: ThemeUtils.blackRegular,
                  ),
                  InkWell(
                    onTap: () {
                      mobileNumber.clear();
                      initData();
                      Get.to(() => CreateBusinessAccount());
                    },
                    child: Text(
                      ' ' + 'Register'.tr,
                      style: ThemeUtils.blackBold.copyWith(color: ColorsUtils.accent),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> bioDetection() async {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ColorsUtils.auth,
                    ),
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(color: ColorsUtils.black, borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        isAuth = 0;

                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: isAuth == 0 ? ColorsUtils.white : ColorsUtils.black, borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: customSmallBoldText(color: isAuth == 0 ? ColorsUtils.black : ColorsUtils.white, title: "Fingerprint".tr)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        isAuth = 1;

                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(color: isAuth == 1 ? ColorsUtils.white : ColorsUtils.black, borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: customSmallBoldText(color: isAuth == 1 ? ColorsUtils.black : ColorsUtils.white, title: "Face".tr)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          height30(),
                          customMediumBoldText(title: 'Authentication required'.tr, color: ColorsUtils.white),
                          height10(),
                          customSmallSemiText(color: ColorsUtils.white, title: 'Verify identity'.tr),
                          height20(),
                          InkWell(
                            onTap: () async {
                              if (isAuth == 1) {
                                if (await encryptedSharedPreferences.getString('bioDetectionFace') == 'true') {
                                  _checkBio();
                                } else {
                                  Get.snackbar('error', 'Setup FaceDetection from setting');
                                }
                              }
                            },
                            child: customMediumSemiText(title: isAuth == 1 ? 'Scan your Face to authenticate'.tr : 'Scan your fingerprint to authenticate'.tr, color: ColorsUtils.white),
                          ),
                          height30(),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: customMediumBoldText(title: 'Cancel'.tr, color: ColorsUtils.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  height30(),
                  isAuth == 1
                      ? SizedBox()
                      : InkWell(
                          onTap: () async {
                            if (await encryptedSharedPreferences.getString('bioDetectionFinger') == 'true') {
                              _checkBio();
                            } else {
                              Get.snackbar('error', 'setup fingerprint from setting');
                            }
                          },
                          child: Container(
                            width: Get.width * 0.2,
                            height: Get.height * 0.07,
                            child: Image.asset(Images.fingerAuth),
                          ),
                        )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Container backgroundImage() {
    return Container(
      height: Get.height,
      width: Get.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                Images.loginBack,
                // Images.loginChange,
              ),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 70),
            child: InkWell(
              onTap: () => getVersion(),
              child: Image.asset(
                Images.sadadLogo,
                height: 100,
                width: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkBio() async {
    try {
      _hasBioSensor = await authentication.canCheckBiometrics;
      if (_hasBioSensor!) {
        isAuth == 1
            ? Platform.isAndroid
                ? Utility.androidVersion >= 32
                    ? goToNextPage()
                    : Get.snackbar('error', 'device does not have hardware support for biometrics'.tr)
                : goToNextPage()
            : _getAuth();
      }
      print('_hasBioSensor===$_hasBioSensor');
      if (_hasBioSensor == false) {
        Get.back();
        Get.snackbar('error'.tr, 'Device Not Supported'.tr);
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _getAuth() async {
    bool isAuthe = false;
    String cellNo = await encryptedSharedPreferences.getString('bioNumber');
    String pass = await encryptedSharedPreferences.getString('bioPass');

    try {
      isAuthe = await authentication.authenticate(localizedReason: 'Scan your Fingerprint', options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: true, stickyAuth: true));

      if (isAuthe) {
        if (cellNo == '' || pass == '') {
          Get.snackbar('error'.tr, 'Please first do login!!');
          Get.to(() => SplashScreen());
        } else {
          await encryptedSharedPreferences.setString('fromReg', 'false');

          ///authentication

          ///authentication
          showLoadingDialog(context: context);
          // await encryptedSharedPreferences.setString('token', '');
          print('no is $cellNo  pass $pass');

          final url = Uri.parse('${Utility.baseUrl}users/login');
          Map<String, String> header = {'Content-Type': 'application/json'};
          Map<String, dynamic>? body = {"cellnumber": cellNo, "password": pass, "devicetoken": Utility.deviceId, "signinForSignup": true};
          var result = await http.post(url, headers: header, body: jsonEncode(body));
          if (result.statusCode == 200) {
            hideLoadingDialog(context: context);
            Utility.userPhone = await encryptedSharedPreferences.getString('bioNumber');
            print('phone${Utility.userPhone}');
            await encryptedSharedPreferences.setString('isSubmerchantEnabled', '${jsonDecode(result.body)['isSubmerchantEnabled'].toString()}');

            await encryptedSharedPreferences.setString('isSubMarchantAvailable', '${jsonDecode(result.body)['isSubMarchantAvailable'].toString()}');
            await encryptedSharedPreferences.setString(
                'isDocExpired',
                '${jsonDecode(result.body)['isDocExpired'].toString()}');
            await encryptedSharedPreferences.setString(
                'promtDocMessageEn',
                '${jsonDecode(result.body)['promtDocMessageEn'].toString()}');
            await encryptedSharedPreferences.setString(
                'promtDocMessageAr',
                '${jsonDecode(result.body)['promtDocMessageAr'].toString()}');
            Utility.name = jsonDecode(result.body)['name'].toString();
            print("res token ${jsonDecode(result.body)['id'].toString()}");
            await encryptedSharedPreferences.setString('id', '${jsonDecode(result.body)['userId'].toString()}');
            await encryptedSharedPreferences.setString('token', jsonDecode(result.body)['id'].toString());
            Utility.userId = jsonDecode(result.body)['userId'].toString();
            await encryptedSharedPreferences.setString('sadadId', jsonDecode(result.body)['SadadId'].toString());
            // hideLoadingDialog(context: context);
            Utility.countryCodeNumber = '+974';
            Utility.countryCode = 'QA';
            Utility.mobNo = '';
            AnalyticsService.sendLoginEvent('${Utility.userId}');

            Future.delayed(Duration(seconds: 1), () {
              Get.snackbar('success'.tr, 'login successfully'.tr);
              homeController.initBottomIndex = 0;

              Get.off(() => HomeScreen());
            });
          } else if (result.statusCode == 499) {
            hideLoadingDialog(context: context);

            Get.off(() => UnderMaintenanceScreen());
          } else {
            hideLoadingDialog(context: context);

            Get.snackbar(
              'error'.tr,
              '${jsonDecode(result.body)['error']['message']}',
            );
          }
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  // Future<void> _checkDeviceSupport() async {
  //   bool isSupport = await BiometricPinAuthService.checkDeviceAuthSupport();
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //             title: const Text("Device Auth Support"),
  //             content: isSupport
  //                 ? const Text("Device Supported")
  //                 : const Text("Device Not Supported"));
  //       });
  // }

  void goToNextPage() async {
    bool authStatus = await BiometricPinAuthService.authenticateBioMetrics();
    String cellNo = await encryptedSharedPreferences.getString('bioNumber');
    String pass = await encryptedSharedPreferences.getString('bioPass');

    print('authStatus::;$authStatus');
    if (authStatus) {
      if (cellNo == '' || pass == '') {
        Get.snackbar('error'.tr, 'Please first do login!!');
        Get.to(() => SplashScreen());
      } else {
        await encryptedSharedPreferences.setString('fromReg', 'false');

        ///authentication
        showLoadingDialog(context: context);
        // await encryptedSharedPreferences.setString('token', '');

        print('no is $cellNo  pass $pass');

        final url = Uri.parse('${Utility.baseUrl}users/login');
        Map<String, String> header = {'Content-Type': 'application/json'};
        Map<String, dynamic>? body = {"cellnumber": cellNo, "password": pass, "devicetoken": Utility.deviceId, "signinForSignup": true};
        var result = await http.post(url, headers: header, body: jsonEncode(body));
        if (result.statusCode == 200) {
          hideLoadingDialog(context: context);
          Utility.userPhone = await encryptedSharedPreferences.getString('bioNumber');
          print('phone${Utility.userPhone}');

          print("res token ${jsonDecode(result.body)['id'].toString()}");
          await encryptedSharedPreferences.setString('id', '${jsonDecode(result.body)['userId'].toString()}');

          await encryptedSharedPreferences.setString('token', jsonDecode(result.body)['id'].toString());

          Utility.userId = jsonDecode(result.body)['userId'].toString();
          // hideLoadingDialog(context: context);
          Utility.countryCodeNumber = '+974';
          Utility.countryCode = 'QA';
          Utility.mobNo = '';
          AnalyticsService.sendLoginEvent('${Utility.userId}');

          Future.delayed(Duration(seconds: 1), () {
            Get.snackbar('success'.tr, 'login successfully'.tr);
            homeController.initBottomIndex = 0;

            Get.off(() => HomeScreen());
          });
        } else if (result.statusCode == 499) {
          hideLoadingDialog(context: context);

          Get.off(() => UnderMaintenanceScreen());
        } else {
          hideLoadingDialog(context: context);

          Get.snackbar(
            'error'.tr,
            '${jsonDecode(result.body)['error']['message']}',
          );
        }

        // if (loginViewModel.loginApiResponse.status == Status.COMPLETE) {
        //   // Utility.mobNo =
        //   //     await encryptedSharedPreferences.getString('bioNumber');
        //
        //   ///
        // } else {
        //   hideLoadingDialog(context: context);
        //   Get.to(() => SplashScreen());
        // }
      }
    } else {
      print('failed');
      Get.back();
      // Get.snackbar(
      //     'error', 'device does not have hardware support for biometrics');

      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return const AlertDialog(
      //           title: Text("Authentication"),
      //           content: Text(
      //             "Failed",
      //             style: TextStyle(color: Colors.red),
      //           ));
      //     });
    }
  }

  initData() async {
    // Future.delayed(Duration(seconds: 2), (){
    //   accountDeletedCheck();
    // });
    String localNo = await encryptedSharedPreferences.getString('mobileNo.');
    // if (localNo != null || localNo != '') {
    //   mobileNumber.text = localNo;
    //   print('local no:::::$localNo');
    //   setState(() {});
    // }
    final url = Uri.parse('${Utility.baseUrl}users/login');
    Map<String, String> header = {'Content-Type': 'application/json'};
    Map<String, dynamic>? body = {"cellnumber": "987678653627", "password": 'U#2&SAy@W[_!pjD\$', "signinForSignup": true};
    print(url);
    var result = await http.post(
      url,
      headers: header,
      body: jsonEncode(body),
    );
    if (result.statusCode == 200) {
      await encryptedSharedPreferences.setString('token', jsonDecode(result.body)['id']);
      print('token is:${jsonDecode(result.body)['id']} \n req is : ${jsonEncode(body)}  \n response is :${result.body} ');
    } else if (result.statusCode == 499) {
      Get.off(() => UnderMaintenanceScreen());
    }
  }

  Future<void> fetchProfileDetails() async {
    var token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}users/findOne?filter[where][cellnumber]=${mobileNumber.text}&[secured]=true');
    Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
    print('token is $token');

    var result = await http.get(
      url,
      headers: header,
    );
    if (result.statusCode == 200) {
      print(result.body);

      final str2 = utf8.decode(base64.decode(jsonDecode(result.body)['data']));

      final text = CryptLib.instance.decryptCipherTextWithRandomIV(str2, "XDRvx?#Py^5V@3jC");
      print("DecryptedText ${text}");
      print("DecryptedText ${jsonDecode(text)['profilepic']}");
      print("DecryptedText ${jsonDecode(text)['name']}");
      await encryptedSharedPreferences.setString('posActivatedDate', jsonDecode(text)['posactivated'] ?? "");
      await encryptedSharedPreferences.setString('requestfordeleteaccount', jsonDecode(text)['requestfordeleteaccount'] == true ? "true" : "fasle");
      var roleId = jsonDecode(text)['roleId'].toString();
      var requestfordeleteaccount = jsonDecode(text)['requestfordeleteaccount'] == true ? "true" : "false";
      if (roleId != "14" && roleId != "16" && roleId != "17" && roleId != "2") {
        if(requestfordeleteaccount == "true") {
          accountDeletedDialog(context: context);
        } else {
          Get.to(() => PasswordScreen(
            phoneNumber: mobileNumber.text,
          ));
        }
      } else {
        //Get.snackbar('Alert'.tr, 'Your user account is not allowed to login from the app,\nYou can login from panel.sadad.qa'.tr);
        showModelBottomSheetForSubUser();
      }
    } else {
      //hideLoadingDialog(context: context);
      Get.snackbar(
        'error'.tr,
        '${jsonDecode(result.body)['error']['message']}',
      );
    }
    //isLoading = false;
    setState(() {});
  }

  Future<String?> deviceToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    Utility.deviceId = fcmToken!;
  }

  checkAuth() async {
    print('Auth is $face$finger');
    face = await encryptedSharedPreferences.getString('bioDetectionFace');
    finger = await encryptedSharedPreferences.getString('bioDetectionFinger');
    if (face == 'false') {
      face = '';
      setState(() {});
    }
    if (finger == 'false') {
      finger = '';
      setState(() {});
    }

    print('Auth is ${face == '' && finger == ''}');
    print('finger $finger');
    print('face $face');

    ///bio detection
    setState(() {});

    if (face == '' && finger == '') {
      print('not auth');
    } else {
      setState(() {});
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        print('auth is ok');
        if (finger != '' || face != '') {
          isAuth = 0;
          _checkBio();
        } else if (finger != '') {
          isAuth = 0;
          _checkBio();
        } else if (face != '') {
          isAuth = 1;
          _checkBio();
        }
      });
    }
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({Key? key, required this.urlLabel, required this.url}) : super(key: key);

  final String urlLabel;
  final String url;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        minimumSize: const Size(0, 0),
        textStyle: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall, color: Colors.blue),
      ),
      onPressed: () {
        _launchUrl(url);
      },
      child: Text(
        urlLabel,
        style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall, color: Colors.blueAccent, decoration: TextDecoration.underline),
      ),
    );
  }
}
