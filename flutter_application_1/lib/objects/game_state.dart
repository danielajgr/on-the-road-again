import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/obstacle.dart';

class GameState {
  GameState(this.rows, this.columns, this.onGameOver) {
    carPos = math.Point<int>(columns ~/ 2, rows - 2);
    initLines();
    createObstacles();
    startObstacleMovement();
  }

  int rows;
  int columns;
  late math.Point<int> carPos;
  final VoidCallback onGameOver;

  List<math.Point<int>> alllines = [];
  List<Obstacle> obstacles = [];
  Timer? obstacleTimer;

  void createObstacles() {
    for (int i = 0; i < 5; i++) {
      obstacles.add(
        Obstacle(
            type: 'test',
            hitbox: Rect.fromLTWH(
              50.0 * i,
              0,
              50.0,
              50.0,
            ),
            color: (Color.fromARGB(197, 255, 0, 0))),
      );
    }
  }

  void moveCar(int amount) {
    final newPosx = carPos.x + amount;
    if (newPosx >= 0 && newPosx < columns) {
      carPos = math.Point<int>(newPosx, carPos.y);
    }
    checkIfHit();
  }

  void moveObstacles() {
    for (Obstacle obstacle in obstacles) {
      final newTop =
          obstacle.hitbox.top + 10.0; // Move down 10 units every step

      obstacle.hitbox =
          obstacle.hitbox.translate(0, 10.0); // Move hbox down 10 units

      if (newTop > rows * 10) {
        // If obstacle goes off-screen reset to the top, fix the reset
        resetObstacles();
        obstacle.hitbox = Rect.fromLTWH(
          math.Random().nextDouble() * (columns * 10.0),
          0,
          obstacle.hitbox.width,
          obstacle.hitbox.height,
        );
      }
    }
  }

  void resetObstacles() {
    double width = 600;
    double obstacleWidth = 50.0;

    for (Obstacle obstacle in obstacles) {
      obstacle.hit = false;

      // Randomly position the obstacle at the top of the road
      double x = (math.Random().nextDouble() * (width - obstacleWidth));
      obstacle.hitbox = Rect.fromLTWH(x, 0, obstacleWidth, obstacleWidth);
    }
  }

  void checkIfHit() {
    for (Obstacle obstacle in obstacles) {
      Offset carOffset = Offset(carPos.x * 10.0, carPos.y * 10.0);

      if (obstacle.hitbox.contains(carOffset)) {
        obstacle.onCollision();
        if (obstacle.checkHit()) {
          onGameOver();
        }
      }
    }
  }

  void startObstacleMovement() {
    obstacleTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      moveObstacles();
      checkIfHit();
    });
  }

  void step(math.Point<int>? newDirection) {
    if (newDirection != null) {
      moveCar(newDirection.x);
    }
    moveLines();
    checkIfHit();
  }

  void initLines() {
    for (int i = 0; i < rows; i += 4) {
      alllines.add(math.Point<int>(columns ~/ 2, i));
    }
  }

  void moveLines() {
    for (int i = 0; i < alllines.length; i++) {
      alllines[i] = alllines[i] =
          math.Point<int>((alllines[i].x + 1) % rows, alllines[i].y);
    }
  }
}
