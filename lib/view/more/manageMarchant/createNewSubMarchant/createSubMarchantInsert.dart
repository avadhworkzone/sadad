import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sadad_merchat_app/view/more/manageMarchant/createNewSubMarchant/setPassSubMarchant.dart';

import '../../../../base/constants.dart';
import '../../../../main.dart';
import '../../../../model/apimodels/responseModel/Auth /countryListModel.dart';
import '../../../../staticData/common_widgets.dart';
import '../../../../staticData/utility.dart';
import '../../../../util/utils.dart';
import '../../../../util/validations.dart';
import '../../../../viewModel/more/bank/bankAccountViewModel.dart';
import '../../../../viewModel/more/businessInfo/businessInfoViewModel.dart';
import '../../../../widget/svgIcon.dart';
import '../../moreOtpScreen.dart';
import '../manageMerchantOTP.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;


class createMarchantInsertScreen extends StatefulWidget {

  BusinessInfoViewModel? bussinessDetails;

  createMarchantInsertScreen({
    Key? key,
    required this.bussinessDetails,
  }) : super(key: key);

  @override
  State<createMarchantInsertScreen> createState() => _createMarchantInsertScreenState();
}

class _createMarchantInsertScreenState extends State<createMarchantInsertScreen> {
  @override
  TextEditingController zone = TextEditingController();
  TextEditingController streetNo = TextEditingController();
  TextEditingController bldgNo = TextEditingController();
  TextEditingController unitNo = TextEditingController();
  TextEditingController businessName = TextEditingController();
  TextEditingController businessRegistrationNumber = TextEditingController();
  TextEditingController emailId = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();

  bool isbusinessNameChange = false;
  bool isbusinessRegistrationNumberChange = false;
  bool isemailIdChange = false;
  bool isunitNoChange = false;
  bool isbldgNoChange = false;
  bool isstreetNoChange = false;
  bool iszoneChange = false;
  bool ismobileNumberChange = false;
  bool hideActionBtn = false;

  bool isInQutar = true;
  List<CountryData> countryList = [];

  final cnt = Get.find<BusinessInfoViewModel>();
  final _formKey = GlobalKey<FormState>();
  bool isSelected = false;

  String? currentMediaTypeID = '';
  final bankA = Get.find<BankAccountViewModel>();
  Map<String, Map<String, dynamic>> businessDoc = {};
  String? tokenMain;
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  bool readOnly = false;

