
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String selectedPeriod = 'Tháng này';

  List<Map<String, dynamic>> expenses = [];
  bool isLoading = true;

  double get totalExpense {
    return expenses.fold<double>(
      0,
          (sum, item) => sum + (item['amount'] as double),
    );
  }

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  // Đọc dữ liệu và tính thống kê từ SQLite
  Future<void> loadStatistics() async {
    setState(() {
      isLoading = true;
    });

    try {
      final transactions =
      await DatabaseHelper.instance.getTransactions();

      final now = DateTime.now();
      final Map<String, double> categoryTotals = {};

      for (final transaction in transactions) {
        // Chỉ thống kê giao dịch chi tiêu
        if (transaction.type != 'Chi tiêu') {
          continue;
        }

        // Ngày được lưu theo định dạng dd/MM/yyyy
        final parts = transaction.date.split('/');

        if (parts.length != 3) {
          continue;
        }

        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (day == null || month == null || year == null) {
          continue;
        }

        final transactionDate = DateTime(year, month, day);

        // Lọc theo thời gian đang chọn
        bool matchesPeriod = false;

        if (selectedPeriod == 'Tháng này') {
          matchesPeriod = transactionDate.year == now.year &&
              transactionDate.month == now.month;
        } else if (selectedPeriod == 'Tháng trước') {
          final previousMonth =
          DateTime(now.year, now.month - 1, 1);

          matchesPeriod =
              transactionDate.year == previousMonth.year &&
                  transactionDate.month == previousMonth.month;
        } else if (selectedPeriod == 'Năm nay') {
          matchesPeriod = transactionDate.year == now.year;
        }

        if (!matchesPeriod) {
          continue;
        }

        categoryTotals[transaction.category] =
            (categoryTotals[transaction.category] ?? 0) +
                transaction.amount;
      }

      final result = categoryTotals.entries.map((entry) {
        return {
          'category': entry.key,
          'amount': entry.value,
          'color': categoryColor(entry.key),
          'icon': categoryIcon(entry.key),
        };
      }).toList();

      result.sort(
            (a, b) => (b['amount'] as double)
            .compareTo(a['amount'] as double),
      );

      if (!mounted) return;

      setState(() {
        expenses = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không tải được thống kê: $e'),
        ),
      );
    }
  }

  Color categoryColor(String category) {
    switch (category) {
      case 'Ăn uống':
        return const Color(0xFFFF5A65);
      case 'Mua sắm':
        return const Color(0xFF9C4DFF);
      case 'Di chuyển':
        return const Color(0xFF35A853);
      case 'Giáo dục':
      case 'Học tập':
        return const Color(0xFF4285F4);
      default:
        return const Color(0xFFFFA726);
    }
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
        return Icons.category;
    }
  }

  String formatMoney(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
    )} đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          'Thống kê',
          style: TextStyle(
            color: Color(0xFF202124),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BỘ CHỌN THỜI GIAN
              Row(
                children: [
                  periodButton('Tháng này'),
                  const SizedBox(width: 8),
                  periodButton('Tháng trước'),
                  const SizedBox(width: 8),
                  periodButton('Năm nay'),
                ],
              ),

              const SizedBox(height: 24),

              // BIỂU ĐỒ VÀ CHI TIẾT
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: isLoading
                    ? const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : Column(
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 220,
                            height: 220,
                            child: CustomPaint(
                              painter: ExpenseChartPainter(
                                expenses: expenses,
                                total: totalExpense,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                formatMoney(totalExpense),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF202124),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Tổng chi tiêu',
                                style: TextStyle(
                                  color: Color(0xFF8A8F98),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 8),

                    if (expenses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Text(
                          'Chưa có dữ liệu chi tiêu '
                              'trong khoảng thời gian này.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8A8F98),
                            fontSize: 13,
                          ),
                        ),
                      )
                    else
                      ...expenses.map((item) {
                        final amount =
                        item['amount'] as double;

                        final percent = totalExpense == 0
                            ? 0.0
                            : amount / totalExpense * 100;

                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  item['category'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                formatMoney(amount),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 42,
                                child: Text(
                                  '${percent.toStringAsFixed(1)}%',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Color(0xFF8A8F98),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget periodButton(String label) {
    final isSelected = selectedPeriod == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (selectedPeriod == label) return;

          setState(() {
            selectedPeriod = label;
          });

          loadStatistics();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2878F0)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF555B66),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class ExpenseChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> expenses;
  final double total;

  ExpenseChartPainter({
    required this.expenses,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 28.0;
    final radius = size.width / 2 - strokeWidth / 2;

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    // Vẽ nền xám khi chưa có giao dịch
    if (total <= 0) {
      final backgroundPaint = Paint()
        ..color = const Color(0xFFEDEFF3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawCircle(center, radius, backgroundPaint);
      return;
    }

    double startAngle = -1.57079632679;

    for (final item in expenses) {
      final amount = item['amount'] as double;

      if (amount <= 0) continue;

      final sweepAngle = amount / total * 6.28318530718;

      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(
      covariant ExpenseChartPainter oldDelegate,
      ) {
    return oldDelegate.total != total ||
        oldDelegate.expenses != expenses;
  }
}
