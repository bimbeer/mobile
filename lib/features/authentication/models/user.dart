import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({required this.id, this.email, this.password});

  final String id;
  final String? email;
  final String? password;

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;

  @override
  List<Object?> get props => [id, email];
}