import 'package:hive/hive.dart';

part 'hive_save.g.dart';

@HiveType(typeId: 41)
class MedicineModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String barcode;

  MedicineModel({required this.id, required this.name, required this.barcode});

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      name: json['name'],
      barcode: json['barcode'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'barcode': barcode};
}

@HiveType(typeId: 42)
class BatchModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String batchNumber;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final String expiryDate;

  @HiveField(4)
  final String unitPrice;

  @HiveField(5)
  final bool isActive;

  @HiveField(6)
  final MedicineModel medicine;

  BatchModel({
    required this.id,
    required this.batchNumber,
    required this.quantity,
    required this.expiryDate,
    required this.unitPrice,
    required this.isActive,
    required this.medicine,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      id: json['id'],
      batchNumber: json['batch_number'],
      quantity: json['quantity'],
      expiryDate: json['expiry_date'],
      unitPrice: json['unit_price'],
      isActive: json['is_active'],
      medicine: MedicineModel.fromJson(json['medicine']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'batch_number': batchNumber,
    'quantity': quantity,
    'expiry_date': expiryDate,
    'unit_price': unitPrice,
    'is_active': isActive,
    'medicine': medicine.toJson(),
  };
}
