import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction_model.dart';

class DatabaseHelper {
  // Singleton
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
  DatabaseHelper._privateConstructor();

  static Database? _database;

  // ==============================
  // LẤY DATABASE
  // ==============================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  // ==============================
  // KHỞI TẠO DATABASE
  // ==============================

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'expense_manager.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // ==============================
  // TẠO BẢNG
  // ==============================

  Future<void> _onCreate(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');
  }

  // ==============================
  // THÊM GIAO DỊCH
  // ==============================

  Future<int> insertTransaction(
      TransactionModel transaction,
      ) async {
    final db = await database;

    return await db.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  // ==============================
  // LẤY TẤT CẢ GIAO DỊCH
  // ==============================

  Future<List<TransactionModel>> getTransactions() async {
    final db = await database;

    final result = await db.query(
      'transactions',
      orderBy: 'id DESC',
    );

    return result
        .map(
          (map) => TransactionModel.fromMap(map),
    )
        .toList();
  }

  // ==============================
  // LẤY 1 GIAO DỊCH
  // ==============================

  Future<TransactionModel?> getTransactionById(
      int id,
      ) async {
    final db = await database;

    final result = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return TransactionModel.fromMap(
      result.first,
    );
  }

  // ==============================
  // CẬP NHẬT GIAO DỊCH
  // ==============================

  Future<int> updateTransaction(
      TransactionModel transaction,
      ) async {
    final db = await database;

    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // ==============================
  // XÓA GIAO DỊCH
  // ==============================

  Future<int> deleteTransaction(
      int id,
      ) async {
    final db = await database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==============================
  // XÓA TOÀN BỘ DATABASE
  // DÙNG KHI TEST
  // ==============================

  Future<void> clearTransactions() async {
    final db = await database;

    await db.delete('transactions');
  }
}