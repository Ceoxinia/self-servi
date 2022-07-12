import 'package:flutter/material.dart';
import 'package:selfservice/models/user.dart';

String getInitials(String bankAccountName) => bankAccountName.isNotEmpty
    ? bankAccountName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
    : '';
Widget info(User user) {
  return Column(children: <Widget>[
    CircleAvatar(
      backgroundColor: Color(0xffe46b10),
      child: Text(getInitials(user.name), style: TextStyle(fontSize: 30)),
      minRadius: 30,
      maxRadius: 50,
    ),
    Center(
        child: ListTile(
      title: Text(
        user.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.SON,
      ),
    ))
  ]);
}
