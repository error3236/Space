import 'dart:math';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flash/Themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SpaceShipGamePage extends StatefulWidget {
  @override
  _SpaceShipGamePageState createState() => _SpaceShipGamePageState();
}

class _SpaceShipGamePageState extends State<SpaceShipGamePage> {
  double shipX = 200;
  double shipY = 200;
  double pulsex = 250;
  double pulsey = 250;
  double shipRotation = 0; // 0 is up, 90 is right, 180 is down, 270 is left
  bool colide = false;
  int score=0;
  void moveUp() {
   
    setState(() {
      shipY -= 10;
      shipRotation = 0;
    });
    colided();
  }

  void moveDown() {
 
    setState(() {
      shipY += 10;
      shipRotation = 180;
    });
    colided();
  }

  void moveLeft() {

    setState(() {
      shipX -= 10;
      shipRotation = 270;
    });
    colided();
  }

  void moveRight() {
    setState(() {
      shipX += 10;
      shipRotation = 90;
    });
    colided();
  }

  void colided() {
    if (shipX == pulsex && shipY == pulsey) {
       Audio.load('sounds/pop.mp3')..play()..dispose();

      setState(() {
        colide = true;
        score++;
      });

      newPulse();
    }
  }

  int generateRandomMultipleOfTen(int min, int max) {
    final random = Random();
    // Ensure the range is adjusted to multiples of 10
    int adjustedMin = (min / 10).ceil() * 10;
    int adjustedMax = (max / 10).floor() * 10;
    if (adjustedMin > adjustedMax) {
      throw ArgumentError('No multiples of 10 in the given range.');
    }

    return ((adjustedMin ~/ 10) +
            random.nextInt((adjustedMax ~/ 10) - (adjustedMin ~/ 10) + 1)) *
        10;
  }

  void newPulse() {
    int randomNumber = generateRandomMultipleOfTen(50, 350);
    setState(() {
      pulsex = randomNumber.toDouble();
      pulsey = randomNumber.toDouble();
      colide = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
           Positioned.fill(
                  child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text("SCORE $score",style: TextStyle(fontSize: 20),),
                ),
              )),
              if (!colide)
                Positioned(
                  left: pulsex,
                  top: pulsey,
                  child: Transform.rotate(
                      angle: shipRotation * 3.141592653589793238 / 180,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Lottie.asset("assets/animations/pulse.json"),
                      )),
                ),
              Positioned(
                left: shipX,
                top: shipY,
                child: Transform.rotate(
                    angle: shipRotation * 3.141592653589793238 / 180,
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset("assets/images/spaceship.png"),
                    )),
              ),
              const Positioned.fill(
                  child: Align(
                alignment: Alignment.center,
                child: Text("Wait for someone to join your space!",style: TextStyle(fontSize: 18),),
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.grey)),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: moveUp,
                child: const Icon(
                  CupertinoIcons.chevron_up,
                  color: AppColors.saturnWhite,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      border: Border(left: BorderSide(color: AppColors.grey)),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    onPressed: moveLeft,
                    child: const Icon(
                      CupertinoIcons.chevron_left,
                      color: AppColors.saturnWhite,
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(right:  BorderSide(color: AppColors.grey)),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: FloatingActionButton(
                    backgroundColor: AppColors.primary,
                    onPressed: moveRight,
                    child: const Icon(
                      CupertinoIcons.chevron_right,
                      color: AppColors.saturnWhite,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.grey)),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: FloatingActionButton(
                backgroundColor: AppColors.primary,
                onPressed: moveDown,
                child: const Icon(
                  CupertinoIcons.chevron_down,
                  color: AppColors.saturnWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
