part of 'location_bloc.dart';

abstract class LocationEvent {
  const LocationEvent();
}

class LocationLoaded extends LocationEvent {
  const LocationLoaded(this.profile);
  final Profile profile;
}

class LocationUpdated extends LocationEvent { }

class AddressChanged extends LocationEvent {
  AddressChanged(this.address);

  final String address;
}

class RangeChanged extends LocationEvent {
  RangeChanged(this.range);

  final int range;
}

