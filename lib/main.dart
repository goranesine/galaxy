import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MaterialApp(
      home: Galaxy(),
    ));

class Galaxy extends StatefulWidget {
  @override
  _GalaxyState createState() => _GalaxyState();
}

class _GalaxyState extends State<Galaxy> with SingleTickerProviderStateMixin {
  double _angle;
  AnimationController _fireController;
  double shipPositionX = 0;
  double shipPositionY = 0;
  double angleDelta;
  double _radius = -550;

  void shipRadius() {
    Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      setState(() {
        _radius == 0 ? _radius = -550 : _radius++;
        print(_radius);
      });
    });
  }

  void clock() {
    Timer.periodic(Duration(milliseconds: 20), (Timer t) {
      setState(() {
        _angle == 360 ? _angle = 0 : _angle++;

        print(_radius);
        angleDelta++;
      });
    });
  }

  @override
  void initState() {
    angleDelta = -90.0;

    _angle = 0;
    clock();
    shipRadius();
    _fireController = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: Duration(milliseconds: 7200),
    )
      ..addListener(() {
        this.setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _fireController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _fireController.forward();
        }
      });
    _fireController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          CustomPaint(
            size: Size(_width, _height),
            painter: Stars(),
          ),
          Positioned(
              top: _height / 2 - 100,
              left: _width / 2 - 100,
              child: blackHole(_angle)),
          Positioned(
            left: _width / 2 - 20,
            top: _height / 2 - 20,
            child: MyRadialPosition(
              radius: _radius,
              angle: angleDelta * 3.142 / 180.0,

              /// Gesture Detector
              child: _ship(_fireController, _angle),
            ),
          ),
        ],
      )),
    );
  }
}

Widget blackHole(double _angle) {
  return Transform.rotate(
    angle: _angle,
    alignment: Alignment.center,
    child: Transform(
      transform: Matrix4.identity()
        ..setEntry(1, 1, 1)
        ..rotateX(3.14 / 3.0),
      alignment: FractionalOffset.center,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          boxShadow: [
            BoxShadow(
                color: Colors.red,
                blurRadius: 5.0,
                offset: Offset(10.0, 0.0),
                spreadRadius: 5.0)
          ],
        ),
      ),
    ),
  );
}

Widget _ship(AnimationController _controller, double _angle) {
  return AnimatedBuilder(
    animation:
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    builder: (context, child) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform.rotate(
              angle: _angle,
              child: _buildContainer(300 * _controller.value, _controller)),
          //_buildContainer(200 * _controller.value, _controller),
          //_buildContainer(300 * _controller.value, _controller),
          //_buildContainer(400 * _controller.value, _controller),
          //_buildContainer(500 * _controller.value, _controller),
          Align(child: Container()),
        ],
      );
    },
  );
}

Widget _buildContainer(double radius, AnimationController _controller) {
  return Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.redAccent.shade700.withOpacity(1 - _controller.value),
    ),
  );
}

class Stars extends CustomPainter {
  Random _random = Random();
  int i = 0;

  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.points;
    double starSize = _random.nextInt(10).toDouble();

    final points = [
      Offset(_random.nextInt(size.width.round()).toDouble(),
          _random.nextInt(size.height.round()).toDouble()),
      // Offset(
      // 150, 75),
      // Offset(
      //   250, 250),
      //Offset(
      // 130, 200),
      // Offset(
      //      270, 100),
    ];
    void draw(double _strokeWidth) {
      final paint = Paint()
        ..color = Colors.white
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawPoints(pointMode, points, paint);
    }

    while (i < 10) {
      draw(starSize);
      i++;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

class MyRadialPosition extends StatelessWidget {
  final double radius;
  final double angle;
  final Widget child;

  MyRadialPosition({this.radius, this.angle, this.child});

  @override
  Widget build(BuildContext context) {
    final x = radius * cos(angle);
    final y = radius * sin(angle);
    return new Transform(
      transform: new Matrix4.translationValues(x, y, 0.0),
      child: child,
    );
  }
}
