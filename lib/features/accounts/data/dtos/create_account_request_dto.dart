import '../../domain/entities/account_entity.dart';

class CreateAccountRequestDto {
  const CreateAccountRequestDto({
    required this.name,
    required this.type,
    required this.phone,
    required this.email,
    required this.description,
    required this.address,
  });

  final String name;
  final AccountType type;
  final String phone;
  final String email;
  final String description;
  final String address;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.apiValue,
      'phone': phone,
      'email': email,
      'description': description,
      'address': address,
    };
  }
}
