class TransactionModel {
  final int? id;
  final String type;
  final String category;
  final double amount;
  final String date;
  final String note;

  TransactionModel({
    this.id,
    required this.type,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });

  // Chuyển Object → Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'amount': amount,
      'date': date,
      'note': note,
    };
  }

  // Chuyển dữ liệu từ SQLite → Object
  factory TransactionModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return TransactionModel(
      id: map['id'] as int?,
      type: map['type'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      note: map['note'] as String,
    );
  }

  // Tạo bản sao khi cần chỉnh sửa
  TransactionModel copyWith({
    int? id,
    String? type,
    String? category,
    double? amount,
    String? date,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}