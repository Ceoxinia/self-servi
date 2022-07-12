import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:selfservice/models/user.dart';
import 'package:selfservice/models/demande.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  @override
  State<Calendar> createState() => _CalendarState();
}

class User {
  String uid;
  final String name;
  final String department;
  final String directeur;
  final String responsable;
  final String SON;
  final String Role;

  User({
    this.uid = '',
    required this.name,
    required this.Role,
    required this.department,
    required this.SON,
    required this.directeur,
    required this.responsable,
  });
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'SON': SON,
        'directeur': directeur,
        'responsable': responsable,
        'department': department,
      };
  static User fromJson(Map<String, dynamic> json) => User(
      uid: json['uid'],
      name: json['name'],
      SON: json['SON'],
      directeur: json['directeur'],
      responsable: json['responsable'],
      department: json['department'],
      Role: json['Role']);
}

class Demande {
  String id;

  final String emetteur;

  final String etat;
  final String wilaya;
  final String commune;
  final String detail;
  final String dateS;
  final String heureS;
  final String heureR;
  final String motif;
  final String emetteurId;

  Demande({
    this.id = '',
    required this.etat,
    required this.wilaya,
    required this.commune,
    required this.detail,
    required this.dateS,
    required this.heureS,
    required this.heureR,
    required this.motif,
    required this.emetteur,
    required this.emetteurId,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'etat': etat,
        'dateS': dateS,
        'heureR': heureR,
        'heureS': heureS,
        'motif': motif,
        'detail': detail,
        'commune': commune,
        'wilaya': wilaya,
        'emetteurId': emetteurId,
      };

  static Demande fromJson(Map<String, dynamic> json) => Demande(
        dateS: json['dateS'],
        id: json['id'],
        emetteur: json['emetteur'],
        etat: json['etat'],
        commune: json['commune'],
        detail: json['detail'],
        heureR: json['heureR'],
        heureS: json['heureS'],
        motif: json['motif'],
        wilaya: json['wilaya'],
        emetteurId: json['emetteurId'],
      );
}

class _CalendarState extends State<Calendar> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  List demandes = [];
  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() async {
    dynamic results = await readstat(selectedDay);

    if (results != null) {
      setState(() {
        demandes = results;
        //json.decode(results).cast<Demande>();
      });
    } else {
      print('errer');
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2000),
      lastDate: DateTime(2055),
      initialEntryMode: DatePickerEntryMode.input,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xffF4925D),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDay) {
      setState(() {
        selectedDay = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: readstat(selectedDay),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final dd = snapshot.data;
            demandes = dd;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 11),
                child: ListView(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * .30,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: <Widget>[
                          StatCard(
                            title: "demandes\naccéptées",
                            stat: demandes.elementAt(0).toString(),
                            icon: Icons.check_circle_outline_outlined,
                            color: Colors.green,
                          ),
                          StatCard(
                            title: "demandes\nrefusées",
                            stat: demandes.elementAt(1).toString(),
                            icon: Icons.highlight_remove,
                            color: Colors.red,
                          ),
                          StatCard(
                            title: demandes.elementAt(4).toString(),
                            stat: demandes.elementAt(2).toString(),
                            icon: Icons.border_color_outlined,
                            color: Colors.orange,
                          ),
                          StatCard(
                              title: "nombre total\ndes demandes",
                              stat: demandes.elementAt(3).toString(),
                              icon: Icons.document_scanner_outlined,
                              color: Colors.blue),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                              widthFactor: 0.35,
                              child: ElevatedButton.icon(
                                  onPressed: () => _selectDate(context),
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0.0,
                                      primary: Color(
                                          0xffF4925D)), //fromARGB(255, 252, 249, 249),),//const Color(0xFFF8F8F8),),
                                  icon: const Icon(
                                    Icons.edit_calendar,
                                    size: 24.0,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Aller à',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0,
                                        fontSize: 15.0),
                                  ))),
                        ),

                        /* Container(
      decoration: const BoxDecoration(
      color:Colors.white),
      child: Text('${selectedDay.month}')),*/

                        Container(
                          decoration: BoxDecoration(
                              color: Colors
                                  .white, //const Color.fromARGB(255, 253, 206, 32),
                              borderRadius: BorderRadius.circular(13)),
                          child: TableCalendar(
                            focusedDay: selectedDay,
                            firstDay: DateTime(2010),
                            lastDay: DateTime(2050),
                            calendarFormat: format,

                            onFormatChanged: (CalendarFormat _format) {
                              setState(() {
                                format = _format;
                              });
                            },

                            startingDayOfWeek: StartingDayOfWeek.sunday,
                            daysOfWeekVisible: true,
                            //Day Changed
                            selectedDayPredicate: (DateTime date) {
                              return isSameDay(selectedDay, date);
                            },
                            onDaySelected:
                                (DateTime selectDay, DateTime focusDay) {
                              setState(() {
                                selectedDay = selectDay;
                                focusedDay = focusDay;
                              });
                            },

                            //To style the Calendar
                            calendarStyle: const CalendarStyle(
                              isTodayHighlighted: true,
                              selectedDecoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: TextStyle(color: Colors.white),
                              todayDecoration: BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              defaultDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              weekendDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              formatButtonVisible: true,
                              titleCentered: true,
                              formatButtonShowsNext: false,
                              formatButtonDecoration: BoxDecoration(
                                color: Color(0xffF4925D),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              formatButtonTextStyle: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String stat;
  final IconData icon;
  final Color color;
  const StatCard(
      {Key? key,
      required this.title,
      required this.stat,
      required this.icon,
      required this.color})
      : super(key: key);

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
                Icon(
                  icon,
                  size: 50,
                  color: color,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  stat,
                  style: TextStyle(
                    color: color,
                    fontSize: 40.0,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

Future readstat(DateTime s) async {
  String dSaisie = s.toString().substring(0, 11);
  final user = await FirebaseAuth.instance.currentUser!;
  List demandesAcc = [];
  List demandesRef = [];
  List demandesentr = [];
  List demandesAtt = [];
  List demandestot = [];
  List demandees = [];

  List users = [];
  final docUser = FirebaseFirestore.instance.collection('Users').doc(user.uid);
  final snapshot = await docUser.get();
  users.add(snapshot.data()!);
  String role = users[0]["Role"];

  if (role == "responsable") {
    final a = await FirebaseFirestore.instance
        .collection('Demande')
        .where('Role', isEqualTo: "personnel")
        .where('etat', whereIn: ["en traitement", "acceptée"])
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
          snapshotRespo.docs.forEach((element) {
            demandesAcc.add(element.data());
          });
        });

    final r = await FirebaseFirestore.instance
        .collection('Demande')
        .where('Role', isEqualTo: "personnel")
        .where('etat', isEqualTo: "refusée")
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
      snapshotRespo.docs.forEach((element) {
        demandesRef.add(element.data());
      });
    });

    final t = await FirebaseFirestore.instance
        .collection('Demande')
        .where('etat', isEqualTo: "en attente1")
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
      snapshotRespo.docs.forEach((element) {
        demandesentr.add(element.data());
      });
    });

    String total =
        (demandesAcc.length + demandesRef.length + demandesentr.length)
            .toString();

    demandees.add(demandesAcc.length.toString());
    demandees.add(demandesRef.length.toString());
    demandees.add(demandesentr.length.toString());
    demandees.add(total);
    demandees.add("demandes\nen attente");
  }

  if (role == "directeur") {
    final a = await FirebaseFirestore.instance
        .collection('Demande')
        .where('etat', isEqualTo: "acceptée")
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
      snapshotRespo.docs.forEach((element) {
        demandesAcc.add(element.data());
      });
    });

    final r = await FirebaseFirestore.instance
        .collection('Demande')
        .where('etat', isEqualTo: "refusée")
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
      snapshotRespo.docs.forEach((element) {
        demandesRef.add(element.data());
      });
    });

    final t = await FirebaseFirestore.instance
        .collection('Demande')
        .where('etat', whereIn: ["en attente2", "en traitement"])
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
          snapshotRespo.docs.forEach((element) {
            demandesentr.add(element.data());
          });
        });

    String total =
        (demandesAcc.length + demandesRef.length + demandesentr.length)
            .toString();

    demandees.add(demandesAcc.length.toString());
    demandees.add(demandesRef.length.toString());
    demandees.add(demandesentr.length.toString());
    demandees.add(total);
    demandees.add("demandes\nen attente");
  }

  if (role == "personnel" || role == "secretaire") {
    final a = await FirebaseFirestore.instance
        .collection('Demande')
        .where('emetteur', isEqualTo: user.uid)
        .where('etat', isEqualTo: "acceptée")
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
      snapshotRespo.docs.forEach((element) {
        demandesAcc.add(element.data());
      });
    });

    final r = await FirebaseFirestore.instance
        .collection('Demande')
        .where('emetteur', isEqualTo: user.uid)
        .where('etat', isEqualTo: "refusée")
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
      snapshotRespo.docs.forEach((element) {
        demandesRef.add(element.data());
      });
    });

    final t = await FirebaseFirestore.instance
        .collection('Demande')
        .where('emetteur', isEqualTo: user.uid)
        .where('etat', whereIn: ["en attente2", "en traitement"])
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
          snapshotRespo.docs.forEach((element) {
            demandesentr.add(element.data());
          });
        });

    final to = await FirebaseFirestore.instance
        .collection('Demande')
        .where('emetteur', isEqualTo: user.uid)
        .where('dateSaisir', isEqualTo: dSaisie)
        .get()
        .then((snapshotRespo) {
      snapshotRespo.docs.forEach((element) {
        demandestot.add(element.data());
      });
    });

    demandees.add(demandesAcc.length.toString());
    demandees.add(demandesRef.length.toString());
    demandees.add(demandesentr.length.toString());
    demandees.add(demandestot.length.toString());
    demandees.add("demandes\nen traitement");
  }

  demandees.add(role);
  return demandees;
}
