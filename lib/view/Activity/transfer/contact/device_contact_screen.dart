import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/util/utils.dart';

class DeviceContactScreen extends StatefulWidget {
  DeviceContactScreen({Key? key}) : super(key: key);

  @override
  State<DeviceContactScreen> createState() => _DeviceContactScreenState();
}

class _DeviceContactScreenState extends State<DeviceContactScreen> {
  TextEditingController searchUser = TextEditingController();
  List<Contact> contactList = [];
  String selectedNumber = '';
  int selectedContact = -1;
  bool? isLoad = true;
  @override
  void initState() {
    getMyContact();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///Contact

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Get.back(result: selectedNumber);
              },
              child: buildContainerWithoutImage(
                  color: ColorsUtils.accent, text: 'Select'),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height40(),
          Stack(
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.arrow_back_ios_outlined),
                  )),
              Center(child: customMediumLargeBoldText(title: 'Your Contact')),
            ],
          ),
          height10(),
          isLoad == true
              ? Expanded(
                  child: Center(
                  child: Loader(),
                ))
              : Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: contactList.length,
                      itemBuilder: (context, i) {
                        // return Text("111111");
                        return contactList[i].phones!.isEmpty
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedContact == i
                                        ? ColorsUtils.lightPink
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorsUtils.border, width: 1),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      selectedContact = i;
                                      selectedNumber =
                                          contactList[i].phones!.first.value!;
                                      print(
                                          'contact details ${contactList[i].phones!.first.value}');
                                      setState(() {});
                                    },
                                    child: contactList[i].phones!.isEmpty
                                        ? SizedBox()
                                        : ListTile(
                                            leading: const CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  ColorsUtils.accent,
                                              child: Icon(Icons.person,
                                                  color: ColorsUtils.white),
                                            ),
                                            title: customMediumBoldText(
                                              title:
                                                  contactList[i].displayName ??
                                                      '',
                                            ),
                                            subtitle: contactList[i]
                                                        .phones!
                                                        .isEmpty ||
                                                    contactList[i].phones ==
                                                        null
                                                ? SizedBox()
                                                : customSmallSemiText(
                                                    title: contactList[i]
                                                                .phones!
                                                                .isEmpty ||
                                                            contactList[i]
                                                                    .phones ==
                                                                null
                                                        ? ''
                                                        : contactList[i]
                                                                    .phones!
                                                                    .first
                                                                    .value ==
                                                                null
                                                            ? 'NA'
                                                            : contactList[i]
                                                                    .phones!
                                                                    .first
                                                                    .value ??
                                                                '')),
                                  ),
                                ),
                              );
                      }),
                )
        ],
      ),
    );
  }

  unfocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Widget contactListTile(List<Contact> contactList, int i) {
    return ListTile(
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: Colors.blue,
        child: Icon(Icons.person),
      ),
      title: Text(
        contactList[i].displayName ?? '',
      ),
      subtitle: Text(
        contactList[i].phones!.first.value ?? '',
      ),
    );
  }

  void getMyContact() async {
    contactList = await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
        iOSLocalizedLabels: false,
        androidLocalizedLabels: false);
    setState(() {
      isLoad = false;
    });
  }
}
