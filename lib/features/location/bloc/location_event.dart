part of 'location_bloc.dart';

abstract class LocationEvent {
  const LocationEvent();
}

class LocationLoaded extends LocationEvent {
  const LocationLoaded(this.profile);
  final Profile profile;
}

class LocationUpdated extends LocationEvent {
  LocationUpdated(this.location);

  final String location;
}

class LocationInputValueChanged extends LocationEvent {
  LocationInputValueChanged(this.location);

  final String location;
}

class RangeValueChanged extends LocationEvent {
  RangeValueChanged(this.range);

  final int range;
}

class LocationFormSubmitted extends LocationEvent {}