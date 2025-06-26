import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:pro/widget/Global.dart';

class AlternativeMedicinesPage extends StatefulWidget {
  final int medicineId;

  const AlternativeMedicinesPage({super.key, required this.medicineId});

  @override
  State<AlternativeMedicinesPage> createState() =>
      _AlternativeMedicinesPageState();
}

class _AlternativeMedicinesPageState extends State<AlternativeMedicinesPage> {
  Map? medicine, meta;
  List alternatives = [];
  bool loading = true;

  String? error;

  @override
  void initState() {
    super.initState();
    fetchAlternatives();
  }

  Future<void> fetchAlternatives() async {
    try {
      final response = await Dio().get(
        "$baseUrl/api/show-all-alternatives/${widget.medicineId}",
      );
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data);
        setState(() {
          medicine = response.data['data']['medicine'];
          meta = response.data['meta'];
          alternatives = response.data['data']['alternatives'];
          loading = false;
        });
      } else {
        setState(() {
          error = 'فشل في جلب البيانات';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'خطأ في الاتصال: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("البدائل")),
      child: SafeArea(
        child:
            loading
                ? const Center(child: CupertinoActivityIndicator())
                : error != null
                ? Center(child: Text(error!))
                : ListView(
                  children: [
                    if (medicine != null)
                      CupertinoListTile.notched(
                        title: Text(
                          "🧪 ${medicine!['scientific_name'] ?? 'بدون اسم'}",
                        ),
                        subtitle: Text(
                          "الباركود: ${medicine!['barcode'] ?? 'غير متوفر'}",
                        ),
                      ),
                    const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        "🩺 البدائل:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (alternatives.isEmpty)
                      const Center(child: Text("لا توجد بدائل متاحة حالياً")),
                    ...alternatives.map((alt) {
                      return CupertinoListTile(
                        title: Text(
                          "🔁 ${alt['arabic_name'] ?? alt['name'] ?? 'اسم غير متوفر'}",
                        ),
                        subtitle: Text(
                          "السعر: ${alt['prices']['people_price']} | الكمية: ${alt['quantity']}",
                        ),
                        additionalInfo: Text(
                          "الصنف: ${alt['category']['name']}",
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    if (meta?['total_alternatives'] != null)
                      Center(
                        child: Text(
                          "الإجمالي: ${meta?['total_alternatives'].toString()} بدائل",
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}




// {
//     "status": true,
//     "status_code": 200,
//     "message": "✅ تم جلب الأدوية البديلة بنجاح!",
//     "data": {
//         "medicine": {
//             "id": 1,
//             "scientific_name": null,
//             "barcode": "12121211"
//         },
//         "alternatives": [
//             {
//                 "id": 2,
//                 "name": "hhslhhvssfwسswsssss",
//                 "scientific_name": null,
//                 "barcode": "12121212",
//                 "type": "unit",
//                 "quantity": 12,
//                 "prices": {
//                     "people_price": "22.00",
//                     "supplier_price": "44.00"
//                 },
//                 "category": {
//                     "name": "عطور",
//                     "id": 1
//                 }
//             },
//             {
//                 "id": 3,
//                 "name": "hhslhhvssfwسswsssssw",
//                 "scientific_name": null,
//                 "barcode": "12121213",
//                 "type": "unit",
//                 "quantity": 12,
//                 "prices": {
//                     "people_price": "22.00",
//                     "supplier_price": "44.00"
//                 },
//                 "category": {
//                     "name": "عطور",
//                     "id": 1
//                 }
//             }
//         ]
//     },
//     "meta": {
//         "total_alternatives": 2
//     }
// }