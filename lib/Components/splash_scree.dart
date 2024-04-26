import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash/Database/Firebase/users_repo.dart';
import 'package:flash/Model/user.dart';
import 'package:flash/Pages/Home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool busy = false;
  @override
  void initState() {
    // TODO: implement initState

    delaySplashscreen();
    super.initState();
  }

  void delaySplashscreen() async {
    await Future.delayed(const Duration(seconds: 3));
    final currentUser = await UsersRepo().getCurrentUser();
    if (currentUser==null) {
      var uuid = const Uuid();
      String uid = uuid.v1();
      final user = User.fromJson({"uid": uid});
      await UsersRepo().saveCurrentUser(user);
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) {
          return const HomePage();
        },
      ), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero(
            //    tag: "sat",
            //   child: AnimatedContainer(
            //    curve: Curves.easeIn,
            //     duration: Duration(seconds: 3),
            //     height: busy?350:0,
            //     width:  busy?350:0,
            //     child: Image.asset("assets/images/saturn.png",)),
            // ),
            AnimatedTextKit(totalRepeatCount: 1, animatedTexts: [
              FadeAnimatedText(
                  duration: const Duration(seconds: 3),
                  "S P A C E",
                  textStyle: const TextStyle(fontSize: 25))
            ])
          ],
        )),
      ),
    );
  }
}
