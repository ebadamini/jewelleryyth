
import 'package:equatable/equatable.dart';

class PhotoEntity extends Equatable{

  const PhotoEntity({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.size,
});

  final int id;
  final String fileName;
  final String fileUrl;
  final double size;

  @override
  List<Object?> get props => [id, fileName, fileUrl, size];
}