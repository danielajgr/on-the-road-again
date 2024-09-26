import 'dart:math' as math;

import 'package:flutter_application_1/widgets/obstacle.dart';

class GameState {
  GameState(this.rows, this.columns) {
    carPos = math.Point<int>(columns ~/ 2, rows ~/ 2);
  }

  int rows;
  int columns;
  late math.Point<int> carPos;

  List<math.Point<int>> body = <math.Point<int>>[const math.Point<int>(0, 0)];
  math.Point<int> direction = const math.Point<int>(1, 0);

  void moveCar(int amount) {
    final newPosx = carPos.x + amount;
    void moveCar(int amount) {
      final newPosx = carPos.x + amount;
      if (newPosx >= 0 && newPosx < columns) {
        carPos = math.Point<int>(newPosx, carPos.y);
      }
    }

    void step(math.Point<int>? newDirection) {
      if (newDirection != null) {
        moveCar(newDirection.x ?? 0);
      }
    }
  }
}
