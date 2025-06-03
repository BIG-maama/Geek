import 'package:hive/hive.dart';
part 'supplier_profile.g.dart';

@HiveType(typeId: 0)
class SupplierProfile extends HiveObject {
  @HiveField(0)
  String company_name;

  @HiveField(1)
  String contact_person_name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String email;

  @HiveField(4)
  String address;

  @HiveField(5)
  String payment_method;

  @HiveField(6)
  int credit_limit;

  @HiveField(7)
  String date;

  @HiveField(8)
  int id;

  @HiveField(9)
  bool status;

  SupplierProfile({
    required this.company_name,
    required this.contact_person_name,
    required this.phone,
    required this.email,
    required this.address,
    required this.payment_method,
    required this.credit_limit,
    required this.date,
    required this.id,
    required this.status,
  });

  factory SupplierProfile.fromJson(Map<String, dynamic> json) {
    return SupplierProfile(
      company_name: json['company_name'],
      contact_person_name: json['contact_person_name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      payment_method: json['payment_method'] ?? "غير محدد",
      credit_limit: json['credit_limit'] ?? 0,
      date: json['created_at'],
      id: json['id'],
      status: json['is_active'],
    );
  }

  @override
  String toString() {
    return '''
SupplierProfile(
  company_name: $company_name,
  contact_person_name: $contact_person_name,
  phone: $phone,
  email: $email,
  address: $address,
  payment_method: $payment_method,
  credit_limit: $credit_limit,
  date: $date,
  id: $id,
  status: $status
)''';
  }
}
