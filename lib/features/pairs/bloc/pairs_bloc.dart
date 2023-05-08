import 'package:bimbeer/features/authentication/data/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../profile/data/repositories/profile_repository.dart';
import '../../profile/models/profile.dart';

part 'pairs_event.dart';
part 'pairs_state.dart';

class PairsBloc extends Bloc<PairsEvent, PairsState> {
  PairsBloc(
      {required ProfileRepository profileRepository,
      required AuthenticaionRepository authenticationRepository})
      : _profileRepository = profileRepository,
        _authenticationRepository = authenticationRepository,
        super(PairsEmpty()) {
    on<PairsFetched>(_onPairsFetched);
    on<PairsFinished>(_onPairsFinished);
  }

  final ProfileRepository _profileRepository;
  final AuthenticaionRepository _authenticationRepository;

  void _onPairsFetched(PairsFetched event, Emitter<PairsState> emit) async {
    emit(PairsLoading());
    final matches = await _profileRepository
        .getMatchingProfiles(_authenticationRepository.currentUser.id);
    if (matches.isNotEmpty) {
      emit(PairsNotEmpty(matches));
    } else {
      emit(PairsEmpty());
    }
  }

  void _onPairsFinished(PairsFinished event, Emitter<PairsState> emit) {
    emit(PairsEmpty());
  }
}
