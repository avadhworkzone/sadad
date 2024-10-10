import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/model/repo/more/signedContract/singedContractRepo.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/utility.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/signedContract/signedContract.dart';
import 'package:sadad_merchat_app/viewModel/more/businessInfo/businessInfoViewModel.dart';
import 'package:sadad_merchat_app/viewModel/more/signedContract/signedContractViewModel.dart';
import '../../../base/constants.dart';
import '../../../main.dart';
import '../../../model/apimodels/responseModel/more/singedContractListModel.dart';
import '../../../widget/webView.dart';

class SignedContractList extends StatefulWidget {
  const SignedContractList({Key? key}) : super(key: key);

  @override
  State<SignedContractList> createState() => _SignedContractListState();
}

class _SignedContractListState extends State<SignedContractList> {
  String? tokenMain;
  final cnt = Get.find<BusinessInfoViewModel>();
  //final temp = Get.find<SignedContractListViewModel>();
  final temp = Get.isRegistered<SignedContractListViewModel>()
      ? Get.find<SignedContractListViewModel>()
      : Get.put(SignedContractListViewModel());
  //SignedContractListViewModel signedContractListViewModel = Get.find();
  List<SignedContractListModel> signedContractListResponse = [];
  @override
  void initState() {
    super.initState();
    gettingToken();
    initData();
  }

  initData() async {
    String id = await encryptedSharedPreferences.getString('id');
    await temp.signerContractList(id);
    signedContractListResponse = temp.signerContractApiResponse.data;
    setState(() {});
  }

  gettingToken() async {
    tokenMain = await encryptedSharedPreferences.getString('token');
    setState(() {});
    print(tokenMain);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            leading: ButtonTheme(
              minWidth: 60,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back_ios_rounded,
                    color: ColorsUtils.black),
              ),
            ),
            title: customMediumLargeSemiText(title: "Signed Contract".tr)),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: customVerySmallNorText(
                  title:
                  "You can view or download the legally signed contract between Sadad and your company.".tr,
                  color: ColorsUtils.grey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(thickness: 1),
            ),
            signedContractListResponse.isEmpty
                ? Center(
              child: Loader(),
            )
                : Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height12(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: signedContractListResponse.length,
                            primary: false,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final title = signedContractListResponse[
                              index]
                                  .type ==
                                  1
                                  ? 'Online Payment Agreement'.tr
                                  : signedContractListResponse[index]
                                  .type ==
                                  2
                                  ? 'POS Agreement'.tr
                                  : signedContractListResponse[index]
                                  .type ==
                                  3
                                  ? 'Other'.tr
                                  : 'Other'.tr;
                              final description =
                              signedContractListResponse[index]
                                  .type ==
                                  3
                                  ? signedContractListResponse[index]
                                  .description ==
                                  null
                                  ? ''
                                  : signedContractListResponse[
                              index]
                                  .description
                                  : '';
                              final id = '${index + 1}';
                              return ((signedContractListResponse[index]
                                  .type ==
                                  1 ||
                                  signedContractListResponse[
                                  index]
                                      .type ==
                                      2) &&
                                  signedContractListResponse[index]
                                      .is_default ==
                                      false)
                                  ? SizedBox()
                                  : signedContractWidget(
                                type: signedContractListResponse[
                                index]
                                    .type,
                                title: title,
                                description: description,
                                token: tokenMain,
                                // onTap: () =>
                                onTap: () async {
                                  Get.to(() => SignedContract(
                                    pdfUrl: Utility.baseUrl +
                                        'containers/api-agreement/download/${signedContractListResponse[index].file_name}',
                                    title: title,
                                    description: description,
                                  ));
                                  //1667968087352_balance-statements.pdf
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signedContractWidget({
    int? type,
    String? title,
    String? token,
    String? description,
    Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsUtils.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(
                        1,
                        3,
                      ),
                    )
                  ]),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(right: 16, left: 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: ColorsUtils.transferUnSelect,
                                    boxShadow: [
                                      BoxShadow(
                                          color: ColorsUtils.lightPink,
                                          blurRadius: 6)
                                    ]),
                                padding: EdgeInsets.all(8),
                                child: type == 1
                                    ? Image.asset(Images.onlinePayment,
                                    height: 25,
                                    width: 25,
                                    color: ColorsUtils.primary)
                                    : type == 2
                                    ? Image.asset(Images.pos,
                                    height: 25,
                                    width: 25,
                                    color: ColorsUtils.primary)
                                    : SvgPicture.asset(
                                    Images.signed_contract,
                                    color: ColorsUtils.primary),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$title",
                                        overflow: TextOverflow.ellipsis,
                                        style: ThemeUtils.blackSemiBold
                                            .copyWith(
                                            fontSize: FontUtils.small)),
                                    height8(),
                                    description == ''
                                        ? SizedBox()
                                        : Text("$description",
                                        style: ThemeUtils.blackRegular
                                            .copyWith(
                                            fontSize:
                                            FontUtils.verySmall,
                                            color: ColorsUtils.grey))
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right, size: 30),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // height8(),
            // dividerData(),
          ],
        ),
      ),
    );
  }
}
