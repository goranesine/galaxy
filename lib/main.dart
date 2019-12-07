import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

void main() => runApp(MaterialApp(
      home: Galaxy(),
    ));

class Galaxy extends StatefulWidget {
  @override
  _GalaxyState createState() => _GalaxyState();
}

class _GalaxyState extends State<Galaxy>  {
  double _angle;
  double angleDelta;
  double _radius = -550;
  double shipSize = 550;

  void shipRadius() {
    Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      setState(() {
        _radius == 0 ? _radius = -550 : _radius++;
        shipSize == 0 ? shipSize = 550 : shipSize--;
      });
    });
  }

  void clock() {
    Timer.periodic(Duration(milliseconds: 20), (Timer t) {
      setState(() {
        _angle == 360 ? _angle = 0 : _angle++;
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
              radius: _radius - 90,
              angle: angleDelta * 3.142 / 90,
              child:
                  Transform.rotate(angle: _angle, child: _circle(shipSize / 2)),
            ),
          ),
          Positioned(
            left: _width / 2 - 20,
            top: _height / 2 - 20,
            child: MyRadialPosition(
              radius: _radius,
              angle: angleDelta * 3.142 / 70,
              child:
                  Transform.rotate(angle: _angle, child: _starr(shipSize / 4)),
            ),
          ),
          Positioned(
            left: _width / 2 - 20,
            top: _height / 2 - 20,
            child: MyRadialPosition(
              radius: _radius,
              angle: angleDelta * 3.142 / 60,
              child: Transform.rotate(
                  angle: _angle, child: _triangle(shipSize / 4)),
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

Widget _circle(double _size) {
  return Container(
    width: _size,
    height: _size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey,
    ),
  );
}

Widget _starr(double shipSize) {
  return ClipPath(
    clipper: StarClipper(5),
    child: Container(
      width: shipSize,
      height: shipSize,
      color: Colors.amber,
    ),
  );
}

Widget _triangle(double shipSize) {
  return ClipPath(
      clipper: TriangleClipper(),
      child: Container(
        width: shipSize,
        height: shipSize,
        color: Colors.blueAccent,
      ));
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
