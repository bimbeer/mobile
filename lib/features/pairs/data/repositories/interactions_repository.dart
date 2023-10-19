import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/interaction.dart';

class InteractionsRepository {
  InteractionsRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<void> addInteraction(Interaction interaction) {
    return _db.collection('interactions').doc().set(interaction.toMap());
  }

  Future<void> updateInteraction(String id, Interaction interaction) async {
    return _db.collection('interactions').doc(id).update(interaction.toMap());
  }

  Future<void> deleteInteraction(String id) {
    return _db.collection('interactions').doc(id).delete();
  }

  Future<List<Interaction>> getAllInteractionsForUser(String userId) async {
    final snapshot = await _db
        .collection('interactions')
        .where(Filter.or(Filter('sender', isEqualTo: userId),
            Filter('recipient', isEqualTo: userId)))
        .get();

    return snapshot.docs
        .map((doc) => Interaction.fromJson(doc.data()))
        .toList();
  }

  Stream<List<Interaction>> getInteractionsByRecipient(String recipientId) {
    return _db
        .collection('interactions')
        .where('recipient', isEqualTo: recipientId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Interaction.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Interaction>> getInteractionsBySender(String senderId) {
    return _db
        .collection('interactions')
        .where('sender', isEqualTo: senderId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Interaction.fromJson(doc.data()))
            .toList());
  }

  Stream<List<Interaction>> interactionsStreamForUser(String userId) {
    return _db
        .collection('interactions')
        .where(Filter.or(Filter('sender', isEqualTo: userId),
            Filter('recipient', isEqualTo: userId)))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Interaction.fromJson(doc.data()))
            .toList());
  }
}
