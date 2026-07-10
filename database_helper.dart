import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('skt_kontrol.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Ürünler tablosunun oluşturulması (İnsert/Dağılım gibi ekstra kolonlar yok, saf SKT verisi)
    await db.execute('''
    CREATE TABLE products (
      id $idType,
      name $textType,
      barcode $textType,
      count $integerType,
      sktDate $textType
    )
    ''');
  }

  // Veritabanına yeni ürün ekleme
  Future<void> insertProduct(ProductModel product) async {
    final db = await instance.database;
    await db.insert(
      'products',
      {
        'id': product.id,
        'name': product.name, // Gerçek senaryoda bu isim bir ürün API'sinden de gelebilir
        'barcode': product.barcode,
        'count': product.count,
        'sktDate': product.sktDate.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Tüm ürünleri getirme (SKT'si en yakın olan en üstte olacak şekilde)
  Future<List<ProductModel>> getAllProducts() async {
    final db = await instance.database;
    // orderBy ile tarihleri küçükten büyüğe (yakından uzağa) sıralıyoruz
    final result = await db.query('products', orderBy: 'sktDate ASC'); 

    return result.map((json) => ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String,
      count: json['count'] as int,
      sktDate: DateTime.parse(json['sktDate'] as String),
    )).toList();
  }
  
  // Okutulan bir ürünü yanlışlıkla ekleme ihtimaline karşı silme fonksiyonu
  Future<void> deleteProduct(String id) async {
    final db = await instance.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
