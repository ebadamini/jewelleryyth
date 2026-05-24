
import 'package:flutter/cupertino.dart';
import 'package:jewelleryyth/features/accounts/domain/entities/account_entity.dart';
import 'package:jewelleryyth/features/accounts/domain/entities/money_balance_entity.dart';
import 'package:jewelleryyth/features/photo/domain/photo_entities.dart';

class AccountModel extends AccountEntity{
  const AccountModel({
    required super.id,
    required super.name,
    required super.type,
    required super.phone,
    required super.email,
    required super.description,
    required super.address,
    required super.metalBalance,
    required super.moneyBalances,
    required super.sequenceNumber,
    required super.photo,
});

  factory AccountModel.fromJson(Map<String, dynamic> json){
    var balanceList = (json['moneyBalances'] as List?)
        ?.map((item) => MoneyBalanceEntity(
        accountId: item['accountId']as int,
        currency: item['currency'] ?? '',
        balance: (item['balance'] as num?)?.toDouble() ?? 0.0,
    )).toList() ?? [];


    List<PhotoEntity> photoList = [];
    final photoRaw = json['photo'];
    if(photoRaw != null && photoRaw is List){
      photoList = photoRaw.map((p) {
        if(p is! Map<String, dynamic>){
          debugPrint('SKIP non-map photo item: $p');
          return null;
        }

        debugPrint('Photo Item: keys: ${p.keys.toList()}');

        return PhotoEntity(
        id: p['id'] as int? ?? 0,
        fileName: p['fileName']?.toString() ?? p['fileName']?.toString() ?? '',
        fileUrl: p['fileUrl']?.toString() ?? p['fileUrl']?.toString() ?? '',
          size: (p['size'] as num?)?.toDouble() ?? 0.0,
        );

      }).whereType<PhotoEntity>().toList();
    }


    return AccountModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      metalBalance: (json['metalBalance'] as num?)?.toDouble() ?? 0.0,
      moneyBalances: balanceList,
      sequenceNumber: json['sequenceNumber'] ?? '',
      photo: photoList,
    );
  }
}