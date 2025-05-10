class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String date;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.date,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      date: json['created_at'],
    );
  }
}

class UserData {
  static UserModel? currentUser;
}
