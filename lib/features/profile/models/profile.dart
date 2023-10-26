import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? description;
  final int? age;
  final String? avatar;
  final List<Beer>? beers;
  final String? gender;
  final String? interest;
  final bool? isGlobal;
  final bool? isLocal;
  final Location? location;
  final int? range;

  const Profile({
    this.firstName,
    this.lastName,
    this.username,
    this.description,
    this.age,
    this.avatar,
    this.beers,
    this.gender,
    this.interest,
    this.isGlobal,
    this.isLocal,
    this.location,
    this.range,
  });

  static const empty = Profile();

  bool get isEmpty => this == empty;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      description: json['description'] ?? '',
      age: json['age'] == null
          ? null
          : json['age'] is String
              ? int.parse(json['age'])
              : json['age'],
      avatar: json['avatar'] ?? '',
      beers: (json['beers'] ?? [])
          .map<Beer>((beerData) => Beer.fromJson(beerData))
          .toList(),
      gender: json['gender'] ?? '',
      interest: json['interest'] ?? '',
      isGlobal: json['isGlobal'] ?? false,
      isLocal: json['isLocal'] ?? false,
      location: json['location'] == null
          ? Location.empty
          : Location.fromJson(json['location']),
      range: json['range'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'description': description,
      'age': age,
      'avatar': avatar,
      'beers': beers?.map((beer) => beer.toMap()).toList(),
      'gender': gender,
      'interest': interest,
      'isGlobal': isGlobal,
      'isLocal': isLocal,
      'location': location?.toMap(),
      'range': range,
    };
  }

  Profile copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? description,
    int? age,
    String? avatar,
    List<Beer>? beers,
    String? gender,
    String? interest,
    bool? isGlobal,
    bool? isLocal,
    Location? location,
    int? range,
  }) {
    return Profile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      description: description ?? this.description,
      age: age ?? this.age,
      avatar: avatar ?? this.avatar,
      beers: beers ?? this.beers,
      gender: gender ?? this.gender,
      interest: interest ?? this.interest,
      isGlobal: isGlobal ?? this.isGlobal,
      isLocal: isLocal ?? this.isLocal,
      location: location ?? this.location,
      range: range ?? this.range,
    );
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        username,
        description,
        age,
        avatar,
        beers,
        gender,
        interest,
        isGlobal,
        isLocal,
        location,
        range,
      ];
}

class Beer extends Equatable {
  final String link;
  final String name;

  const Beer({
    required this.link,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'link': link,
      'name': name,
    };
  }

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      link: json['link'] ?? '',
      name: json['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        link,
        name,
      ];
}

class Location extends Equatable {
  final String label;
  final Position? position;

  const Location({
    required this.label,
    required this.position,
  });

  static Location get empty => Location(label: '', position: Position.empty);

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'position': position?.toMap(),
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      label: json['label'] ?? '',
      position: json['position'] == null
          ? Position.empty
          : Position.fromJson(json['position']),
    );
  }

  @override
  List<Object?> get props => [
        label,
        position,
      ];
}

class Position extends Equatable {
  final List<double> coordinates;
  final String geohash;

  const Position({
    required this.coordinates,
    required this.geohash,
  });

  static Position get empty => const Position(coordinates: [], geohash: '');

  Map<String, dynamic> toMap() {
    return {
      'coordinates': coordinates.map((e) => e as dynamic),
      'geohash': geohash,
    };
  }

  factory Position.fromJson(Map<String, dynamic> json) {
    final coordinates = json['coordinates'];
    return Position(
      coordinates: coordinates != null
          ? List<double>.from(coordinates.map((e) => e as double))
          : <double>[],
      geohash: json['geohash'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        coordinates,
        geohash,
      ];
}
