import 'package:hive/hive.dart';
part 'medic_&_catg_info.g.dart';

@HiveType(typeId: 1)
class CategoryInfo extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  int id;
  @HiveField(3)
  String time_create;
  CategoryInfo({
    required this.name,
    required this.description,
    required this.id,
    required this.time_create,
  });
  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      description: json['description'],
      name: json['name'],
      id: json['id'],
      time_create: json['created_at'],
    );
  }
}

@HiveType(typeId: 2)
class MedicInfo extends HiveObject {
  @HiveField(0)
  String medicine_name;
  @HiveField(1)
  String arabic_name;
  @HiveField(2)
  String bar_code;
  @HiveField(3)
  String type;
  @HiveField(4)
  String category_id;
  @HiveField(5)
  String quantity;
  @HiveField(6)
  String alert_quantity;
  @HiveField(7)
  String people_price;
  @HiveField(8)
  String supplier_price;
  @HiveField(9)
  String tax_rate;
  @HiveField(10)
  int id;
  @HiveField(11)
  String created_at;
  @HiveField(12)
  List attachments;
  MedicInfo({
    required this.medicine_name,
    required this.arabic_name,
    required this.type,
    required this.category_id,
    required this.quantity,
    required this.bar_code,
    required this.alert_quantity,
    required this.people_price,
    required this.supplier_price,
    required this.tax_rate,
    required this.id,
    required this.created_at,
    required this.attachments,
  });
  factory MedicInfo.fromJson(Map<String, dynamic> json) {
    return MedicInfo(
      medicine_name: json['medicine_name'],
      arabic_name: json['arabic_name'],
      type: json['type'],
      category_id: json['category_id'],
      quantity: json['quantity'],
      bar_code: json['bar_code'],
      alert_quantity: json['alert_quantity'],
      people_price: json['people_price'],
      supplier_price: json['supplier_price'],
      tax_rate: json['tax_rate'],
      id: json['id'],
      created_at: json['created_at'],
      attachments: json['attachments'],
    );
  }
}
