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

      if (response.statusCode == 200 && response.data['status'] == true) {
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
                          "🧪 ${medicine!['name'] ?? medicine!['arabic_name']}",
                        ),
                        subtitle: Text("الباركود: ${medicine!['barcode']}"),
                      ),
                    const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Text(
                        "🩺 البدائل:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...alternatives.map((alt) {
                      return CupertinoListTile(
                        title: Text("🔁 ${alt['arabic_name'] ?? alt['name']}"),
                        subtitle: Text(
                          "السعر: ${alt['prices']['people_price']} | الكمية: ${alt['quantity']}",
                        ),
                        additionalInfo: Text(
                          "الصنف: ${alt['category']['name']}",
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 20),
                    Center(child: Text(meta?['total_alternatives'])),
                  ],
                ),
      ),
    );
  }
}
