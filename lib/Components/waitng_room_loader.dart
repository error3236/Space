import 'package:flash/Themes/app_colors.dart';
import 'package:flutter/material.dart';

class WaitingRoomLoader extends StatelessWidget {
  const WaitingRoomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Text("Wait for users to join"),
      ),
    );
  }
}