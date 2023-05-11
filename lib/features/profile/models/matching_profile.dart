import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:equatable/equatable.dart';

class MatchingProfile extends Equatable {
  final String id;
  final Profile profile;

  const MatchingProfile(this.id, this.profile);

  @override
  List<Object?> get props => [id, profile];
}
