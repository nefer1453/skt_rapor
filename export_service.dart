import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'database_helper.dart';
import 'product_model.dart';

class ExportService {
  // 1. WhatsApp / Metin Formatı
  static Future<void> shareViaWhatsApp() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    if (products.isEmpty) return;

    StringBuffer sb = StringBuffer();
    sb.writeln("*SKT DURUM RAPORU* 📋\n");
    
    for (var p in products) {
      final dateStr = "${p.sktDate.day}.${p.sktDate.month}.${p.sktDate.year}";
      sb.writeln("▪️ *${p.name}*");
      sb.writeln("Adet: ${p.count} | SKT: $dateStr");
      sb.writeln("Barkod: ${p.barcode}\n");
    }

    // Share eklentisi telefondaki paylaşım menüsünü (WhatsApp dahil) tetikler
    await Share.share(sb.toString(), subject: 'SKT Raporu');
  }

  // 2. Excel Formatı (.xlsx)
  static Future<void> exportToExcel() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    if (products.isEmpty) return;

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['SKT_Raporu'];
    excel.setDefaultSheet('SKT_Raporu');

    // Başlıklar
    sheetObject.appendRow(['Barkod', 'Ürün Adı', 'Adet', 'SKT']);

    // Veriler
    for (var p in products) {
      final dateStr = "${p.sktDate.day}.${p.sktDate.month}.${p.sktDate.year}";
      sheetObject.appendRow([p.barcode, p.name, p.count, dateStr]);
    }

    // Dosyayı kaydet ve paylaş
    final directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/SKT_Raporu_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final fileBytes = excel.encode();
    
    if (fileBytes != null) {
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      
      await Share.shareXFiles([XFile(filePath)], text: 'Excel SKT Raporu');
    }
  }

  // 3. PDF Formatı (Adobe Estetiğinde Temiz Tablo)
  static Future<void> exportToPdf() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    if (products.isEmpty) return;

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("SKT KONTROL RAPORU", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Barkod', 'Urun Adi', 'Adet', 'SKT'],
                data: products.map((p) {
                  return [
                    p.barcode,
                    p.name,
                    p.count.toString(),
                    "${p.sktDate.day}.${p.sktDate.month}.${p.sktDate.year}"
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
                rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300))),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/SKT_Raporu_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(filePath)], text: 'PDF SKT Raporu');
  }

  // 4. JSON Formatı (Sistem İçi Evrensel Veri Çıktısı)
  static Future<void> exportToJson() async {
    final products = await DatabaseHelper.instance.getAllProducts();
    if (products.isEmpty) return;

    // Verileri Map listesine çevirip JSON string'e dönüştürüyoruz
    final List<Map<String, dynamic>> jsonData = products.map((p) => {
      "id": p.id,
      "isim": p.name,
      "barkod": p.barcode,
      "adet": p.count,
      "skt": p.sktDate.toIso8601String(),
    }).toList();

    final String jsonString = jsonEncode(jsonData);

    final directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/SKT_Raporu_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File(filePath);
    await file.writeAsString(jsonString);

    await Share.shareXFiles([XFile(filePath)], text: 'JSON SKT Raporu');
  }
}
