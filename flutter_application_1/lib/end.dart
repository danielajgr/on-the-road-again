import 'package:flutter/material.dart';
import 'main.dart'; 

import 'package:flutter/services.dart'; 

class EndPage extends StatelessWidget {
  const EndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(
          child: 
          Text(
            'You Lost!!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 60,
              color: Color.fromARGB(255, 157, 38, 30),
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your Score was: ',
              style: TextStyle(fontSize: 50),
            ),
            const Text(
              'Do you want to go play again?',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // back to the main page
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Arkansas')),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text('Yes'),
                ),
                const SizedBox(width: 20), 
                ElevatedButton(
                  onPressed: () {
                    // Close the app
                    SystemNavigator.pop();
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}