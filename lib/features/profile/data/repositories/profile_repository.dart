import 'package:bimbeer/features/profile/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRepository {
  ProfileRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Stream<Profile> getProfile(String id) {
    final docRef = _db.collection('profile').doc(id);
    return docRef.snapshots().map((doc) {
      if (doc.exists) {
        return Profile.fromSnapshot(doc);
      } else {
        return Profile.empty;
      }
    });
  }

  Future<void> editProfile({required String id, required Profile profile}) async {
    final docRef = _db.collection('profile').doc(id);
    await docRef.update(profile.toMap());
  }
}
