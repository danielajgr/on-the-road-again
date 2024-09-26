import 'dart:math' as math;

import 'package:flutter_application_1/widgets/obstacle.dart';

class GameState {
  GameState(this.rows, this.columns) {
    carPos = math.Point<int>(columns ~/ 2, rows - 2); 
    initLines();
  }

  int rows;
  int columns;
  late math.Point<int> carPos;

  List<math.Point<int>> alllines = [];

  void moveCar(int amount) {
    final newPosx = carPos.x + amount;
    if (newPosx >= 0 && newPosx < columns) {
      carPos = math.Point<int>(newPosx, carPos.y);
    }
  }

  void step(math.Point<int>? newDirection) {
    if (newDirection != null) {
      moveCar(newDirection.x);
    }
    moveLines(); 
  }

  void initLines() {
    for (int i = 0; i < rows; i += 4) {
      alllines.add(math.Point<int>(columns ~/ 2, i)); 
    }
  }

  void moveLines(){
    for(int i = 0; i < alllines.length; i++){
      alllines[i] = alllines[i] = math.Point<int>((alllines[i].x+ 1) % rows, alllines[i].y);
    }
  }
}
