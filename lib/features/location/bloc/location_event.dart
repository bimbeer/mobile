part of 'location_bloc.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
}

class LocationInitialized extends LocationEvent {
  const LocationInitialized(this.profile);

  final Profile profile;

  @override
  List<Object> get props => [profile];
}

class LocationUpdated extends LocationEvent {
  const LocationUpdated(this.city);

  final GeocodeCity city;

  @override
  List<Object> get props => [city];
}

class LocationInputValueChanged extends LocationEvent {
  const LocationInputValueChanged(this.location);

  final String location;

  @override
  List<Object> get props => [location];
}

class RangeValueChanged extends LocationEvent {
  const RangeValueChanged(this.range);

  final int range;

  @override
  List<Object?> get props => [range];
}

class LocationFormSubmitted extends LocationEvent {
  const LocationFormSubmitted({required this.userId, required this.profile});

  final String userId;
  final Profile profile;

  @override
  List<Object?> get props => [userId, profile];
}
