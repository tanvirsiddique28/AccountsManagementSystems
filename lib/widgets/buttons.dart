import 'package:flutter/material.dart';
Widget Buttons({height,width,String?title,onPress}){


  return ElevatedButton(
      onPressed: onPress,
      child: Text(title!),
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.green,
      minimumSize: Size(width, height),
    ),
  );
}