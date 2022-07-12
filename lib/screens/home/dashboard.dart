import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selfservice/widget/Calendar.dart';

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tableau de Bord'),
        centerTitle: true,
        backgroundColor: Color(0xffF4925D),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 37% of our total height
            height: size.height * .30,
            decoration: const BoxDecoration(
              color: Color(0xffF4925D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              )
            ),
          ),
          Calendar()
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String stat ;
  final IconData icon;
  final Color color;
  const StatCard({
    Key? key,required this.title,required this.stat,required this.icon,required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        //margin: const EdgeInsets.only(top:5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 17,
              spreadRadius: -23,
              color: Colors.black,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            const Spacer(),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Icon(icon,
                 size: 50, 
                 color: color,
                 ),
                 const SizedBox(
                   width:10,
                 ),
                 Text(stat,
                 style:TextStyle(
                   color: color,
                   fontSize: 40.0,
                 ) ,)
               ],
             ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style:const TextStyle(
                        fontWeight: FontWeight.bold,
                      )

              ),
            )
          ],
        ),
      ),
    );
  }
}

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

