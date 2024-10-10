import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:lottie/lottie.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/moreController.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/model/services/base_service.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/analytics_service.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/businessDetailsInsertScreen.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/businessDetailsScreen.dart';
import 'package:sadad_merchat_app/view/more/myQrCode/myQrCode.dart';
import 'package:sadad_merchat_app/view/more/personalInfo/personalInfoScreen.dart';
import 'package:sadad_merchat_app/view/more/setting/settingScreen.dart';
import 'package:sadad_merchat_app/view/more/signedContract/signedContract.dart';
import 'package:sadad_merchat_app/view/more/signedContract/signedContractList.dart';
import 'package:sadad_merchat_app/view/splash.dart';
import 'package:sadad_merchat_app/viewModel/Auth/connectivity_viewmodel.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/widget/moreScreenWidget.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/addBankAccount.dart';
import 'package:sadad_merchat_app/widget/svgIcon.dart';
import 'package:http/http.dart' as http;
import 'bankAccount/bankAccount.dart';
import 'package:dio/dio.dart' as dio;
import 'package:sadad_merchat_app/model/services/base_service.dart';

import 'manageMarchant/manageMarchant.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with BaseService {
  final cnt = Get.put(MoreController());
  final businessDetailCnt = Get.find<BusinessInfoViewModel>();
  ConnectivityViewModel connectivityViewModel = Get.find();
  String userName = '';
  String sadadId = '';
  bool ShowManageMarchant = false;
  @override
  void initState() {
    connectivityViewModel.startMonitoring();
    AnalyticsService.sendAppCurrentScreen('More Screen');

    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    businessDetailCnt.businessInfoModel.value = BusinessInfoResponseModel(userbusinessstatusId: null, user: User(name: ""));
    print("dispose called");
    super.dispose();
  }

  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      cnt.getToken();

      userName = await encryptedSharedPreferences.getString('name');
      print('user Name$userName');
      sadadId = await encryptedSharedPreferences.getString('sadadId');

      await businessDetailCnt.getBusinessInfo(context);
      // log("${businessDetailCnt.bankAccountList.length}",
      await businessDetailCnt.getBankData(context);
      print(".../..../..../..../${businessDetailCnt.businessInfoModel.value.streetnumber}");
      Utility.userPhone = businessDetailCnt.businessInfoModel.value.user?.cellnumber ?? "";
      Utility.userbusinessstatus = businessDetailCnt.businessInfoModel.value.userbusinessstatusId ?? 0;
      getManageMarchantSetting();
      setState(() {});
    });
  }
  Future<void> getManageMarchantSetting() async {
    String token = await encryptedSharedPreferences.getString('token');
    String id = await encryptedSharedPreferences.getString('id');

    final url = Uri.parse(baseURL +
        "usermetapreferences?filter[where][userId]=$id&filter[fields][0]=isallowedtoaddsubmerchant&filter[fields][1]=isAllowToDelete");
    Map<String, String> header = {
      'Authorization': token,
      'Content-Type': 'application/json'
    };
    print(url);
    var result = await http.get(url, headers: header);
    print('header$header');
    print(result.body);
    print(result.statusCode);
    if (result.statusCode < 299 || result.statusCode == 200) {
      print('ok done');
      List data = json.decode(result.body);
      ShowManageMarchant = data[0]["isallowedtoaddsubmerchant"] ?? false;
      await encryptedSharedPreferences.setString('isAllowToDelete', data[0]["isAllowToDelete"] == true ? 'true' : 'false');
      print("data is :- ${data[0]["isallowedtoaddsubmerchant"]}");

      setState(() {
      });
      // notificationModel.value.isPlayaSound =
      //     notificationResponseModel.isplayasound;
    } else if (result.statusCode == 401) {
      //Get.back(result: true);
      funcSessionExpire();
    } else {
      Get.snackbar('error', '${jsonDecode(result.body)['error']['message']}');
    }
  }
  Future<void> onPull() async {
    await businessDetailCnt.getBusinessInfo(context);
    // log("${businessDetailCnt.bankAccountList.length}",
    await businessDetailCnt.getBankData(context);
    print(".../..../..../..../${businessDetailCnt.businessInfoModel.value.streetnumber}");
    Utility.userPhone = businessDetailCnt.businessInfoModel.value.user?.cellnumber ?? "";
    Utility.userbusinessstatus = businessDetailCnt.businessInfoModel.value.userbusinessstatusId ?? 0;
    getManageMarchantSetting();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (connectivityViewModel.isOnline != null) {
      if (connectivityViewModel.isOnline!) {
        return Scaffold(
          backgroundColor: ColorsUtils.createInvoiceContainer,
          body: Obx(
            () => businessDetailCnt.isLoading.value
                ? Center(
                    child: Lottie.asset(Images.slogo, width: 60, height: 60),
                  )
                : SafeArea(
                    child: RefreshIndicator(
                      onRefresh: onPull,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 96,
                                width: 96,
                                margin: const EdgeInsets.only(top: 60, bottom: 16),
                                decoration: BoxDecoration(
                                  color: ColorsUtils.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: ColorsUtils.line,
                                  ),
                                ),
                                child: Obx(
                                  () => cnt.isLoading.value
                                      ? Center(child: Lottie.asset(Images.slogo, width: 60, height: 60))
                                      : ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Container(
                                            child: Stack(
                                              children: [
                                            businessDetailCnt.businessInfoModel.value.logo == null
                                              ? Image.network(
                                                  "https://sadad.qa/wp-content/uploads/2022/02/Color-Logo.png",
                                                  fit: BoxFit.scaleDown,
                                                  height: 96,
                                                  width: 96,
                                                ) :
                                                Image.network("${Utility.baseUrl}containers/api-businesslogo/download/${businessDetailCnt.businessInfoModel.value.logo.toString()}?access_token=${cnt.token.toString()}",
                                                  fit: BoxFit.cover,
                                                  height: 96,
                                                  width: 96,
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      uploadImage();
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      padding: EdgeInsets.all(4),
                                                      decoration: BoxDecoration(color: ColorsUtils.white, shape: BoxShape.circle),
                                                      child: Icon(Icons.edit, color: ColorsUtils.accent, size: 20),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      businessDetailCnt.businessInfoModel.value.user == null
                                          ? userName
                                          : businessDetailCnt.businessInfoModel.value.user!.name!,
                                      style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medLarge)),
                                  width16(),
                                  SvgIcon(getAccountStatus(
                                      "${businessDetailCnt.businessInfoModel.value.userbusinessstatus?.id.toString() ?? ""}")),
                                ],
                              ),
                              height16(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${'Sadad ID'.tr} ${businessDetailCnt.businessInfoModel.value.user?.sadadId ?? sadadId}",
                                      style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small)),
                                  width16(),
                                  InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: businessDetailCnt.businessInfoModel.value.user == null
                                                ? sadadId
                                                : businessDetailCnt.businessInfoModel.value.user!.sadadId));
                                        Get.snackbar("Success".tr, 'Copied to clipboard'.tr);
                                      },
                                      child: SvgPicture.asset(Images.copy)),
                                ],
                              ),
                              height24(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${businessDetailCnt.posVal.value}",
                                        style:
                                            ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium, color: ColorsUtils.primary),
                                      ),
                                      height5(),
                                      Text("POS Devices".tr,
                                          style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall)),
                                    ],
                                  ),
                                  Container(
                                    height: 40,
                                    width: 1,
                                    margin: const EdgeInsets.symmetric(horizontal: 47),
                                    color: ColorsUtils.grey,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "${businessDetailCnt.activeVal.value}",
                                        style:
                                            ThemeUtils.blackBold.copyWith(fontSize: FontUtils.medium, color: ColorsUtils.primary),
                                      ),
                                      height5(),
                                      Text("Active Users".tr,
                                          style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.verySmall)),
                                    ],
                                  ),
                                ],
                              ),
                              height20(),
                              Container(
                                color: ColorsUtils.white,
                                child: Column(
                                  children: [
                                    moreScreenCommonRow(
                                        onTap: () => Get.to(() => MyQrCode(),
                                            arguments:
                                                "${businessDetailCnt.businessInfoModel.value.user == null ? "" : businessDetailCnt.businessInfoModel.value.user!.sadadId}"),
                                        image: Images.qr_code,
                                        title: "My QRcode".tr,
                                        notification: 0,
                                        blueColor: true),
                                    Divider(
                                      color: ColorsUtils.line,
                                      thickness: 1,
                                    ),
                                    moreScreenCommonRow(
                                        onTap: () {
                                          print(businessDetailCnt.businessInfoModel.value.merchantregisterationnumber);
                                          Get.to(() => BusinessDetailInsert(
                                                  isFirstTime: businessDetailCnt.businessInfoModel.value.merchantregisterationnumber == null))
                                              ?.then((value) => {
                                                    if (value == false) {onPull()}
                                                  });
                                        },
                                        image: Images.businessInfo,
                                        title: "Business informations".tr,
                                        notification: 0),
                                    moreScreenCommonRow(
                                        onTap: () => Get.to(
                                              () => BankAccount(),
                                            ),
                                        image: Images.bank_account,
                                        title: "Bank Account".tr,
                                        notification: 0),
                                    moreScreenCommonRow(
                                        onTap: () async {
                                          Get.to(() => SignedContractList());
                                        },
                                        image: Images.signed_contract,
                                        title: "Signed contract".tr,
                                        notification: 0),
                                    moreScreenCommonRow(
                                        onTap: () => Get.to(() => PersonalInfoScreen(
                                              model: businessDetailCnt.businessDataModel.value,
                                            )),
                                        image: Images.personal_info,
                                        title: "Personal Information".tr,
                                        notification: 0),
                                    ShowManageMarchant ? moreScreenCommonRow(
                                        onTap: () => Get.to(() => ManageMarchant(bussinessDetails: businessDetailCnt,fromMoreScreen: true)),
                                        image: Images.manage_Merchant,
                                        title: "Manage Merchants".tr,
                                        notification: 0) : SizedBox(),
                                    moreScreenCommonRow(
                                        onTap: () => Get.to(() => SettingScreen()),
                                        image: Images.setting,
                                        title: "Settings".tr,
                                        notification: 0),
                                    height20(),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  color: ColorsUtils.white,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(20),
                                                    topRight: Radius.circular(20),
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    height48(),
                                                    Text(
                                                      'Are you sure you want to Logout ?'.tr,
                                                      style: ThemeUtils.blackBold.copyWith(fontSize: FontUtils.mediumSmall),
                                                    ),
                                                    height32(),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () => Get.back(),
                                                          child: Container(
                                                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 34),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  color: ColorsUtils.primary),
                                                              child: Text(
                                                                'No'.tr,
                                                                style: ThemeUtils.blackRegular.copyWith(
                                                                    color: ColorsUtils.white, fontSize: FontUtils.small),
                                                              )),
                                                        ),
                                                        width20(),
                                                        InkWell(
                                                          onTap: () async {
                                                            Get.offAll(
                                                              () => SplashScreen(),
                                                            );
                                                            print(
                                                                'name----${await encryptedSharedPreferences.getString('name')}');
                                                          },
                                                          child: Container(
                                                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 34),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                  border: Border.all(color: ColorsUtils.primary)),
                                                              child: Text(
                                                                'Yes'.tr,
                                                                style: ThemeUtils.blackRegular.copyWith(
                                                                    color: ColorsUtils.primary, fontSize: FontUtils.small),
                                                              )),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              margin: EdgeInsets.symmetric(horizontal: 16),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: ColorsUtils.red.withOpacity(0.1)),
                                              padding: EdgeInsets.all(8),
                                              child: SvgPicture.asset(Images.logout),
                                            ),
                                            Text(
                                              'Logout'.tr,
                                              style: ThemeUtils.blackRegular
                                                  .copyWith(fontSize: FontUtils.small, color: ColorsUtils.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    height20(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        );
      } else {
        return InternetNotFound(
          onTap: () async {
            connectivityViewModel.startMonitoring();

            if (connectivityViewModel.isOnline != null) {
              if (connectivityViewModel.isOnline!) {
                setState(() {});
                init();
              } else {
                Get.snackbar('error', 'Please check your connection');
              }
            } else {
              Get.snackbar('error', 'Please check your connection');
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
              init();
            } else {
              Get.snackbar('error', 'Please check your connection');
            }
          } else {
            Get.snackbar('error', 'Please check your connection');
          }
        },
      );
    }
  }

  uploadImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png'], allowMultiple: false);

    if (result != null) {
      try {
        showLoadingDialog(context: context);

        File? file = File(result.files.first.path!);

        List fileLIst = file.path.split("/").last.split(".");

        String fileName = fileLIst[0];
        if (fileLIst.length > 2) {
          for (int i = 1; i < fileLIst.length - 1; i++) {
            fileName = fileName + "_${fileLIst[i]}";
          }
        }
        Random random = Random();
        var randumNumber = random.nextInt(100);
        fileName = fileName + "${randumNumber}.${fileLIst.last.toString().toLowerCase()}";
        Directory cachePath = await getTemporaryDirectory();
        File newImage = await File(file.path).rename("${cachePath.path}/$fileName");
        file = newImage;

        dio.Dio _dio = dio.Dio();
        String? mimeType = mime(result.files.first.path!);
        String mimee = mimeType!.split('/')[0];
        String type = mimeType.split('/')[1];

        String token = await encryptedSharedPreferences.getString('token');
        dio.FormData formData = dio.FormData();

        formData = dio.FormData.fromMap({
          "name": await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType(mimee, type),
          ),
        });

        var response = await _dio.post(baseURL + "containers/api-businesslogo/upload",
            data: formData, options: dio.Options(headers: {"Authorization": token}));

        print("Response ::: ${response.data} :::: ${response.statusCode}");
        if (response.statusCode == 200) {
          String imageName = response.data["result"]["files"]["name"][0]["name"];
          storeImageName(imageName);
          Get.back();
        } else {
          Get.back();
        }
      } on Exception catch (e) {
        Get.back();
      }
    }
  }
  storeImageName(String imageName) async {
    String token = await encryptedSharedPreferences.getString('token');
    String userBusinessId =
    await encryptedSharedPreferences.getString('userbusinessId');
    final url = Uri.parse(
        '${Utility.baseUrl}userbusinesses/${userBusinessId}');
    Map<String, String> header = {'Authorization': token,'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "logo": imageName,
      "merchantregisterationnumber": businessDetailCnt.businessInfoModel.value.merchantregisterationnumber,
      "modifiedby": int.parse(Utility.userId),
      "modified": DateTime.now().microsecondsSinceEpoch,
    };
    print('request body :- $body');

    var result = await http.patch(url, headers: header, body: jsonEncode(body),);
    if(result.statusCode == 200){
      var tempData = jsonDecode(result.body);
      await onPull();
    }
  }
// @override
// void dispose() {
//   // TODO: implement dispose
//   super.dispose();
//   businessDetailCnt.dispose();
// }
}
