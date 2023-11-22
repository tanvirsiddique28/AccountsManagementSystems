import 'package:flutter/material.dart';

Widget customsTextFormField(String?title,controller){
  return  TextFormField(
    controller: controller,
    decoration: InputDecoration(
        labelText: title!,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        )
    ),
  );
}