import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/Components/chat_leave_aleart.dart';
import 'package:flash/Components/chat_textfield.dart';
import 'package:flash/Components/waitng_room_loader.dart';
import 'package:flash/Database/Firebase/users_repo.dart';
import 'package:flash/Pages/ChatRoom/Controller/chat_room_controller.dart';
import 'package:flash/Pages/Home/home_page.dart';
import 'package:flash/Services/chat_service.dart';
import 'package:flash/Themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class JoinedChatRoom extends StatefulWidget {
  final String chatRoomID;
  const JoinedChatRoom({super.key, required this.chatRoomID});

  @override
  State<JoinedChatRoom> createState() => _JoinedChatRoomState();
}

class _JoinedChatRoomState extends State<JoinedChatRoom> {
  String recieverID = "", senderID = "";
  FocusNode focusNode = FocusNode();
  bool isLoading = false;
  bool canPop = false;
  String uUid="";
  @override
  void initState() {
    // TODO: implement initState

    secureScreen();
    checkUser();
    super.initState();
  }

  void secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
    focusNode.addListener(() {
      Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
        () => scrollDown(),
      );
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();
  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void checkUser() async {
    final currentUser = await UsersRepo().getCurrentUser();
    setState(() {
      isLoading = true;
      uUid=currentUser!.uid!;
    });

    await firestore
        .collection("ChatRoom")
        .doc(widget.chatRoomID)
        .get()
        .then((value) {
      if (value["user1"] ==currentUser!.uid) {
        setState(() {
          recieverID = value["user2"];
        });
      } else {
        setState(() {
          recieverID = value["user1"];
        });
        final Stream<DocumentSnapshot> stream =
            firestore.collection("ChatRoom").doc(widget.chatRoomID).snapshots();
        stream.listen((event) {
          if (!event.exists) {
            leaveSpace(hostLeft: true);
          }
          if (event["user2"] == "") {
            joinedUserleft();
          }
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void joinedUserleft() async {
     final currentUser = await UsersRepo().getCurrentUser();
    final QuerySnapshot messages = await firestore
        .collection("ChatRoom")
        .doc(widget.chatRoomID)
        .collection("messages")
        .get();
    if (messages.docs.isNotEmpty) {
      for (DocumentSnapshot msg in messages.docs) {
        msg.reference.delete();
      }
    }
    if (widget.chatRoomID == currentUser!.uid) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ChatRoomController()),
        (Route<dynamic> route) => false,
      );
    }
  }

  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
        cUid: uUid,
          chatRoomId: widget.chatRoomID,
          message: messageController.text.trim(),
          reciverID: recieverID);

      messageController.clear();
    }
    scrollDown();
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
        .doc(widget.chatRoomID)
        .get()
        .then((value) async {
      if (value["user1"] ==currentUser!.uid) {
        final QuerySnapshot snapshot = await firestore
            .collection("ChatRoom")
            .doc(widget.chatRoomID)
            .collection("messages")
            .get();
        if (snapshot.docs.isNotEmpty) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        }
        await firestore.collection("ChatRoom").doc(widget.chatRoomID).delete();
        setState(() {
          canPop = true;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      } else {
        await firestore
            .collection("ChatRoom")
            .doc(widget.chatRoomID)
            .update({"user1": value["user1"], "user2": ""});
        setState(() {
          canPop = true;
        });

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
    if (isLoading) {
      return const WaitingRoomLoader();
    } else {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          showDialog(
            context: context,
            builder: (context) {
              return ChatLeaveAleart(
                  onPressed: leaveSpace, text: "Your about leave your space");
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.primary,
              title: const Text("S P A C E")),
          backgroundColor: AppColors.primary,
          body: Column(
            children: [
              Expanded(child: buildMessageList()),
              buildMessageInput()
            ],
          ),
        ),
      );
    }
  }

  Widget buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(widget.chatRoomID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          controller: scrollController,
          children: snapshot.data!.docs
              .map((document) => buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot documentSnapshot) {
    
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    var aligment = (data['SenderId'] == uUid
        ? Alignment.centerRight
        : Alignment.centerLeft);
    return Container(
      alignment: aligment,
      child: BubbleSpecialThree(
        isSender: aligment == Alignment.centerRight ? true : false,
        text: data["Message"],
        color: aligment == Alignment.centerRight
            ? AppColors.saturnWhite
            : AppColors.blackAccent,
        tail: true,
        textStyle: TextStyle(
            color: aligment == Alignment.centerRight
                ? AppColors.primary
                : Colors.white,
            fontSize: 16),
      ),
    );
  }

  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        children: [
          Expanded(
            child: ChatTextField(
              focusNode: focusNode,
              controller: messageController,
              hintText: "Send Message",
            ),
          ),
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                CupertinoIcons.arrow_up_circle_fill,
                size: 40,
                color: AppColors.saturnWhite,
              ))
        ],
      ),
    );
  }
}
