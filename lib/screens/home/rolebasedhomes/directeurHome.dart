import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:selfservice/screens/home/dashboard.dart';
import 'package:selfservice/screens/home/form/form.dart';
import 'package:selfservice/screens/home/form/history.dart';
import 'package:selfservice/screens/home/profile.dart';

class directeurHome extends StatefulWidget {
  directeurHome({Key? key}) : super(key: key);

  @override
  State<directeurHome> createState() => _directeurHomeState();
}

class _directeurHomeState extends State<directeurHome> {
  int index = 0;

  final screens = [
    dashboard(),
    history(),
    utilisateur(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color(0xffF4925D),
        buttonBackgroundColor: Color(0xffF4925D),
        height: 60,
        animationDuration: Duration(
          milliseconds: 200,
        ),
        index: index, //.. default start position for icon
        animationCurve: Curves.bounceInOut,
        items: <Widget>[
          Icon(
            Icons.dashboard,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.history,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.account_circle_outlined,
            size: 30,
            color: Colors.white,
          ),
          /*  Icon(
            Icons.logout,
            size: 30,
            color: Colors.white,
          ),*/
        ],

        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }
}
