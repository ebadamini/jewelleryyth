import 'package:flutter/cupertino.dart';
import 'package:jewelleryyth/features/photo/domain/photo_entities.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/entities/money_balance_entity.dart';
import 'money_balance_dto.dart';

class AccountResponseDto {
  const AccountResponseDto({
    required this.id,
    required this.name,
    required this.type,
    required this.phone,
    required this.email,
    required this.description,
    required this.address,
    required this.metalBalance,
    required this.moneyBalances,
    required this.sequenceNumber,
    required this.photo,
  });

  final int id;
  final String name;
  final AccountType type;
  final String phone;
  final String email;
  final String description;
  final String address;
  final double metalBalance;
  final List<MoneyBalanceDto> moneyBalances;
  final String sequenceNumber;
  final List<PhotoEntity> photo;



  factory AccountResponseDto.fromJson(Map<String, dynamic> json) {
    final balances = (json['moneyBalances'] as List<dynamic>? ?? [])
        .map((e) => MoneyBalanceDto.fromJson(e as Map<String, dynamic>))
        .toList();

    List<PhotoEntity> photo = [];
    var photoRaw = json['photo'];
    if(photoRaw != null && photoRaw is List){
      photo = photoRaw.map((p){
        if(p is! Map<String, dynamic>){
          debugPrint('Account Response DTO: skip non map photo item: $p');
          return null;
        }

        debugPrint('Photo Item Key: ${p.keys.toList()}');

        return PhotoEntity(
            id: p['id'] as int,
            fileName: p['fileName'] ?? '',
            fileUrl: p['fileUrl'] ?? '',
            size: (p['size'] as num?)?.toDouble() ?? 0.0,
        );
      }).whereType<PhotoEntity>().toList();
    }
    return AccountResponseDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      type: accountTypeFromString(json['type']?.toString() ?? ''),
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      metalBalance: (json['metalBalance'] as num?)?.toDouble() ?? 0,
      moneyBalances: balances,
      sequenceNumber: json['sequenceNumber']?.toString() ?? '',
      photo: photo,
    );
  }

  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      name: name,
      type: type,
      phone: phone,
      email: email,
      description: description,
      address: address,
      metalBalance: metalBalance,
      moneyBalances: moneyBalances.map((e) => e.toEntity()).toList(),
      sequenceNumber: sequenceNumber,
      photo: photo,
    );
  }
}
