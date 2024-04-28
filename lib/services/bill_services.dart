import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' show get;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pfe_syrine/models/company.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../constants.dart';
import '../models/order.dart';

class BillServices {
  var user = GetStorage().read("user");
  Future<void> createPDF(List<Order> orders, Company company) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    page.graphics.drawString(
        "Product Delivery Bill",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          20,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.4, 25, 300, 50));

    page.graphics.drawString(
        "Company Name : ${company.name}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 75, 300, 50));
    page.graphics.drawString(
        "Company Adress : ${company.adresse.toUpperCase()}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 105, 300, 50));

    page.graphics.drawString(
        "Company phone number : ${company.phoneNumber}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 135, 300, 50));
    page.graphics.drawString(
        "Company Tax ID : ${company.taxID}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 165, 300, 50));
    page.graphics.drawString(
        "Date : ${DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())}",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.8, 70, 300, 50));
    page.graphics.drawString(
        "Location : Ariana",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.8, 100, 300, 50));
    page.graphics.drawString(
        "Phone :28 882 607",
        PdfStandardFont(
          PdfFontFamily.helvetica,
          17,
        ),
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(Constants.screenWidth * 0.8, 130, 300, 50));

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 17), cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));
    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Name';
    header.cells[1].value = 'Price';
    header.cells[2].value = 'Quantity';

    for (int i = 0; i < orders.length; i++) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = "${orders[i].product.name}";
      row.cells[1].value = "${orders[i].product.price}";
      row.cells[2].value = "${orders[i].quantity}";
    }
    PdfGridRow row = grid.rows.add();
    grid.rows.setSpan(orders.length, 0, 1, 3);
    double ttc = 0;
    for (var data in orders) {
      ttc += data.quantity * data.product.price;
    }
    row.cells[0].value = "Total Price Including Taxes (TTC) = ${ttc} DT";
    grid.draw(page: page, bounds: Rect.fromLTWH(Constants.screenWidth * 0.001, 250, 0, 0));
    page.graphics
        .drawImage(PdfBitmap(await _readImageData('logo_ph_c.png')), Rect.fromLTWH(Constants.screenWidth * 0.9, 0, 150, 70));
    // page.graphics.drawImage(await _readImageDataFromWeb(company.url), Rect.fromLTWH(Constants.screenWidth * 0.001, 0, 100, 70));

    document.save().then((value) {
      List<int> bytes = value;

      saveAndLaunchFile(bytes, '${company.name + DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now())}.pdf');
    });
  }

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

  Future<PdfImage> _readImageDataFromWeb(String url) async {
    var response = await get(Uri.parse(url));
    var data = response.bodyBytes;

    PdfBitmap image = PdfBitmap(data);

    return image;
  }
}
