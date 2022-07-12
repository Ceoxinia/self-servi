import 'package:flutter/material.dart';
class ButtonSwiping extends StatefulWidget {
  const ButtonSwiping({ Key? key }) : super(key: key);

  @override
  State<ButtonSwiping> createState() => _ButtonSwipingState();
}

class _ButtonSwipingState extends State<ButtonSwiping> 
  with SingleTickerProviderStateMixin {
  

  late TabController tabController ;


  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2,vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.85,
      decoration: BoxDecoration(
        color: Colors.white54 ,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TabBar(
          unselectedLabelColor:Colors.white,
          labelColor: Colors.orange,
          indicatorColor: Colors.white,
          indicator: BoxDecoration(
            color: Colors.white ,
            borderRadius: BorderRadius.circular(25),

          ),
          controller: tabController,
          tabs:[
            Tab(
              text: "demandes reçues",
            ),
            Tab(
              text: "demandes envoyées",
            ),
          ]
          
        ),
      ),
    );
  }
}