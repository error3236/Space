import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String message,senderID,reciverID;
  final Timestamp timestamp;
  Message({required this.message,required this.timestamp,required this.senderID,required this.reciverID});


  Map<String,dynamic> toMap(){
    return{
      "Message":message,
      "TimeStamp":timestamp,
      "SenderId":senderID,
      "ReciverId":reciverID

    };
  }
}