


import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class StartScreen extends StatelessWidget {
  final bool isShow;
  const StartScreen({ this.isShow=true,super.key});

  @override
  Widget build(BuildContext context) {
    return isShow?Container(
          alignment: Alignment(0,-0.2),
        child:Container(child: Text("Start the game",style: TextStyle(fontSize: 32,color: Colors.grey),),))
    :Container();
  }
}