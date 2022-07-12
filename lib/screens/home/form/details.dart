import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selfservice/models/demande.dart';
import 'package:selfservice/screens/home/form/form.dart';
import 'package:selfservice/screens/home/form/update.dart';
import 'package:selfservice/widget/DemandeCard.dart';
import 'package:selfservice/widget/SearchBox.dart';
import 'package:selfservice/widget/constants.dart';

import '../../../service/email_service.dart';
import '../../../service/generate_pdf/pdfApi.dart';
import '../../../service/generate_pdf/pdf_invoice.dart';

class Details extends StatefulWidget {
  const Details({
    required this.dateS,
    required this.commune,
    required this.userRole,
    required this.id,
    required this.emetteur,
    required this.emetteurId,
    required this.etat,
    required this.detail,
    required this.heureR,
    required this.heureS,
    required this.motif,
    required this.user,
    required this.wilaya,
    required this.email,
  });

  final String userRole;
  final String user;
  final String dateS;
  final String commune;
  final String emetteur;
  final String emetteurId;
  final String etat;
  final String id;
  final String detail;
  final String heureR;
  final String heureS;
  final String motif;
  final String wilaya;
  final String email;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    final motifController = TextEditingController();

    final user = FirebaseAuth.instance.currentUser!;
    DateTime dt1 = DateTime.parse(widget.heureS);
    DateTime dt2 = DateTime.parse(widget.heureR);
    Duration diff = dt1.difference(dt2);
    int i = diff.inSeconds;

    String pic = setIcon();

