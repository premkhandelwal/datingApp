import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/logic/data/conversations.dart';
import 'package:dating_app/logic/data/message.dart';
import 'package:dating_app/logic/data/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DbServices {
  Stream<List<CurrentUser>?>? getUsers() {
    return FirebaseFirestore.instance
        .collection('UserActivity')
        .orderBy('name')
        .snapshots()
        .map((event) => event.docs.map((e) {
              print(e);
              return CurrentUser.fromMap(e.data());
            }).toList());
  }

  Stream<CurrentUser>? getCurrentUser() {
    return FirebaseFirestore.instance
        .collection('UserActivity')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => CurrentUser.fromMap(e.data())).toList()[0]);
  }

  Stream<List<Message>?>? getMessages(String chatid) {
    if (chatid == "") {
      return null;
    }
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatid)
        .collection('messages')
        .orderBy('sendTime', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Message.fromFirestore(e)).toList());
  }

  Stream<List<Conversations>?>? getConversations() {
    return FirebaseFirestore.instance
        .collection('UserActivity')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('conversations')
        .orderBy('sendTime', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => Conversations.fromJson(e.data())).toList());
  }

  Future<void> updateSeenStatus(String userId) async {
    await FirebaseFirestore.instance
        .collection('UserActivity')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('conversations')
        .doc(userId)
        .update({
      'status': 'seen',
    });
  }

  Future<void> sendMessage(String chatid, Message message) async {
    Conversations senderConversation =
        Conversations.fromSenderMessage(message, chatid);
    Conversations recieverConversation =
        Conversations.fromRecieverMessage(message, chatid);
    if (message is TextMessage) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .add(message.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.from)
          .collection('conversations')
          .doc(message.to)
          .set(recieverConversation.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.to)
          .collection('conversations')
          .doc(message.from)
          .set(senderConversation.toMap());
    } else if (message is ImageMessage) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .add(message.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.from)
          .collection('conversations')
          .doc(message.to)
          .set(recieverConversation.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.to)
          .collection('conversations')
          .doc(message.from)
          .set(senderConversation.toMap());
    } else if (message is GifMessage) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .add(message.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.from)
          .collection('conversations')
          .doc(message.to)
          .set(recieverConversation.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.to)
          .collection('conversations')
          .doc(message.from)
          .set(senderConversation.toMap());
    } else if (message is VideoMessage) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .add(message.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.from)
          .collection('conversations')
          .doc(message.to)
          .set(recieverConversation.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.to)
          .collection('conversations')
          .doc(message.from)
          .set(senderConversation.toMap());
    } else if (message is DocumentMessage) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .add(message.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.from)
          .collection('conversations')
          .doc(message.to)
          .set(recieverConversation.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.to)
          .collection('conversations')
          .doc(message.from)
          .set(senderConversation.toMap());
    } else if (message is AudioMessage) {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatid)
          .collection('messages')
          .add(message.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.from)
          .collection('conversations')
          .doc(message.to)
          .set(recieverConversation.toMap());
      await FirebaseFirestore.instance
          .collection('UserActivity')
          .doc(message.to)
          .collection('conversations')
          .doc(message.from)
          .set(senderConversation.toMap());
    }
  }

  Future<void> userStatusOnline() async {
    FirebaseFirestore.instance
        .collection('UserActivity')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'status': 'Online'});
  }

  Future<void> userStatusOffline() async {
    FirebaseFirestore.instance
        .collection('UserActivity')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'status': 'Offline'});
  }

  Future<void> saveTokenToDatabase(String token) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('UserActivity')
        .doc(userId)
        .collection('deviceTokens')
        .doc('deviceTokens')
        .set({
      'tokens': FieldValue.arrayUnion([token]),
    }, SetOptions(merge: true));
  }

  Future<void> deleteTokenFromDatabase() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String? token = await FirebaseMessaging.instance.getToken();

    await FirebaseFirestore.instance
        .collection('UserActivity')
        .doc(userId)
        .collection('deviceTokens')
        .doc('deviceTokens')
        .set({
      'tokens': FieldValue.arrayRemove([token]),
    }, SetOptions(merge: true));
    FirebaseMessaging.instance.deleteToken();
  }
}
