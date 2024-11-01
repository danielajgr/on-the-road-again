import 'package:flutter/material.dart';
import 'package:flutter_application_1/objects/game_state.dart';
import 'package:flutter_application_1/widgets/car.dart';
import 'package:flutter_application_1/widgets/pointCounter.dart';
import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late GameState gameState;
  PointCounter pointCounter = PointCounter();
  int points = 0;

  double lineOffset = 0;
  double bushOffset = 0;
  Timer? _timer;
  static const int _carRows = 30;
  static const int _carColumns = 50;
  static const double _carCellSize = 10.0;

  double _yAxis = 0.0;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

//median controller
  @override
  void initState() {
    super.initState();
    startPoints();
    gameState = GameState(30, 50, handleGameOver);
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            print("Setting state of GamePage");
            _yAxis = event.y;
          });
        },
      ),
    );
    _timer = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      if (mounted) {
        setState(() {
          lineOffset += 10;
          bushOffset += 10;

          if (lineOffset >= 325) {
            lineOffset = 0;
          }
          if (bushOffset >= 1000) {
            bushOffset = 0;
          }
        });
      }
    });
    // if (gameState.obstacle?.checkHit() == true) {
    //   handleGameOver();
    // }
  }

  //end game
  void handleGameOver() {
    pointCounter.stop();
    if(mounted) {
      Navigator.pushNamed(context, '/end', arguments: pointCounter);
    } else {
      print("GamePage wasn't mounted when handleGameOver was called? Did we forget to stop a timer?");
    }
    cleanup();
  }

  void startPoints() {
    pointCounter.reset();
    pointCounter.start();
  }

  void cleanup() {
    gameState.cancelTimers();

    _timer?.cancel();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void dispose() {
    cleanup();
    super.dispose();
  }

//game scene
  @override
  Widget build(BuildContext context) {
    print("Rebuilding GamePage");
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.green),
          Positioned(
            top: bushOffset - 600,
            left: 40,
            child: Circle(),
          ),
          Positioned(
            top: bushOffset - 1200,
            left: 40,
            child: Circle(),
          ),
          Positioned(
            top: bushOffset - 600,
            left: 800,
            child: Circle(),
          ),
          Positioned(
            top: bushOffset - 1200,
            left: 800,
            child: Circle(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // road
                Expanded(
                  child: Container(
                    width: 600,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 68, 68, 68),
                      //add borders
                      border: Border(
                        left: BorderSide(width: 10.0, color: Colors.black),
                        right: BorderSide(width: 10.0, color: Colors.black),
                        bottom: BorderSide(width: 10.0, color: Colors.black),
                      ),
                    ),
                    //sort out brackets and parentheses
                    child: Stack(
                      children: [
                        SizedBox(
                          height: _carRows * _carCellSize,
                          width: _carColumns * _carCellSize,
                          child: Car(
                            state: gameState,
                            rows: _carRows,
                            columns: _carColumns,
                            cellSize: _carCellSize,
                            yAxis: _yAxis,
                          ),
                        ),
                        Positioned(
                          top: lineOffset,
                          left: 290, //
                          child: _buildLine(),
                        ),
                        Positioned(
                          top: lineOffset - 210,
                          left: 290,
                          child: _buildLine(),
                        ),
                        Positioned(
                          top: lineOffset - 400,
                          left: 290,
                          child: _buildLine(),
                        ),
                        Positioned(
                          top: lineOffset - 600,
                          left: 290,
                          child: _buildLine(),
                        ),
                        Positioned(
                          top: lineOffset - 800,
                          left: 290,
                          child: _buildLine(),
                        ),
                        Positioned(
                            top: gameState.obstacle?.hitbox.top,
                            left: gameState.obstacle?.hitbox.left,
                            child: Container(
                              width: gameState.obstacle?.hitbox.width,
                              height: gameState.obstacle?.hitbox.height,
                              color: gameState.obstacle?.color,
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //test button to go to end.dart
                ElevatedButton(
                  //handle obstacle
                  onPressed: () {
                    handleGameOver();
                  },
                  child: const Text('End'),
                ),
                // Display the points below the button
                Text(
                  'Point Score: $points',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // create a yellow median
  Widget _buildLine() {
    return Container(
      width: 20,
      height: 100,
      color: Colors.yellow,
    );
  }

  //create a bush
  Widget Circle() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 35, 59, 35),
      ),
    );
  }
}
