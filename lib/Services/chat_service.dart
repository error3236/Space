import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/Model/message.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth user = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

//Send Message
  Future<void> sendMessage(
      {required String reciverID,
      required String message,
      required String chatRoomId,
      required String cUid}) async {
    final String currentUserId = cUid;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        message: message,
        timestamp: timestamp,
        reciverID: reciverID,
        senderID: currentUserId);

    await firestore
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //Get message
  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return firestore
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('TimeStamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getRooms() {
    return firestore
        .collection("ChatRoom")
        .orderBy('TimeStamp', descending: false)
        .snapshots();
  }
}
