
import 'package:jewelleryyth/features/photo/domain/photo_entities.dart';

class PhotoModel extends PhotoEntity{
  const PhotoModel({
    required super.id,
    required super.fileName,
    required super.fileUrl,
    required super.size,
});

  factory PhotoModel.fromJson(Map<String, dynamic> json){
    return PhotoModel(
        id: json['id'] as int,
        fileName: json['fileName'] ?? '',
        fileUrl: json['fileUrl'] ?? '',
        size: (json['size'] as num?)?.toDouble() ?? 0.0,
    );
  }
}