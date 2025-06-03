import 'package:flutter/material.dart';

class SupplierDetailsPage extends StatelessWidget {
  final Map<String, dynamic> supplierData;

  const SupplierDetailsPage({Key? key, required this.supplierData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supplier = supplierData['supplier'];
    final stats = supplierData['statistics'];

    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل المورد"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(supplier),
            const SizedBox(height: 12),
            _buildInfoCard(supplier),
            const SizedBox(height: 12),
            _buildStatsCard(stats),
            const SizedBox(height: 12),
            _buildCreditInfo(stats['credit_info']),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(Map supplier) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.teal,
              radius: 30,
              child: Icon(Icons.business, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    supplier['company_name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    supplier['is_active'] == 1 ? "نشط ✅" : "غير نشط ❌",
                    style: TextStyle(
                      color:
                          supplier['is_active'] == 1
                              ? Colors.green
                              : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map supplier) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
              Icons.person,
              "الشخص المسؤول",
              supplier['contact_person_name'],
            ),
            _buildInfoRow(Icons.phone, "الهاتف", supplier['phone']),
            _buildInfoRow(Icons.email, "البريد الإلكتروني", supplier['email']),
            _buildInfoRow(Icons.location_on, "العنوان", supplier['address']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? '—')),
        ],
      ),
    );
  }

  Widget _buildStatsCard(Map stats) {
    final orders = stats['orders'];
    final payments = stats['payments'];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "إحصائيات الطلبات والدفع",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStatRow("الطلبات", orders['total'].toString(), Colors.blue),
            _buildStatRow(
              "قيد الانتظار",
              orders['pending'].toString(),
              Colors.orange,
            ),
            _buildStatRow("مؤكدة", orders['confirmed'].toString(), Colors.teal),
            _buildStatRow(
              "مكتملة",
              orders['completed'].toString(),
              Colors.green,
            ),
            _buildStatRow("ملغية", orders['cancelled'].toString(), Colors.red),
            const Divider(height: 20),
            _buildStatRow(
              "المبالغ المدفوعة",
              payments['total_paid'].toString(),
              Colors.green,
            ),
            _buildStatRow(
              "دفعات معلقة",
              payments['pending_payments'].toString(),
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildCreditInfo(Map credit) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "معلومات الائتمان",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.credit_card,
              "الحد الائتماني",
              credit['credit_limit'],
            ),
            _buildInfoRow(
              Icons.payment,
              "طريقة الدفع",
              credit['payment_method'],
            ),
          ],
        ),
      ),
    );
  }
}
