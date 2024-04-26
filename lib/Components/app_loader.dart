
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child:SizedBox(
                      height: 250,
                      width: 250,
                      child: LottieBuilder.asset('assets/animations/pulse.json',fit: BoxFit.cover,))
    );
  }
}