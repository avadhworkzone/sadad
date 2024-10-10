import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/bankAccountResponseModel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/bankAccount/bankAccount.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:http/http.dart' as http;

import '../../../model/apimodels/responseModel/uploadImageResponseModel.dart';
import '../../../model/repo/more/bank/bankAccountRepo.dart';
import '../../../util/validations.dart';

class BankAccountDetail extends StatefulWidget {
  final bool isEdit;
  final String? iban;
  final String? accountname;

  const BankAccountDetail({Key? key, this.isEdit = false, this.iban, this.accountname}) : super(key: key);

  @override
  _BankAccountDetailState createState() => _BankAccountDetailState();
}

class _BankAccountDetailState extends State<BankAccountDetail> {
  BankAccountResponseModel bankAccountResponseModel = BankAccountResponseModel();
  var bankAccountViewModel = Get.find<BankAccountViewModel>();

  // var bankAccountViewModel = Get.find<BankAccountViewModel>();
  var businessInfoViewModel = Get.find<BusinessInfoViewModel>();
  String? token;
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final cnt = Get.find<BankAccountViewModel>();
  String? imageName = "";
  bool ibanApiCalling = false;
  String bankLogo = "";
  String bankName = "";

  Future getImageFile() async {
    File? result;
    if (Platform.isIOS) {
      ImagePicker picker = ImagePicker();
      XFile? photo = await picker.pickImage(source: ImageSource.gallery);
      result = File(photo?.path ?? "");
    } else {
      FilePickerResult? photo = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'heic', 'heif']);
      result = File(photo?.files.first.path ?? "");
    }

    if (result != null) {
      File? file = File(result.path);
      List fileLIst = file.path.split("/").last.split(".");

      String fileName = fileLIst[0];
      if (fileLIst.length > 2) {
        for (int i = 1; i < fileLIst.length - 1; i++) {
          fileName = fileName + "_${fileLIst[i]}";
        }
      }
      String fileNameWithoutExtension = fileName;
      fileName = fileName + ".${fileLIst.last.toString().toLowerCase()}";
      Directory cachePath = await getTemporaryDirectory();
      File newImage = await File(file.path).rename("${cachePath.path}/$fileName");
      file = newImage;

      Directory tempDir = await getTemporaryDirectory();

      if (fileLIst.last.toString().toLowerCase() == "heic" || fileLIst.last.toString().toLowerCase() == "heif") {
        File? compressedImage = await FlutterImageCompress.compressAndGetFile(file.path, "${tempDir.path}/$fileNameWithoutExtension.jpeg", format: CompressFormat.jpeg, quality: 100);
        file = compressedImage ?? newImage;
      }

      log('DOC=>${file}');
      imageName = file.path.split("/").last;
      String str = file.path;
      String extension = str.substring(str.lastIndexOf('.') + 1);
      log('extension:::$extension');
      if (extension == 'jpeg' || extension == 'png' || extension == 'jpg' || extension == 'JPEG' || extension == 'PNG' || extension == 'JPG') {
        _image = file;
        cnt.uploadBankImage(file: _image!, context: context);
        log('image is $_image');
        setState(() {});
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    cnt.ibanController.value.text = "";
    cnt.accountNameController.value.text = "";
    super.initState();
    initFunc();
    if (widget.isEdit == true) {
      cnt.ibanController.value.text = widget.iban.toString();
      cnt.accountNameController.value.text = widget.accountname.toString();
    } else {}
    // cnt.ibanController.value.text = Get.arguments[1];
    // cnt.accountNameController.value.text = Get.arguments[0];
  }

  initFunc() async {
    token = await encryptedSharedPreferences.getString('token');

    print("init Master Bank called");
    await cnt.getBanks(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.off(() => BankAccount());
          return false;
        },
        child: Scaffold(
          backgroundColor: ColorsUtils.white,
          bottomSheet: Padding(
            padding: const EdgeInsets.only(bottom: 25, left: 20, right: 20),
            child: InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  if (_image == null) {
                    print("Empty Ave che");
                    Get.snackbar('error'.tr, 'Please upload letter'.tr);
                  } else if (cnt.ibanController.value.text.length <= 27 || cnt.ibanController.value.text.length >= 30) {
                    Get.snackbar('error', 'Invalid IBAN number'.tr);
                  } else if (cnt.accountNameController.value.text == "") {
                    Get.snackbar('error', 'Please enter account name'.tr);
                  } else {
                    print('-----${cnt.masterBanks.toString()}');
                    cnt.masterBanks.forEach((element) async {
                      print("element.id ${element.id}");
                      print('ibn number==${element.ibannumber}');

                      // print(
                      //     'ibncontroller==${cnt.ibanController.value.text.substring(4, 8)}');
                      print('lenght is ${cnt.ibanController.value.text.length}');

                      if (cnt.ibanController.value.text.substring(4, 8) == element.ibannumber) {
                        print('=======>>>${element.id}');
                        cnt.updateBankID(element.id ?? 0);
                      } else {
                        print('errrrrrroroor');
                      }
                    });
                    print('update bank-----${cnt.bankId.value}');
                    // if (cnt.bankId.value != 0) {
                    await cnt.addBankData(
                        context: context, ibanNumber: cnt.ibanController.value.text, bankId: cnt.bankId.value, primary: Get.arguments ?? false, accountName: cnt.accountNameController.value.text);
                    // } else {
                    //   Get.snackbar('error'.tr, 'Invalid Ibn Number');
                    //   // Get.snackbar('error'.tr,
                    //   //     'The given IBAN is already registered with us! Please provide another IBAN number');
                    // }
                    businessInfoViewModel.getBankData(context);
                  }
                }
                cnt.isLoading.value = false;
              },
              child: Container(
                height: 48.0,
                child: buildContainerWithoutImage(
                  color: ColorsUtils.primary,
                  text: 'Save'.tr,
                ),
              ),
            ),
          ),
          body: Obx(() => cnt.isLoading.value
              ? Center(
                  child: Lottie.asset(Images.slogo, width: 60, height: 60),
                )
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height24(),
                          Text('Bank Account details'.tr, style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.medLarge)),
                          height24(),
                          commonTextField(
                            contollerr: cnt.accountNameController.value,
                            regularExpression: TextValidation.bankAccountName,
                            hint: 'Account Name'.tr,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Account Name cannot be empty".tr;
                              } else if (value.length > 128) {
                                return "Account Name can't greater then 128 character".tr;
                              }
                              return null;
                            },
                          ),
                          height20(),
                          commonTextField(
                            onChange: (str) {
                              if (str.length >= 8) {
                                ibanApiCall();
                              } else if(str.length < 8) {
                                setState(() {
                                  bankName = "";
                                  bankLogo = "";
                                });
                              }
                            },
                            maxLength: 29,
                            inputFormatters: [
                              TextInputFormatter.withFunction((oldValue, newValue) => TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection)),
                            ],
                            textCapitalization: TextCapitalization.characters,
                            contollerr: cnt.ibanController.value,
                            hint: 'Bank IBAN'.tr,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "IBAN number cannot be empty".tr;
                              } else if (value.length < 4) {
                                return "IBAN number can't less then 4 digit".tr;
                              }
                              return null;
                            },
                          ),
                          height12(),
                          if (bankName.isNotEmpty)
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bankName),
                                height8(),
                                Image.network(
                                  height: 50.0,
                                  width: 120.0,
                                  fit: BoxFit.contain,
                                  "${Utility.baseUrl}containers/api-banks/download/$bankLogo?access_token=${token!}",
                                ),
                                height12(),
                              ],
                            ),
                          Text('Note: You have to add below documents to verify your account'.tr, style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small)),
                          height40(),
                          Text('Authorization letter'.tr, style: ThemeUtils.blackSemiBold.copyWith(fontSize: FontUtils.mediumSmall)),
                          height12(),
                          Text('Upload the bank authorization letter'.tr, style: ThemeUtils.blackRegular.copyWith(fontSize: FontUtils.small)),
                          height24(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => getImageFile(),
                                child: Container(
                                  height: 48,
                                  width: 117,
                                  decoration: BoxDecoration(border: Border.all(width: 1, color: ColorsUtils.primary), borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    children: [
                                      width12(),
                                      SvgPicture.asset(
                                        Images.plusicon,
                                        color: ColorsUtils.primary,
                                      ),
                                      width8(),
                                      Text('Upload'.tr, style: ThemeUtils.maroonSemiBold.copyWith(fontSize: FontUtils.small)),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  imageName.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          // appBar:
          appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  Get.off(BankAccount());
                },
                child: Icon(Icons.arrow_back_ios_rounded, color: ColorsUtils.black)),
          ),
        ));
  }

  Future<void> ibanApiCall() async {
    if (ibanApiCalling) {
      return;
    }
    ibanApiCalling = true;
    token = await encryptedSharedPreferences.getString('token');
    final url = Uri.parse('${Utility.baseUrl}banks/findOne?filter[where][ibannumber]=${cnt.ibanController.value.text.substring(4, 8)}');
    Map<String, String> header = {'Authorization': token!, 'Content-Type': 'application/json'};
    print(url);
    var result = await http.get(
      url,
      headers: header,
    );
    if (result.statusCode == 200) {
      ibanApiCalling = false;
      print(result.body);
      Map temp = jsonDecode(result.body);
      setState(() {
        bankName = temp['name'];
        bankLogo = temp['logo'];
      });
    } else {
      ibanApiCalling = false;
      setState(() {
        bankName = "";
        bankLogo = "";
      });
    }
  }
}
