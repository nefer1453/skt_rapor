import 'package:flutter/material.dart';
import 'product_model.dart';
import 'product_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Geçici sahte veri listesi (Arayüzü görebilmek için)
  final List<ProductModel> _scannedProducts = [
    ProductModel(id: "1", name: "Eski Kaşar Peyniri", barcode: "8690001112223", count: 12, sktDate: DateTime.now().add(const Duration(days: 5))),
    ProductModel(id: "2", name: "Macar Salam", barcode: "8694445556667", count: 8, sktDate: DateTime.now().add(const Duration(days: 20))),
    ProductModel(id: "3", name: "Zeytin Ezmesi", barcode: "8697778889991", count: 25, sktDate: DateTime.now().add(const Duration(days: 45))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Parlama yapmayan ana arka plan
      appBar: AppBar(
        title: const Text("SKT KONTROL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Colors.white),
            onPressed: () {
              // Raporlama ekranına geçiş buraya bağlanacak
            },
          ),
        ],
      ),
      body: _scannedProducts.isEmpty
          ? const Center(
              child: Text(
                "Henüz ürün okutulmadı.\nBaşlamak için aşağıdaki butona basın.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 100), // Butonun altını kapatmaması için padding
              itemCount: _scannedProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: _scannedProducts[index]);
              },
            ),
      
      // Tek elle operasyon için ekranın alt ortasına yerleştirilmiş devasa buton
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 85,
        height: 85,
        child: FloatingActionButton(
          onPressed: () {
            // Kamera ve Klavyeyi aynı anda tetikleyecek fonksiyon buraya gelecek
          },
          backgroundColor: const Color(0xFF1A73E8), // Elektrik Mavisi aksiyon rengi
          shape: const CircleBorder(),
          elevation: 6,
          child: const Icon(
            Icons.center_focus_strong, // Hem odaklanmayı hem kamerayı çağrıştıran şık ikon
            size: 38,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
