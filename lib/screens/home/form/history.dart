import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selfservice/widget/DemandeCard.dart';
import 'package:selfservice/widget/SearchBox.dart';
import 'package:selfservice/widget/constants.dart';
import 'package:selfservice/widget/profileinfo.dart';
import 'package:selfservice/models/user.dart';
import 'package:selfservice/models/demande.dart';
import 'details.dart';
import 'dart:convert';

class history extends StatefulWidget {
  history({Key? key}) : super(key: key);

  @override
  State<history> createState() => _historyState();
}

String userID = '';
String userRole = '';
List demandes = [];

class _historyState extends State<history> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List de = [];

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    dynamic results = await readDemande();
    if (results != null) {
      setState(() {
        demandes = results;
        //json.decode(results).cast<Demande>();
      });
    }
    super.didChangeDependencies();
  }

  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    fetchdata();
    fetchdata1();
  }

  fetchdata() async {
    dynamic results = await readDemande();
    if (results != null) {
      setState(() {
        demandes = results;
        //json.decode(results).cast<Demande>();
      });
    } else {
      print('errer');
    }
  }

  fetchdata1() async {
    dynamic results = await readDEnvRes();
    if (results != null) {
      setState(() {
        de = results;
      });
    } else {
      print('errer');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Listes demandes'),
          centerTitle: true,
          backgroundColor: Color(0xffF4925D),
        ),
        backgroundColor: kPrimaryColor,
        body: Stack(
          children: <Widget>[
            Container(
              // Here the height of the container is 37% of our total height
              height: size.height * .37,
              decoration: const BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  )),
            ),
            FutureBuilder(
                future: readDemande(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    int l = demandes.length - 1;
                    userRole = demandes.elementAt(l);

                    return SafeArea(
                      bottom: false,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            if (userRole != "responsable") ...[
                              ListeDesDemandes(demandes: demandes)
                            ] else ...[
                              Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  decoration: BoxDecoration(
                                    color: Colors.white54,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TabBar(
                                        unselectedLabelColor: Colors.white,
                                        labelColor: Colors.orange,
                                        indicatorColor: Colors.white,
                                        indicator: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        controller: tabController,
                                        tabs: [
                                          Tab(
                                            text: "demandes reçues",
                                          ),
                                          Tab(
                                            text: "demandes envoyées",
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    ListeDesDemandes(demandes: demandes),
                                    FutureBuilder(
                                        future: readDEnvRes(),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          if (snapshot.hasData) {
                                            return ListeDesDemandes(
                                                demandes: de);

                                            //ListeDesDemandes(demandes: de)     ;
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                            ;
                                          }
                                        })
                                    // Put widgets here
                                  ],
                                ),
                              )
                            ],

                            //ButtonSwiping(d :demandes),
                            // ListeDesDemandes(demandes: demandes)     ,
                          ]),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })
          ],
        ));
  }

  Future readDemande() async {
    final user = await FirebaseAuth.instance.currentUser!;
    List demandees = [];
    List users = [];
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);
    final snapshot = await docUser.get();
    users.add(snapshot.data()!);
    String role = (users[0]["Role"]).toString();

    if (role == "responsable") {
      final ResspoUser = await FirebaseFirestore.instance
          .collection('Demande')
          .where('etat',
              whereIn: ["en attente1", "acceptée", "refusée", "en traitement"])
          .where('Role', isEqualTo: "personnel")
          .get()
          .then((snapshotRespo) {
            snapshotRespo.docs.forEach((element) {
              demandees.add(element.data());
            });
          });
    }

    if (role == "personnel" || role == "secretaire") {
      final RespoUser = await FirebaseFirestore.instance
          .collection('Demande')
          .where('emetteur', isEqualTo: user.uid)
          .get()
          .then((snapshotRespo) {
        snapshotRespo.docs.forEach((element) {
          demandees.add(element.data());
        });
      });
    }

    if (role == "directeur") {
      final ResspoUser = await FirebaseFirestore.instance
          .collection('Demande')
          .where('Role', whereIn: ["secretaire", "responsable"])
          .get()
          .then((snapshotRespo) {
            snapshotRespo.docs.forEach((element) {
              demandees.add(element.data());
            });
          });

      final ResspoUse = await FirebaseFirestore.instance
          .collection('Demande')
          .where('Role', isEqualTo: "personnel")
          .where('etat',
              whereIn: ["en attente2", "aceeptée", "refusée", "en traitement"])
          .get()
          .then((snapshotRespo) {
            snapshotRespo.docs.forEach((element) {
              demandees.add(element.data());
            });
          });
    }

    demandees.sort((a, b) => a['dateSaisir'].compareTo(b['dateSaisir']));
    demandees.add(role);

    return demandees;
  }
}

class ListeDesDemandes extends StatelessWidget {
  const ListeDesDemandes({
    Key? key,
    required this.demandes,
  }) : super(key: key);
  final List demandes;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: demandes.length - 1,
          itemBuilder: (context, index) => DemandeCard(
                itemIndex: index,
                user: userID,
                userRole: userRole.toString(),
                //emetteurId:demandes[index]["emetteur"],
                dateSaisi: demandes[index]["dateSaisir"],
                dateS: demandes[index]["dateS"],
                commune: demandes[index]["commune"],
                emetteur: demandes[index]["emetteurId"],
                etat: demandes[index]["etat"],
                id: demandes[index]["id"],
                detail: demandes[index]["detail"],
                heureR: demandes[index]["heureR"],
                heureS: demandes[index]["heureS"],
                motif: demandes[index]["motif"],
                wilaya: demandes[index]["wilaya"],

                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(
                          user: userID,
                          userRole: userRole.toString(),
                          dateS: demandes[index]["dateS"],
                          commune: demandes[index]["commune"],
                          emetteur: demandes[index]["emetteurId"],
                          emetteurId: demandes[index]["emetteur"],
                          etat: demandes[index]["etat"],
                          id: demandes[index]["id"],
                          detail: demandes[index]["detail"],
                          heureR: demandes[index]["heureR"],
                          heureS: demandes[index]["heureS"],
                          motif: demandes[index]["motif"],
                          wilaya: demandes[index]["wilaya"],
                          email: demandes[index]["email"]),
                    ),
                  );
                },
              )),
    );
  }
}

Future readDEnvRes() async {
  final user = await FirebaseAuth.instance.currentUser!;
  List dem = [];

  final RespoUser = await FirebaseFirestore.instance
      .collection('Demande')
      .where('emetteur', isEqualTo: user.uid)
      .get()
      .then((snapshotRespo) {
    snapshotRespo.docs.forEach((element) {
      dem.add(element.data());
    });
  });

  dem.sort((a, b) => b['dateSaisir'].compareTo(a['dateSaisir']));

  return dem;
}