    return Scaffold(
      backgroundColor: Color(0xffF4925D),
      appBar: AppBar(
        backgroundColor: Color(0xffF4925D),
        elevation: 0,
        centerTitle: true,
        title: Text('Détail de la demande'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 75,
                      margin: EdgeInsets.only(top: 35.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 8, 30),
                        child: Column(
                          children: [
                            Center(
                              child: Text('ID : ${widget.id}', // product.title,
                                  // style: GoogleFonts.lato                              (
                                  style: TextStyle(
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Row(
                              children: [
                                Icon(Icons.person, size: 25.0),
                                Text(' ${widget.emetteur}', // product.title,
                                    //style: GoogleFonts.lato                                (
                                    style: TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RowInfo(info: "${widget.etat}", title: "Etat : "),
                            RowInfo(
                                info: "${widget.dateS}",
                                title: "Date de sortie : "),
                            RowInfo(
                                info: widget.heureS.substring(10, 16),
                                title: "heure de sortie : "),
                            RowInfo(
                                info: widget.heureR.substring(10, 16),
                                title: "heure de retour : "),
                            RowInfo(
                                info: "${widget.wilaya}", title: "Wilaya : "),
                            RowInfo(
                                info: "${widget.commune}", title: "Commune : "),
                            RowInfo(info: "${widget.motif}", title: "Motif : "),
                            RowInfo(info: "", title: "Détail : "),
                            Text("${widget.detail}", // product.title,
                                style: TextStyle(
                                  fontSize: 19.0,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 45.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (widget.emetteurId == user.uid) ...[
                                    if (widget.etat == "acceptée")
                                      Button(
                                        text: "Imprimer",
                                        ico: Icons.print,
                                        tap: () async {
                                          final pdfFile =
                                              await PdfInvoiceApi.generate(
                                                  '${widget.id}',
                                                  '${widget.emetteur}',
                                                  widget.dateS,
                                                  widget.heureS,
                                                  widget.heureR,
                                                  widget.motif,
                                                  widget.detail);

                                          PdfApi.openFile(pdfFile);
                                        },
                                        color:
                                            Color.fromARGB(255, 153, 246, 141),
                                        colorr:
                                            Color.fromARGB(255, 87, 154, 83),
                                      ),
                                    if (widget.etat == "en attente1" ||
                                        widget.etat == "en attente2") ...[
                                      Button(
                                          text: "Modifier",
                                          ico: Icons.create_rounded,
                                          tap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        updateForm(
                                                            widget.dateS,
                                                            widget.commune,
                                                            widget.id,
                                                            widget.detail,
                                                            widget.heureR,
                                                            widget.heureS,
                                                            widget.motif,
                                                            widget.wilaya)));
                                          },
                                          color: Color.fromARGB(
                                              255, 227, 201, 238),
                                          colorr: Color.fromARGB(
                                              255, 177, 131, 208)),
                                      Button(
                                        text: "Supprimer",
                                        ico: Icons.delete,
                                        tap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  "vous voulez supprimer\ncette demande?"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text(
                                                      "CANCEL",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      final docDemande =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Demande')
                                                              .doc(widget.id);
                                                      docDemande.delete();
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                                title: Text(
                                                                    "Demande supprimée !"),
                                                              ));
                                                    },
                                                    child: Text(
                                                      "OK",
                                                      style: TextStyle(
                                                          color: Colors.amber),
                                                    ))
                                              ],
                                            ),
                                          );
                                        },
                                        color:
                                            Color.fromARGB(255, 245, 112, 147),
                                        colorr: Color(0xffF4925D),
                                      ),
                                    ]
                                  ] else if (widget.userRole ==
                                      "responsable") ...[
                                    if (widget.etat == "en attente1") ...[
                                      Button(
                                        text: "Valider",
                                        ico: Icons.check_rounded,
                                        tap: () {
                                          final docDemande = FirebaseFirestore
                                              .instance
                                              .collection('Demande')
                                              .doc(widget.id);
                                          docDemande.update(
                                              {'etat': 'en traitement'});
                                        },
                                        color:
                                            Color.fromARGB(255, 153, 246, 141),
                                        colorr:
                                            Color.fromARGB(255, 87, 154, 83),
                                      ),
                                      Button(
                                        text: "refuser",
                                        ico: Icons.clear_rounded,
                                        tap: () {
                                          final docDemande = FirebaseFirestore
                                              .instance
                                              .collection('Demande')
                                              .doc(widget.id);
                                          docDemande
                                              .update({'etat': 'refusée'});
                                        },
                                        color:
                                            Color.fromARGB(255, 245, 112, 147),
                                        colorr: Color(0xffF4925D),
                                      ),
                                    ]
                                  ] else ...[
                                    if (widget.userRole == "directeur") ...[
                                      if (widget.etat == "en traitement" ||
                                          widget.etat == "en attente2")
                                        Button(
                                          text: "Valider",
                                          ico: Icons.check_rounded,
                                          tap: () {
                                            final docDemande = FirebaseFirestore
                                                .instance
                                                .collection('Demande')
                                                .doc(widget.id);
                                            docDemande
                                                .update({'etat': 'acceptée'});
                                            final docRespo = FirebaseFirestore
                                                .instance
                                                .collection('Users')
                                                .doc(widget.emetteurId);
                                            docRespo.update(
                                                {'etat': 'non disponible'});
                                            Timer(Duration(seconds: i), () {
                                              docRespo.update(
                                                  {'etat': 'disponible'});
                                            });

                                            sendEmail(
                                                widget.emetteur,
                                                widget.email,
                                                widget.emetteur,
                                                'Accepter',
                                                widget.id);
                                          },
                                          color: Color.fromARGB(
                                              255, 153, 246, 141),
                                          colorr:
                                              Color.fromARGB(255, 87, 154, 83),
                                        ),
                                      Button(
                                        text: "refuser",
                                        ico: Icons.clear_rounded,
                                        tap: () {
                                          final docDemande = FirebaseFirestore
                                              .instance
                                              .collection('Demande')
                                              .doc(widget.id);
                                          docDemande
                                              .update({'etat': 'refusée'});
                                        },
                                        color:
                                            Color.fromARGB(255, 245, 112, 147),
                                        colorr: Color(0xffF4925D),
                                      ),
                                    ]
                                  ]
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0.0),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          offset: const Offset(-1, 10),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Image.asset(
                      "assets/$pic.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  String setIcon() {
    String icon;
    switch (widget.etat) {
      case "en attente1":
        icon = 'error';
        break;
      case "en attente2":
        icon = 'error';
        break;
      case "acceptée":
        icon = 'approved';
        break;
      case "refusée":
        icon = 'rejected';
        break;
      default:
        icon = 'document';
    }

    // Finally returning a Widget
    return icon;
  }

  refus(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Motif de refus"),
        content: TextField(
          maxLength: 115,
          minLines: 1,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "CANCEL",
                style: TextStyle(color: Colors.black),
              )),
          TextButton(
              onPressed: () {
                final docDemande = FirebaseFirestore.instance
                    .collection('Demande')
                    .doc(widget.id);
                docDemande.update({'etat': 'refusée'});

                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.amber),
              ))
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button(
      {required this.tap,
      required this.colorr,
      required this.text,
      required this.ico,
      required this.color,
      Key? key})
      : super(key: key);
  final VoidCallback tap;
  final IconData ico;
  final Color color;
  final Color colorr;
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset(0, 20), blurRadius: 30, color: Colors.black12)
        ], color: Colors.white, borderRadius: BorderRadius.circular(22)),
        child: Row(
          children: [
            Container(
                height: 50,
                width: 120,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    child: Text(text,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: color,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(2, 4),
                          blurRadius: 5,
                          spreadRadius: 2)
                    ],
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [color, colorr]),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(95),
                      topLeft: Radius.circular(95),
                      bottomRight: Radius.circular(200),
                    ))),
            Icon(ico, size: 30)
          ],
        ),
      ),
    );
  }
}

class RowInfo extends StatelessWidget {
  const RowInfo({
    Key? key,
    required this.info,
    required this.title,
  }) : super(key: key);

  final String info;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
              )),
          Text(info,
              style: TextStyle(
                fontSize: 19.0,
              )),
        ],
      ),
    );
  }
}
