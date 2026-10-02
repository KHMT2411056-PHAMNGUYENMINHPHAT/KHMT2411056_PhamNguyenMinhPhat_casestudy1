import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/transaction_model.dart';

class EditTransactionScreen extends StatefulWidget {
  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {
  bool isExpense = true;

  String selectedCategory = 'Ăn uống';

  DateTime selectedDate = DateTime(2025, 4, 12);

  final TextEditingController amountController =
  TextEditingController();

  final TextEditingController noteController =
  TextEditingController();

  final Color redColor = const Color(0xFFFF5A5F);
  final Color blueColor = const Color(0xFF0D6EFD);

  @override
  void initState() {
    super.initState();

    // Lấy dữ liệu giao dịch được truyền vào
    isExpense = widget.transaction.type == 'Chi tiêu';

    selectedCategory = widget.transaction.category;

    amountController.text =
        widget.transaction.amount.toStringAsFixed(0);

    noteController.text =
        widget.transaction.note;

    // Chuyển ngày từ dd/MM/yyyy sang DateTime
    final parts = widget.transaction.date.split('/');

    if (parts.length == 3) {
      selectedDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  // =========================
  // CHỌN NGÀY
  // =========================

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // =========================
  // ĐỊNH DẠNG NGÀY
  // =========================

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // =========================
  // TIÊU ĐỀ
  // =========================

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF172033),
        ),
      ),
    );
  }

  // =========================
  // CHI TIÊU / THU NHẬP
  // =========================

  Widget transactionTypeButton(
      String title,
      bool active,
      VoidCallback onTap,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: active ? redColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: active
                  ? redColor
                  : const Color(0xFFE2E5EA),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: active
                  ? Colors.white
                  : const Color(0xFF172033),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // DANH MỤC
  // =========================

  Widget categoryDropdown() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 14),
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
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Color(0xFF687386),
          ),
          items: const [
            DropdownMenuItem(
              value: 'Ăn uống',
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFFFE5E7),
                    child: Icon(
                      Icons.restaurant,
                      color: Color(0xFFFF5A5F),
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('Ăn uống'),
                ],
              ),
            ),

            DropdownMenuItem(
              value: 'Di chuyển',
              child: Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    color: Color(0xFFFF5A5F),
                  ),
                  SizedBox(width: 10),
                  Text('Di chuyển'),
                ],
              ),
            ),

            DropdownMenuItem(
              value: 'Mua sắm',
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    color: Color(0xFFFF5A5F),
                  ),
                  SizedBox(width: 10),
                  Text('Mua sắm'),
                ],
              ),
            ),

            DropdownMenuItem(
              value: 'Giáo dục',
              child: Row(
                children: [
                  Icon(
                    Icons.school,
                    color: Color(0xFFFF5A5F),
                  ),
                  SizedBox(width: 10),
                  Text('Giáo dục'),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCategory = value;
              });
            }
          },
        ),
      ),
    );
  }

  // =========================
  // SỐ TIỀN
  // =========================

  Widget amountField() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E5EA),
        ),
      ),
      child: TextField(
        controller: amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Nhập số tiền',
          suffixText: 'đ',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  // =========================
  // NGÀY GIAO DỊCH
  // =========================

  Widget dateField() {
    return GestureDetector(
      onTap: selectDate,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE2E5EA),
          ),
        ),
        child: Row(
          children: [
            Text(
              formatDate(selectedDate),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF172033),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.calendar_today_outlined,
              size: 21,
              color: Color(0xFF687386),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // GHI CHÚ
  // =========================

  Widget noteField() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE2E5EA),
        ),
      ),
      child: TextField(
        controller: noteController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Nhập ghi chú (tùy chọn)',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  // =========================
  // NÚT LƯU
  // =========================

  Widget saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () async {
          // Kiểm tra số tiền
          if (amountController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vui lòng nhập số tiền'),
              ),
            );
            return;
          }

          final amount = double.tryParse(
            amountController.text
                .replaceAll('.', '')
                .replaceAll(',', ''),
          );

          if (amount == null || amount <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Số tiền không hợp lệ'),
              ),
            );
            return;
          }

          // Tạo giao dịch mới với ID cũ
          final updatedTransaction =
          widget.transaction.copyWith(
            type: isExpense ? 'Chi tiêu' : 'Thu nhập',
            category: selectedCategory,
            amount: amount,
            date: formatDate(selectedDate),
            note: noteController.text.trim(),
          );

          // Cập nhật SQLite
          await DatabaseHelper.instance.updateTransaction(
            updatedTransaction,
          );

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Đã cập nhật giao dịch thành công',
              ),
            ),
          );

          // Quay lại Dashboard
          Navigator.pop(context, true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: blueColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Lưu',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =========================
  // GIAO DIỆN
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: const BackButton(
          color: Color(0xFF172033),
        ),

        centerTitle: true,

        title: const Text(
          'Sửa giao dịch',
          style: TextStyle(
            color: Color(0xFF172033),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // CHI TIÊU / THU NHẬP
              Row(
                children: [
                  transactionTypeButton(
                    'Chi tiêu',
                    isExpense,
                        () {
                      setState(() {
                        isExpense = true;
                      });
                    },
                  ),

                  const SizedBox(width: 10),

                  transactionTypeButton(
                    'Thu nhập',
                    !isExpense,
                        () {
                      setState(() {
                        isExpense = false;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // DANH MỤC
              sectionTitle('Danh mục'),

              const SizedBox(height: 9),

              categoryDropdown(),

              const SizedBox(height: 22),

              // SỐ TIỀN
              sectionTitle('Số tiền'),

              const SizedBox(height: 9),

              amountField(),

              const SizedBox(height: 22),

              // NGÀY
              sectionTitle('Ngày giao dịch'),

              const SizedBox(height: 9),

              dateField(),

              const SizedBox(height: 22),

              // GHI CHÚ
              sectionTitle('Ghi chú'),

              const SizedBox(height: 9),

              noteField(),

              const SizedBox(height: 30),

              // LƯU
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }
}