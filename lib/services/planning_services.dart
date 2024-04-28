import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as dart_ui;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pfe_syrine/global.dart';
import 'package:pfe_syrine/models/planning.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../constants.dart';
import 'callapi.dart';

class PlanningServices {
  Future<Planning> createPlanning(Map data, VoidCallback refresh) async {
    var response = await CallApi().postData(data, 'create_planning');
    var jsondata = jsonDecode(response.body);
    Planning planning = Planning.fromJson(jsondata);
    refresh();
    return planning;
  }

  Future<bool> deletePlanning(int planningId, VoidCallback refresh) async {
    try {
      var response = await CallApi().deleteData('deleteplanning/${planningId}');
      if (response.statusCode == 200) {
        refresh();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> startPlanning(int planningId, VoidCallback refresh) async {
    var user = GetStorage().read("user");
    try {
      var response = await CallApi().getData('start_planning/${planningId}/${user['id']}');
      if (response.statusCode == 200) {
        refresh();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> finishPlanning(int planningId, VoidCallback refresh) async {
    var user = GetStorage().read("user");
    try {
      var response = await CallApi().getData('finish_planning/${planningId}/${user['id']}');
      if (response.statusCode == 200) {
        refresh();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

/*  Future<void> createPDF(Planning planning) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    page.graphics.drawString(
        "Planning QR Code ",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          20,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.4, 25, 300, 50));

    page.graphics.drawString(
        "Date : ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.8, 70, 300, 50));

    page.graphics.drawString(
        "Planning : ${planning.activity.name}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 75, 300, 50));
    page.graphics.drawString(
        "Employee : ${planning.user.firstname} ${planning.user.lastname.toUpperCase()}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 110, 300, 50));

    page.graphics.drawString(
        "Start date: ${DateFormat("yyyy-MM-dd HH:mm").format(planning.start_time)}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 140, 300, 50));

    page.graphics.drawString(
        "End date  : ${DateFormat("yyyy-MM-dd HH:mm").format(planning.end_time)}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 170, 300, 50));
    page.graphics.drawImage(PdfBitmap(await _readImageData('logo2.png')), Rect.fromLTWH(Constants.screenWidth * 0.9, 0, 150, 70));
    // page.graphics.drawImage(await _readImageDataFromWeb(company.url), Rect.fromLTWH(Constants.screenWidth * 0.001, 0, 100, 70));

    document.save().then((value) {
      List<int> bytes = value;

      saveAndLaunchFile(bytes, '${planning.activity.name + "_" + DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())}.pdf');
    });
  }*/

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> renderPdf(Planning planning) async {
    // Create a new PDF document.
    final PdfDocument document = PdfDocument();

    // Create a pdf bitmap for the rendered barcode image.
    final PdfBitmap bitmap = PdfBitmap(await _readImageDataQ());
    // set the necessary page settings for the pdf document such as margin, size etc..
    document.pageSettings.margins.all = 10;

    // Create a PdfPage page object and assign the pdf document's pages to it.
    final PdfPage page = document.pages.add();
    // Retrieve the pdf page client size
    page.graphics.drawString(
        "Planning QR Code ",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          20,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.4, 25, 300, 50));

    page.graphics.drawString(
        "Date : ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.8, 70, 300, 50));

    page.graphics.drawString(
        "Planning : ${planning.activity.name}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 75, 300, 50));
    page.graphics.drawString(
        "Employee : ${planning.user.firstname} ${planning.user.lastname.toUpperCase()}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 110, 300, 50));

    page.graphics.drawString(
        "Start date: ${DateFormat("yyyy-MM-dd HH:mm").format(planning.start_time)}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 140, 300, 50));

    page.graphics.drawString(
        "End date  : ${DateFormat("yyyy-MM-dd HH:mm").format(planning.end_time)}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 170, 300, 50));
    page.graphics.drawImage(PdfBitmap(await _readImageData('logo2.png')), Rect.fromLTWH(Constants.screenWidth * 0.9, 0, 150, 70));
    // Draw an image into graphics using the bitmap.
    page.graphics.drawImage(bitmap, Rect.fromLTWH(35, 200, 500, 300));
    page.graphics.drawString(
        "Scan to start",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.6, 450, 300, 50));
    //Save and dispose the document.

    document.save().then((value) {
      List<int> bytes = value;
      saveAndLaunchFile(bytes, "${planning.activity.name}_${planning.activity.type}" + '.pdf');
    });
  }

  /// Method to read the rendered barcode image and return the image data for processing.
  Future<List<int>> _readImageDataQ() async {
    final dart_ui.Image data = await Global.barcodeKey.currentState!.convertToImage(pixelRatio: 3.0);
    final ByteData? bytes = await data.toByteData(format: dart_ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}

class Barcode extends StatefulWidget {
  final String value;
  const Barcode({Key? key, required this.value}) : super(key: key);

  @override
  BarcodeState createState() => BarcodeState();
}

class BarcodeState extends State<Barcode> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
        child: Container(
      height: 100,
      width: 200,
      child: SfBarcodeGenerator(value: widget.value, symbology: QRCode(module: 2)),
    ));
  }

  Future<dart_ui.Image> convertToImage({double pixelRatio = 1.0}) async {
    // Get the render object from context and store in the RenderRepaintBoundary onject.
    final RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;

    // Convert the repaint boundary as image
    final dart_ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);

    return image;
  }
}
