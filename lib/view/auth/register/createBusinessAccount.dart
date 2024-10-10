import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/Auth%20/countryListModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:sadad_merchat_app/view/auth/register/enterYourPhoneNumberScreen.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';

class CreateBusinessAccount extends StatefulWidget {
  const CreateBusinessAccount({Key? key}) : super(key: key);

  @override
  State<CreateBusinessAccount> createState() => _CreateBusinessAccountState();
}

class _CreateBusinessAccountState extends State<CreateBusinessAccount> {
  GlobalKey<FormState> _formKey = GlobalKey();
  ConnectivityViewModel connectivityViewModel = Get.find();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController partnerId = TextEditingController();
  bool isInQutar = true;

  List<CountryData> countryList = [];

  // bool isTermsCondition = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountryList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomButton(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: isInQutar
                ? Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height40(),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 30,
                          ),
                        ),
                        height30(),
                        customMediumBoldText(title: 'Create new business account'.tr),
                        height5(),
                        customSmallMedSemiText(title: 'Fill the below inputs'.tr),
                        height20(),
                        commonTextField(
                            contollerr: name,
                            keyType: TextInputType.name,
                            onChange: (str) {
                              print(str.length);
                            },
                            validator: (str) {
                              if (str!.isEmpty) {
                                return 'Name should not be empty'.tr;
                              }
                              if (str.length >= 512) {
                                return 'max characters allowed are 512'.tr;
                              }
                              return null;
                            },
                            regularExpression: TextValidation.alphabetValidationPattern,
                            hint: 'Business name*'.tr),
                        height20(),

                        commonTextField(
                          contollerr: email,
                          hint: 'Email*'.tr,
                          keyType: TextInputType.emailAddress,
                          regularExpression: TextValidation.emailAddressValidationPattern,
                          // validationType:
                          //     TextValidation.emailAddressValidationPattern,
                          onChange: (str) {
                            _formKey.currentState!.validate();
                          },
                          validator: (str) {
                            String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                            // r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            // r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            // r"{0,253}[a-zA-Z0-9])?)*$";
                            RegExp regex = RegExp(pattern);
                            if (str == null || str.isEmpty || !regex.hasMatch(str))
                              return 'Enter a valid email address'.tr;
                            else
                              return null;
                          },
                        ),
                        height20(),
                        commonTextField(
                          contollerr: partnerId,
                          hint: 'Partner Id'.tr,
                          keyType: TextInputType.number,
                          regularExpression: TextValidation.digitsValidationPattern,
                          // validationType:
                          //     TextValidation.emailAddressValidationPattern,
                          onChange: (str) {
                            _formKey.currentState!.validate();
                          },
                          validator: (str) {
                            return null;
                          },
                        ),

                        height30(),
                        // Row(
                        //   children: [
                        //     InkWell(
                        //       onTap: () {
                        //         setState(() {
                        //           isTermsCondition = !isTermsCondition;
                        //         });
                        //       },
                        //       child: Container(
                        //         width: 20,
                        //         height: 20,
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(5),
                        //             border: Border.all(color: ColorsUtils.black)),
                        //         child: isTermsCondition
                        //             ? Center(
                        //                 child: Image.asset(
                        //                   Images.check,
                        //                   width: 10,
                        //                 ),
                        //               )
                        //             : SizedBox(),
                        //       ),
                        //     ),
                        //     width20(),
                        //     customSmallSemiText(title: 'I agree to the Sadad '),
                        //     // width5(),
                        //     Text('Terms and conditions',
                        //         style: ThemeUtils.blackBold.copyWith(
                        //             decoration: TextDecoration.underline,
                        //             fontSize: FontUtils.small,
                        //             color: ColorsUtils.accent)),
                        //   ],
                        // )
                      ],
                    ),
                  )
                : SizedBox(),
          ),
        ));
  }

  Column bottomButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: InkWell(
            onTap: () async {
              connectivityViewModel.startMonitoring();

              if (connectivityViewModel.isOnline != null) {
                if (connectivityViewModel.isOnline!) {
                  print('hi');
                  String token = await encryptedSharedPreferences.getString('token');
                  if (_formKey.currentState!.validate()) {
                    print('hi');

                    // if (isTermsCondition == false) {
                    //   Get.snackbar('error', 'Please read Terms and conditions');
                    // }
                    //
                    // else {

                    final url = Uri.parse('${Utility.baseUrl}users/count?where[email]=${email.text}&where[agreement]=true');
                    Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
                    var result = await http.get(
                      url,
                      headers: header,
                    );
                    if (result.statusCode == 200) {
                      if (jsonDecode(result.body)['count'] >= 1) {
                        Get.snackbar('error', 'email Id already exits');
                      } else {
                        Get.to(() => EnterYourPhoneScreen(
                              name: name.text,
                              email: email.text,
                              partnerId: partnerId.text,
                            ));
                      }
                      print(' req is  :${result.body} ');
                    }
                    // }
                  }
                } else {
                  Get.snackbar('error', 'please check internet connectivity');
                }
              } else {
                Get.snackbar('error', 'please check internet connectivity');
              }
            },
            child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'Next'.tr),
          ),
        )
      ],
    );
  }

  getLoction() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        Get.snackbar('Location'.tr, 'Please allow location permission for registration process.'.tr);
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
        // showDialog<String>(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text(''),
        //         content: Text("Sorry, we couldn't find you in Qatar. The registration couldn't be completed.".tr),
        //         actions: <Widget>[
        //           TextButton(
        //               child: Text('Okay'.tr),
        //               onPressed: () async {
        //                 Get.close(2);
        //               }),
        //         ],
        //       );
        //     });
      }

      setState(() {});
      // final coordinates = new Coordinates(position.latitude, position.longitude);
      // var addresses =
      // await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first;
      // print(first.countryName);
      // return first.countryName;
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
