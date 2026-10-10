import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../edit_transaction.dart';
import 'filter_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  static const Color primaryColor = Color(0xFF2878F0);
  static const Color textColor = Color(0xFF172033);
  static const Color secondaryColor = Color(0xFF687386);
  static const Color backgroundColor = Color(0xFFF5F7FB);

  final TextEditingController searchController = TextEditingController();
  List<TransactionModel> allTransactions = [];
  List<TransactionModel> visibleTransactions = [];
  String selectedType = 'Tất cả';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadTransactions() async {
    try {
      final data = await DatabaseHelper.instance.getTransactions();
      if (!mounted) return;
      setState(() {
        allTransactions = data;
        isLoading = false;
        applyLocalFilters();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải giao dịch: $e')),
      );
    }
  }

  DateTime? parseDate(String value) {
    try {
      final parts = value.split('/');
      if (parts.length != 3) return null;
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
    }
  }

  void applyLocalFilters() {
    final query = searchController.text.trim().toLowerCase();
    visibleTransactions = allTransactions.where((t) {
      final matchesType = selectedType == 'Tất cả' || t.type == selectedType;
      final searchable = '${t.note} ${t.category} ${t.date} ${t.type}'.toLowerCase();
      return matchesType && searchable.contains(query);
    }).toList();

    visibleTransactions.sort((a, b) {
      final da = parseDate(a.date);
      final db = parseDate(b.date);
      if (da == null && db == null) return 0;
      if (da == null) return 1;
      if (db == null) return -1;
      return db.compareTo(da);
    });
  }

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    )} đ';
  }

  Future<void> openFilter() async {
    final result = await Navigator.push<List<TransactionModel>>(
      context,
      MaterialPageRoute(builder: (_) => const FilterScreen()),
    );
    if (!mounted || result == null) return;
    setState(() {
      visibleTransactions = result;
      selectedType = 'Tất cả';
      searchController.clear();
    });
  }

  IconData categoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Mua sắm':
        return Icons.shopping_cart;
      case 'Di chuyển':
        return Icons.directions_car;
      case 'Giáo dục':
      case 'Học tập':
        return Icons.school;
      default:
        return Icons.receipt_long;
    }
  }

  Widget typeChip(String type) {
    final selected = selectedType == type;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedType = type;
              applyLocalFilters();
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? primaryColor : const Color(0xFFE2E5EA),
              ),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : textColor,
              ),
            ),
          ),
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Giao dịch',
          style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Lọc giao dịch',
            onPressed: openFilter,
            icon: const Icon(Icons.filter_alt_outlined, color: textColor),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(applyLocalFilters),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm giao dịch...',
                  prefixIcon: const Icon(Icons.search, size: 21),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  typeChip('Tất cả'),
                  typeChip('Thu nhập'),
                  typeChip('Chi tiêu'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : visibleTransactions.isEmpty
                  ? const Center(
                child: Text(
                  'Chưa có giao dịch phù hợp',
                  style: TextStyle(color: secondaryColor),
                ),
              )
                  : RefreshIndicator(
                onRefresh: loadTransactions,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  itemCount: visibleTransactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final t = visibleTransactions[index];
                    final isIncome = t.type == 'Thu nhập';
                    final color = isIncome
                        ? const Color(0xFF35A853)
                        : const Color(0xFFFF5A5F);
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditTransactionScreen(transaction: t),
                            ),
                          );
                          if (result == true) loadTransactions();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: color.withValues(alpha: 0.12),
                                child: Icon(categoryIcon(t.category), color: color),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.note.isEmpty ? t.category : t.note,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${t.category} • ${t.date}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, color: secondaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${isIncome ? '+' : '-'}${formatMoney(t.amount)}',
                                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
