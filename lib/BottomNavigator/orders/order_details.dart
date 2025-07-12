import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsScreen({Key? key, required this.orderData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = orderData;
    final supplier = data['supplier'] ?? {};
    final items = List<Map<String, dynamic>>.from(data['items'] ?? []);

    return Scaffold(
      backgroundColor: Color(0xFFF0FDF4), // أخضر فاتح خلفية ناعمة
      appBar: AppBar(
        title: Text('تفاصيل الطلبية'),
        backgroundColor: Colors.greenAccent[700],
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('📝 معلومات الطلب'),
            _infoCard([
              _infoRow('رقم الطلب', data['order_number']),
              _infoRow(
                'تاريخ الطلب',
                data['order_date'].toString().split('T').first,
              ),
              _statusBadge(data['status']),
            ]),

            SizedBox(height: 20),
            _buildSectionTitle('🏢 بيانات المورّد'),
            _infoCard([
              _infoRow('اسم المورّد', supplier['name'] ?? '-'),
              _infoRow('الهاتف', supplier['phone'] ?? '-'),
              _infoRow('البريد الإلكتروني', supplier['email'] ?? '-'),
            ]),

            SizedBox(height: 20),
            _buildSectionTitle('📦 الأصناف'),
            ...items.map((item) => _itemCard(item)),

            SizedBox(height: 20),
            _buildSectionTitle('💰 الإجمالي'),
            _totalAmount('${data['total_amount']} ج.م'),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.greenAccent[700],
      ),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.greenAccent[400],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color bgColor;
    String label;

    switch (status) {
      case 'pending':
        bgColor = Colors.orange.shade100;
        label = 'قيد التنفيذ';
        break;
      case 'completed':
        bgColor = Colors.green.shade200;
        label = 'مكتمل';
        break;
      case 'cancelled':
        bgColor = Colors.red.shade200;
        label = 'ملغى';
        break;
      default:
        bgColor = Colors.grey.shade300;
        label = status;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _itemCard(Map<String, dynamic> item) {
    final medicine = item['medicine'] ?? {};
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicine['name'] ?? '-',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent[700],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Flexible(child: _smallInfo('كود', medicine['code'] ?? '-')),
              SizedBox(width: 10),
              Flexible(
                child: _smallInfo('الكمية', item['quantity'].toString()),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Flexible(
                child: _smallInfo('سعر الوحدة', '${item['unit_price']} ج.م'),
              ),
              SizedBox(width: 10),
              Flexible(
                child: _smallInfo('السعر الكلي', '${item['total_price']} ج.م'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallInfo(String label, String value) {
    return RichText(
      text: TextSpan(
        text: '$label: ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.greenAccent[400],
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalAmount(String amount) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.greenAccent[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          amount,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent[700],
          ),
        ),
      ),
    );
  }
}





// {
//     "status": true,
//     "status_code": 200,
//     "message": "تم جلب تفاصيل الطلبية بنجاح",
//     "data": {
//         "id": 1,
//         "order_number": "ORD-20250707-0001",
//         "order_date": "2024-06-01T00:00:00.000000Z",
//         "status": "pending",
//         "supplier": {
//             "id": 1,
//             "name": "محمد علي",
//             "phone": "9621234061",
//             "email": "matrex663@gmail.com"
//         },
//         "items": [
//             {
//                 "id": 1,
//                 "medicine": {
//                     "id": 3,
//                     "name": "hhslhhvsssssssswsw",
//                     "code": "12121211"
//                 },
//                 "quantity": 13,
//                 "unit_price": "44.00",
//                 "total_price": "572.00",
//                 "expiry_date": null
//             },
//             {
//                 "id": 2,
//                 "medicine": {
//                     "id": 4,
//                     "name": "hhslhhvsssssssswsws",
//                     "code": "12121214"
//                 },
//                 "quantity": 13,
//                 "unit_price": "44.00",
//                 "total_price": "572.00",
//                 "expiry_date": null
//             }
//         ],
//         "total_amount": 1144,
//         "items_count": 2,
//         "created_at": "2025-07-07 18:47:45",
//         "updated_at": "2025-07-07 18:47:45"
//     }
// }