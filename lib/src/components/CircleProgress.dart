import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mangoHub/src/shared/Colors.dart';

class CircleProgress extends CustomPainter {
  double currentProgress;
  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 8
      ..color = mangoOrange
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 10
      ..color = (currentProgress == 100) ? mangoOrange : mangoBlue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    // double radius = min(size.width/2,size.height/2) - 20;
    double radius = min(40, 40);

    canvas.drawCircle(
        center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircleProgressObj extends StatefulWidget {
  @override
  _CircleProgressObjState createState() => _CircleProgressObjState();
}

class _CircleProgressObjState extends State<CircleProgressObj> with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation<double> animation;
  int skipCount=0;
  bool skipState=false;

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(vsync: this,duration: Duration(milliseconds: 5000));
    animation = Tween<double>(begin: 0.0,end: 100.0).animate(progressController)..addListener((){
      setState(() {});
    });
  }

  void _restartAnimation() {
    progressController.value = 0.0;
    setState(() {
      // animation = _generateCharacterPosition();
      progressController.forward();
    });
  }

  Animation _generateCharacterPosition() => new FractionalOffsetTween().animate(new CurvedAnimation(
    parent: progressController,
    curve: Curves.easeOut,
  ));


  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: CircleProgress(animation.value), // this will add custom painter after child
      child: GestureDetector(
        child: ClipRRect(
          borderRadius:BorderRadius.circular(100) ,
                
          child: Container(
            height: 100,
            width: 100,
            color: Colors.white,
            child: Center(
                child: (animation.value==100.0)?Icon(Icons.refresh, size: 60,color: mangoBlue,):Text("${animation.value.toInt()}",style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),)),
          ),
        ),
        onTap: (){


          if(animation.value == 100){
            _restartAnimation();
            skipState=false;
            skipCount++;
            print(skipCount);

          }else {
            progressController.forward();
          }

          print("press");
        },
      ),
    );
  }
}


