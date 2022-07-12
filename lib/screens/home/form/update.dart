import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:selfservice/service/ascii_cities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:selfservice/widget/responsibles.dart';
//import 'package:selfservice/service/email_service.dart';

import '../../../service/database_management.dart';
import '../../../service/email_service.dart';
import '../../../service/generate_pdf/pdfApi.dart';
import '../../../service/generate_pdf/pdf_invoice.dart';
import '../../../widget/titles.dart';

class updateForm extends StatefulWidget {
  late String dateSC;
  late String communeC;
  late String idC;
  late String detailC;
  late String heureRC;
  late String heureSC;
  late String motifC;
  late String wilayaC;

  updateForm(String dateSC, String communeC, String idC, String detailC,
      String heureRC, String heureSC, String motifC, String wilayaC) {
    this.dateSC = dateSC;
    this.communeC = communeC;
    this.idC = idC;
    this.detailC = detailC;
    this.heureRC = heureRC;
    this.heureSC = heureSC;
    this.motifC = motifC;
    this.wilayaC = wilayaC;
  }

  @override
  State<updateForm> createState() => _updateFormState();
}

class _updateFormState extends State<updateForm> {
  // List of items in our dropdown menu
  var items = [
    'Motif',
    'Personelle',
    'Travail',
  ];
  String? countryId;
  String? stateId;
  List<dynamic> states = [];
  bool heureSo = true;
  bool heureRe = true;
  bool dateS = true;
  DateTime? selectedDate;
  DateTime? selectedheureS;
  DateTime? selectedheureR;
  final _formKey = GlobalKey<FormState>();

