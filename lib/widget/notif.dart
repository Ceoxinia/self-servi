import 'package:flutter/material.dart';

String getInitials(String bankAccountName) => bankAccountName.isNotEmpty
    ? bankAccountName.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
    : '';
Widget notif(String Nom, String Etat, String date, String nature) {
  return Container(
      height: 90,
      padding: EdgeInsets.only(top: 10),
      margin: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 12, color: Colors.black45, spreadRadius: -8)
          ],
          borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xffe46b10),
          child: Text(getInitials(Nom),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              )),
          minRadius: 20,
          maxRadius: 30,
        ),
        title: nature == "Demande"
            ? Text(
                '$Nom a envoye une demande',
                style: Etat == "New"
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : TextStyle(),
              )
            : Text(
                '$Nom a repondu ',
                style: Etat == "New"
                    ? TextStyle(fontWeight: FontWeight.bold)
                    : TextStyle(),
              ),
        subtitle: Text(
          '$date',
          style: Etat == "New"
              ? TextStyle(fontWeight: FontWeight.bold)
              : TextStyle(),
        ),
        trailing: Icon(Icons.more_vert),
      ));
}
