import 'package:flutter/material.dart';


class Ball extends StatelessWidget {
  final double x;
  final double y;
  const Ball({required this.x, required this.y, Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
        // 将小球置于pingpong中央
      
        alignment: Alignment(x,y),
        width: 20,
        height: 20,
        decoration:  BoxDecoration(
          color: Colors.yellow,
          shape: BoxShape.circle,
         
          ),
      
      );


  }
}