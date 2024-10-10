import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/model/apimodels/responseModel/more/businessInfomodel.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/docUpdateOtpScreen.dart';
import 'package:sadad_merchat_app/view/more/moreOtpScreen.dart';
import 'package:sadad_merchat_app/viewModel/more/bank/bankAccountViewModel.dart';

import '../../../../viewModel/more/businessInfo/businessInfoViewModel.dart';

class CommercialRegistrationScreenOld extends StatefulWidget {
  String? title;
  String? subtitle;
  String? imgId;
  String? id;
  // Map<String, Map<String, dynamic>>? docData;

  CommercialRegistrationScreenOld(
      {Key? key, this.title, this.subtitle, this.id, this.imgId})
      : super(key: key);

  @override
  State<CommercialRegistrationScreenOld> createState() =>
      _CommercialRegistrationScreenOldState();
}

class _CommercialRegistrationScreenOldState
    extends State<CommercialRegistrationScreenOld> {
  final cnt = Get.find<BusinessInfoViewModel>();
  final bankA = Get.find<BankAccountViewModel>();
  final _formKey = GlobalKey<FormState>();
  RxList<Businessmedia> businessMediaList = <Businessmedia>[].obs;
  Map<String, Map<String, dynamic>> docData = {};

  @override
  void initState() {
    // TODO: implement initState
    print("==-=>${widget.title}");
    cnt.dateCnt.clear();
    cnt.image = null;
    super.initState();
  }

  Future getImageFile() async {
    String title = widget.id!;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png','pdf']);

    if (result != null) {
      File? file = File(result.files.single.path!);
      log('DOC=>${file}');
      cnt.imageName = file.path.split("/").last;
      String str = file.path;
      String extension = str.substring(str.lastIndexOf('.') + 1);
      log('extension:::$extension');
      if (extension == 'jpeg' || extension == 'png' || extension == 'jpg' || extension == 'pdf') {
        cnt.image = file;
        bankA.uploadBusinessImage(file: cnt.image!, context: context);
        // log('image is $cnt.image');
        // if (widget.docData!.containsKey(title)) {
        //   widget.docData![title]!['file'] = file.path;
        //   widget.docData![title]!['url'] = bankA.uploadedUrl.value;
        // } else {
        // docData!.addAll({
        //   title: {
        //     'id': widget.imgId,
        //     'url': bankA.uploadedUrl.value,
        //     'typeId': widget.id
        //   }
        // });
        // widget.docData!.addAll({
        //   title: {
        //     'date': '',
        //     'file': file.path,
        //     'url': bankA.uploadedUrl.value
        //   }
        // });
        // }
        setState(() {});
      }
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          bottomSheet: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 60, left: 20, right: 20),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (cnt.image == null) {
                        print("Empty Ave che");
                        Get.snackbar('error'.tr, 'Please upload Image'.tr);
                      } else {
                        // Get.off(
                        //     () => MoreOtpScreen(
                        //           type: "Document",
                        //           businessDataModel:
                        //               cnt.businessDataModel.value,
                        //           businessMedia: Businessmedia(
                        //             name: widget.subtitle,
                        //             businessmediatypeId: widget.id,
                        //           ),
                        //         ),
                        //     arguments: "Document");
                        docData!.addAll({
                          widget.id!: {
                            'id': widget.imgId,
                            'url': bankA.uploadedUrl.value,
                            'typeId': widget.id,
                            'date': cnt.selectedDate
                          }
                        });
                        print('doc------${docData}');
                        Get.back(result: docData);
                        // Get.off(() => DocUpdateOtpScreen(
                        //       isDelete: false,
                        //       docData: docData,
                        //       isEdit: true,
                        //     ));
                      }
                    }

                    // cnt.updateBusinessDetails(context:  context);
                  },
                  child: buildContainerWithoutImage(
                      color: ColorsUtils.primary, text: 'Add'.tr),
                ),
              ),
            ],
          ),
          appBar: commonAppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height24(),
                Text(widget.title.toString(),
                    style: ThemeUtils.blackSemiBold
                        .copyWith(fontSize: FontUtils.medLarge)),
                height12(),
                Text(widget.subtitle.toString()),
                height32(),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        getImageFile();
                        // imgFromGallery();
                      },
                      child: Container(
                        height: Get.height * 0.125,
                        width: Get.width * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorsUtils.border)),
                        child: Stack(
                          children: [
                            cnt.image == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: Image.asset(
                                        Images.noImage,
                                        fit: BoxFit.cover,
                                        height: 25,
                                        width: 25,
                                      ),
                                    ))
                                : cnt.imageName.contains('pdf') ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                        child: Image.asset(
                                          Images.doc,
                                          fit: BoxFit.fill,
                                          height: 50,
                                          width: 50,
                                        ))) : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  cnt.image!,
                                  fit: BoxFit.cover,
                                  height: Get.height * 0.125,
                                  width: Get.width * 0.25,
                                )),
                            const Positioned(
                              bottom: 10,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: ColorsUtils.accent,
                                radius: 10,
                                child: Center(
                                    child: Icon(
                                  Icons.add,
                                  color: ColorsUtils.white,
                                  size: 15,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    width20(),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Product image'.tr,
                          style: ThemeUtils.blackBold
                              .copyWith(fontSize: FontUtils.small),
                        ),
                        height10(),
                        Text(
                          'Max Image dimension 500px X 500px, MAX 1MB'.tr,
                          style: ThemeUtils.blackSemiBold
                              .copyWith(fontSize: FontUtils.verySmall),
                        ),
                      ],
                    ))
                  ],
                ),
                height32(),
                commonTextField(
                  hint: "Expiration date".tr,
                  contollerr: cnt.dateCnt,
                  isRead: true,
                  onTap: () async {
                    log("Inside the log");
                    DateTime selectedDate = DateTime.now();
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 0)),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                        cnt.selectedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(picked).toString();
                        cnt.dateCnt.text =
                            DateFormat.yMMMd().format(selectedDate);
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Expiration Date cannot be Empty".tr;
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//
// class DateTextFormatter extends TextInputFormatter {
//   static const _maxChars = 8;
//
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     var text = _format(newValue.text, '/');
//     return newValue.copyWith(text: text, selection: updateCursorPosition(text));
//   }
//
//   String _format(String value, String seperator) {
//     value = value.replaceAll(seperator, '');
//     var newString = '';
//
//     for (int i = 0; i < min(value.length, _maxChars); i++) {
//       newString += value[i];
//       if ((i == 1 || i == 3) && i != value.length - 1) {
//         newString += seperator;
//       }
//     }
//
//     return newString;
//   }
//
//   TextSelection updateCursorPosition(String text) {
//     return TextSelection.fromPosition(TextPosition(offset: text.length));
//   }
// }
