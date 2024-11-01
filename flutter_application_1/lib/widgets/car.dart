import 'dart:async';
import 'dart:ui' as ui; 

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/objects/game_state.dart';
import 'package:flutter_application_1/widgets/obstacle.dart';

class Car extends StatefulWidget {
  final int rows;
  final int columns;
  final double cellSize;
  final double yAxis;
  final GameState state;

  Car(
      {Key? key,
      required this.state,
      required this.rows,
      required this.columns,
      required this.cellSize,
      required this.yAxis})
      : super(key: key);

  @override
  // State<StatefulWidget> createState() => CarState(rows, columns, cellSize);
  State<StatefulWidget> createState() => CarState();
}

class CarState extends State<Car> {
  
  // GameState? state;
  // double cellSize;
  late Timer _timer;

  // CarState(int rows, int columns, this.cellSize) {
  //   print("Rebuilding car thing!");
  //   // state = GameState(rows, columns, gameOver);
  //   state = GameState(rows, columns, () {});
  // }

  // void checkIfHit() {
  //   Offset carOffset =
  //       Offset(state!.carPos.x * cellSize, state!.carPos.y * cellSize);
  //   Obstacle? obstacle = state?.obstacle;
  //
  //   if (obstacle != null && obstacle.hitbox.contains(carOffset)) {
  //     obstacle.onCollision();
  //     if (obstacle.checkHit()) {
  //       gameOver();
  //     }
  //   }
  // }
  //
  // void gameOver() {
  //   Navigator.pushNamed(context, '/end');
  // }

  @override
  void initState() {
    super.initState();


    print("Creating a new timer!");
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        print("Moving car from within car widget!");
        _moveCar();
      });
    });
    widget.state.carTimer = _timer;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _moveCar() {
    int direction = -widget.yAxis.sign.toInt();
    widget.state.moveCar(direction);
    // checkIfHit();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CarPainter(widget.state, widget.cellSize),
    );
  }
}



class CarPainter extends CustomPainter {
  final GameState? state;
  final double cellSize;

  CarPainter(this.state, this.cellSize);

  void paintCar(Canvas canvas, Size size) {
    final carPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final roadLineColor = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    /*
    final obstaclePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    */
    final carPos = state!.carPos;
    final a = Offset(carPos.x * cellSize, carPos.y * cellSize);
    final b = Offset((carPos.x + 1) * cellSize, (carPos.y + 1) * cellSize);

    canvas.drawRect(Rect.fromPoints(a, b), carPaint);

    canvas.drawRect(
        Rect.fromPoints(size.topCenter(b), size.topCenter(a)), roadLineColor);
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