  List UsersNeed = [];

  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() async {
    dynamic results = await readUser(user.uid);
    if (results != null) {
      setState(() {
        UsersNeed = results;
      });
    } else {
      print('erreor');
    }
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    CollectionReference demandes =
        FirebaseFirestore.instance.collection('demandes');

    final detailController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: readUser(user.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverAppBar(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200),
                          )),
                          backgroundColor: Color.fromARGB(255, 255, 220, 178),
                          expandedHeight: 240,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Image.asset(
                              'assets/head.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                  body: Form(
                      key: _formKey,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30, bottom: 30),
                            child: Text(
                              'Modifier une demande',
                              style: GoogleFonts.openSans(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                  color: Color(0xffF4925D)),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Responsable(UsersNeed[0]['directeur'],
                                  'directeur', context, 'personnel'),
                              if (UsersNeed[0]['Role'] == 'personnel')
                                Responsable(UsersNeed[0]['responsable'],
                                    'responsable', context, 'personnel'),
                            ],
                          ),
                          //if respo or secrt

                          title('Date de sortie'),

                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 248, 245, 245),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 12,
                                            color: Colors.black45,
                                            spreadRadius: -8)
                                      ],
                                      borderRadius: BorderRadius.circular(16)),
                                  child: TextButton(
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: DateTime.now().subtract(
                                                const Duration(hours: 72)),
                                            maxTime: DateTime.now(),
                                            onChanged: (date) {
                                          print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          selectedDate = date;
                                          this.dateS = false;
                                          setState(() {});
                                        },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.fr);
                                      },
                                      child: ListTile(
                                        title: dateS
                                            ? Text(
                                                widget.dateSC,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 106, 104, 104)),
                                              )
                                            : Text(
                                                widget.dateSC
                                                    .toString()
                                                    .substring(0, 11),
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 106, 104, 104)),
                                              ),
                                        trailing: Icon(Icons.calendar_today,
                                            color: Colors.orange),
                                      )))),

                          title('La duree'),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 248, 245, 245),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 12,
                                              color: Colors.black45,
                                              spreadRadius: -8)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: TextButton(
                                        onPressed: () {
                                          DatePicker.showTime12hPicker(context,
                                              showTitleActions: true,
                                              onChanged: (heureS) {
                                            print(
                                                'change $heureS in time zone ' +
                                                    heureS
                                                        .timeZoneOffset.inHours
                                                        .toString());
                                          }, onConfirm: (heureS) {
                                            print("");
                                            selectedheureS = heureS;
                                            this.heureSo = false;
                                            setState(() {});
                                          }, currentTime: selectedDate);
                                        },
                                        child: ListTile(
                                          title: heureSo
                                              ? Text(
                                                  widget.heureSC
                                                      .substring(10, 16),
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 106, 104, 104)),
                                                )
                                              : Text(
                                                  selectedheureS
                                                      .toString()
                                                      .substring(10, 16),
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 106, 104, 104)),
                                                ),
                                          trailing: Icon(Icons.schedule,
                                              color: Colors.orange),
                                        ))),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 248, 245, 245),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 12,
                                              color: Colors.black45,
                                              spreadRadius: -8)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: TextButton(
                                        onPressed: () {
                                          DatePicker.showTime12hPicker(context,
                                              showTitleActions: true,
                                              onChanged: (heureR) {
                                            print(
                                                'change $heureR in time zone ' +
                                                    heureR
                                                        .timeZoneOffset.inHours
                                                        .toString());
                                          }, onConfirm: (heureR) {
                                            print('');
                                            selectedheureR = heureR;
                                            this.heureRe = false;
                                            setState(() {});
                                          }, currentTime: selectedDate);
                                        },
                                        child: ListTile(
                                          title: heureRe
                                              ? Text(
                                                  widget.heureRC
                                                      .substring(10, 16),
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 106, 104, 104)),
                                                )
                                              : Text(
                                                  selectedheureR
                                                      .toString()
                                                      .substring(10, 16),
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 106, 104, 104)),
                                                ),
                                          trailing: Icon(Icons.schedule,
                                              color: Colors.orange),
                                        ))),
                              ]),

                          title('Wilaya'),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 245, 245),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black45,
                                        spreadRadius: -8)
                                  ],
                                  borderRadius: BorderRadius.circular(16)),
                              child: FormHelper.dropDownWidget(
                                context,
                                widget.wilayaC,
                                this.countryId,
                                wilaya,
                                (onChangedVal) {
                                  this.countryId = onChangedVal;
                                  this.states = algeria_cites
                                      .where((stateItem) =>
                                          stateItem["wilaya_code"] ==
                                          onChangedVal)
                                      .toList();
                                  this.stateId = null;
                                  setState(() {});
                                },
                                (onValidateVal) {},
                                borderColor: Color.fromARGB(255, 248, 245, 245),
                                borderFocusColor:
                                    Color.fromARGB(255, 248, 245, 245),
                                borderRadius: 20,
                                optionValue: "wilaya_code",
                                optionLabel: "wilaya_name",
                                paddingBottom: 16.0,
                                paddingTop: 16.0,
                                paddingLeft: 8.0,
                                paddingRight: 8.0,
                                borderWidth: 0.0,
                              )),
                          title('Commune'),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 245, 245),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black45,
                                        spreadRadius: -8)
                                  ],
                                  borderRadius: BorderRadius.circular(16)),
                              child: FormHelper.dropDownWidget(
                                context,
                                widget.communeC,
                                this.stateId,
                                this.states,
                                (onChangedVal) {
                                  this.stateId = onChangedVal;
                                },
                                (onValidateVal) {},
                                optionValue: "commune_name",
                                optionLabel: "commune_name",
                                paddingBottom: 16.0,
                                paddingTop: 16.0,
                                paddingLeft: 8.0,
                                paddingRight: 8.0,
                                borderColor: Color.fromARGB(255, 248, 245, 245),
                                borderFocusColor:
                                    Color.fromARGB(255, 248, 245, 245),
                              )),

                          title('Motif'),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 248, 245, 245),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 12,
                                            color: Colors.black45,
                                            spreadRadius: -8)
                                      ],
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        value: widget.motifC,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: items.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            widget.motifC = newValue!;
                                          });
                                        },
                                      ))),
                            ],
                          ),
                          title('Details'),

                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 245, 245),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 12,
                                        color: Colors.black45,
                                        spreadRadius: -8)
                                  ],
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextField(
                                  controller: detailController,
                                  maxLines: 8, //or null
                                  decoration: InputDecoration.collapsed(
                                      hintText: widget.detailC),
                                ),
                              )),

                          GestureDetector(
                            onTap: () {
                              if (heureSo) {
                                selectedheureS = DateTime.parse(widget.heureSC);
                              }
                              if (heureRe) {
                                selectedheureR = DateTime.parse(widget.heureRC);
                              }

                              if (countryId == Null) {
                                countryId = widget.wilayaC;
                                stateId = widget.communeC;
                              }
                              if (_formKey.currentState!.validate() &&
                                  !selectedheureR!.isBefore(selectedheureS!) &&
                                  detailController.text.trim() != null &&
                                  widget.motifC != "Motif") {
                                if (!dateS) {
                                  updateDemande(
                                    widget.idC,
                                    countryId!,
                                    stateId!,
                                    selectedheureS.toString()!,
                                    selectedheureR.toString()!,
                                    selectedDate.toString().substring(0, 11)!,
                                    widget.motifC,
                                    detailController.text.trim(),
                                  );
                                } else {
                                  updateDemande(
                                    widget.idC,
                                    countryId!,
                                    stateId!,
                                    selectedheureS.toString()!,
                                    selectedheureR.toString()!,
                                    widget.dateSC,
                                    widget.motifC,
                                    detailController.text.trim(),
                                  );
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Votre demande a ete Modifie!')),
                                );
                              } else {
                                if (detailController.text.trim() == null ||
                                    widget.motifC == "Motif") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Veuillez remplire toutes les champs')),
                                  );
                                } else {
                                  if (selectedheureR!
                                      .isBefore(selectedheureS!)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Erreur dans l'heure")),
                                    );
                                  }
                                }
                              }
                              ;
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
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
                                      colors: [
                                        Color.fromARGB(255, 245, 112, 147),
                                        Color(0xffF4925D)
                                      ])),
                              child: Text(
                                'Valider',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
