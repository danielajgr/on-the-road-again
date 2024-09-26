// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:core';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/objects/game_state.dart';
import 'package:sensors_plus/sensors_plus.dart';
class Car extends StatefulWidget{
  Car({Key? key, this.rows = 20, this.columns = 20, this.cellSize = 10.0})
      : super(key: key) {
    assert(10 <= rows);
    assert(10 <= columns);
    assert(5.0 <= cellSize);
  }

  final int rows;
  final int columns;
  final double cellSize;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => CarState(rows, columns, cellSize);
}

class CarPainter extends CustomPainter {
  CarPainter(this.state, this.cellSize);

  GameState? state;
  double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final blackLine = Paint()..color = Colors.black;
    final blackFilled = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, size.bottomLeft(Offset.zero)),
      blackLine,
    );
    for (final p in state!.body) {
      final a = Offset(cellSize * p.x, cellSize * p.y);
      final b = Offset(cellSize * (p.x + 1), cellSize * (p.y + 1));

      canvas.drawRect(Rect.fromPoints(a, b), blackFilled);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


class CarState extends State<Car> {
  CarState(int rows, int columns, this.cellSize) {
    state = GameState(rows, columns); 
  }

  double cellSize;
  GameState? state;
  AccelerometerEvent? acceleration;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;
  late Timer _timer;
  CarPainter? carPainter; 

  @override
  void initState() {
    super.initState();
    
    carPainter = CarPainter(state, cellSize); 
    

    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acceleration = event;
      });
    });

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _step();
        
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    _timer.cancel();
  }

  void _step() {
    final newDirection = acceleration == null
        ? null
        : (acceleration!.x.abs() < 1.0)
            ? null
            : math.Point<int>(-acceleration!.x.sign.toInt(), 0);
    state!.moveCar(newDirection?.x ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: carPainter);
  }


}
