import 'dart:async';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:bimbeer/features/profile/models/profile_match.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide GeoPoint;
import 'package:flutter_geo_hash/geohash.dart';

import '../../models/matching_profile.dart';
import '../../utils/profile_matching_utils.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  Profile? _cachedProfile;

  Profile get currentProfile => _cachedProfile ?? Profile.empty;

  Stream<Profile> profileStream(String id) {
    if (id == '') return const Stream.empty();
    final docRef = _db.collection('profile').doc(id);
    return docRef
        .snapshots()
        .map((doc) => Profile.fromJson(doc.data()!))
        .asBroadcastStream();
  }

  Future<Profile> get(String id) async {
    if (id == '') return Profile.empty;
    final docRef = _db.collection('profile').doc(id);
    final snapshot = await docRef.get();
    late Profile profile;
    if (snapshot.exists) {
      profile = Profile.fromJson(snapshot.data()!);
    } else {
      profile = Profile.empty;
    }
    _updateCache(profile);
    return profile;
  }

  Future<void> add(String id, Profile profile) async {
    final docRef = _db.collection('profile').doc(id);
    await docRef.set(profile.toMap());
    _updateCache(profile);
  }

  Future<void> edit({required String id, required Profile profile}) async {
    final docRef = _db.collection('profile').doc(id);
    await docRef.update(profile.toMap());
    _updateCache(profile);
  }

  Future<List<MatchingProfile>> getMatchingProfiles(String id) async {
    final profile = _cachedProfile ?? await get(id);
    final latitude = profile.location?.position?.coordinates[0];
    final longtitude = profile.location?.position?.coordinates[1];

    final geoPoint = GeoPoint(latitude!, longtitude!);
    final geohashPrefixes = MyGeoHash()
        .geohashQueryBounds(geoPoint, profile.range!.toDouble() * 1000);

    final queries = geohashPrefixes.map((prefix) {
      final query = _db
          .collection('profile')
          .where('location.position.geohash', isGreaterThanOrEqualTo: prefix[0])
          .where('location.position.geohash', isLessThan: prefix[1])
          .where('beers',
              arrayContainsAny: profile.beers?.map((beer) => beer.toMap()));

      return query.get();
    });

    final querySnapshots = await Future.wait(queries);
    final matchedProfiles = <MatchingProfile>[];

    for (final querySnapshot in querySnapshots) {
      for (final document in querySnapshot.docs) {
        final potentialMatchId = document.id;
        final matchingProfile = MatchingProfile(
            potentialMatchId, Profile.fromJson(document.data()));

        final currentInteractions = await _db
            .collection('interactions')
            .where('sender', isEqualTo: id)
            .where('recipient', isEqualTo: potentialMatchId)
            .get();
        if (currentInteractions.docs.isNotEmpty) return matchedProfiles;

        final currentReverseInteractions = await _db
            .collection('interactions')
            .where('recipient', isEqualTo: id)
            .where('sender', isEqualTo: potentialMatchId)
            .get();
        if (currentReverseInteractions.docs.isNotEmpty) return matchedProfiles;

        if (potentialMatchId != id) {
          if (_isMatch(profile, matchingProfile.profile)) {
            matchedProfiles.add(MatchingProfile(potentialMatchId, profile));
          }
        }
      }
    }

    return matchedProfiles;
  }

  bool _isMatch(Profile profile, Profile other) {
    final geoPoint = GeoPoint(profile.location!.position!.coordinates[0],
        profile.location!.position!.coordinates[1]);

    final otherGeoPoint = GeoPoint(other.location!.position!.coordinates[0],
        other.location!.position!.coordinates[1]);

    final distance = MyGeoHash().distanceBetween(
      otherGeoPoint,
      geoPoint,
    );

    if (distance <= other.range!) {
      final profileMatch = ProfileMatch(other.gender!, other.interest!);
      final potentialMatches =
          getPotentialMatches(profile.gender, profile.interest);

      for (final potentialMatch in potentialMatches) {
        if (profileMatch == potentialMatch) {
          return true;
        }
      }
    }
    return false;
  }

  void _updateCache(Profile profile) {
    _cachedProfile = profile;
  }
}
