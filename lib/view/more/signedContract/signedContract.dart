import 'dart:io';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:sadad_merchat_app/base/constants.dart';
import 'package:sadad_merchat_app/controller/pdfviewerController.dart';
import 'package:sadad_merchat_app/main.dart';
import 'package:sadad_merchat_app/staticData/common_widgets.dart';
import 'package:sadad_merchat_app/staticData/loading_dialog.dart';
import 'package:sadad_merchat_app/util/downloadFile.dart';
import 'package:sadad_merchat_app/util/utils.dart';
import 'package:sadad_merchat_app/view/more/businessInfo/documentRegisterScreen/AppDialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../staticData/utility.dart';

class SignedContract extends StatefulWidget {
  String? pdfUrl;
  String? title;
  String? description;
  bool? isFromBusinessDoc;

  SignedContract(
      {Key? key,
        this.pdfUrl,
        this.title,
        this.description,
        this.isFromBusinessDoc})
      : super(key: key);

  @override
  _SignedContractState createState() => _SignedContractState();
}

class _SignedContractState extends State<SignedContract> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final cnt = Get.put<PdfViewerModel>(PdfViewerModel());

  @override
  void initState() {
    // TODO: implement initState
    bool isLoading = true;
    cnt.getToken();
    showLoadingDialog(context: context);
    loadPdf();
    super.initState();
  }

  final sampleUrl = 'http://www.africau.edu/images/default/sample.pdf';

  File? pdfFlePath;
  bool isLoading = true;

  bool isPdfLoading = true;

  Future<File> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file =
    File('${directory.path}/sadadContract_${DateTime.now().day}.pdf');
    // if (await file.exists()) {
    //   print('file==>>${file.path}');
    //   return file;
    // }

    final response = await http.get(Uri.parse(widget.pdfUrl.toString()),
        headers: {'Authorization': cnt.token});
    await file.writeAsBytes(response.bodyBytes);
    print('file==>>${file.path}');

    return file;
  }

  void loadPdf() async {
    pdfFlePath = await downloadAndSavePdf();
    isLoading = false;
    Get.back();
    setState(() {});
    print(pdfFlePath);
  }

  Widget commonRowDataBottomSheet({String? img, String? title}) {
    return InkWell(
      onTap: () {
        downloadFile(context: context, isEmail: false, url: widget.pdfUrl);
      },
      child: Row(
        children: [
          Image.asset(
            img!,
            height: 25,
            color: img == Images.link
                ? ColorsUtils.black
                : img == Images.delete
                ? ColorsUtils.reds
                : ColorsUtils.black,
            width: 25,
          ),
          width20(),
          Text(
            title!,
            style: ThemeUtils.blackBold.copyWith(
                fontSize: FontUtils.small,
                color: title == 'Delete'.tr
                    ? ColorsUtils.reds
                    : ColorsUtils.black),
          ),
        ],
      ),
    );
  }

  bottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 30, left: 24, right: 24, top: 24),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: commonRowDataBottomSheet(
              img: Images.download, title: 'Download'.tr),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('PDF::::${cnt.doc}');
    return Scaffold(
      // appBar: AppBar(
      //     // centerTitle: false,
      //     // leading: InkWell(
      //     //   onTap: () {
      //     //     Get.back();
      //     //   },
      //     //   child: Icon(Icons.arrow_back_ios_rounded, color: ColorsUtils.black),
      //     // ),
      //     title: Row(
      //       children: [
      //         customMediumLargeSemiText(title: "Signed Contract"),
      //       ],
      //     ),
      //     actions: [
      //       InkWell(
      //         onTap: () {
      //           downloadFile(
      //               context: context, isEmail: false, url: widget.pdfUrl);
      //         },
      //         child: Container(
      //           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius: BorderRadius.circular(10),
      //               boxShadow: [
      //                 BoxShadow(
      //                     color: ColorsUtils.primary.withOpacity(0.5),
      //                     blurRadius: 5)
      //               ]),
      //           child: Image.asset(
      //             Images.mailIcon,
      //             scale: 4,
      //             color: ColorsUtils.primary,
      //           ),
      //         ),
      //       ),
      //       InkWell(
      //         onTap: () {
      //           downloadFile(
      //               context: context, isEmail: false, url: widget.pdfUrl);
      //         },
      //         child: Container(
      //           margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //           decoration: BoxDecoration(
      //               color: Colors.white,
      //               borderRadius: BorderRadius.circular(10),
      //               boxShadow: [
      //                 BoxShadow(
      //                     color: ColorsUtils.primary.withOpacity(0.5),
      //                     blurRadius: 5)
      //               ]),
      //           child: Image.asset(
      //             Images.download,
      //             scale: 4,
      //             color: ColorsUtils.primary,
      //           ),
      //         ),
      //       ),
      //     ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios_rounded,
                        color: ColorsUtils.black),
                  ),
                  width10(),
                  Expanded(
                      child: customMediumLargeSemiText(title: widget.title)),
                  widget.isFromBusinessDoc == true ? SizedBox() :
                  commonTopViewContainer(context,
                      scale: 3, image: Images.mailIcon, onTap: () async {
                    String token =
                        await encryptedSharedPreferences.getString('token');
                    var pdfFileName = widget.pdfUrl!.split("/").last;
                    final url =
                    Uri.parse(Utility.baseUrl + 'merchant_agreements/sendEmail?filename=' + "$pdfFileName");
                    final request = http.Request("GET", url);
                    request.headers.addAll(<String, String>{
                      'Authorization': token,
                      'Content-Type': 'application/json'
                    });
                    showLoadingDialog(context: context);
                    request.body = '';
                    print('===>${url}');
                    final res = await request.send();
                    if (res.statusCode == 200) {
                      hideLoadingDialog(context: context);
                      print(res.request);
                      Get.snackbar('Success'.tr, 'Mail sent successFully'.tr);
                    } else {
                      hideLoadingDialog(context: context);
                      print('error ::${res.statusCode}');
                      print('error ::${res}');
                      Get.snackbar('error', '${res.request}');
                    }
                  }),
                  commonTopViewContainer(context,
                      scale: 4, image: Images.download, onTap: () {
                        downloadFile(
                            context: context, isEmail: false, url: widget.pdfUrl);
                      }),
                ],
              ),
              height24(),
              pdfFlePath == null
                  ? customVerySmallBoldText(
                  title: isLoading ? '' : 'No data Found'.tr)
                  : Expanded(
                child: SfPdfViewer.file(
                  pdfFlePath!,
                  scrollDirection: PdfScrollDirection.vertical,
                  canShowHyperlinkDialog: true,
                ),
                //   child: PDFView(
                //   filePath: pdfFlePath!.path,
                //   onViewCreated: (controller) {
                //     Get.back();
                //   },
                // )
              )
              // Expanded(
              //   child: GetBuilder<PdfViewerModel>(
              //     builder: (controller) {
              //       return controller.isLoading
              //           ? Center(
              //               child:
              //                   Lottie.asset(Images.slogo, width: 60, height: 60),
              //             )
              //           : controller.error != ""
              //               ? Text("No data")
              //               : pdfViewer(controller);
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  InkWell commonTopViewContainer(BuildContext context,
      {required Function onTap, required String image, required double scale}) {
    return InkWell(
      onTap: () {
        onTap();
        // downloadFile(
        //     context: context, isEmail: false, url: widget.pdfUrl);
      },
      child: Container(
        height: 35,
        width: 35,
        // padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: ColorsUtils.primary.withOpacity(0.5), blurRadius: 5)
            ]),
        child: Image.asset(
          image,
          scale: scale,
          color: ColorsUtils.primary,
        ),
      ),
    );
  }

  Widget pdfViewer(PdfViewerModel con) {
    if (pdfFlePath != null) {
      return Expanded(
        child: Container(
          // child: PdfView(path: pdfFlePath!),
        ),
      );
    } else {
      return Text("Pdf is not Loaded");
    }
    // print('token----${con.token}');
    // print('url----${con.pdfView}');
    // String hearder = "${con.token}";
    // return WebviewScaffold(
    //   url: con.pdfView,
    //   withJavascript: true,
    //   headers: {'Authorization': con.token},
    //   appBar: new AppBar(
    //     title: new Text("Widget webview"),
    //   ),
    // );
    // return PDFViewer(
    //   key: UniqueKey(),
    //   document: con.doc!,
    //   // scrollDirection: Axis.vertical,
    //   // showNavigation: false,
    //   // showPicker: false,
    //   // showIndicator: false,
    //   // lazyLoad: false,
    //   // maxScale: 10,
    // );
  }
}
