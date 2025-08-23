import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';

import 'package:pro/widget/Global.dart';

class OrdersResultPage extends StatefulWidget {
  final String filterType;
  const OrdersResultPage({super.key, required this.filterType});

  @override
  State<OrdersResultPage> createState() => _OrdersResultPageState();
}

class _OrdersResultPageState extends State<OrdersResultPage> {
  List orders = [];
  List<Map<String, dynamic>> suppliers = [];
  List<String> statuses = ['pending', 'confirmed', 'completed', 'cancelled'];
  String? selectedStatus;
  int? selectedSupplierId;
  String searchQuery = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.filterType == 'supplier') {
      loadSuppliersFromHive().then((_) {
        setState(() {});
        fetchOrders();
      });
    } else {
      fetchOrders();
    }
  }

  Future<void> loadSuppliersFromHive() async {
    final box = await Hive.openBox<Supplier>('suppliers');
    suppliers =
        box.values
            .map((e) => {'id': e.id, 'name': e.contactPersonName})
            .toList();
  }

  Future<void> fetchOrders() async {
    setState(() => loading = true);
    try {
      final uri = Uri.parse(buildUriWithFilter());
      final res = await http.get(uri);

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['status']) {
          setState(() {
            orders = data['data']['orders']['data'];
          });
        }
      }
    } catch (e) {
      debugPrint('خطأ في الجلب: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  String buildUriWithFilter() {
    const baseUrle = '$baseUrl/api/orders';
    switch (widget.filterType) {
      case 'supplier':
        return selectedSupplierId != null
            ? '$baseUrle?supplier_id=$selectedSupplierId'
            : baseUrle;
      case 'status':
        return selectedStatus != null
            ? '$baseUrle?status=$selectedStatus'
            : baseUrle;
      case 'search':
        return searchQuery.isNotEmpty
            ? '$baseUrle?search=$searchQuery'
            : baseUrle;
      default:
        return baseUrle;
    }
  }

  Widget buildFilterChips() {
    if (widget.filterType == 'status') {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children:
              statuses.map((status) {
                final selected = selectedStatus == status;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: selected,
                    selectedColor: Colors.teal,
                    onSelected: (_) {
                      setState(() {
                        selectedStatus = status;
                      });
                      fetchOrders();
                    },
                  ),
                );
              }).toList(),
        ),
      );
    } else if (widget.filterType == 'supplier' && suppliers.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children:
              suppliers.map((supplier) {
                final id = supplier['id'];
                final name = supplier['name'];
                final selected = selectedSupplierId == id;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(name),
                    selected: selected,
                    selectedColor: Colors.teal,
                    onSelected: (_) {
                      setState(() {
                        selectedSupplierId = id;
                      });
                      fetchOrders();
                    },
                  ),
                );
              }).toList(),
        ),
      );
    } else if (widget.filterType == 'search') {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          onChanged: (val) {
            setState(() {
              searchQuery = val;
            });
            fetchOrders();
          },
          decoration: InputDecoration(
            hintText: 'ابحث عن رقم الطلب أو اسم المورد...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    return Scaffold(
      appBar: AppBar(
        title: Text('الطلبات (${widget.filterType})'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          buildFilterChips(),
          Expanded(
            child:
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : orders.isEmpty
                    ? const Center(
                      child: Text(
                        'لا يوجد طلبات حالياً',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ).animate().fadeIn(duration: 500.ms)
                    : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: orders.length,
                      itemBuilder: (_, i) {
                        final order = orders[i];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: themeColor.withOpacity(0.1),
                              child: Icon(
                                Icons.receipt_long,
                                color: themeColor,
                              ),
                            ),
                            title: Text(
                              'طلب رقم: ${order['order_number']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('المورد: ${order['supplier']['name']}'),
                                  Text('الحالة: ${order['status']}'),
                                  Text('التاريخ: ${order['order_date']}'),
                                  Text(
                                    'الإجمالي: ${order['total_amount']} د.ع',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: (i * 100).ms);
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
