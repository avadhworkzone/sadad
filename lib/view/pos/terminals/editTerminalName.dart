import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/util/validations.dart';
import 'package:http/http.dart' as http;
import 'package:sadad_merchat_app/viewModel/pos/terminal/terminalViewModel.dart';

class EditTerminalName extends StatefulWidget {
  String? terminalName;
  String? id;

  EditTerminalName({Key? key, this.terminalName, this.id}) : super(key: key);

  @override
  State<EditTerminalName> createState() => _EditTerminalNameState();
}

class _EditTerminalNameState extends State<EditTerminalName> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController name = TextEditingController();

  @override
  void initState() {
    initData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomUpdateButton(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height60(),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 25,
                      )),
                  height40(),
                  customMediumLargeBoldText(title: 'Edit terminal name'.tr),
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
                      regularExpression: TextValidation.alphabetSpaceValidationPattern,
                      hint: 'Terminal name*'.tr),
                ],
              ),
            ),
          ),
        ));
  }

  Column bottomUpdateButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                showLoadingDialog(context: context);
                String token = await encryptedSharedPreferences.getString('token');
                final url = Uri.parse(
                  '${Utility.baseUrl}terminals/${widget.id}',
                );
                print(url);
                Map<String, String> header = {'Authorization': token, 'Content-Type': 'application/json'};
                Map<String, dynamic>? body = {
                  "name": "${name.text}",
                };

                var result = await http.patch(
                  url,
                  headers: header,
                  body: jsonEncode(body),
                );

                print('token is:$token \n req is : ${jsonEncode(body)}  \n response is :${result.body} ');

                if (result.statusCode == 200) {
                  Get.back();

                  Get.snackbar('Success'.tr, 'terminal updated successfully');
                  hideLoadingDialog(context: context);
                } else {
                  if (result.statusCode == 401) {
                    SessionExpire();
                  }

                  hideLoadingDialog(context: context);

                  Get.snackbar('error'.tr, '${jsonDecode(result.body)['error']['message']}');
                }
              }
            },
            child: buildContainerWithoutImage(color: ColorsUtils.accent, text: 'update'.tr),
          ),
        ),
        height30()
      ],
    );
  }

  initData() async {
    name.text = widget.terminalName!;
    print('name is${name.text + 'id is ${widget.id}'}');
  }
}
