import 'package:flutter/material.dart';

/// Dart import
import 'dart:async';
import 'dart:io';
import 'dart:ui' as dart_ui;

/// Package imports

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Barcode import
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

/// Pdf import
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// open file library import
// import 'package:open_file/open_file.dart';

final GlobalKey<_BarcodeState> barcodeKey = GlobalKey();

class Barcode extends StatefulWidget {
  final String? codeValue;
  const Barcode({Key? key, this.codeValue}) : super(key: key);

  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        child: SfBarcodeGenerator(
      value: '${widget.codeValue}',
      symbology: QRCode(),
    )

        // child: SfBarcodeGenerator(
        //   value: 'CODE128',
        //   showValue: true,
        //   symbology: Code128(module: 2),
        // ),
        );
  }

  Future<dart_ui.Image> convertToImage({double pixelRatio = 1.0}) async {
    // Get the render object from context and store in the RenderRepaintBoundary onject.
    final RenderRepaintBoundary boundary =
        context.findRenderObject() as RenderRepaintBoundary;

    // Convert the repaint boundary as image
    final dart_ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

    return image;
  }
}
