import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget Responsable(String name, String directeur, context, String Secretaire) {
  return Column(children: [
    Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      width: Secretaire != 'personnel'
          ? MediaQuery.of(context).size.width - 50
          : MediaQuery.of(context).size.width / 2 - 20,
      height: MediaQuery.of(context).size.width / 2 - 80,
      decoration: BoxDecoration(
          color: Color(0xffF4925D),
          boxShadow: [
            BoxShadow(
                blurRadius: 18,
                color: Color.fromARGB(115, 128, 107, 2),
                spreadRadius: -8)
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(children: [
          Icon(Icons.account_circle_outlined, color: Colors.white, size: 35),
          directeur == 'directeur'
              ? Text(
                  'Votre Directeur :',
                  style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255)),
                )
              : Text(
                  'Votre Responsable :',
                  style: GoogleFonts.openSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
        ]),
        ListTile(
          title: Text(
            name,
            style: GoogleFonts.openSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ]),
    ),
    Container(),
  ]);
}
