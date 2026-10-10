import 'package:flutter/material.dart';

import 'add_transaction.dart';

import 'edit_transaction.dart';

import 'database/database_helper.dart';

import 'models/transaction_model.dart';

import 'screens/statistics_screen.dart';

import 'screens/profile_screen.dart';

import 'screens/filter_screen.dart';
import 'screens/transactions_screen.dart';

import 'screens/filter_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> transactions = [];

  double totalIncome = 0;

  double totalExpense = 0;

  double balance = 0;

  @override
  void initState() {
    super.initState();

    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();

    double income = 0;

    double expense = 0;

    for (final transaction in data) {
      if (transaction.type == 'Thu nhập') {
        income += transaction.amount;
      } else if (transaction.type == 'Chi tiêu') {
        expense += transaction.amount;
      }
    }

    if (!mounted) return;

    setState(() {
      transactions = data;

      totalIncome = income;

      totalExpense = expense;

      balance = income - expense;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =========================

      // APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),

        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF202124)),
          tooltip: 'Hồ sơ cá nhân',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
        ),

        title: const Text(
          'Quản lý thu chi',

          style: TextStyle(
            color: Color(0xFF202124),

            fontSize: 18,

            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),

            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_none,

                  size: 27,

                  color: Color(0xFF202124),
                ),

                Positioned(
                  right: 0,

                  top: 0,

                  child: Container(
                    width: 15,

                    height: 15,

                    alignment: Alignment.center,

                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4D5A),

                      shape: BoxShape.circle,
                    ),

                    child: const Text(
                      '3',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 9,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // =========================

      // BODY

      // =========================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =====================

              // THẺ SỐ DƯ

              // =====================
              balanceCard(),

              const SizedBox(height: 12),

              // =====================

              // THU NHẬP / CHI TIÊU

              // =====================
              Row(
                children: [
                  Expanded(child: incomeCard()),

                  const SizedBox(width: 10),

                  Expanded(child: expenseCard()),
                ],
              ),

              const SizedBox(height: 18),

              // =====================

              // GIAO DỊCH GẦN ĐÂY

              // =====================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Giao dịch gần đây',

                    style: TextStyle(
                      fontSize: 16,

                      fontWeight: FontWeight.bold,

                      color: Color(0xFF202124),
                    ),
                  ),

                  TextButton(
                    onPressed: () {},

                    child: const Text(
                      'Xem tất cả',

                      style: TextStyle(color: Color(0xFF1976D2), fontSize: 12),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // =====================

              // DANH SÁCH GIAO DỊCH

              // =====================
              ...transactions.map((transaction) {
                IconData icon = Icons.receipt_long;

                Color iconColor = const Color(0xFF2878F0);

                if (transaction.category == 'Ăn uống') {
                  icon = Icons.restaurant;

                  iconColor = const Color(0xFFFF7A22);
                } else if (transaction.category == 'Di chuyển') {
                  icon = Icons.directions_car;

                  iconColor = const Color(0xFF2196F3);
                } else if (transaction.category == 'Mua sắm') {
                  icon = Icons.shopping_cart;

                  iconColor = const Color(0xFF9C4DFF);
                } else if (transaction.category == 'Giáo dục') {
                  icon = Icons.school;

                  iconColor = const Color(0xFF009688);
                } else if (transaction.category == 'Thu nhập') {
                  icon = Icons.attach_money;

                  iconColor = const Color(0xFF35A853);
                }

                final isIncome = transaction.type == 'Thu nhập';

                return transactionItem(
                  transaction: transaction,

                  icon: icon,

                  iconColor: iconColor,

                  title: transaction.note.isEmpty
                      ? transaction.category
                      : transaction.note,

                  category: transaction.category,

                  date: transaction.date,

                  amount:
                  '${isIncome ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} đ',

                  amountColor: isIncome
                      ? const Color(0xFF35A853)
                      : const Color(0xFFFF4D5A),
                );
              }).toList(),
            ],
          ),
        ),
      ),

      // =========================

      // NÚT +

      // =========================
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );

          if (result == true) {
            loadTransactions();
          }
        },

        backgroundColor: const Color(0xFF2878F0),

        elevation: 4,

        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // =========================

      // BOTTOM NAVIGATION

      // =========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2878F0),
        unselectedItemColor: const Color(0xFF6E7480),
        selectedFontSize: 11,
        unselectedFontSize: 10,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TransactionsScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StatisticsScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }

  // =====================================================

  // THẺ SỐ DƯ

  // =====================================================

  Widget balanceCard() {
    return Container(
      width: double.infinity,

      height: 118,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),

        gradient: const LinearGradient(
          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: [Color(0xFF4285F4), Color(0xFF1465D8)],
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.18),

            blurRadius: 8,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Stack(
        children: [
          // Nội dung số dư

          Padding(
            padding: const EdgeInsets.only(left: 20, top: 18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Text(
                      'SỐ DƯ HIỆN TẠI',

                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 10,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 6),

                    Icon(
                      Icons.visibility_outlined,

                      color: Colors.white,

                      size: 15,
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  '${balance.toStringAsFixed(0)} đ',

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 27,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Hình ví minh họa
          Positioned(
            right: 14,

            top: 18,

            child: Icon(
              Icons.account_balance_wallet,

              size: 58,

              color: Colors.white.withOpacity(0.85),
            ),
          ),

          // Dấu chấm slide
          Positioned(
            bottom: 8,

            left: 0,

            right: 0,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Container(
                  width: 8,

                  height: 4,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(width: 4),

                const Icon(Icons.circle, size: 4, color: Colors.white54),

                const SizedBox(width: 4),

                const Icon(Icons.circle, size: 4, color: Colors.white54),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================

  // THẺ THU NHẬP

  // =====================================================

  Widget incomeCard() {
    return Container(
      height: 58,

      padding: const EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EC),

        borderRadius: BorderRadius.circular(9),
      ),

      child: Row(
        children: [
          Container(
            width: 28,

            height: 28,

            decoration: const BoxDecoration(
              color: Color(0xFF5DBB63),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.arrow_downward,

              color: Colors.white,

              size: 18,
            ),
          ),

          const SizedBox(width: 7),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'TỔNG THU NHẬP',

                style: TextStyle(fontSize: 8, color: Color(0xFF666666)),
              ),

              SizedBox(height: 2),

              Text(
                '${totalIncome.toStringAsFixed(0)} đ',

                style: TextStyle(
                  fontSize: 11,

                  fontWeight: FontWeight.bold,

                  color: Color(0xFF35A853),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================

  // THẺ CHI TIÊU

  // =====================================================

  Widget expenseCard() {
    return Container(
      height: 58,

      padding: const EdgeInsets.symmetric(horizontal: 8),

      decoration: BoxDecoration(
        color: const Color(0xFFFFEDEF),

        borderRadius: BorderRadius.circular(9),
      ),

      child: Row(
        children: [
          Container(
            width: 28,

            height: 28,

            decoration: const BoxDecoration(
              color: Color(0xFFFF5A65),

              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.arrow_upward,

              color: Colors.white,

              size: 18,
            ),
          ),

          const SizedBox(width: 7),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'TỔNG CHI TIÊU',

                style: TextStyle(fontSize: 8, color: Color(0xFF666666)),
              ),

              SizedBox(height: 2),

              Text(
                '${totalExpense.toStringAsFixed(0)} đ',

                style: TextStyle(
                  fontSize: 11,

                  fontWeight: FontWeight.bold,

                  color: Color(0xFFFF4D5A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================

  // =====================================================

  // ITEM GIAO DỊCH

  // =====================================================

  Widget transactionItem({
    required TransactionModel transaction,

    required IconData icon,

    required Color iconColor,

    required String title,

    required String category,

    required String date,

    required String amount,

    required Color amountColor,
  }) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,

          MaterialPageRoute(
            builder: (context) =>
                EditTransactionScreen(transaction: transaction),
          ),
        );

        if (result == true) {
          loadTransactions();
        }
      },

      child: Container(
        height: 64,

        decoration: const BoxDecoration(
          color: Colors.white,

          border: Border(bottom: BorderSide(color: Color(0xFFEDEDED))),
        ),

        child: Row(
          children: [
            // ICON

            Container(
              width: 36,

              height: 36,

              margin: const EdgeInsets.only(left: 8, right: 10),

              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),

                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: iconColor, size: 20),
            ),

            // TÊN + DANH MỤC + NGÀY
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 12,

                      fontWeight: FontWeight.bold,

                      color: Color(0xFF202124),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Row(
                    children: [
                      Text(
                        category,

                        style: const TextStyle(
                          fontSize: 9,

                          color: Color(0xFF8A8F98),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        date,

                        style: const TextStyle(
                          fontSize: 9,

                          color: Color(0xFF8A8F98),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // SỐ TIỀN
            Padding(
              padding: const EdgeInsets.only(right: 8),

              child: Text(
                amount,

                style: TextStyle(
                  fontSize: 11,

                  fontWeight: FontWeight.bold,

                  color: amountColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
