import 'package:flutter/material.dart';
import 'add_transaction.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,

        leading: const Icon(
          Icons.menu,
          color: Color(0xFF202124),
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
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            20,
          ),
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
                  Expanded(
                    child: incomeCard(),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: expenseCard(),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // =====================
              // GIAO DỊCH GẦN ĐÂY
              // =====================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
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
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // =====================
              // DANH SÁCH GIAO DỊCH
              // =====================

              transactionItem(
                icon: Icons.restaurant,
                iconColor: const Color(0xFFFF7A22),
                title: 'Ăn trưa',
                category: 'Ăn uống',
                date: '03/09/2024',
                amount: '-50.000 đ',
                amountColor: const Color(0xFFFF4D5A),
              ),

              transactionItem(
                icon: Icons.directions_car,
                iconColor: const Color(0xFF2196F3),
                title: 'Xăng xe',
                category: 'Di chuyển',
                date: '03/09/2024',
                amount: '-100.000 đ',
                amountColor: const Color(0xFFFF4D5A),
              ),

              transactionItem(
                icon: Icons.attach_money,
                iconColor: const Color(0xFF35A853),
                title: 'Lương tháng 9',
                category: 'Thu nhập',
                date: '01/09/2024',
                amount: '+8.000.000 đ',
                amountColor: const Color(0xFF35A853),
              ),

              transactionItem(
                icon: Icons.shopping_cart,
                iconColor: const Color(0xFF9C4DFF),
                title: 'Mua sắm',
                category: 'Mua sắm',
                date: '31/08/2024',
                amount: '-300.000 đ',
                amountColor: const Color(0xFFFF4D5A),
              ),

              transactionItem(
                icon: Icons.school,
                iconColor: const Color(0xFF009688),
                title: 'Học phí',
                category: 'Giáo dục',
                date: '30/08/2024',
                amount: '-500.000 đ',
                amountColor: const Color(0xFFFF4D5A),
              ),
            ],
          ),
        ),
      ),

      // =========================
      // NÚT +
      // =========================

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF2878F0),
        elevation: 4,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

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
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Thống kê',
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
          colors: [
            Color(0xFF4285F4),
            Color(0xFF1465D8),
          ],
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
            padding: const EdgeInsets.only(
              left: 20,
              top: 18,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(
                  children: const [
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

                const Text(
                  '5.000.000 đ',
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
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.circle,
                  size: 4,
                  color: Colors.white54,
                ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.circle,
                  size: 4,
                  color: Colors.white54,
                ),
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

      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),

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
            mainAxisAlignment:
            MainAxisAlignment.center,

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: const [
              Text(
                'TỔNG THU NHẬP',
                style: TextStyle(
                  fontSize: 8,
                  color: Color(0xFF666666),
                ),
              ),

              SizedBox(height: 2),

              Text(
                '8.000.000 đ',
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

      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),

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
            mainAxisAlignment:
            MainAxisAlignment.center,

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: const [
              Text(
                'TỔNG CHI TIÊU',
                style: TextStyle(
                  fontSize: 8,
                  color: Color(0xFF666666),
                ),
              ),

              SizedBox(height: 2),

              Text(
                '3.000.000 đ',
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
  // ITEM GIAO DỊCH
  // =====================================================

  Widget transactionItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String category,
    required String date,
    required String amount,
    required Color amountColor,
  }) {
    return Container(
      height: 64,

      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEDEDED),
          ),
        ),
      ),

      child: Row(
        children: [

          // ICON
          Container(
            width: 36,
            height: 36,

            margin: const EdgeInsets.only(
              left: 8,
              right: 10,
            ),

            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),

            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          // TÊN + DANH MỤC + NGÀY
          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  title,
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
            padding: const EdgeInsets.only(
              right: 8,
            ),

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
    );
  }
}