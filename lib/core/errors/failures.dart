
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}


class ServerFailure extends Failure{
  const ServerFailure({String? message}) : super(message: message ?? 'Server Error');
}

class CacheFailure extends Failure{
  const CacheFailure({String? message}) : super(message: message ?? 'Cache Error');
}