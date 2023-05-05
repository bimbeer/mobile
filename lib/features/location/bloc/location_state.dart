part of 'location_bloc.dart';

class LocationState extends Equatable {
  const LocationState({
    this.address = const Address.pure(),
    this.range = 1,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  static int minRange = 1;
  static int maxRange = 100;

  final Address address;
  final int range;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  LocationState copyWith(
      {Address? address, int? range, FormzSubmissionStatus? status, String? errorMessage}) {
    return LocationState(
        address: address ?? this.address,
        range: range ?? this.range,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props => [address, range, status, errorMessage];
}

class LocationInitial extends LocationState {}
