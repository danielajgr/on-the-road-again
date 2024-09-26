import 'package:flutter/material.dart';
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
  PointCounter pointCounter = PointCounter();
  int points = 0;

  void startPoints() {
    pointCounter.reset();
    pointCounter.start();
  }

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
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
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
          if (bushOffset >= 525) {
            bushOffset = 0;
          }
        });
      }
    });
    //timer for updating point display
    Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      if (mounted) {
        setState(() {
          points = pointCounter.getPoints();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    pointCounter.stop();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

//game scene
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Page'),
        automaticallyImplyLeading: false, // get rid of back button
      ),
      body: Container(
        color: Colors.green,
        child: Center(
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

                  //yellow rects
                  child: Stack(
                    children: [
                      SizedBox(
                        height: _carRows * _carCellSize,
                        width: _carColumns * _carCellSize,
                        child: Car(
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
                        top: lineOffset - 200,
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
                        top: bushOffset - 200,
                        left: 400,
                        child: Circle(),
                      ),
                      Positioned(
                        top: bushOffset - 400,
                        left: 400,
                        child: Circle(),
                      ),
                      Positioned(
                        top: bushOffset - 600,
                        left: 50,
                        child: Circle(),
                      ),
                      Positioned(
                        top: bushOffset - 800,
                        left: 50,
                        child: Circle(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //test button to go to end.dart
              ElevatedButton(
                //if obstacle.checkHit() = true then end, if not then continue
                onPressed: () {
                  Navigator.pushNamed(context, '/end', arguments: pointCounter);
                },
                child: const Text('End'),
              ),
              const SizedBox(height: 20),
              // Display the points below the button
              Text(
                'Point Score: $points',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
        ),
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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 35, 59, 35),
      ),
    );
  }
}
