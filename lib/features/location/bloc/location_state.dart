part of 'location_bloc.dart';

class LocationState extends Equatable {
  const LocationState({
    this.locationInput = const LocationInput.pure(),
    this.range = 1,
    this.fetchedCities,
    this.city,
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage,
  });

  static int minRange = 1;
  static int maxRange = 100;

  final FormzSubmissionStatus status;
  final LocationInput locationInput;
  final int range;
  final List<GeocodeCity>? fetchedCities;
  final GeocodeCity? city;
  final String? errorMessage;

  LocationState copyWith(
      {LocationInput? locationInput,
      int? range,
      FormzSubmissionStatus? status,
      List<GeocodeCity>? fetchedCities,
      GeocodeCity? city,
      String? errorMessage}) {
    return LocationState(
        locationInput: locationInput ?? this.locationInput,
        range: range ?? this.range,
        status: status ?? this.status,
        fetchedCities: fetchedCities ?? this.fetchedCities,
        city: city ?? this.city,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object?> get props =>
      [locationInput, range, status, fetchedCities, city, errorMessage];
}

class LocationInitial extends LocationState {}
