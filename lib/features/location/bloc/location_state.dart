part of 'location_bloc.dart';

class LocationState extends Equatable {
  const LocationState({
    this.address = const AddressInput.pure(),
    this.range = 1,
    this.fetchedCities,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  static int minRange = 1;
  static int maxRange = 100;

  final FormzSubmissionStatus status;
  final AddressInput address;
  final int range;
  final List<GeocodeCity>? fetchedCities;
  final String? errorMessage;

  LocationState copyWith(
      {AddressInput? address,
      int? range,
      FormzSubmissionStatus? status,
      List<GeocodeCity>? fetchedCities,
      String? errorMessage}) {
    return LocationState(
        address: address ?? this.address,
        range: range ?? this.range,
        status: status ?? this.status,
        fetchedCities: fetchedCities ?? this.fetchedCities,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props =>
      [address, range, status, fetchedCities, errorMessage];
}

class LocationInitial extends LocationState {}
