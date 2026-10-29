class UserModel {
  final String name;
  final String phone;

  UserModel({
    required this.name,
    required this.phone,
  });
  UserModel copyWith({
String? name,
String? phone,
  }){
    return UserModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }
}