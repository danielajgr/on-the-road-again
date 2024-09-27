import 'package:flutter/material.dart';
import 'game.dart';
import 'end.dart'; // Import the EndPage
import 'package:sensors_plus/sensors_plus.dart';

// Found landscape orientation here: https://www.geeksforgeeks.org/flutter-managing-device-orientation/
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 17, 184, 255)),
        useMaterial3: true,
      ),
      //Where the pages take you
      routes: {
        '/': (context) => const MyHomePage(title: 'Arkansas'),
        '/game': (context) => const GamePage(),
        '/end': (context) => const EndPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 60,
                  color: Color.fromARGB(255, 157, 38, 30),
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 10,
              child: Container(
                width: 40,
                height: 40,
                color: Colors.yellow,
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '7',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          '2024',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'On the Road',
              style: TextStyle(
                fontSize: 70,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Again!!!',
              style: TextStyle(
                fontSize: 70,
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // go to game screen
                Navigator.pushNamed(context, '/game');
              },
              child: const Text('Play'),
            ),
            const Text(
              'The Natural State',
              style: TextStyle(
                fontSize: 40,
                color: Color.fromARGB(255, 157, 38, 30),
                fontFamily: 'Times New Roman',
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
