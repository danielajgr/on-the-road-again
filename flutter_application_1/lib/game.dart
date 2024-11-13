import 'package:flutter/material.dart';
import 'package:flutter_application_1/objects/game_state.dart';
import 'package:flutter_application_1/widgets/car.dart';
import 'package:flutter_application_1/widgets/obstacle.dart';
import 'package:flutter_application_1/widgets/pointCounter.dart';
import 'dart:async';
import 'objects/useful_things.dart';
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
  late Timer _lineSpawnTimer;
  late Timer _obSpawnTimer;
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
            _yAxis = event.y;
          });
        },
      ),
    );
    _obSpawnTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        gameState.createObstacle();
      });
    });
    _lineSpawnTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      setState(() {
        gameState.spawnLine();
      });
    });
    _timer = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      if (mounted) {
        setState(() {
          gameState.moveLines();
          bushOffset += 10;
          if (bushOffset >= 1000) {
            bushOffset = 0;
          }
        });
      }
    });
  }

  //end game
  void handleGameOver() {
    pointCounter.stop();
    if (mounted) {
      Navigator.pushNamed(context, '/end', arguments: pointCounter);
    }
    cleanup();
  }

  void startPoints() {
    pointCounter.reset();
    pointCounter.start();
  }

  void cleanup() {
    gameState.cancelTimers();
    _lineSpawnTimer.cancel();
    _obSpawnTimer.cancel();
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

  List<Widget> getLines() {
    List<Widget> finalList = [];
    List<doublePoint> points = gameState.alllines;
    for(doublePoint point in points) {
      finalList.add(                        
    Positioned(
          top: point.y,
          left: point.x, //
          child: _buildLine(),
        ),
      );
    }
    
    return finalList;
  }

//game scene
  @override
  Widget build(BuildContext context) {
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
                        for(Widget line in getLines())
                          line,
                        // Positioned(
                        //   top: lineOffset,
                        //   left: 290, //
                        //   child: _buildLine(),
                        // ),
                        // Positioned(
                        //   top: lineOffset - 210,
                        //   left: 290,
                        //   child: _buildLine(),
                        // ),
                        // Positioned(
                        //   top: lineOffset - 400,
                        //   left: 290,
                        //   child: _buildLine(),
                        // ),
                        // Positioned(
                        //   top: lineOffset - 600,
                        //   left: 290,
                        //   child: _buildLine(),
                        // ),
                        // Positioned(
                        //   top: lineOffset - 800,
                        //   left: 290,
                        //   child: _buildLine(),
                        // ),
                        for(Obstacle obstacle in [gameState.obstacle!])
                          Positioned(
                              top: obstacle.hitbox.top,
                              left: obstacle.hitbox.left,
                              child: Container(
                                width: obstacle.hitbox.width,
                                height: obstacle.hitbox.height,
                                color: obstacle.color,
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
