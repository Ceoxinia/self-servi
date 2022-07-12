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
        'Role' :Role ,
      };
  static User fromJson(Map<String, dynamic> json) => User(
        uid: json['uid'],
        name: json['name'],
        SON: json['SON'],
        directeur: json['directeur'],
        responsable: json['responsable'],
        department: json['department'],
        Role: json['Role']
      );
}
