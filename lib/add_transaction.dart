import 'package:flutter/material.dart';
import 'edit_transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState
    extends State<AddTransactionScreen> {
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
  // NÚT CHI TIÊU / THU NHẬP
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
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : const Color(0xFF172033),
            ),
          ),
        ),
      ),
    );
  }

  // =========================
  // Ô DANH MỤC
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
  // Ô NHẬP SỐ TIỀN
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
          hintStyle: TextStyle(
            color: Color(0xFFB8BDC7),
          ),
          suffixText: 'đ',
          suffixStyle: TextStyle(
            color: Color(0xFF687386),
            fontSize: 16,
          ),
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
  // Ô NGÀY
  // =========================
  Widget dateField() {
    return GestureDetector(
      onTap: selectDate,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
  // Ô GHI CHÚ
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
          hintStyle: TextStyle(
            color: Color(0xFFB8BDC7),
          ),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditTransactionScreen(),
            ),
          );
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
          'Thêm giao dịch',
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