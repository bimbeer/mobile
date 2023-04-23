import 'package:cloud_firestore/cloud_firestore.dart';
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

  factory Profile.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Profile(
      firstName: data?['firstName'] ?? '',
      lastName: data?['lastName'] ?? '',
      username: data?['username'] ?? '',
      description: data?['description'] ?? '',
      age: data?['age'] ?? 0,
      avatar: data?['avatar'] ?? '',
      beers: (data?['beers'] ?? [])
          .map<Beer>((beerData) => Beer(
                link: beerData?['link'] ?? '',
                name: beerData?['name'] ?? '',
              ))
          .toList(),
      gender: data?['gender'] ?? '',
      interest: data?['interest'] ?? '',
      isGlobal: data?['isGlobal'] ?? false,
      isLocal: data?['isLocal'] ?? false,
      location: Location(
        label: data?['location']?['label'] ?? '',
        position: Position(
          coordinates: (data?['location']?['position']?['coordinates'] ?? [])
              .cast<double>(),
          geohash: data?['location']?['position']?['geohash'] ?? '',
        ),
      ),
      range: data?['range'] ?? 0,
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

  @override
  List<Object?> get props => [
        link,
        name,
      ];
}

class Location extends Equatable {
  final String label;
  final Position position;

  const Location({
    required this.label,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'position': position.toMap(),
    };
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

  Map<String, dynamic> toMap() {
    return {
      'coordinates': coordinates,
      'geohash': geohash,
    };
  }

  @override
  List<Object?> get props => [
        coordinates,
        geohash,
      ];
}
