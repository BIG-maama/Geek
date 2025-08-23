import 'package:hive/hive.dart';
part 'supplier_profile.g.dart';

@HiveType(typeId: 0)
class Supplier extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String companyName;

  @HiveField(2)
  String contactPersonName;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String email;

  @HiveField(5)
  int isActive;

  @HiveField(6)
  int unpaidPurchases;

  Supplier({
    required this.id,
    required this.companyName,
    required this.contactPersonName,
    required this.phone,
    required this.email,
    required this.isActive,
    required this.unpaidPurchases,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      companyName: json['company_name'],
      contactPersonName: json['contact_person_name'],
      phone: json['phone'],
      email: json['email'],
      isActive: json['is_active'],
      unpaidPurchases: json['unpaid_purchases'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'company_name': companyName,
    'contact_person_name': contactPersonName,
    'phone': phone,
    'email': email,
    'is_active': isActive,
    'unpaid_purchases': unpaidPurchases,
  };
}
