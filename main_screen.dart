import 'package:flutter/material.dart';
import 'product_model.dart';
import 'product_card.dart';
import 'barcode_reader_sheet.dart';
import 'database_helper.dart';
import 'report_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<ProductModel> _scannedProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    setState(() => _isLoading = true);
    final products = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _scannedProducts = products;
      _isLoading = false;
    });
  }

  Future<void> _deleteProduct(String id) async {
    await DatabaseHelper.instance.deleteProduct(id);
    _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("SKT KONTROL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        // main_screen.dart içindeki AppBar actions kısmı güncellendi:
  actions: [
  IconButton(
    icon: const Icon(Icons.analytics_outlined, color: Colors.white),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReportScreen()),
      );
    },
  ),
],
        
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1A73E8)))
          : _scannedProducts.isEmpty
              ? const Center(
                  child: Text(
                    "Henüz ürün okutulmadı.\nBaşlamak için aşağıdaki butona basın.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  itemCount: _scannedProducts.length,
                  itemBuilder: (context, index) {
                    final product = _scannedProducts[index];
                    return Dismissible(
                      key: Key(product.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteProduct(product.id);
                      },
                      child: ProductCard(product: product),
                    );
                  },
                ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 85,
        height: 85,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return BarcodeReaderSheet(
                  onProductAdded: (newProduct) async {
                    await DatabaseHelper.instance.insertProduct(newProduct);
                    _refreshProducts();
                  },
                );
              },
            );
          },
          backgroundColor: const Color(0xFF1A73E8),
          shape: const CircleBorder(),
          elevation: 6,
          child: const Icon(
            Icons.center_focus_strong,
            size: 38,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
