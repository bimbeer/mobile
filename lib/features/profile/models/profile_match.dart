import 'package:equatable/equatable.dart';

class ProfileMatch extends Equatable{
  final String gender;
  final String interest;

  const ProfileMatch(this.gender, this.interest);
  
  @override
  List<Object?> get props => [gender, interest];
}
