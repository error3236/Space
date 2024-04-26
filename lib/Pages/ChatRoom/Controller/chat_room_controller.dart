import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/Components/app_loader.dart';
import 'package:flash/Database/Firebase/users_repo.dart';
import 'package:flash/Pages/ChatRoom/Controller/rejoined_or_host_waitng_lobby.dart';

import 'package:flutter/material.dart';

class ChatRoomController extends StatefulWidget {
  const ChatRoomController({
    super.key,
  });

  @override
  State<ChatRoomController> createState() => _ChatRoomControllerState();
}

class _ChatRoomControllerState extends State<ChatRoomController> {
 
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String chatRoomId = "", reciverID = "";
  bool isJoinableLobby = false;
  bool isUserLobbyExist = false;
  bool newLobby = false;
  final Timestamp timestamp = Timestamp.now();
  List availableRooms = [];

  @override
  void initState() {
    // TODO: implement initState
    initializeSaturn();
    super.initState();
  }

  void initializeSaturn() async {
    final currentUser = await UsersRepo().getCurrentUser();
    setState(() {
      isJoinableLobby = false;
      isUserLobbyExist = false;
      newLobby = false;
      chatRoomId = "";
    });
    CollectionReference chatRoomCollection = firestore.collection("ChatRoom");
    QuerySnapshot querySnapshot = await chatRoomCollection.get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;

      if (documentData["user2"] == "" &&
          documentData["user1"] != currentUser!.uid) {
        availableRooms.add(documentData["user1"]);
      }
    }
    if (availableRooms.isEmpty) {
      hostLobby(currentUserUid: currentUser!.uid);
    } else {
      String docID = availableRooms.first;
      availableRooms.remove(docID);
      joinLobby(docID: docID, currentUserUid: currentUser!.uid);
    }
  }

  void navigatePage() async {
    if (isJoinableLobby) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RejoinedAndHostWaitingRoom(chatRoomId: chatRoomId)),
      );
    } else if (newLobby) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RejoinedAndHostWaitingRoom(chatRoomId: chatRoomId)),
      );
    } else if (isUserLobbyExist) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RejoinedAndHostWaitingRoom(chatRoomId: chatRoomId)),
      );
    } else {}
  }

  void joinLobby({String? docID, String? currentUserUid}) async {
    CollectionReference chatRoomCollection = firestore.collection("ChatRoom");
    await chatRoomCollection.doc(docID).get().then((value) {});
    await chatRoomCollection.doc(docID).update({"user2": currentUserUid});
    setState(() {
      isJoinableLobby = true;
      chatRoomId = docID!;
    });
    navigatePage();
  }

  void rejoinexistingLobby({required String currentUserUid}) async {
    CollectionReference chatRoomCollection = firestore.collection("ChatRoom");
    chatRoomCollection
        .doc(currentUserUid)
        .update({"user1": currentUserUid, "user2": ""});
    setState(() {
      isUserLobbyExist = true;
      chatRoomId =currentUserUid;
    });
    navigatePage();
  }

  void hostLobby({String? currentUserUid}) async {
    CollectionReference chatRoomCollection = firestore.collection("ChatRoom");
    await chatRoomCollection
        .doc(currentUserUid)
        .set({"user1": currentUserUid, "user2": "", "TimeStamp": timestamp});
    setState(() {
      chatRoomId = currentUserUid!;
      newLobby = true;
    });
    navigatePage();
  }

  @override
  Widget build(BuildContext context) {
    return const AppLoader();
  }
}
