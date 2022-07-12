import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selfservice/widget/profileinfo.dart';
import 'package:selfservice/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// still didn't finish the UI and make the secretaire / responsable / personel /directeur difference
class utilisateur extends StatefulWidget {
  utilisateur({Key? key}) : super(key: key);

  @override
  State<utilisateur> createState() => _utilisateurState();
}

class User {
  String uid;
  final String name;
  final String department;
  final String directeur;
  final String responsable;
  final String SON;
  final String role;
  final String structur;
  final String mail;
  final String gender;

  User({
    this.uid = '',
    required this.name,
    required this.department,
    required this.SON,
    required this.directeur,
    required this.responsable,
    required this.role,
    required this.structur,
    required this.mail,
    required this.gender,
  });
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'SON': SON,
        'role': role,
        'structur': structur,
        'directeur': directeur,
        'responsable': responsable,
        'department': department,
        'mail': mail,
        'gender': gender,
      };
  static User fromJson(Map<String, dynamic> json) => User(
      uid: json['uid'],
      name: json['name'],
      SON: json['SON'],
      role: json['Role'],
      structur: json['structure'],
      directeur: json['directeur'],
      responsable: json['responsable'],
      department: json['departement'],
      mail: json['email'],
      gender: json['gender']);
}

class _utilisateurState extends State<utilisateur> {
  Widget textfield({@required hintText}) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xffF4925D),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        backgroundColor: Colors.transparent,
        body: StreamBuilder<List<User>>(
            stream: readUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went Wrong ${snapshot.error}');
              } else if (snapshot.hasData) {
                final users = snapshot.data!;
                return ListView(
                  children: users.map(info).toList(),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      );
  String getInitials(String bankAccountName) => bankAccountName.isNotEmpty
      ? bankAccountName
          .trim()
          .split(RegExp(' +'))
          .map((s) => s[0])
          .take(2)
          .join()
      : '';
  Widget info(User user) {
    return Stack(children: <Widget>[
      CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        painter: HeaderCurvedContainer(),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Profile",
              style: TextStyle(
                fontSize: 35,
                letterSpacing: 1.5,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 5),
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: user.gender == "femme"
                      ? AssetImage('assets/femme.png')
                      : AssetImage('assets/homme.png'),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              user.name,
              style: TextStyle(
                fontSize: 25,
                letterSpacing: 1,
                color: Color(0xffF4925D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                user.role,
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                " | " + user.SON,
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 21.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.alternate_email_sharp,
                        size: 40.0,
                        color: Color(0xffF4925D),
                      ),
                    ),
                    SizedBox(width: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          user.mail,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          "E-mail",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 21.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.account_tree_rounded,
                        size: 40.0,
                        color: Color(0xffF4925D),
                      ),
                    ),
                    SizedBox(width: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          user.structur,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          "Votre Structure",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (user.role == "personnel" || user.role == "responsable")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.apartment_rounded,
                          size: 40.0,
                          color: Color(0xffF4925D),
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            user.department,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Votre Departement",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (user.role != "directeur")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.assignment_late_sharp,
                          size: 40.0,
                          color: Color(0xffF4925D),
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            user.directeur,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Votre Directeur",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (user.role == "personnel")
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.assignment_late_sharp,
                          size: 40.0,
                          color: Color(0xffF4925D),
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            user.responsable,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Votre Responsable",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ]);
  }

  final user = FirebaseAuth.instance.currentUser!;

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('Users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
  Stream<List<User>> readUser() => FirebaseFirestore.instance
      .collection('Users')
      .where("uid", isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xffF4925D);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
