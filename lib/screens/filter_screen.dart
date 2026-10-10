
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const Color primaryColor = Color(0xFF2878F0);
  static const Color textColor = Color(0xFF172033);
  static const Color secondaryColor = Color(0xFF687386);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  String selectedType = 'Tất cả';
  String selectedCategory = 'Tất cả';

  DateTime? startDate;
  DateTime? endDate;

  List<TransactionModel> allTransactions = [];
  List<TransactionModel> filteredTransactions = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  // Đọc giao dịch từ SQLite
  Future<void> loadTransactions() async {
    try {
      final data = await DatabaseHelper.instance.getTransactions();

      if (!mounted) return;

      setState(() {
        allTransactions = data;
        isLoading = false;
        applyFilters();
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải giao dịch: $e')),
      );
    }
  }

  // Chuyển ngày dd/MM/yyyy thành DateTime
  DateTime? parseDate(String value) {
    try {
      final parts = value.split('/');
      if (parts.length != 3) return null;

      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  // Áp dụng các điều kiện lọc
  void applyFilters() {
    filteredTransactions = allTransactions.where((transaction) {
      final matchesType = selectedType == 'Tất cả' ||
          transaction.type == selectedType;

      final matchesCategory = selectedCategory == 'Tất cả' ||
          transaction.category == selectedCategory;

      final transactionDate = parseDate(transaction.date);

      bool matchesDate = true;

      if (startDate != null || endDate != null) {
        if (transactionDate == null) {
          matchesDate = false;
        } else {
          if (startDate != null) {
            final start = DateTime(
              startDate!.year,
              startDate!.month,
              startDate!.day,
            );

            if (transactionDate.isBefore(start)) {
              matchesDate = false;
            }
          }

          if (endDate != null) {
            final end = DateTime(
              endDate!.year,
              endDate!.month,
              endDate!.day,
            );

            if (transactionDate.isAfter(end)) {
              matchesDate = false;
            }
          }
        }
      }

      return matchesType && matchesCategory && matchesDate;
    }).toList();

    // Giao dịch mới nhất hiển thị trước
    filteredTransactions.sort((a, b) {
      final dateA = parseDate(a.date);
      final dateB = parseDate(b.date);

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateB.compareTo(dateA);
    });
  }

  // Chọn ngày bắt đầu hoặc ngày kết thúc
  Future<void> selectDate({required bool isStart}) async {
    final initialDate = isStart
        ? (startDate ?? endDate ?? DateTime.now())
        : (endDate ?? startDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: isStart ? 'Chọn ngày bắt đầu' : 'Chọn ngày kết thúc',
      cancelText: 'Hủy',
      confirmText: 'Xác nhận',
    );

    if (picked == null || !mounted) return;

    setState(() {
      if (isStart) {
        startDate = picked;

        if (endDate != null && endDate!.isBefore(picked)) {
          endDate = null;
        }
      } else {
        endDate = picked;

        if (startDate != null && picked.isBefore(startDate!)) {
          startDate = null;
        }
      }

      applyFilters();
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Chọn ngày';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    )} đ';
  }

  // Tổng tiền theo kết quả lọc
  double get filteredTotal {
    return filteredTransactions.fold(
      0,
          (sum, transaction) => sum + transaction.amount,
    );
  }

  // Các danh mục lấy từ dữ liệu thực tế
  List<String> get categories {
    final values = allTransactions
        .map((transaction) => transaction.category)
        .toSet()
        .toList()
      ..sort();

    return ['Tất cả', ...values];
  }

  // Xóa tất cả điều kiện lọc
  void resetFilters() {
    setState(() {
      selectedType = 'Tất cả';
      selectedCategory = 'Tất cả';
      startDate = null;
      endDate = null;
      applyFilters();
    });
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget typeButton(String title) {
    final isSelected = selectedType == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedType = title;
            applyFilters();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : const Color(0xFFE2E5EA),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget dateButton({
    required String title,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E5EA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: secondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    color: primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      formatDate(date),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget transactionCard(TransactionModel transaction) {
    final isIncome = transaction.type == 'Thu nhập';

    final icon = transaction.category == 'Ăn uống'
        ? Icons.restaurant
        : transaction.category == 'Di chuyển'
        ? Icons.directions_car
        : transaction.category == 'Mua sắm'
        ? Icons.shopping_bag
        : transaction.category == 'Giáo dục'
        ? Icons.school
        : Icons.receipt_long;

    final color = isIncome
        ? const Color(0xFF35A853)
        : const Color(0xFFFF5A5F);

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note.isEmpty
                      ? transaction.category
                      : transaction.note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${transaction.category} • ${transaction.date}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${isIncome ? '+' : '-'}${formatMoney(transaction.amount)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lọc giao dịch',
          style: TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: resetFilters,
            child: const Text(
              'Đặt lại',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
                children: [
                  // LOẠI GIAO DỊCH
                  sectionTitle('Loại giao dịch'),
                  Row(
                    children: [
                      typeButton('Tất cả'),
                      const SizedBox(width: 8),
                      typeButton('Chi tiêu'),
                      const SizedBox(width: 8),
                      typeButton('Thu nhập'),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // DANH MỤC
                  sectionTitle('Danh mục'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFE2E5EA),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: const TextStyle(fontSize: 13),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            selectedCategory = value;
                            applyFilters();
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // KHOẢNG NGÀY
                  sectionTitle('Khoảng thời gian'),
                  Row(
                    children: [
                      dateButton(
                        title: 'Từ ngày',
                        date: startDate,
                        onTap: () => selectDate(isStart: true),
                      ),
                      const SizedBox(width: 10),
                      dateButton(
                        title: 'Đến ngày',
                        date: endDate,
                        onTap: () => selectDate(isStart: false),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // KẾT QUẢ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kết quả lọc',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '${filteredTransactions.length} giao dịch',
                        style: const TextStyle(
                          fontSize: 12,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tổng số tiền',
                          style: TextStyle(
                            fontSize: 13,
                            color: secondaryColor,
                          ),
                        ),
                        Text(
                          formatMoney(filteredTotal),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  if (filteredTransactions.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                      ),
                      alignment: Alignment.center,
                      child: const Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: Color(0xFFB8BDC7),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Không tìm thấy giao dịch',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Thử thay đổi điều kiện lọc nhé.',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...filteredTransactions.map(transactionCard),
                ],
              ),
            ),

            // NÚT ÁP DỤNG
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFEDEFF3)),
                ),
              ),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      List<TransactionModel>.from(
                        filteredTransactions,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Áp dụng bộ lọc',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
