import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/Database/Firebase/users_repo.dart';
import 'package:flash/Pages/ChatRoom/Controller/chat_room_controller.dart';
import 'package:flash/Pages/ChatRoom/Controller/joinfrom_available_space.dart';
import 'package:flash/Services/chat_service.dart';
import 'package:flash/Themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatService chatService = ChatService();
  bool isFlying = false;
  final Timestamp timestamp = Timestamp.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('S P A C E'),
         ),
      body: SafeArea(
          child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const ChatRoomController();
                          },
                        ));
                      },
                      child: SizedBox(
                          height: 250,
                          width: 250,
                          child: LottieBuilder.asset(
                            'assets/animations/pulse.json',
                            fit: BoxFit.cover,
                          ))),
                  const Text("Tap into space"),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StreamBuilder(
                        stream: chatService.getRooms(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                              height: 600,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.secondaryBlack,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18))),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.saturnWhite,
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            
                            List roomList = snapshot.data!.docs;
                            List<DocumentSnapshot> availableRoom = [];
                            for (var doc in roomList) {
                              if (doc["user2"] == "") {
                                availableRoom.add(doc);
                              }
                            }
                            if (availableRoom.length != 0) {
                              return SizedBox(
                                height: 600,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: AppColors.secondaryBlack,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          topRight: Radius.circular(18))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      itemCount: availableRoom.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot data =
                                            availableRoom[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                border: Border(
                                                    top: BorderSide(
                                                        color:
                                                            AppColors.grey))),
                                            child: ListTile(
                                              onTap: () async {
                                                 final currentUser = await UsersRepo().getCurrentUser();
                                                await FirebaseFirestore.instance
                                                    .collection("ChatRoom")
                                                    .doc(data["user1"])
                                                    .update({
                                                  "TimeStamp": timestamp,
                                                  "user1": data["user1"],
                                                  "user2": currentUser!.uid
                                                });
                                                navigateToJoinPage(
                                                    data["user1"].toString());
                                              },
                                              leading: LottieBuilder.asset(
                                                'assets/animations/pulse.json',
                                                fit: BoxFit.cover,
                                              ),
                                              title: Text("Space $index"),
                                              trailing: const Text("1/2"),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 600,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: AppColors.secondaryBlack,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          topRight: Radius.circular(18))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("No available space!"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                 child: SizedBox(

                                  height: 50,
                                  width: 120,
                                   child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(color: AppColors.grey)),
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      color: AppColors.primary
                                    ),
                                    child: const Text("Host a Space"),
                                   ),
                                 ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatRoomController(),
                                        ));
                                  },
                                ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return SizedBox(
                              height: 600,
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.secondaryBlack,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18))),
                                child: InkWell(
                                 child: SizedBox(
                                  height: 50,
                                  width: 120,
                                   child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(color: AppColors.grey)),
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                      color: AppColors.primary
                                    ),
                                    child: const Text("Host a space"),
                                   ),
                                 ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChatRoomController(),
                                        ));
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                },
                icon: const Icon(
                  CupertinoIcons.chevron_up,
                  size: 40,
                ))
          ],
        ),
      )),
    );
  }

  void navigateToJoinPage(String roomId) {
    Navigator.push(context, MaterialPageRoute(
      builder: (ctx) {
        return JoinFromAvailableSpace(chatRoomId: roomId);
      },
    ));
  }
}
