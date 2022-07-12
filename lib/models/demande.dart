class Demande {
  final String Role;
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
  final String emailDirecteur;
  final String dateSaisir;
  Demande({
    required this.dateS,
    required this.commune,
    required this.Role,
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
    required this.emailDirecteur,
    required this.dateSaisir,
  });
}
