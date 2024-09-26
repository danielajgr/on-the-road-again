import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/objects/game_state.dart';

class Car extends StatefulWidget {
  final int rows;
  final int columns;
  final double cellSize;
  final double yAxis;

  Car({Key? key, required this.rows, required this.columns, required this.cellSize, required this.yAxis})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => CarState(rows, columns, cellSize);
}

class CarState extends State<Car> {
  GameState? state;
  double cellSize;
  late Timer _timer;

  CarState(int rows, int columns, this.cellSize) {
    state = GameState(rows, columns); 
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _moveCar();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _moveCar() {
    int direction = -widget.yAxis.sign.toInt(); 
    state!.moveCar(direction);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CarPainter(state, cellSize), 
    );
  }
}

class CarPainter extends CustomPainter {
  final GameState? state;
  final double cellSize;

  CarPainter(this.state, this.cellSize);

  @override
  void paintCar(Canvas canvas, Size size) {
    final carPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final roadLineColor = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    

    final carPos = state!.carPos;
    final a = Offset(carPos.x * cellSize, carPos.y * cellSize);
    final b = Offset((carPos.x + 1) * cellSize, (carPos.y + 1) * cellSize);

    canvas.drawRect(Rect.fromPoints(a, b), carPaint);

    canvas.drawRect(Rect.fromPoints(size.topCenter(b),size.topCenter(a) ), roadLineColor);

  }

  @override
  void paint(Canvas canvas, Size size) {
    final carPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    
    

    final carPos = state!.carPos;
    final a = Offset(carPos.x * cellSize, carPos.y * cellSize);
    final b = Offset((carPos.x + 1) * cellSize, (carPos.y + 1) * cellSize);
    canvas.drawRect(Rect.fromPoints(a, b), carPaint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
