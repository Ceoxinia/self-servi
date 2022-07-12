import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget title(
  String title,
) {
  return Container(
    margin: const EdgeInsets.only(left: 25, top: 15, bottom: 16),
    child: Text(title,
        style: GoogleFonts.openSans(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: Color(0xffF4925D))),
  );
}
