import 'package:hive/hive.dart';

part 'invocies_pro.g.dart';

@HiveType(typeId: 80)
class Invoice extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String invoiceNumber;

  @HiveField(2)
  String invoiceDate;

  @HiveField(3)
  String dueDate;

  @HiveField(4)
  String status;

  @HiveField(5)
  String totalAmount;

  @HiveField(6)
  String supplierName;

  @HiveField(7)
  int itemsCount;

  @HiveField(8)
  List<MedicineItem> medicines;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.dueDate,
    required this.status,
    required this.totalAmount,
    required this.supplierName,
    required this.itemsCount,
    required this.medicines,
  });

  // دالة fromJson
  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      invoiceDate: json['invoice_date'],
      dueDate: json['due_date'],
      status: json['status'],
      totalAmount: json['total_amount'],
      supplierName: json['supplier_name'],
      itemsCount: json['items_count'],
      medicines:
          (json['medicines'] as List<dynamic>)
              .map((med) => MedicineItem.fromJson(med))
              .toList(),
    );
  }

  // دالة toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'invoice_date': invoiceDate,
      'due_date': dueDate,
      'status': status,
      'total_amount': totalAmount,
      'supplier_name': supplierName,
      'items_count': itemsCount,
      'medicines': medicines.map((med) => med.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 81)
class MedicineItem {
  @HiveField(0)
  String medicineName;

  @HiveField(1)
  String unitPrice;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String totalPrice;

  MedicineItem({
    required this.medicineName,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });

  // fromJson
  factory MedicineItem.fromJson(Map<String, dynamic> json) {
    return MedicineItem(
      medicineName: json['medicine_name'],
      unitPrice: json['unit_price'],
      quantity: json['quantity'],
      totalPrice: json['total_price'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'medicine_name': medicineName,
      'unit_price': unitPrice,
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}
