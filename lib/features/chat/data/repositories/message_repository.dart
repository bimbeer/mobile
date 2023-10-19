import 'package:bimbeer/features/chat/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRepository {
  MessageRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<void> addMessage(Message message) {
    return _db.collection('messages').doc().set(message.toMap());
  }

  Future<List<Message>> getMessages(String senderId, String recipientId) async {
    final snapshot = await _db
        .collection('messages')
        .where(Filter.and(Filter('uid', isEqualTo: senderId),
            Filter('pairId', isEqualTo: recipientId)))
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList();
  }

  Stream<List<Message>> messagesStream(String senderId, String recipientId) {
    return _db
        .collection('messages')
        .where(Filter.and(Filter('uid', isEqualTo: senderId),
            Filter('pairId', isEqualTo: recipientId)))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }
}
