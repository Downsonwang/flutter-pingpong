

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
  

  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
enum Direction {
  Up,
  Down,
  Left,
  Right,
}
class _MyHomePageState extends State<MyHomePage> {
 
  int scoreUp = 0;
  int scoreDown = 0;
    // 设置小球的初始坐标为屏幕中心的位置
 
  double ballX =0;
  double ballY = 0;
  // 记录班子 x轴坐标
  double upX = 0;
  double downX = 0;

 // 开始游戏后 消除文字
    bool isRunning = false;
    Direction direction = Direction.Down;
    Direction hDirection = Direction.Right;
    late Timer timer;
 

  start(){
    setState(() {
      isRunning = true;
    });
   timer =  Timer.periodic(Duration(milliseconds: 20), (timer) { 
      double newBallY = ballY;
      double newBallX = ballX;
      double newUpx = upX;
      double newDownx = downX;
      // 球的位置是不是已经小于最下面或者超出最上面
      Direction newDirection = direction;
      Direction newHDirection = hDirection;
      switch (direction) {
        case Direction.Up:
        newBallY -= ballStep;
        
        setState(() {
          
        });
        break;
        case Direction.Down:
         newBallY += ballStep;
         setState(() {
           
         });
       
        break;
        default: 
      }

      switch (hDirection) {
        case Direction.Left:
         newBallX -= ballStep *2;
         break;
        case Direction.Right:
        newBallX += ballStep * 2;
         break;
        default:
      }

      final rocketLen = 2 / 3;

      if(newBallY <= -maxY ){
         if(newBallX < (upX - rocketLen / 2) || newBallX > (upX + rocketLen / 2) ){
          setState(() {
            isRunning = false;
          });
          timer.cancel();
         }
           if  (newBallX > (upX - rocketLen/2) && newBallX < (upX + rocketLen/2)){
              scoreUp++;
             
           }
            newDirection = Direction.Down;

      } else if(newBallY >= maxY) {
        if(newBallX < (downX - rocketLen/2) || newBallX > (downX + rocketLen/2) ){
          setState(() {
            isRunning = false;
          });
               timer.cancel();
         }

         if (newBallX > (downX - rocketLen/2) && newBallX < (downX + rocketLen/2)){
         scoreDown++;
         }
        newDirection = Direction.Up;
      

      }

         if(newBallX <= -1 ){
        newHDirection = Direction.Right;
      } else if(newBallX >= 1) {
        newHDirection = Direction.Left;
      }
     
   
      setState(() {
      scoreUp = scoreUp;
      scoreDown = scoreDown;
      ballY = newBallY;
      ballX = newBallX;
      direction = newDirection;
      hDirection = newHDirection;

    });
    });
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.white,
      body: RawKeyboardListener(focusNode: FocusNode(), autofocus: true,onKey: (event) {
        // down 键盘
        if(event.runtimeType == RawKeyDownEvent && direction == Direction.Up){
          switch (event.logicalKey.keyLabel) {
            case "Arrow Left":
               setState(() {
                 upX = upX - step;
                 
               });
               break;
            case  "Arrow Right":
            setState(() {
                 upX = upX + step;
                
               });
               break;
            default:
          }
        }else if (event.runtimeType == RawKeyDownEvent && direction == Direction.Down){
           switch (event.logicalKey.keyLabel) {
            case "Arrow Left":
               setState(() {
               
                 downX = downX - step;
               });
               break;
            case  "Arrow Right":
            setState(() {
               
                 downX = downX + step;
               });
               break;
            default:
          }
        
        }
          upX = upX.clamp(-1, 1);
          downX = downX.clamp(-1, 1);
          setState(() {
            upX = upX;
            downX = downX;
          });
      }, 
      child: GestureDetector(
        onTap: () {
          start();
        },
      child:  Stack(
       children:[

        StartScreen(isShow: !isRunning,),
        
        Racket(x: upX, y: -maxY, color: Colors.red),
        Positioned(
            right: 0, // 假设 racketWidth 是球拍的宽度
            child: Text('Score: $scoreUp', style: TextStyle(fontSize: 24))), 
         Ball(x: ballX, y: ballY),
        Racket(x: downX, y: maxY, color: Colors.black),
              Positioned(
            left: 0,bottom: 0, // 假设 racketWidth 是球拍的宽度
            child: Text('Score: $scoreDown', style: TextStyle(fontSize: 24))),

        
       ],
      )
    ),));
  }
}