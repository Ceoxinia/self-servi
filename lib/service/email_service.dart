import 'dart:convert';

import 'package:http/http.dart' as http;

Future sendEmail(String name, String email, String reciever, String reason,
    String id) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_1kw8og8';
  const templateId = 'template_j36fgpi';
  const userId = '0_qWj9YC47tZfU5VD';
  var corps;
  var title;
  switch (reason) {
    case "demande":
      {
        corps =
            "Vous avez recu une demande de bon de sortie de  $reciever , veuillez consulter la liste des demandes dans l'application pour traiter la demande.";
        title = "Demande de bon de sortie : $name";
      }
      break;
    case "traiter":
      {
        corps =
            "Votre demande de bon de sortie [$id] a ete bien recu, vous pouvez pas le changer ni le supprimer";
        title = "$reciever Votre demande est en traitement";
      }
      break;
    case "Accepter":
      {
        corps =
            "Votre demande de bon de sortie [$id] a ete acceptee veuillez consulter la liste des demandes dans l'application pour l'imprimer";
        title = " $reciever Votre demande a ete acceptee";
      }
  }
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json'
      }, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'title': title,
          'to_email': email,
          'to_name': reciever,
          'corps': corps,
        }
      }));
  return response.statusCode;
}

Future sendEmailRefus(
    String email, String reciever, String motif, String id) async {
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  const serviceId = 'service_1kw8og8';
  const templateId = 'template_q50ztum';
  const userId = '0_qWj9YC47tZfU5VD';
  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json'
      }, //This line makes sure it works for all platforms.
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'demande_id': id,
          'to_email': email,
          'to_name': reciever,
          'motif': motif,
        }
      }));
  return response.statusCode;
}
