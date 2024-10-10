import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/payment/store/businessDocumentScreen.dart';

class EditStoreDetailScreen extends StatefulWidget {
  const EditStoreDetailScreen({Key? key}) : super(key: key);

  @override
  State<EditStoreDetailScreen> createState() => _EditStoreDetailScreenState();
}

class _EditStoreDetailScreenState extends State<EditStoreDetailScreen> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: InkWell(
              onTap: () {
                Get.to(() => BusinessDocumentScreen());
              },
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Save'.tr),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height60(),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              height40(),
              customMediumBoldText(
                  title: 'Edit store detail', color: ColorsUtils.black),
              height30(),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      getImageFile();
                      print('image is $_image');
                      setState(() {});
                      // imgFromGallery();
                    },
                    child: Container(
                      height: Get.height * 0.12,
                      width: Get.width * 0.25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ColorsUtils.border)),
                      child: Stack(
                        children: [
                          _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    width: Get.width * 0.25,
                                    _image!,
                                    fit: BoxFit.cover,
                                  ))
                              : SizedBox(
                                  child: Center(
                                      child: Image.asset(
                                    Images.noImage,
                                    height: 50,
                                    width: 50,
                                  )),
                                ),
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
                        'Store logo',
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
              height30(),
              commonTextField(hint: 'Store name', maxLines: 1)
            ],
          ),
        ),
      ),
    );
  }

  getImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);

    if (result != null) {
      File? file = File(result.files.single.path!);
      List fileLIst = file.path.split("/").last.split(".");

      String fileName = fileLIst[0];
      if (fileLIst.length > 2) {
        for (int i = 1; i < fileLIst.length - 1; i++) {
          fileName = fileName + "_${fileLIst[i]}";
        }
      }
      fileName = fileName + ".${fileLIst.last.toString().toLowerCase()}";
      Directory cachePath = await getTemporaryDirectory();
      File newImage = await File(file.path).rename("${cachePath.path}/$fileName");
      file = newImage;
      log('DOC=>${file}');
      String str = file.path;
      String extension = str.substring(str.lastIndexOf('.') + 1);
      log('extension:::$extension');
      if (extension == 'jpeg' ||
          extension == 'png' ||
          extension == 'jpg' ||
          extension == 'JPEG' ||
          extension == 'PNG' ||
          extension == 'JPG') {
        _image = file;
        log('image is $_image');
        setState(() {});
      }
    } else {
      // User canceled the picker
    }
  }
}
