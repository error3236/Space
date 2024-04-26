import 'package:flash/Themes/app_colors.dart';
import 'package:flutter/material.dart';


class SimpleAleart extends StatelessWidget {
  final String text;
  final String? optionalText;
  const SimpleAleart({this.optionalText, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor:Colors.transparent ,
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(2)),
      backgroundColor:AppColors.blackAccent,
      title: SizedBox(
        height: 200,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,),
            const SizedBox(
              height: 10,
            ),
            Text(optionalText ?? ''),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          color: AppColors.primary,
          onPressed: () {
            Navigator.pop(context);
          },
          child:  const Text(
            "Ok",
           
          ),
        )
      ],
    );
  }
}
