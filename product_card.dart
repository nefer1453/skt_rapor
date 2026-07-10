import 'package:flutter/material.dart';
import 'product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  // Kalan güne göre durum rengini belirleyen fonksiyon
  Color _getStatusColor(int days) {
    if (days <= 7) return const Color(0xFFD32F2F); // Kritik: Soft Kırmızı (1 hafta veya daha az)
    if (days <= 30) return const Color(0xFFFBC02D); // Dikkat: Hardal Sarısı (1 ay veya daha az)
    return const Color(0xFF388E3C); // Güvenli: Soft Yeşil
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = product.remainingDays;
    final statusColor = _getStatusColor(daysLeft);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF1E1E1E), // Gözü yormayan koyu gri kart arka planı
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: statusColor.withOpacity(0.5), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Sol Taraf: Durum rengini belirten dikey çizgi
            Container(
              width: 6,
              height: 60,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 16),
            
            // Orta Taraf: Ürün Detayları
            Expanded(
              child: Column(
                crossAxisAlignment: start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.qr_code, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        product.barcode,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: 'monospace', // Barkod numarasının düzgün hizalanması için
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Sağ Taraf: Adet ve SKT Bilgisi
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${product.count} Adet",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${product.sktDate.day}.${product.sktDate.month}.${product.sktDate.year}",
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
