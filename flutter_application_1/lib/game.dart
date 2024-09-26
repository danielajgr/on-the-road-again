import 'package:flutter/material.dart';
import 'dart:async';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double lineOffset = 0;
  Timer? _timer; 


//median controller
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      if (mounted) { 
        setState(() {
          lineOffset += 10;
          if (lineOffset >= 200) {
            lineOffset = 0; 
          }
        });
      }
    });
  }

//handle set state eorr when game restarts
  @override
  void dispose() {
    _timer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 600, 
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 68, 68, 68), 
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/end');
                },
                child: const Text('End'),
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
}