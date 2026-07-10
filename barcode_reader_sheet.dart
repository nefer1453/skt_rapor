import 'package:flutter/material.dart';
import 'product_model.dart';

class BarcodeReaderSheet extends StatefulWidget {
  final Function(ProductModel) onProductAdded;

  const BarcodeReaderSheet({Key? key, required this.onProductAdded}) : super(key: key);

  @override
  State<BarcodeReaderSheet> createState() => _BarcodeReaderSheetState();
}

class _BarcodeReaderSheetState extends State<BarcodeReaderSheet> {
  final _barcodeController = TextEditingController();
  final _countController = TextEditingController(text: "1");
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30)); // Varsayılan 1 ay sonrası
  
  bool _isBarcodeEntered = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    _countController.dispose();
    super.dispose();
  }

  // Tarih seçici fonksiyonu
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // En fazla 5 yıl sonrası
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1A73E8),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Klavye açıldığında ekranın altından taşmaması için padding ayarı
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Üst Tutamaç Çizgisi
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (!_isBarcodeEntered) ...[
              // --- 1. AŞAMA: BARKOD OKUMA/YAZMA ---
              const Text(
                "Ürün Barkodu Okutun veya Yazın",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Yapay Zeka/Kamera Tarama Alanı Simülasyonu
              // Gerçek pakette (örn: mobile_scanner) bu container içine kamera görüntüsü gömülür.
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1A73E8), width: 1),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera_outlined, color: Color(0xFF1A73E8), size: 40),
                    SizedBox(height: 8),
                    Text("Kamera Barkod İçin Aktif...", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Otomatik Tetiklenen Klavye Giriş Alanı
              TextField(
                controller: _barcodeController,
                autofocus: true, // Klavye pencere açılır açılmaz anında tetiklenir
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                decoration: InputDecoration(
                  hintText: "Barkodu Manuel Girin...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.qr_code, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1A73E8))),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _isBarcodeEntered = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_barcodeController.text.isNotEmpty) {
                    setState(() {
                      _isBarcodeEntered = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Devam Et", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ] else ...[
              // --- 2. AŞAMA: ADET VE SKT GİRİŞİ ---
              Text(
                "Barkod: ${_barcodeController.text}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF1A73E8), fontSize: 14, fontFamily: 'monospace', fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Adet Giriş Alanı
              TextField(
                controller: _countController,
                keyboardType: TextInputType.number,
                autofocus: true, // Barkod bitince doğrudan adet klavyesi açılır
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Ürün Adeti",
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.pin, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              
              // SKT Seçim Butonu
              OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today, color: Color(0xFF1A73E8)),
                label: Text(
                  "SKT Seç: ${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF1A73E8)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              
              // Kaydet Butonu
              ElevatedButton(
                onPressed: () {
                  final int count = int.tryParse(_countController.text) ?? 1;
                  // Gerçek senaryoda veritabanından isim çekilecek, şimdilik geçici isim veriyoruz
                  final newProduct = ProductModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: "Yeni Okutulan Ürün", 
                    barcode: _barcodeController.text,
                    count: count,
                    sktDate: _selectedDate,
                  );
                  
                  widget.onProductAdded(newProduct);
                  Navigator.pop(context); // Pencereyi kapat
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF388E3C), // Güvenli Yeşil Kaydet Butonu
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Listeye Ekle", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
