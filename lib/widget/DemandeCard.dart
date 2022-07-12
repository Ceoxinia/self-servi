import 'package:flutter/material.dart';
import 'package:selfservice/models/demande.dart';
import 'package:selfservice/screens/home/form/details.dart';
import 'constants.dart';

class DemandeCard extends StatelessWidget {
  const DemandeCard(
      {required this.itemIndex,
      required this.press,
      required this.dateS,
      required this.dateSaisi,
      required this.commune,
      required this.id,
      required this.emetteur,
      required this.etat,
      required this.detail,
      required this.heureR,
      required this.heureS,
      required this.motif,
      required this.user,
      required this.userRole,
      required this.wilaya,
      Key? key})
      : super(key: key);
  final int itemIndex;
  final String userRole;
  final String user;
  final VoidCallback press;
  final String dateS;

  final String commune;
  final String emetteur;
  final String etat;
  final String id;
  final String detail;
  final String heureR;
  final String heureS;
  final String motif;
  final String wilaya;
  final String dateSaisi;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String icon = getIcon();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      // color: Colors.blueAccent,
      height: 160,
      child: InkWell(
        onTap: press, //(){},
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Those are our background
            Container(
              height: 150,
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color:
                    getColor(), //itemIndex.isEven ? kBlueColor : kSecondaryColor,
                boxShadow: const [kDefaultShadow],
              ),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  child: SizedBox(
                    height: 140,
                    // our image take 200 width, thats why we set out total width - 200
                    width: size.width - 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person),
                              Text(
                                '$emetteur', // product.title,
                                style: Theme.of(context).textTheme.button,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Text(
                              'date de saisie : $dateSaisi\ndate de sortie : $dateS\nheure de sortie : ${heureS.substring(10, 16)}    heure de retour: ${heureR.substring(10, 16)}\n',
                              // product.title,
                              style: TextStyle(
                                fontSize: 15.0,
                              )),
                        ),
                        // it use the available space

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 1.5, // 30 padding
                            vertical: kDefaultPadding / 4, // 5 top and bottom
                          ),
                          decoration: BoxDecoration(
                            color: getColor(),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22),
                              topRight: Radius.circular(22),
                            ),
                          ),
                          child: Text(
                            "Id : $id",
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // our product image
            Positioned(
              top: 0,
              right: 0,
              /*child: Hero(
                tag: 'hello',*/ //'${product.id}',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                height: 44,
                // image is square but we add extra 20 + 20 padding thats why width is 200
                width: 84,
                child: Image.asset(
                  "assets/$icon.png",
                  fit: BoxFit.cover,
                ),
              ),
              //),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    Color color;
    switch (etat) {
      case "en attente1":
        color = Color.fromARGB(255, 233, 161, 161);
        break;
      case "en attente2":
        color = Color.fromARGB(255, 233, 161, 161);
        break;
      case "acceptée":
        color = Color.fromARGB(255, 196, 249, 176);
        break;
      case "refusée":
        color = Color.fromARGB(255, 251, 54, 39);
        break;
      default:
        color = Color.fromARGB(255, 254, 250, 116);
    }

    // Finally returning a Widget
    return color;
  }

  String getIcon() {
    String icon;
    switch (etat) {
      case "en attente1":
        icon = 'chat';
        break;
      case "en attente2":
        icon = 'chat';
        break;
      case "acceptée":
        icon = 'check (3)';
        break;
      case "refusée":
        icon = 'cross';
        break;
      default:
        icon = 'wait';
    }
    return icon;
  }
}
