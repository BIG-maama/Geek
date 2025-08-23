import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pro/BottomNavigator/Medicines/medic_&_catg_info.dart';
import 'package:pro/BottomNavigator/Suppliers/supplier_profile.dart';

import 'package:pro/widget/Global.dart';

class AddNewOrder extends StatefulWidget {
  @override
  _AddNewOrderState createState() => _AddNewOrderState();
}

class _AddNewOrderState extends State<AddNewOrder> {
  final TextEditingController _noteController = TextEditingController();
  DateTime _orderDate = DateTime.now();
  int? _selectedSupplierId;

  List<Supplier> _suppliers = [];
  List<MedicInfo> _medicines = [];
  List<Map<String, dynamic>> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
    _loadMedicines();
  }

  void _loadSuppliers() {
    final box = Hive.box<Supplier>('suppliers');
    setState(() {
      _suppliers = box.values.toList();
    });
  }

  void _loadMedicines() {
    final box = Hive.box<MedicInfo>('medics');
    setState(() {
      _medicines = box.values.toList();
    });
  }

  String formatDateTime(DateTime dt) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(dt.day)}/${twoDigits(dt.month)}/${dt.year} ${twoDigits(dt.hour)}:${twoDigits(dt.minute)}";
  }

  // حذف AlertDialog بالكامل لأنه لن نستخدمه

  Future<void> _submitOrder() async {
    if (_selectedSupplierId == null || _selectedItems.isEmpty) {
      _showError("يرجى اختيار المورد وإضافة الأدوية");
      return;
    }

    final body = {
      "supplier_id": _selectedSupplierId,
      "order_date": _orderDate.toIso8601String(),
      "note": _noteController.text,
      "items": _selectedItems,
    };

    print("Request Body: $body"); // طباعة كامل البيانات

    try {
      final response = await Dio().post("$baseUrl/api/orders", data: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) Navigator.pop(context, true);
          });
        }
      } else {
        _showError("حدث خطأ أثناء إرسال الطلب.");
      }
    } catch (e) {
      _showError("فشل في إنشاء الطلب: ${e.toString()}");
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("خطأ"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("إغلاق"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = formatDateTime(_orderDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("طلب جديد"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          /// التاريخ
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text("تاريخ الطلب"),
            subtitle: Text(formattedDate),
          ),

          /// المورد
          DropdownButtonFormField<int>(
            decoration: InputDecoration(labelText: "اختر المورد"),
            value: _selectedSupplierId,
            items:
                _suppliers
                    .map(
                      (s) => DropdownMenuItem<int>(
                        value: s.id,
                        child: Text(s.companyName),
                      ),
                    )
                    .toList(),
            onChanged: (val) {
              setState(() => _selectedSupplierId = val);
            },
          ),
          SizedBox(height: 16),

          /// قائمة الأدوية مع حقل إدخال الكمية
          Text("الأدوية", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          ..._medicines.map((med) {
            final selected = _selectedItems.firstWhere(
              (e) => e['medicine_id'] == med.id,
              orElse: () => {"quantity": ""},
            );

            TextEditingController quantityController = TextEditingController(
              text: selected['quantity']?.toString() ?? '',
            );

            return Card(
              child: ListTile(
                title: Text(med.arabicName),
                subtitle: SizedBox(
                  width: 120,
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'الكمية',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (val) {
                      final quantity = int.tryParse(val);
                      setState(() {
                        _selectedItems.removeWhere(
                          (e) => e['medicine_id'] == med.id,
                        );
                        if (quantity != null && quantity > 0) {
                          _selectedItems.add({
                            "medicine_id": med.id,
                            "quantity": quantity,
                          });
                        }
                      });
                    },
                  ),
                ),
              ),
            );
          }).toList(),

          SizedBox(height: 16),

          /// الملاحظات
          TextFormField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "ملاحظات (اختياري)",
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(height: 20),

          /// زر الإرسال
          ElevatedButton.icon(
            onPressed: _submitOrder,
            icon: Icon(Icons.send),
            label: Text("إرسال الطلب"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class NewOrderStepper extends StatefulWidget {
//   @override
//   _NewOrderStepperState createState() => _NewOrderStepperState();
// }

// class _NewOrderStepperState extends State<NewOrderStepper> {
//   int _currentStep = 0;
//   int? _selectedSupplierId;
//   List<Map<String, dynamic>> _suppliers = [
//     {"id": 1, "name": "صيدلية القدس"},
//     {"id": 2, "name": "دواء العرب"},
//   ];

//   List<Map<String, dynamic>> _allMedicines = [
//     {"id": 1, "name": "باراسيتامول", "icon": CupertinoIcons.pin_fill},
//     {"id": 2, "name": "أوغمنتين", "icon": CupertinoIcons.capsule},
//     {"id": 3, "name": "فيتامين C", "icon": CupertinoIcons.drop},
//   ];

//   Map<int, int> _selectedQuantities = {};
//   TextEditingController _noteController = TextEditingController();

//   PageController _pageController = PageController();

//   void _nextStep() {
//     if (_currentStep < 3) {
//       setState(() {
//         _currentStep++;
//       });
//       _pageController.animateToPage(
//         _currentStep,
//         duration: Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _submitOrder();
//     }
//   }

//   void _prevStep() {
//     if (_currentStep > 0) {
//       setState(() {
//         _currentStep--;
//       });
//       _pageController.animateToPage(
//         _currentStep,
//         duration: Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   void _submitOrder() {
//     if (_selectedSupplierId == null || _selectedQuantities.isEmpty) {
//       showCupertinoDialog(
//         context: context,
//         builder:
//             (_) => CupertinoAlertDialog(
//               title: Text("خطأ"),
//               content: Text("يرجى تحديد المورد والأدوية"),
//               actions: [
//                 CupertinoDialogAction(
//                   child: Text("حسناً"),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//       );
//       return;
//     }

//     final orderData = {
//       "supplier_id": _selectedSupplierId,
//       "items":
//           _selectedQuantities.entries
//               .map((e) => {"medicine_id": e.key, "quantity": e.value})
//               .toList(),
//       "note": _noteController.text,
//       "order_date": DateTime.now().toIso8601String(),
//     };

//     // إرسال الطلب أو مناداة API هنا

//     showCupertinoDialog(
//       context: context,
//       builder:
//           (_) => CupertinoAlertDialog(
//             title: Text("✅ تم الإرسال"),
//             content: Text("تم إرسال الطلب بنجاح!"),
//             actions: [
//               CupertinoDialogAction(
//                 child: Text("حسناً"),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//     );
//   }

//   Widget _buildSupplierStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "اختر المورد",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: CupertinoColors.label,
//           ),
//         ),
//         SizedBox(height: 12),
//         CupertinoSegmentedControl<int>(
//           groupValue: _selectedSupplierId,
//           children: {
//             for (var s in _suppliers)
//               s['id']: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 8,
//                   horizontal: 16,
//                 ),
//                 child: Text(s['name'], style: TextStyle(fontSize: 16)),
//               ),
//           },
//           onValueChanged: (val) => setState(() => _selectedSupplierId = val),
//         ),
//       ],
//     ).animate().fade(duration: 600.ms).slideY(begin: 0.2);
//   }

//   Widget _buildMedicineGrid() {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.symmetric(vertical: 12),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.9,
//       ),
//       itemCount: _allMedicines.length,
//       itemBuilder: (context, index) {
//         final med = _allMedicines[index];
//         int quantity = _selectedQuantities[med['id']] ?? 0;

//         return Container(
//           decoration: BoxDecoration(
//             color: CupertinoColors.systemTeal.withOpacity(0.15),
//             borderRadius: BorderRadius.circular(18),
//             boxShadow: [
//               BoxShadow(
//                 color: CupertinoColors.systemTeal.withOpacity(0.3),
//                 blurRadius: 8,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           padding: EdgeInsets.all(12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(med['icon'], size: 48, color: CupertinoColors.systemTeal),
//               SizedBox(height: 8),
//               Text(
//                 med['name'],
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                   color: CupertinoColors.label,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CupertinoButton(
//                     padding: EdgeInsets.zero,
//                     child: Icon(
//                       CupertinoIcons.minus_circled,
//                       color:
//                           quantity > 0
//                               ? CupertinoColors.systemRed
//                               : Colors.grey,
//                       size: 32,
//                     ),
//                     onPressed:
//                         quantity > 0
//                             ? () {
//                               setState(() {
//                                 _selectedQuantities[med['id']] = quantity - 1;
//                               });
//                             }
//                             : null,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Text(
//                       quantity.toString(),
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: CupertinoColors.black,
//                       ),
//                     ),
//                   ),
//                   CupertinoButton(
//                     padding: EdgeInsets.zero,
//                     child: Icon(
//                       CupertinoIcons.add_circled,
//                       color: CupertinoColors.systemGreen,
//                       size: 32,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _selectedQuantities[med['id']] = quantity + 1;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ).animate().fade(duration: 500.ms).scale();
//       },
//     );
//   }

//   Widget _buildMedicinesStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "اختر الأدوية وكمياتها",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: CupertinoColors.label,
//           ),
//         ),
//         _buildMedicineGrid(),
//       ],
//     ).animate().fade(duration: 600.ms).slideY(begin: 0.2);
//   }

//   Widget _buildNotesStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           "ملاحظات إضافية",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: CupertinoColors.label,
//           ),
//         ),
//         SizedBox(height: 12),
//         CupertinoTextField(
//           controller: _noteController,
//           maxLines: 5,
//           placeholder: "اكتب ملاحظاتك هنا...",
//           decoration: BoxDecoration(
//             color: CupertinoColors.systemGrey6,
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ],
//     ).animate().fade(duration: 600.ms).slideY(begin: 0.2);
//   }

//   Widget _buildReviewStep() {
//     String supplierName =
//         _selectedSupplierId == null
//             ? "غير محدد"
//             : _suppliers.firstWhere(
//               (s) => s['id'] == _selectedSupplierId,
//             )['name'];

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "مراجعة الطلب",
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: CupertinoColors.label,
//             ),
//           ),
//           SizedBox(height: 16),
//           Text(
//             "المورد: $supplierName",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           SizedBox(height: 12),
//           Text(
//             "الأدوية المختارة:",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           ..._selectedQuantities.entries.map((e) {
//             final medName =
//                 _allMedicines.firstWhere((m) => m['id'] == e.key)['name'];
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4),
//               child: Text(
//                 "- $medName : ${e.value}",
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }),
//           SizedBox(height: 12),
//           Text(
//             "الملاحظات:",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           Text(
//             _noteController.text.isEmpty ? "-" : _noteController.text,
//             style: TextStyle(fontSize: 16),
//           ),
//           SizedBox(height: 24),
//           CupertinoButton.filled(
//             child: Text("إرسال الطلب"),
//             borderRadius: BorderRadius.circular(14),
//             onPressed: _submitOrder,
//           ),
//         ],
//       ).animate().fade(duration: 600.ms).slideY(begin: 0.1),
//     );
//   }

//   List<Widget> _steps() => [
//     _buildSupplierStep(),
//     _buildMedicinesStep(),
//     _buildNotesStep(),
//     _buildReviewStep(),
//   ];

//   @override
//   void dispose() {
//     _noteController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: CupertinoPageScaffold(
//         navigationBar: CupertinoNavigationBar(
//           middle: Text("طلب جديد"),
//           backgroundColor: CupertinoColors.systemTeal,
//           brightness: Brightness.dark,
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // خطوات مع شريط تقدم (اختياري)
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Row(
//                   children: List.generate(_steps().length, (index) {
//                     bool isActive = index == _currentStep;
//                     bool isCompleted = index < _currentStep;
//                     return Expanded(
//                       child: Container(
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         height: 6,
//                         decoration: BoxDecoration(
//                           color:
//                               isCompleted
//                                   ? CupertinoColors.systemTeal
//                                   : (isActive
//                                       ? CupertinoColors.systemTeal.withOpacity(
//                                         0.5,
//                                       )
//                                       : CupertinoColors.systemGrey4),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),

//               Expanded(
//                 child: PageView(
//                   controller: _pageController,
//                   physics: NeverScrollableScrollPhysics(),
//                   children: _steps(),
//                 ),
//               ),

//               // أزرار التحكم
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: Row(
//                   children: [
//                     if (_currentStep > 0)
//                       CupertinoButton(
//                         child: Text("السابق"),
//                         onPressed: _prevStep,
//                       ),
//                     Spacer(),
//                     CupertinoButton.filled(
//                       child: Text(
//                         _currentStep == _steps().length - 1
//                             ? "إنهاء"
//                             : "التالي",
//                       ),
//                       onPressed: _nextStep,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
