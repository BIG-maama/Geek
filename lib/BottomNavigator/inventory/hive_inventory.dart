// Run this command after saving:
// flutter packages pub run build_runner build

import 'package:hive/hive.dart';
part 'hive_inventory.g.dart';

@HiveType(typeId: 10)
class InventoryCount extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String countNumber;

  @HiveField(2)
  String countDate;

  @HiveField(3)
  String status;

  @HiveField(4)
  String createdBy;

  @HiveField(7)
  int items_count;

  @HiveField(8)
  String created_at;

  @HiveField(5)
  List<InventoryItem> items;

  InventoryCount({
    required this.id,
    required this.countNumber,
    required this.countDate,
    required this.status,
    required this.createdBy,
    required this.items,
    required this.created_at,
    required this.items_count,
  });

  factory InventoryCount.fromJson(Map<String, dynamic> json) {
    return InventoryCount(
      id: json['id'],
      created_at: json['created_at'],
      items_count: json['items_count'],
      countNumber: json['count_number'],
      countDate: json['count_date'],
      status: json['status'],
      createdBy: json['created_by'] ?? 'غير معروف',
      items:
          (json['items'] as List)
              .map((e) => InventoryItem.fromJson(e))
              .toList(),
    );
  }
}

@HiveType(typeId: 11)
class InventoryItem extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  Medicine medicine;

  @HiveField(2)
  int systemQuantity;

  @HiveField(3)
  int actualQuantity;

  @HiveField(4)
  int difference;

  InventoryItem({
    required this.id,
    required this.medicine,
    required this.systemQuantity,
    required this.actualQuantity,
    required this.difference,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      medicine: Medicine.fromJson(json['medicine']),
      systemQuantity: json['system_quantity'],
      actualQuantity: json['actual_quantity'],
      difference: json['difference'],
    );
  }
}

@HiveType(typeId: 12)
class Medicine extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String barCode;

  Medicine({required this.id, required this.name, required this.barCode});

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      barCode: json['bar_code'],
    );
  }
}
