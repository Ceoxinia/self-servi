import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:selfservice/service/generate_pdf/pdfApi.dart';

class PdfInvoiceApi {
  static Future<File> generate(String id, String demandeur, String dateSaisie,
      String heureS, String heureR, String motif, String details) async {
    final pdf = pw.Document();
    List users = await readUserr();
    final imageSVG =
        (await rootBundle.load('assets/logo.png')).buffer.asUint8List();

    pdf.addPage(
      Page(
        build: (Context context) => Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image(MemoryImage(imageSVG)),
              Text(' La direction centrale-ISI (DC-ISI)',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
          ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Center(
              child: Text('Bon de sortie',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Je soussigné Mr(Mlle) : ${users[0]['directeur']} ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text('Avoir Autrisee Mr(Mlle) : $demandeur ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Text(
                  'A faire sortire Le : $dateSaisie De : ${heureS.substring(10, 16)} a : ${heureR.substring(10, 16)}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
          ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Text('Les Details de damande',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Nom et prenom :',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text('$demandeur')
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Departement :',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(users[0]['departement'])
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Structure :',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(users[0]['structure'])
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Date de Sortie :',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(dateSaisie)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Heure de Sortie :',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(heureS.substring(10, 16))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Heure de Retour :',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(heureR.substring(10, 16))
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Motif',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(motif)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              'Details :',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(details)
          ]),
          SizedBox(height: 3 * PdfPageFormat.cm),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              height: 50,
              width: 50,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: id,
              ),
            ),
          ]),
        ]),
      ),
    );
    return PdfApi.saveDocument(name: '$id.pdf', pdf: pdf);
  }
}

Future readUserr() async {
  final user = FirebaseAuth.instance.currentUser!;
  List users = [];
  final docUser = FirebaseFirestore.instance.collection('Users').doc(user.uid);
  final snapshot = await docUser.get();
  users.add(snapshot.data()!);
  return users;
}
