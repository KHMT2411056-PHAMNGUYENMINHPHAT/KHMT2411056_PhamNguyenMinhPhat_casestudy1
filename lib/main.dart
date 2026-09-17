import 'package:flutter/material.dart';

void main() {
  runApp(const ExpenseManagerApp());
}

class ExpenseManagerApp extends StatelessWidget {
  const ExpenseManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Manager',
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
          child: Column(
            children: [
              // Nội dung chính
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      const WalletLogo(),

                      const SizedBox(height: 42),

                      // Tiêu đề
                      const Text(
                        'Expense Manager',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF202124),
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Mô tả
                      const Text(
                        'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Color(0xFFB7B7B7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Nút Bắt đầu
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    // Sau này có thể chuyển sang màn hình chính
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================
// LOGO VÍ TIỀN
// ===============================

class WalletLogo extends StatelessWidget {
  const WalletLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phần tiền màu xanh lá phía sau
          Positioned(
            top: 8,
            child: Container(
              width: 92,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF7BC67B),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // Tờ tiền màu xanh lá bên trái
          Positioned(
            top: 28,
            left: 25,
            child: Container(
              width: 105,
              height: 35,
              decoration: BoxDecoration(
                color: const Color(0xFF65BE65),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),

          // Ví màu xanh dương
          Positioned(
            bottom: 8,
            child: Container(
              width: 155,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),

          // Phần nắp ví
          Positioned(
            right: 8,
            bottom: 21,
            child: Container(
              width: 55,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFF0757B7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}