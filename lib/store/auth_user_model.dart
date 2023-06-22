import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String userId;
  final String email;
  final String token;

  const AuthUser({
    required this.userId,
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, email, token];
}
