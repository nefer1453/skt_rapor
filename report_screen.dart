import 'package:flutter/material.dart';
import 'export_service.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  Widget _buildExportButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 100, // Devasa buton yüksekliği
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Raporlar ve Çıktılar", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Verileri Dışa Aktar",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Listelenen ürünleri istediğiniz formatta paylaşın.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),

            _buildExportButton(
              context: context,
              title: "WhatsApp'a Gönder",
              icon: Icons.chat_bubble_outline,
              color: const Color(0xFF25D366), // WhatsApp Yeşili
              onTap: () => ExportService.shareViaWhatsApp(),
            ),
            
            _buildExportButton(
              context: context,
              title: "PDF Oluştur",
              icon: Icons.picture_as_pdf_outlined,
              color: const Color(0xFFE53935), // PDF Kırmızısı
              onTap: () => ExportService.exportToPdf(),
            ),
            
            _buildExportButton(
              context: context,
              title: "Excel İndir",
              icon: Icons.table_chart_outlined,
              color: const Color(0xFF43A047), // Excel Yeşili
              onTap: () => ExportService.exportToExcel(),
            ),

            _buildExportButton(
              context: context,
              title: "JSON Raporu Dök",
              icon: Icons.data_object,
              color: const Color(0xFFFBC02D), // JSON / Kod Sarısı
              onTap: () => ExportService.exportToJson(),
            ),
          ],
        ),
      ),
    );
  }
}
