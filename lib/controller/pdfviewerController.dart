// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:get/get.dart';
import 'package:sadad_merchat_app/main.dart';

class PdfViewerModel extends GetxController {
  String token = "";
  bool isLoading = true;
  String pdfView = "";
  String error = "";
  // PDFDocument? doc;

  // https://api.sadadqatar.com/api-v5/containers/api-agreement/download/1665125658037_products_(28).pdf
  Future getToken() async {
    try {
      isLoading = true;
      update();
      pdfView = await encryptedSharedPreferences.getString('Pdf');
      print('PDF VI:=>${pdfView}');
      token = await encryptedSharedPreferences.getString('token');
      // doc = await PDFDocument.fromURL(
      //   pdfView,
      //   headers: {'Authorization': token},
      // );

      // print('DOC :=>$doc');

      isLoading = false;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
    update();
  }
}
