import 'dart:io';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';

class InvoicePaymentPage extends StatefulWidget {
  final int invoiceId;

  const InvoicePaymentPage(int id, {Key? key, required this.invoiceId})
    : super(key: key);

  @override
  State<InvoicePaymentPage> createState() => _InvoicePaymentPageState();
}

class _InvoicePaymentPageState extends State<InvoicePaymentPage> {
  final TextEditingController _amountController = TextEditingController(
    text: "220",
  );
  String paymentMethod = "bank_transfer";
  DateTime? paymentDate = DateTime.now();
  File? paymentProof;
  final TextEditingController _notesController = TextEditingController(
    text: "هذه دفعة مبدئية للفاتورة",
  );

  /// 📂 اختيار صورة إثبات الدفع
  Future<void> pickPaymentProof() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        paymentProof = File(result.files.single.path!);
      });
    }
  }

  /// 📅 اختيار تاريخ الدفع
  Future<void> pickPaymentDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: paymentDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => paymentDate = picked);
    }
  }

  /// 🟢 إرسال بيانات الدفع (API لاحقاً)
  void submitPayment() {
    debugPrint("✅ بيانات الدفع:");
    debugPrint("Invoice ID: ${widget.invoiceId}");
    debugPrint("Amount: ${_amountController.text}");
    debugPrint("Method: $paymentMethod");
    debugPrint("Date: $paymentDate");
    debugPrint("Proof: ${paymentProof?.path}");
    debugPrint("Notes: ${_notesController.text}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم إدخال بيانات الدفع بنجاح ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("💳 دفع الفاتورة"),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 💳 بطاقة الدفع (UI فقط)
            CreditCard(
              cardNumber: "**** **** **** 5432",
              cardExpiry: "06/25",
              cardHolderName: "فاتورة #${widget.invoiceId}",
              cvv: "123",
              bankName: "Bank Transfer",
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              showShadow: true,
            ),
            const SizedBox(height: 20),

            /// 💰 المبلغ
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "💰 المبلغ المدفوع",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 🏦 طريقة الدفع
            DropdownButtonFormField<String>(
              value: paymentMethod,
              decoration: InputDecoration(
                labelText: "🏦 طريقة الدفع",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "bank_transfer",
                  child: Text("تحويل بنكي"),
                ),
                DropdownMenuItem(value: "cash", child: Text("كاش")),
                DropdownMenuItem(value: "credit_card", child: Text("بطاقة")),
              ],
              onChanged: (val) => setState(() => paymentMethod = val!),
            ),
            const SizedBox(height: 16),

            /// 📅 تاريخ الدفع
            InkWell(
              onTap: pickPaymentDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "📅 تاريخ الدفع",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  paymentDate != null
                      ? DateFormat("yyyy-MM-dd").format(paymentDate!)
                      : "اختر التاريخ",
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// 📂 إثبات الدفع
            ElevatedButton.icon(
              onPressed: pickPaymentProof,
              icon: const Icon(Icons.upload_file),
              label: const Text("رفع إثبات الدفع"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
            ),
            if (paymentProof != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(paymentProof!, height: 150),
              ),
            ],
            const SizedBox(height: 16),

            /// 📝 ملاحظات
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "📝 ملاحظات",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// 🔘 زر الدفع
            ElevatedButton.icon(
              onPressed: submitPayment,
              icon: const Icon(Icons.check_circle),
              label: const Text("تأكيد الدفع"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 14,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Lottie.asset("assets/lottie/payment.json", height: 120),
          ],
        ),
      ),
    );
  }
}
