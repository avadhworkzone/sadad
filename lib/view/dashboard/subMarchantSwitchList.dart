import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'dart:developer';

import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/subMerchantListModel.dart';
import 'package:dio/dio.dart' as dio;
import 'package:sadad_merchat_app/model/services/base_service.dart';

import '../../controller/home_Controller.dart';
import '../../staticData/common_widgets.dart';
import '../../staticData/loading_dialog.dart';
import '../../staticData/utility.dart';
import '../../util/analytics_service.dart';
import '../home.dart';
import 'package:http/http.dart' as http;

class subMarchantSwitchList extends StatefulWidget {
  const subMarchantSwitchList({super.key});

  @override
  State<subMarchantSwitchList> createState() => _subMarchantSwitchListState();
}

class _subMarchantSwitchListState extends State<subMarchantSwitchList> with BaseService {
  String? sadadId = "";
  String? userName = "";
  String token = "";
  List<SubMerchantModel> subMerchantList = [];
  HomeController homeController = Get.find();

  @override
  void initState() {
    //showLoadingDialog(context: context);
    getSadadId();
    getSubMarchantList();
    super.initState();
  }

  getSadadId() async {
    sadadId = await encryptedSharedPreferences.getString('sadadId');
    userName = await encryptedSharedPreferences.getString('name');
    token = await encryptedSharedPreferences.getString('token');
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            Images.sadadLogo,
            height: 80,
            width: 80,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Center(
              child: Text(
                "Close".tr,
                style: TextStyle(color: ColorsUtils.hintColor, fontSize: FontUtils.verySmall),
              ),
            ),
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 2, right: 2),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.white, Color(0xFFF5F5F5)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                          color: Colors.white,
                          border: Border(),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                          boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey, offset: Offset(0, 2))]),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Default".tr,
                                    style: TextStyle(fontSize: FontUtils.verySmall, color: ColorsUtils.accent, fontWeight: FontWeight.w600),
                                  ),
                                  Text(userName.toString(), style: TextStyle(fontSize: FontUtils.large, color: ColorsUtils.hintColor, fontWeight: FontWeight.w600)),
                                  Text("${'Sadad ID'.tr} : ${sadadId}", style: TextStyle(fontSize: FontUtils.small, color: ColorsUtils.hintColor))
                                ],
                              ),
                              Image.asset(
                                Images.star_red_fill,
                                height: 25,
                                width: 25,
                              )
                            ],
                          ),
                          const Divider(thickness: 1, height: 30),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: subMerchantList.length,
                            itemBuilder: (context, index) {
                              return subMerchantList[index].linkmerchantverificationstatusId != 2 ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child:  InkWell(
                                  onTap: () {
                                    switchToSubMarchantAccount(subMerchantList[index].sadadId);
                                    //Get.snackbar("Success".tr, 'Added to Favourite.'.tr);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFDADCE0)),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: const [BoxShadow(blurRadius: 6, color: Color(0xFFDADCE0), spreadRadius: 1.5, offset: Offset(0, 3))]),
                                    child: Row(children: [
                                      Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 20,child: subMerchantList[index].profilepic == null ? Image.network(
                                            "https://sadad.qa/wp-content/uploads/2022/02/Color-Logo.png",
                                            fit: BoxFit.scaleDown,
                                            height: 40,
                                            width: 40,
                                          ) : Image.network(
                                            "${Utility.baseUrl}containers/api-businesslogo/download/${subMerchantList[index].profilepic.toString()}?access_token=${token}",
                                            fit: BoxFit.scaleDown,
                                            height: 40,
                                            width: 40,
                                          ),),
                                          subMerchantList[index].userbusinesses!.length > 0
                                              ? subMerchantList[index].userbusinesses![0].userbusinessstatusId == 3
                                                  ? Container(
                                                      height: 18,
                                                      width: 18,
                                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red, border: Border.all(width: 2, color: Colors.white)),
                                                    )
                                                  : SizedBox()
                                              : SizedBox(),
                                          subMerchantList[index].parentmerchantId == null && subMerchantList[index].linkmerchantverificationstatusId != 2
                                              ? Container(
                                                  height: 18,
                                                  width: 18,
                                                  child: Icon(Icons.star_rate_rounded, size: 11, color: Colors.white),
                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: ColorsUtils.accent, border: Border.all(width: 2, color: Colors.white)),
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("${subMerchantList[index].name}", style: TextStyle(fontSize: FontUtils.smaller, fontWeight: FontWeight.w500, color: Colors.black)),
                                            const SizedBox(height: 3),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Sadad Id".tr + " : ${subMerchantList[index].sadadId}", style: TextStyle(fontSize: FontUtils.verySmall, color: Colors.black.withOpacity(0.5))),
                                                width16(),
                                                subMerchantList[index].parentmerchantId == null && subMerchantList[index].linkmerchantverificationstatusId != 2
                                                    ? Text("Primary".tr, style: TextStyle(fontSize: FontUtils.verySmall, color: ColorsUtils.accent))
                                                    : SizedBox(),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      InkWell(
                                        onTap: () {
                                          setSubMarchantFavourite(subMerchantList[index].sadadId);
                                        },
                                        child: subMerchantList[index].submerchantDefault == false ? Image.asset(
                                          Images.star_black_notfill,
                                          height: 25,
                                          width: 25,
                                        ) : Image.asset(
                                          Images.star_red_fill,
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      // Expanded(
                                      //   flex: 1,
                                      //   child: InkWell(
                                      //     onTap: () {
                                      //       switchToSubMarchantAccount(subMerchantList[index].sadadId);
                                      //       //Get.snackbar("Success".tr, 'Added to Favourite.'.tr);
                                      //     },
                                      //     child: Icon(
                                      //       Icons.arrow_forward_ios_rounded,
                                      //       size: 15,
                                      //       color: Colors.grey,
                                      //     ),
                                      //   ),
                                      // )
                                    ]),
                                  ),
                                ),
                              ) : SizedBox();
                            },
                          ),
                          const SizedBox(height: 10)
                        ]),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)]),
                        height: 40,
                        width: 40,
                        child: const Icon(Icons.keyboard_arrow_up_outlined, color: Colors.red, size: 25),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  getSubMarchantList() async {
    showLoadingDialog(context: context);
    dio.Dio _dio = dio.Dio();
    String token = await encryptedSharedPreferences.getString('token');
    var response = await _dio.get(baseURL + "users/submerchantList",
        options: dio.Options(
          headers: {"Authorization": token},
        ));

    log("response:::${response.data}");
    if (response.statusCode == 200) {
      subMerchantList.clear();
      response.data.forEach((element) {
        subMerchantList.add(SubMerchantModel.fromJson(element));
      });
      subMerchantList.forEach((element) {
        if(element.submerchantDefault == true){
          userName = element.name;
          sadadId = element.sadadId;
        }
      });
      setState(() {});
      log("subMerchantList:::${subMerchantList}");
    }
    Navigator.pop(context);
  }

  setSubMarchantFavourite(
    String? SadadId,
  ) async {
    try {
      dio.Dio _dio = dio.Dio();
      String token = await encryptedSharedPreferences.getString('token');
      var params = {
        "SadadId": SadadId,
        "submerchantDefault": 1,
      };
      var response = await _dio.post(
        baseURL + "users/markSubmerchantDefault",
        options: dio.Options(
          headers: {"Authorization": token},
        ),
        data: jsonEncode(params),
      );

      log("response:::${response.data}");
      if (response.statusCode == 200) {
        print(response.data);
        getSubMarchantList();
        setState(() {});
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        funcSessionExpire();
        print(e.response?.statusCode);
      } else {
        print(e.message);
        Get.snackbar('error'.tr, '${jsonDecode(e.response?.data)['error']['message']}');
      }
    }
  }

  switchToSubMarchantAccount(String? SadadId,) async {
    dio.Dio _dio = dio.Dio();
    String token = await encryptedSharedPreferences.getString('token');
    // var params = {
    //   "SadadId": SadadId,
    // };
    // var response = await _dio.post(
    //   baseURL + "users/switchChildMerchant",
    //   options: dio.Options(
    //     headers: {"Authorization": token},
    //   ),
    //   data: jsonEncode(params),
    // );
    // log("response:::${response.data}");

    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    var body = {
      "SadadId": SadadId,
    };
    print("body =======>>>  ${jsonEncode(body)}");
    final url = Uri.parse(baseURL + "users/switchChildMerchant");
    var result =
    await http.post(url, headers: header, body: json.encode(body));

    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      var data = json.decode(result.body);
      print(data);
      var token = data["id"].toString();
      await encryptedSharedPreferences.setString('token', token);
      print(data);
      await encryptedSharedPreferences.setString('name', data["userInfo"]["name"].toString());
      Utility.name = data["userInfo"]["name"];
      Utility.profilePic = data["userInfo"]["profilepic"] ?? "";
      Utility.userId = data["userInfo"]["id"].toString();
      //Utility.userbusinessstatus = response.data["userInfo"][""].userbusinessstatusId ?? 0;
      await encryptedSharedPreferences.setString('email', data["userInfo"]["email"]);
      await encryptedSharedPreferences.setString('sadadId', data["userInfo"]["SadadId"]);
      await encryptedSharedPreferences.setString('mobileNo.', data["userInfo"]["cellnumber"]);
      await encryptedSharedPreferences.setString('id', Utility.userId);
      showLoadingDialog(context: context);
      AnalyticsService.sendLoginEvent('${Utility.userId}');
      await encryptedSharedPreferences.setString('fromReg', 'false');
      Future.delayed(Duration(seconds: 1), () {
        hideLoadingDialog(context: context);
        Utility.countryCodeNumber = '+974';
        Utility.countryCode = 'QA';
        Utility.mobNo = '';
        homeController.initBottomIndex = 0;
        Get.offAll(() => HomeScreen());
        //getSubMarchantList();
        setState(() {});
      });
    }else if (result.statusCode == 401) {
      funcSessionExpire();
    } else {
      Get.snackbar('error'.tr, '${jsonDecode(result.body)['error']['message']}');
    }
  }
}
