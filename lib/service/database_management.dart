import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Demande {
  String id;
  final user = FirebaseAuth.instance.currentUser!;

  final String emetteur;
  final String email;
  final String etat;
  final String wilaya;
  final String commune;
  final String detail;
  final String dateS;
  final String dateSaisir;
  final String heureS;
  final String heureR;
  final String motif;
  final String emetteurId;
  final String role;
  final String emailDirecteur;

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
    required this.dateSaisir,
    required this.role,
    required this.email,
    required this.emailDirecteur,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'emetteur': user.uid,
        'etat': etat,
        'dateS': dateS,
        'heureR': heureR,
        'heureS': heureS,
        'motif': motif,
        'detail': detail,
        'commune': commune,
        'wilaya': wilaya,
        'emetteurId': emetteurId,
        'dateSaisir': dateSaisir,
        'Role': role,
        'email': email,
        'emailDirecteur': emailDirecteur
      };
}

Future signIn(son, psd) async {
  final docUser = FirebaseFirestore.instance
      .collection('Users')
      .where("SON", isEqualTo: son);
  final snapshot = await docUser.get();
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: snapshot.docs[0]['email'], password: psd);
}

Future readUser(String uid) async {
  List users = [];
  final docUser = FirebaseFirestore.instance.collection('Users').doc(uid);
  final snapshot = await docUser.get();

  users.add(snapshot.data()!);
  final RespoUser = FirebaseFirestore.instance
      .collection('Users')
      .where('Role', isEqualTo: 'responsable')
      .get()
      .then((snapshotRespo) {
    snapshotRespo.docs.forEach((element) {
      users.add(element.data()!);
    });
  });
  final directeurUser = FirebaseFirestore.instance
      .collection('Users')
      .where('Role', isEqualTo: 'directeur')
      .get()
      .then((snapshotdirec) {
    snapshotdirec.docs.forEach((element) {
      users.add(element.data()!);
    });
  });
  return users;
}

Future creerDemande(
    String etat,
    String wilaya,
    String Commune,
    String HeureS,
    String HeureR,
    String dateS,
    String motif,
    String detail,
    String emetteurId,
    String emetteur,
    String dateSaisir,
    String role,
    String email,
    String emailDirecteur) async {
  // Call the user's CollectionReference to add a new user
  final docUser = FirebaseFirestore.instance.collection('Demande').doc();
  final demande = Demande(
      id: docUser.id,
      etat: etat,
      wilaya: wilaya,
      commune: Commune,
      heureR: HeureR,
      heureS: HeureS,
      dateS: dateS,
      motif: motif,
      detail: detail,
      emetteur: emetteur,
      emetteurId: emetteurId,
      dateSaisir: dateSaisir,
      role: role,
      email: email,
      emailDirecteur: emailDirecteur);
  final json = demande.toJson();
  await docUser.set(json);
}

Future updateDemande(
  String id,
  String wilaya,
  String Commune,
  String HeureS,
  String HeureR,
  String dateS,
  String motif,
  String detail,
) async {
  // Call the user's CollectionReference to add a new user
  final docUser = FirebaseFirestore.instance.collection('Demande').doc(id);
  docUser.update({
    'wilaya': wilaya,
    'commune': Commune,
    'heureR': HeureR,
    'heureS': HeureS,
    'dateS': dateS,
    'motif': motif,
    'detail': detail,
  });
}
