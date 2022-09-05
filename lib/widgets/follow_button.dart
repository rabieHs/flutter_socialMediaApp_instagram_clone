import 'package:flutter/material.dart';
class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color BackgroundColor;
  final Color BorderColor;
  final String text;
  final Color textColor;
  const FollowButton({Key? key,
    this.function,
  required this.text,
  required this.BorderColor,
  required this.BackgroundColor,
  required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: BackgroundColor,
            border: Border.all(color:BorderColor ),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(text,style: TextStyle(color: textColor,fontWeight: FontWeight.bold
          ),
          ),
          width: 250,
          height: 27,
        ),

      ),
    );
  }
}
