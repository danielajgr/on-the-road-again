import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/obstacle.dart';
import 'useful_things.dart';

class GameState {
  GameState(this.rows, this.columns, this.onGameOver) {
    carPos = doublePoint(x: (columns ~/ 2).toDouble(), y: rows - 2);
    spawnLine();
    createObstacle();
    startObstacleMovement();
  }

  int rows;
  int columns;
  double roadSpeed = 10;
  late doublePoint carPos;
  final VoidCallback onGameOver;

  List<doublePoint> alllines = [];
  Obstacle? obstacle;
  Timer? obstacleTimer;
  Timer? carTimer;

  void createObstacle() {
    obstacle = Obstacle(
      type: 'test',
      hitbox: const Rect.fromLTWH(
        50.0,
        0,
        50.0,
        50.0,
      ),
      color: (Color.fromARGB(197, 255, 0, 0)),
    );
  }

  void cancelTimers() {
    obstacleTimer?.cancel();
    carTimer?.cancel();
  }

  void moveCar(int amount, int deltaT) {
    print(amount * (deltaT/1000));
    final newPosx = carPos.x + amount * (deltaT/1000);
    if (newPosx >= 0 && newPosx < columns) {
      carPos = doublePoint(x: newPosx, y: carPos.y);
    }
    checkIfHit();
  }

  void moveObstacle() {
    if (obstacle != null) {
      final newTop = obstacle!.hitbox.top + 10.0;

      obstacle!.hitbox = obstacle!.hitbox.translate(0, 10.0);

      if (newTop > rows * 10) {
        resetObstacle();
      }
    }
  }

  void resetObstacle() {
    if (obstacle != null) {
      //road width
      double width = 600;
      //obstacle width
      double obstacleWidth = 50.0;

      obstacle!.hit = false;

      // Randomly position the obstacle at the top of the road
      double x = math.Random().nextDouble() * (width - obstacleWidth);
      obstacle!.hitbox = Rect.fromLTWH(x, 0, obstacleWidth, obstacleWidth);
    }
  }

  void checkIfHit() {
    if (obstacle != null) {
      Offset carOffset = Offset(carPos.x * 10.0, carPos.y * 10.0);

      // Check if car hit the obstacle
      if (obstacle!.hitbox.contains(carOffset)) {
        onGameOver();
      }
    }
  }

  void startObstacleMovement() {
    obstacleTimer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      moveObstacle();
      checkIfHit();
    });
  }

  void spawnLine() {
    alllines.add(doublePoint(x:290, y: -200));
  }

  void moveLines() {
    for (int i = 0; i < alllines.length; i++) {
      double newY = (alllines[i].y + roadSpeed).toDouble();
      if(newY > 350)
        alllines.removeAt(i);
      else
        alllines[i] = doublePoint(x: alllines[i].x, y : newY);
    }
  }
}