import '../../domain/entities/account_entity.dart';

class UpdateAccountRequestDto {
  const UpdateAccountRequestDto({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.email,
    required this.description,
    required this.address,
  });

  final int id;
  final String name;
  final AccountType type;
  final String phone;
  final String email;
  final String description;
  final String address;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.apiValue,
      'phone': phone,
      'email': email,
      'description': description,
      'address': address,
    };
  }
}
