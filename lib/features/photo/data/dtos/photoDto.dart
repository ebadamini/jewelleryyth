

import 'package:jewelleryyth/features/photo/domain/photo_entities.dart';

class PhotoDto {
  const PhotoDto({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.size,
});

  final int id;
  final String fileName;
  final String fileUrl;
  final double size;

  factory PhotoDto.fromJson(Map<String, dynamic> json){
    return PhotoDto(
        id: json['id'] as int,
        fileName: json['fileName'] ?? '',
        fileUrl: json['fileUrl'] ?? '',
        size: (json['size'] as num?)?.toDouble() ?? 0.0,
    );
  }

  PhotoEntity toEntity(){
    return PhotoEntity(id: id, fileName: fileName, fileUrl: fileUrl, size: size);
  }
}