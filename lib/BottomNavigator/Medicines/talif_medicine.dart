import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:pro/widget/Global.dart';

class DamagedMedicinesPage extends StatefulWidget {
  @override
  _DamagedMedicinesPageState createState() => _DamagedMedicinesPageState();
}

class _DamagedMedicinesPageState extends State<DamagedMedicinesPage> {
  final List<String> _reasons = [
    'expired',
    'damaged',
    'storage_issue',
    'other',
  ];
  String _selectedReason = 'expired';

  List<dynamic> _damagedList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDamagedMedicines(reason: _selectedReason);
  }

  Future<void> fetchDamagedMedicines({required String reason}) async {
    setState(() => _isLoading = true);
    try {
      final response = await Dio().get(
        "$baseUrl/api/show-all-damaged-medicines",
        queryParameters: {'reason': reason},
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        setState(() {
          _damagedList = response.data['data']['damaged_medicines'];
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.systemGroupedBackground,
      darkColor: CupertinoColors.black,
    ).resolveFrom(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("الأدوية التالفة"),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // 🔘 الفلاتر
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 8,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      _reasons.map((reason) {
                        final isSelected = reason == _selectedReason;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedReason = reason);
                              fetchDamagedMedicines(reason: reason);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? CupertinoColors.activeBlue
                                        : CupertinoColors.systemGrey5
                                            .withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                reason,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? CupertinoColors.white
                                          : CupertinoColors.label.resolveFrom(
                                            context,
                                          ),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),

            // 📄 القائمة الرئيسية
            Expanded(
              child:
                  _isLoading
                      ? Center(child: CupertinoActivityIndicator())
                      : RefreshIndicator(
                        onRefresh:
                            () =>
                                fetchDamagedMedicines(reason: _selectedReason),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _damagedList.length,
                          itemBuilder: (context, index) {
                            final item = _damagedList[index];
                            final med = item['medicine'];

                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 4,
                              ),
                              color: CupertinoColors.systemGrey6.withOpacity(
                                0.25,
                              ),
                              shadowColor: CupertinoColors.systemGrey
                                  .withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: CupertinoListTile(
                                padding: const EdgeInsets.all(14),
                                leading: CircleAvatar(
                                  backgroundColor: CupertinoColors.activeBlue
                                      .withOpacity(0.1),
                                  child: Icon(
                                    CupertinoIcons.capsule,
                                    color: CupertinoColors.activeBlue,
                                  ),
                                ),
                                title: Text(
                                  med['arabic_name'] ?? med['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 4),
                                    _subtitle(
                                      "الكمية:",
                                      item['quantity_damaged'].toString(),
                                    ),
                                    _subtitle("السبب:", item['reason_text']),
                                    _subtitle("الباركود:", med['barcode']),
                                    if (item['notes'] != null &&
                                        item['notes'].toString().isNotEmpty)
                                      _subtitle("ملاحظات:", item['notes']),
                                    _subtitle(
                                      "التاريخ:",
                                      item['damaged_at'].toString().substring(
                                        0,
                                        10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _subtitle(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Text(
        "$label $value",
        style: TextStyle(fontSize: 13, color: CupertinoColors.systemGrey),
      ),
    );
  }
}