  initState(){
    //businessName.text = widget.bussinessDetails!.businessInfoModel.value.businessname!;
    emailId.text = widget.bussinessDetails!.businessInfoModel.value.user!.email ?? "";
    mobileNumber.text = widget.bussinessDetails!.businessInfoModel.value.user?.cellnumber ?? "";
    //businessRegistrationNumber.text = widget.bussinessDetails!.businessInfoModel.value.merchantregisterationnumber ?? "";
    //streetNo.text = widget.bussinessDetails!.businessInfoModel.value.streetnumber ?? "";
    //bldgNo.text = widget.bussinessDetails!.businessInfoModel.value.buildingnumber ?? "";
    //unitNo.text = widget.bussinessDetails!.businessInfoModel.value.unitnumber ?? "";
    //zone.text = widget.bussinessDetails!.businessInfoModel.value.zonenumber ?? "";
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Create Merchant".tr, style: TextStyle(fontSize: FontUtils.medLarge, fontWeight: FontWeight.w600)),
          leading: InkWell(
              onTap: () {
                if(businessName.text == "" && businessRegistrationNumber.text == "" && zone.text == "" && streetNo.text == "" && bldgNo.text == "" && unitNo.text == "" && mobileNumber.text == widget.bussinessDetails!.businessInfoModel.value.user?.cellnumber && emailId.text == widget.bussinessDetails!.businessInfoModel.value.user?.email)
                {
                  Get.back();
                } else {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are you sure?'.tr),
                          content: Text("The changes won't be saved".tr),
                          actions: <Widget>[
                            TextButton(
                                child: Text('Yes'.tr),
                                onPressed: () async {
                                  Get.close(2);
                                }),
                            TextButton(
                                child: Text('No'.tr),
                                onPressed: () async {
                                  Get.close(1);
                                }),
                          ],
                        );
                      });
                }
                setState(() {});
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 25)),
          backgroundColor: Colors.white,
          elevation: 0),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Column(
                    children: [
                      commonTextField(
                        contollerr: businessName,
                        hint: "Business name".tr,
                        isRead: readOnly,
                        regularExpression: r'[A-Za-z ]',
                        validator: (value) {
                          if (value == cnt.businessInfoModel.value.businessname!) {
                            isbusinessNameChange = false;
                          } else {
                            isbusinessNameChange = true;
                          }
                          if (value!.isEmpty) {
                            return "Business name cannot be empty".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      height20(),
                      commonTextField(
                        contollerr: businessRegistrationNumber,
                        keyType: TextInputType.emailAddress,
                        errorText: crError,
                        validationType: TextValidation.digitsValidationPattern,
                        regularExpression: r'[0-9-/]',
                        isRead: readOnly,
                        hint: "Business Registration Number".tr,
                        inputLength: 12,
                        onChange: (str) {
                          if (isSelected == true) {
                            _formKey.currentState!.validate();
                          }
                          if (str.length > 3) {
                            checkCRNumber();
                          }
                        },
                        validator: (value) {
                          if (value == cnt.businessInfoModel.value.merchantregisterationnumber) {
                            isbusinessRegistrationNumberChange = false;
                          } else {
                            isbusinessRegistrationNumberChange = true;
                          }
                          if (value!.isEmpty) {
                            return "Business Registration Number cannot be empty".tr;
                          }

                          if (value.length < 3) {
                            return "Required minimum 3 characters".tr;
                          } else {
                            return null;
                          }

                        },
                      ),
                      height20(),
                      commonTextField(
                        errorText: emailError,
                        isRead: readOnly,
                        onChange: (str) {
                          bool changeEmail = false;
                          if (str == cnt.businessInfoModel.value.user!.email) {
                            changeEmail = false;
                            setState(() {
                              emailError = null;
                            });
                          } else {
                            changeEmail = true;
                          }
                          if (changeEmail && str.contains("@")) {
                            checkEmail();
                          }
                        },
                        contollerr: emailId,
                        hint: "Email ID".tr,
                        validator: (value) {
                          if (value == cnt.businessInfoModel.value.user!.email) {
                            isemailIdChange = false;
                          } else {
                            isemailIdChange = true;
                          }
                          if (emailError != null) {
                            return emailError;
                          }
                          if (value!.isEmpty) {
                            return "Email ID cannot be empty".tr;
                          } else {
                            String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                            RegExp regex = RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Enter a valid email address'.tr;
                            else
                              return null;
                          }
                        },
                      ),
                      height20(),
                      commonTextField(
                        errorText: mobileError,
                        isRead: readOnly,
                        inputLength: 8,
                        onChange: (str) {
                          bool mobileChange = false;
                          if (str == cnt.businessInfoModel.value.user!.cellnumber) {
                            mobileChange = false;
                            setState(() {
                              mobileError = null;
                            });
                          } else {
                            mobileChange = true;
                          }
                          print(mobileChange);
                          if (mobileChange && str.length >= 8) {
                            checkMobileNumber();
                          }
                        },
                        contollerr: mobileNumber,
                        keyType: TextInputType.number,
                        hint: "Mobile Number".tr,
                        validator: (value) {
                          if (value == cnt.businessInfoModel.value.user!.cellnumber) {
                            ismobileNumberChange = false;
                          } else {
                            ismobileNumberChange = true;
                          }
                          if (mobileError != null) {
                            return mobileError;
                          }
                          if (value!.isEmpty) {
                            return "Mobile Number cannot be empty".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      height20(),
                      commonTextField(
                        contollerr: zone,
                        isRead: readOnly,
                        // maxLength: 4,
                        validationType: TextValidation.digitsValidationPattern,
                        keyType: TextInputType.number,
                        regularExpression: r'[0-9]',
                        hint: "Zone".tr,
                        inputLength: 3,

                        onChange: (str) {
                          if (isSelected == true) {
                            _formKey.currentState!.validate();
                          }
                        },
                        validator: (value) {
                          if (value == cnt.businessInfoModel.value.zonenumber) {
                            iszoneChange = false;
                          } else {
                            iszoneChange = true;
                          }
                          if (value!.isEmpty) {
                            return "Zone cannot be empty".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      height20(),
                      Row(
                        children: [
                          commonTextField(
                            contollerr: streetNo,
                            isRead: readOnly,
                            hint: 'Street no.'.tr,
                            width: 155,
                            validationType: TextValidation.digitsValidationPattern,
                            keyType: TextInputType.number,
                            regularExpression: r'[0-9]',
                            inputLength: 3,
                            onChange: (str) {
                              if (isSelected == true) {
                                _formKey.currentState!.validate();
                              }
                            },
                            validator: (value) {
                              if (value == cnt.businessInfoModel.value.streetnumber) {
                                isstreetNoChange = false;
                              } else {
                                isstreetNoChange = true;
                              }
                              if (value!.isEmpty) {
                                return "Street cannot be empty".tr;
                              }
                              return null;
                            },
                          ),
                          Spacer(),
                          commonTextField(
                            contollerr: bldgNo,
                            hint: 'Bldg.no.'.tr,
                            isRead: readOnly,
                            validationType: TextValidation.digitsValidationPattern,
                            keyType: TextInputType.number,
                            regularExpression: r'[0-9]',
                            inputLength: 3,
                            width: 155,
                            onChange: (str) {
                              if (isSelected == true) {
                                _formKey.currentState!.validate();
                              }
                            },
                            validator: (value) {
                              if (value == cnt.businessInfoModel.value.buildingnumber) {
                                isbldgNoChange = false;
                              } else {
                                isbldgNoChange = true;
                              }
                              if (value!.isEmpty) {
                                return "Bldg cannot be empty".tr;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      height20(),
                      commonTextField(
                        contollerr: unitNo,
                        hint: 'Unit no.'.tr,
                        isRead: readOnly,
                        validationType: TextValidation.digitsValidationPattern,
                        keyType: TextInputType.number,
                        regularExpression: r'[0-9]',
                        inputLength: 3,
                        onChange: (str) {
                          if (isSelected == true) {
                            _formKey.currentState!.validate();
                          }
                        },
                        validator: (value) {
                          if (value == cnt.businessInfoModel.value.unitnumber) {
                            isunitNoChange = false;
                          } else {
                            isunitNoChange = true;
                          }
                          return null;
                        },
                      ),
                      height20(),
                      cnt.businessInfoModel.value.basicdetailsstatusId == 3
                          ? Text(
                              "Alert : ".tr + cnt.businessInfoModel.value.basicdetailsstatuscommet.toString(),
                              style: TextStyle(
                                color: ColorsUtils.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                            )
                          : SizedBox(),
                      hideActionBtn
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        String userBusinessId = await encryptedSharedPreferences.getString('userbusinessId');
                                        if (_formKey.currentState!.validate()) {
                                          Map<String, dynamic> Body = {};
                                            Body.addEntries({"businessname": businessName.text}.entries);
                                            Body.addEntries({"merchantregisterationnumber": businessRegistrationNumber.text}.entries);
                                            Body.addEntries({"buildingnumber": bldgNo.text}.entries);
                                            Body.addEntries({"streetnumber": streetNo.text}.entries);
                                            Body.addEntries({"zonenumber": zone.text}.entries);
                                            Body.addEntries({"changedemail": emailId.text}.entries);
                                            Body.addEntries({"newCellnumber": mobileNumber.text}.entries);
                                            Body.addEntries({"unitnumber": unitNo.text}.entries);

                                          if (!Body.isEmpty) {
                                            //createMerchantOTP(Body);
                                            Get.to( () => SetPassSubMarchant(body: Body,));
                                          }
                                        } else {
                                          Get.snackbar('error'.tr, 'Please provide valid details'.tr);
                                        }
                                      },
                                      child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Add Marchant'.tr),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      // InkWell(
                      //   onTap: () {
                      //     //_formKey.currentState!.validate();
                      //     if(businessName.text == "" && businessRegistrationNumber.text == "" && zone.text == "" && streetNo.text == "" && bldgNo.text == "" && unitNo.text == "" && mobileNumber.text == widget.bussinessDetails!.businessInfoModel.value.user?.cellnumber && emailId.text == widget.bussinessDetails!.businessInfoModel.value.user?.email)
                      //       {
                      //         Get.back();
                      //       } else {
                      //       showDialog<String>(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return AlertDialog(
                      //               title: Text('Are you sure?'.tr),
                      //               content: Text("The changes won't be saved".tr),
                      //               actions: <Widget>[
                      //                 TextButton(
                      //                     child: Text('Yes'.tr),
                      //                     onPressed: () async {
                      //                       Get.close(2);
                      //                     }),
                      //                 TextButton(
                      //                     child: Text('No'.tr),
                      //                     onPressed: () async {
                      //                       Get.close(1);
                      //                     }),
                      //               ],
                      //             );
                      //           });
                      //     }
                      //     setState(() {});
                      //   },
                      //   child: Text(
                      //     "No, Thanks".tr,
                      //     style: TextStyle(
                      //       color: Colors.grey,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                height20(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  createMerchantOTP(Map<String, dynamic> body,) async {
    try {
      dio.Dio _dio = dio.Dio();
      String token = await encryptedSharedPreferences.getString('token');
      var response = await _dio.get(Utility.baseUrl + "usermetaauths/resendOtp?type=createsubmerchantotp",
          options: dio.Options(
            headers: {"Authorization": token},
          ));

      log("response:::${response.data}");
      if (response.statusCode == 200) {
        if (response.data["result"] == true) {
          Get.back();
          Get.snackbar(
              'success'.tr, 'OTP Send SuccessFully'.tr);
          Get.to(() => ManageMerchantOTP(body: body,isCreateSubMerchant: true,));
          setState(() {});
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print(e.message);
        Get.snackbar('error', '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }


  Dio dioForMobile = Dio();
  String? mobileError;

  Future<void> checkMobileNumber() async {
    dioForMobile.close();
    dioForMobile = Dio();
    String token = await encryptedSharedPreferences.getString('token');
    final url = 'users/count?where[cellnumber]=${mobileNumber.text}&amp;where[agreement]=true';

    var response = await dioForMobile.get(Utility.baseUrl + url,
        options: Options(
          headers: {"Authorization": token, 'Content-Type': 'application/json'},
        ));
    if (response.data['count'] != 0) {
      setState(() {
        mobileError = "Mobile number already exist".tr;
      });
    } else {
      setState(() {
        mobileError = null;
      });
    }
    log("response mobile::${response.data}");
  }

  Dio dioForEmail = Dio();
  String? emailError;
  Future<void> checkEmail() async {
    dioForEmail.close();
    dioForEmail = Dio();
    String token = await encryptedSharedPreferences.getString('token');
    final url = 'users/count?where[email]=${emailId.text}&amp;where[agreement]=true';

    var response = await dioForEmail.get(Utility.baseUrl + url,
        options: Options(
          headers: {"Authorization": token, 'Content-Type': 'application/json'},
        ));
    if (response.data['count'] != 0) {
      setState(() {
        emailError = "Email address already exist".tr;
      });
    } else {
      setState(() {
        emailError = null;
      });
    }
    log("response of mail::${response.data}");
  }

  Dio dioForCR = Dio();
  String? crError;
  Future<void> checkCRNumber() async {
    dioForCR.close();
    dioForCR = Dio();
    String token = await encryptedSharedPreferences.getString('token');
    final url = 'userbusinesses/checkCrNumber?merchantregisterationnumber=${businessRegistrationNumber.text}';

    var response = await dioForCR.get(Utility.baseUrl + url,
        options: Options(
          headers: {"Authorization": token, 'Content-Type': 'application/json'},
        ));
    if (response.data['result'] == true) {
      setState(() {
        crError = "Commercial registration number already exist".tr;
      });
    } else {
      setState(() {
        crError = null;
      });
    }
    log("response of mail::${response.data}");
  }
  getCountryList() async {
    String token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse(
        '${Utility.baseUrl}settings?filter[where][key][inq][0]=allowed_countries&filter[where][key][inq][1]=geofencing&filter[where][key][inq][2]=proxy_checker&filter[fields][0]=key&filter[fields][1]=value');
    Map<String, String> header = {'Authorization': token};
    var result = await http.get(url, headers: header);
    log("response ::: ${result.body}");
    if(result.statusCode == 200){
      List tempData = jsonDecode(result.body);
      tempData.forEach((element) { countryList.add(CountryData.fromJson(element));});
      if(!countryList.isEmpty){
        getLoction();
      }
      log("key ::: ${countryList[0].key}");
      log("value ::: ${countryList[0].value}");
    }
  }
  getLoction() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location', 'Please allow location permission for registration process.');
        Get.back();
      }
      if (permission == LocationPermission.deniedForever) {
        //Get.snackbar('Location', 'Please allow location permission for registration process.');
        showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Location'.tr),
                content: Text('Please allow location permission for registration process.'.tr),
                actions: <Widget>[
                  TextButton(
                      child: Text('Open Setting'.tr),
                      onPressed: () async {
                        Get.close(2);
                        openAppSettings();
                      }),
                  TextButton(
                      child: Text('Close'.tr),
                      onPressed: () async {
                        Get.close(2);
                      }),
                ],
              );
            });
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    if (await Geolocator.isLocationServiceEnabled()) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      debugPrint('location: ${position.latitude}');
      await encryptedSharedPreferences.setString('currentLat', position.latitude.toString());
      await encryptedSharedPreferences.setString('currentLong', position.longitude.toString());
      List<Placemark> newPlace = await placemarkFromCoordinates(position.latitude, position.longitude);

      // this is all you need
      Placemark placeMark = newPlace[0];
      String? name = placeMark.name;
      String? subLocality = placeMark.subLocality;
      String? locality = placeMark.locality;
      String? administrativeArea = placeMark.administrativeArea;
      String? postalCode = placeMark.postalCode;
      String? country = placeMark.country;
      String? address = "${name}, ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";

      print(address);
      if (countryList[0].value!.contains(placeMark.isoCountryCode??"12345")) {
        isInQutar = true;
      } else {
        isInQutar = false;
        Get.back();
        showModalBottomSheet<void>(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
                      height25(),
                      Image.asset(Images.geo_fencing,height: 45,width: 45,),
                      height20(),
                      customSmallMedBoldText(
                          color: ColorsUtils.accent,
                          title:"Sorry, we couldn't find you in Qatar. The registration couldn't be completed.".tr),
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
                              child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Okay'),
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
      setState(() {});
    } else {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('On Location Service'.tr),
              content: Text('Please on location service for registration'.tr),
              actions: <Widget>[
                TextButton(
                    child: Text('Okay'.tr),
                    onPressed: () async {
                      Get.close(2);
                    }),
              ],
            );
          });
    }
  }
}
