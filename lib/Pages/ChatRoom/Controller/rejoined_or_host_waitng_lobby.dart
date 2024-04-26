import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/Components/chat_leave_aleart.dart';
import 'package:flash/Database/Firebase/users_repo.dart';
import 'package:flash/Pages/ChatRoom/Pages/game.dart';
import 'package:flash/Pages/ChatRoom/Pages/joined_chat_room.dart';
import 'package:flash/Pages/Home/home_page.dart';
import 'package:flutter/material.dart';

class RejoinedAndHostWaitingRoom extends StatefulWidget {
  final String chatRoomId;
  const RejoinedAndHostWaitingRoom({super.key, required this.chatRoomId});

  @override
  State<RejoinedAndHostWaitingRoom> createState() =>
      _RejoinedAndHostWaitingRoomState();
}

class _RejoinedAndHostWaitingRoomState
    extends State<RejoinedAndHostWaitingRoom> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String user2 = "";

  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    checkUsers();
    super.initState();
  }

  void checkUsers() async {
    CollectionReference chatRoomCollection = firestore.collection("ChatRoom");
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
    // await chatRoomCollection.doc(widget.chatRoomId).get().then((value) {
    //   if (value["user2"] != "") {
    //     setState(() {
    //       user2 = value["user2"];
    //     });
    //   }
    // });
  }

  void leaveSpace({bool hostLeft = false}) async {
    final currentUser = await UsersRepo().getCurrentUser();
    if (hostLeft) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    }
    await firestore
        .collection("ChatRoom")
        .doc(currentUser!.uid)
        .get()
        .then((value) async {
      if (value["user1"] == currentUser.uid) {
        final QuerySnapshot snapshot = await firestore
            .collection("ChatRoom")
            .doc(currentUser.uid)
            .collection("messages")
            .get();
        if (snapshot.docs.isNotEmpty) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        }
        await firestore.collection("ChatRoom").doc(currentUser.uid).delete();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) {
          showDialog(
            context: context,
            builder: (context) {
              return ChatLeaveAleart(
                  onPressed: leaveSpace, text: "Your about leave your space");
            },
          );
        },
        canPop: false,
        child: SpaceShipGamePage());
  }
}
