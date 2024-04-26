import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/Components/app_loader.dart';
import 'package:flash/Database/Firebase/users_repo.dart';
import 'package:flash/Pages/ChatRoom/Controller/rejoined_or_host_waitng_lobby.dart';
import 'package:flash/Pages/ChatRoom/Pages/joined_chat_room.dart';
import 'package:flutter/material.dart';

class JoinFromAvailableSpace extends StatefulWidget {
  final String chatRoomId;
  const JoinFromAvailableSpace({super.key, required this.chatRoomId});

  @override
  State<JoinFromAvailableSpace> createState() => _JoinFromAvailableSpaceState();
}

class _JoinFromAvailableSpaceState extends State<JoinFromAvailableSpace> {
  @override
  void initState() {
    // TODO: implement initState
    joinSpace();
    super.initState();
  }

  void joinSpace() async {
     final currentUser = await UsersRepo().getCurrentUser();
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(widget.chatRoomId)
        .update({
      "user1": widget.chatRoomId,
      "user2": currentUser!.uid
    });
    CollectionReference chatRoomCollection =
        FirebaseFirestore.instance.collection("ChatRoom");
    final Stream<DocumentSnapshot> stream =
        chatRoomCollection.doc(widget.chatRoomId).snapshots();
    stream.listen((event) {
      if (event.get("user2") != "") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => JoinedChatRoom(
                    chatRoomID: widget.chatRoomId,
                  )),
        );
      }
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RejoinedAndHostWaitingRoom(chatRoomId: widget.chatRoomId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AppLoader();
  }
}
