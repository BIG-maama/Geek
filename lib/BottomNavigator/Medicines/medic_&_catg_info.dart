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

@HiveType(typeId: 31)
class Prices {
  @HiveField(0)
  int supplierPrice;

  @HiveField(1)
  int peoplePrice;

  @HiveField(2)
  int taxRate;

  Prices({
    required this.supplierPrice,
    required this.peoplePrice,
    required this.taxRate,
  });

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
    supplierPrice: int.tryParse(json['supplier_price'].toString()) ?? 0,
    peoplePrice: int.tryParse(json['people_price'].toString()) ?? 0,
    taxRate: int.tryParse(json['tax_rate'].toString()) ?? 0,
  );
}

@HiveType(typeId: 4)
class Category {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
    );
  }
}

@HiveType(typeId: 5)
class MedicineForm {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  MedicineForm({
    required this.id,
    required this.name,
    required this.description,
  });

  factory MedicineForm.fromJson(Map<String, dynamic> json) {
    return MedicineForm(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

@HiveType(typeId: 6)
class Status {
  @HiveField(0)
  bool isLow;

  @HiveField(1)
  bool isOut;

  @HiveField(2)
  bool isExpired;

  @HiveField(3)
  bool isExpiringSoon;

  Status({
    required this.isLow,
    required this.isOut,
    required this.isExpired,
    required this.isExpiringSoon,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      isLow: json['is_low'] ?? false,
      isOut: json['is_out'] ?? false,
      isExpired: json['is_expired'] ?? false,
      isExpiringSoon: json['is_expiring_soon'] ?? false,
    );
  }
}

@HiveType(typeId: 7)
class MedicInfo extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String arabicName;

  @HiveField(2)
  String barcode;

  @HiveField(3)
  String type;

  @HiveField(4)
  String quantity;

  @HiveField(5)
  String alertQuantity;

  @HiveField(7)
  int id;

  @HiveField(8)
  List<dynamic> attachments;

  @HiveField(9)
  Prices prices;

  @HiveField(10)
  Category category;

  @HiveField(11)
  MedicineForm medicineForm;

  @HiveField(12)
  Status status;

  MedicInfo({
    required this.name,
    required this.arabicName,
    required this.barcode,
    required this.type,
    required this.quantity,
    required this.alertQuantity,
    required this.id,
    required this.attachments,
    required this.prices,
    required this.category,
    required this.medicineForm,
    required this.status,
  });

  factory MedicInfo.fromJson(Map<String, dynamic> json) {
    final medicine = json['medicine'] ?? json;

    return MedicInfo(
      name: medicine['name'] ?? '',
      arabicName: medicine['arabic_name'] ?? '',
      barcode: medicine['barcode'] ?? '',
      type: medicine['type'] ?? '',
      quantity: medicine['quantity']?.toString() ?? '0',
      alertQuantity: medicine['alert_quantity']?.toString() ?? '0',
      id: medicine['id'] ?? 0,
      attachments: json['attachments'] ?? [],
      prices: Prices.fromJson(medicine['prices'] ?? {}),
      category: Category.fromJson(medicine['category'] ?? {}),
      medicineForm: MedicineForm.fromJson(medicine['medicine_form'] ?? {}),
      status: Status.fromJson(medicine['status'] ?? {}),
    );
  }
}




// {
//     "status": true,
//     "status_code": 200,
//     "medicine": {
//         "id": 1,
//         "name": "hhslhhv",
//         "scientific_name": null,
//         "arabic_name": "fgfgdgdhhhuu",
//         "barcode": "12121212",
//         "type": "unit",
//         "quantity": "12",
//         "alert_quantity": "4",
//         "prices": {
//             "supplier_price": "44",
//             "people_price": "22",
//             "tax_rate": "3"
//         },
//         "expiry_date": null,
//         "category": {
//             "id": 1,
//             "name": "مسكنات"
//         },
//         "medicine_form": {
//             "id": 1,
//             "name": "ji",
//             "description": "اقراص"
//         },
//         "status": {
//             "is_low": false,
//             "is_out": false,
//             "is_expired": true,
//             "is_expiring_soon": false
//         }
//     },
//     "attachments": [],
//     "message": "تم إضافة الدواء والمرفقات بنجاح"
// }