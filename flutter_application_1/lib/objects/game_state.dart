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
  List<Obstacle> obstacles = [];
  Timer? obstacleTimer;
  Timer? carTimer;

  void createObstacle() {
    obstacles.add(Obstacle(
        type: 'test',
        hitbox: const Rect.fromLTWH(
          50.0,
          0,
          50.0,
          50.0,
        ),
        color: (Color.fromARGB(197, 255, 0, 0)),
    ));
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
    print("Game_State.dart car pos: ${carPos}");
    checkIfHit();
  }

  void moveObstacles() {
    for(int i = 0; i < obstacles.length; i++) {
      Obstacle obstacle = obstacles[i];
      final newTop = obstacle.hitbox.top + roadSpeed;

      obstacle.hitbox = obstacle.hitbox.translate(0, roadSpeed);
      checkIfHit();
      if (newTop > rows * 10) {
        resetObstacle(obstacle);
      }
    }
  }

  void resetObstacle(Obstacle obstacle) {
    double width = 600;
    //obstacle width
    double obstacleWidth = 50.0;

    obstacle.hit = false;

    // Randomly position the obstacle at the top of the road
    double x = math.Random().nextDouble() * (width - obstacleWidth);
    obstacle.hitbox = Rect.fromLTWH(x, 0, obstacleWidth, obstacleWidth);
  }

  void checkIfHit() {
    for(Obstacle obstacle in obstacles) {
      Offset carOffset = Offset(carPos.x * 10, carPos.y * 10);
      print("Car offset: $carOffset");

      // Check if car hit the obstacle
      if (obstacle.hitbox.contains(carOffset) || obstacle.hitbox.contains(Offset((carPos.x + 1) * 10, (carPos.y + 10) * 10))) {
        onGameOver();
      }
    }
  }

  void startObstacleMovement() {
    obstacleTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      moveObstacles();
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