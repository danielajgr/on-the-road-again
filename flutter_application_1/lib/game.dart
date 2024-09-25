import 'package:flutter/material.dart';
import 'end.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Page'),
        automaticallyImplyLeading: false, // get rid of  back button
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
                  width: 500, 
                  color: const Color.fromARGB(255, 68, 68, 68), 
    
                ),
              ),
              const SizedBox(height: 20), 
              //test button to go to end.dart
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
}