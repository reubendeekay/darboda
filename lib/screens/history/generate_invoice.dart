import 'package:open_filex/open_filex.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFilex.open(url);
  }
}

class PdfInvoiceApi {
  static Future<File> generate(Widget widget) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        widget,
      ],
      footer: (context) => Text('Generated by CoFarmer'),
    ));

    return PdfApi.saveDocument(name: 'Invoice.pdf', pdf: pdf);
  }
}
