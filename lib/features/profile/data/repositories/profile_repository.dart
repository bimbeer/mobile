import 'dart:async';
import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  Profile? _cachedProfile;

  Profile get currentProfile => _cachedProfile ?? Profile.empty;

  Stream<Profile> profileStream(String id) {
    final docRef = _db.collection('profile').doc(id);
    return docRef.snapshots().map((doc) => Profile.fromSnapshot(doc)).asBroadcastStream();
  }

  Future<Profile> get(String id) async {
    final docRef = _db.collection('profile').doc(id);
    final snapshot = await docRef.get();
    late Profile profile;
    if (snapshot.exists) {
      profile = Profile.fromSnapshot(snapshot);
    } else {
      profile = Profile.empty;
    }
    _updateCache(profile);
    return profile;
  }

  Future<void> edit({required String id, required Profile profile}) async {
    final docRef = _db.collection('profile').doc(id);
    await docRef.update(profile.toMap());
    _updateCache(profile);
  }

  void _updateCache(Profile profile) {
    _cachedProfile = profile;
  }
}
