

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pingpong/ball.dart';
import 'package:pingpong/racket.dart';
import 'package:pingpong/startScreen.dart';

const step = 0.1;

const ballStep = 0.01;

const double maxY = 0.95;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
enum Direction {
  Up,
  Down,
  Left,
  Right,
}
class _MyHomePageState extends State<MyHomePage> {
  double ballX =0;
  double ballY = 0;
  // 记录班子 x轴坐标
  double upX = 0;
  double downX = 0;

 // 开始游戏后 消除文字
    bool isRunning = false;
    Direction direction = Direction.Down;
    Direction hDirection = Direction.Left;
  start(){
    setState(() {
      isRunning = true;
    });
    Timer.periodic(Duration(milliseconds: 50), (timer) { 
      double newBallY = ballY;
      double newBallX = ballX;
      // 球的位置是不是已经小于最下面或者超出最上面
      Direction newDirection = direction;
      Direction newHDirection = hDirection;
      switch (direction) {
        case Direction.Up:
        newBallY -= ballStep;
        break;
        case Direction.Down:
         newBallY += ballStep;
        break;
        default: 
      }

      switch (hDirection) {
        case Direction.Left:
         newBallX -= ballStep;
         break;
        case Direction.Right:
        newBallX += ballStep;
         break;
      }

      if(newBallY <= -maxY ){
         if(newBallX < (upX - 0.333)|| newBallX > (upX + 0.333) ){
          setState(() {
            isRunning = false;
          });
          timer.cancel();
         }
        newDirection = Direction.Down;
      } else if(newBallY >= maxY) {
        if(newBallX < (downX - 0.333)|| newBallX > (downX + 0.333) ){
          setState(() {
            isRunning = false;
          });
               timer.cancel();
         }
        newDirection = Direction.Up;
      }

         if(newBallY <= -1 ){
        newHDirection = Direction.Right;
      } else if(newBallY >= 1) {
        newHDirection = Direction.Left;
      }
      setState(() {
      ballY = newBallY;
      ballX = newBallX;
      direction = newDirection;


    });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RawKeyboardListener(focusNode: FocusNode(), autofocus: true,onKey: (event) {
        // down 键盘
        if(event.runtimeType == RawKeyDownEvent){
          switch (event.logicalKey.keyLabel) {
            case "Arrow Left":
               setState(() {
                 upX = upX - step;
                 downX = downX - step;
               });
               break;
            case  "Arrow Right":
            setState(() {
                 upX = upX + step;
                 downX = downX + step;
               });
               break;
            default:
          }
        }
      }, 
      child: GestureDetector(
        onTap: () {
          start();
        },
      child:  Stack(
       children:[

        StartScreen(isShow: !isRunning,),
        Racket(x: upX, y: -maxY, color: Colors.red),
        Ball(x: ballX, y: ballY),
        Racket(x: downX, y: maxY, color: Colors.black),
       ],
      )
    ),));
  }
}