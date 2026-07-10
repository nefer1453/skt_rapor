class ProductModel {
  final String id;
  final String name;
  final String barcode;
  final int count;
  final DateTime sktDate;

  ProductModel({
    required this.id,
    required this.name,
    required this.barcode,
    required this.count,
    required this.sktDate,
  });

  // SKT'ye kalan gün sayısını hesaplayan yardımcı fonksiyon
  int get remainingDays {
    final today = DateTime.now();
    final difference = sktDate.difference(DateTime(today.year, today.month, today.day));
    return difference.inDays;
  }
}
